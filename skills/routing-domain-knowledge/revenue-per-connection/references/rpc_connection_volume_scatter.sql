SELECT
  CAST(cf.consolidated_agent_zuid AS BIGINT) AS agent_zuid,
  apr.performance_tier_current AS tier,
  COUNT(DISTINCT cf.messageid) AS connections,
  SUM(COALESCE(cf.collected_revenue, 0) + COALESCE(cf.collected_revenue_2, 0)) AS total_revenue,
  SUM(COALESCE(cf.collected_revenue, 0) + COALESCE(cf.collected_revenue_2, 0))
    / COUNT(DISTINCT cf.messageid) AS rpc,
  SUM(CASE WHEN cf.transaction_flag = 1 AND cf.transaction_status_label != 'Cancelled' THEN 1 ELSE 0 END) AS closed_transactions,
  ROUND(
    SUM(CASE WHEN cf.transaction_flag = 1 AND cf.transaction_status_label != 'Cancelled' THEN 1 ELSE 0 END)
    * 100.0 / COUNT(DISTINCT cf.messageid), 2
  ) AS cvr_pct
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
HAVING COUNT(DISTINCT cf.messageid) >= 3
ORDER BY connections DESC
