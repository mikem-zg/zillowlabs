-- Pause reason analysis: distribution of self-pause reasons in L30d
-- Returns: agentReason and event count, ordered by frequency
-- Note: agentReason is often NULL — this only shows events with a reason

SELECT
  a.agentReason,
  COUNT(*) AS event_count
FROM touring.agentavailability_bronze.agentselfpause sp
JOIN touring.agentavailability_bronze.agentselfpauseaudit a
  ON sp.id = a.agentSelfPauseId
WHERE a.eventDate >= DATE_SUB(CURRENT_DATE(), 30)
  AND a.agentReason IS NOT NULL
  AND a.agentReason != 'manual-unpause'
GROUP BY a.agentReason
ORDER BY event_count DESC;
