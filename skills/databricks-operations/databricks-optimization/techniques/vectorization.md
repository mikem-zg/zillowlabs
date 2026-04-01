# Vectorization

## What It Is

Replacing row-by-row Python iteration (`.iterrows()`, `.apply(lambda)`, `for i in range(len(...))`)
with native Pandas/NumPy/Spark column operations that execute in optimized C/Fortran/JVM code.

## Why It Matters

Python loops over DataFrame rows are 10–100x slower than vectorized equivalents because:
- Each iteration crosses the Python↔C boundary
- No SIMD/CPU vectorization
- No memory locality optimization
- GIL contention in multi-threaded contexts

**Rough speedup**: 10–100x for numeric operations, 5–20x for string/categorical operations.

## How to Identify Opportunities

Search for these patterns in the codebase:

```
.iterrows()
.apply(lambda
for i in range(len(
for _, row in        — same as .iterrows()
```

Common high-impact targets include:
- `.iterrows()` loops building lookup dicts from DataFrames (especially in hot paths like simulation or scoring)
- `for i in range(len(...))` loops building group dictionaries
- `.iterrows()` loops building agent-keyed or entity-keyed maps from aggregation results

## Before/After Examples

### Example 1: Building a dict from DataFrame rows

**Before** (building a map from aggregation results):
```python
m = {}
for _, row in agg.iterrows():
    aid = str(row['entity_id'])
    m[aid] = {
        'yes': float(row['yes_count']),
        'total': float(row['total_count']),
        'region': int(region_map.get(row['entity_id'], -1)),
    }
```

**After** (vectorized):
```python
agg['entity_id_str'] = agg['entity_id'].astype(str)
agg['region'] = agg['entity_id'].map(region_map).fillna(-1).astype(int)
m = dict(zip(
    agg['entity_id_str'],
    agg[['yes_count', 'total_count', 'region']].rename(
        columns={'yes_count': 'yes', 'total_count': 'total'}
    ).to_dict('records')
))
```

### Example 2: Building lookup structures from a DataFrame

**Before** (building lookup structures from a DataFrame):
```python
zip_agent_idx = {}
for _, row in agents.iterrows():
    zp = str(row['zip'])
    idx = id_to_idx[row['entity_id']]
    if zp not in zip_agent_idx:
        zip_agent_idx[zp] = []
    zip_agent_idx[zp].append(idx)
```

**After** (vectorized):
```python
agents['_idx'] = agents['entity_id'].map(id_to_idx)
zip_agent_idx = (
    agents.groupby('zip')['_idx']
    .apply(lambda x: np.array(sorted(x.unique()), dtype=np.int32))
    .to_dict()
)
agents.drop(columns=['_idx'], inplace=True)
```

### Example 3: MSA grouping loop

**Before** (grouping loop):
```python
msa_groups = {}
for i in range(len(agent_yes)):
    msa = agent_msa[i]
    if msa not in msa_groups:
        msa_groups[msa] = {'yes': [], 'total': [], 'indices': []}
    msa_groups[msa]['yes'].append(agent_yes[i])
    msa_groups[msa]['total'].append(agent_total[i])
    msa_groups[msa]['indices'].append(i)
```

**After** (vectorized with pandas groupby):
```python
df_temp = pd.DataFrame({
    'yes': agent_yes, 'total': agent_total, 'msa': agent_msa,
    'idx': np.arange(len(agent_yes))
})
msa_groups = {
    msa: {
        'yes': grp['yes'].values,
        'total': grp['total'].values,
        'indices': grp['idx'].values,
    }
    for msa, grp in df_temp.groupby('msa')
}
```

### Example 4: `.apply(lambda)` for type conversion

**Before** (type conversion with apply):
```python
if not df[col].empty and df[col].apply(lambda x: isinstance(x, decimal.Decimal)).any():
    df[col] = df[col].apply(lambda x: float(x) if isinstance(x, decimal.Decimal) else x)
```

**After** (vectorized):
```python
if not df[col].empty:
    df[col] = pd.to_numeric(df[col], errors='coerce')
```

## Gotchas and When NOT to Use

- **String operations**: `.str` accessor methods are already vectorized in Pandas — don't
  convert them to list comprehensions.
- **Complex conditional logic**: If the logic has many branches and side effects, a vectorized
  version using `np.where()` chains may be less readable. Use `np.select()` for multi-branch.
- **Small DataFrames** (<100 rows): The overhead of vectorization setup may exceed the loop
  cost. Not worth optimizing.
- **Side effects**: If the loop modifies external state (writing files, API calls), it cannot
  be vectorized.
- **`.to_dict('records')`**: This is itself an `.iterrows()` under the hood for large
  DataFrames. For building simple key→value maps, prefer `.set_index(key_col)[val_col].to_dict()`.

## Databricks Features

### Pandas API on Spark (`pyspark.pandas`)

Drop-in Pandas syntax that runs distributed on Spark. Import as:
```python
import pyspark.pandas as ps
psdf = ps.from_pandas(pdf)
psdf['new_col'] = psdf['col_a'] + psdf['col_b']
result = psdf.to_pandas()
```
Useful when DataFrame is too large for single-node Pandas but the code uses Pandas idioms.
Available on all Databricks runtimes. Avoids rewriting to PySpark DataFrame API.

### `applyInPandas()` / `mapInPandas()`

For grouped operations that must stay in Pandas (e.g., custom statistical functions):
```python
def process_group(pdf: pd.DataFrame) -> pd.DataFrame:
    pdf['result'] = pdf['value'].rolling(3).mean()
    return pdf

spark_df.groupBy('entity_id').applyInPandas(process_group, schema=output_schema)
```
Each group runs as a vectorized Pandas operation — no row-at-a-time overhead.
The key advantage: you write Pandas code but it runs distributed across the cluster.

### Pandas UDFs (`@pandas_udf`)

10–100x faster than row-at-a-time Python UDFs. Uses Apache Arrow for data transfer:
```python
from pyspark.sql.functions import pandas_udf
import pandas as pd

@pandas_udf("float")
def smooth_ratio(numerator: pd.Series, denominator: pd.Series) -> pd.Series:
    alpha, beta = 1.0, 1.0
    return (numerator + alpha) / (denominator + alpha + beta)

df = df.withColumn("smoothed", smooth_ratio(df.yes_count, df.total_count))
```
Arrow-backed transfer means data stays columnar — no per-row Python pickling.

### Photon Engine Auto-Vectorization

On Photon-enabled clusters, SQL and DataFrame operations are automatically vectorized
using a C++ execution engine. No code changes needed — just use Photon runtime:
```python
"spark_version": "15.4.x-photon-scala2.12"
```
Photon accelerates: filters, aggregations, joins, sorts, window functions.
Switch to Photon-compatible instance types (`m5d.*`/`c5d.*`) with Photon runtime
for automatic vectorization of Spark operations.

### Arrow-Optimized `.toPandas()` and `createDataFrame()`

Enable Arrow for 10–100x faster Spark↔Pandas conversion:
```python
spark.conf.set("spark.sql.execution.arrow.pyspark.enabled", "true")
```
See `techniques/serialization-avoidance.md` for detailed coverage.
