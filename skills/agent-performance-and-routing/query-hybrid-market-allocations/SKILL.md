# Query: hybrid_market_allocations_approved

## Table
`premier_agent.agent_gold.hybrid_market_allocations_approved`

## Purpose
The primary allocations table and backbone of the entire application. Contains ZIP-level agent allocation data including buyer/seller program splits, capacity thresholds, and estimated connections per effective date. Nearly every page and API endpoint reads from this table.

## Columns Used

| Column | Type | Description |
|--------|------|-------------|
| `effective_date` | STRING | Allocation effective date (YYYY-MM-DD format). Some rows contain slash-formatted dates that must be filtered out with `NOT LIKE '%/%'`. |
| `zip` | STRING | 5-digit ZIP code |
| `msa` | STRING | MSA name (fallback when dim_zip_mapping has no match) |
| `parent_zuid` | STRING/BIGINT | Team lead ZUID (always cast to STRING for joins and frontend display) |
| `agent_zuid` | STRING/BIGINT | Individual agent ZUID |
| `agent_zip_allocated_cxn` | DOUBLE | Allocated connections for an agent in a ZIP. Always SUM'd and ROUND'd to 0 decimal places. |
| `cap_threshold` | DOUBLE | Capacity threshold for a ZIP. Always MAX'd at ZIP level to avoid double-counting. |
| `estimatedconnections` | DOUBLE | Estimated connections for a ZIP |
| `allocation_program` | STRING | Program type: `'buyer'` or `'seller'`. Buyer is the primary focus — most queries filter to buyer only. |

## Common Filters

```sql
-- Latest effective date (excluding slash-formatted dates)
WHERE effective_date = (
  SELECT MAX(effective_date)
  FROM premier_agent.agent_gold.hybrid_market_allocations_approved
  WHERE effective_date NOT LIKE '%/%'
)

-- Date range filter (for trend queries)
WHERE effective_date >= '2024-01-01'
  AND effective_date NOT LIKE '%/%'

-- Buyer program only (used in almost all queries)
AND allocation_program = 'buyer'

-- Filter by team
AND CAST(parent_zuid AS STRING) = :team_id
```

## Common Aggregation Patterns

### ZIP-level CTE (deduplicate before MSA-level rollup)
```sql
WITH zip_level AS (
  SELECT
    effective_date,
    zip,
    msa,
    MAX(cap_threshold) as zip_cap,
    ROUND(SUM(agent_zip_allocated_cxn), 0) as zip_allocated_all,
    ROUND(SUM(CASE WHEN allocation_program = 'buyer' THEN agent_zip_allocated_cxn ELSE 0 END), 0) as zip_allocated_buyer
  FROM premier_agent.agent_gold.hybrid_market_allocations_approved
  WHERE effective_date >= '2024-01-01'
    AND effective_date NOT LIKE '%/%'
  GROUP BY effective_date, zip, msa
)
```

### Team-level aggregation
```sql
SELECT
  CAST(parent_zuid AS STRING) AS parent_zuid,
  ROUND(SUM(agent_zip_allocated_cxn), 0) AS allocated_cxn,
  ROUND(SUM(estimatedconnections), 0) AS estimated_cxn,
  COUNT(DISTINCT agent_zuid) AS agents,
  COUNT(DISTINCT zip) AS zips,
  COUNT(DISTINCT msa) AS msas
FROM premier_agent.agent_gold.hybrid_market_allocations_approved
WHERE effective_date = (...)
  AND allocation_program = 'buyer'
GROUP BY parent_zuid
```

### Team breakdown by ZIP
```sql
SELECT
  msa, zip,
  ROUND(SUM(agent_zip_allocated_cxn), 0) AS allocated_cxn,
  ROUND(SUM(estimatedconnections), 0) AS estimated_cxn,
  COUNT(DISTINCT agent_zuid) AS agents
FROM premier_agent.agent_gold.hybrid_market_allocations_approved
WHERE effective_date = (...)
  AND CAST(parent_zuid AS STRING) = :team_id
  AND allocation_program = 'buyer'
GROUP BY msa, zip
```

## Common Joins

- **dim_zip_mapping**: `LEFT JOIN enterprise.conformed_dimension.dim_zip_mapping zm ON a.zip = zm.zipcode` — to get `msa_regionid` and canonical `msa` name. Used in MSA-level aggregations.

## Cross-Table Relationships
This table is the "hub" of the data model. Other tables enrich its data:
- `dim_flex_agents` adds team names, manager names, rep info (joined via `parent_zuid` ↔ `team_lead_zuid`)
- `recommended_agent_connection_targets` provides capacity (joined via `parent_zuid` ↔ `team_lead_zuid`)
- `partner_metrics_monthly` provides performance ratings (joined via `parent_zuid` ↔ `team_zuid`)
- `preferred_partner_segmentation_v4` provides partner segment labels (joined via `parent_zuid` ↔ `team_zuid`)
- `rom_zuid_map` provides ROM names (joined via `parent_zuid` ↔ `zuid`)
- `dim_zip_mapping` provides MSA geography (joined via `zip` ↔ `zipcode`)

## Frontend Data Flow

### Dashboard Page (`/` → `client/src/pages/dashboard.tsx`)
- **Summary cards**: `/api/allocations/summary` returns time-series data (total_cap, total_allocated_cxn, total_unallocated_cxn, unique_teams, unique_zips, unique_msas) displayed as `StatCard` components with month-over-month change indicators.
- **Top MSAs bar chart**: `/api/allocations/top-msas` returns top 15 MSAs by allocated_cxn, rendered as a Recharts `BarChart`.
- **Unallocated trend chart**: `/api/allocations/unallocated-trend` returns the unallocated CXN trend, rendered as a Recharts `AreaChart` with allocation rate overlay.
- **Forecast trend chart**: `/api/allocations/forecast-trend` appears alongside allocation data.
- **Snapshot modal**: `/api/allocations/snapshot` returns a flat array of all teams with allocated_cxn as the core metric, displayed in a full-width table with inline editing of overrides. The snapshot is the primary planning view — it merges allocation data with enrichment from 7 other tables/queries.
- **Simulation modal**: `/api/allocations/simulation` compares simulation runs against forecasts at MSA level. The simulation modal has tabs: "AOP Forecast by MSA", "Results by Team", "Fill Rate by Performance", and "Missing Team Flags".

### Teams Page (`/teams` → `client/src/pages/teams.tsx`)
- **Team list**: `/api/allocations/teams` returns team-level aggregation enriched with names, performance, and capacity. Rendered as a sortable, searchable card grid. Each team card shows: allocated_cxn, estimated_cxn, team_capacity, agents, zips, msas, trx_bucket, zhl_bucket.
- **Team detail panel** (modal): When a team is clicked, three tabs load:
  - **Allocation History** (`/api/allocations/team-history/:teamId`): Up to 52 periods of history rendered as area chart + month-over-month change table with automated "why did allocations change" insights.
  - **Competitors** (`/api/allocations/team-competitors/:teamId`): Teams sharing ZIPs with this team.
  - **OHR & Performance** (`/api/allocations/team-snapshot/:teamId`): Health and metric history.
- **Team chat box**: A built-in Q&A feature (`analyzeTeamQuestion`) analyzes team data client-side. It uses history data to answer questions like "why did allocations drop?" by computing agent impact (~15 CXNs per agent), zip changes, capacity changes, OHR shifts, and performance bucket changes.

### Unallocated Page (`/unallocated` → `client/src/pages/unallocated.tsx`)
- **MSA map**: `/api/allocations/unallocated-detail` returns per-MSA breakdown (cap_cxn, allocated_cxn, unallocated_cxn, teams, zips). Rendered as a `react-simple-maps` USA map with bubble markers sized by unallocated CXN and colored by allocation rate (red <25%, orange 25-50%, yellow 50-75%, green 75%+).
- **MSA team drill-down**: When a bubble is clicked, `/api/allocations/msa-teams/:msaRegionId` loads teams in that MSA with their capacity headroom.
- **Date selector**: Users can switch between effective dates using a dropdown populated from the unallocated-trend data.

## Backend Transformation Details
- Numeric columns are parsed from string arrays (`result.result.data_array`) via `parseFloat()`. String columns like `effective_date`, `msa`, `zip`, `parent_zuid` are kept as-is.
- Enrichment from other tables is merged in-memory via `Map<string, Record>` lookups keyed by `parent_zuid`.
- The `/api/allocations/teams` endpoint runs 4 parallel Databricks queries and merges results server-side.
- The `/api/allocations/snapshot` endpoint runs 8 parallel queries and is the most data-intensive endpoint.

## Used In (API Endpoints)
- `/api/allocations/summary` — trend of total allocations over time
- `/api/allocations/top-msas` — top MSAs by allocated connections
- `/api/allocations/unallocated-detail` — unallocated capacity by MSA
- `/api/allocations/unallocated-trend` — trend of unallocated capacity
- `/api/allocations/teams` — team-level allocation summary
- `/api/allocations/team-breakdown/:teamId` — ZIP detail for a team
- `/api/allocations/msa-teams/:msaRegionId` — teams in an MSA
- `/api/allocations/team-history/:teamId` — allocation history for a team
- `/api/allocations/team-competitors/:teamId` — competitors sharing ZIPs
- `/api/allocations/forecast` — team-ZIP mapping for forecast overlay
- `/api/allocations/snapshot` — full snapshot for planning view
