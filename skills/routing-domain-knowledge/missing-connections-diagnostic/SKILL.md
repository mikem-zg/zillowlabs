---
name: missing-connections-diagnostic
description: Canonical ordered diagnostic playbook for "why isn't this agent receiving connections?" questions. Use whenever an agent, team lead, or escalation asks why a specific agent is missing, light on, or under-served on connections. Lists checks in priority order (mechanical block first, then ranking, then exceptions), names the specific table/column for each check, and explicitly calls out common red herrings (active_flag, roster_status) that are descriptive symptoms — not causes.
evolving: true
last_reviewed: 2026-04-18
---

# Missing Connections Diagnostic Playbook

> **Living document**: Each time this skill is used, review and improve it based on new learnings.

## When to use

Use this playbook as the **canonical answer** for any question shaped like:
- "Why isn't [agent] getting connections?"
- "Why has [agent]'s volume dropped?"
- "Why is this agent under-served / missing leads?"
- "Why didn't [agent] get called on this lead?"

Run the checks **in order**. Stop at the first one that explains the gap — earlier checks have larger mechanical impact than later ones.

---

## TL;DR — Cohort Evidence

These hit-rates over a 14-day window grounded the ordering below:

| Cohort | 14-day hit rate | Interpretation |
|---|---|---|
| `active_flag = false` AND `current_target = 0` | ~7% | Effectively blocked. Residual is exception/remnant routing. |
| `active_flag = false` AND `current_target > 0` | ~48% | Still receiving connections — `false` flag is **not** a routing gate. Lower than the active baseline because of ranking deprioritization. |
| `active_flag = true` AND `current_target > 0` | ~83% | Healthy baseline. |

**Implication:** `current_target = 0` is the dominant mechanical block. `active_flag = false` is correlated with the block but does not itself block routing. Always check the target before invoking the flag.

---

## Diagnostic Order (Top-Down)

### 1. Mechanical block: `current_target = 0`?

This is the dominant cause of "no connections at all." Check first.

- **Table:** `premier_agent.agent_gold.agent_performance_ranking`
- **Column:** `current_target`
- **Upstream cause:** `premier_agent.agent_gold.recommended_agent_connection_targets.recommended_connection_target` rolled up to the agent. The recommendation goes to zero when recent activity (lifetime cxns, recent volume, pickup, pCVR) collapses, then propagates into `touring.leadroutingservice_bronze.capacity.agent_cxns_target` on the monthly target refresh (typically 1st of month).
- **Example query:**
  ```sql
  SELECT agent_zuid, current_target, performance_tier_current, active_flag
  FROM premier_agent.agent_gold.agent_performance_ranking
  WHERE agent_zuid = :zuid
    AND agent_performance_date = (SELECT MAX(agent_performance_date) FROM premier_agent.agent_gold.agent_performance_ranking);
  ```
- **If `current_target = 0`:** This is your answer. Volume will be ~7% of baseline (exception/remnant routing only). Investigate the upstream recommendation — typically traces back to low recent activity or low score.

### 2. Ranking / performance tier deprioritization

If `current_target > 0` but volume is well below baseline, ranking is the next-largest lever. PaceCar v3 (within team) and team-level ranking both score on this.

- **Table:** `premier_agent.agent_gold.agent_performance_ranking`
- **Columns:** `performance_tier_current` (`High` / `Fair` / `Low`), `total_score_current`, `cvr_tier`, `pickup_rate_l90`, `answer_rate_l90`
- **Also relevant:** `premier_agent.agent_silver.agent_score.agent_score` — the score the routing system actually uses
- **Why this matters:** Even within the `false` + `target > 0` cohort, hit rate is 48% vs the `true` baseline of 83%. The 35-point gap is almost entirely score/ranking deprioritization (inactive agents tend to have lower composite scores).
- **Example query:**
  ```sql
  SELECT agent_zuid, performance_tier_current, total_score_current,
         pickup_rate_l90, answer_rate_l90, buyside_agent_cvr
  FROM premier_agent.agent_gold.agent_performance_ranking
  WHERE agent_zuid = :zuid
    AND agent_performance_date = (SELECT MAX(agent_performance_date) FROM premier_agent.agent_gold.agent_performance_ranking);
  ```
- See `connection-pacing-routing` for the PaceCar v3 throttle/penalty formulas.

### 3. Self-pause

Agent voluntarily removed from the routing pool for some portion of the window.

- **Tables:** `touring.agentavailability_bronze.agentselfpause`, `agentselfpauseaudit`
- **Column:** `isPaused` (current state); `eventDate` + `unpausedAtSetTo` (history)
- **Threshold:** >73% of L30d business hours paused starts to materially reduce delivery; >93% is "effectively opted out."
- **Example query:**
  ```sql
  SELECT CAST(assigneeZillowUserId AS BIGINT) AS agent_zuid, isPaused, unpausedAt
  FROM touring.agentavailability_bronze.agentselfpause
  WHERE CAST(assigneeZillowUserId AS BIGINT) = :zuid;
  ```
- See `self-pause` skill for full query patterns and tier thresholds.

### 4. Enrollment / capacity gaps

Agent isn't enrolled in the program or has no capacity row at all.

- **Tables:** `touring.leadroutingservice_bronze.agentplatform`, `touring.leadroutingservice_bronze.capacity`
- **Columns:** `agentplatform.assigneezuid` + program flags; `capacity.agent_cxns_target`
- **What to check:** Is the agent actually on the program? Does a current capacity row exist? Is `agent_cxns_target` set?
- **Example query:**
  ```sql
  SELECT assigneezuid, * FROM touring.leadroutingservice_bronze.capacity
  WHERE assigneezuid = :zuid ORDER BY updateDate DESC LIMIT 5;
  ```

### 5. Eligibility / price / geo filters

Agent is enrolled and ranked but filtered out of specific leads.

- **Tables:** `touring.leadroutingservice_bronze.price` (price filter), agent ZIP assignments in `touring.leadroutingservice_bronze.zip` / `zipgroup`
- **What to check:** Does the agent's price range exclude the leads coming through? Are their ZIP assignments aligned with where actual lead volume is flowing?
- See `databricks-query-lead-routing-price-filters`.

### 6. Exception paths (usually only relevant for *unexpected* calls, not absent ones)

These rarely explain "no connections" — they explain *unexpected* connections. Only check if you've ruled out 1-5 and need to explain anomalies.

- **Remnants** — `touring.connectionpacing_bronze.candidateagentrankinghistory.AllocationTypeID = 3`, `IsPreferredRemnant`. See `remnant-logic`.
- **Manual reassignment / hold** — check FUB / CRM-side reassignment audit.
- **ZHL Agent Transfer Program flag** — distinct from reassignment; see `databricks-query-agent-reassignments`.

---

## Common red herrings — descriptive symptoms, NOT causes

These appear in dashboards and bot answers, but they do **not** gate routing. Do not surface them as "the answer":

| Field | Why it looks like a cause | Why it isn't |
|---|---|---|
| `agent_performance_ranking.active_flag = false` | Strongly correlated with low/no delivery | **Not a routing gate.** Agents with `false` + `target > 0` still receive ~48% hit rate. The flag is a downstream descriptor of recent activity — the same upstream signal that drives `current_target` to zero. Naming it as the cause hides the real mechanical block. |
| `roster_status = 'Onboarding'` (or similar) | Onboarding-clause-false agents get fewer connections | Same pattern: the roster status reflects activity/tenure but isn't itself the routing filter. The actual block is `current_target = 0` and/or low score. |
| "Agent score is low" without checking target | Score does deprioritize | If `current_target = 0`, score is moot — there is no allocation to distribute against. Always check target first, then explain ranking within target. |

**Rule of thumb:** if your answer is "the agent is inactive" or "the active_flag is false," go back and check `current_target`. The flag is downstream of the same root cause, and quoting it skips the explanation.

---

## Putting it together — answer template

For a typical "why isn't [agent] getting connections?" question, the answer should:

1. State the **mechanical status** first: `current_target` value (and recommendation source if zero).
2. If target > 0, explain **ranking position**: tier, score vs team/competitor average.
3. Add **availability context** if relevant: self-pause, enrollment.
4. Only mention `active_flag` / `roster_status` as **context** ("this agent shows `active_flag = false`, which is consistent with the underlying low-recent-activity signal that drove the recommended target to zero") — never as the explanation by itself.

---

## Related skills

- `routing-system-overview` — end-to-end routing pipeline (ZIP forecast → BUA → agent target → routing)
- `connection-pacing-routing` — PaceCar v3 scoring, throttle/capacity penalty formulas
- `self-pause` — pause tables, scoring, business-hours variants
- `remnant-logic` — exception routing
- `databricks-query-recommended-agent-connection-targets` — upstream of `current_target`
- `databricks-query-agent-performance-ranking` — `current_target`, `performance_tier_current`, `total_score_current`
- `databricks-query-agent-score` — routing-relevant `agent_score`
- `databricks-query-candidate-agent-ranking-history` — per-lead ranking debugging
- `databricks-query-findpro-opportunity-result` — call-down outcomes
- `routing-escalation-taxonomy` — full escalation triage (Category 1 covers agent-level distribution issues)
