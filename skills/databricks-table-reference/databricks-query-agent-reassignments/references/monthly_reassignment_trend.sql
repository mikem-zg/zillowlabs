WITH isa_agents AS (
  SELECT DISTINCT
    get_json_object(_airbyte_data, '$.teamMemberZuid') AS agent_zuid
  FROM touring.connectionrankingdata_airbyte_internal.connectionrankingdata_bronze_raw__stream_agentroutingroleassignment
  WHERE get_json_object(_airbyte_data, '$.agentRoutingRoleId') = '1'
    AND get_json_object(_airbyte_data, '$.deletedAt') IS NULL
)

SELECT
  DATE_FORMAT(contact_creation_date, 'yyyy-MM') AS month,
  COUNT(*) AS total_connections,
  SUM(CASE WHEN CAST(initial_agent_zuid AS STRING) != consolidated_agent_zuid
      THEN 1 ELSE 0 END) AS total_reassignments,
  SUM(CASE WHEN CAST(initial_agent_zuid AS STRING) != consolidated_agent_zuid
       AND contact_status_label IN (
         'New', 'Attempted contact', 'Spoke with customer',
         'Met with customer', 'Appointment set', 'Showing homes',
         'Submitting offers', 'Under contract', 'Active listing', 'Listing agreement'
       ) THEN 1 ELSE 0 END) AS active_reassignments,
  ROUND(
    SUM(CASE WHEN CAST(initial_agent_zuid AS STRING) != consolidated_agent_zuid
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
  ) AS overall_reassignment_rate_pct,
  ROUND(
    SUM(CASE WHEN CAST(initial_agent_zuid AS STRING) != consolidated_agent_zuid
         AND contact_status_label IN (
           'New', 'Attempted contact', 'Spoke with customer',
           'Met with customer', 'Appointment set', 'Showing homes',
           'Submitting offers', 'Under contract', 'Active listing', 'Listing agreement'
         ) THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
  ) AS active_reassignment_rate_pct
FROM mortgage.cross_domain_gold.combined_funnels_pa_zhl cf
WHERE pa_lead_type = 'Connection'
  AND connection_msa_market_ops_flag = 1
  AND contact_creation_date >= '2024-01-01'
  AND contact_creation_date < '2026-01-01'
  AND contact_creation_date < date_sub(current_date(), 90)
  AND consolidated_agent_zuid NOT IN (SELECT agent_zuid FROM isa_agents)
GROUP BY DATE_FORMAT(contact_creation_date, 'yyyy-MM')
ORDER BY month
