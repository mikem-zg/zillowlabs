# Batch SQL

## What It Is

Replacing per-period, per-entity, or per-category SQL queries executed in a loop with a single
bulk query that retrieves all data at once. The results are then partitioned in-memory.

## Why It Matters

Each SQL query has fixed overhead: connection setup, query planning, cluster communication,
and result serialization. When queries are structurally identical except for a date or entity
filter, batching them into one query eliminates N-1 round trips.

**Rough speedup**: 5–50x depending on query count and per-query overhead.

The Databricks SQL connector typically adds ~2–5 seconds per query for connection
and cursor setup. With dozens of queries per period, that overhead alone can add minutes
to the pipeline — eliminated entirely by batching.

## How to Identify Opportunities

Look for these patterns:

1. **SQL queries inside `for` loops over periods/dates**:
   ```python
   for eff_date, label in eval_dates:
       df = run_query(build_query(eff_date), "label")
   ```

2. **Multiple calls to the same SQL template with different parameters**:
   ```python
   tgt_df = run_query(build_targets_query(eff_date))
   rec_df = run_query(build_recommendations_query(eff_date))
   status_df = run_query(build_status_query(eff_date))
   ```

3. **Separate current/prior queries**:
   ```python
   current_df = run_query(build_metric_query(eff_date))
   prior_df = run_query(build_prior_metric_query(eff_date))
   ```

## Before/After Examples

### Example 1: Per-period target queries → single bulk query

**Before** (per-period loop):
```python
for eff_date, label in eval_dates:
    mask = train['period'] == label
    tgt_df = spark.sql(build_targets_query(eff_date)).toPandas()
    tgt_map = tgt_df.set_index('entity_id')['target_value'].to_dict()
    train.loc[mask, 'target_value'] = (
        pd.to_numeric(train.loc[mask, 'entity_id'].map(tgt_map), errors='coerce')
        .fillna(0).astype('float32')
    )
```

**After** (single bulk query):
```python
date_list = ", ".join(f"'{ed}'" for ed, _ in eval_dates)
bulk_sql = f"""
    SELECT CAST(entity_id AS STRING) AS entity_id,
           snapshot_date AS eff_date,
           target_value
    FROM my_schema.capacity_table
    WHERE snapshot_date IN ({date_list})
"""
bulk_df = spark.sql(bulk_sql).toPandas()
for eff_date, label in eval_dates:
    mask = train['period'] == label
    period_targets = bulk_df[bulk_df['eff_date'] == eff_date]
    tgt_map = period_targets.set_index('entity_id')['target_value'].to_dict()
    train.loc[mask, 'target_value'] = (
        pd.to_numeric(train.loc[mask, 'entity_id'].map(tgt_map), errors='coerce')
        .fillna(0).astype('float32')
    )
```

### Example 2: Separate current/prior queries → bulk query

When current and prior period queries are nearly identical with different date windows,
combine them into a single bulk query:
```python
min_date, max_date = compute_bulk_date_range(eval_dates)
bulk_df = spark.sql(bulk_query_sql(min_date, max_date)).toPandas()
for eff_date, label in eval_dates:
    current_map, prior_map = build_maps_from_bulk(bulk_df, eff_date)
```
This replaces 2 × N_periods queries with a single query.

### Example 3: Multiple independent queries → parallel execution

**Before** (sequential):
```python
tgt_df = run_query(build_targets_query(eff_date))
rec_df = run_query(build_recommendations_query(eff_date))
status_df = run_query(build_status_query(eff_date))
filter_df = run_query(build_filter_query(eff_date))
```

**After** (parallel with ThreadPoolExecutor):
```python
from concurrent.futures import ThreadPoolExecutor, as_completed

queries = {
    'targets': build_targets_query(eff_date),
    'recommendations': build_recommendations_query(eff_date),
    'status': build_status_query(eff_date),
    'filters': build_filter_query(eff_date),
}
results = {}
with ThreadPoolExecutor(max_workers=4) as pool:
    futures = {pool.submit(run_query, sql, label): label
               for label, sql in queries.items()}
    for future in as_completed(futures):
        label = futures[future]
        results[label] = future.result()
```

## Gotchas and When NOT to Use

- **Query result size**: Batching increases the result set size. If individual queries return
  100K rows and you batch 5 periods, the result is 500K rows — ensure the driver has enough
  memory.
- **Query complexity**: Very complex CTEs may hit Spark catalyst optimizer limits when
  combined into a single query. If the batched query is slower than the sum of parts,
  split it back.
- **Mixed query types**: Only batch queries that hit the same tables. Batching unrelated
  queries (targets + metrics + status) into a single SQL statement doesn't help — use
  parallel execution instead.
- **Parameterized queries**: When batching, use `IN (...)` clauses for date lists rather
  than generating massive `UNION ALL` statements.

## Databricks Features

### Delta Lake Time Travel

Query historical snapshots without multiple queries:
```sql
SELECT * FROM my_table VERSION AS OF 42;
SELECT * FROM my_table TIMESTAMP AS OF '2026-01-15';
```
Useful when comparing current vs prior period data from the same table — instead of two
queries with different date filters, query two versions of the same table.

### `spark.sql()` with CTEs and Window Functions

The preferred pattern over loop-and-query. Use CTEs to structure complex logic and window
functions for per-group computations:
```sql
WITH all_periods AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY entity_id ORDER BY snapshot_date DESC) AS rn
    FROM capacity_table
    WHERE snapshot_date IN ('2026-01-01', '2026-02-01')
)
SELECT entity_id, snapshot_date, target_value
FROM all_periods WHERE rn <= 2
```

### Databricks SQL Warehouse Query Caching

Identical queries within 24 hours return cached results instantly. This means:
- If you run the same query twice (e.g., during retry), the second call is free
- Structurally identical queries with different literal values are NOT cached — they are
  different queries. Use parameterized queries to benefit from caching.

### EXPLAIN and Spark UI SQL Tab

Verify that batched queries are actually more efficient:
```sql
EXPLAIN EXTENDED SELECT ...
```
Check the Spark UI → SQL tab → DAG visualization to confirm the query plan uses a single
table scan instead of N separate scans.

### Parameterized Queries (DBR 13.3+)

Use `:param` syntax to avoid f-string SQL injection risks:
```python
spark.sql("""
    SELECT * FROM my_table
    WHERE snapshot_date = :eff_date
      AND entity_id IN (:entity_list)
""", params={"eff_date": "2026-01-01", "entity_list": entity_ids})
```
This also enables better query plan caching since the parameterized template is the same
across calls.
