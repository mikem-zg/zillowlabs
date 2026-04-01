# RPC Reference Queries

SQL queries for analyzing Revenue Per Connection (RPC) across performance tiers, geographies, and time periods. All queries target Databricks and use the `mortgage.cross_domain_gold.combined_funnels_pa_zhl` and `premier_agent.agent_gold.agent_performance_ranking` tables.

## How to Run

Use the `run-databricks-query` skill to execute any of these queries from the Replit environment. Copy the SQL into the execution pattern described in that skill.

## Query Descriptions

| File | Description |
|------|-------------|
| `rpc_by_tier.sql` | Core query: aggregate RPC by High/Fair/Low tier for connections in the 90–180 day maturity window. Returns connections, total revenue, RPC, closed transactions, and CVR per tier. |
| `rpc_monthly_trend.sql` | Monthly RPC trend by tier over the trailing 12 months (with 90-day maturity buffer). Shows how RPC evolves over time for each tier. |
| `rpc_by_tier_and_business_line.sql` | RPC broken down by tier AND representation type (Buyer vs Seller). Reveals whether revenue differences by tier are driven by one side of the transaction. |
| `rpc_by_msa.sql` | RPC by tier within each MSA. Filters to MSAs with at least 50 connections to avoid noisy small-sample results. Useful for geographic targeting analysis. |
| `rpc_agent_distribution.sql` | Agent-level RPC distribution within each tier showing percentiles (p10, p25, p50, p75, p90). Requires agents to have at least 5 connections. Shows within-tier variance. |
| `rpc_tier_transition_impact.sql` | Revenue profile of agents who transitioned between tiers (e.g., Fair→High, Low→Fair). Helps quantify the revenue impact of tier upgrades/downgrades. |
| `rpc_connection_volume_scatter.sql` | Agent-level connection count vs RPC for scatter/correlation analysis. Includes CVR per agent. Useful for identifying whether high-volume agents have different RPC patterns. |

## Common Adjustments

- **Change the time window**: Modify `DATE_SUB(CURRENT_DATE(), 180)` and `DATE_SUB(CURRENT_DATE(), 90)` to shift the analysis period. Always maintain at least a 90-day maturity buffer.
- **Remove Market Ops filter**: Delete `AND cf.connection_msa_market_ops_flag = 1` to include all markets.
- **Filter to a specific MSA**: Add `AND cf.connection_msa = 'Your MSA Name'` to any query.
- **Historical tier matching**: Replace the `MAX(agent_performance_date)` subquery with a date-matched join for point-in-time tier accuracy.
