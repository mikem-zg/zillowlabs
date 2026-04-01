WITH agent_rpc AS (
  SELECT
    CAST(cf.consolidated_agent_zuid AS BIGINT) AS agent_zuid,
    apr.performance_tier_current AS tier,
    COUNT(DISTINCT cf.messageid) AS connections,
    SUM(COALESCE(cf.collected_revenue, 0) + COALESCE(cf.collected_revenue_2, 0)) AS total_revenue,
    SUM(COALESCE(cf.collected_revenue, 0) + COALESCE(cf.collected_revenue_2, 0))
      / COUNT(DISTINCT cf.messageid) AS rpc
  FROM mortgage.cross_domain_gold.combined_funnels_pa_zhl cf
  INNER JOIN premier_agent.agent_gold.agent_performance_ranking apr
    ON CAST(cf.consolidated_agent_zuid AS BIGINT) = apr.agent_zuid
    AND apr.agent_performance_date = (
      SELECT MAX(agent_performance_date)
      FROM premier_agent.agent_gold.agent_performance_ranking
    )
  WHERE cf.pa_lead_type = 'Connection'
    AND cf.connection_msa_market_ops_flag = 1
    AND cf.contact_creation_date >= DATE_SUB(CURRENT_DATE(), 180)
    AND cf.contact_creation_date < DATE_SUB(CURRENT_DATE(), 90)
    AND (cf.transaction_status_label IS NULL OR cf.transaction_status_label != 'Cancelled')
  GROUP BY
    CAST(cf.consolidated_agent_zuid AS BIGINT),
    apr.performance_tier_current
  HAVING COUNT(DISTINCT cf.messageid) >= 5
)
SELECT
  tier,
  COUNT(*) AS agent_count,
  ROUND(AVG(rpc), 2) AS avg_rpc,
  ROUND(PERCENTILE_APPROX(rpc, 0.10), 2) AS p10,
  ROUND(PERCENTILE_APPROX(rpc, 0.25), 2) AS p25,
  ROUND(PERCENTILE_APPROX(rpc, 0.50), 2) AS p50_median,
  ROUND(PERCENTILE_APPROX(rpc, 0.75), 2) AS p75,
  ROUND(PERCENTILE_APPROX(rpc, 0.90), 2) AS p90,
  ROUND(AVG(connections), 1) AS avg_connections_per_agent
FROM agent_rpc
GROUP BY tier
ORDER BY
  CASE tier
    WHEN 'High' THEN 1
    WHEN 'Fair' THEN 2
    WHEN 'Low' THEN 3
  END
