---
name: add-data-signal
description: >
  Step-by-step workflow for adding a new data signal (feature) to the prediction model.
  Use when the user asks to add a new feature, signal, input variable, or data source to the model.
  Includes parallel review of all existing signals for continuous improvement.
  Also covers the pruning lifecycle — how features are tested, evaluated, and removed when they don't contribute.
evolving: true
last_reviewed: 2026-03-24
---

# Add Data Signal

End-to-end workflow for adding a new signal to the ZIP-level predicted connections model. Every time this skill is used, a parallel subagent reviews all existing signals for improvement opportunities.

Also covers feature pruning — how to evaluate, remove, and document features that don't help.

## When to Use

- User asks to add a new feature/signal/input to the model
- User identifies a new data source that should inform predictions
- User wants to capture a new behavioral pattern or business rule
- After a training run reveals zero-importance features (trigger pruning workflow)

## Architecture Overview

Adding a signal touches these layers:

| Layer | File(s) | What changes |
|-------|---------|-------------|
| Signal registry | `signals/<group>.json` | Schema, docs, metadata |
| Constants | `model/constants.py` | Feature list, count |
| Engineering | `model/features.py` | Computation function |
| Databricks query | `databricks/queries.py` | SQL to pull raw data |
| Training notebooks | `notebooks/zip_hurdle_features_period.py`, `notebooks/zip_hurdle_features_merge.py` | Feature pipeline (parallelized per-period + merge) |
| Scoring notebook | `notebooks/zip_hurdle_scoring.py` | Scoring pipeline |
| Dashboard | `app.py`, `pages/3_Feature_Exploration.py` | Display (auto via registry) |

## Step-by-Step Workflow

### Step 0: Parallel — Review Existing Signals

**Every time a new signal is added, delegate an async subagent to review all existing signals.** This ensures continuous improvement of signal documentation.

```javascript
await startAsyncSubagent({
    task: `Review all signal JSON files in signals/ for quality and completeness.
For each file, check:
1. Does "purpose" clearly explain the business meaning (not just technical)?
2. Are "data_sources" structured objects with table, description, and refresh_cadence?
3. Does every signal have a "business_meaning" that a non-technical person could understand?
4. Are "gotchas" comprehensive — include any known data quality issues, scale gotchas (0-1 vs 0-100), staleness risks, or edge cases?
5. Is "computation" present and accurate for derived signals?
6. Are "used_in" consumers complete (model_training, model_scoring, agent_diagnosis, simulator, etc.)?

Fix any gaps directly. Add missing fields. Improve vague descriptions.
Also check signals/__init__.py — does it expose all needed query functions?
Run validate_constants() against model/constants.py to ensure registry↔constants consistency.

CRITICAL GUARDRAILS:
- Do NOT modify model/constants.py — only review signal JSON files and signals/__init__.py.
- Do NOT add, remove, or re-add any features to *_FEATURES lists or ALL_FEATURES.
- Check model/pruned_features.json before suggesting any feature additions — features listed there were intentionally removed and must not be re-added without a new hypothesis.
- Your scope is DOCUMENTATION QUALITY ONLY — signal descriptions, business_meaning, gotchas, data_sources, computation fields.`,
    relevantFiles: [
        "signals/__init__.py",
        "signals/base.json",
        "signals/behavioral_deltas.json",
        "signals/competitive_quality.json",
        "signals/deltas.json",
        "signals/lookalikes.json",
        "signals/portfolio.json",
        "signals/seasonality.json",
        "signals/self_pause.json",
        "signals/targets.json",
        "signals/temporal_recency.json",
        "signals/tenure.json",
        "signals/throttle.json",
        "signals/volatility.json",
        "signals/zip_profiles.json",
        "model/pruned_features.json"
    ]
});
```

This runs in the background while you proceed with Steps 1–6.

### Step 1: Design the Signal

Before writing code, answer these questions:

1. **What does it measure?** Write a plain-English sentence a non-technical person would understand.
2. **Where does the data come from?** Identify source table(s), refresh cadence, and any known quality issues.
3. **How is it computed?** Write the formula or logic.
4. **What group does it belong to?** Existing group (e.g., "Target Features", "Base") or new group?
5. **What are the gotchas?** Scale (0-1 vs 0-100?), defaults, staleness, edge cases.
6. **What experiment will it ship in?** Use `added_in` field to track.

#### Default Value Design

Choose defaults carefully — they affect agents/ZIPs with missing data:

| Signal type | Good default | Why |
|-------------|-------------|-----|
| Count (e.g., connections in last 7d) | `0` | No data = no activity |
| Ratio / velocity (e.g., 7d vs 30d ratio) | `0` | Avoids implying momentum that doesn't exist |
| Days-since (e.g., days since last connection) | `30` (or period length) | Conveys "no recent activity" without extreme outlier |
| Binary flag (e.g., has_recent_activity) | `0` | No data = no |
| Share / percentage | `0` | No data = no share |

Document defaults in the signal JSON's `"default"` field and in the gotchas.

#### Databricks Run Time Impact

Adding signals that require per-period SQL (scanning large tables like `combined_funnels`) will increase feature preparation time on Databricks. Typical impact:
- Lookup table join (e.g., agent_score): +5-10s
- Per-period scan of a large table (e.g., combined_funnels): +30-60s
- Feature prep baseline (Exp 26): ~400s; Exp 27 with temporal queries: ~430s

This is normal — don't panic if the Databricks run takes longer after adding scan-heavy features.

### Step 2: Add to Signal Registry

If adding to an existing group, edit `signals/<group>.json`. If creating a new group, create a new JSON file.

**Required schema for each signal:**

```json
{
  "signal_name": {
    "description": "Technical description",
    "business_meaning": "Plain-English explanation for non-technical stakeholders",
    "dtype": "float32",
    "default": 0,
    "computation": "Formula or logic summary",
    "added_in": "Exp N"
  }
}
```

**Required schema for the group (top-level):**

```json
{
  "group": "Group Name",
  "purpose": "Plain-English: what this group measures and why it matters",
  "description": "Technical summary",
  "engineering_function": "function_name_in_features_py",
  "engineering_module": "model.features",
  "data_sources": [
    {
      "table": "schema.database.table_name",
      "description": "What this table provides",
      "refresh_cadence": "Daily / Monthly / Real-time / Derived"
    }
  ],
  "used_in": ["model_training", "model_scoring", ...],
  "gotchas": ["Known issue 1", "Known issue 2"],
  "signals": { ... }
}
```

### Step 3: Add to Constants

Edit `model/constants.py`:

1. Add the signal name to the appropriate `*_FEATURES` list (or create a new list).
2. If you created a new list, add it to the `ALL_FEATURES` concatenation.
3. Update the experiment name if this is part of a new experiment.

**Validation:** Run `validate_constants()` to verify registry↔constants consistency:

```python
from signals import validate_constants
from model.constants import ALL_FEATURES
result = validate_constants(ALL_FEATURES)
assert result["valid"], f"Mismatch: {result}"
```

### Step 4: Implement Feature Engineering

Edit `model/features.py`:

- If adding to an existing group, add computation logic to the existing `add_*` function.
- If creating a new group, write a new `add_<group>_features(df, ...)` function.

**Conventions:**
- Function takes `df` and returns modified copy: `o = df.copy(); ... return o`
- Use `.fillna(default)` for missing values
- Cast to float32: `.astype('float32')`
- Include `period_col='period'` parameter if computation varies by period

### Step 5: Wire into Databricks Pipelines

Three notebooks may need updates, plus `databricks/queries.py` for API cache:

**`notebooks/zip_hurdle_features_period.py`** (per-period feature prep):
- Add query for raw data if signal needs new source data with per-period date windows
- Call the engineering function in the per-period feature pipeline
- Uses `{eff_date}` templating for date-relative queries

**`notebooks/zip_hurdle_features_merge.py`** (cross-period merge):
- Add any cross-period feature engineering (e.g., deltas between periods)
- Add global features that don't vary by period (e.g., targets, self-pause)

**`notebooks/zip_hurdle_scoring.py`** (scoring):
- Same query + engineering call for the scoring path (using `current_date()` instead of `{eff_date}`)
- Verify signal appears in scoring DataFrame

**`databricks/queries.py`** (API cache):
- Add a cache query function for the new signal's data source
- This query runs at current-date (no period windows)

#### Training vs Scoring SQL — Critical Distinction

Many signals need **different SQL** for training vs scoring:

| Context | Date logic | Example |
|---------|-----------|---------|
| Training (features notebook) | Relative to each period's `eff_date` — e.g., "7 days before this period's start" | `WHERE cal_dt BETWEEN date_sub('{eff_date}', 37) AND date_sub('{eff_date}', 31)` |
| Scoring (scoring notebook) | Current date — "7 days before today" | `WHERE cal_dt BETWEEN date_sub(current_date(), 7) AND current_date()` |
| API cache (queries.py) | Current date, same as scoring | Same as scoring |

**Pattern for per-period training queries:** Use SQL CTEs that compute one result per `eff_date` period, then UNION ALL across periods. The features notebook iterates over periods and substitutes `{eff_date}` into the SQL template.

**Example (Exp 27 temporal recency):**
```sql
-- Training: per-period CTE (repeated for each eff_date)
WITH recency_{period_idx} AS (
  SELECT consolidated_agent_zuid,
         COUNT(*) as cxns_last_7d
  FROM mortgage.cross_domain_gold.combined_funnels_pa_zhl
  WHERE cal_dt BETWEEN date_sub('{eff_date}', 37) AND date_sub('{eff_date}', 31)
  GROUP BY 1
)

-- Scoring: current date, single query
SELECT consolidated_agent_zuid,
       COUNT(*) as cxns_last_7d
FROM mortgage.cross_domain_gold.combined_funnels_pa_zhl
WHERE cal_dt BETWEEN date_sub(current_date(), 7) AND current_date()
GROUP BY 1
```

**If your signal's SQL is the same for training and scoring** (e.g., it reads a slowly-changing lookup table), you can use the same query in both notebooks. But if it involves date-relative windows, you must write both variants.

### Step 5b: Run Databricks Training and Post URL

After syncing code and triggering a Databricks run (rapid or production), **always post the resulting Databricks run URL in chat** so the user can click through to monitor or inspect the job. The URL is returned in the `url` field of the result dict from `trigger_rapid()` or `trigger_and_wait()`.

### Step 5c: Evaluate CV Metrics

Training now runs temporal cross-validation (3 expanding-window folds) before the final model fit. Use CV metrics to evaluate the new signal:

- **CV MAE decreased** → signal is genuinely helping prediction on unseen data
- **CV MAE unchanged** → signal adds no value; consider pruning
- **Train MAE improved but CV MAE worsened** → overfitting — the model memorizes the signal's noise instead of learning real patterns. Prune or rethink.
- **CV std deviation increased significantly** → signal makes the model unstable across time periods

Always compare CV MAE (not just train MAE) when evaluating whether a new feature helps.

### Step 6: Local Sanity Check

Run `python scripts/train_zip_model.py` to verify the pipeline runs end-to-end.

**Important expectations:**
- Features that depend on per-period date windows (e.g., temporal recency, recent activity counts) **will show zero importance** in local training. This is expected — the local data cache is a single date snapshot, so all agents get the same value for date-relative features. The features will have proper values on Databricks where per-period SQL runs.
- The local check validates: no import errors, correct feature count, pipeline completes, no NaN explosions.
- Do NOT prune features based on local zero-importance alone — wait for Databricks results.

### Step 6b: Review Sample Weight Impact

After the Databricks run completes, check the sample weight strategy comparison in the training output. If the new feature primarily benefits a specific tier (e.g., only helps high-tier agents), the current sample weights may amplify or dampen its effect. Look for:

- Did the selected weight strategy change from the previous run?
- Did high-tier MAE improve more or less than expected?
- If the feature interacts with tier (e.g., a tier-specific behavioral signal), consider whether `TIER_WEIGHTS` in `model/constants.py` need adjustment.

This is usually fine with no changes needed — just a quick sanity check.

### Step 7: Verify

1. **Registry consistency:** `validate_constants(ALL_FEATURES)` returns valid
2. **App loads:** Restart the Streamlit app — feature group table and glossary should auto-populate
3. **Feature count:** `len(ALL_FEATURES)` matches expected count
4. **No import errors:** `python -c "from signals import get_all_features; print(len(get_all_features()))"`

### Step 7b: Check if Hyperparameter Tuning is Due

After adding a new signal, check whether the model's hyperparameters should be re-tuned. Read `.agents/skills/training-modes/references/tuning_log.json` and evaluate:

1. **Never tuned** (`last_tuned` is null) — suggest tuning
2. **Feature count changed significantly** — if `feature_count_at_tune` is 10+ features behind the current `len(ALL_FEATURES)`, suggest tuning
3. **Been a long time** — if `last_tuned` is more than 5 experiments ago (compare `last_tuned_experiment` to current `EXPERIMENT_NAME`), suggest tuning

If any condition is met, inform the user:
> "It's been a while since the model's hyperparameters were tuned (last tuned: {last_tuned_experiment} with {feature_count_at_tune} features, now at {current_count}). The optimal settings may have shifted. Would you like to run a tuning session? (`python -m databricks tune`)"

Do NOT run tuning automatically — just prompt the user. Tuning takes 15-30 minutes and is a separate decision.

### Step 8: Collect Background Review

Wait for the parallel signal review subagent from Step 0:

```javascript
await waitForBackgroundTasks();
```

Review its findings. Apply any fixes it identified to existing signals.

## Checklist

Before marking complete, verify:

- [ ] Signal JSON has all required fields (`purpose`, `data_sources`, `gotchas`, `business_meaning`, `computation`)
- [ ] `model/constants.py` updated with signal in correct `*_FEATURES` list
- [ ] `model/features.py` has engineering function (or existing function updated)
- [ ] `databricks/queries.py` has cache query if new data source needed
- [ ] All relevant notebooks updated (period features + merge + scoring) with correct date logic
- [ ] If date-relative feature: period notebook uses `{eff_date}` windows, scoring uses `current_date()`
- [ ] Default values documented in signal JSON and handled in `features.py` via `.fillna()`
- [ ] Local sanity check passes (`python scripts/train_zip_model.py`) — zero importance OK for date-relative features
- [ ] `validate_constants()` passes
- [ ] App loads without errors
- [ ] Parallel signal review completed and findings addressed (verify no feature list changes)
- [ ] Checked `tuning_log.json` and prompted user if re-tuning is due
- [ ] `replit.md` updated if feature count or architecture changed

## Example: Adding `recommended_cxn_target`

This signal was added in Exp 24 to the "Target Features" group:

1. **Registry:** Added to `signals/targets.json` with `business_meaning: "What the Zillow algorithm thinks this agent should receive"` and gotcha about no ZIP awareness
2. **Constants:** Added `'recommended_cxn_target'` to `TARGET_FEATURES` list
3. **Engineering:** Added lookup logic in `add_agent_target_features()` using `recommended_target_map`
4. **Query:** Added `recommended_targets` query to `databricks/queries.py` pulling from `premier_agent.agent_gold.recommended_agent_connection_targets`
5. **Notebooks:** Added query call + map construction in both training and scoring notebooks

---

## Feature Pruning Lifecycle

### Pruned Features Registry

File: `model/pruned_features.json`

This is the canonical record of every feature that was tried and removed. It prevents re-adding features that already failed, and captures the reasoning so future experiments can build on what we learned.

### Pruning Rules

| Condition | Action |
|-----------|--------|
| Feature importance = 0 in any training run | Prune immediately |
| Feature importance < `retention_threshold` (default: 10) in two consecutive experiments | Prune |
| Feature importance < `retention_threshold` in one experiment | Flag as candidate; monitor in next experiment |
| CV MAE worsened (higher) after adding the feature | Investigate — feature may cause overfitting |
| Train MAE improved but CV MAE worsened | Strong overfitting signal — prune or rethink |

### Pruning Workflow

After a training run (rapid or production):

1. **Check feature importance** from the training output or local model bundle
2. **Identify candidates**: features with importance < retention_threshold
3. **For each pruned feature, add to `model/pruned_features.json`:**

```json
{
  "feature": "feature_name",
  "group": "GROUP_NAME",
  "added_in": "Exp N",
  "pruned_in": "Exp M",
  "importance_at_prune": 0,
  "reason": "Why it didn't work (technical)",
  "hypothesis": "What we expected it to do",
  "verdict": "What the model already captures instead"
}
```

4. **Remove from `model/constants.py`** — delete from the group list
5. **Do NOT remove from `model/features.py`** — keep the computation code (it's harmless and may be needed for scoring backward compatibility). Just remove from the feature list so it's not used in training.
6. **Bump experiment name** (e.g., "Exp 24" → "Exp 25")
7. **Re-run rapid test** to confirm metrics hold or improve
8. **Update `model/pruned_features.json`** — set `last_updated` and `last_experiment`

### Key Principles

- **Always record hypothesis and verdict** — this prevents re-adding equivalent features
- **Keep computation code** — removing from constants is enough; deleting feature functions risks breaking scoring pipelines
- **Prune in batches** — do all pruning at once, then re-run. Don't prune one-by-one.
- **Check for redundancy** — correlated features split importance between them. If you suspect redundancy, try removing the older one instead of the newer one.
- **New hypothesis required for re-addition** — if someone wants to add back a pruned feature, they must explain why it would work differently this time
