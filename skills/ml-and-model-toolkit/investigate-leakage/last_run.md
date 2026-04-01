# Leakage Investigation Report

- **Date:** 2026-03-28
- **Model Version:** Exp 35 (88 features, 68 enabled)
- **Investigator:** Agent (automated audit)
- **Method:** Static code audit of all SQL queries, feature functions, profile builders, and scoring pipeline

---

## Phase 1: Feature-Target Correlation Audit

**Result: NOT EXECUTABLE (code audit only)**

No local training data (`data_cache/eval_mktops_train.parquet`) is available in this environment. Correlation analysis requires a Databricks execution context or cached data.

**Recommendation:** Run the Phase 1 correlation script in the next Databricks training run and verify no feature exceeds |pearson| > 0.85.

---

## Phase 2: Target Leakage Check — SQL Date Boundaries

**Result: PASS**

Every SQL query function in `model/sql.py` was audited for date boundary correctness. All feature lookback windows use strict `< '{eff_date}'` (exclusive upper bound). The only query referencing dates `>= '{eff_date}'` is the `actuals` CTE, which computes the label.

| Query Function | Date Boundary | Verdict |
|---|---|---|
| `period_dataset_sql()` — `mkt_ops_zips` | `contact_creation_date < '{eff_date}'` | PASS |
| `period_dataset_sql()` — `prior_actuals` | `contact_creation_date < '{eff_date}'` | PASS |
| `period_dataset_sql()` — `prior_agent` | `contact_creation_date < '{eff_date}'` | PASS |
| `period_dataset_sql()` — `prior_zip` | `contact_creation_date < '{eff_date}'` | PASS |
| `period_dataset_sql()` — `prior_60d_agent_zip` | `contact_creation_date < '{eff_date}'` | PASS |
| `period_dataset_sql()` — `actuals` (LABEL) | `>= '{eff_date}' AND < ADD_MONTHS('{eff_date}', 1)` | PASS (this IS the target) |
| `period_dataset_sql()` — `hma` | `effective_date <= '{eff_date}'` | PASS (point-in-time) |
| `period_dataset_sql()` — `flex_enrolled` | `createdAt < '{eff_date}'` | PASS |
| `period_dataset_sql()` — `perf` | `agent_performance_date = '{eff_date}'` | PASS (point-in-time) |
| `period_dataset_sql()` — `perf_prior` | `agent_performance_date = DATE_SUB('{eff_date}', 30)` | PASS |
| `biz_hours_pause_sql()` — `pause_events` | `a.eventDate < '{eff_date}'` | PASS |
| `biz_hours_pause_sql()` — `date_spine` | `DATE_SUB(30)` to `'{eff_date}'` inclusive | PASS (note below) |
| `prior_biz_hours_pause_sql()` — `pause_events` | `a.eventDate < DATE_SUB('{eff_date}', 30)` | PASS |
| `throttle_freq_sql()` | `RequestedAt < '{eff_date}'` | PASS |
| `perf_score_type_sql()` | `RequestedAt < '{eff_date}'` | PASS |
| `temporal_recency_sql()` | `contact_creation_date < '{eff_date}'` | PASS |
| `agent_score_sql()` | `agent_performance_date <= '{eff_date}'` | PASS (point-in-time) |
| `prior_agent_score_sql()` | `agent_performance_date <= DATE_SUB('{eff_date}', 30)` | PASS |
| `zip_tier_distribution_sql()` | `contact_creation_date < '{eff_date}'` | PASS |
| `prior_zip_tier_distribution_sql()` | `< DATE_ADD('{eff_date}', -30)` | PASS |
| `self_pause_sql()` | `a.eventDate < '{eff_date}'` | PASS |
| `targets_temporal_sql()` | `ch.changedAt <= '{eff_date}'` | PASS (point-in-time) |
| `recommended_targets_temporal_sql()` | `snapshot_date <= '{eff_date}'` | PASS (point-in-time) |
| `met_appt_temporal_sql()` | `agent_performance_date <= '{eff_date}'` | PASS (point-in-time) |
| `price_filter_temporal_sql()` | `createdAt/updatedAt <= '{eff_date}'` | PASS (point-in-time) |
| `broadcast_sql()` | `created_at < '{eff_date}'` | PASS |
| `isa_sql()` | No date filter (slowly-changing dimension) | PASS |
| `implied_unavail_sql()` | `contact_creation_date < '{eff_date}'` | PASS |

**Note on `biz_hours_pause_sql()` date_spine:** The SEQUENCE generates days from `eff_date - 30` to `eff_date` inclusive (31 days). This means business hours include `eff_date` itself. However, the `pause_events` CTE filters `eventDate < '{eff_date}'`, so no future pause events are included. The overlap computation counts business hours on `eff_date` that were covered by pauses started before `eff_date`, which is correct — it measures the agent's pause state on the morning of `eff_date`.

---

## Phase 3: Lookalike / Profile Contamination

**Result: PASS**

All three temporal builder functions use strictly prior-period data:

| Function | Period Selection | Verdict |
|---|---|---|
| `build_zip_profiles_temporal()` | `prior_periods = periods[:i]` (strictly earlier) | PASS |
| `build_zip_neighbors_temporal()` | `prior_periods = periods[:i]` (strictly earlier) | PASS |
| `build_agent_zip_dict_temporal()` | `prior_periods = periods[:i]` (strictly earlier) | PASS |

For the first period, all three return zeros/empty dicts, which is correct (no prior data available).

**Global (non-temporal) artifacts:** `build_zip_profiles(train)`, `build_zip_neighbors()`, and `build_agent_zip_dict(train)` are built from ALL training data including all periods. These are saved in the model bundle and used only at scoring time (not during training). At training time, the temporal versions are used. This is correct.

**Important detail:** `build_agent_zip_dict()` uses `actual_cxns` (the target variable) to compute agent-ZIP average connections. This is legitimate because it uses only prior-period data (via the temporal wrapper) — the target values from prior periods are known historical facts, not future information.

---

## Phase 4: Compound Feature Leakage

**Result: PASS**

All compound features in `add_compound_features()` (model/features.py:1369) were traced back to their base features:

| Compound Feature | Base Inputs | Leakage Risk |
|---|---|---|
| `answer_rate_vs_comp` | `answer_rate`, `zip_comp_avg_answer` | None — both from performance ranking at `eff_date` |
| `cvr_vs_comp` | `cvr`, `zip_comp_avg_cvr` | None — same source |
| `tier_advantage` | `tier_num`, `zip_comp_avg_tier` | None |
| `score_x_tier_gap` | `agent_score`, `tier_advantage` | None — `agent_score` uses `<= eff_date` |
| `headroom_x_score` | `thr_headroom`, `agent_score` | None |
| `throttle_x_pause` | `thr_ratio`, `self_pause_pct` | None — both from `< eff_date` |
| `concentration_x_volatility` | `agent_hhi`, `zip_vol_cv` | None — HHI from prior cxns, vol from prior periods |
| `top_zip_x_trend` | `agent_top_zip_share`, `zip_vol_trend` | None |
| `days_cold_x_share` | `agent_days_since_last_cxn`, `zip_agent_share` | None — recency uses `< eff_date` |
| `connection_momentum_ratio` | `prior_30d_cxns`, `prior_60d_cxns` | None — both from `< eff_date` |
| `delta_x_inverse_competition` | `agent_zip_cxn_delta`, `zip_prior_agents` | None |
| `target_vs_fair_share` | `agent_cxns_target`, `zip_prior_total`, `zip_prior_agents` | None |
| `engagement_index` | `answer_rate`, `pickup_rate`, `self_pause_pct` | None |
| `price_breadth_x_share` | `price_range_breadth`, `agent_zip_share` | None |
| `prediction_overreach_ratio` | `hma_predicted`, `prior_30d_cxns` | None |
| `prior_period_dropout` | `prior_30d_cxns`, `prior_60d_cxns` | None |
| `agent_cxns_7d_30d_ratio` | `agent_cxns_last_7d`, `agent_cxns_last_30d` | None — temporal recency uses `< eff_date` |
| `engagement_x_target_share` | `engagement_index`, `agent_cxns_target`, `zip_estimated_cxns` | None |

No compound feature uses a leaky base feature.

---

## Phase 5: Delta Feature Leakage

**Result: PASS**

All delta features compare values from two prior windows, neither of which overlaps the label window.

| Delta Feature | Current Window | Prior Window | Overlap with Label? |
|---|---|---|---|
| `agent_zip_cxn_delta` | `prior_30d_cxns` (eff-30 to eff) | `prior_60d_cxns - prior_30d_cxns` (eff-60 to eff-30) | No |
| `agent_total_delta` | Same aggregation | Same | No |
| `zip_total_delta` | Same aggregation | Same | No |
| `zip_agent_share_delta` | Same | Same | No |
| `hma_predicted_delta` | HMA at eff_date | HMA at prior period (shift or prior_hma_sql) | No |
| `zip_pct_high_delta` / `zip_pct_low_delta` | zip_tier_distribution_sql (eff-30 to eff) | prior_zip_tier_distribution_sql (eff-60 to eff-30) | No |
| `pause_biz_pct_delta` | biz_hours_pause_sql (eff-30 to eff) | prior_biz_hours_pause_sql (eff-60 to eff-30) | No |
| `pct_broadcast_delta` | broadcast_sql per period | Prior period shift | No |
| `agent_score_30d_delta` | agent_score_sql (<= eff) | prior_agent_score_sql (<= eff-30) | No |
| `tier_delta` | perf at eff_date | perf_prior at eff_date-30 | No |
| `cvr_30d_delta` | cvr at eff_date | cvr_prior at eff_date-30 | No |

---

## Phase 6: Scoring vs Training Parity

**Result: FLAG (distribution mismatch, not leakage)**

The scoring notebook (`notebooks/zip_hurdle_scoring.py`) uses the same `model/sql.py` functions and `model/features.py` feature engineering as training, with appropriate substitution of `current_date()` for `eff_date`. However, several features have a train/score distribution mismatch:

| Feature | Training Value | Scoring Value | Impact |
|---|---|---|---|
| `zip_vol_cv` | Computed from cross-period CV | `0` (hardcoded) | DISABLED — no impact |
| `zip_vol_trend` | Computed from cross-period slope | `0` (hardcoded) | ENABLED — model sees non-trivial values in training but always 0 at scoring |
| `agent_n_periods` | Count of prior periods with data | `1` (hardcoded) | ENABLED — model sees 0-4 in training but always 1 at scoring |
| `agent_zip_n_periods` | Count of prior periods per agent-zip | `1` (hardcoded) | ENABLED — same issue |
| `pct_broadcast_delta` | Computed per-period shift | `0` (hardcoded) | DISABLED — no impact |
| `zip_profile_avg_cxns_delta` | Computed per-period shift | `0` (hardcoded) | Not in FEATURE_REGISTRY as enabled |
| `lookalike_avg_delta` | Computed per-period shift | `0` (hardcoded) | Not in FEATURE_REGISTRY as enabled |

**Assessment:** This is NOT leakage — the scoring pipeline cannot compute cross-period features from a single scoring run. However, `zip_vol_trend`, `agent_n_periods`, and `agent_zip_n_periods` are enabled features with different distributions at training vs scoring time. The model may learn to rely on these features in training but find them uninformative (constant) at scoring time.

**Recommendation:** Consider:
1. Disabling `zip_vol_trend`, `agent_n_periods`, `agent_zip_n_periods` since they degrade to constants at score time, OR
2. Setting them to their training-set median values at scoring time instead of arbitrary constants.

---

## Phase 7: Sample Weight Leakage

**Result: PASS**

`compute_sample_weights()` (model/features.py:56) uses two components:

1. **Tier weights** (`tier_num`): derived from `agent_performance_ranking.performance_tier_current` at `eff_date`. This is a point-in-time attribute, not derived from the target. PASS.
2. **Recency weights** (`period` ordering): assigns higher weight to more recent training periods based on chronological order. Independent of target values. PASS.

Neither weight component uses `actual_cxns`, connection counts from the label period, or any target-derived information.

---

## Phase 8: Practical Leakage Detection Tests

**Result: NOT EXECUTABLE (code audit only)**

Phases 8a-8d (permutation importance, train-vs-CV gap analysis, SHAP dependence plots, feature ablation) require model training and evaluation data, which are not available in this environment.

**From training notebook output patterns:**
- The training notebook (zip_hurdle_training.py) computes and reports train MAE vs val MAE. The CV section (line 166-220) explicitly calculates and prints the gap. This infrastructure exists to detect leakage signals.
- The experiment history in `model/constants.py` (lines 332-345) shows gradual improvement across experiments (zip MAE from 1.21 down to ~0.44), which is consistent with legitimate feature engineering rather than leakage (leakage typically causes sudden, dramatic improvement).

**Recommendation:** During the next Databricks run, examine:
1. Train-vs-CV MAE gap — if > 20% relative, investigate further
2. Top-20 feature importance — verify no single feature dominates (>10x the next)
3. SHAP dependence for top-5 features — look for suspiciously clean linear patterns

---

## Checklist Summary

| Check | Status |
|---|---|
| Feature-target correlation audit | NOT EXECUTABLE (needs data) |
| All SQL queries verified for date boundary correctness | PASS |
| Profile/lookalike features use only prior-period data | PASS |
| All compound features traced to clean base features | PASS |
| All delta features verified: no label window overlap | PASS |
| Scoring SQL uses analogous date windows as training SQL | PASS (with FLAG — see Phase 6) |
| Sample weights independent of target variable | PASS |
| Train-vs-CV gap within acceptable range | NOT EXECUTABLE (needs data) |
| No feature with suspiciously high permutation importance | NOT EXECUTABLE (needs data) |
| SHAP dependence plots reviewed | NOT EXECUTABLE (needs data) |

---

## Overall Assessment

**No leakage detected.** The model's SQL date boundaries are consistently correct, temporal isolation in profiles/lookalikes is properly implemented, and sample weights are clean.

**One non-leakage concern identified:** Three enabled features (`zip_vol_trend`, `agent_n_periods`, `agent_zip_n_periods`) have a train-vs-score distribution mismatch. They carry real information during training but degrade to constants at scoring time. This doesn't produce false precision but may waste model capacity on features that can't contribute at production time.

**Items requiring Databricks execution for complete audit:**
1. Feature-target correlation analysis (Phase 1)
2. Train-vs-CV gap measurement (Phase 8b)
3. Permutation importance check (Phase 8a)
4. SHAP dependence review (Phase 8c)
