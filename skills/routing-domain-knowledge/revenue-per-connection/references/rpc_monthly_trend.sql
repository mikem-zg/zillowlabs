SELECT
  DATE_TRUNC('month', cf.contact_creation_date) AS month,
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
  AND cf.contact_creation_date >= DATE_SUB(CURRENT_DATE(), 455)
  AND cf.contact_creation_date < DATE_SUB(CURRENT_DATE(), 90)
  AND (cf.transaction_status_label IS NULL OR cf.transaction_status_label != 'Cancelled')
GROUP BY
  DATE_TRUNC('month', cf.contact_creation_date),
  apr.performance_tier_current
ORDER BY month, tier
