-- Team Level: Self-pause percentage (24x7 — standard)
-- Returns: agent_zuid and self_pause_pct (0-100, capped)
-- Denominator: 720 hours (30 days x 24 hours)
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
    COALESCE(a.unpausedAtSetTo, CURRENT_TIMESTAMP()) AS pause_end
  FROM touring.agentavailability_bronze.agentselfpause sp
  JOIN touring.agentavailability_bronze.agentselfpauseaudit a
    ON sp.id = a.agentSelfPauseId
  WHERE CAST(sp.assigneeZillowUserId AS BIGINT) IN (SELECT agent_zuid FROM team_agents)
    AND a.eventDate >= DATE_SUB(CURRENT_DATE(), 30)
    AND (a.agentReason IS NULL OR a.agentReason != 'manual-unpause')
)
SELECT
  agent_zuid,
  LEAST(
    ROUND(
      SUM(
        GREATEST(
          TIMESTAMPDIFF(HOUR,
            GREATEST(pause_start, CAST(DATE_SUB(CURRENT_DATE(), 30) AS TIMESTAMP)),
            LEAST(pause_end, CURRENT_TIMESTAMP())
          ), 0
        )
      ) / 720.0 * 100, 2
    ), 100
  ) AS self_pause_pct
FROM pause_events
GROUP BY agent_zuid;
