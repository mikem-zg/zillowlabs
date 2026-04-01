# Serialization Avoidance

## What It Is

Minimizing format conversions between Pandas DataFrames and Spark DataFrames. Every
`.toPandas()` and `createDataFrame()` call serializes data across the Python↔JVM boundary.
This is often the single largest bottleneck in mixed Pandas/Spark pipelines.

## Why It Matters

A `spark.createDataFrame(pandas_df)` call on a large DataFrame (hundreds of thousands of
rows × dozens of columns) can take tens of minutes or more. Even with Arrow enabled,
serialization on a single-node cluster is slow because Arrow must serialize the entire
DataFrame through a single driver process.

**Rough speedup**: 10–100x by avoiding the conversion entirely (pure Spark SQL) or 3–5x
by adding worker nodes to parallelize Arrow serialization.

## How to Identify Opportunities

1. **`.toPandas()` calls**: Every `.toPandas()` pulls data from Spark executors to the
   driver, serializes via Arrow, and creates a Pandas DataFrame. If the data is only
   manipulated and then converted back to Spark, the round-trip is wasteful.

2. **`spark.createDataFrame(pandas_df)`**: Converts a Pandas DataFrame to Spark. This is
   the bottleneck in the merge step.

3. **Pandas operations between Spark reads and writes**: A common pattern reads period
   tables from Delta → `.toPandas()` → feature engineering in Pandas → `createDataFrame()`
   → `.saveAsTable()`. If the feature engineering could be done in Spark SQL, the Pandas
   round-trip is eliminated entirely.

## Before/After Examples

### Example 1: Eliminate the Pandas round-trip (the big win)

**Before** (typical merge step pattern):
```python
all_dfs = []
for eff_date, label in eval_dates:
    period_df = spark.sql(f"SELECT * FROM {table_name}").toPandas()
    all_dfs.append(period_df)
train = pd.concat(all_dfs, ignore_index=True)

train = add_feature_a(train, period_col='period')
train = add_feature_b(train, period_col='period')
# ... 20+ more feature functions ...

spark.conf.set("spark.sql.execution.arrow.pyspark.enabled", "true")
train_spark = spark.createDataFrame(train)  # <-- can take tens of minutes
train_spark.coalesce(4).write.mode("overwrite").saveAsTable(output_table)
```

**After** (pure Spark SQL — conceptual):
```python
train_spark = spark.sql(f"""
    SELECT * FROM {table_1}
    UNION ALL SELECT * FROM {table_2}
""")

train_spark = train_spark.withColumn(
    'metric_delta',
    F.col('current_value') - (F.col('cumulative_value') - F.col('current_value'))
)

window_entity = Window.partitionBy('entity_id', 'period')
train_spark = train_spark.withColumn(
    'entity_total', F.sum('current_value').over(window_entity)
)

train_spark.write.mode("overwrite").saveAsTable(output_table)
```
No `.toPandas()`, no `createDataFrame()`. The data stays in Spark throughout.

### Example 2: Avoid `.toPandas()` for simple lookups

**Before**:
```python
tgt_df = spark.sql(build_targets_query(eff_date)).toPandas()
tgt_map = tgt_df.set_index('entity_id')['target_value'].to_dict()
train.loc[mask, 'target_value'] = train.loc[mask, 'entity_id'].map(tgt_map)
```

**After** (Spark join):
```python
targets = spark.sql(build_targets_query(eff_date))
train_spark = train_spark.join(
    broadcast(targets.select("entity_id", "target_value")),
    on="entity_id", how="left"
).fillna({"target_value": 0})
```

### Example 3: Arrow configuration for unavoidable conversions

When `.toPandas()` or `createDataFrame()` is unavoidable, ensure Arrow is enabled:
```python
spark.conf.set("spark.sql.execution.arrow.pyspark.enabled", "true")
spark.conf.set("spark.sql.execution.arrow.pyspark.fallback.enabled", "true")
```
Without Arrow, the conversion uses Python pickling — 10–100x slower.

## Gotchas and When NOT to Use

- **Complex Pandas operations**: Some feature engineering functions use Pandas-specific
  operations that have no direct Spark equivalent (e.g., `pd.cut()`, complex `.apply()`
  with closure state, scipy functions). These require staying in Pandas.
- **Small DataFrames**: For DataFrames <10K rows, the serialization overhead is negligible
  (<1 second). Don't optimize these.
- **Debugging convenience**: Pandas DataFrames are easier to inspect interactively (print,
  `.head()`, `.describe()`). During development, the Pandas round-trip may be worth it
  for debugging speed.
- **Arrow compatibility**: Some data types don't serialize well with Arrow (e.g., nested
  structs, complex maps). If Arrow fails, it falls back to pickle (slow). The fallback
  setting (`arrow.pyspark.fallback.enabled`) handles this gracefully.
- **Memory**: `.toPandas()` brings the entire DataFrame into driver memory. For small
  datasets (<1GB), this is fine. For larger datasets (>10GB), it will OOM.

## Databricks Features

### Arrow-Based `.toPandas()`

10–100x faster Spark→Pandas conversion:
```python
spark.conf.set("spark.sql.execution.arrow.pyspark.enabled", "true")
```
Data stays in columnar Arrow format during transfer — no per-row serialization.

### Arrow-Based `createDataFrame()`

Same setting enables fast Pandas→Spark conversion:
```python
spark.conf.set("spark.sql.execution.arrow.pyspark.enabled", "true")
train_spark = spark.createDataFrame(pandas_df)
```
Even with Arrow, large DataFrames can take a long time on a single-node cluster because
Arrow serialization is single-threaded on the driver. Adding worker nodes would
parallelize this.

### Pandas UDFs with Arrow Serialization

Avoids per-row Python pickling entirely:
```python
@pandas_udf("float")
def compute_delta(current: pd.Series, prior: pd.Series) -> pd.Series:
    return current - prior

df = df.withColumn("delta", compute_delta(df.current_val, df.prior_val))
```
Data is transferred as Arrow batches — orders of magnitude faster than standard Python
UDFs that pickle each row individually.

### Delta Lake Columnar Format

Delta stores data in Parquet (columnar). Reading a subset of columns is efficient:
```python
spark.sql("SELECT entity_id, metric_value FROM big_table")
```
Only the requested columns are read from disk — no need to convert to row-based formats.
This is why `SELECT *` followed by Pandas column selection is wasteful.

### `pyspark.pandas` (Koalas)

Avoid `.toPandas()` entirely by staying in the Spark execution engine:
```python
import pyspark.pandas as ps
psdf = spark.sql("SELECT * FROM big_table").pandas_api()
psdf['delta'] = psdf['col_a'] - psdf['col_b']
psdf.to_spark().write.saveAsTable("output")
```
The Pandas API calls are translated to Spark operations internally — no data leaves the
JVM. Useful for simple Pandas operations (arithmetic, string manipulation, basic aggregation).
For complex operations (rolling windows with custom functions, scipy), regular Pandas may
still be needed.

### Serverless Compute Auto-Configuration

Databricks serverless pre-configures Arrow settings optimally:
- `spark.sql.execution.arrow.pyspark.enabled` = `true`
- `spark.sql.execution.arrow.pyspark.fallback.enabled` = `true`
- Optimal Arrow batch sizes for the instance type

No manual configuration needed on serverless.
