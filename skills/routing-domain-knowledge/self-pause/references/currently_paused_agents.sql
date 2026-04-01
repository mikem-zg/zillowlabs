-- Check which agents are currently self-paused
-- Returns: agent_zuid, isPaused flag, scheduled unpause time, last update

SELECT
  CAST(assigneeZillowUserId AS BIGINT) AS agent_zuid,
  isPaused,
  unpausedAt,
  updateDate
FROM touring.agentavailability_bronze.agentselfpause
WHERE isPaused = TRUE;
