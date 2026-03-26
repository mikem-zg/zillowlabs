---
name: query-candidate-agent-ranking-history
description: Reference for querying touring.connectionpacing_bronze.candidateagentrankinghistory — agent ranking positions, scoring factors, and ranking method per lead. Use when debugging agent routing decisions, analyzing ranking distributions, or understanding why an agent was or wasn't selected for a lead.
evolving: true
last_reviewed: 2026-03-22
---

# Data Table: `touring.connectionpacing_bronze.candidateagentrankinghistory`

> **Living document**: Each time this skill is used, review and improve it based on new learnings. Add gotchas, column clarifications, or query patterns discovered during use.

## Overview

| Property | Value |
|----------|-------|
| **Catalog** | `touring` |
| **Schema** | `connectionpacing_bronze` |
| **Table** | `candidateagentrankinghistory` |
| **Grain** | One row per (agent, lead) ranking event |
| **Owner Team** | Conductors (connection-pacing service) |
| **Source System** | Connection-pacing service → Databricks bronze replication |
| **Used By** | Agent Debugger notebooks, ML Routing Sims, routing analysis |

## Purpose

Records every agent's ranking position and scoring factors for each lead routing request. This is the detailed audit trail of the connection-pacing service's agent ranking decisions. Essential for debugging why a specific agent was ranked at a given position for a specific lead, analyzing ranking factor distributions, and comparing ranking methods (e.g., ALR vs BAT).

## Columns

| Column | Type | Description |
|--------|------|-------------|
| `AgentZuid` | INT | Agent ZUID — the agent who was ranked for this lead. |
| `LeadID` | INT | The lead identifier for the routing request. |
| `AgentAbsPos` | INT | Agent's absolute ranking position for this lead (1 = top-ranked). |
| `AgentRankingFactors` | STRING (JSON) | JSON blob containing scoring factors. Key fields: `performance_score`, `capacity_penalty_factor`, `weighted_capacity`, `ranking_method`, `performance_score_type`. |
| `RequestedAt` | TIMESTAMP | When the ranking request was made. |
| `ZipCode` | STRING | ZIP code of the lead. |
| `TeamZuid` | INT | Team lead ZUID for the ranked agent. |

## AgentRankingFactors JSON Structure

The `AgentRankingFactors` column is a JSON string. Parse with `GET_JSON_OBJECT` or `FROM_JSON`. Key fields:

| JSON Field | Type | Description |
|------------|------|-------------|
| `performance_score` | FLOAT | The agent's performance score used in ranking. |
| `capacity_penalty_factor` | FLOAT | Penalty applied for being over capacity (1.0 = no penalty, lower = more penalized). |
| `weighted_capacity` | FLOAT | Agent's weighted capacity value. |
| `ranking_method` | STRING | The routing method used (e.g., `'ALR'`, `'BAT'`). |
| `performance_score_type` | STRING | Type of performance score applied. |

## Historical Data

**YES** — every ranking event is logged with `RequestedAt` timestamp. Data goes back historically. Each lead routing request generates one row per candidate agent considered.

## Key Relationships

- **`AgentZuid` → `agent_performance_ranking.agent_zuid`**: Links ranking events to agent performance tiers
- **`AgentZuid` → `agentplatform.assigneezuid`**: Links to agent enrollment
- **`TeamZuid` → `agent_performance_ranking.team_lead_zuid`**: Links to team lead
- **`LeadID` → `findpro_opportunity_result_v1.lead_id`**: Join to see which ranked agents were actually called (FindPro call-down list)
- **`ZipCode`**: Can join to ZIP-level tables for market context

## Common Query Patterns

### Agent Debugger: 30-day ranking profile for a single agent
```sql
SELECT
  AgentZuid,
  LeadID,
  AgentAbsPos,
  GET_JSON_OBJECT(AgentRankingFactors, '$.performance_score') AS perf_score,
  GET_JSON_OBJECT(AgentRankingFactors, '$.capacity_penalty_factor') AS capacity_penalty,
  GET_JSON_OBJECT(AgentRankingFactors, '$.weighted_capacity') AS weighted_capacity,
  GET_JSON_OBJECT(AgentRankingFactors, '$.ranking_method') AS ranking_method,
  GET_JSON_OBJECT(AgentRankingFactors, '$.performance_score_type') AS perf_score_type,
  RequestedAt,
  ZipCode
FROM touring.connectionpacing_bronze.candidateagentrankinghistory
WHERE AgentZuid = <agent_zuid>
  AND RequestedAt >= DATE_SUB(CURRENT_DATE(), 30)
ORDER BY RequestedAt DESC;
```

### Agent Debugger: Team-level ranking profile (all agents on a team)
```sql
SELECT
  AgentZuid,
  LeadID,
  AgentAbsPos,
  GET_JSON_OBJECT(AgentRankingFactors, '$.performance_score') AS perf_score,
  GET_JSON_OBJECT(AgentRankingFactors, '$.capacity_penalty_factor') AS capacity_penalty,
  GET_JSON_OBJECT(AgentRankingFactors, '$.weighted_capacity') AS weighted_capacity,
  GET_JSON_OBJECT(AgentRankingFactors, '$.ranking_method') AS ranking_method,
  GET_JSON_OBJECT(AgentRankingFactors, '$.performance_score_type') AS perf_score_type,
  RequestedAt,
  ZipCode
FROM touring.connectionpacing_bronze.candidateagentrankinghistory
WHERE TeamZuid = <team_lead_zuid>
  AND RequestedAt >= DATE_SUB(CURRENT_DATE(), 30)
ORDER BY AgentZuid, RequestedAt DESC;
```

### ML Routing Sims: Join ranking history with agent scores for A/B test analysis
```sql
SELECT
  rh.AgentZuid,
  rh.LeadID,
  rh.AgentAbsPos,
  GET_JSON_OBJECT(rh.AgentRankingFactors, '$.performance_score') AS perf_score,
  GET_JSON_OBJECT(rh.AgentRankingFactors, '$.ranking_method') AS ranking_method,
  s.agent_score
FROM touring.connectionpacing_bronze.candidateagentrankinghistory rh
LEFT JOIN premier_agent.agent_silver.agent_score s
  ON rh.AgentZuid = s.agent_zuid
  AND CAST(rh.RequestedAt AS DATE) = s.agent_performance_date
WHERE rh.RequestedAt >= DATE_SUB(CURRENT_DATE(), 30);
```

### Analyze ranking position distribution for an agent
```sql
SELECT
  AgentZuid,
  COUNT(*) AS total_rankings,
  AVG(AgentAbsPos) AS avg_position,
  MIN(AgentAbsPos) AS best_position,
  MAX(AgentAbsPos) AS worst_position,
  PERCENTILE_APPROX(AgentAbsPos, 0.5) AS median_position
FROM touring.connectionpacing_bronze.candidateagentrankinghistory
WHERE AgentZuid = <agent_zuid>
  AND RequestedAt >= DATE_SUB(CURRENT_DATE(), 30)
GROUP BY AgentZuid;
```

### Compare ranking methods (ALR vs BAT) for a team
```sql
SELECT
  GET_JSON_OBJECT(AgentRankingFactors, '$.ranking_method') AS ranking_method,
  COUNT(*) AS lead_count,
  AVG(AgentAbsPos) AS avg_position
FROM touring.connectionpacing_bronze.candidateagentrankinghistory
WHERE TeamZuid = <team_lead_zuid>
  AND RequestedAt >= DATE_SUB(CURRENT_DATE(), 30)
GROUP BY GET_JSON_OBJECT(AgentRankingFactors, '$.ranking_method');
```
