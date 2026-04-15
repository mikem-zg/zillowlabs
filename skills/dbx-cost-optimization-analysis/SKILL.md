# dbx-cost-optimization-analysis

**Short description:** Analyze a Databricks/dbt git repo and produce two deliverables—a high-level **summary** and a detailed **report**—grounded in platform cost data, table lineage, and how pipelines are wired in code. **Default:** Markdown files in the project root; use HTML, another format, or chat-only output if the user asks.

Use this skill when invoked from within a git project folder containing Databricks workflows, dbt models, or Databricks Asset Bundles (DAB). It provides data-driven cost optimization recommendations based on Databricks best practices, consumer patterns, and project-specific pipeline configurations.

## Available commands

| Command | Effect |
|---------|--------|
| *(default)* | Generate both summary and report |
| `summary` | Generate only the summary file (default name: `databricks_cost_optimization_summary.md`) |
| `plan` | Generate only the report file (default name: `databricks_cost_optimization_report.md`) |
| `scope=job:<name>` | Focus on one job; deeper input/output & producer/consumer analysis |
| `scope=model:<name>` | Focus on one model; deeper input/output & producer/consumer analysis |
| `format=html` | Optional. Emit `.html` instead of `.md` for the files being generated (see **Output format**). |

## References

- [Databricks Cost Optimization Best Practices](https://docs.databricks.com/aws/en/lakehouse-architecture/cost-optimization/best-practices)
- [Zillow Data Platform Cost Governance](https://data-platform-docs.zgtools.net/docs-databricks/operational-guides/cost-governance/cost-optimization) (internal)
- [SQL Warehouse Governance](https://data-platform-docs.zgtools.net/docs-databricks/operational-guides/cost-governance/sql-warehouse-governance) (internal)
- [Cost Monitoring](https://data-platform-docs.zgtools.net/docs-databricks/operational-guides/cost-governance/cost-monitoring) (internal)
- [dbt Incremental Strategy](https://docs.getdbt.com/docs/build/incremental-strategy)

---

## Arguments

The user may invoke this skill with optional arguments. Interpret them from the request (e.g. "run cost optimization summary only", "focus on job X", "plan for model Y").

| Argument | Values | Effect |
|----------|--------|--------|
| **summary** | (flag) | Generate **only** the summary deliverable (default filename: `databricks_cost_optimization_summary.md`). Skip the report. |
| **plan** | (flag) | Generate **only** the report deliverable (default filename: `databricks_cost_optimization_report.md`). Skip the summary. |
| **format** | `html` (optional) | Use `.html` files with semantic HTML and minimal CSS instead of Markdown. Omit unless the user asks for HTML or passes `format=html`. |
| **scope** | `model:<name>` or `job:<name>` | Narrow the investigation to a single dbt model or job. When set: (1) filter all analysis to that model/job only; (2) run **deeper investigation** on input vs output sizes, consumer patterns, and producer patterns for that entity. |

**Scope behaviour**

- **`scope=job:<job_name>`** — Restrict to that job. Costs, cluster utilization, lineage, and recommendations apply only to that job. Add a **deeper-dive section** with: input table sizes (bytes, rows) read by the job; output table sizes written; consumer patterns for outputs; producer patterns for inputs; hour-of-day/day-of-week for producers and consumers.
- **`scope=model:<model_name>`** — Restrict to that dbt model. Resolve the job(s) that run it and the table(s) it writes. Add a **deeper-dive section** with: upstream source sizes (bytes, rows) and freshness; output table size; consumer patterns (who reads the output, when); producer patterns (who writes the inputs, when); read/write volume ratios (expansion/compression).

**Output behaviour**

- `summary` only → produce only the summary file (default `databricks_cost_optimization_summary.md`, or `.html` if `format=html`).
- `plan` only → produce only the report file (default `databricks_cost_optimization_report.md`, or `.html` if `format=html`).
- Default (no flags) → produce both files.
- **User preference overrides defaults:** If the user asks for no files (chat-only), HTML, PDF, or another representation, follow that instead of writing Markdown to disk.

**Invocation examples**

- "Run cost optimization summary only" → `summary`
- "Generate the cost optimization plan" → `plan`
- "Cost optimization for job zhl_data_warehouse_databricks_loan_prod" → `scope=job:zhl_data_warehouse_databricks_loan_prod`
- "Deep dive on model fact_zhl_lead" → `scope=model:fact_zhl_lead`
- "Summary for model fact_loan" → `summary` + `scope=model:fact_loan`

---

## Workflow

### 1. Discover Project-Defined Jobs Only

**Scope strictly to jobs defined in this project.** Do not include other jobs that share the service tag.

**If `scope=job:<name>`:** Restrict the project job list to that single job (or jobs matching the name pattern). All subsequent steps apply only to this job.

**If `scope=model:<name>`:** Find the job(s) that run the given dbt model (from task definitions, dbt_project). Restrict the project job list to those jobs. Resolve the table(s) the model writes (catalog.schema.model_name). All subsequent steps apply only to that model and its job(s).

- Parse `databricks.yml` targets (lab, stage, prod) to get `bundle.target` values.
- Parse `resources/*.yml` for job definitions: look for `resources.jobs.<key>` with `name: <base>_${bundle.target}`.
- Build the **project job list**: expand each base name with each target (e.g. `zhl_data_warehouse_databricks_loan_prod`, `zhl_data_warehouse_databricks_loan_stage`, `zhl_data_warehouse_databricks_loan_lab`).
- Extract `zodiac_service`, `zodiac_team`, and warehouse IDs from `databricks.yml`.
- Map each job to its schedule (cron), warehouse_id, and dbt tasks if applicable.

**Example project jobs** (zhl-dw): `zhl_data_warehouse_databricks_loan_*`, `zhl_data_warehouse_databricks_leads_*`, `zhl_data_warehouse_databricks_job_*`, `zhl_data_warehouse_genesys_job_*`, `zhl_dw_communications_workflow_*`, `zhl_dw_daily_databricks_job_*`, `zhl_dw_early_morning_daily_*`, `zhl_dw_monthly_databricks_job_*`, `zhl_lead_call_summary_daily_*`, `treasury_loan_daily_*`, `zhl_dw_adhoc_job_*`, etc.

### 2. Retrieve Costs for Project Jobs Only

Use **three** Databricks/SQL cost sources **plus** **AWS** team attribution when the analysis should include full platform spend. Filter Databricks sources so that **only** rows for project-defined jobs/warehouses are included; filter `aws_costs_aggr` by `team` (and date) per [reference.md](reference.md).

**1. Job compute costs** – `data_platform.cost_governance_data_silver.usage_cost_aggr`

- Cluster/job runs (non-SQL tasks). Add `job_name IN (<project_job_names>)`.
- See [reference.md](reference.md) for full query.

**2. SQL warehouse costs** – `data_platform.cost_governance_data_silver.dbsql_cost_per_query`

- SQL warehouse usage (dbt, SQL tasks, dashboards). Filter `warehouse_id IN (<project_warehouse_ids>)` from `databricks.yml`.
- Join to `all_job_run_details` on `query_source_id = job_id` and filter `job_name IN (<project_job_names>)` for job-attributed queries.
- Include `query_attributed_dollars_estimation`, `duration_seconds`, `start_time` per query.
- Aggregate by job, warehouse, date for total warehouse cost per project job.
- **Warehouse cost often dominates** for dbt/SQL-heavy projects – treat it as a primary cost driver, not secondary to job compute.

**3. AWS costs (by team)** – `data_platform.cost_governance_data_silver.aws_costs_aggr`

- Aggregated AWS spend with `team` and date grain `ds`. Use `SUM(cost)`; example: monthly rollup with `date_trunc('month', ds)`.
- When presenting **cost by team**, include **`aws_cost_usd`** (or equivalent) as a **separate column** next to Databricks job compute and SQL warehouse dollars so AWS is visible and not conflated with DBU/warehouse lines.
- See [reference.md](reference.md) for the canonical example query and a **combined** pattern (job compute + AWS columns on `team` × `month`).

**Never report on** jobs like `incremental_batch_zhl_factory_event_flattener_daily`, `vfs_execution_fact_submission`, or untagged ad-hoc warehouse usage—they are outside this project.

### 3. Lineage Investigation

**Conduct a dedicated lineage investigation** using `system.access.table_lineage` and `system.access.audit`. This is a required step—do not skip it. Build a full picture of data flows for project tables.

**If `scope=model:<name>` or `scope=job:<name>`:** Restrict lineage to tables written by that model/job. When scope is set, also run **deeper producer/consumer analysis** — who produces the inputs, who consumes the outputs, and when (hour-of-day, day-of-week).

**1. Derive project tables**
- From dbt models and `dbt_project.yml`: catalog + schema per target (e.g. `mortgage.internal`). List all tables written by project jobs (from dbt model names, e.g. `fact_loan`, `fact_zhl_lead`).
- Build full table names: `catalog.schema.table`.

**2. Query `system.access.table_lineage`**
- **Upstream (sources):** `WHERE target_table_full_name IN (<project_tables>)` — what feeds into each project table. Use `source_table_full_name`, `source_type`, `entity_type`, `entity_id`, `event_time`.
- **Downstream (consumers):** `WHERE source_table_full_name IN (<project_tables>)` — what reads each project table. Use `target_table_full_name`, `entity_type`, `entity_id`, `created_by`, `statement_id`, `event_time`.
- **Read vs write:** For lineage, source not null = read; target not null = write. Join upstream + downstream to build a flow graph.

**3. Query `system.access.audit`**
- `WHERE action_name = 'getTable'` and `request_params['full_name_arg'] IN (<project_tables>)` — who read which project table, `user_identity`, `event_time`, `event_date`.
- **Lineage can be incomplete.** Audit often captures reads that lineage misses (e.g. JDBC, some dashboards). Use audit to fill gaps and validate consumer lists.

**4. Combine and analyse**
- Merge lineage consumers with audit readers. Deduplicate by entity/user.
- Identify: tables with no downstream lineage but with audit reads (lineage gap); high-fanout consumers; critical paths; orphan tables.
- Surface lineage findings in both summary (overview) and report (detailed, with recommendations).

See [reference.md](reference.md) for lineage investigation queries.

**When scope is set — deeper input/output and producer/consumer analysis:**

- **Input sizes:** For the scoped model/job, query upstream tables via lineage. Use `DESCRIBE DETAIL` or `ANALYZE TABLE` for `numFiles`, `sizeInBytes`, row count. Join to lineage to get which inputs feed the model.
- **Output sizes:** For the table(s) written by the model, same approach. Compute read vs write ratios (compression/expansion).
- **Producer patterns:** From lineage (target = upstream table) and audit: who writes the inputs, when (hour-of-day, day-of-week). Use for scheduling alignment.
- **Consumer patterns:** From lineage (source = output table) and audit: who reads the outputs, when. Use for scheduling and refresh alignment.
- Surface in a dedicated "Focused analysis" section in the report (and summary overview when `summary` is produced).

### 4. Consumer Pattern Analysis (Project Tables)

Use **usage system tables** together with **lineage investigation results** and cost data to drive consumer-based recommendations.

**1. Downstream consumers**
- `system.access.table_lineage` – `source_table_full_name` in project tables. Consumer = `entity_type`, `entity_id`, `created_by`. Use `statement_id` to join to cost/query data.
- `system.access.audit` – `action_name = 'getTable'` and `request_params['full_name_arg']` in project tables. Gives who read which table, `event_time`, `user_identity`. Use for access patterns when lineage is incomplete.

**2. Consumer query patterns**
- Join lineage to `dbsql_cost_per_query` on `statement_id` for cost and `start_time` (hour-of-day, day-of-week).
- **system.query.history** – `statement_id`, `start_time`, `executed_by`, `query_source` (job_info, dashboard_id, notebook_id), `read_bytes`, `total_duration_ms`. Derive hour-of-day, day-of-week, consumer type (job vs dashboard vs ad-hoc). Use when `dbsql_cost_per_query` is missing rows or for richer metrics.
- **Per-job dbt model cost by day:** filter `query_source.job_info.job_id` to a single job and join `system.query.history` to `dbsql_cost_per_query` on `statement_id`, grouping by dbt model tag and `date(start_time)`. Use to see **which models cost the most day by day** and prioritize model-level optimizations. See [reference.md](reference.md) (“Per-job dbt model cost by day”).
- Aggregate per table: consumer, hour-of-day, day-of-week, query count, dollars, duration, read_bytes.

**3. Drive recommendations from usage**
- If consumers run 8am–6pm → align producer schedules to finish before 8am.
- If dashboards (query_source.dashboard_id) dominate → avoid full refreshes during refresh peaks.
- If read_bytes/read_rows are high for certain tables → recommend partitioning or incremental_predicates.

See [reference.md](reference.md) for queries.

### 4b. SQL optimization patterns (deep dive — project tables and sources)

**Applies to the report (`plan` or default), not a thin summary.** The deep dive must treat **SQL-level savings** as first-class: every **table the project writes** and **upstream source tables** that feed those models (from lineage and dbt `source`/`ref` definitions) are in scope for investigation—not only one “hot” model.

1. **Inventory project tables and sources** — Build `catalog.schema.table` for: (a) all tables materialized by project dbt models / jobs; (b) **upstream** tables from `system.access.table_lineage` (sources feeding project outputs) and from `sources.yml` / refs. For high fan-in paths, follow sources far enough to explain cost (at minimum: direct sources of the costliest models).

2. **Cost per table (model) by `job_id`** — For each project job that runs warehouse-attributed SQL (typical dbt jobs), resolve **`job_id`** (`all_job_run_details`, job UI, or `system.lakeflow.jobs`). Run the **per-job dbt model cost** query in [reference.md](reference.md) (“Per-job dbt model cost by day”): it attributes **`dbsql_cost_per_query`** to **`@@dbt_model_name`** (table/model) for a fixed `job_id`. Rank by `est_sql_dollars`, `read_gib`, `read_billions_rows`, and duration. Use this to prioritize **which** tables/models and their **sources** deserve SQL optimization analysis.

3. **SQL optimization patterns** — For ranked models/tables, tie warehouse cost and `system.query.history` evidence (e.g. `read_bytes`, `statement_text` where appropriate) to concrete patterns: missing partition/date filters, full scans on large Delta tables, heavy merges without `incremental_predicates`, join/broadcast issues, sort-merge vs broadcast opportunities, stats gaps, and misalignment between `cluster_by`/partition keys and typical predicates. Recommend changes with estimated impact when possible.

4. **Coverage** — When the project has multiple jobs, repeat the per-`job_id` cost-by-table analysis for **each** relevant job that contributes to project spend; do not stop after the single largest job if other jobs write or refresh project tables.

### 5. Partitioning and Read-Time Optimization

- Use lineage to see which columns downstream queries filter on.
- If consumers frequently filter by date or a high-cardinality key, recommend `cluster_by` / `partition by` on those columns.
- For `insert_overwrite` models, ensure partition keys align with typical filter predicates.
- Suggest `incremental_predicates` when using `merge` to limit target-table scans.

### 6. dbt Incremental vs Full Refresh

- **Sources:** For each dbt model, inspect upstream sources – size, partition columns, freshness.
- **Strategies:**
  - **append:** Low-cost, append-only; no dedup.
  - **merge:** Use when `unique_key` is reliable; can be expensive on large targets.
  - **insert_overwrite:** Best for partition-aligned, date-based loads.
  - **delete+insert:** Use when `unique_key` is not unique or merge unsupported.
  - **microbatch:** For large time-series; process in time-based batches.
- **Recommendations:**
  - Small, frequently changing sources → consider incremental + merge.
  - Large, append-only, date-partitioned → `insert_overwrite` or `replace_where`.
  - Full refresh only when source is small or schema/backfill is needed.

### 7. GitLab MR vs Cost Correlation

- Fetch git log for merges (author, date, message, MR ref if available).
- Join merge dates with daily (or weekly) cost from **Databricks** sources: `usage_cost_aggr.usage_cost` (job compute) and `dbsql_cost_per_query` totals (warehouse). Optionally overlay **`aws_costs_aggr`** by `date(ds)` for the same `team` when investigating infra-adjacent spikes (confirm grain with finance/governance if daily AWS aligns to merge dates).
- Flag dates with cost increases shortly after merges; surface top MRs by cost delta for review.

### 8. Volume-Based Compute and Worker Type Analysis

Analyse **sources**, **job type/definition**, and **volume** to suggest worker choices and warehouse type.

**1. Sources analysis**
- Inspect dbt sources (sources.yml, refs): table size (row count, bytes), partitioning, growth rate.
- Use `DESCRIBE DETAIL`, `ANALYZE TABLE`, or lineage to infer volume. Large unpartitioned sources → incremental or partitioning.
- Volume drives: full refresh vs incremental, and whether job compute vs warehouse is appropriate.

**2. Job type and definition**
- Parse job YAML: task types (`sql_warehouse_task`, `dbt_task`, `notebook_task`, `spark_jar_task`, `python_task`), task count, dependencies, schedule.
- Identify: SQL-only vs mixed (SQL + Python/notebook). Heavy dbt/SQL → warehouse. Heavy Spark/Python → job compute cluster.
- Note cluster config if present: instance type, workers, spot vs on-demand, autoscaling.

**3. Worker type suggestions – analyse before recommending**

Do **not** assume SQL warehouse (or Photon) is always cheaper. Analyse and quantify benefit first.

- **SQL on job compute vs SQL warehouse:** Compare current cost (usage_cost_aggr for job compute, dbsql_cost_per_query for warehouse) for similar workloads. If the job already runs on a warehouse, switching to job compute is rarely beneficial for SQL. If it runs on a cluster, estimate warehouse cost (duration × warehouse DBU rate) and compare to actual job compute cost. **Only recommend a switch when cost data shows a measurable benefit** (e.g. “warehouse would save ~$X/day”).
- **Photon:** Evaluate, do not assume. Compare cost and duration for the same job with Photon on vs off (if data exists), or run a pilot. Photon helps many workloads but not all; quantify before recommending.
- **Non-SQL Spark/Python** → Job compute cluster. Use compute-optimized for streaming/maintenance; memory-optimized for shuffle/ML; storage-optimized for caching.
- **Spot instances** → For fault-tolerant batch jobs; keep driver on-demand.
- **Autoscaling** → Enable for variable-volume jobs; set min/max from observed run patterns.

**4. Serverless vs non-serverless SQL warehouse**
- **Serverless:** Scales to zero, fast startup, no idle cost. Best for bursty or intermittent workloads (scheduled dbt, dashboards, ad-hoc). Use when jobs run a few times per day or less.
- **Non-serverless (provisioned):** Predictable for long, high-throughput runs. Consider when jobs run very frequently (e.g. every 15 min) and serverless startup/scale overhead may add cost. Compare via dbsql_cost_per_query by warehouse_id.
- Per job: if schedule is sparse (daily, hourly) → prefer serverless. If many short runs back-to-back → consider provisioned. Use cost data to validate.

See [reference.md](reference.md) for serverless vs provisioned decision guide.

### 9. Cluster Utilization and Job Run Metrics

Use system tables to analyse whether clusters can be downsized and to refine cluster config or dbt models.

**1. Cluster utilization** – `system.compute.node_timeline` joined with `job_task_run_timeline` and `system.compute.clusters`

- Use the full job-level utilization query in [reference.md](reference.md): joins task runs → clusters → node_timeline (worker and driver), aggregates by job, derives `cpu_status` (CPU_OVER_PROVISIONED, CPU_RIGHT_SIZED, CPU_UNDER_PROVISIONED), `mem_status`, and `recommendation`.
- **Scope:** All-purpose and jobs compute only (excludes serverless, SQL warehouses).
- **Filter for project jobs:** Replace the team filter in `job_cluster_runs` with project job name patterns (e.g. `j.job_name LIKE 'zhl_data_warehouse%'` or `j.job_name IN (<project_job_names>)`).
- Use `cpu_status`, `mem_status`, `recommendation` for actionable right-sizing. **Recommend only when data supports it**; quantify estimated savings where possible.

**2. Job run metrics** – `system.lakeflow.job_run_timeline` and `system.lakeflow.job_task_run_timeline`

- Duration: `run_duration_seconds`, `execution_duration_seconds`, `setup_duration_seconds`, `cleanup_duration_seconds` (when populated).
- Join to `system.lakeflow.jobs` for job name; filter by project job_ids (from `all_job_run_details` or job name patterns).
- Use for: identifying slow tasks, comparing runs over time, correlating duration with cost.
- High `setup_duration_seconds` or `queue_duration_seconds` → consider cluster pools or different scheduling.
- Long task runs with low cluster utilization → suggest dbt model changes (incremental, partitioning) or smaller clusters.
- CPU seconds: derive from `node_timeline` (cpu percent × minutes) or use `system.billing.usage` when joined to job runs.

See [reference.md](reference.md) for queries.

### 10. Main Cost Reduction Strategies & Affected Jobs

For each project-defined job, derive strategies from its cost and config. Only reference project jobs.

| Strategy | Rationale | Example affected jobs (project only) |
| Reduce job frequency | Lower DBU hours (job + warehouse) | Jobs with high run frequency from this project |
| Reduce warehouse runtime | Lower SQL warehouse cost (dbsql_cost_per_query) | dbt/SQL jobs with high duration or dollars |
| Switch to incremental | Avoid full scans; reduce warehouse cost | dbt models in this project materialized as table |
| Add incremental_predicates | Limit merge scans; reduce warehouse cost | Merge models in this project with large targets |
| Align schedules with consumers | Finish before peak usage; use usage system tables (audit, query.history) for patterns | Heavy producers in this project |
| Consolidate/optimize partitions | Reduce read cost and warehouse spend | Tables written by this project with poor partitioning |
| Switch worker type | Job compute vs warehouse; serverless vs provisioned; instance family. **Only when cost analysis shows measurable benefit** (quantify $ delta) | Jobs with high cost and mismatched compute choice |
| Right-size clusters | Use `system.compute.node_timeline` utilization (avg/peak CPU, memory) to reduce workers or instance type | Job compute clusters with low utilization |
| Optimize dbt / task config | Use `job_run_timeline` and `job_task_run_timeline` duration, setup, queue times | Jobs with long runs, high setup, or low utilization |

Prioritize by impact per job (cost delta × feasibility).

---

## Output

Deliver the summary and/or report in the **user’s preferred form**. **Default:** one or two **Markdown** files in the project root (`*.md`). **Do not** require HTML. **All content scoped to project-defined jobs only** (or to the scoped job/model when `scope` is set).

### Output format

| Situation | What to produce |
|-----------|-----------------|
| **Default** (no format specified) | `databricks_cost_optimization_summary.md` and/or `databricks_cost_optimization_report.md` — GitHub-flavored Markdown (headings, tables, lists, fenced code for SQL/snippets). |
| **`format=html`** or user asks for HTML | Same structure and sections, as semantic HTML with minimal CSS; filenames `.html`. |
| User asks for **chat-only**, **no files**, or inline | Put the same content in the assistant response; skip writing files unless they ask to save. |
| User asks for **PDF** or another export | Produce Markdown first (or the closest equivalent in chat), then convert or describe how to export if you cannot write binary files. |

**Respect the `summary` and `plan` arguments** (using default `.md` names unless `format=html`):

- `summary` only → **only** the summary deliverable.
- `plan` only → **only** the report deliverable.
- Neither → **both** deliverables.

Target a **senior data engineer** who wants (1) a **big picture** view of how things are doing and (2) a **deep dive** into cost savings. The two outputs serve different concerns and perspectives.

### databricks_cost_optimization_summary (Big picture)

**Perspective:** Big picture — "How are things doing?"

**Purpose:** Give a senior engineer a quick, high-level health check. Focus on **status, trends, and understanding**, not yet on specific changes.

**Contents:**
- **Executive summary** — 2–3 sentences on overall project cost health, biggest levers, and any critical issues.
- **Cost at a glance** — Total daily/monthly spend for project jobs; job compute vs warehouse vs **AWS** (`aws_costs_aggr` by `team`) when relevant; top 5–10 cost drivers ranked by $.
- **Cost trends** — Time series (daily or weekly) by job; job compute, warehouse, and **AWS** (by team/month or day) separately and combined where useful. Show direction (up, flat, down) and any spikes.
- **Cluster utilization status** — Per-job: `cpu_status`, `mem_status` (e.g. RIGHT_SIZED, OVER_PROVISIONED, UNDER_PROVISIONED). No detailed recommendations here; just "where do we stand?"
- **Lineage overview** — Upstream sources and downstream consumers for project tables; any lineage gaps (audit vs lineage); high-fanout or orphan tables.
- **Consumer patterns overview** — Who consumes project tables; peak hours/days; any obvious scheduling misalignments. High-level only.
- **MR vs cost correlation** — Merge dates overlaid on cost; flag any clear spikes after merges. "What happened when?"
- **Incremental strategy overview** — Count of models by strategy (table vs merge vs insert_overwrite); any obvious mismatches (e.g. large tables as full refresh).

**Avoid in summary:** Detailed per-job recommendations, specific $ deltas, step-by-step action lists. Keep it **diagnostic and status-oriented**.

### databricks_cost_optimization_report (Deep dive)

**Perspective:** Deep dive — "Where can we save?"

**Purpose:** Detailed analysis and **actionable recommendations** based on that analysis. Focus on **cost savings opportunities** and specific changes.

**Contents:**
- **Cost savings opportunities** — Ranked by estimated impact. Per opportunity: affected jobs, rationale, supporting metrics, estimated $ delta or % saving (when quantifiable).
- **Recommendations per job** — One section per project job with:
  - Supporting metrics (cost, duration, utilization, consumer patterns)
  - **Suggestions based on analysis** — e.g. "cluster utilization avg 18% → reduce workers from 4 to 2; est. ~$X/day"
  - Volume-based and worker type changes (serverless vs provisioned, instance family) with quantified benefit when known
  - Scheduling changes (align with consumers, reduce frequency) with rationale
  - Incremental/model changes (switch strategy, add predicates) with affected models
  - Partitioning changes with rationale
  - Main cost reduction strategies table — strategy | rationale | affected jobs | est. impact
- **Lineage investigation** — Full upstream/downstream map; lineage vs audit gaps; critical paths; recommendations based on lineage (e.g. tables with many consumers → avoid disruptive full refreshes).
- **Project tables, sources, and SQL optimization** — All tables written by the project **plus** their lineage-defined **source** tables; cross-check with **per-`job_id` cost-by-table/model** warehouse metrics ([reference.md](reference.md), “Per-job dbt model cost by day”). Rank spend/read volume, then document SQL optimization patterns (predicates, partitions, merge/incremental behavior, stats, clustering) with evidence.
- **Detailed metrics** — Full cluster utilization (avg, p90, swap), job run duration/setup/queue, consumer hour-of-day/day-of-week with query counts and dollars.
- **MR-cost deep dive** — For any flagged MRs: before/after cost, possible causes, suggested review.

**Avoid in report:** Repeating high-level "how are we doing" without a tie to a specific recommendation. Every section should support **suggestions based on analysis**.

---

## Databricks Best Practices (Quick Reference)

| Principle | Practices |
|-----------|-----------|
| **Choose resources** | Delta Lake, job compute for batch, SQL warehouse for SQL (analyse benefit before recommending; Photon not always cheaper), right instance type |
| **Allocate dynamically** | Auto-scaling, auto-termination, compute policies |
| **Monitor cost** | Tagging, budgets, `usage_cost_aggr`, `dbsql_cost_per_query`, `aws_costs_aggr` (AWS by `team`) |
| **Design workloads** | Batch vs streaming (AvailableNow), spot instances where acceptable |

---

## Additional Resources

- For detailed cost query templates and lineage queries, see [reference.md](reference.md).