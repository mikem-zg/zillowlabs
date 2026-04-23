---
name: zhl-adoption
description: Canonical definition of ZHL adoption — funded ZHL loans per agent transaction — plus all related funnel metrics (locked rate, pre-approval attach rate), denominator choices, source tables, and SQL patterns. Use when computing, comparing, or threshold-setting any "adoption", "funded", "locked", "pre-approval", "PRE", or "attach" rate, or when deciding which denominator to use for a ZHL conversion metric.
evolving: true
last_reviewed: 2026-04-16
---

# ZHL Adoption

> **Living document**: Each time this skill is used, review and improve it based on new learnings. Add gotchas, column clarifications, or query patterns discovered during use.

## "Adoption" Means Two Different Things — Always Disambiguate

There are **two officially-tracked adoption metrics** in the org, and they answer different questions. Stakeholders use the word "adoption" for both. Always confirm which one is meant before doing analysis or setting thresholds.

### A. Flex PA-to-ZHL Adoption Rate *(the "clean ZHL view")*

> **# Flex PA-to-ZHL Funded Loans ÷ # Flex Transactions**
>
> "Of all Flex transactions in the month, what fraction were funded by ZHL after a Flex connection-to-ZHL transfer."

- **Numerator**: only loans where the buyer was transferred *from a Flex connection to ZHL* and ultimately funded with ZHL. PA-originated only.
- **Denominator**: all Flex transactions in the month.
- **Cohorting**: by Flex transaction month (downstream outcomes — transfers, fundings — are matched back to the originating transaction). This is the cleanest view; an "activity-based" view (current-month metrics over current-month activity) also exists but is noisier.
- **Decomposes** as: `Transfer Rate of Transactors × Win Rate`
  - Transfer Rate of Transactors = % of Flex transactions referred to ZHL
  - Win Rate = funded loans / transferred transactors
- **Use when**: evaluating ZHL conversion performance from the ZHL side; agent-level signals; modeling.
- **Source of truth**: ZHL Win Rate Deep Dive Tableau dashboard. Owners: Ryan Townsend, Tim Mattran.

### B. EM Program Adoption Rate *(the broader org-level "integrated transaction" view)*

> **# Integrated Loans (PA + ZHL-to-PA + PA Influenced) ÷ # Closed Transactions in EM zips**
>
> "Of all the closed transactions on connections we delivered in Enhanced Markets, what fraction touched both ZHL and PA in any order."

- **Numerator** is broader than (A): includes PA loans + ZHL-to-PA loans + PA Influenced loans. *Any loan that touches both ZHL and PA, regardless of order, as long as the Beth↔Alan connection was made in an EM zip.*
- **Denominator**: closed transactions tied to connections delivered within Enhanced Market zips. Excludes transactions on connections delivered outside EM (e.g., NY state).
- **Use when**: executive reporting on "are we driving integrated transactions in EM"; AOP goal tracking. **This is the metric currently stagnated below 15% in mature markets** — and the most likely referent when someone says "20% adoption goal."
- **Source of truth**: Preferred Revenue Scorecard Tableau dashboard ([Confluence](https://zillowgroup.atlassian.net/wiki/spaces/B2CMM/pages/165446175), owner Jason Dunbar). Backend is a Tableau-published dataset over EDW; not directly reproducible from a single Databricks table.

### Quick Comparison

| | (A) Flex PA-to-ZHL | (B) EM Program Adoption |
|---|---|---|
| Numerator scope | PA-originated funded loans only | PA + ZHL-to-PA + PA Influenced |
| Denominator scope | All Flex transactions | EM-zip transactions only |
| Population pooled rate | ~10% (Mar '25) | <15% (mature markets, May '25) |
| Default for ZHL analytics | ✅ | |
| Default for EM/program reporting | | ✅ |
| Reproducible in Databricks | ✅ (with caveats below) | ❌ (Tableau-only without rebuild) |

## Approximating Adoption from `agent_metrics_monthly`

For per-agent analysis we work with `premier_agent.agent_gold.agent_metrics_monthly`. The closest available approximation is:

| Field | Column | Approximates |
|---|---|---|
| Numerator | `zhl_funded_flag_sum` | "Flex PA-to-ZHL Funded Loans" (definition A numerator) |
| Denominator | `flex_closed_trx_by_closed_date_monthly` | "Flex Transactions" (definition A denominator) |

This is an approximation of **definition (A) Flex PA-to-ZHL Adoption**, not (B) EM Program Adoption. It does **not** include ZHL-to-PA or PA Influenced loans, and it does **not** restrict the denominator to EM-zip transactions.

> **Verify the denominator.** `flex_closed_trx_by_closed_date_monthly` is buy-side closed transactions attributed by closed date. Other plausible denominators in the same table:
> - `flex_closed_transactions` (lifetime/state-of-the-world cumulative — wrong for monthly)
> - `flex_all_trx_logged_or_closed_last_180d` (already a 180-day window — useful for L180)
> - `zhl_distinct_transaction_closed_dates` (only transactions where ZHL had activity — would inflate the rate)
>
> The monthly buy-side close column is the most natural for rolling-window analysis. For audit-grade work, reconcile against the Tableau scorecard.

## The Funnel (for context)

```
eligible connection → engaged → credit pulled → pre-approved → locked → funded
                                                                            ↓
                                                                     ÷ TRANSACTIONS
                                                                            =
                                                                       ADOPTION
```

| Stage | Flag column on `agent_metrics_monthly` |
|---|---|
| Eligible connection | `zhl_buyer_connection` |
| Engaged / contacted | `zhl_engaged_contacted_flag_sum` |
| Credit pulled | `zhl_credit_pulled_flag_sum` |
| Pre-approved | `zhl_preapproved_flag_sum` |
| Locked | `zhl_locked_flag_sum` |
| Funded | `zhl_funded_flag_sum` |

## Rate Definitions — The Whole Family

| Metric | Numerator | Denominator | When to use |
|---|---|---|---|
| **Adoption rate** *(canonical)* | `zhl_funded_flag_sum` | `flex_closed_trx_by_closed_date_monthly` | The default. Outcome-anchored thresholds, executive reporting, "are agents using ZHL." |
| **Funded-per-connection** | `zhl_funded_flag_sum` | `zhl_buyer_connection` | Deep-funnel diagnostic. Will be tiny (~0.6% pop). Avoid using as "adoption" — it conflates routing efficiency with adoption behavior. |
| **Locked-per-transaction** | `zhl_locked_flag_sum` | `flex_closed_trx_by_closed_date_monthly` | Leading indicator of adoption (5–8 weeks ahead of funded). |
| **Pre-approval attach rate (PA/EC)** | `activity_non_pac_purchase_preapprovals_monthly` | `zhl_buyer_connection` | The pPRE numerator/denominator. Top-of-funnel attach. Population pooled rate ≈ 4%. |
| **Pre-approval rate (PA/MW)** | `activity_non_pac_purchase_preapprovals_monthly` | `activity_met_with_flex_live_non_pac_zhl_buy_box_connections_monthly` | Used by production scoring (`agent_performance_scoring.eligible_preapprovals_l90 / eligible_met_with_l90`). Higher correlation with funded (r=0.334 vs 0.303), but susceptible to met-with under-reporting gaming. Population pooled rate ≈ 12%. |
| **Adaptive PA rate (zPRE)** | per-agent | blend of PA/MW (mature) ↔ PA/EC (cold) | Smoothed, cold-start-capable. See `notebooks/ppre_model.py` § 10.4. Volume blend saturates at ~15 met-withs. |

## Two Denominator Choices to Be Conscious Of

1. **For pre-approval attach rate**, the denominator decision is `zhl_buyer_connection` (eligible connections, system-recorded, can't be gamed) vs met-withs (more predictive but gameable). Default to eligible connections; the production scoring system uses met-withs but is currently being revisited for that reason. See `docs/pre-approval-denominator-comparison.md`.

2. **For adoption (funded)**, the denominator decision is **transactions** (canonical) vs eligible connections (deep-funnel). Adoption is per-transaction. Funded-per-connection is a different question.

## Time Windows

- **L90D (last 90 days)** — production standard. `agent_performance_scoring` columns suffixed `_l90` use this. All scoring and rating logic.
- **L30D** — sometimes used for "recent" cuts.
- **Last 180D** — what `flex_closed_trx_by_closed_date_last_180d` provides directly without requiring aggregation.
- **Monthly snapshots** — `agent_metrics_monthly` is the source; aggregate with `SUM(...) GROUP BY agent_zuid` over a `data_month BETWEEN ... AND ...` range.

When comparing periods month-over-month, use the same window length on both sides; mixing L90D with L30D will mislead you about stability.

## Source Tables

- **`premier_agent.agent_gold.agent_metrics_monthly`** — event counts per agent per month. Source for all rates, including transactions.
- **`premier_agent.agent_gold.agent_performance_scoring`** — production scoring snapshot with pre-aggregated `_l90` columns and integer `fair_target` / `high_target` cuts. Source of truth for what's currently rated.
- **`premier_agent.agent_gold.agent_performance_ranking`** — historical tier labels (`performance_tier_current`).

## Standard SQL Pattern (3-month rollup, all metrics)

```sql
SELECT
    CAST(agent_zuid AS STRING) AS agent_zuid,
    SUM(zhl_buyer_connection)                                                   AS elig_cxn,
    SUM(activity_met_with_flex_live_non_pac_zhl_buy_box_connections_monthly)    AS elig_mw,
    SUM(flex_closed_trx_by_closed_date_monthly)                                 AS transactions,   -- adoption denom
    SUM(activity_non_pac_purchase_preapprovals_monthly)                         AS pa,
    SUM(zhl_preapproved_flag_sum)                                               AS preapproved,
    SUM(zhl_locked_flag_sum)                                                    AS locked,
    SUM(zhl_funded_flag_sum)                                                    AS funded         -- adoption num
FROM premier_agent.agent_gold.agent_metrics_monthly
WHERE data_month BETWEEN '2026-01-01' AND '2026-03-01'
GROUP BY CAST(agent_zuid AS STRING)
HAVING SUM(flex_closed_trx_by_closed_date_monthly) > 0;   -- only agents with real transactions
```

Then compute the canonical adoption rate as `funded / transactions`. Compute pre-approval attach rate as `pa / elig_cxn`.

## Gotchas

1. **"Adoption" is ambiguous — Flex PA-to-ZHL vs. EM Program.** See the top of this doc. The "20% adoption goal" most likely refers to **EM Program Adoption** (currently <15% in mature markets, broader numerator, EM-zip denominator). The agent-level approximation we compute from `agent_metrics_monthly` is closer to **Flex PA-to-ZHL Adoption**. They're not the same number; pooled rates differ. State which one you mean.
2. **"Adoption" is per-transaction, not per-connection.** Funded ÷ eligible connections is a deep-funnel diagnostic that conflates routing efficiency, agent quality, and adoption behavior into one number. It's NOT what stakeholders mean when they say "20% adoption goal."
3. **`zhl_preapproved_flag_sum` ≠ `activity_non_pac_purchase_preapprovals_monthly`.** The first is all ZHL pre-approvals; the second filters to non-PAC purchase pre-approvals (the production PRE numerator). Don't mix them across an analysis.
4. **PRE rating thresholds (5%, 10%) are calibrated for the raw rate world.** They will not produce sensible distributions on smoothed signals (zPRE, shrinkage estimates). Re-anchor thresholds for any new signal — see `docs/ppre-proposal-onepager.md` and the experiments in `scripts/experiments/`.
5. **PA/MW ≠ PA/EC.** PA/MW (per met-with) and PA/EC (per eligible connection) differ by the meeting rate (~30% of connections become met-withs). A "10% PRE" under PA/MW is roughly a "3% PRE" under PA/EC. The production scoring grades on PA/MW; the business often thinks in PA/EC. Always state the denominator.
6. **Filter on agents with real transactions.** Adoption rate is undefined for an agent with zero transactions in the period. Use `HAVING SUM(transactions) > 0` or equivalent.
7. **CRM-derived columns are deprecated.** Prefer the system-recorded `flex_closed_trx_by_closed_date_monthly` over any CRM-tied transaction count.
8. **`em_flag = TRUE`** restricts to "eligible market" agents — the population the scoring system actually rates. Most analysis should filter on this.
9. **Cohorting matters.** "Adoption Cohorted by Flex Transaction Month" matches downstream outcomes (transfers, fundings) back to the originating transaction month — this is the cleanest view, but lags. "Activity-based" views compute current-month numerator over current-month denominator and are noisier but timely. The Tableau scorecard uses cohorted; ad-hoc rollups from `agent_metrics_monthly` are activity-based unless you explicitly cohort.

## When Setting a Threshold from an Adoption Goal

To work backwards from an adoption target (e.g., "High tier agents should average 20% adoption"):

1. Compute each agent's score (zPRE, raw rate, whatever).
2. Compute each agent's realized adoption using the canonical definition (`funded / transactions`).
3. Sweep the score threshold; for each candidate cut, compute the **pooled** adoption rate of agents above it (weight by transactions, not equal-weight by agent — the question is "what fraction of transactions actually convert," not "what is the average agent's rate").
4. Pick the threshold where pooled adoption equals the target.

Filter to agents with `transactions > 0` so undefined rates don't pollute the sweep.
