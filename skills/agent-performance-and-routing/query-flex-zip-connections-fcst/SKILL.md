# Query: flex_zip_connections_fcst

## Table
`sandbox_pa.revenue_optimization.flex_zip_connections_fcst`

## Purpose
ZIP-level flex connection forecasts. Serves two roles:
1. **Forecast trend chart** — shows how total forecasted connections change month-over-month
2. **Simulation baseline** — provides the AOP flex forecast that simulation results are compared against

## Columns Used

| Column | Type | Description |
|--------|------|-------------|
| `forecast_month` | DATE/STRING | The month being forecasted |
| `flex_forecast_date` | DATE/STRING | The date the forecast was generated (vintage) |
| `fcst_flex_allocated_cxns` | DOUBLE | Forecasted flex allocated connections per ZIP |
| `zipcode` | STRING | 5-digit ZIP code |

## Common Patterns

### Forecast trend (latest forecast per month)
The key constraint: only use forecasts made *before* the month they predict (`flex_forecast_date < forecast_month`):
```sql
WITH max_dates AS (
  SELECT
    forecast_month,
    MAX(flex_forecast_date) as max_fcst_date
  FROM sandbox_pa.revenue_optimization.flex_zip_connections_fcst
  WHERE forecast_month >= '2024-01-01'
    AND flex_forecast_date < forecast_month
  GROUP BY forecast_month
)
SELECT
  a.forecast_month,
  ROUND(SUM(a.fcst_flex_allocated_cxns), 0) as forecast_cxn
FROM sandbox_pa.revenue_optimization.flex_zip_connections_fcst a
INNER JOIN max_dates md
  ON a.forecast_month = md.forecast_month
  AND a.flex_forecast_date = md.max_fcst_date
GROUP BY a.forecast_month
ORDER BY a.forecast_month
```

### Simulation baseline (latest forecast for a specific target month)
For simulation comparison, uses the absolute latest forecast date (no `< forecast_month` constraint):
```sql
SELECT
  COALESCE(CAST(zm.msa_regionid AS STRING), '000000') AS msa_regionid,
  COALESCE(zm.msa, 'No MSA Mapping / Unmapped ZIPs') AS msa,
  ROUND(SUM(a.fcst_flex_allocated_cxns), 1) AS aop_flex_forecast
FROM sandbox_pa.revenue_optimization.flex_zip_connections_fcst a
LEFT JOIN enterprise.conformed_dimension.dim_zip_mapping zm
  ON a.zipcode = zm.zipcode
WHERE a.flex_forecast_date = (
  SELECT MAX(flex_forecast_date)
  FROM sandbox_pa.revenue_optimization.flex_zip_connections_fcst
)
  AND a.forecast_month = '${forecastDateFinal}'
GROUP BY ...
```
The target month (`forecastDateFinal`) is computed dynamically as next month from the current date.

## Frontend Data Flow

### Dashboard — Forecast Trend Card
`/api/allocations/forecast-trend` returns `[{ forecast_month, forecast_cxn }, ...]`. Rendered as a Recharts `LineChart` on the dashboard showing the forecast trajectory over time. The `forecast_month` is formatted with `formatForecastMonth()` (e.g., "Mar 2025").

### Dashboard — Simulation Modal — AOP Forecast by MSA Tab
The simulation endpoint (`/api/allocations/simulation`) uses this table as the baseline. The modal shows a table with columns:
- **AOP Forecast**: from this table (aggregated to MSA level)
- **Sim Allocation**: from `hybrid_market_simulations`
- **Delta (Sim − AOP)**: difference
- **Fill Rate**: sim_allocation / aop_flex_forecast × 100

Summary cards at the top show totals for AOP Flex Forecast, Sim Allocation, and Delta.

Color coding: Fill Rate >= 100% is green, >= 80% is yellow, < 80% is red.

## Key Notes
- **Two different date selection strategies**:
  1. Trend: `flex_forecast_date < forecast_month` (use only pre-period forecasts)
  2. Simulation: `MAX(flex_forecast_date)` regardless (use the absolute latest forecast)
- For simulation, the forecast month is dynamically set to `now.getMonth() + 2` (i.e., next month, 1-indexed).
- Joins to `dim_zip_mapping` on `zipcode` for MSA-level aggregation in simulation view.

## Used In (API Endpoints)
- `/api/allocations/forecast-trend` — monthly forecast trend chart
- `/api/allocations/simulation` — AOP flex forecast baseline for simulation comparison
