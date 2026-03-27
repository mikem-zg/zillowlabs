# Business Concepts — Agent Debugger (Team-Level)

Reference for the implicit business knowledge embedded in the Team-Level Agent Debugger notebook.
For system-level pipeline context (ZIP forecasts → BUA → targets → routing), see `.agents/skills/system-overview/SKILL.md`.
For routing implementation details (PaceCar V3 scoring, handler chain), see `.agents/skills/connection-pacing-routing/SKILL.md`.
For single-agent concepts (lead lifecycle funnel, ranking mechanics, peer comparison, competitive dynamics, analysis windows), see `.agents/skills/agent-debugger/BUSINESS_CONCEPTS.md`.

---

## 1. Team Structure & Agent Roster

Teams are identified by their **team lead ZUID** (`team_lead_zuid` / `TeamZuid`). All agents on a team share the same team lead.

**Roster construction:** The team-level debugger builds the agent roster from the **union** of two sources:

| Source | Table | What It Captures |
|--------|-------|-----------------|
| APM roster | `premier_agent.agent_gold.agent_performance_ranking` | Agents officially assigned to the team in the APM (Agent Performance Management) system |
| Ranking history | `touring.connectionpacing_bronze.candidateagentrankinghistory` | Agents who were actually ranked as part of this team during the analysis period |

**Why these can differ:**
- An agent may be in the APM roster but never ranked (inactive, paused for the entire period, or no leads in their ZIPs)
- An agent may appear in ranking history but not in the APM roster (recently transferred to the team, or data lag in APM)
- The union ensures no agent is missed, but some agents may have partial data (e.g., ranking data but no APM snapshot, or vice versa)

The debugger flags agents with missing data in the "Agents with Missing Data" section at the bottom of its output.

---

## 2. Pause Mechanics

Agents can be paused in two independent ways, tracked by different data sources:

| Pause Type | Data Source | Who Initiates |
|------------|-------------|---------------|
| **Self-pause** | `touring.agentavailability_bronze.agentselfpauseaudit` + `agentselfpause` | The agent themselves (via app/portal) |
| **Team-pause** | `premier_agent.crm_bronze.leadrouting_AgentPauseAudit` + `leadrouting_AgentPause` | The team lead or admin |

**Self-pause data model:**
- `agentselfpause` links the pause record to the agent (`assigneeZillowUserId`)
- `agentselfpauseaudit` contains the timeline: `eventDate` (pause start) and `unpausedAtSetTo` (pause end)
- If `unpausedAtSetTo` is NULL, the pause is still active (capped at analysis window end)
- Records with `agentReason = 'manual-unpause'` are filtered OUT — these are unpause events, not pause events

**Team-pause data model:**
- Uses a different pattern: `leadrouting_AgentPauseAudit` has `isPaused` flag and `updateDate`
- Pause end is determined by the NEXT audit row for the same `agentPauseId` (using `LEAD()` window function)
- Only rows where `isPaused = true` are kept

**Interval merging:** Both pause types can have overlapping intervals (e.g., agent self-pauses while already team-paused). The debugger merges overlapping intervals before computing total hours to avoid double-counting.

**Four pause metrics:**
1. **% self-paused** — Hours self-paused / total hours in window × 100
2. **% team-paused** — Hours team-paused / total hours in window × 100
3. **% paused (total)** — Union of self + team pause intervals / total hours × 100
4. **% paused (business hours)** — Union of pause intervals intersected with business hours / total business hours × 100

**Business hours definition:**
- Weekdays (Mon–Fri): 8:00 AM to 9:00 PM
- Weekends (Sat–Sun): 9:00 AM to 8:00 PM
- **Excluded holidays:** Christmas (Dec 25) and Thanksgiving (4th Thursday of November)
- Business-hours pause percentage is the more operationally meaningful metric because leads arrive during business hours

**Summary labels:**
- `low` pause: < 10% of business hours paused
- `medium` pause: 10–30%
- `high` pause: > 30%

---

## 3. Connection Counting

The team-level debugger reports **three independent connection measures** for each agent. They can disagree because they come from different systems with different definitions:

| Measure | Source Table | Definition | Used For |
|---------|-------------|------------|----------|
| **Flex (combined_funnels)** | `mortgage.cross_domain_gold.combined_funnels_pa_zhl` | Count of distinct `sbr_connection_contactid` where `xlob_pa_connection_monetization_type = 'Flex'` within the analysis period | Broad connection view — includes downstream funnel data |
| **FACS (find_alan_call_summary)** | `premier_agent.connections_gold.find_alan_call_summary` | Sum of `live_connection` where `business_line = 'Flex'` | Call-level view — counts successful live connections at the call level |
| **Routing (routing_cxn_share)** | `premier_agent.metrics_gold.routing_cxn_share_new_buckets` | Sum of `cxns` (or count of distinct `plf_lead_id` in single-agent debugger) | Routing system's view — what the pacing algorithm sees |

**Why they disagree:**
- **Timing:** Each table has different refresh cadences and event timestamps
- **Definition:** "Flex connection" means slightly different things at different pipeline stages
- **Scope:** `combined_funnels` is the broadest (534-column table joining PA and ZHL funnels); `routing_cxn_share` is the narrowest (just the routing system's count)
- **Deduplication:** Different dedup logic — `combined_funnels` deduplicates by contact ID, `routing_cxn_share` by lead ID

**Which is used for what:**
- The single-agent debugger uses **Routing** for its `leads_connected` count (matches the routing system's perspective)
- The team-level debugger reports all three side-by-side for comparison
- The team summary table uses **Routing** for the `cxns_count` column and delivery rate calculation

---

## 4. Price Filters

Agents can set min/max price ranges that filter which leads they're eligible for. If a lead's property price falls outside the agent's range, the agent won't be ranked for that lead.

**Data source:** `touring.leadroutingservice_bronze.price` joined to `touring.leadroutingservice_bronze.agentPlatform`

**Point-in-time reconstruction:**
1. Each price rule has `createdAt` (start), `deletedAt` (end, NULL if still active), and `updatedAt`
2. Rules are expanded to daily granularity using a calendar table (`enterprise.conformed_dimension.dim_calendar`)
3. Deduplication: If multiple rules apply to the same agent on the same day, only the most recently updated rule is kept (`ROW_NUMBER() ... ORDER BY last_updated DESC`)

**Output:** The debugger shows the distinct min/max price pairs active during the analysis period:
- `$250,000 – $750,000` = agent only sees leads in this price range
- `any – $500,000` = no minimum, max of $500K
- `None` = no price filter set (agent sees all leads regardless of price)

**Business implications:**
- Restrictive price filters reduce the pool of eligible leads, which can explain low connection counts even when the agent has good performance scores
- The `has_price_filter` flag in the team summary helps quickly identify agents who may be self-limiting

---

## 5. FindPro Call-Down Results

When the routing system selects an agent, FindPro executes the actual call-down. The team-level debugger captures full outcome and strategy detail.

**Outcome categories:**

| Outcome | Meaning | Attempted Pickup? |
|---------|---------|-------------------|
| **ACCEPTED** | Agent answered and accepted the connection | Yes |
| **MISSED** | Agent was called but did not answer | No |
| **REJECTED** | Agent actively rejected/declined the lead | No |
| Other outcomes | Various system-level outcomes | Yes (attempted) |

The debugger classifies MISSED and REJECTED as **"no attempt"** — the agent did not try to pick up. Everything else is classified as **"attempted pickup"**. This maps to agent responsiveness:
- `leads_attempted_pickup` = leads where the agent tried to answer
- `leads_no_attempt` = leads where the agent was called but didn't try
- `leads_accepted` = leads where the agent successfully accepted

**Contact strategies:**

| Strategy | How It Works |
|----------|-------------|
| **BROADCAST** | Multiple agents are contacted simultaneously for the same lead. First to answer wins. |
| **DAISYCHAIN** | Agents are contacted one at a time in sequence. Each agent gets a window to respond before the next is tried. |

The debugger counts how many of the agent's called leads used each strategy. Broadcast leads are more competitive (agent must answer faster than peers); daisy chain leads give more time but may never reach the agent if someone earlier in the chain answers first.

**Pickup-related summary labels:**
- Pickup rate: `low` (< 20% attempted), `medium` (20–40%), `high` (> 40%)
- Successful pickup rate: `low` (≤ 50% of attempted leads accepted), `acceptable` (> 50%)
- Sufficient opportunities: `yes` if `leads_called × 0.4 > capacity` (agent had enough call volume that even at moderate pickup rates they should have met capacity), `no` otherwise

---

## 6. APM Performance Tiers

The APM (Agent Performance Management) system assigns performance tiers that directly affect routing priority.

**Tier assignment:**
- Agents with **< 25 lifetime connections** are classified as **"New"** regardless of other metrics
- All other agents use `performance_tier_current` from the APM system (High, Fair, Low)

**Tier components tracked by the debugger:**

| Field | What It Measures |
|-------|-----------------|
| `cvr_pct_to_market` | Agent's conversion rate as a percentage of the market average. > 100% means above market. |
| `pre_app_rate` | Pre-approval rate: `eligible_preapprovals_l90 / eligible_met_with_l90`. Measures ZHL (Zillow Home Loans) pre-approval activity. |
| `pickup_rate_l90` | Agent's 90-day pickup rate — how often they answer when called. |
| `market_ops_market_partner` | Boolean — whether the agent is a "market partner." This changes which CVR tier formula applies. |
| `cvr_tier_effective` | The CVR tier actually used for routing: `cvr_tier_v2` for market partners, `cvr_tier` for non-partners. |
| `pickup_rate_tier` | Tiered classification of pickup rate (e.g., High, Mid, Low). |
| `zhl_pre_approval_target_rating` | ZHL pre-approval target rating — feeds into the ideal connections matrix. |

**How tiers affect routing:**
- PaceCar V3 uses tier-differentiated penalty curves (see `.agents/skills/connection-pacing-routing/SKILL.md` Throttle & Capacity Penalty Reference):
  - HIGH performers get gentle throttling (midpoint=10, max_degradation=0.50)
  - LOW performers get aggressive throttling (midpoint=3, max_degradation=0.99)
- The SOV Adjustment Factor gives HIGH_PERFORMER agents a 2× boost when the team is on-track (85–110% of target)
- Tier also feeds into recommended connection targets via the IDEAL_CXNS_CONFIG matrix

**Tier transitions:** The debugger captures APM snapshots at the start and end of the analysis period. Comparing `perf_tier_start` vs. `perf_tier_end` reveals tier transitions (e.g., Fair → High, or High → Low). Tier changes mid-period affect routing priority going forward.

**Summary sort order:** The team summary table sorts agents by tier (High → Fair → Low → New), then by routing connection count descending within each tier.

---

## 7. Performance Score Composition

The `performance_score` used in ranking comes from different formulas depending on the agent's characteristics. The team-level debugger breaks this down via `performance_score_type`.

**`performance_score_type`:** A string extracted from `AgentRankingFactors:performance_score_type` that identifies which scoring formula was used for each ranking event. The debugger shows the percentage breakdown across all ranked leads:

Example output:
```
| type                    | %     |
|-------------------------|-------|
| flex_performance_v2     | 85.3% |
| flex_new_agent          | 14.7% |
```

This reveals whether the agent is being scored as a "new agent" (simplified formula, typically lower scores) vs. a standard agent. If an agent transitions from `flex_new_agent` to `flex_performance_v2` mid-period, their score dynamics will change.

**Trend analysis:** Both debuggers compute performance score trends using first-7-day vs. last-7-day windows:
- Windows anchor to the agent's actual first/last ranked day (not fixed calendar dates)
- **5% relative change threshold** separates meaningful trends from noise
- Formula: `pct_change = (last_7d_avg - first_7d_avg) / abs(first_7d_avg)`
- Labels: `Up +X%` | `Down -X%` | `Flat (±X%)`  | `N/A` (insufficient data)

**Competitiveness metrics (team-level only):**
The team-level debugger adds `call_share_performance_avg` and `call_share_performance_med` — the percentage of leads in the agent's ZIPs where a competitor with a *worse* performance score was called instead. These are rolled up into a competitiveness quartile:
- `top_competitive_quartile` — score ≥ 75 (agent rarely loses to worse competitors)
- `second_competitive_quartile` — score ≥ 50
- `third_competitive_quartile` — score ≥ 25
- `bottom_competitive_quartile` — score < 25 (agent frequently loses to worse competitors, suggesting non-performance factors like capacity or pauses are the cause)
