WITH apr_current AS (
  SELECT agent_zuid, performance_tier_current AS current_tier
  FROM premier_agent.agent_gold.agent_performance_ranking
  WHERE agent_performance_date = (
    SELECT MAX(agent_performance_date)
    FROM premier_agent.agent_gold.agent_performance_ranking
  )
),
apr_prior AS (
  SELECT agent_zuid, performance_tier AS prior_tier
  FROM premier_agent.agent_gold.agent_performance_ranking
  WHERE agent_performance_date = (
    SELECT MAX(agent_performance_date)
    FROM premier_agent.agent_gold.agent_performance_ranking
    WHERE agent_performance_date < DATE_SUB(CURRENT_DATE(), 90)
  )
),
transitions AS (
  SELECT
    p.agent_zuid,
    p.prior_tier,
    c.current_tier,
    CONCAT(p.prior_tier, ' -> ', c.current_tier) AS transition
  FROM apr_prior p
  INNER JOIN apr_current c ON p.agent_zuid = c.agent_zuid
  WHERE p.prior_tier != c.current_tier
)
SELECT
  t.transition,
  t.prior_tier,
  t.current_tier,
  COUNT(DISTINCT t.agent_zuid) AS agent_count,
  COUNT(DISTINCT cf.messageid) AS connections,
  SUM(COALESCE(cf.collected_revenue, 0) + COALESCE(cf.collected_revenue_2, 0)) AS total_revenue,
  SUM(COALESCE(cf.collected_revenue, 0) + COALESCE(cf.collected_revenue_2, 0))
    / NULLIF(COUNT(DISTINCT cf.messageid), 0) AS rpc
FROM transitions t
LEFT JOIN mortgage.cross_domain_gold.combined_funnels_pa_zhl cf
  ON CAST(cf.consolidated_agent_zuid AS BIGINT) = t.agent_zuid
  AND cf.pa_lead_type = 'Connection'
  AND cf.connection_msa_market_ops_flag = 1
  AND cf.contact_creation_date >= DATE_SUB(CURRENT_DATE(), 180)
  AND cf.contact_creation_date < DATE_SUB(CURRENT_DATE(), 90)
  AND (cf.transaction_status_label IS NULL OR cf.transaction_status_label != 'Cancelled')
GROUP BY
  t.transition,
  t.prior_tier,
  t.current_tier
ORDER BY agent_count DESC
