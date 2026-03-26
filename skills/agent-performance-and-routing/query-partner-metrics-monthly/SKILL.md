# Query: partner_metrics_monthly

## Table
`premier_agent.agent_gold.partner_metrics_monthly`

## Purpose
Monthly performance metrics per team. Serves three critical roles:
1. **Performance bucketing** — TRX ratio and ZHL ratings determine team performance badges
2. **Team snapshot history** — 12 months of detailed metrics for the Health & Performance tab
3. **Primary MSA lookup** — the canonical source for a team's primary MSA

## Columns Used

| Column | Type | Description |
|--------|------|-------------|
| `team_zuid` | BIGINT | Team ZUID (cast to STRING for joins; maps to `parent_zuid`) |
| `data_month` | DATE/STRING | Month of the data record |
| `primary_msa` | STRING | Team's primary MSA (used for geographic association) |
| `l6m_trx_target` | DOUBLE | Last 6-month transaction target |
| `l6m_logged_trx` | DOUBLE | Last 6-month logged transactions |
| `monthly_trx_target` | DOUBLE | Monthly transaction target |
| `monthly_logged_trx` | DOUBLE | Monthly logged transactions |
| `csat` | DOUBLE | Customer satisfaction score |
| `wwr` | DOUBLE | Win/win rate |
| `closed` | DOUBLE | Closed transactions |
| `pendingtrans` | DOUBLE | Pending transactions |
| `zhl_pre_approval_target_rating` | STRING | ZHL pre-approval target rating (e.g., "Exceptional", "High") |
| `zhl_pre_approval_target_rating_last_3m` | STRING | ZHL rating over last 3 months |
| `current_active_team_members` | DOUBLE | Current active team member count |
| `allocated_cxns` | DOUBLE | Allocated connections (from this table's perspective) |

## Performance Bucketing Logic (Critical Business Rule)
The TRX and ZHL performance ratings are the primary quality indicators. The bucketing logic runs in the backend but the bucket labels/colors are interpreted in the frontend:

### TRX Bucket (computed from l6m ratio)
```
ratio = l6m_logged_trx / l6m_trx_target
>= 1.25 → "Exceptional"
>= 1.0  → "High"
>= 0.75 → "Fair"
< 0.75  → "Low"
```

### Combined Performance Label
The snapshot endpoint produces a combined string: `"{trxBucket}-{zhlBucket}"` (e.g., "High-High", "Fair-Low", "Exceptional-none").

### Frontend Badge Color Logic (`dashboard.tsx`)
The `getPerfBadge()` function maps combined labels to colors:
- **Green**: high-high, fair-high, high-fair, exceptional-high, exceptional-fair, exceptional-exceptional
- **Red**: low-low, fair-low, low-fair, low-none
- **Amber**: everything else (e.g., fair-fair, high-low)
- **Purple**: "New" (when no performance data exists)

### Frontend Badge Color Logic (`teams.tsx`)
The `getBucketColor()` function maps individual TRX buckets:
- **Exceptional**: violet
- **High**: green
- **Fair**: amber
- **Low**: red
- **New**: blue (when `time_in_preferred` is "< 3 months")

## Common Query Patterns

### TRX and ZHL as separate CTEs (used in teams, competitors, snapshot, simulation)
```sql
WITH trx AS (
  SELECT
    CAST(team_zuid AS STRING) AS parent_zuid,
    l6m_trx_target,
    l6m_logged_trx
  FROM premier_agent.agent_gold.partner_metrics_monthly
  WHERE data_month = (
    SELECT MAX(data_month)
    FROM premier_agent.agent_gold.partner_metrics_monthly
    WHERE l6m_trx_target IS NOT NULL
  )
    AND team_zuid IS NOT NULL
    AND l6m_trx_target IS NOT NULL
),
zhl AS (
  SELECT
    CAST(team_zuid AS STRING) AS parent_zuid,
    zhl_pre_approval_target_rating
  FROM premier_agent.agent_gold.partner_metrics_monthly
  WHERE data_month = (
    SELECT MAX(data_month)
    FROM premier_agent.agent_gold.partner_metrics_monthly
    WHERE zhl_pre_approval_target_rating IS NOT NULL
  )
    AND team_zuid IS NOT NULL
    AND zhl_pre_approval_target_rating IS NOT NULL
)
SELECT t.parent_zuid, t.l6m_trx_target, t.l6m_logged_trx, z.zhl_pre_approval_target_rating
FROM trx t LEFT JOIN zhl z ON t.parent_zuid = z.parent_zuid
```

### Team snapshot history (last 12 months)
```sql
SELECT
  CAST(data_month AS STRING) as data_month,
  current_active_team_members, allocated_cxns,
  l6m_trx_target, l6m_logged_trx,
  monthly_trx_target, monthly_logged_trx,
  csat, wwr, closed, pendingtrans,
  zhl_pre_approval_target_rating,
  zhl_pre_approval_target_rating_last_3m
FROM premier_agent.agent_gold.partner_metrics_monthly
WHERE CAST(team_zuid AS STRING) = :team_id
  AND data_month <= date_trunc('month', CURRENT_DATE)
ORDER BY data_month DESC
LIMIT 12
```

### Primary MSA lookup (enrichment subquery)
```sql
SELECT CAST(team_zuid AS STRING) AS team_zuid, primary_msa
FROM premier_agent.agent_gold.partner_metrics_monthly
WHERE data_month = (
  SELECT MAX(data_month)
  FROM premier_agent.agent_gold.partner_metrics_monthly
  WHERE primary_msa IS NOT NULL
)
  AND team_zuid IS NOT NULL
```

## Frontend Data Flow

### Teams Page — Team Detail Panel — Health & Performance Tab
Renders a 12-month history table with columns:
- data_month, current_active_team_members, allocated_cxns
- l6m_trx_target, l6m_logged_trx (used to compute per-month TRX ratio)
- monthly_trx_target, monthly_logged_trx
- csat, wwr, closed, pendingtrans
- zhl_pre_approval_target_rating, zhl_pre_approval_target_rating_last_3m

### Teams Page — Team Detail Panel — History Tab
Performance data is cross-referenced with allocation history to generate "Why did allocations change?" insights. When TRX bucket changes between months, an insight like "Trx performance: Fair → High" is generated.

### Teams Page — Team Chat Box
The `analyzeTeamQuestion` function uses performance data to answer questions like "What's our performance?" — it reports the TRX ratio, bucket, ZHL rating, and closed transactions.

### Dashboard — Snapshot Modal
Each team row shows a performance badge computed from the combined TRX-ZHL label.

### Dashboard — Simulation Modal — Fill Rate by Performance Tab
Groups simulation results by performance bucket to show fill rate distribution.

## Key Notes
- TRX and ZHL use **separate** latest dates because one may have data more recently than the other.
- The `primary_msa` column has its own latest date subquery (filtered where `primary_msa IS NOT NULL`).
- `data_month` format may include timestamps — the frontend strips them with `.split("T")[0]` or `.split(" ")[0]`.

## Used In (API Endpoints)
- `/api/allocations/teams` — performance bucketing + primary MSA
- `/api/allocations/msa-teams/:msaRegionId` — primary MSA enrichment
- `/api/allocations/team-snapshot/:teamId` — 12-month performance history
- `/api/allocations/team-competitors/:teamId` — competitor performance
- `/api/allocations/snapshot` — performance + primary MSA for planning
- `/api/allocations/simulation/fill-by-team` — performance for simulation teams
