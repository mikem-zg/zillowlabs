-- Self-pause history for a single agent
-- Returns: pause start/end times and reasons for a specific agent
-- Usage: Replace <agent_zuid> with the agent's ZUID (BIGINT)

SELECT
  CAST(sp.assigneeZillowUserId AS BIGINT) AS agent_zuid,
  a.eventDate AS pause_start,
  a.unpausedAtSetTo AS pause_end,
  a.agentReason,
  GREATEST(
    TIMESTAMPDIFF(HOUR,
      GREATEST(a.eventDate, CAST(DATE_SUB(CURRENT_DATE(), 30) AS TIMESTAMP)),
      LEAST(COALESCE(a.unpausedAtSetTo, CURRENT_TIMESTAMP()), CURRENT_TIMESTAMP())
    ), 0
  ) AS hours_paused
FROM touring.agentavailability_bronze.agentselfpause sp
JOIN touring.agentavailability_bronze.agentselfpauseaudit a
  ON sp.id = a.agentSelfPauseId
WHERE CAST(sp.assigneeZillowUserId AS BIGINT) = <agent_zuid>
  AND a.eventDate >= DATE_SUB(CURRENT_DATE(), 60)
  AND (a.unpausedAtSetTo IS NULL
       OR a.unpausedAtSetTo > CAST(DATE_SUB(CURRENT_DATE(), 30) AS TIMESTAMP))
  AND (a.agentReason IS NULL OR a.agentReason != 'manual-unpause')
ORDER BY a.eventDate DESC;
