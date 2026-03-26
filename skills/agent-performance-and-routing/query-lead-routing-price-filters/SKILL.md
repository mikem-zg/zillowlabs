---
name: query-lead-routing-price-filters
description: Reference for querying touring.leadroutingservice_bronze.price — agent price filter rules that define min/max price ranges for lead routing. Use when analyzing agent price preferences, understanding lead eligibility filters, or reconstructing point-in-time price ranges.
evolving: true
last_reviewed: 2026-03-22
---

# Data Table: `touring.leadroutingservice_bronze.price`

> **Living document**: Each time this skill is used, review and improve it based on new learnings. Add gotchas, column clarifications, or query patterns discovered during use.

## Overview

| Property | Value |
|----------|-------|
| **Catalog** | `touring` |
| **Schema** | `leadroutingservice_bronze` |
| **Table** | `price` |
| **Grain** | One row per agent price filter rule |
| **Owner Team** | Metro (Touring) |
| **Source System** | Lead Routing Service (LRS) Aurora MySQL → Databricks bronze |
| **Used By** | Agent Debugger (Team Level) notebooks, lead eligibility analysis |

## Purpose

Stores agent price filter rules that define the min/max price ranges an agent is willing to accept leads for. Joined via `agentplatform` (through `agentProgramId`) to associate price filters with specific agents. Used in team-level analysis to understand which agents accept leads in which price ranges, and to reconstruct historical price filter states by expanding rules across a calendar.

## Columns

| Column | Type | Description |
|--------|------|-------------|
| `agentProgramId` | INT | FK to `agentplatform.id`. Links this price filter to a specific agent-program enrollment. |
| `min` | DECIMAL | Minimum price the agent will accept leads for. |
| `max` | DECIMAL | Maximum price the agent will accept leads for. `NULL` may indicate no upper bound. |
| `createdAt` | DATETIME(6) | When the price filter rule was created. |
| `deletedAt` | DATETIME(6) | When the price filter rule was soft-deleted. `NULL` = active. |
| `updatedAt` | DATETIME(6) | When the price filter rule was last updated. |

## Historical Data

**Current-state only** for active rules (`deletedAt IS NULL`). However, historical rules are preserved via soft-delete (`deletedAt` is set rather than the row being removed). By examining `createdAt`, `updatedAt`, and `deletedAt`, you can reconstruct the history of price filter changes.

## Key Relationships

- **`agentProgramId` → `agentplatform.id`**: Links price filters to the agent-program enrollment record
- **Through `agentplatform`**: `agentplatform.assigneezuid` → agent ZUID, `agentplatform.ownerzuid` → team lead ZUID
- **`agentProgramId` → `capacity.agentprogramid`**: Can also join to capacity via the same enrollment ID

## Common Query Patterns

### Get active price filters for all agents on a team
```sql
SELECT
  ap.assigneezuid AS agent_zuid,
  ap.ownerzuid AS team_lead_zuid,
  p.min AS price_min,
  p.max AS price_max,
  p.createdAt,
  p.updatedAt
FROM touring.leadroutingservice_bronze.agentplatform ap
JOIN touring.leadroutingservice_bronze.price p
  ON ap.id = p.agentProgramId
WHERE ap.ownerzuid = <team_lead_zuid>
  AND ap.programid = 3
  AND ap.deletedat IS NULL
  AND p.deletedAt IS NULL
ORDER BY ap.assigneezuid, p.min;
```

### Team Level: Expand price filter rules across a calendar for point-in-time ranges
```sql
WITH date_spine AS (
  SELECT EXPLODE(SEQUENCE(
    DATE_SUB(CURRENT_DATE(), 30),
    CURRENT_DATE(),
    INTERVAL 1 DAY
  )) AS cal_date
),
agent_prices AS (
  SELECT
    ap.assigneezuid AS agent_zuid,
    p.min AS price_min,
    p.max AS price_max,
    CAST(p.createdAt AS DATE) AS rule_start,
    COALESCE(CAST(p.deletedAt AS DATE), CURRENT_DATE()) AS rule_end
  FROM touring.leadroutingservice_bronze.agentplatform ap
  JOIN touring.leadroutingservice_bronze.price p
    ON ap.id = p.agentProgramId
  WHERE ap.ownerzuid = <team_lead_zuid>
    AND ap.programid = 3
    AND ap.deletedat IS NULL
)
SELECT
  d.cal_date,
  ap.agent_zuid,
  ap.price_min,
  ap.price_max
FROM date_spine d
JOIN agent_prices ap
  ON d.cal_date >= ap.rule_start
  AND d.cal_date <= ap.rule_end
ORDER BY d.cal_date, ap.agent_zuid, ap.price_min;
```

### Find agents with no price filters set
```sql
SELECT
  ap.assigneezuid AS agent_zuid,
  ap.ownerzuid AS team_lead_zuid
FROM touring.leadroutingservice_bronze.agentplatform ap
LEFT JOIN touring.leadroutingservice_bronze.price p
  ON ap.id = p.agentProgramId
  AND p.deletedAt IS NULL
WHERE ap.programid = 3
  AND ap.deletedat IS NULL
  AND p.agentProgramId IS NULL;
```

### Price range distribution across a team
```sql
SELECT
  ap.assigneezuid AS agent_zuid,
  COUNT(*) AS num_price_rules,
  MIN(p.min) AS lowest_min,
  MAX(p.max) AS highest_max
FROM touring.leadroutingservice_bronze.agentplatform ap
JOIN touring.leadroutingservice_bronze.price p
  ON ap.id = p.agentProgramId
WHERE ap.ownerzuid = <team_lead_zuid>
  AND ap.programid = 3
  AND ap.deletedat IS NULL
  AND p.deletedAt IS NULL
GROUP BY ap.assigneezuid
ORDER BY lowest_min;
```

### History of price filter changes for an agent
```sql
SELECT
  p.min AS price_min,
  p.max AS price_max,
  p.createdAt,
  p.updatedAt,
  p.deletedAt,
  CASE WHEN p.deletedAt IS NULL THEN 'Active' ELSE 'Deleted' END AS status
FROM touring.leadroutingservice_bronze.agentplatform ap
JOIN touring.leadroutingservice_bronze.price p
  ON ap.id = p.agentProgramId
WHERE ap.assigneezuid = <agent_zuid>
  AND ap.programid = 3
ORDER BY p.createdAt DESC;
```
