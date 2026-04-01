# Spark Broadcast Joins

## What It Is

Using `broadcast()` (or SQL hints) to instruct Spark to send a small table to all executors
as an in-memory hash map, avoiding the expensive shuffle-sort-merge join strategy.

## Why It Matters

Default Spark joins use sort-merge: both sides are shuffled, sorted, and merged. For a join
between a large fact table (millions of rows) and a small dimension table (thousands of rows),
this is wasteful — shuffling the large table is expensive when the small table fits in memory.

**Rough speedup**: 2–10x for joins where one side is <100MB.

## How to Identify Opportunities

1. **Joins with dimension tables**: Small dimension/lookup tables (geography mappings,
   agent rosters, segmentation tables) joined to large fact tables.

2. **Map-based enrichment in Pandas**: Many feature functions use `.map(dict)` patterns
   which are conceptually broadcast joins:
   ```python
   tgt_map = tgt_df.set_index('entity_id')['target_value'].to_dict()
   train.loc[mask, 'target_value'] = train.loc[mask, 'entity_id'].map(tgt_map)
   ```
   If this were done in Spark instead of Pandas, a broadcast join would be ideal.

3. **Check the Spark UI**: SQL tab → look for `SortMergeJoin` nodes where one input
   has <10MB of data. These should be `BroadcastHashJoin` instead.

## Before/After Examples

### Example 1: PySpark DataFrame join with broadcast

**Before** (default sort-merge join):
```python
enriched = train_spark.join(targets_spark, on="entity_id", how="left")
```

**After** (broadcast the small targets table):
```python
from pyspark.sql.functions import broadcast
enriched = train_spark.join(broadcast(targets_spark), on="entity_id", how="left")
```

### Example 2: SQL hint for broadcast join

**Before**:
```sql
SELECT t.*, dzm.region_id AS region_id
FROM train_features t
LEFT JOIN dim_geography dzm
    ON t.zip = dzm.zipcode
```

**After**:
```sql
SELECT /*+ BROADCAST(dzm) */ t.*, dzm.region_id AS region_id
FROM train_features t
LEFT JOIN dim_geography dzm
    ON t.zip = dzm.zipcode
```

### Example 3: Converting Pandas map-based join to Spark broadcast join

**Before** (Pandas map-based join):
```python
tgt_df = spark.sql(build_targets_query(eff_date)).toPandas()
tgt_map = tgt_df.set_index('entity_id')['target_value'].to_dict()
train.loc[mask, 'target_value'] = (
    pd.to_numeric(train.loc[mask, 'entity_id'].map(tgt_map), errors='coerce')
    .fillna(0).astype('float32')
)
```

**After** (Spark broadcast join):
```python
targets_df = spark.sql(build_targets_query(eff_date))
train_spark = train_spark.join(
    broadcast(targets_df.select("entity_id", "target_value")),
    on="entity_id", how="left"
).fillna({"target_value": 0})
```

## Gotchas and When NOT to Use

- **Table too large**: Broadcasting a table >200MB causes driver OOM or excessive network
  traffic. The default auto-broadcast threshold is 10MB for a reason.
- **Many broadcast joins**: Each broadcast join creates a copy of the small table on every
  executor. If you have 10 broadcast joins, that's 10 copies of (possibly different) small
  tables in executor memory.
- **Skewed join keys**: If the large table has skewed keys (e.g., a few agents with millions
  of rows), broadcast join still processes all rows for those keys on a single executor.
  Use skew join hints instead.
- **Dynamic tables**: If the "small" table varies in size by run (e.g., filtered by date
  range), it may exceed the broadcast threshold on some runs. Use AQE to handle this
  automatically.

## Databricks Features

### `spark.sql.autoBroadcastJoinThreshold`

Default is 10MB. Raise it for dimension tables slightly larger than 10MB:
```python
spark.conf.set("spark.sql.autoBroadcastJoinThreshold", "50m")
```
Small dimension tables (geography mappings, agent rosters, etc.) are typically well
under 50MB and should always be broadcast.

### Adaptive Query Execution (AQE)

Enabled by default on DBR 12+. AQE automatically converts sort-merge joins to broadcast
joins at runtime when it observes that one side is small enough after evaluating the query
plan. This means even without explicit `broadcast()` hints, Spark may choose broadcast joins.

```python
spark.conf.set("spark.sql.adaptive.enabled", "true")
spark.conf.set("spark.sql.adaptive.autoBroadcastJoinThreshold", "50m")
```

### `/*+ BROADCAST(table) */` SQL Hint

Alternative to `F.broadcast()` for SQL queries:
```sql
SELECT /*+ BROADCAST(small_table) */
    big.*, small_table.value
FROM big_table big
LEFT JOIN small_table ON big.key = small_table.key
```
Can also be used in CTEs:
```sql
WITH small AS (SELECT /*+ BROADCAST */ * FROM dim_geography)
SELECT * FROM train_features t LEFT JOIN small s ON t.zip = s.zipcode
```

### Photon's Optimized Broadcast Hash Join

On Photon-enabled clusters, broadcast hash joins use a vectorized C++ implementation
that is 2–3x faster than the standard Spark broadcast join. No code changes needed —
just use Photon runtime.

### Skew Join Hints

When broadcast isn't possible (both sides are large) but join keys are skewed:
```sql
SELECT /*+ SKEW('train_features', 'entity_id') */
    t.*, p.performance_bucket
FROM train_features t
JOIN performance_metrics p ON t.team_lead_id = p.team_id
```
Spark will automatically split skewed partitions into smaller sub-partitions for
parallel processing.
