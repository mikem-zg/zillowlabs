---
name: query-agent-zip-predicted-cxns
description: Reference for the legacy sandbox_pa.agent_ops.agent_zip_predicted_cxns table — the old HMA-based prediction table. DEPRECATED in favor of the LightGBM Hurdle model. Retained for historical reference only.
evolving: true
last_reviewed: 2026-03-21
status: DEPRECATED
---

# Data Table: `sandbox_pa.agent_ops.agent_zip_predicted_cxns` (DEPRECATED)

> **DEPRECATED**: This table has been superseded by the LightGBM Hurdle model (Exp 22b). The main dashboard (`app.py`) no longer uses this table. Some historical research pages (9, 10) still reference it but are candidates for removal.
>
> **Living document**: Each time this skill is used, review and improve it based on new learnings.

## Why It Was Replaced

The `agent_zip_predicted_cxns` table is assembled from HMA allocations using a simple capacity-weighted formula (buyer) or round-robin (seller). It does NOT account for:
- Agent behavioral signals (answer rate, CVR, pickup rate)
- Temporal trends (30d vs 60d deltas)
- Market dynamics (agent density effects, ZIP profiles)
- Cold-start patterns (lookalike ZIP features)

The LightGBM Hurdle model (54 features) reduces agent-level MAE from 4.95 to 2.62 connections — a **47% improvement** over HMA-based predictions.

## What Replaced It

| Component | Old | New |
|-----------|-----|-----|
| Data source | `sandbox_pa.agent_ops.agent_zip_predicted_cxns` | `data_cache/eval_mktops_*.parquet` + model prediction |
| Model | Capacity-weighted allocation | LightGBM Hurdle (classifier + regressor) |
| Model file | N/A (SQL assembly) | `artifacts/zip_hurdle_model.pkl` |
| Training script | N/A | `scripts/train_zip_model.py` |
| Dataset builder | N/A | `scripts/build_mktops_dataset.py` |
| Features | 0 (capacity only) | 54 (behavioral, market, trend, lookalike, target, self-pause) |

## Overview (Historical Reference)

| Property | Value |
|----------|-------|
| **Catalog** | `sandbox_pa` |
| **Schema** | `agent_ops` |
| **Table Type** | Created via `CREATE OR REPLACE TABLE` (manual refresh) |
| **Grain** | One row per agent x team lead x ZIP x program (buyer/seller) |

## Source Tables

| Source Table | Role |
|--------------|------|
| `premier_agent.agent_gold.hybrid_market_allocations` | Core allocation data |
| `premier_agent.agent_gold.agent_performance_ranking` | Agent performance tier |
| `premier_agent.crm_bronze.lrs_AgentPlatform` | Agent program enrollment |
| `premier_agent.crm_bronze.lrs_Capacity` | PaceCar capacity targets |

## Assembly Logic

### Buyer (Capacity-Weighted)
```
agent_zip_predicted_cxns = (agent_capacity / SUM(team_capacity_in_zip)) x team_zip_total_allocation
```

### Seller (Round-Robin)
```
agent_zip_predicted_cxns = (1 / agent_count_in_zip) x team_zip_total_allocation
```

## Key Columns

| Column | Type | Description |
|--------|------|-------------|
| `team_lead_zuid` | INT | Team lead ZUID |
| `agent_zuid` | INT | Agent ZUID |
| `zip` | VARCHAR(5) | 5-digit ZIP code |
| `allocation_program` | VARCHAR | `'buyer'` or `'seller'` |
| `agent_cxns_target` | INT | PaceCar target (NULL for seller) |
| `agent_zip_predicted_cxns` | DECIMAL | Estimated connections |
| `performance_tier_current` | VARCHAR | Agent performance tier |

## Files That Still Reference This Table

As of 2026-03-21:
- `pages/9_Research_Archive.py` — historical experiments
- `pages/10_Big_Miss_Investigation.py` — missed alarm analysis
- `pages/5_ZIP_Predictions_Lab.py` — research lab (reconstructs similar logic)
- `models/retrain_model.py` — old training script
- `models/train_high_classifier.py` — old classifier training

**None of these are part of the current production pipeline.**
