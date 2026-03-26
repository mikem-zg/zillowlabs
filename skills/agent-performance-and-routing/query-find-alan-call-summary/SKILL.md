---
name: query-find-alan-call-summary
description: Reference for querying premier_agent.connections_gold.find_alan_call_summary — call-level summary for agent connections including live connection status and business line. Use when analyzing FACS connection counts, call outcomes, or agent connection activity.
evolving: true
last_reviewed: 2026-03-22
---

# Data Table: `premier_agent.connections_gold.find_alan_call_summary`

> **Living document**: Each time this skill is used, review and improve it based on new learnings. Add gotchas, column clarifications, or query patterns discovered during use.

## Overview

| Property | Value |
|----------|-------|
| **Catalog** | `premier_agent` |
| **Schema** | `connections_gold` |
| **Table** | `find_alan_call_summary` |
| **Grain** | One row per call event |
| **Owner Team** | Premier Agent Analytics |
| **Used By** | Agent Debugger (Team Level) notebooks, connection analysis |

## Purpose

Provides call-level summary data for agent connections through the Find ALAN (Automated Lead Assignment Network) system. Each row represents a call event, recording whether it resulted in a live connection, when the call occurred, and the business line. Used in team-level analysis to count FACS (Find ALAN Call Summary) connections per agent.

## Columns

| Column | Type | Description |
|--------|------|-------------|
| `call_agent_zuid` | INT | Agent ZUID who received/handled the call. |
| `live_connection` | BOOLEAN/INT | Whether the call resulted in a live connection with the consumer. |
| `call_time` | TIMESTAMP | When the call occurred. |
| `business_line` | STRING | Business line classification for the call (e.g., buyer, seller). |

## Historical Data

**YES** — historical data available via `call_time`. Records maintained over time for trend analysis.

## Key Relationships

- **`call_agent_zuid` → `agent_performance_ranking.agent_zuid`**: Join for performance tier context
- **`call_agent_zuid` → `agentplatform.assigneezuid`**: Links to agent enrollment
- **`call_agent_zuid` → `routing_cxn_share_new_buckets.plf_alan_Zuid`**: Compare FACS connections with routing connection share

## Common Query Patterns

### Team Level: Count FACS connections by agent over last 30 days
```sql
SELECT
  call_agent_zuid AS agent_zuid,
  COUNT(*) AS total_calls,
  SUM(CASE WHEN live_connection = 1 THEN 1 ELSE 0 END) AS live_connections,
  ROUND(SUM(CASE WHEN live_connection = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS live_connection_rate
FROM premier_agent.connections_gold.find_alan_call_summary
WHERE call_agent_zuid IN (<agent_zuid_list>)
  AND call_time >= DATE_SUB(CURRENT_DATE(), 30)
GROUP BY call_agent_zuid
ORDER BY live_connections DESC;
```

### Team Level: Count FACS connections for all agents on a team
```sql
SELECT
  facs.call_agent_zuid AS agent_zuid,
  COUNT(*) AS total_calls,
  SUM(CASE WHEN facs.live_connection = 1 THEN 1 ELSE 0 END) AS live_connections
FROM premier_agent.connections_gold.find_alan_call_summary facs
INNER JOIN touring.leadroutingservice_bronze.agentplatform ap
  ON facs.call_agent_zuid = ap.assigneezuid
WHERE ap.ownerzuid = <team_lead_zuid>
  AND ap.programid = 3
  AND ap.deletedat IS NULL
  AND facs.call_time >= DATE_SUB(CURRENT_DATE(), 30)
GROUP BY facs.call_agent_zuid
ORDER BY live_connections DESC;
```

### Daily call volume trend for an agent
```sql
SELECT
  CAST(call_time AS DATE) AS call_date,
  COUNT(*) AS total_calls,
  SUM(CASE WHEN live_connection = 1 THEN 1 ELSE 0 END) AS live_connections
FROM premier_agent.connections_gold.find_alan_call_summary
WHERE call_agent_zuid = <agent_zuid>
  AND call_time >= DATE_SUB(CURRENT_DATE(), 30)
GROUP BY CAST(call_time AS DATE)
ORDER BY call_date;
```

### Breakdown by business line
```sql
SELECT
  business_line,
  COUNT(*) AS total_calls,
  SUM(CASE WHEN live_connection = 1 THEN 1 ELSE 0 END) AS live_connections
FROM premier_agent.connections_gold.find_alan_call_summary
WHERE call_agent_zuid = <agent_zuid>
  AND call_time >= DATE_SUB(CURRENT_DATE(), 30)
GROUP BY business_line;
```
