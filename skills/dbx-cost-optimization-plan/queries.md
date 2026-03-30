# Cost Optimization SQL Queries and Conventions

## Base CTE

Reuse this CTE in every query. Replace `<START_DATE>` with the resolved `start_date` parameter.

```sql
with base as (
  SELECT
    workday_employee.manager_name,
    CASE
      WHEN workday_employee.has_direct_reports = 'Yes' THEN workday_employee.PREFERRED_NAME
      ELSE workday_employee.manager_name
    END AS cost_attributed_manager_name,
    workday_employee.PREFERRED_NAME AS employee_name,
    workday_employee.has_direct_reports,
    usage_cost_aggr.*
  FROM
    data_platform.cost_governance_data_silver.usage_cost_aggr
      LEFT JOIN data_platform.platform_zodiac_api_silver.teams
        ON teams.team_name = usage_cost_aggr.team
      LEFT JOIN engineering.engineering_metrics_silver.workday_employee
        ON (
          CASE
            WHEN usage_cost_aggr.user LIKE '%@zillowgroup.com' THEN usage_cost_aggr.user
            ELSE CONCAT(teams.owner_user_login, '@zillowgroup.com')
          END = workday_employee.PRIMARYWORKEMAIL
        )
  WHERE usage_date >= date '<START_DATE>'
  AND usage_date < current_date()
)
```

---

## Q1 — Monthly Cost Trend by Workspace and SKU

**Purpose:** Identify which environment and compute type drives the most spend over time.

```sql
<BASE_CTE>
SELECT
  date_trunc('month', usage_date) AS usage_month,
  workspace_name,
  sku_name,
  round(sum(usage_cost), 2) AS total_cost
FROM base
WHERE (team = '<TEAM>' OR cost_attributed_manager_name = '<MANAGER>')
  AND workspace_name IN (<WORKSPACES_LIST>)
  <EMPLOYEE_FILTER>
GROUP BY 1, 2, 3
ORDER BY 1 DESC, 4 DESC
```

---

## Q2 — Cost by Employee

**Purpose:** Identify which engineers drive the most cost and whether spend is concentrated.

```sql
<BASE_CTE>
SELECT
  cost_attributed_manager_name,
  employee_name,
  workspace_name,
  sku_name,
  round(sum(usage_cost), 2) AS total_cost
FROM base
WHERE (team = '<TEAM>' OR cost_attributed_manager_name = '<MANAGER>')
  AND workspace_name IN (<WORKSPACES_LIST>)
  <EMPLOYEE_FILTER>
GROUP BY 1, 2, 3, 4
ORDER BY 5 DESC
LIMIT 50
```

---

## Q3 — Top 20 Most Expensive Jobs

**Purpose:** Identify specific jobs consuming the most budget — primary input for all phases.

```sql
<BASE_CTE>
SELECT
  workspace_name,
  job_name,
  sku_name,
  employee_name,
  cost_attributed_manager_name,
  round(sum(usage_cost), 2) AS total_cost
FROM base
WHERE (team = '<TEAM>' OR cost_attributed_manager_name = '<MANAGER>')
  AND workspace_name IN (<WORKSPACES_LIST>)
  AND job_name IS NOT NULL
  <EMPLOYEE_FILTER>
GROUP BY 1, 2, 3, 4, 5
ORDER BY 6 DESC
LIMIT 20
```

---

## Q4 — Job Frequency and Cost-Per-Run Analysis

**Purpose:** Distinguish jobs that are expensive because they run frequently vs expensive per individual run.

```sql
<BASE_CTE>
SELECT
  workspace_name,
  job_name,
  sku_name,
  employee_name,
  count(distinct usage_date)                                                           AS active_days,
  round(sum(usage_cost), 2)                                                            AS total_cost,
  round(sum(usage_cost) / nullif(count(distinct usage_date), 0), 4)                   AS avg_daily_cost,
  round(sum(usage_cost) / nullif(count(distinct date_trunc('month', usage_date)), 0), 2) AS avg_monthly_cost
FROM base
WHERE (team = '<TEAM>' OR cost_attributed_manager_name = '<MANAGER>')
  AND workspace_name IN (<WORKSPACES_LIST>)
  AND job_name IS NOT NULL
  <EMPLOYEE_FILTER>
GROUP BY 1, 2, 3, 4
ORDER BY total_cost DESC
LIMIT 30
```

---

## Job Classification Rules

Apply these rules when labeling jobs from Q3 and Q4 results:

| Rule | Condition | Phase |
|---|---|---|
| 1 | Job workspace is `enterprise-data-lab` or `enterprise-data-stage` | Phase 1 |
| 2 | Job name contains `dev`, `test`, `lab`, `tmp`, `temp`, `poc`, `backfill`, `sandbox`, `wip`, `explore`, `analysis` | Phase 1 (even if in prod) |
| 3 | SKU = `SERVERLESS SQL COMPUTE` | Phase 2 |
| 4 | SKU = `JOBS SERVERLESS COMPUTE` on `enterprise-data-prod` only | Phase 3 |

**Concentration flag:** if top 3 jobs account for >50% of total cost, call it out — the team can achieve outsized savings by addressing just those jobs.

**Unattributed cost:** if `job_name` is null or generic, note as "unattributed cost" and flag for investigation separately.

**Frequency signal (Q4):**
- `active_days` >20 in a 30-day window on Lab/Stage → top pause candidate (Phase 1)
- High `total_cost` but low `avg_daily_cost` → scheduling optimization candidate
- High `avg_daily_cost` but low `active_days` → ad-hoc/one-off, lower priority

---

## Warehouse Sizing Guide (Phase 2)

| Size | DBU/Hr | Use case |
|---|---|---|
| `XSmall` | 6 | Ad-hoc exploration, infrequent queries, low concurrency |
| `Small` | 12 | Daily scheduled jobs, moderate concurrency |
| `Medium` | 24 | High-concurrency dashboards, frequent intra-day queries — justify if kept |

---

## Output Format

### Executive Summary

2–3 sentences: total cost for the analysis window, biggest cost driver (SKU + workspace), estimated total savings.

---

### Phase 1 — Lower Environment Quick Wins (Lab / Stage)

**Target:** `JOBS SERVERLESS COMPUTE` + `JOBS COMPUTE` on `enterprise-data-lab` / `enterprise-data-stage`
**Action:** Pause or delete idle dev/test jobs. Zero production risk.
**Benchmark:** EDW team achieved 86% Lab cost reduction through Phase 1 job pausing (Nov → Jan 2026).

| Job Name | Workspace | SKU | Employee | Total Cost ($) | Active Days | Action | Est. Savings |
|---|---|---|---|---|---|---|---|

**Effort:** Low | **Priority:** High

---

### Phase 2 — SQL Serverless Compute Right-Sizing

**Target:** `SERVERLESS SQL COMPUTE` across all workspaces
**Action:** Downgrade warehouse sizes; isolate frequent/daily/weekend workloads into separate smaller warehouses.
**Benchmark:** ~20% cost reduction estimated from warehouse right-sizing.

| Job Name | Workspace | Employee | Total Cost ($) | Current Pattern | Recommended Action | Est. Savings |
|---|---|---|---|---|---|---|

**Effort:** Medium | **Priority:** Medium

---

### Phase 3 — Jobs Serverless Performance Optimization Flags (Optional)

**Target:** `JOBS SERVERLESS COMPUTE` in `enterprise-data-prod`
**Action:** Disable the serverless "performance optimized" feature on non-SLA-bound batch jobs to reduce per-DBU cost.

Disable criteria:
- Non-SLA-bound batch job (latency insensitive)
- Fewer than 10 active days in the analysis window
- No known failure history that the optimization flag helps prevent

| Job Name | Employee | Total Cost ($) | Avg Daily Cost ($) | Active Days | Recommendation |
|---|---|---|---|---|---|

**Effort:** Low-Medium | **Priority:** Optional

---

### Savings Summary

| Phase | Focus Area | Est. Savings ($) | Est. Savings (%) | Effort | Priority |
|---|---|---|---|---|---|
| Phase 1 | Lab/Stage job pausing | $X | Y% | Low | High |
| Phase 2 | SQL warehouse right-sizing | $X | ~20% | Medium | Medium |
| Phase 3 | Serverless perf-opt flags | $X | TBD | Low-Medium | Optional |
| **Total** | | **$X** | **Y%** | | |

Derive all dollar amounts from query results. If an estimate differs significantly from the benchmarks, note why.

---

### Next Actions (Ordered by ROI)

List 5–7 concrete steps, highest-ROI/lowest-effort first. Each must include:
- Specific job(s) to act on
- Employee to contact
- Suggested timeline: this week / this sprint / this quarter
