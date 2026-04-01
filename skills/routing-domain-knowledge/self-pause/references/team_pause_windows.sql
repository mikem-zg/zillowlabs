-- Team Level: Calculate self-pause windows for all agents on a team
-- Returns: agent_zuid, pause event count, and percent of L30d spent paused
-- Usage: Replace <team_lead_zuid> with the team lead's ZUID

WITH team_agents AS (
  SELECT assigneezuid AS agent_zuid
  FROM touring.leadroutingservice_bronze.agentplatform
  WHERE ownerzuid = <team_lead_zuid>
    AND programid = 3
    AND deletedat IS NULL
),
pause_events AS (
  SELECT
    CAST(sp.assigneeZillowUserId AS BIGINT) AS agent_zuid,
    a.eventDate AS pause_start,
    COALESCE(a.unpausedAtSetTo, CURRENT_TIMESTAMP()) AS pause_end,
    a.agentReason
  FROM touring.agentavailability_bronze.agentselfpause sp
  JOIN touring.agentavailability_bronze.agentselfpauseaudit a
    ON sp.id = a.agentSelfPauseId
  WHERE CAST(sp.assigneeZillowUserId AS BIGINT) IN (SELECT agent_zuid FROM team_agents)
    AND a.eventDate >= DATE_SUB(CURRENT_DATE(), 30)
    AND (a.agentReason IS NULL OR a.agentReason != 'manual-unpause')
)
SELECT
  agent_zuid,
  COUNT(*) AS pause_events,
  ROUND(SUM(
    GREATEST(
      TIMESTAMPDIFF(HOUR,
        GREATEST(pause_start, CAST(DATE_SUB(CURRENT_DATE(), 30) AS TIMESTAMP)),
        LEAST(pause_end, CURRENT_TIMESTAMP())
      ), 0
    )
  ) / (30.0 * 24) * 100, 2) AS pct_time_paused
FROM pause_events
GROUP BY agent_zuid
ORDER BY pct_time_paused DESC;
