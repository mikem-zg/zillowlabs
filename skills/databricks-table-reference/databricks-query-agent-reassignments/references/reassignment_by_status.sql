WITH isa_agents AS (
  SELECT DISTINCT
    get_json_object(_airbyte_data, '$.teamMemberZuid') AS agent_zuid
  FROM touring.connectionrankingdata_airbyte_internal.connectionrankingdata_bronze_raw__stream_agentroutingroleassignment
  WHERE get_json_object(_airbyte_data, '$.agentRoutingRoleId') = '1'
    AND get_json_object(_airbyte_data, '$.deletedAt') IS NULL
)

SELECT
  contact_status_label,
  COUNT(*) AS reassigned_leads,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_reassignments
FROM mortgage.cross_domain_gold.combined_funnels_pa_zhl cf
WHERE pa_lead_type = 'Connection'
  AND connection_msa_market_ops_flag = 1
  AND contact_creation_date >= '2024-01-01'
  AND contact_creation_date < '2026-01-01'
  AND contact_creation_date < date_sub(current_date(), 90)
  AND CAST(initial_agent_zuid AS STRING) != consolidated_agent_zuid
  AND consolidated_agent_zuid NOT IN (SELECT agent_zuid FROM isa_agents)
GROUP BY contact_status_label
ORDER BY reassigned_leads DESC
