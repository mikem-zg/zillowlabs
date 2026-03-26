# Publish Model to Databricks

Step-by-step workflow for publishing the LightGBM Hurdle model training pipeline to Databricks as a runnable notebook.

## When to use

- After making changes to `train_zip_model.py` that should be reflected in the Databricks training notebook
- When setting up the notebook in Databricks for the first time
- When verifying the published notebook is in sync with local logic

## Prerequisites

- `DATABRICKS_HOST`, `DATABRICKS_TOKEN`, and `DATABRICKS_HTTP_PATH` environment variables must be set
- The model must train successfully locally before publishing (`python train_zip_model.py`)

## Publishing Workflow

### Step 1: Review local changes

Check what has changed in `train_zip_model.py` since the last notebook sync:

```bash
git diff train_zip_model.py
```

Identify which functions, features, or parameters changed. The notebook at `notebooks/zip_hurdle_training.py` must be manually updated to reflect these changes.

### Step 2: Sync changes into the notebook (MANUAL)

**This step is intentionally manual.** The notebook is NOT an auto-generated copy of `train_zip_model.py`. It is a Databricks-adapted mirror that:

- Reads from warehouse tables via `spark.sql()` instead of local Parquet files
- Uses `spark` context (available in Databricks) instead of `databricks-sql-connector`
- Writes predictions to `sandbox_pa.agent_ops.zip_hurdle_predictions` via `CREATE OR REPLACE TABLE`
- Includes documentation cells explaining each pipeline stage

**Key adaptation patterns:**

| Local (train_zip_model.py) | Databricks (notebook) |
|---|---|
| `pd.read_parquet('data_cache/file.parquet')` | `spark.sql("SELECT ... FROM table").toPandas()` |
| `from databricks import sql as dbsql` | Use `spark.sql()` directly |
| `pickle.dump(bundle, f)` | Write predictions to warehouse table |
| Feature lookup from local Parquet | Feature lookup via `spark.sql()` |

**What to sync:**
- New or changed feature engineering functions
- Changes to the feature list (`all_features`)
- Hyperparameter changes (`params` dict)
- Changes to the soft threshold alpha
- New data sources or lookup tables

**What NOT to sync:**
- Local file I/O (Parquet reads/writes)
- `databricks-sql-connector` usage
- Local model pickle saving
- `data_integrity` imports

### Step 3: Check sync status

Verify the local state before publishing:

```bash
python -m databricks sync-check
```

This shows whether notebooks have unpublished local changes (hash-based drift detection).

### Step 4: Publish notebooks to Databricks

```bash
python -m databricks publish notebooks
```

This uploads all `.py` files from `notebooks/` to the Databricks workspace via the Workspace API (`/api/2.0/workspace/import`). The default workspace path is `/Shared/predicted-connections/notebooks`.

To customize the workspace path, set `DATABRICKS_NOTEBOOKS_PATH` environment variable.

### Step 4b: Post the Run URL

When any publish or trigger command outputs a Databricks job/run URL, **always post the URL in chat** so the user can click through to monitor or inspect the job.

### Step 5: Verify the published notebook

After publishing, verify the notebook is accessible in Databricks:

1. Navigate to the Databricks workspace
2. Find the notebook at `/Shared/predicted-connections/notebooks/zip_hurdle_training`
3. Confirm all cells are present and the documentation is intact
4. Optionally run the notebook to verify it executes correctly

### Step 6: Confirm sync status

```bash
python -m databricks status
```

This shows both query sync and notebook sync status.

## Full publish (queries + notebooks)

To publish everything at once:

```bash
python -m databricks publish all
```

## Critical: Python-to-Databricks conversion gotchas

These are hard-won lessons from actual publish failures. Review every item when converting `train_zip_model.py` logic into the notebook.

### 1. Decimal types from Spark SQL

Spark SQL returns `Decimal` (not `float64`) for any numeric column with division, `COALESCE`, or `ROUND` in the query. Pandas cannot do arithmetic on Decimal columns — you'll get `InvalidOperation` errors (not a clear type error) inside functions like `groupby().transform()`.

**Fix:** Cast all numeric columns to `float64` immediately after `.toPandas()`:

```python
df = spark.sql(query).toPandas()
for c in df.columns:
    if c not in ('agent_zuid', 'zip', 'period', 'split'):
        df[c] = pd.to_numeric(df[c], errors='coerce').astype('float64')
```

Apply this to BOTH train and test data loading. The error surfaces deep in feature engineering (e.g., `add_competitive_quality`), not at load time, making it hard to diagnose.

### 2. Package installation on shared clusters

Shared clusters (e.g., `shared-edge`) do NOT have `lightgbm` pre-installed. The `%pip install` magic command doesn't reliably work in submitted runs (via the Jobs API). Use `subprocess` instead:

```python
import subprocess
subprocess.check_call(["pip", "install", "lightgbm", "--quiet"])
```

Place this in its own cell BEFORE the imports cell.

### 3. Do NOT use `dbutils.library.restartPython()`

In submitted runs on shared clusters, `restartPython()` kills the execution context and the run fails silently (empty error trace). Only use it in interactive notebook sessions, never in automated runs.

### 4. Cluster permissions

The service token may not have `CREATE CLUSTER` permission. Always use `existing_cluster_id` when submitting runs — never `new_cluster`. List available clusters via `/api/2.0/clusters/list` and pick a running shared cluster.

### 5. Notebook format: cell boundaries matter

Every function definition should be in the same cell as its first usage OR in a preceding cell. If a function is defined in cell N and called in cell N-1 (due to a copy-paste error), the notebook will fail with `NameError`.

### 6. String vs numeric column identity

`agent_zuid` and `zip` come from the warehouse as STRING. Do not cast them to numeric — they are join keys and may have leading zeros (ZIPs) or non-numeric patterns. Keep them as strings throughout.

### 7. Test locally before publishing

Always verify `train_zip_model.py` runs to completion locally before syncing changes into the notebook. The notebook mirrors the local logic — if local training fails, the notebook will too (plus additional Spark-specific issues).

### 8. Run verification after publish

After a successful notebook run, verify the output table:

```sql
SELECT experiment_name, run_timestamp, n_features,
       COUNT(*) as rows, COUNT(DISTINCT agent_zuid) as agents
FROM sandbox_pa.agent_ops.zip_hurdle_predictions
GROUP BY ALL
```

Compare row counts and agent counts against local training output to confirm parity.

## Notebook format reference

The notebook uses Databricks percent format:
- First line: `# Databricks notebook source`
- Cell delimiter: `# COMMAND ----------`
- Markdown cells: `# MAGIC %md` prefix on each line
- Python cells: regular Python code

## Output table schema

The notebook writes to `sandbox_pa.agent_ops.zip_hurdle_predictions`:

| Column | Type | Description |
|---|---|---|
| agent_zuid | STRING | Agent identifier |
| zip | STRING | ZIP code |
| predicted_cxns | DOUBLE | Hurdle model prediction |
| classifier_prob | DOUBLE | P(connections > 0) |
| experiment_name | STRING | E.g., "Exp 22b" |
| run_timestamp | STRING | ISO timestamp of the run |
| n_features | INT | Number of features used |
