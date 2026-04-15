# dbx-cost-optimization-analysis – Reference

## Cost Governance Tables (Zillow)

| Table | Purpose |
|-------|---------|
| `usage_cost_aggr` | **Job compute costs** – aggregated cluster/job usage by service, job, warehouse, date |
| `dbsql_cost_per_query` | **SQL warehouse costs** – per-query cost (DBU, dollars, duration). Primary source for dbt and SQL task spend. |
| `all_job_run_details` | Job metadata (job_id, job_name, service, team) – used to join dbsql to job names |
| `aws_costs_aggr` | **AWS costs** – aggregated AWS spend attributed by `team` and date (`ds`); use `SUM(cost)` for totals. Complements Databricks usage (does not replace it). |

**Use all three** cost families for a full picture: `usage_cost_aggr` (job compute), `dbsql_cost_per_query` (SQL warehouse, often job-attributed via join), and `aws_costs_aggr` (AWS). For dbt/SQL-heavy projects, warehouse costs from `dbsql_cost_per_query` often dominate **Databricks** bill lines; AWS adds **non-Databricks** or cross-cloud line items tagged to the same `team`.

## Job Compute Cost Query (Service-Based)

Filter by `team` and optionally `service` to scope to project pipelines:

```sql
WITH monthly_usage AS (
  SELECT
    date(usage_date) AS usage_date,
    service,
    user,
    job_name,
    warehouse_name,
    SUM(usage_cost) AS usage_cost
  FROM data_platform.cost_governance_data_silver.usage_cost_aggr
  WHERE team IN ('big-data-pade', 'data-management', 'zhl-eventhub')
    AND date(usage_date) > date_add(current_date(), -90)
  -- Add: AND service = 'tdw-zhl-dw' for project-specific
  GROUP BY date(usage_date), service, user, job_name, warehouse_name
)
SELECT
  usage_date,
  usage_cost,
  service,
  job_name,
  warehouse_name,
  concat(coalesce(service,''), '__', coalesce(job_name,''), '__', coalesce(warehouse_name,'')) AS job_identifier
FROM monthly_usage
ORDER BY usage_date DESC, usage_cost DESC
```

## SQL Warehouse Cost Query (dbsql_cost_per_query)

Restrict `warehouse_id` to project-defined warehouses from `databricks.yml`. Filter by project job names via join to `all_job_run_details`. This is a **primary** cost source for dbt and SQL tasks—not secondary to job compute.

```sql
WITH jobs AS (
  SELECT DISTINCT workspace_name, domain_name, service, team, job_name, job_id
  FROM data_platform.cost_governance_data_silver.all_job_run_details
),
job_query_times AS (
  SELECT
    jobs.job_name,
    sqlc.executed_by AS service,
    sqlc.warehouse_id,
    sqlc.warehouse_name,
    date(sqlc.start_time) AS run_date,
    SUM(sqlc.duration_seconds)/360 AS duration_hours,
    SUM(sqlc.query_attributed_dbus_estimation)/360 AS dbu_estimation,
    SUM(sqlc.query_attributed_dollars_estimation) AS dollars_estimation
  FROM data_platform.cost_governance_data_silver.dbsql_cost_per_query sqlc
  LEFT JOIN jobs ON sqlc.query_source_id = jobs.job_id
  WHERE sqlc.warehouse_id IN (
    '6ae43eb46e158417', 'fe62b53194db7a18', 'ca815545c604fb62',
    'bf25bdd305a7b2b7', '679a40df035fafca', '4c1cb67b5816fe7c',
    '4dc6861628e936c7', '31ac391d847a721d', '41d9b0ed14ce3c5e',
    '44f8740e99b74ece', 'ac6ca9297e04e78c', 'dbff1adecc82796e'
  )
  AND date(sqlc.start_time) > date_add(current_date(), -90)
  GROUP BY ALL
)
SELECT * FROM job_query_times
QUALIFY row_number() OVER (PARTITION BY run_date ORDER BY dollars_estimation DESC) <= 50
ORDER BY run_date DESC, dollars_estimation DESC
```

## AWS Cost Query (`aws_costs_aggr`)

**Purpose:** Team-attributed AWS spend from `data_platform.cost_governance_data_silver.aws_costs_aggr`. Filter on `team` and aggregate with `SUM(cost)`. Time grain uses `ds` (date column).

**Example — monthly total for one team** (baseline pattern):

```sql
SELECT
  date_trunc('month', ds),
  SUM(cost) AS usage_cost
FROM data_platform.cost_governance_data_silver.aws_costs_aggr
WHERE team = 'big-data-pade'
GROUP BY 1
```

**Example — AWS as a column by team and month** (multiple teams; use in reports next to Databricks totals):

```sql
SELECT
  team,
  date_trunc('month', ds) AS month,
  SUM(cost) AS aws_cost_usd
FROM data_platform.cost_governance_data_silver.aws_costs_aggr
WHERE team IN ('big-data-pade', 'data-management', 'zhl-eventhub')
GROUP BY team, date_trunc('month', ds)
ORDER BY month DESC, aws_cost_usd DESC
```

**Example — combine with job compute on the same grain** (one row per team × month with **Databricks job compute** and **AWS** as separate columns; adjust date filters as needed):

```sql
WITH job_compute AS (
  SELECT
    team,
    date_trunc('month', usage_date) AS month,
    SUM(usage_cost) AS databricks_job_compute_usd
  FROM data_platform.cost_governance_data_silver.usage_cost_aggr
  WHERE team IN ('big-data-pade', 'data-management', 'zhl-eventhub')
  GROUP BY team, date_trunc('month', usage_date)
),
aws AS (
  SELECT
    team,
    date_trunc('month', ds) AS month,
    SUM(cost) AS aws_cost_usd
  FROM data_platform.cost_governance_data_silver.aws_costs_aggr
  WHERE team IN ('big-data-pade', 'data-management', 'zhl-eventhub')
  GROUP BY team, date_trunc('month', ds)
)
SELECT
  COALESCE(j.team, a.team) AS team,
  COALESCE(j.month, a.month) AS month,
  COALESCE(j.databricks_job_compute_usd, 0) AS databricks_job_compute_usd,
  COALESCE(a.aws_cost_usd, 0) AS aws_cost_usd
FROM job_compute j
FULL OUTER JOIN aws a
  ON j.team = a.team AND j.month = a.month
ORDER BY month DESC, team
```

Add **SQL warehouse** dollars in a fourth column by joining or unioning aggregates from `dbsql_cost_per_query` + `all_job_run_details` on the same `team` and `month` when presenting a full “by team” cost table.

**Notes**

- **Double-counting:** Do not sum `usage_cost_aggr` and overlapping AWS lines for the same underlying resource if your governance model already allocates hybrid spend; treat **AWS** as its own column for **AWS-tagged** `cost` and reconcile definitions with the cost governance team if totals must tie to finance.
- **Daily filters:** Use `date(ds)` (or equivalent) in `WHERE` for a calendar month, e.g. `date(ds) BETWEEN '2026-03-01' AND '2026-03-31'`.

## Usage System Tables (Consumer Patterns)

Use these tables **alongside** lineage and cost to understand who consumes project tables and when. They are important for consumer-based recommendations.

| Table | Purpose |
|-------|---------|
| `system.access.table_lineage` | Read/write events; source/target tables; entity_type, entity_id, statement_id |
| `system.access.audit` | Audit events; `action_name='getTable'` + `request_params['full_name_arg']` = table read; user_identity, event_time |
| `system.query.history` | Query execution; statement_id, executed_by, query_source (job_info, dashboard_id, notebook_id), start_time, read_bytes, total_duration_ms |

### Per-job dbt model cost by day (`job_id` + `query.history` + `dbsql_cost_per_query`)

**Purpose:** For a **single Databricks job** (`job_id` from the job UI or `all_job_run_details`), break down **SQL warehouse** cost and volume **by dbt model** and **by calendar day**. Use this to see which models drive spend on which days and to **prioritize optimization** (incremental, predicates, partitioning) on the highest-`est_sql_dollars` or highest-read models.

**Parameters:** Replace `:job_id` with the numeric/string job id for the dbt job. Adjust the `INTERVAL 10 DAY` window as needed.

**Requirements:** dbt must emit `query_tags` including `@@dbt_model_name` and `@@dbt_materialized` (typical for dbt on Databricks). Only queries tagged as `incremental` or `table` are included—extend the `IN (...)` list if you need `view` or other materializations.

```sql
WITH qh AS (
  SELECT
    query_source.job_info.job_run_id AS job_run_id,
    h.statement_text,
    h.query_tags.`@@dbt_model_name` AS table_name,
    h.query_tags,
    h.statement_id,
    h.start_time,
    h.total_duration_ms,
    h.read_bytes,
    h.read_rows,
    h.written_bytes
  FROM system.query.history h
  WHERE h.start_time >= DATE_TRUNC('DAY', CURRENT_TIMESTAMP()) - INTERVAL 10 DAY
    AND h.query_source.job_info.job_id = :job_id
    AND h.execution_status = 'FINISHED'
    AND h.query_tags.`@@dbt_model_name` IS NOT NULL
    AND h.query_tags.`@@dbt_materialized` IN ('incremental', 'table')
)
SELECT
  table_name,
  DATE(qh.start_time) AS first_seen,
  COUNT(DISTINCT qh.statement_id) AS finished_query_count,
  ROUND(SUM(qh.total_duration_ms) / 1000.0, 2) AS sum_query_duration_sec,
  ROUND(SUM(qh.read_bytes) / POWER(1024, 3), 4) AS read_gib,
  ROUND(SUM(qh.read_rows) / 1e9, 4) AS read_billions_rows,
  ROUND(SUM(COALESCE(d.query_attributed_dollars_estimation, 0)), 4) AS est_sql_dollars,
  ROUND(SUM(COALESCE(d.query_attributed_dbus_estimation, 0)), 4) AS est_sql_dbus,
  ROUND(SUM(COALESCE(d.duration_seconds, 0)), 2) AS dbsql_attributed_duration_sec
FROM qh
LEFT JOIN data_platform.cost_governance_data_silver.dbsql_cost_per_query d
  ON qh.statement_id = d.statement_id
GROUP BY 1, 2
ORDER BY DATE(qh.start_time) DESC;
```

**Interpretation:** Sort or filter by `est_sql_dollars` (and `read_gib`) within a day or across the window to rank models. If `est_sql_dollars` is null for many rows, confirm warehouse cost attribution and that `dbsql_cost_per_query` includes those `statement_id` values.

**Deep dive — pair with project tables, sources, and SQL optimization:** For cost optimization **reports**, do not use this query in isolation. (1) Build the full set of **project output tables** from dbt and **upstream source tables** from lineage (and `sources.yml`). (2) For **each** project job that runs dbt/SQL on a warehouse, run this query with that job’s **`job_id`** to rank models/tables by attributed dollars and read volume. (3) Map high-cost models to their **sources** and investigate **SQL optimization patterns**: partition pruning vs full scan, merge/incremental predicates, join strategy, `cluster_by` alignment with filters, stats, and opportunities to reduce `read_bytes` / `read_rows`. (4) If the project has multiple jobs, repeat per relevant **`job_id`** so every contributor to project spend is covered.

**system.access.audit** – who read which table:
```sql
SELECT user_identity.email, request_params['full_name_arg'] AS table_name, event_time, event_date
FROM system.access.audit
WHERE action_name = 'getTable'
  AND request_params['full_name_arg'] IN ('mortgage.internal.fact_loan', 'mortgage.internal.fact_zhl_lead')
  AND event_date >= date_add(current_date(), -30)
```

**system.query.history** – hour-of-day, day-of-week, consumer type, read volume:
```sql
SELECT
  executed_by,
  CASE WHEN query_source.dashboard_id IS NOT NULL THEN 'dashboard'
       WHEN query_source.job_info.job_id IS NOT NULL THEN 'job'
       ELSE 'ad-hoc' END AS consumer_type,
  hour(start_time) AS hour_of_day,
  dayofweek(start_time) AS day_of_week,
  COUNT(*) AS query_count,
  SUM(total_duration_ms)/1000 AS total_seconds,
  SUM(read_bytes) AS total_read_bytes
FROM system.query.history
WHERE start_time >= date_add(current_date(), -30)
  AND execution_status = 'FINISHED'
GROUP BY executed_by,
         CASE WHEN query_source.dashboard_id IS NOT NULL THEN 'dashboard'
              WHEN query_source.job_info.job_id IS NOT NULL THEN 'job'
              ELSE 'ad-hoc' END,
         hour(start_time), dayofweek(start_time)
```

Join `system.access.table_lineage`.statement_id to `system.query.history`.statement_id to attribute usage to specific project tables.

---

## Lineage Investigation

**Required workflow step.** Run these queries to build a full lineage map for project tables. Combine lineage with audit to handle incomplete lineage.

### 1 – Upstream (sources feeding project tables) – system.access.table_lineage

```sql
-- What feeds into each project table
SELECT
  target_table_full_name AS project_table,
  source_table_full_name,
  source_type,
  entity_type,
  entity_id,
  event_time,
  event_date
FROM system.access.table_lineage
WHERE target_table_full_name IN (
  'mortgage.internal.fact_loan',
  'mortgage.internal.fact_zhl_lead'
  -- ... project tables from dbt
)
AND event_date >= date_add(current_date(), -30)
ORDER BY target_table_full_name, event_time DESC
```

### 2 – Downstream (consumers of project tables) – system.access.table_lineage

```sql
-- What reads each project table
SELECT
  source_table_full_name AS project_table,
  target_table_full_name,
  entity_type,
  entity_id,
  created_by,
  statement_id,
  event_time,
  event_date
FROM system.access.table_lineage
WHERE source_table_full_name IN (
  'mortgage.internal.fact_loan',
  'mortgage.internal.fact_zhl_lead'
  -- ... project tables from dbt
)
AND event_date >= date_add(current_date(), -30)
ORDER BY source_table_full_name, event_time DESC
```

### 3 – Who read project tables – system.access.audit (fills lineage gaps)

```sql
-- Lineage can be incomplete; audit often captures JDBC, dashboards, etc.
SELECT
  request_params['full_name_arg'] AS table_name,
  user_identity.email,
  user_identity.id,
  event_time,
  event_date
FROM system.access.audit
WHERE action_name = 'getTable'
  AND request_params['full_name_arg'] IN (
    'mortgage.internal.fact_loan',
    'mortgage.internal.fact_zhl_lead'
    -- ... project tables from dbt
  )
  AND event_date >= date_add(current_date(), -30)
ORDER BY table_name, event_time DESC
```

### 4 – Combine and analyse

- **Merge** downstream lineage (entity_id, created_by) with audit readers (user_identity) — deduplicate by entity/user.
- **Identify lineage gaps:** tables with no downstream lineage but with audit reads → lineage incomplete.
- **Identify:** high-fanout consumers, critical paths, orphan tables (no consumers).
- **Surface** findings in summary (overview) and report (detailed, with recommendations).

---

## Focused Scope: Input/Output Sizes and Producer/Consumer Patterns

**When `scope=model:<name>` or `scope=job:<name>`**, run this deeper analysis. Use Databricks MCP or Unity Catalog APIs.

### Table size (DESCRIBE DETAIL)

```sql
-- For each upstream and downstream table in scope
DESCRIBE DETAIL mortgage.internal.fact_loan
```

Use `sizeInBytes`, `numFiles`, `numRecords` (if available) for input vs output comparison.

### Input/output volume summary (when scope is set)

```sql
-- Aggregate size per table (requires table list from lineage)
SELECT
  table_catalog,
  table_schema,
  table_name,
  -- Use information_schema or DESCRIBE DETAIL per table
  SUM(size_in_bytes) AS total_bytes
FROM (
  -- For each table: DESCRIBE DETAIL or information_schema.tables
  -- Join lineage upstream (inputs) and downstream (outputs) to get table list
) t
GROUP BY table_catalog, table_schema, table_name
```

**Producer patterns** — who writes inputs (from lineage where target = input table) + audit for `createTable`/write events. **Consumer patterns** — who reads outputs (from lineage where source = output table) + audit `getTable`. Join to `system.query.history` for hour-of-day, day-of-week.

### Producer/consumer hour-of-day (when scope is set)

Use the lineage + audit + query.history joins from the Consumer Patterns section, but filter to tables in scope (inputs and outputs of the scoped model/job). Aggregate by table, entity, hour_of_day, day_of_week.

---

## Consumer Patterns: Lineage + Cost

### Step 1 – Downstream consumers via system.access.table_lineage

```sql
-- Consumers of project tables (source = table being read)
SELECT
  source_table_full_name,
  entity_type,
  entity_id,
  created_by,
  statement_id,
  event_time
FROM system.access.table_lineage
WHERE source_table_full_name IN (
  'mortgage.internal.fact_loan',
  'mortgage.internal.fact_zhl_lead'
  -- ... project tables from dbt catalogs/schemas
)
AND event_date >= date_add(current_date(), -30)
```

### Step 2 – Join to dbsql_cost_per_query for hour-of-day, day-of-week

```sql
WITH lineage AS (
  SELECT source_table_full_name, entity_type, entity_id, created_by, statement_id
  FROM system.access.table_lineage
  WHERE source_table_full_name IN (<project_tables>)
    AND event_date >= date_add(current_date(), -30)
    AND statement_id IS NOT NULL
),
consumer_patterns AS (
  SELECT
    l.source_table_full_name,
    l.entity_type,
    l.entity_id,
    l.created_by,
    hour(sqlc.start_time) AS hour_of_day,
    dayofweek(sqlc.start_time) AS day_of_week,
    COUNT(*) AS query_count,
    SUM(sqlc.query_attributed_dollars_estimation) AS total_dollars,
    SUM(sqlc.duration_seconds) AS total_seconds
  FROM lineage l
  JOIN data_platform.cost_governance_data_silver.dbsql_cost_per_query sqlc
    ON l.statement_id = sqlc.statement_id
  WHERE date(sqlc.start_time) >= date_add(current_date(), -30)
  GROUP BY l.source_table_full_name, l.entity_type, l.entity_id, l.created_by,
           hour(sqlc.start_time), dayofweek(sqlc.start_time)
)
SELECT * FROM consumer_patterns ORDER BY total_dollars DESC
```

**Note:** `system.access.table_lineage` and `system.access.audit` require the `system.access` schema to be enabled in Unity Catalog. `system.query.history` is in `system.query`. If unavailable, consumer analysis will be limited. Use all three when possible for robust recommendations.

## Volume-Based Compute and Worker Type

### Sources Analysis

- **dbt sources:** Inspect `sources.yml`, `ref()` in models. Use `DESCRIBE DETAIL <table>` or `ANALYZE TABLE` for size (numFiles, sizeInBytes, numRows).
- **Lineage:** Join to `system.access.table_lineage` to see read volume. `system.query.history` has `read_bytes`, `read_rows` per query.
- **Volume thresholds:** Large (>100GB, >1B rows) unpartitioned → incremental or partitioning. Small (<1GB) → full refresh may be fine.

### Job Type and Definition (from YAML)

| Task type | Typical worker | Notes |
|-----------|----------------|-------|
| `sql_warehouse_task` | SQL warehouse | Always warehouse |
| `dbt_task` | SQL warehouse | Uses `warehouse_id` from config |
| `notebook_task`, `spark_jar_task`, `python_task` | Job compute cluster | Use `job_cluster_key` or `existing_cluster_id` |
| Mixed (dbt + notebook) | Warehouse + cluster | Each task uses its own compute |

Extract from `databricks.yml` / `resources/*.yml`: `warehouse_id` vs `serverless_sql_id` per target; cluster `node_type_id`, `num_workers`, `autoscale`.

### Cluster Utilization (system.compute.node_timeline + job_task_run_timeline + clusters)

**Scope:** All-purpose and jobs compute only (excludes serverless, SQL warehouses).

**Example – job-level utilization with CPU/memory status and recommendations:**

Replace the team filter in `job_cluster_runs` with project job patterns for project-scoped analysis, e.g. `j.name LIKE 'zhl_data_warehouse%' OR j.name IN (<project_job_names>)`.

```sql
WITH all_task_runs AS (
  SELECT
    t.job_id, t.run_id, t.task_key, t.workspace_id,
    t.compute_ids[0] AS cluster_id,
    DATE_TRUNC('month', t.period_start_time) AS `month`,
    ROW_NUMBER() OVER (PARTITION BY t.task_key, t.job_id, t.workspace_id
      ORDER BY t.period_start_time DESC) AS run_recency
  FROM system.lakeflow.job_task_run_timeline t
  WHERE DATE_TRUNC('month', t.period_start_time) >= ADD_MONTHS(DATE_TRUNC('month', CURRENT_DATE()), -2)
    AND ARRAY_SIZE(t.compute_ids) > 0
),
latest_jobs AS (
  SELECT job_id, workspace_id, name AS job_name, tags,
    ROW_NUMBER() OVER (PARTITION BY workspace_id, job_id ORDER BY change_time DESC) AS rn
  FROM system.lakeflow.jobs WHERE delete_time IS NULL
  QUALIFY rn = 1
),
latest_clusters AS (
  SELECT
    cluster_id, workspace_id, worker_node_type,
    worker_count, min_autoscale_workers, max_autoscale_workers,
    (min_autoscale_workers IS NOT NULL AND max_autoscale_workers IS NOT NULL) AS is_autoscaling,
    (LOWER(COALESCE(dbr_version, '')) LIKE '%photon%') AS photon_enabled,
    ROW_NUMBER() OVER (PARTITION BY workspace_id, cluster_id ORDER BY change_time DESC) AS rn
  FROM system.compute.clusters WHERE cluster_source = 'JOB'
  QUALIFY rn = 1
),
worker_utilization AS (
  SELECT cluster_id,
    ROUND(AVG(cpu_user_percent + cpu_system_percent), 2) AS avg_worker_cpu,
    ROUND(PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY (cpu_user_percent + cpu_system_percent)), 2) AS p90_worker_cpu,
    ROUND(AVG(cpu_wait_percent), 2) AS avg_cpu_wait,
    ROUND(AVG(mem_used_percent), 2) AS avg_worker_mem,
    ROUND(PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY mem_used_percent), 2) AS p90_worker_mem,
    ROUND(AVG(mem_swap_percent), 2) AS avg_swap,
    COUNT(*) AS util_data_points
  FROM system.compute.node_timeline
  WHERE start_time >= ADD_MONTHS(DATE_TRUNC('month', CURRENT_DATE()), -2)
    AND start_time <= DATE_TRUNC('month', CURRENT_DATE())
    AND driver = FALSE
  GROUP BY cluster_id
),
driver_utilization AS (
  SELECT cluster_id,
    ROUND(AVG(cpu_user_percent + cpu_system_percent), 2) AS avg_driver_cpu,
    ROUND(AVG(mem_used_percent), 2) AS avg_driver_mem
  FROM system.compute.node_timeline
  WHERE start_time >= ADD_MONTHS(DATE_TRUNC('month', CURRENT_DATE()), -2)
    AND start_time <= DATE_TRUNC('month', CURRENT_DATE())
    AND driver = TRUE
  GROUP BY cluster_id
),
job_cluster_runs AS (
  SELECT
    j.job_name, COALESCE(j.tags['team'], j.tags['Team']) AS team,
    `month`,
    t.cluster_id, c.worker_node_type, c.is_autoscaling,
    c.min_autoscale_workers, c.max_autoscale_workers,
    COALESCE(c.worker_count, c.max_autoscale_workers) AS max_workers,
    c.photon_enabled
  FROM all_task_runs t
  JOIN latest_jobs j ON t.job_id = j.job_id AND t.workspace_id = j.workspace_id
  LEFT JOIN latest_clusters c ON t.cluster_id = c.cluster_id AND t.workspace_id = c.workspace_id
  WHERE (
    j.tags['team'] IN ('big-data-pade', 'data-management', 'big-data-mde', 'big-data-ncde', 'big-data-zbi')
    OR j.tags['Team'] IN ('big-data-pade', 'data-management', 'big-data-mde', 'big-data-ncde', 'big-data-zbi')
  )
  -- For project-scoped: replace above with e.g. j.job_name LIKE 'zhl_data_warehouse%'
),
job_level_util AS (
  SELECT
    jcr.job_name, `month`, jcr.team, jcr.worker_node_type, jcr.is_autoscaling,
    jcr.min_autoscale_workers, jcr.max_autoscale_workers, jcr.max_workers, jcr.photon_enabled,
    COUNT(DISTINCT jcr.cluster_id) AS runs_with_cluster,
    ROUND(AVG(wu.avg_worker_cpu), 2) AS avg_cpu_across_runs,
    ROUND(AVG(wu.p90_worker_cpu), 2) AS avg_p90_cpu,
    ROUND(AVG(wu.avg_cpu_wait), 2) AS avg_cpu_wait,
    ROUND(AVG(wu.avg_worker_mem), 2) AS avg_mem_across_runs,
    ROUND(AVG(wu.p90_worker_mem), 2) AS avg_p90_mem,
    ROUND(MAX(wu.avg_swap), 2) AS worst_swap,
    ROUND(AVG(du.avg_driver_cpu), 2) AS avg_driver_cpu,
    ROUND(AVG(du.avg_driver_mem), 2) AS avg_driver_mem,
    SUM(CASE WHEN wu.cluster_id IS NOT NULL THEN 1 ELSE 0 END) AS runs_with_util_data,
    COUNT(*) AS total_runs
  FROM job_cluster_runs jcr
  LEFT JOIN worker_utilization wu ON jcr.cluster_id = wu.cluster_id
  LEFT JOIN driver_utilization du ON jcr.cluster_id = du.cluster_id
  GROUP BY ALL
),
final AS (
  SELECT *,
    ROUND(runs_with_util_data * 100.0 / NULLIF(total_runs, 0), 0) AS util_coverage_pct,
    CASE
      WHEN runs_with_util_data = 0 THEN 'NO_DATA'
      WHEN avg_p90_cpu >= 85 THEN 'CPU_UNDER_PROVISIONED'
      WHEN avg_cpu_across_runs < 20 THEN 'CPU_OVER_PROVISIONED'
      WHEN avg_cpu_across_runs BETWEEN 20 AND 70 THEN 'CPU_RIGHT_SIZED'
      ELSE 'CPU_REVIEW'
    END AS cpu_status,
    CASE
      WHEN runs_with_util_data = 0 THEN 'NO_DATA'
      WHEN worst_swap > 5 THEN 'MEM_CRITICAL_SWAPPING'
      WHEN avg_p90_mem >= 85 THEN 'MEM_UNDER_PROVISIONED'
      WHEN avg_mem_across_runs < 20 THEN 'MEM_OVER_PROVISIONED'
      WHEN avg_mem_across_runs BETWEEN 20 AND 70 THEN 'MEM_RIGHT_SIZED'
      ELSE 'MEM_REVIEW'
    END AS mem_status,
    CASE
      WHEN runs_with_util_data = 0 THEN 'No utilization data'
      WHEN worst_swap > 5 THEN 'CRITICAL: Memory swapping — increase instance memory'
      WHEN avg_p90_cpu >= 85 AND avg_p90_mem >= 85 THEN 'Both CPU+Mem saturated — scale up instance type AND workers'
      WHEN avg_p90_cpu >= 85 AND is_autoscaling THEN 'CPU saturated — consider compute-optimized instance (autoscaling handles workers)'
      WHEN avg_p90_cpu >= 85 THEN 'CPU saturated — add workers or compute-optimized instance'
      WHEN avg_p90_mem >= 85 AND is_autoscaling THEN 'Memory saturated — switch to memory-optimized instance'
      WHEN avg_p90_mem >= 85 THEN 'Memory saturated — add workers or memory-optimized instance'
      WHEN avg_cpu_across_runs < 20 AND avg_mem_across_runs < 20 AND is_autoscaling
        THEN 'Instance type oversized — consider smaller instance (autoscaling handles workers)'
      WHEN avg_cpu_across_runs < 20 AND avg_mem_across_runs < 20
        THEN 'Over-provisioned — reduce workers and/or smaller instance'
      ELSE 'Within acceptable range — monitor'
    END AS recommendation
  FROM job_level_util
  WHERE worker_node_type IS NOT NULL
  ORDER BY
    CASE
      WHEN runs_with_util_data = 0 THEN 4
      WHEN worst_swap > 5 OR avg_p90_cpu >= 85 OR avg_p90_mem >= 85 THEN 1
      WHEN avg_cpu_across_runs < 20 AND avg_mem_across_runs < 20 THEN 2
      ELSE 3
    END,
    avg_cpu_across_runs ASC
)
SELECT * FROM final
WHERE (cpu_status != 'NO_DATA' OR mem_status != 'NO_DATA')
```

**Status values:** `CPU_OVER_PROVISIONED` / `CPU_RIGHT_SIZED` / `CPU_UNDER_PROVISIONED` / `NO_DATA`; same for `mem_status`. Use `recommendation` for actionable guidance. **Only recommend changes when utilization data supports it**; quantify estimated savings where possible.

**Note:** Nodes that ran under 10 minutes may not appear.

### Job Run Metrics (system.lakeflow.job_run_timeline, job_task_run_timeline)

**job_run_timeline:** run_id, period_start_time, period_end_time, run_duration_seconds, execution_duration_seconds, setup_duration_seconds, queue_duration_seconds, cleanup_duration_seconds, compute_ids, result_state.

**job_task_run_timeline:** task_key, setup_duration_seconds, execution_duration_seconds, cleanup_duration_seconds, compute_ids.

**Sample – job duration and setup by project jobs:**
```sql
WITH jobs AS (
  SELECT workspace_id, job_id, name FROM system.lakeflow.jobs
  WHERE name LIKE 'zhl_data_warehouse%'  -- project job pattern
  QUALIFY row_number() OVER (PARTITION BY workspace_id, job_id ORDER BY change_time DESC) = 1
),
run_durations AS (
  SELECT workspace_id, job_id, run_id,
    CAST(SUM(unix_timestamp(period_end_time) - unix_timestamp(period_start_time)) AS LONG) AS run_duration_sec,
    MAX(setup_duration_seconds) AS setup_duration_seconds,
    MAX(queue_duration_seconds) AS queue_duration_seconds,
    MAX(execution_duration_seconds) AS execution_duration_seconds
  FROM system.lakeflow.job_run_timeline
  WHERE period_start_time >= current_timestamp() - INTERVAL 30 DAYS
    AND result_state IS NOT NULL
  GROUP BY workspace_id, job_id, run_id
)
SELECT j.name, r.run_id, r.run_duration_sec, r.setup_duration_seconds, r.queue_duration_seconds, r.execution_duration_seconds
FROM run_durations r
JOIN jobs j ON r.workspace_id = j.workspace_id AND r.job_id = j.job_id
ORDER BY r.run_duration_sec DESC
```

Use for: slow-task identification, duration trends, setup/queue optimization (e.g. cluster pools), dbt model changes when runs are long and utilization is low.

**Note:** `system.operational_data.job_runs` is deprecated; use `system.lakeflow.job_run_timeline` and `job_task_run_timeline`.

---

### SQL Warehouse vs Job Compute / Photon – Analyse Before Recommending

**Do not assume** SQL warehouse or Photon is always a cost improvement. Analyse and quantify.

1. **Compare actual costs:** Use `usage_cost_aggr` (job compute) and `dbsql_cost_per_query` (warehouse) for the same job or comparable workloads. If the job already runs on warehouse, switching to cluster is rarely beneficial for SQL.
2. **Estimate when no direct comparison:** For a SQL job on cluster, estimate warehouse cost: `duration_hours × warehouse_DBU_rate × price_per_DBU`. Compare to `usage_cost_aggr.usage_cost` for that job.
3. **Photon:** Evaluate via A/B (Photon on vs off) or pilot. Compare `query_attributed_dollars_estimation`, `duration_seconds` for the same queries. Photon helps many but not all workloads.
4. **Quantify benefit:** Only recommend a switch when you can state an estimated delta (e.g. “~$X/day savings” or “Y% lower cost”). If no data, recommend a **pilot** rather than a blind switch.

### Serverless vs Non-Serverless SQL Warehouse

| Factor | Prefer serverless | Prefer provisioned |
|--------|-------------------|---------------------|
| Schedule | Sparse (daily, hourly, few runs/day) | Very frequent (e.g. every 15 min, 24/7) |
| Run pattern | Bursty, intermittent | Long, sustained, predictable |
| Idle time | High (warehouse idle between runs) | Low (warehouse always busy) |
| Startup tolerance | OK (seconds to start) | Need minimal startup |
| Query concurrency | Variable, many short queries | Steady, fewer longer queries |

**Validate with cost data:** Compare `dbsql_cost_per_query` by `warehouse_id` for project warehouses. If serverless cost is high vs provisioned for the same job, consider switching.

### Instance Type (Job Compute)

| Workload | Instance family |
|----------|-----------------|
| ETL, streaming, maintenance | Compute optimized |
| Heavy shuffle, ML, large joins | Memory optimized |
| Interactive, ad-hoc, caching | Storage optimized |
| General | General purpose |

---

## dbt Incremental Strategy Decision Guide

| Scenario | Strategy | Rationale |
|----------|----------|-----------|
| Append-only, no updates | append | Lowest cost, no merge scan |
| Updates by key, small target | merge | SCD1; ensure unique_key is reliable |
| Large target, date-partitioned | insert_overwrite | Replace partitions only |
| Large time-series, batch processing | microbatch | Parallel batches by event_time |
| unique_key not unique / merge unsupported | delete+insert | Full replace for matched keys |
| Need to limit target scan | merge + incremental_predicates | Reduces merge cost |

## Extracting Project Metadata

From `databricks.yml`:
- `var.zodiac_service` → service tag for cost filtering
- `var.zodiac_team` → team tag
- `var.serverless_sql_id`, `var.warehouse_id` per target → warehouse IDs for SQL cost queries

From job YAML:
- `Service: ${var.zodiac_service}` – used for cost attribution
- `warehouse_id: ${var.serverless_sql_id}` – SQL task warehouse

## GitLab MR vs Cost Correlation

To detect which changes might have caused cost spikes:

1. **Fetch merge history:** `git log --merges --format="%H %ad %s" --date=short -90` to get merge commits and dates.
2. **Aggregate daily cost:** Combine **Databricks** sources: (a) `usage_cost_aggr.usage_cost` by date for project jobs; (b) `SUM(query_attributed_dollars_estimation)` from `dbsql_cost_per_query` by `date(start_time)` for project warehouses/jobs. Total daily Databricks-oriented cost = job compute + warehouse. Optionally add **`aws_costs_aggr`** by `date(ds)` and `team` as a separate series or column so MR correlation can spot infra/AWS shifts alongside DBU spend.
3. **Correlate:** For each merge date, compare cost on that day and the following 1–3 days vs the 7-day prior average. Flag merges where post-merge cost exceeds prior baseline by a threshold (e.g. 20%).
4. **Surface:** List flagged MRs with merge date, author, subject, and cost delta for user review.

## Output structure (Markdown by default)

**Audience:** Senior data engineer. Two distinct perspectives:
- **Summary** = Big picture, "how are things doing?" — status and trends only
- **Report** = Deep dive, "where can we save?" — analysis and suggestions based on that analysis

**Default files:** `databricks_cost_optimization_summary.md` and `databricks_cost_optimization_report.md` in the project root. Use HTML (`.html`) or chat-only if the user prefers—HTML is not required.

### databricks_cost_optimization_summary (Big Picture)

**Perspective:** Diagnostic, status-oriented. No actionable recommendations.

| Section | Content |
|---------|---------|
| Executive summary | 2–3 sentences on overall health, biggest levers, critical issues |
| Cost at a glance | Total spend, job vs warehouse vs **AWS** (`aws_costs_aggr`) split when relevant, top 5–10 cost drivers |
| Cost trends | Time series by job; direction and spikes |
| Cluster utilization status | Per-job cpu_status, mem_status (RIGHT_SIZED, OVER/UNDER_PROVISIONED) |
| Consumer patterns overview | Who consumes; peak hours; high-level only |
| MR vs cost correlation | Merge dates on cost; flag spikes |
| Incremental strategy overview | Model count by strategy; obvious mismatches |

**Avoid:** Detailed recommendations, specific $ deltas, step-by-step actions.

### databricks_cost_optimization_report (Deep Dive)

**Perspective:** Action-oriented. Suggestions based on analysis. Cost savings focus.

| Section | Content |
|---------|---------|
| Cost savings opportunities | Ranked by impact; affected jobs, rationale, metrics, est. $ delta |
| Recommendations per job | Supporting metrics + specific suggestions; each tied to analysis |
| Detailed metrics | Full utilization, run duration/setup/queue, consumer patterns with $ |
| Main cost reduction strategies | Table: strategy, rationale, affected jobs, est. impact |
| MR-cost deep dive | For flagged MRs: before/after, causes, suggested review |
| Project tables + sources + SQL optimization | All project materializations and lineage sources; per-`job_id` cost-by-table/model query; SQL patterns (predicates, scans, merge, partitions) |

**Avoid:** High-level status without a concrete recommendation.

**Default:** Markdown (GFM), project root. **Optional:** semantic HTML with minimal CSS when the user requests `format=html` or HTML output.
