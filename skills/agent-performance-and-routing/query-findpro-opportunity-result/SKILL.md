---
name: query-findpro-opportunity-result
description: Reference for querying connections_platform.findpro.findpro_opportunity_result_v1 — records of which agents were called for each lead (FindPro call-down list execution). Use when analyzing agent call-down results, comparing ranked vs called agents, or debugging connection delivery.
evolving: true
last_reviewed: 2026-03-22
---

# Data Table: `connections_platform.findpro.findpro_opportunity_result_v1`

> **Living document**: Each time this skill is used, review and improve it based on new learnings. Add gotchas, column clarifications, or query patterns discovered during use.

## Overview

| Property | Value |
|----------|-------|
| **Catalog** | `connections_platform` |
| **Schema** | `findpro` |
| **Table** | `findpro_opportunity_result_v1` |
| **Grain** | One row per (lead, agent) call attempt |
| **Owner Team** | Connections Platform |
| **Source System** | FindPro service → Databricks |
| **Used By** | Agent Debugger notebooks, routing analysis, connection delivery debugging |

## Purpose

Records the outcome of FindPro call-down list execution — which agents were actually called for each lead. This is the execution layer downstream of the connection-pacing ranking. While `candidateagentrankinghistory` shows who was *ranked*, this table shows who was *called*. Joining the two reveals "ranked but not called" gaps, which are critical for understanding connection delivery failures.

## Columns

| Column | Type | Description |
|--------|------|-------------|
| `lead_id` | INT | The lead identifier. Join key to `candidateagentrankinghistory.LeadID`. |
| `user_id` | INT | Agent ZUID — the agent who was called for this lead. |
| `user_id_type` | STRING | Type of user ID (typically identifies the ZUID type). |
| `created_at` | TIMESTAMP | When the call attempt record was created. |

## Historical Data

**YES** — records are timestamped via `created_at`. Historical data available for analyzing call-down patterns over time.

## Key Relationships

- **`lead_id` → `candidateagentrankinghistory.LeadID`**: Join to compare ranked agents vs actually-called agents
- **`user_id` → `candidateagentrankinghistory.AgentZuid`**: Maps called agent to their ranking position
- **`user_id` → `agent_performance_ranking.agent_zuid`**: Links to agent performance data
- **`user_id` → `agentplatform.assigneezuid`**: Links to agent enrollment

## Common Query Patterns

### Agent Debugger: Find leads where agent was ranked but NOT called
```sql
WITH ranked AS (
  SELECT DISTINCT LeadID, AgentZuid
  FROM touring.connectionpacing_bronze.candidateagentrankinghistory
  WHERE AgentZuid = <agent_zuid>
    AND RequestedAt >= DATE_SUB(CURRENT_DATE(), 30)
),
called AS (
  SELECT DISTINCT lead_id, user_id
  FROM connections_platform.findpro.findpro_opportunity_result_v1
  WHERE user_id = <agent_zuid>
    AND created_at >= DATE_SUB(CURRENT_DATE(), 30)
)
SELECT
  r.LeadID,
  CASE WHEN c.lead_id IS NOT NULL THEN 'Called' ELSE 'Ranked but NOT Called' END AS status
FROM ranked r
LEFT JOIN called c
  ON r.LeadID = c.lead_id AND r.AgentZuid = c.user_id;
```

### Agent Debugger: Count ranked vs called leads for an agent
```sql
WITH ranked AS (
  SELECT DISTINCT LeadID
  FROM touring.connectionpacing_bronze.candidateagentrankinghistory
  WHERE AgentZuid = <agent_zuid>
    AND RequestedAt >= DATE_SUB(CURRENT_DATE(), 30)
),
called AS (
  SELECT DISTINCT lead_id
  FROM connections_platform.findpro.findpro_opportunity_result_v1
  WHERE user_id = <agent_zuid>
    AND created_at >= DATE_SUB(CURRENT_DATE(), 30)
)
SELECT
  COUNT(DISTINCT r.LeadID) AS total_ranked,
  COUNT(DISTINCT c.lead_id) AS total_called,
  COUNT(DISTINCT r.LeadID) - COUNT(DISTINCT c.lead_id) AS ranked_not_called
FROM ranked r
LEFT JOIN called c ON r.LeadID = c.lead_id;
```

### Count call attempts per agent in a date range
```sql
SELECT
  user_id AS agent_zuid,
  COUNT(*) AS call_attempts,
  COUNT(DISTINCT lead_id) AS unique_leads
FROM connections_platform.findpro.findpro_opportunity_result_v1
WHERE created_at >= DATE_SUB(CURRENT_DATE(), 30)
GROUP BY user_id
ORDER BY call_attempts DESC;
```

### Join ranking position with call-down execution
```sql
SELECT
  rh.AgentZuid,
  rh.LeadID,
  rh.AgentAbsPos,
  GET_JSON_OBJECT(rh.AgentRankingFactors, '$.ranking_method') AS ranking_method,
  fp.created_at AS call_time
FROM touring.connectionpacing_bronze.candidateagentrankinghistory rh
INNER JOIN connections_platform.findpro.findpro_opportunity_result_v1 fp
  ON rh.LeadID = fp.lead_id AND rh.AgentZuid = fp.user_id
WHERE rh.AgentZuid = <agent_zuid>
  AND rh.RequestedAt >= DATE_SUB(CURRENT_DATE(), 30)
ORDER BY rh.RequestedAt DESC;
```
