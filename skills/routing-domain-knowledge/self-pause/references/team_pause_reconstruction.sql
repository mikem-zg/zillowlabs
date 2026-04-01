-- Team-pause window reconstruction
-- Team-pause (team-lead-initiated) stores state transitions, not explicit
-- start/end. Uses LEAD() window function to reconstruct pause intervals
-- from isPaused = true → next state change.
-- Usage: Replace {period_start} and {analysis_end} with date strings

SELECT agent_zuid, pause_start, pause_end FROM (
    SELECT
        p.assigneeZillowUserId                        AS agent_zuid,
        CAST(a.updateDate AS TIMESTAMP)               AS pause_start,
        COALESCE(
            LEAD(CAST(a.updateDate AS TIMESTAMP)) OVER (
                PARTITION BY a.agentPauseId ORDER BY a.updateDate
            ),
            TIMESTAMP '{analysis_end}T23:59:59'
        )                                              AS pause_end,
        a.isPaused
    FROM premier_agent.crm_bronze.leadrouting_AgentPauseAudit a
    JOIN premier_agent.crm_bronze.leadrouting_AgentPause p
        ON a.agentPauseId = p.agentPauseId
)
WHERE isPaused = true
  AND pause_end >= TIMESTAMP '{period_start}'
  AND pause_start <= TIMESTAMP '{analysis_end}T23:59:59';
