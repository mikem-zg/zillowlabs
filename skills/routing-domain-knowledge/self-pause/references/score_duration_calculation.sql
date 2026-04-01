-- Self-pause score: percentage of L30d hours an agent was self-paused
-- Formula: LEAST(hours_paused / 720 * 100, 100)
-- 720 = 30 days x 24 hours; capped at 100%
-- Pulls 60-day event window to capture pauses that started before L30d

WITH pause_durations AS (
    SELECT
        CAST(sp.assigneeZillowUserId AS BIGINT) as agent_zuid,
        a.eventDate as pause_start,
        COALESCE(a.unpausedAtSetTo, CURRENT_TIMESTAMP()) as pause_end
    FROM touring.agentavailability_bronze.agentselfpause sp
    JOIN touring.agentavailability_bronze.agentselfpauseaudit a
        ON sp.id = a.agentSelfPauseId
    WHERE a.eventDate >= DATE_SUB(CURRENT_DATE(), 60)
      AND (a.unpausedAtSetTo IS NULL
           OR a.unpausedAtSetTo > CAST(DATE_SUB(CURRENT_DATE(), 30) AS TIMESTAMP))
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
            ) / (30.0 * 24) * 100, 2
        ), 100
    ) as self_pause_score_pct
FROM pause_durations
GROUP BY agent_zuid;
