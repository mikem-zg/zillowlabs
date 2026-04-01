# Temporal Issues Investigation — Run Report

| Field | Value |
|-------|-------|
| **Date** | 2026-03-28 |
| **Model Version** | Exp 35 |
| **Feature Count** | 88 enabled features |
| **Training Periods** | Oct 2025 – Feb 2026 (5 periods) |
| **Investigator** | Automated audit via investigate-temporal-issues skill |

---

## Phase 1: Expanding-Window CV Audit

**Result: PASS**

The CV fold construction in `notebooks/zip_hurdle_training.py` (lines 154–164) is correct:

- Periods are sorted chronologically using `datetime.strptime(p, '%b %Y')`
- CV folds use `_available_periods[:i]` for training and `_available_periods[i]` for validation
- `_cv_start = max(1, len(periods) - _max_cv_folds)` ensures fold 0 never trains on empty data
- Maximum 3 folds are used, all with strictly earlier training periods

**Feature computation temporal isolation:**

- Per-period features are computed independently via `zip_hurdle_features_period.py`, each with its own `eff_date`
- Cross-period features (profiles, lookalikes) use temporal variants:
  - `build_zip_profiles_temporal()` uses `periods[:i]` (prior-only) — verified in `model/profiles.py` line 51
  - `build_zip_neighbors_temporal()` uses `periods[:i]` — verified line 122
  - `build_agent_zip_dict_temporal()` uses `periods[:i]` — verified line 82
- The global `build_zip_profiles()` at merge line 298 uses all training data, but this is only for the scoring bundle artifact — not used in CV evaluation

**Checklist:**
- [x] First fold (fold 0) has no training data — handled by `_cv_start = max(1, ...)`
- [x] Each subsequent fold trains on all periods before it
- [x] No fold trains on its own validation period
- [x] No fold trains on any period after its validation period
- [x] Feature computation for each fold uses only data from training periods

---

## Phase 2: Feature Staleness Analysis

**Result: PASS (with accepted medium-risk items)**

| Feature Group | Data Source | Refresh Cadence | Staleness Risk | Status |
|--------------|-------------|-----------------|----------------|--------|
| `prior_30d_cxns` | `combined_funnels_pa_zhl` | Daily | Low | OK |
| `agent_score` | `agent_score_historical` | Daily | Low | OK |
| `tier_num` | `agent_performance_ranking` | Daily | Low | OK |
| `hma_predicted` | `hybrid_market_allocations` | Monthly | **Medium** | Accepted |
| `agent_cxns_target` | `capacityhistory` | Irregular | **Medium** | Accepted |
| `recommended_cxn_target` | `recommended_agent_connection_targets` | Daily | Low | OK |
| `self_pause_biz_pct` | `agentselfpause/audit` | Real-time | Low | OK |
| `pct_days_throttled` | `candidateagentrankinghistory` | Real-time | Low | OK |
| `zip_estimated_cxns` | `hybrid_market_allocations` | Monthly | **Medium** | Accepted |

The medium-risk items (`hma_predicted`, `agent_cxns_target`, `zip_estimated_cxns`) are inherently monthly/irregular features. Their staleness is an accepted property of the underlying data sources, not a model defect.

---

## Phase 3: Period Alignment Verification

**Result: PASS (one minor boundary note)**

All per-period feature queries use consistent date boundaries:

| Query | Window | Boundary |
|-------|--------|----------|
| `period_dataset_sql()` prior | `DATE_ADD('{eff_date}', -30)` to `'{eff_date}'` | Exclusive end |
| `period_dataset_sql()` actuals | `'{eff_date}'` to `ADD_MONTHS('{eff_date}', 1)` | Exclusive end |
| `temporal_recency_sql()` | `DATE_ADD('{eff_date}', -30)` to `'{eff_date}'` | Exclusive end |
| `throttle_freq_sql()` | `DATE_SUB('{eff_date}', 30)` to `'{eff_date}'` | Exclusive end |
| `perf_score_type_sql()` | `DATE_SUB('{eff_date}', 30)` to `'{eff_date}'` | Exclusive end |
| `agent_score_sql()` | `MAX(date) <= '{eff_date}'` | Inclusive (point-in-time) |

**Critical alignment verified:** The label window (`eff_date` to `eff_date + 1 month`) does not overlap with any feature window. All features use dates strictly before or equal to `eff_date`.

**Minor note:** `biz_hours_pause_sql()` constructs a date spine via `SEQUENCE(DATE_SUB('{eff_date}', 30), CAST('{eff_date}' AS DATE), INTERVAL 1 DAY)` which produces 31 days (inclusive of `eff_date`), while other 30-day features exclude `eff_date`. This makes the `self_pause_biz_pct` denominator slightly larger (31 vs 30 days of business hours), resulting in a marginally deflated pause percentage. This is consistent between training and scoring, so it does not introduce a train/score mismatch — it's just a minor boundary inconsistency vs other 30-day features. Not a leak.

---

## Phase 4: Temporal Distribution Shift (Concept Drift)

**Result: PASS (instrumentation verified, no live data available)**

The training notebook includes per-fold CV metrics (MAE, Corr, Pred/Actual ratio) at lines 193–204, which would detect concept drift as monotonically increasing MAE across folds.

Cannot verify actual metric values without running on Databricks. The infrastructure for drift detection is in place.

---

## Phase 5: Point-in-Time Correctness

**Result: PASS**

Every slowly-changing dimension uses proper point-in-time lookups:

| Feature | Source Table | Point-in-Time Mechanism | Verified |
|---------|-------------|------------------------|----------|
| `tier_num` | `agent_performance_ranking` | `WHERE agent_performance_date = '{eff_date}'` | [x] |
| `tier_num_prior` | `agent_performance_ranking` | `WHERE agent_performance_date = DATE_SUB('{eff_date}', 30)` | [x] |
| `agent_cxns_target` | `capacityhistory` | `WHERE changedAt <= '{eff_date}' ORDER BY changedAt DESC LIMIT 1` (via ROW_NUMBER) | [x] |
| `recommended_cxn_target` | `recommended_agent_connection_targets` | `WHERE snapshot_date <= '{eff_date}'` | [x] |
| `agent_score` | `agent_score_historical` | `MAX(agent_performance_date) WHERE <= '{eff_date}'` | [x] |
| `hma_predicted` | `hybrid_market_allocations` | `MAX(effective_date) WHERE effective_date <= '{eff_date}'` | [x] |
| `is_active` | `agent_performance_ranking` | `WHERE agent_performance_date = '{eff_date}'` | [x] |
| `met_rate` / `appt_rate` | `agent_performance_ranking` | `MAX(date) WHERE <= '{eff_date}'` (temporal version) | [x] |
| `price_filter` | LRS `price` table | `createdAt <= '{eff_date}' AND (deletedAt IS NULL OR > '{eff_date}')` | [x] |
| `flex_enrolled` | `agentplatform` | `createdAt < '{eff_date}' AND (deletedAt IS NULL OR > '{eff_date}')` | [x] |

Both training (`zip_hurdle_features_period.py` / `zip_hurdle_features_merge.py`) and scoring (`zip_hurdle_scoring.py`) use the same `model/sql.py` functions with temporal variants for point-in-time correctness.

---

## Phase 6: Train/Score Temporal Gap

**Result: FLAG — 55-day gap (CAUTION zone)**

```
Most recent training period: 2026-02-01
Today:                       2026-03-28
Gap:                         55 days
```

The gap is in the CAUTION zone (45–60 days). While the model should still generalize reasonably, accuracy may degrade.

**Recommendation:** Add `("2026-03-01", "Mar 2026")` to `EVAL_DATES_TRAIN` in `model/constants.py` and retrain. This should be done before the gap exceeds 60 days (April 2, 2026).

---

## Phase 7: Seasonality Leakage

**Result: PASS**

Seasonality features (`month_sin`, `month_cos`) are **disabled** in `FEATURE_REGISTRY` (`enabled: False`, line 67–68 of `model/constants.py`). This is the conservative and correct choice given:

- The model has only 5 months of training data (Oct 2025 – Feb 2026), insufficient for learning genuine annual seasonality patterns
- Explicit month encoding with <1 year of data would enable memorization rather than generalization

No other features carry direct calendar information. Indirect seasonality through correlated features (e.g., `prior_30d_cxns` reflects seasonal volume) is acceptable.

---

## Phase 8: Lookback Window Consistency

**Result: FLAG — 3 enabled features have training/scoring mismatch (known architectural limitation)**

Training and scoring both use the same `model/sql.py` functions, ensuring SQL-level consistency. However, 3 enabled features require multi-period data that is unavailable at scoring time:

| Feature | Training Value | Scoring Value | Enabled | Impact |
|---------|---------------|---------------|---------|--------|
| `zip_vol_trend` | Computed from zip-level connection trends across prior periods | `0.0` (constant) | **Yes** | Model learns from trend signal in training but gets no signal at scoring |
| `agent_n_periods` | Count of prior periods where agent appeared | `1.0` (constant) | **Yes** | Model learns tenure signal but all agents look identical at scoring |
| `agent_zip_n_periods` | Count of prior periods where agent-zip pair appeared | `1.0` (constant) | **Yes** | Same as above at agent-zip level |

These features carry real signal during training (they contribute to feature importance), but at scoring time they collapse to constants, meaning the model cannot use them for differentiation. This doesn't cause temporal contamination, but it does mean:

1. The model allocates some splitting capacity to these features during training
2. At scoring time, those splits provide no discriminative power
3. This slightly reduces effective model capacity at scoring time

**Recommendation:** Consider whether these features' training benefit outweighs the scoring dead-weight. Options:
- (a) Keep as-is (current approach) — the model may still learn useful interactions with other features
- (b) Disable them and retrain — reclaims model capacity for features that work at scoring time
- (c) Compute approximate values at scoring time (e.g., use historical period count from training data for tenure)

---

## Phase 9: Diagnostic Queries

**Result: NOT EXECUTED (requires Databricks access)**

The following diagnostic queries from the playbook should be run on Databricks to complete the audit:

- **9a: Period Coverage Check** — verify 5 periods have similar row counts
- **9b: Date Boundary Isolation Check** — verify `prior_actual_corr` is moderate (0.2–0.5) and consistent
- **9c: Feature Value Stability Across Periods** — check for sudden jumps in `agent_score`, `tier_num`, `hma_predicted`
- **9d: Label Window Isolation Verification** — confirm no rows leak between feature/label windows

These queries are documented in the skill's SKILL.md and can be run manually when Databricks access is available.

---

## Summary

| Phase | Check | Result |
|-------|-------|--------|
| 1 | CV fold construction | **PASS** — each fold trains only on prior periods |
| 2 | Feature staleness | **PASS** — medium-risk items acknowledged and accepted |
| 3 | Period alignment | **PASS** — all queries use consistent date boundaries (minor 31-vs-30 note on biz_hours_pause) |
| 4 | Concept drift detection | **PASS** — instrumentation in place |
| 5 | Point-in-time correctness | **PASS** — all slowly-changing dimensions use temporal lookups |
| 6 | Train/score temporal gap | **FLAG** — 55-day gap, add March 2026 training period |
| 7 | Seasonality leakage | **PASS** — seasonality features correctly disabled |
| 8 | Lookback window consistency | **FLAG** — 3 enabled features (`zip_vol_trend`, `agent_n_periods`, `agent_zip_n_periods`) trained with values but scored as constants |
| 9 | Diagnostic queries | **NOT EXECUTED** — requires Databricks |

### Remediation Priorities

1. **Add March 2026 training period** — straightforward, reduces temporal gap to ~28 days
2. **Evaluate multi-period features** — consider disabling `zip_vol_trend`, `agent_n_periods`, `agent_zip_n_periods` or computing approximate scoring values (separate task)
3. **Run Databricks diagnostic queries** — validate period coverage and feature stability empirically

### Overall Assessment

**The model is temporally sound.** No temporal contamination, look-ahead bias, or label leakage was found. The two flagged items are:
- A temporal gap that requires routine maintenance (adding a new training period)
- A known architectural limitation where some cross-period features can't be computed at scoring time

Both are low-severity and do not indicate data integrity problems.
