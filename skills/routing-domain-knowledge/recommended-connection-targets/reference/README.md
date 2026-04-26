# Reference: Recommended Agent Connection Targets — source files

These are **read-only** copies of the upstream source files for the recommended-targets algorithm, captured to make this skill self-contained for offline review without re-querying GitLab.

**Captured**: 2026-04-26
**Captured against**: `main` branch of `analytics/artificial-intelligence/agent-analytics-and-ai/applied-science/recommended_agent_connection_targets_algorithm` on `gitlab.zgtools.net`
**Method**: Glean `readDocument` (URLs listed below)

## File map (mirrors the upstream repo layout)

| Local path under `reference/` | Upstream path |
|---|---|
| `update_recommended_agent_connection_targets_task.py` | `src/recommended_agent_connection_targets_algorithm/update_recommended_agent_connection_targets_task.py` |
| `recommended_agent_connection_targets_algorithm_lib/agent_connection_targets_recommender.py` | `src/recommended_agent_connection_targets_algorithm/recommended_agent_connection_targets_algorithm_lib/agent_connection_targets_recommender.py` |
| `recommended_agent_connection_targets_algorithm_lib/query_scripts/team_config.py` | `…/recommended_agent_connection_targets_algorithm_lib/query_scripts/team_config.py` |
| `recommended_agent_connection_targets_algorithm_lib/query_scripts/agent_data.py` | `…/recommended_agent_connection_targets_algorithm_lib/query_scripts/agent_data.py` |
| `recommended_agent_connection_targets_algorithm_lib/query_scripts/desired_connections.py` | `…/recommended_agent_connection_targets_algorithm_lib/query_scripts/desired_connections.py` |
| `recommended_agent_connection_targets_algorithm_lib/schemas/input_data_schemas.py` | `…/recommended_agent_connection_targets_algorithm_lib/schemas/input_data_schemas.py` |
| `tests/test_agent_connection_targets_recommender.py` | `tests/test_agent_connection_targets_recommender.py` |
| `example_queries.sql` | *(local — not from upstream)* |

## What each file contains

- **`update_recommended_agent_connection_targets_task.py`** — Spark task wrapper. Owns the run flow: `collect_input_data → combine_and_convert_input_data → calculate_recommended_agent_connection_targets → write_recommended_agent_connection_targets`. Defines `OUTPUT_SCHEMA_RENAMING_MAP` and the EM/non-EM bucket normalization (`'N/A' → 'NA'`, `'Mid' → 'Fair'`) and the 21-day-since-update `Unresponsive` derivation.
- **`agent_connection_targets_recommender.py`** — pure-pandas algorithm class. Defines `IDEAL_CXNS_CONFIG` (the 5×5 matrix), `DEFAULT_VALUES`, `get_max_cxns_and_reason` (per-agent two-pass rule flow + reason-text construction), `adjust_cxn_targets_based_on_team_allocation`, `handle_above_capacity_teams`, `handle_below_capacity_teams`, validation.
- **`query_scripts/team_config.py`** — SQL for the team allocation totals (latest `algo_run_date`, smallest `allocation_run_id` per `parent_zuid`, sum of `agent_zip_allocated_cxn`, filtered to `allocation_program = 'buyer'`).
- **`query_scripts/agent_data.py`** — SQL for per-agent performance signals from `agent_performance_ranking`, with EM-conditional column switching (`cvr_tier_v2/cvr_tier`, `zhl_pre_approval_target_rating/'NA'`, `performance_tier_current/performance_tier`, `rank_current/rank_v1`) and the most-recent-Sunday `agent_performance_date` pin.
- **`query_scripts/desired_connections.py`** — SQL for the Airtable agent-survey desired-connections feed (latest row per `zuid` from `touring.desiredconnections_bronze.agent_capacity_capacity_tblzvbnyyozkstfdb`).
- **`schemas/input_data_schemas.py`** — pyspark `StructType` definitions for `team_config_schema`, `agent_data_schema`, `desired_connections_schema`.
- **`tests/test_agent_connection_targets_recommender.py`** — canonical worked-example reference (~40 cases) covering matrix lookups, hard rules, requested-cxns overrides, unresponsive branches, pickup-rate penalty (rows 37–42), and reason-text fragments. **Read this whenever you're unsure what reason string a given input combo produces** — the expected outputs in this file are the source of truth.
- **`example_queries.sql`** — 15 copy-paste-ready Databricks SQL queries built and verified against `premier_agent.agent_gold.recommended_agent_connection_targets` snapshot 2026-04-25. Covers latest-snapshot lookup, per-agent / per-team rollups, reconciliation invariant, ideal distribution, hard-rule integrity, per-cell matrix verification (text-only and joined), reason fragment census, pickup-penalty cohort tracking, EM/non-EM split, day-over-day target stability, multi-team membership, and upstream-bucket join. Use these as the starting point for any analytical question against the table.

## How to refresh these files

If the upstream repo has changed, refresh via Glean code search.

### Approach 1 — Direct `readDocument` by URL (preferred)

Inside `code_execution`:

```javascript
const urls = [
  "https://gitlab.zgtools.net/analytics/artificial-intelligence/agent-analytics-and-ai/applied-science/recommended_agent_connection_targets_algorithm/-/blob/main/src/recommended_agent_connection_targets_algorithm/recommended_agent_connection_targets_algorithm_lib/agent_connection_targets_recommender.py",
  "https://gitlab.zgtools.net/analytics/artificial-intelligence/agent-analytics-and-ai/applied-science/recommended_agent_connection_targets_algorithm/-/blob/main/src/recommended_agent_connection_targets_algorithm/update_recommended_agent_connection_targets_task.py",
  "https://gitlab.zgtools.net/analytics/artificial-intelligence/agent-analytics-and-ai/applied-science/recommended_agent_connection_targets_algorithm/-/blob/main/src/recommended_agent_connection_targets_algorithm/recommended_agent_connection_targets_algorithm_lib/query_scripts/team_config.py",
  "https://gitlab.zgtools.net/analytics/artificial-intelligence/agent-analytics-and-ai/applied-science/recommended_agent_connection_targets_algorithm/-/blob/main/src/recommended_agent_connection_targets_algorithm/recommended_agent_connection_targets_algorithm_lib/query_scripts/agent_data.py",
  "https://gitlab.zgtools.net/analytics/artificial-intelligence/agent-analytics-and-ai/applied-science/recommended_agent_connection_targets_algorithm/-/blob/main/src/recommended_agent_connection_targets_algorithm/recommended_agent_connection_targets_algorithm_lib/query_scripts/desired_connections.py",
  "https://gitlab.zgtools.net/analytics/artificial-intelligence/agent-analytics-and-ai/applied-science/recommended_agent_connection_targets_algorithm/-/blob/main/src/recommended_agent_connection_targets_algorithm/recommended_agent_connection_targets_algorithm_lib/schemas/input_data_schemas.py",
  "https://gitlab.zgtools.net/analytics/artificial-intelligence/agent-analytics-and-ai/applied-science/recommended_agent_connection_targets_algorithm/-/blob/main/tests/test_agent_connection_targets_recommender.py",
];
const result = await mcpGlean_readDocument({ urls });
const parsed = JSON.parse(result.content[0].text);
for (const d of parsed.documents) {
  const c = d.richDocumentData?.content || d.content || "";
  let body = c;
  try { body = JSON.parse(c).pageBody || c; } catch (e) {}
  // ...write body to the matching local path under reference/
}
```

### Approach 2 — Glean code search (if you don't already have the URLs)

Inside `code_execution`:

```javascript
const out = await mcpGlean_codeSearch({
  query: "IDEAL_CXNS_CONFIG cvr_bucket zhl_preapprovals_bucket",
  // optional: pageSize: 10
});
console.log(out.content[0].text);
```

Other useful queries for this codebase:
- `"AgentConnectionTargetsRecommender" repo:recommended_agent_connection_targets_algorithm`
- `"OUTPUT_SCHEMA_RENAMING_MAP"` — finds `update_recommended_agent_connection_targets_task.py`
- `"team_config_query"` — finds `query_scripts/team_config.py`
- `"agent_data_query"` — finds `query_scripts/agent_data.py`
- `"desired_connections_query"` — finds `query_scripts/desired_connections.py`
- `"handle_above_capacity_teams"` or `"handle_below_capacity_teams"` — reconciliation logic

The result entries include the GitLab `blob/...` URL you can pass to `mcpGlean_readDocument` as in Approach 1.

### After refreshing

1. Diff against the previous version: `git diff HEAD reference/`.
2. Update the parent `SKILL.md` for any algorithmic changes (matrix cells, default values, rule order, reason-text fragments, schema rename map).
3. Bump `last_reviewed` and `last_verified_against` in the parent `SKILL.md` frontmatter.
4. If the matrix changed, also update the "Recent change context" section with per-cell deltas.

## Caveats

- **Not a live mirror.** These files are static copies as of the capture date. Always check `last_verified_against` in the parent `SKILL.md` and consider refreshing for any non-trivial change.
- **Source-of-truth precedence**: if the parent `SKILL.md` and these files disagree, the reference files win — refresh the skill to match.
- **Do not edit** the files in this folder by hand. They are upstream-owned. If you find a bug, fix it upstream and re-pull.
