-- Self-pause percentage (business-hours — refined definition)
-- Includes weekends with shorter hours, excludes major holidays,
-- uses per-day hour counts in the denominator
-- Denominator: SUM(day_biz_hours) across the 30-day window
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
    CASE WHEN DAYOFWEEK(cal_date) BETWEEN 2 AND 6
        THEN CAST(cal_date AS TIMESTAMP) + INTERVAL 8 HOURS
        ELSE CAST(cal_date AS TIMESTAMP) + INTERVAL 9 HOURS
    END AS biz_start,
    CASE WHEN DAYOFWEEK(cal_date) BETWEEN 2 AND 6
        THEN CAST(cal_date AS TIMESTAMP) + INTERVAL 21 HOURS
        ELSE CAST(cal_date AS TIMESTAMP) + INTERVAL 20 HOURS
    END AS biz_end,
    CASE WHEN DAYOFWEEK(cal_date) BETWEEN 2 AND 6 THEN 13.0 ELSE 11.0 END AS day_biz_hours
  FROM date_spine
  WHERE NOT (MONTH(cal_date) = 12 AND DAY(cal_date) = 25)
    AND NOT (MONTH(cal_date) = 11 AND DAY(cal_date) BETWEEN 25 AND 28)
),
total_biz AS (
  SELECT SUM(day_biz_hours) AS total_biz_hours FROM biz_hours
),
pause_events AS (
  SELECT
    CAST(CAST(sp.assigneeZillowUserId AS BIGINT) AS STRING) AS agent_zuid,
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
    GREATEST(TIMESTAMPDIFF(MINUTE,
      GREATEST(pe.pause_start, bh.biz_start),
      LEAST(pe.pause_end, bh.biz_end)
    ), 0) / 60.0 AS overlap_hours
  FROM pause_events pe
  CROSS JOIN biz_hours bh
  WHERE pe.pause_start < bh.biz_end
    AND pe.pause_end > bh.biz_start
)
SELECT
  o.agent_zuid,
  LEAST(ROUND(SUM(o.overlap_hours) / tb.total_biz_hours * 100, 2), 100) AS self_pause_biz_pct
FROM overlap o
CROSS JOIN total_biz tb
GROUP BY o.agent_zuid, tb.total_biz_hours;
