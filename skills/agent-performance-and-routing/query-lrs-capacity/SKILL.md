---
name: query-lrs-capacity
description: Reference for querying agent capacity (PaceCar target) tables. Covers both legacy premier_agent.crm_bronze.lrs_Capacity and the new touring.leadroutingservice_bronze.capacity. Use when looking up agent connection targets or capacity settings.
evolving: true
last_reviewed: 2026-03-21
---

# Data Table: Agent Capacity (PaceCar Target)

> **Living document**: Each time this skill is used, review and improve it based on new learnings. Add gotchas, column clarifications, or query patterns discovered during use.

## ⚠️ MIGRATION ALERT

**The `premier_agent.crm_bronze.lrs_*` tables will stop refreshing after March 30, 2026.** Use the new Touring-owned table path:

| Old Path (DEPRECATED) | New Path |
|------------------------|----------|
| `premier_agent.crm_bronze.lrs_Capacity` | `touring.leadroutingservice_bronze.capacity` |

See `query-lrs-agent-platform` skill for the full migration mapping.

## Overview

| Property | Value |
|----------|-------|
| **Catalog (new)** | `touring` |
| **Schema (new)** | `leadroutingservice_bronze` |
| **Table (new)** | `capacity` |
| **Catalog (legacy)** | `premier_agent` |
| **Schema (legacy)** | `crm_bronze` |
| **Table (legacy)** | `lrs_Capacity` |
| **Source System** | Lead Routing Service (LRS) Aurora MySQL → Databricks bronze |
| **Grain** | One row per agent-program enrollment |
| **Owner Team** | Metro (Touring) |

## Purpose

Stores the **current** connection target (PaceCar target) per agent-program enrollment. This is the capacity value set in the Agent Connection Planning UI — how many connections the agent is targeted to receive. Links to `agentplatform` via `agentprogramid`.

**Important:** Only exists for the **buyer program** — seller does not use PaceCar (seller uses round-robin distribution instead).

## Columns

| Column | Type | Description |
|--------|------|-------------|
| `id` | INT | Primary key. |
| `capacity` | INT | Current connection target value (PaceCar target). The number of connections this agent is configured to receive in the next ~30 days. |
| `createdat` | DATETIME(6) | When the capacity record was created. |
| `updatedat` | DATETIME(6) | Last update timestamp. |
| `deletedat` | DATETIME(6) | Soft delete timestamp. `NULL` = active. |
| `agentprogramid` | INT | FK to `agentplatform.id`. Links capacity to the specific agent-program enrollment. |

## Historical Data

**Current-state only** in the capacity table. For historical capacity changes, use:

- **CapacityHistory table**: `touring.leadroutingservice_snapshot_bronze.capacityhistory`
- Columns: `id`, `capacitySetTo`, `createdAt`, `ownerZuid`, `assigneeZuid`, `changedAt`, `changedById`

### Reconstructing Historical Capacity

To find the capacity at a specific point in time:
```sql
SELECT capacitySetTo
FROM touring.leadroutingservice_snapshot_bronze.capacityhistory
WHERE assigneeZuid = <agent_zuid>
  AND createdAt <= '<target_date>'
ORDER BY createdAt DESC
LIMIT 1;
```

## Key Relationships

- **`agentprogramid` → `agentplatform.id`**: Links capacity to the agent-program enrollment record
- **Downstream to model**: Capacity value becomes the `agent_cxns_target` feature

## Learnings from Prediction Model Development

### Target=0 Is the Strongest Zero-Connection Predictor
**Experiment 1 finding**: When `capacity = 0` (or NULL), the agent receives exactly 0 connections. The model's `target_is_zero` binary feature is the single most reliable zero-connection predictor. This is a mechanical routing constraint, not a model prediction.

### Target Value as Model Feature
The capacity value is used to derive several model features:
- `agent_cxns_target`: Direct capacity value (from PaceCar)
- `target_is_zero`: Binary flag (`1` when capacity = 0 or NULL)
- `hma_vs_target_ratio`: `agent_total_hma / agent_cxns_target` — measures how well the allocation model covers the target
- `target_pct_used_prior`: Prior-period actual connections / target — measures historical delivery rate

### Target Setting Validation (Exp 13)
Controlling for market (MSA), there's a strong positive relationship between target and actual connections (expected since routing respects targets). However, targets are often set much higher than what the market can deliver — the median agent receives only ~40-60% of their target.

### Capping for Analysis
For delivery ratio analysis, cap targets at a realistic max to avoid distortion:
```python
MAX_REALISTIC_TARGET = 15
pred_df['capped_target'] = pred_df['agent_cxns_target'].clip(upper=MAX_REALISTIC_TARGET)
```

### Missing Capacity
When capacity is NULL (no record in the table), it means the agent's target hasn't been set. This is different from `capacity = 0` (explicitly set to zero). For ML features:
```sql
COALESCE(c.capacity, 0) AS agent_cxns_target
```

## Common Query Patterns

### Get current capacity for all active Flex agents (NEW TABLE)
```sql
SELECT
  a.assigneezuid AS agent_zuid,
  a.ownerzuid AS team_lead_zuid,
  c.capacity
FROM touring.leadroutingservice_bronze.agentplatform a
LEFT JOIN touring.leadroutingservice_bronze.capacity c
  ON a.id = c.agentprogramid
WHERE a.programid = 3
  AND a.deletedat IS NULL;
```

### Find agents with no capacity set
```sql
SELECT
  a.assigneezuid AS agent_zuid,
  a.ownerzuid AS team_lead_zuid
FROM touring.leadroutingservice_bronze.agentplatform a
LEFT JOIN touring.leadroutingservice_bronze.capacity c
  ON a.id = c.agentprogramid
WHERE a.programid = 3
  AND a.deletedat IS NULL
  AND c.capacity IS NULL;
```

### Get capacity distribution across teams
```sql
SELECT
  a.ownerzuid AS team_lead_zuid,
  COUNT(*) AS agent_count,
  SUM(c.capacity) AS total_team_capacity,
  AVG(c.capacity) AS avg_agent_capacity
FROM touring.leadroutingservice_bronze.agentplatform a
JOIN touring.leadroutingservice_bronze.capacity c
  ON a.id = c.agentprogramid
WHERE a.programid = 3
  AND a.deletedat IS NULL
GROUP BY a.ownerzuid;
```

### Get capacity with performance data for model input
```sql
SELECT
  a.assigneezuid AS agent_zuid,
  a.ownerzuid AS team_lead_zuid,
  COALESCE(c.capacity, 0) AS agent_cxns_target,
  CASE WHEN COALESCE(c.capacity, 0) = 0 THEN 1 ELSE 0 END AS target_is_zero,
  p.performance_tier_current,
  p.buyside_agent_cvr
FROM touring.leadroutingservice_bronze.agentplatform a
LEFT JOIN touring.leadroutingservice_bronze.capacity c ON a.id = c.agentprogramid
LEFT JOIN premier_agent.agent_gold.agent_performance_ranking p
  ON a.assigneezuid = p.agent_zuid AND a.ownerzuid = p.team_lead_zuid
  AND p.agent_performance_date = (SELECT MAX(agent_performance_date) FROM premier_agent.agent_gold.agent_performance_ranking)
WHERE a.programid = 3 AND a.deletedat IS NULL;
```
