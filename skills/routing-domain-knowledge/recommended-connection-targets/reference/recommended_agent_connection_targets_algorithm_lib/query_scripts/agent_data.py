agent_data_query = """

select
team_lead_zuid as team_zuid,
agent_zuid,
em_flag,
case when em_flag = True then cvr_tier_v2 else cvr_tier end as cvr_bucket,
case when em_flag = True then zhl_pre_approval_target_rating else 'NA' end as zhl_preapprovals_bucket,
case when em_flag = True then performance_tier_current else performance_tier end as performance_bucket,
total_cxn_l30d as cxns_l30,
lifetime_connections as lifetime_cxns,
case when em_flag = True then rank_current else rank_v1 end as rank,
pickup_rate_penalty_applied,
agent_performance_date

from premier_agent.agent_gold.agent_performance_ranking
where 1=1
and agent_performance_date = 
(
select max(agent_performance_date)
from premier_agent.agent_gold.agent_performance_ranking
where agent_performance_date <= DATE_SUB(CURRENT_DATE, (DAYOFWEEK(CURRENT_DATE) - 1) + 1)
)
and active_flag = True

/*
logic for finding the agent_performance_date that existed on the most recent sunday
- get the current date
- subtract a number of days where number of days subtracted is composed by summing two parts:
1. the number of days to the most recent sunday = (day number of current day) - (day number of sunday (1)) (note: 1 = sunday, 7 = saturday)
2. 1 -- since the agent_performance_date is usually 1 days lagged
*/

"""