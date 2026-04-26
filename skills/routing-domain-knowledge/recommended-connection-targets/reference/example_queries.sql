-- ============================================================================
-- Canonical example queries for
--   premier_agent.agent_gold.recommended_agent_connection_targets
--
-- Each section is independently runnable. Replace the snapshot date as needed.
-- Companion to the parent SKILL.md — these are the queries that produced the
-- "Validation against production" section.
--
-- Run via: .agents/skills/databricks-operations/run-databricks-query/SKILL.md
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 1. Latest snapshot lookup
--    Always pin to the latest snapshot rather than current_date(); the job
--    runs daily but can be late.
-- ---------------------------------------------------------------------------
SELECT MAX(snapshot_date) AS latest_snapshot
FROM premier_agent.agent_gold.recommended_agent_connection_targets;


-- ---------------------------------------------------------------------------
-- 2. Per-agent target lookup
--    NOTE: An agent can be on multiple teams (~520/day). Returns one row per
--    (agent, team) pair. To get a single per-agent number, sum across teams.
-- ---------------------------------------------------------------------------
SELECT team_lead_zuid, team_member_zuid, em_flag, desired_connections,
       ideal_connections, recommended_connection_target, recommendation_reason
FROM premier_agent.agent_gold.recommended_agent_connection_targets
WHERE snapshot_date = DATE'2026-04-25'
  AND team_member_zuid = <AGENT_ZUID>;


-- ---------------------------------------------------------------------------
-- 3. Per-team total (the value that drove reconciliation)
-- ---------------------------------------------------------------------------
SELECT team_lead_zuid,
       COUNT(*) AS team_size,
       SUM(recommended_connection_target) AS team_recommended_total,
       SUM(ideal_connections) AS team_ideal_total
FROM premier_agent.agent_gold.recommended_agent_connection_targets
WHERE snapshot_date = DATE'2026-04-25'
GROUP BY team_lead_zuid
ORDER BY team_recommended_total DESC;


-- ---------------------------------------------------------------------------
-- 4. Reconciliation invariant check
--    SUM(recommended_connection_target) per team should equal team_cxn_target
--    from HMA buyer-program totals exactly. Use this to detect job drift.
-- ---------------------------------------------------------------------------
WITH current_hma AS (
  SELECT * FROM premier_agent.agent_gold.hybrid_market_allocations
  WHERE date(algo_run_date) = (
    SELECT MAX(date(algo_run_date))
    FROM premier_agent.agent_gold.hybrid_market_allocations
  )
),
curr_run AS (
  SELECT parent_zuid, MIN(allocation_run_id) AS run_id
  FROM current_hma GROUP BY parent_zuid
),
team_targets AS (
  SELECT hma.parent_zuid AS team_zuid,
         CEIL(COALESCE(SUM(hma.agent_zip_allocated_cxn), 0.0)) AS team_cxn_target
  FROM current_hma hma
  JOIN curr_run cr ON hma.parent_zuid = cr.parent_zuid
                  AND hma.allocation_run_id = cr.run_id
  WHERE hma.allocation_program = 'buyer'
  GROUP BY hma.parent_zuid
),
recommended AS (
  SELECT team_lead_zuid AS team_zuid,
         SUM(recommended_connection_target) AS sum_recommended
  FROM premier_agent.agent_gold.recommended_agent_connection_targets
  WHERE snapshot_date = DATE'2026-04-25'
  GROUP BY team_lead_zuid
)
SELECT
  COUNT(*) AS teams_joined,
  SUM(CASE WHEN diff = 0 THEN 1 ELSE 0 END) AS exact_match,
  SUM(CASE WHEN ABS(diff) <= 1 THEN 1 ELSE 0 END) AS within_1,
  ROUND(AVG(ABS(diff)), 2) AS avg_abs_diff,
  MAX(ABS(diff)) AS max_abs_diff
FROM (
  SELECT t.team_zuid,
         (r.sum_recommended - t.team_cxn_target) AS diff
  FROM team_targets t
  JOIN recommended r ON t.team_zuid = r.team_zuid
);
-- Expected: exact_match = teams_joined, max_abs_diff = 0.


-- ---------------------------------------------------------------------------
-- 5. ideal_connections distribution (matrix sanity check)
--    Mass should concentrate on matrix values: 1, 3, 5, 7, 10, 12, 15.
-- ---------------------------------------------------------------------------
SELECT ideal_connections, COUNT(*) AS rows,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM premier_agent.agent_gold.recommended_agent_connection_targets
WHERE snapshot_date = DATE'2026-04-25'
GROUP BY ideal_connections
ORDER BY ideal_connections;


-- ---------------------------------------------------------------------------
-- 6. Hard-rule integrity checks
--    Confirms the algorithm's deterministic branches.
-- ---------------------------------------------------------------------------
-- 6a. New-agent rule: 100% of "Less than 25 lifetime cxns%" rows have ideal=7
SELECT ideal_connections, COUNT(*) AS rows
FROM premier_agent.agent_gold.recommended_agent_connection_targets
WHERE snapshot_date = DATE'2026-04-25'
  AND recommendation_reason LIKE 'Less than 25 lifetime%'
GROUP BY ideal_connections;
-- Expected: only ideal_connections=7

-- 6b. At-risk rule: 100% of "Limiting due to heavy recent volume%" have ideal=1
SELECT ideal_connections, COUNT(*) AS rows
FROM premier_agent.agent_gold.recommended_agent_connection_targets
WHERE snapshot_date = DATE'2026-04-25'
  AND recommendation_reason LIKE 'Limiting due to heavy recent volume%'
GROUP BY ideal_connections;
-- Expected: only ideal_connections=1


-- ---------------------------------------------------------------------------
-- 7. Per-cell IDEAL_CXNS_CONFIG verification
--    For no-suffix matrix reasons, ideal_connections is uniquely determined
--    by the matrix. MIN, MAX and MODE should be identical and match the
--    documented matrix value for each cell.
-- ---------------------------------------------------------------------------
SELECT recommendation_reason,
       MIN(ideal_connections) AS min_ideal,
       MAX(ideal_connections) AS max_ideal,
       MODE(ideal_connections) AS modal_ideal,
       COUNT(*) AS rows
FROM premier_agent.agent_gold.recommended_agent_connection_targets
WHERE snapshot_date = DATE'2026-04-25'
  AND recommendation_reason RLIKE
      '^(Low|Low-Fair|NA|Fair|High) pCVR( and (Low|Low-Fair|NA|Fair|High) ZHL Pre-approvals)? performance$'
GROUP BY recommendation_reason
ORDER BY recommendation_reason;


-- ---------------------------------------------------------------------------
-- 8. Reason-text fragment census
--    Useful for spotting the introduction/disappearance of any documented
--    suffix as the algorithm evolves.
-- ---------------------------------------------------------------------------
SELECT
  SUM(CASE WHEN recommendation_reason LIKE 'Less than 25 lifetime cxns, ramp slowly%'           THEN 1 ELSE 0 END) AS new_agent,
  SUM(CASE WHEN recommendation_reason LIKE 'Limiting due to heavy recent volume%'               THEN 1 ELSE 0 END) AS at_risk,
  SUM(CASE WHEN recommendation_reason LIKE '% pCVR performance%'                                THEN 1 ELSE 0 END) AS pcvr_only,
  SUM(CASE WHEN recommendation_reason LIKE '% pCVR and % ZHL Pre-approvals performance%'        THEN 1 ELSE 0 END) AS pcvr_and_zhl,
  SUM(CASE WHEN recommendation_reason LIKE '%, low recent cxn volume%'                          THEN 1 ELSE 0 END) AS low_volume_suffix,
  SUM(CASE WHEN recommendation_reason LIKE '%AND agent requested%cxns%'                         THEN 1 ELSE 0 END) AS requested_suffix,
  SUM(CASE WHEN recommendation_reason LIKE '%AND unresponsive to desired cxns SMS%'             THEN 1 ELSE 0 END) AS unresponsive_suffix,
  SUM(CASE WHEN recommendation_reason LIKE '%, last desired was %cxns%'                         THEN 1 ELSE 0 END) AS last_desired_suffix,
  SUM(CASE WHEN recommendation_reason LIKE '%AND low pickup rate%'                              THEN 1 ELSE 0 END) AS pickup_penalty_suffix
FROM premier_agent.agent_gold.recommended_agent_connection_targets
WHERE snapshot_date = DATE'2026-04-25';


-- ---------------------------------------------------------------------------
-- 9. Pickup-rate penalty cohort (track decline if the high-volume cap ships)
-- ---------------------------------------------------------------------------
SELECT snapshot_date,
       SUM(CASE WHEN recommendation_reason LIKE '%AND low pickup rate%' THEN 1 ELSE 0 END) AS penalised,
       COUNT(*) AS total_rows,
       ROUND(100.0 * SUM(CASE WHEN recommendation_reason LIKE '%AND low pickup rate%' THEN 1 ELSE 0 END)
                   / COUNT(*), 2) AS pct_penalised
FROM premier_agent.agent_gold.recommended_agent_connection_targets
WHERE snapshot_date >= date_sub(current_date(), 60)
GROUP BY snapshot_date
ORDER BY snapshot_date;


-- ---------------------------------------------------------------------------
-- 10. EM vs non-EM split
--     Non-EM should always render reasons WITHOUT a ZHL clause.
-- ---------------------------------------------------------------------------
SELECT em_flag,
       COUNT(*) AS rows,
       SUM(CASE WHEN recommendation_reason LIKE '% pCVR and % ZHL Pre-approvals%' THEN 1 ELSE 0 END) AS rows_with_zhl_clause
FROM premier_agent.agent_gold.recommended_agent_connection_targets
WHERE snapshot_date = DATE'2026-04-25'
GROUP BY em_flag;
-- Expected: em_flag=false → rows_with_zhl_clause = 0


-- ---------------------------------------------------------------------------
-- 11. Above-/below-/exact-cap reconciliation breakdown
--     Quantifies how often reconciliation moves the value vs leaves it alone.
-- ---------------------------------------------------------------------------
SELECT
  CASE
    WHEN recommended_connection_target = ideal_connections THEN '0_unchanged'
    WHEN recommended_connection_target > ideal_connections THEN '1_increased_above_cap_team'
    ELSE '2_decreased_below_cap_team'
  END AS direction,
  COUNT(*) AS rows,
  ROUND(AVG(recommended_connection_target - ideal_connections), 2) AS avg_diff
FROM premier_agent.agent_gold.recommended_agent_connection_targets
WHERE snapshot_date = DATE'2026-04-25'
GROUP BY 1
ORDER BY 1;


-- ---------------------------------------------------------------------------
-- 12. Day-over-day target stability (volatility radar)
--     Useful to monitor whether daily target swings are reasonable.
-- ---------------------------------------------------------------------------
WITH t AS (
  SELECT snapshot_date, team_lead_zuid, team_member_zuid, recommended_connection_target
  FROM premier_agent.agent_gold.recommended_agent_connection_targets
  WHERE snapshot_date IN (DATE'2026-04-25', DATE'2026-04-24')
)
SELECT t1.team_lead_zuid, t1.team_member_zuid,
       t1.recommended_connection_target AS today,
       t0.recommended_connection_target AS yesterday,
       (t1.recommended_connection_target - t0.recommended_connection_target) AS delta
FROM t t1
LEFT JOIN t t0
  ON t0.team_lead_zuid = t1.team_lead_zuid
 AND t0.team_member_zuid = t1.team_member_zuid
 AND t0.snapshot_date = DATE'2026-04-24'
WHERE t1.snapshot_date = DATE'2026-04-25'
  AND ABS(COALESCE(t1.recommended_connection_target - t0.recommended_connection_target, 0)) >= 5
ORDER BY ABS(t1.recommended_connection_target - COALESCE(t0.recommended_connection_target, 0)) DESC
LIMIT 50;


-- ---------------------------------------------------------------------------
-- 13. Multi-team agents (reminder this is real)
-- ---------------------------------------------------------------------------
WITH per_member AS (
  SELECT team_member_zuid, COUNT(DISTINCT team_lead_zuid) AS n_teams
  FROM premier_agent.agent_gold.recommended_agent_connection_targets
  WHERE snapshot_date = DATE'2026-04-25'
  GROUP BY team_member_zuid
)
SELECT n_teams, COUNT(*) AS agent_count
FROM per_member
GROUP BY n_teams
ORDER BY n_teams;


-- ---------------------------------------------------------------------------
-- 14. Join to upstream agent_performance_ranking (recover the buckets)
--     The output table omits cvr_bucket and zhl_preapprovals_bucket. Recover
--     them by joining on agent_zuid using the latest performance snapshot
--     on or before the targets snapshot_date (perf ranking is typically 1-2
--     days behind).
--
--     Notes on table/column names that bite first-time users:
--       - Table is premier_agent.agent_gold.agent_performance_ranking
--         (NOT agent_silver).
--       - Join key is agent_zuid (NOT team_member_zuid).
--       - Bucket columns are cvr_tier and zhl_pre_approval_target_rating.
-- ---------------------------------------------------------------------------
WITH latest_apr_date AS (
  SELECT MAX(agent_performance_date) AS d
  FROM premier_agent.agent_gold.agent_performance_ranking
  WHERE agent_performance_date <= DATE'2026-04-25'
),
apr AS (
  SELECT *
  FROM premier_agent.agent_gold.agent_performance_ranking
  WHERE agent_performance_date = (SELECT d FROM latest_apr_date)
)
SELECT r.team_lead_zuid, r.team_member_zuid,
       apr.cvr_tier AS cvr_bucket,
       apr.zhl_pre_approval_target_rating AS zhl_bucket,
       r.em_flag,
       r.ideal_connections, r.recommended_connection_target,
       r.recommendation_reason
FROM premier_agent.agent_gold.recommended_agent_connection_targets r
LEFT JOIN apr ON apr.agent_zuid = r.team_member_zuid
WHERE r.snapshot_date = DATE'2026-04-25'
  AND r.team_member_zuid = <AGENT_ZUID>;


-- ---------------------------------------------------------------------------
-- 15. Bucket → ideal_connections matrix verification (joined version)
--     Uses the upstream buckets to verify the matrix end-to-end. Note: the
--     reason-text-only verification in section 7 is *cleaner* (every no-suffix
--     reason has a single ideal_connections value); this joined version is
--     noisier because:
--       (a) agent_performance_ranking lags the targets snapshot by 1-2 days,
--           so joining picks up a stale bucket version.
--       (b) The algorithm normalizes upstream values: 'Mid' → 'Fair',
--           'N/A' → 'NA'. Apply the same normalization here to compare.
--       (c) Joining a member_zuid that has rolled off the team picks up
--           orphan rows that did not pass the algorithm's input filters.
--     Use this only as a sanity check; rely on section 7 for matrix proof.
-- ---------------------------------------------------------------------------
WITH latest_apr_date AS (
  SELECT MAX(agent_performance_date) AS d
  FROM premier_agent.agent_gold.agent_performance_ranking
  WHERE agent_performance_date <= DATE'2026-04-25'
),
apr AS (
  SELECT agent_zuid,
         CASE WHEN cvr_tier = 'Mid' THEN 'Fair' ELSE cvr_tier END AS cvr_bucket_norm,
         CASE WHEN zhl_pre_approval_target_rating = 'N/A' THEN 'NA'
              ELSE zhl_pre_approval_target_rating END AS zhl_bucket_norm
  FROM premier_agent.agent_gold.agent_performance_ranking
  WHERE agent_performance_date = (SELECT d FROM latest_apr_date)
)
SELECT
  apr.cvr_bucket_norm AS cvr_bucket,
  CASE WHEN r.em_flag THEN apr.zhl_bucket_norm ELSE 'NA' END AS zhl_bucket,
  r.ideal_connections,
  COUNT(*) AS rows
FROM premier_agent.agent_gold.recommended_agent_connection_targets r
JOIN apr ON apr.agent_zuid = r.team_member_zuid
WHERE r.snapshot_date = DATE'2026-04-25'
  AND r.recommendation_reason RLIKE
      '^(Low|Low-Fair|NA|Fair|High) pCVR( and (Low|Low-Fair|NA|Fair|High) ZHL Pre-approvals)? performance$'
GROUP BY 1, 2, 3
ORDER BY 1, 2, 3;
-- Expected: each (cvr_bucket, zhl_bucket) row should land on the matrix
-- value in IDEAL_CXNS_CONFIG, but minor leakage from snapshot-lag is normal.
