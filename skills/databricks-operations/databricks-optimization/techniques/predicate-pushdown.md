# Predicate Pushdown

## What It Is

Ensuring that filter conditions (`WHERE` clauses) are applied as early as possible in the
query plan — ideally at the storage layer — so that unnecessary data is never read from disk.

## Why It Matters

Delta Lake tables store per-file statistics (min/max values per column). When a filter can
be evaluated against these statistics, entire files are skipped without reading any rows.
A query filtering by date on a date-partitioned table may read 1/12th of the data instead
of the full table.

**Rough speedup**: 2–100x depending on selectivity and data layout.

## How to Identify Opportunities

1. **Filters applied after joins or transformations**: If a query joins two tables and then
   filters the result, the filter should be pushed before the join.

2. **`.toPandas()` followed by Pandas filtering**: Loading the full Spark DataFrame into
   Pandas and then filtering is the worst case — the filter should happen in Spark:
   ```python
   df = spark.sql("SELECT * FROM big_table").toPandas()
   df = df[df['date'] >= '2026-01-01']  # WRONG: filter should be in SQL
   ```

3. **Missing date filters in SQL queries**: Some queries scan broad date ranges when
   only recent data is needed.

4. **Check the Spark UI**: SQL tab → look for `FileScan` nodes. Compare "number of files
   read" vs "number of files after pruning". If most files are read, pushdown isn't
   working.

## Before/After Examples

### Example 1: Filter before .toPandas()

**Before**:
```python
period_df = spark.sql(f"SELECT * FROM {table_name}").toPandas()
period_df = period_df[period_df['entity_id'].isin(entity_list)]
```

**After**:
```python
entity_filter = ", ".join(f"'{a}'" for a in entity_list)
period_df = spark.sql(f"""
    SELECT * FROM {table_name}
    WHERE entity_id IN ({entity_filter})
""").toPandas()
```

### Example 2: Push filter before join

**Before**:
```sql
SELECT cf.*, dzm.regionid
FROM large_fact_table cf
LEFT JOIN dim_geography dzm ON cf.zip = dzm.zipcode
WHERE cf.created_date >= '2026-01-01'
  AND cf.lead_type = 'Connection'
```

**After** (explicit subquery to ensure pushdown):
```sql
WITH filtered_cf AS (
    SELECT * FROM large_fact_table
    WHERE created_date >= '2026-01-01'
      AND lead_type = 'Connection'
)
SELECT cf.*, dzm.regionid
FROM filtered_cf cf
LEFT JOIN dim_geography dzm ON cf.zip = dzm.zipcode
```
Note: Spark's optimizer usually does this automatically, but explicit CTEs make it certain.

### Example 3: Select only needed columns

**Before**:
```python
period_df = spark.sql(f"SELECT * FROM {table_name}").toPandas()
```

**After**:
```python
needed_cols = ", ".join(["entity_id", "zip", "metric_value", "tier_num", "score"])
period_df = spark.sql(f"SELECT {needed_cols} FROM {table_name}").toPandas()
```
Delta Lake's columnar format means unselected columns are never read from disk.

## Gotchas and When NOT to Use

- **Spark optimizer usually handles this**: For simple filters on base tables, Spark
  automatically pushes predicates down. Explicit pushdown is only needed for complex
  queries where the optimizer might not infer the optimization.
- **UDFs break pushdown**: If you apply a Python UDF and then filter on its result, Spark
  cannot push the filter below the UDF. Filter on raw columns first, then apply UDFs.
- **Non-deterministic functions**: Filters involving `rand()`, `current_timestamp()`, etc.
  cannot be pushed down because they must be evaluated at the row level.
- **Cross-database joins**: Filters on one side of a cross-database join may not be pushed
  to the other database's scan.

## Databricks Features

### Delta Lake Data Skipping

Automatic min/max statistics per file allow the engine to skip entire files:
```sql
SELECT * FROM my_delta_table WHERE date_col = '2026-01-01'
```
If a file's max `date_col` is '2025-12-31', the entire file is skipped. This works
automatically — no configuration needed. Works best when data is sorted or clustered
by the filtered column.

### `OPTIMIZE ... ZORDER BY (col)`

Colocates data by column values within files so predicate pushdown skips more files:
```sql
OPTIMIZE my_schema.my_table
ZORDER BY (period, entity_id)
```
After Z-ordering, a filter on `period` will skip most files because rows with the same
period are colocated. Run `OPTIMIZE` after major writes. Cost: one-time rewrite of
all files.

### Partition Pruning

Delta tables partitioned by date/period allow entire partitions to be skipped:
```sql
CREATE TABLE my_table (...)
PARTITIONED BY (period STRING)
```
A query with `WHERE period = 'Feb 2026'` reads only the `Feb 2026` partition directory.
Partitioning by the most common filter column (e.g., period or date) gives
instant pruning for filtered queries.

### Liquid Clustering (DBR 13.3+)

Automatic clustering without explicit partitioning or Z-ordering:
```sql
CREATE TABLE my_table (...) CLUSTER BY (period, entity_id)
```
Databricks automatically manages data layout for optimal predicate pushdown. No need
to manually run `OPTIMIZE ZORDER` — it happens incrementally on writes.

### `DESCRIBE DETAIL` and `DESCRIBE HISTORY`

Verify partition layout and optimization state:
```sql
DESCRIBE DETAIL my_schema.my_table
DESCRIBE HISTORY my_schema.my_table
```
`DESCRIBE DETAIL` shows number of files, size, partition columns. Check if the table
has too many small files (suggests `OPTIMIZE` is needed).

### Spark UI Metrics

In the Spark UI → SQL tab → select a query → look at the `FileScan` node:
- **number of files read**: How many files Spark actually read
- **number of files pruned**: How many files were skipped by data skipping
- **number of partitions read**: How many partitions were scanned

A well-optimized query should show "files pruned" >> "files read".
