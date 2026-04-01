# Data Structures & Indexing

## What It Is

Choosing the right data structures, indexes, and partition configurations for efficient
lookups, joins, and aggregations — both in Python (dicts, sets, NumPy arrays) and in
Spark (shuffle partitions, bloom filters, Delta statistics).

## Why It Matters

Algorithm complexity matters more than micro-optimization. An O(n²) nested loop over two
DataFrames is fundamentally slower than an O(n) hash join, regardless of how well the
loop is vectorized. Similarly, Spark's default 200 shuffle partitions is often wrong —
too many for small datasets (excessive scheduling overhead) or too few for large datasets
(memory pressure per partition).

**Rough speedup**: 2–20x depending on the data size and the complexity improvement.

## How to Identify Opportunities

1. **Dict lookups replacing DataFrame merges**: When only looking up a single column by key,
   `.set_index(key)[col].to_dict()` + `.map(dict)` is faster than `.merge()`.

2. **Nested loops over DataFrames**: `for a in agents: for z in zips:` is O(agents × zips).
   Restructure as a single groupby or merge.

3. **Shuffle partition count**: Default `spark.sql.shuffle.partitions = 200`. For small
   training data, 200 partitions can mean very few rows per partition — too many partitions
   with too much scheduling overhead.

4. **Small file problem**: After many incremental writes to a Delta table, files may be
   too small (< 1MB each), causing excessive file-open overhead during reads.

## Before/After Examples

### Example 1: Vectorized agent tenure (replacing nested loop)

**Before** (nested loop with dict lookups):
```python
for i in range(len(o)):
    a, z, r, p = agents[i], zips[i], ranks[i], periods[i]
    ap = agent_periods.get(a, set())
    agent_n[i] = sum(1 for pp in ap if period_rank.get(pp, 999) < r)
    azp = agent_zip_periods.get((a, z), set())
    az_n[i] = sum(1 for pp in azp if period_rank.get(pp, 999) < r)
```

**After** (merge-based):
```python
agent_tenure = (
    o.groupby('entity_id')
    .apply(lambda g: g.assign(
        entity_n_periods=g['_period_rank'].rank(method='min') - 1
    ))
)
entity_zip_tenure = (
    o.groupby(['entity_id', 'zip'])
    .apply(lambda g: g.assign(
        entity_zip_n_periods=g['_period_rank'].rank(method='min') - 1
    ))
)
```

### Example 2: Set-based lookups for membership testing

**Before**:
```python
mkt_ops_team_leads = list(mkt_ops_df['team_lead_zuid'])
agents_df = agents_df[agents_df['team_lead_zuid'].isin(mkt_ops_team_leads)]
```

**After** (explicit set for O(1) lookups):
```python
mkt_ops_team_leads = set(mkt_ops_df['team_lead_zuid'])
agents_df = agents_df[agents_df['team_lead_zuid'].isin(mkt_ops_team_leads)]
```
Note: Pandas `.isin()` internally converts lists to sets, but passing a set is faster
because it skips the conversion.

### Example 3: Pre-indexed lookup vs repeated DataFrame filtering

**Before**:
```python
for eff_date, label in eval_dates:
    mask = train['period'] == label
    period_data = train.loc[mask]
```

**After** (pre-index for O(1) group access):
```python
grouped = {label: group for label, group in train.groupby('period')}
for eff_date, label in eval_dates:
    period_data = grouped[label]
```

## Gotchas and When NOT to Use

- **Over-indexing**: Building elaborate index structures for data that's only accessed once
  adds overhead without benefit.
- **Memory vs speed tradeoff**: Dict-based lookups trade memory for speed. A dict mapping
  tens of thousands of entities to their features is typically fine. A dict mapping hundreds
  of thousands of composite keys to full feature vectors may use too much memory — consider alternatives.
- **Spark partition sizing**: Target 100MB–200MB per partition for optimal performance.
  Adjust partition count based on total data size.
- **Premature optimization**: Don't optimize data structures for code that runs once
  during pipeline setup. Focus on code that runs in the hot path (inner loops, per-lead
  scoring, per-row feature computation).

## Databricks Features

### Bloom Filter Indexes on Delta Tables

For point lookups on high-cardinality columns:
```sql
CREATE BLOOMFILTER INDEX ON my_schema.my_table
FOR COLUMNS (entity_id)
```
A bloom filter index allows the engine to skip entire files when filtering by
`entity_id = 'X'` — it tells the engine "this file definitely does NOT contain X"
without reading the file. Useful for ad-hoc agent lookups against large tables.

### Delta Lake Column Statistics

Delta automatically maintains min/max statistics for the first 32 columns of each file.
These act as an automatic "index" — queries filtering on these columns benefit from data
skipping without any explicit index creation.

To check which columns have statistics:
```sql
DESCRIBE DETAIL my_schema.my_table
```

### `OPTIMIZE` with File Compaction

Compacts small files into larger ones for faster scans:
```sql
OPTIMIZE my_schema.my_table
```
Reduces file-open overhead. Target file size is ~1GB by default.

### Photon's Vectorized Hash Table

On Photon-enabled clusters, hash joins and aggregations use a vectorized C++ hash table
implementation that is 2–3x faster than the standard Spark hash table. Benefits:
- Faster `GROUP BY` aggregations
- Faster hash joins (both broadcast and shuffle)
- Faster `DISTINCT` operations

No code changes needed — automatic on Photon runtime.

### `spark.sql.shuffle.partitions` Tuning

Default 200 is rarely optimal:
```python
spark.conf.set("spark.sql.shuffle.partitions", "20")
```

Rules of thumb:
- Data < 1GB: 10–20 partitions
- Data 1–10GB: 50–100 partitions
- Data 10–100GB: 200–500 partitions
- Data > 100GB: 500–2000 partitions

Target ~100MB per partition. Use `.coalesce()` for writes but remember that shuffle
operations during transformations may still use the default partition count.

### AQE Auto-Coalesce

With AQE enabled (default on DBR 12+), Spark automatically coalesces small shuffle
partitions at runtime:
```python
spark.conf.set("spark.sql.adaptive.enabled", "true")
spark.conf.set("spark.sql.adaptive.coalescePartitions.enabled", "true")
```
This handles the "too many small partitions" problem automatically without manually
tuning `spark.sql.shuffle.partitions`.
