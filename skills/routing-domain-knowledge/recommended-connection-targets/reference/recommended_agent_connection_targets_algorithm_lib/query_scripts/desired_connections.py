desired_connections_query = """
select
  agent_zuid,
  requested_cxns,
  last_update
from (
  select
    cast(zuid as bigint) as agent_zuid,
    cast(desired_cxns as int) as requested_cxns,
    last_update,
    row_number() over (partition by zuid order by last_update desc nulls last) as rn
  from touring.desiredconnections_bronze.agent_capacity_capacity_tblzvbnyyozkstfdb
) where rn = 1

"""