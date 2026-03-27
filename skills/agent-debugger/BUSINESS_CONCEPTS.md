# Business Concepts — Agent Debugger (Single-Agent)

Reference for the implicit business knowledge embedded in the single-agent Agent Debugger notebook.
For system-level pipeline context (ZIP forecasts → BUA → targets → routing), see `.agents/skills/system-overview/SKILL.md`.
For routing implementation details (PaceCar V3 scoring, handler chain), see `.agents/skills/connection-pacing-routing/SKILL.md`.
For team-level concepts (pause mechanics, connection counting, APM tiers, price filters, FindPro outcomes), see `.agents/skills/agent-debugger-team-level/BUSINESS_CONCEPTS.md`.

---

## 1. Lead Lifecycle Funnel

A lead passes through three stages before an agent receives a connection:

| Stage | Meaning | Data Source |
|-------|---------|-------------|
| **Ranked** | The agent appeared in the candidate ranking list for this lead. The routing system considered the agent but may or may not have called them. | `touring.connectionpacing_bronze.candidateagentrankinghistory` |
| **Called** | FindPro actually attempted to contact the agent for this lead. Only a subset of ranked agents are called — position, capacity, and availability determine who gets called. | `connections_platform.findpro.findpro_opportunity_result_v1` |
| **Connected** | The agent received the connection (the consumer and agent were matched). | `premier_agent.metrics_gold.routing_cxn_share_new_buckets` (routing measure) |

The debugger computes all three counts: `leads_ranked`, `leads_called`, `leads_connected`. The drop-off between stages is diagnostic:

- **Ranked but never called** — The agent was considered but outranked by competitors or filtered out by capacity/eligibility rules. A high ranked-to-called drop-off suggests the agent is consistently ranked too low or is being throttled.
- **Called but never connected** — The agent was called but didn't pick up, rejected the lead, or was beaten by another agent who answered first. This points to behavioral issues (pickup rate) or contact strategy effects (broadcast vs. daisy chain).

---

## 2. Agent Ranking Mechanics

Each time a lead arrives, eligible agents are ranked. The ranking record captures:

- **`AgentAbsPos`** — The agent's absolute position in the ranking list for that lead. Position 1 is best. **NULL position is mapped to 99** (per spec: "if abs position is null, set to 99"), meaning the agent was technically in the candidate pool but received no meaningful rank.
- **`ranking_method`** — Which algorithm produced the ranking:
  - **`pace_car_v3`** — The primary performance-based ranking algorithm. Uses multiplicative scoring: capacity penalty × SOV adjustment × cooldown × performance score × geo preferences. This is the standard path for most leads.
  - **`shuffle`** — A randomized ranking method. The debugger **excludes shuffle-ranked leads from most analysis** because shuffle positions don't reflect agent quality. The team-level debugger tracks shuffle vs. non-shuffle counts separately. Shuffle lacks capacity_penalty_factor, so throttle analysis only uses pace_car_v3 rows.
- **`performance_score`** — A composite score (extracted from the `AgentRankingFactors` JSON) that drives ranking position. Higher is better. This score incorporates conversion rates, call success, and closing performance (see Performance Score Composition in the team-level reference).
- **`capacity_penalty_factor`** — A multiplier from PaceCar V3 (see Capacity & Throttling below). Only present on pace_car_v3 rows.

The debugger deduplicates per lead, keeping the **best (lowest) position** for each lead when computing position metrics. This means if an agent was ranked multiple times for the same lead (e.g., re-ranking events), only the best attempt counts.

---

## 3. Capacity & Throttling

PaceCar V3 applies a `capacity_penalty_factor` that reduces an agent's effective score as they approach or exceed their connection target.

- **`capacity_penalty_factor < 1`** means the agent is being throttled — their ranking score is multiplied by a value less than 1, pushing them down the list.
- **`capacity_penalty_factor = 1`** means no throttling is applied.
- The debugger counts **days with capacity penalty < 1** as a summary metric. Multiple days of throttling indicate a systematic pattern, not a one-off.

The `weighted_capacity` field (available in the team-level debugger) shows the agent's effective capacity target as seen by the routing system. The debugger computes the average capacity across ranked days.

**Business meaning:** An agent who is throttled most days is consistently near or above their target. This can happen when:
- The target is set too low relative to ZIP demand
- The agent is on a high-performing team that gets boosted by LPA
- The team lead overrode the target to a low value

For the exact penalty formulas (logistic S-curve by tier, assignment cooldown), see the Throttle & Capacity Penalty Reference in `.agents/skills/connection-pacing-routing/SKILL.md`.

---

## 4. Peer Comparison Logic

The debugger identifies "peers" — teammates with similar performance — to answer: "Is there someone like this agent who is getting more connections?"

**Tiered selection algorithm (tried in order, first match wins):**

| Tier | Perf Score Match | Extra Requirement | Rationale |
|------|-----------------|-------------------|-----------|
| **±2.5%** | Within 2.5% of target agent's avg perf_score | Peer must have **more connections** than target agent | Tightest match — find near-identical agents who are outperforming |
| **±5%** | Within 5% | None | Broader match if 2.5% tier yields no peers |
| **±10%** | Within 10% | None | Broadest fallback |

If no peers are found within ±10%, the analysis stops ("No peers found").

**Top peer:** The peer with the most connections in the selected tier. This is the agent who is most clearly outperforming the target agent despite similar quality.

**ZIP exclusivity analysis:** After identifying the top peer, the debugger finds ZIPs where:
1. The top peer was ranked AND called
2. The target agent was **never ranked**

These "exclusive ZIPs" reveal coverage gaps — the top peer is getting connections from ZIPs the target agent isn't even eligible for. This is actionable: expanding ZIP assignments could close the gap.

**Data flow:**
1. Query all teammates' ranking history (`candidateagentrankinghistory` filtered by `TeamZuid`)
2. Compute each teammate's average `performance_score`
3. Pull connection counts from `routing_cxn_share_new_buckets` for all teammates
4. Apply tiered selection
5. For the top peer, query their FindPro calls and cross-reference ZIP coverage

---

## 5. Competitive Dynamics

The debugger analyzes competitors (agents from other teams) who were ranked on the same leads as the focal agent.

**Competitor position on not-called leads:** For leads where the focal agent was ranked but NOT called, the debugger looks at which competitors WERE called and what their ranking positions were. This answers: "When this agent lost a lead, who won it and how much better were they ranked?"

- `avg_pos_called` — The focal agent's average position on leads where they were called. Lower is better.
- `avg_pos_not_called` — The focal agent's average position on leads where they were NOT called. Usually higher (worse) than the called average.
- `avg_comp_pos_nc` — Average competitor position on not-called leads (only competitors who were actually called). If this is much lower than the agent's not-called position, competitors are clearly outranking the agent.

**Perf score trends (agent vs. competitors):** The debugger computes trend direction for both the focal agent and competitors using first-7-day vs. last-7-day average performance scores:
- Trend windows are anchored to the agent's actual first and last ranked day, not fixed calendar dates
- A **5% relative change threshold** separates "Up"/"Down" from "Flat"
- Formula: `pct = (last_avg - first_avg) / abs(first_avg)`
- Labels: `Up +X%` | `Down -X%` | `Flat (±X%)`

**Business interpretation:**
- Agent trend Up + Competitor trend Down = agent is gaining ground, should see improvement
- Agent trend Down + Competitor trend Up = agent is losing ground, expect fewer connections
- Both flat = stable competitive environment

**Call share by performance (team-level debugger only):** The team-level version adds a deeper metric: what percentage of leads in the agent's ZIPs went to competitors with *worse* performance scores. High call_share_performance means the agent is losing leads to lower-quality competitors, suggesting non-performance factors (capacity, availability, price filters) are the cause.

---

## 6. Analysis Window Conventions

The debugger uses specific date window patterns that are important to understand:

**35-day pull / 30-day analysis:**
- `DAYS_BACK = 35` — Data is pulled for 35 days to ensure completeness (data pipelines may have lag)
- `PERIOD_DAYS = 30` — All metrics are computed over a 30-day analysis window
- The extra 5 days are buffer only; they are filtered out before any metric calculation

**Today is excluded:**
- `analysis_end = today - 1` — The most recent day is always excluded because ranking data for the current day is likely partial/incomplete
- This means the analysis window is `[today - 30, today - 1]` inclusive

**Trend windows anchor to actual activity, not calendar:**
- `first7_start` = the agent's actual first ranked day in the 30-day window
- `last7_start` = the agent's actual last ranked day minus 6 days
- This prevents misleading trends when an agent wasn't ranked for the first or last few days of the calendar window
- Example: If an agent's first ranking was day 5 of the period, the "first 7 days" window starts at day 5, not day 1

**Deduplication:** When computing position metrics, the debugger keeps only the best (lowest) position per lead. This prevents double-counting when an agent is re-ranked for the same lead (e.g., multiple ranking events within the same day).
