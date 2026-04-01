# Caching & Memoization

## What It Is

Storing the results of expensive computations, query results, or intermediate DataFrames
so they can be reused without recomputation. This includes in-memory caching, disk caching,
and Spark-level DataFrame persistence.

## Why It Matters

The same groupby operations, SQL queries, and intermediate results are often
computed multiple times across different feature engineering functions. Caching eliminates
redundant work.

**Rough speedup**: 2–10x depending on the computation cost and reuse frequency.

## How to Identify Opportunities

1. **Repeated `.groupby().transform()` calls on the same columns**:
   Multiple feature functions group by `['entity_id', period_col]` or `['zip', period_col]`
   independently.

2. **Same SQL query called for multiple periods**:
   A parameterized query called once per period — results could be cached across the
   feature engineering session.

3. **Intermediate DataFrames recomputed on each function call**:
   `df.copy()` at the start of every feature function creates a full copy. When functions
   are chained, each copy includes all prior work.

4. **Query runner called with identical SQL**:
   If the same table/date range is queried in both data pull and feature engineering steps,
   the second call is wasted.

## Before/After Examples

### Example 1: Eliminating redundant `.copy()` in feature functions

**Before** (every function copies):
```python
def add_feature_a(df, period_col='period'):
    o = df.copy()
    # ... modify o ...
    return o

def add_feature_b(df, period_col='period'):
    o = df.copy()
    # ... modify o ...
    return o

train = add_feature_a(train)
train = add_feature_b(train)
```

**After** (in-place with explicit new column creation):
```python
def add_feature_a(df, period_col='period', inplace=False):
    o = df if inplace else df.copy()
    # ... modify o ...
    return o

train = add_feature_a(train, inplace=True)
train = add_feature_b(train, inplace=True)
```
Saves a full copy per function call, which adds up significantly with many chained functions.

### Example 2: Sharing groupby results across feature functions

**Before** (independent groupby in each function):
```python
def add_feature_a(df):
    at = df.groupby(['entity_id', 'period'])['metric_value'].transform('sum')
    ...

def add_feature_b(df):
    entity_total = df.groupby(['entity_id', 'period'])['metric_value'].transform('sum')
    ...
```

**After** (precompute and pass):
```python
entity_period_sums = df.groupby(['entity_id', 'period'])['metric_value'].transform('sum')
df['_entity_period_total'] = entity_period_sums

def add_feature_a(df):
    at = df['_entity_period_total']
    ...

def add_feature_b(df):
    entity_total = df['_entity_period_total']
    ...
```

### Example 3: File-based query result caching

**Before** (query every run):
```python
result = run_query(build_status_query(eff_date), "status")
```

**After** (cache with TTL):
```python
cache_path = Path(f"data_cache/status_{eff_date.replace('-','')}.parquet")
if cache_path.exists() and (time.time() - cache_path.stat().st_mtime) < 3600:
    result = pd.read_parquet(cache_path)
else:
    result = run_query(build_status_query(eff_date), "status")
    result.to_parquet(cache_path, index=False)
```

## Gotchas and When NOT to Use

- **Memory pressure**: Caching large DataFrames in memory can cause OOM. Use file-based
  caching for DataFrames that exceed available memory.
- **Stale caches**: Cached data can become stale if the underlying table is updated.
  Always include a TTL or explicit invalidation.
- **`.copy()` is sometimes necessary**: If a function modifies the DataFrame in ways that
  would corrupt downstream functions (e.g., dropping rows, renaming columns), the copy is
  needed.
- **Spark lazy evaluation**: Spark DataFrames are lazily evaluated — calling `.cache()` on
  a Spark DataFrame doesn't actually compute it until an action triggers evaluation.
  Always follow `.cache()` with a `.count()` or similar action to force materialization.

## Databricks Features

### `.persist(StorageLevel.MEMORY_AND_DISK)` vs `.cache()`

`.cache()` is a shorthand for `.persist(StorageLevel.MEMORY_AND_DISK_DESER)`.
For large DataFrames that may not fit in memory, use explicit persistence:
```python
from pyspark import StorageLevel
df.persist(StorageLevel.MEMORY_AND_DISK)
df.count()
# ... use df multiple times ...
df.unpersist()
```
**Critical**: Always call `.unpersist()` when done to free memory. Leaked persisted
DataFrames are a common cause of executor OOM errors.

### Delta Table Caching

For repeated reads of the same Delta table within a session:
```sql
CACHE SELECT * FROM my_schema.my_table
```
This loads the entire table into the cluster's memory. Subsequent queries against the
cached table skip disk I/O entirely.

### Databricks Disk Caching

Automatically enabled on SSD-backed instances (e.g., `i3.*`).
Remote Parquet/Delta files are transparently cached on local NVMe SSDs after first read.
No configuration needed — it's automatic on SSD-backed instances.

Verify it's working via the Spark UI → Storage tab → "Disk bytes spilled" should be minimal.

### `spark.catalog.cacheTable()`

Session-level table caching:
```python
spark.catalog.cacheTable("my_schema.my_table")
# ... run multiple queries against the table ...
spark.catalog.uncacheTable("my_schema.my_table")
```
Persists across multiple `spark.sql()` calls within the same notebook.

### Databricks Results Cache (SQL Warehouse)

For SQL Warehouse endpoints, identical queries
within 24 hours return cached results instantly. This is automatic — no configuration needed.
Caching is per-warehouse, so different users hitting the same warehouse benefit from each
other's cached queries.

### Temporary Views

For intermediate results reused across notebook cells:
```python
df.createOrReplaceTempView("enriched_entities")
spark.sql("SELECT * FROM enriched_entities WHERE tier_num = 2")
spark.sql("SELECT entity_id, COUNT(*) FROM enriched_entities GROUP BY entity_id")
```
Lightweight in-session caching — no disk I/O, no persistence overhead. The view is
re-evaluated on each query but the query plan is cached.
