-- Team Level: Self-pause percentage (business-hours only — weekdays 8am-8pm)
-- Restricts denominator and overlap calculation to business hours only
-- Denominator: ~264 hours (12 hrs/day x ~22 weekdays/month)
-- Usage: Replace <team_lead_zuid> with the team lead's ZUID

WITH team_agents AS (
  SELECT assigneezuid AS agent_zuid
  FROM touring.leadroutingservice_bronze.agentplatform
  WHERE ownerzuid = <team_lead_zuid>
    AND programid = 3
    AND deletedat IS NULL
),
date_spine AS (
  SELECT EXPLODE(SEQUENCE(
    DATE_SUB(CURRENT_DATE(), 30),
    CURRENT_DATE(),
    INTERVAL 1 DAY
  )) AS cal_date
),
biz_hours AS (
  SELECT
    cal_date,
    CAST(cal_date AS TIMESTAMP) + INTERVAL 8 HOURS AS biz_start,
    CAST(cal_date AS TIMESTAMP) + INTERVAL 20 HOURS AS biz_end
  FROM date_spine
  WHERE DAYOFWEEK(cal_date) BETWEEN 2 AND 6
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
    AND a.eventDate >= DATE_SUB(CURRENT_DATE(), 60)
    AND (a.unpausedAtSetTo IS NULL
         OR a.unpausedAtSetTo > CAST(DATE_SUB(CURRENT_DATE(), 30) AS TIMESTAMP))
    AND (a.agentReason IS NULL OR a.agentReason != 'manual-unpause')
),
overlap AS (
  SELECT
    pe.agent_zuid,
    GREATEST(
      TIMESTAMPDIFF(MINUTE,
        GREATEST(pe.pause_start, bh.biz_start),
        LEAST(pe.pause_end, bh.biz_end)
      ), 0
    ) / 60.0 AS overlap_hours
  FROM pause_events pe
  CROSS JOIN biz_hours bh
  WHERE pe.pause_start < bh.biz_end
    AND pe.pause_end > bh.biz_start
)
SELECT
  agent_zuid,
  LEAST(
    ROUND(SUM(overlap_hours) / (SELECT COUNT(*) * 12.0 FROM biz_hours) * 100, 2),
    100
  ) AS self_pause_biz_hrs_pct
FROM overlap
GROUP BY agent_zuid;
