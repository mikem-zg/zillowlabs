team_config_query = """

/*
Select the latest allocation_run_id for each parent_zuid in the latest monthly allocation
Note: this will *not* include incremental zero outs
Note: to use the latest including zero outs, use max(allocation_run_id) for curr_run_id
*/

with current_hma as (
select *
from premier_agent.agent_gold.hybrid_market_allocations
where 1=1
and date(algo_run_date) = (select max(date(algo_run_date)) from premier_agent.agent_gold.hybrid_market_allocations)
),

partner_allocations_curr_run_id as (
  select
    parent_zuid,
    min(allocation_run_id) as curr_run_id
  from current_hma
  group by
    parent_zuid
),

/*
Sum all the allocated targets (over all zips, agents) grouped by parent_zuid and allocation_program
*/

partner_program_allocations as (
  select
    hma.parent_zuid as team_zuid,
    hma.allocation_program,
    max(date(effective_date)) as effective_date,
    ceil(coalesce(sum(hma.agent_zip_allocated_cxn), 0.0)) as team_cxn_target
  from current_hma hma
  inner join partner_allocations_curr_run_id pid
    on hma.parent_zuid = pid.parent_zuid
    and hma.allocation_run_id = pid.curr_run_id
  group by
    hma.parent_zuid,
    hma.allocation_program
)

/*
Final select statement where we limit to buyer program only
*/
select * from partner_program_allocations
where allocation_program = 'buyer'

"""