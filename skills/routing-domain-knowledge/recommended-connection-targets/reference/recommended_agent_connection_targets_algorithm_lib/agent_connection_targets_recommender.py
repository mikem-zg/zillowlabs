import pandas as pd
import numpy as np


class AgentConnectionTargetsRecommender:
  """
  AgentConnectionTargetsRecommender holds the logic used to calculate the recommended agent connection targets based on compiled input data. It contains the methods needed to calculate the recommendations and return the results.
  """

  IDEAL_CXNS_CONFIG = {
    "ideal_cxns": {
        "cvr_bucket": {
            "Low": {
                "zhl_preapprovals_bucket": {
                    "Low": 1,
                    "Low-Fair": None,
                    "NA": 3,  # Use 'NA' instead of 'None'
                    "Fair": 1,
                    "High": 3
                }
            },
            "Low-Fair": {
                "zhl_preapprovals_bucket": {
                    "Low": 3,
                    "Low-Fair": None,
                    "NA": 5,  # Use 'NA' instead of 'None'
                    "Fair": 5,
                    "High": 5
                }
            },
            "NA": {
                "zhl_preapprovals_bucket": {
                    "Low": 7,
                    "Low-Fair": None,
                    "NA": 7,  # Use 'NA' instead of 'None'
                    "Fair": 7,
                    "High": 7
                }
            },
            "Fair": {
                "zhl_preapprovals_bucket": {
                    "Low": 3,
                    "Low-Fair": None,
                    "NA": 10,  # Use 'NA' instead of 'None'
                    "Fair": 10,
                    "High": 15
                }
            },
            "High": {
                "zhl_preapprovals_bucket": {
                    "Low": 5,
                    "Low-Fair": None,
                    "NA": 15,  # Use 'NA' instead of 'None'
                    "Fair": 12,
                    "High": 15
                  }
              }
          }
      }
  }

  DEFAULT_VALUES = {
        'new_agent_target': 7,
        'all_agent_max': 20,
        'at_risk_target': 1,
        'high_target': 15,
        'fair_target': 10,
        'low_target': 5,
        'low_agent_max': 5
    }

  def __init__(self, agent_data_df, team_config_df):
      
    self.agent_data_df = agent_data_df
    self.team_config_df = team_config_df

    self.recommended_agent_connection_targets = None

  def calculate_max_cxns_and_reasons(self):
      
    # Make sure team_zuid is the same data type in both DataFrames to ensure correct merge
    self.agent_data_df['team_zuid'] = self.agent_data_df['team_zuid'].astype(str)
    self.team_config_df['team_zuid'] = self.team_config_df['team_zuid'].astype(str)
      
    # Perform the merge operation
    merged_df = pd.merge(self.agent_data_df,
                         self.team_config_df[[
                             'team_zuid', 'new_agent_target',
                             'all_agent_max', 'at_risk_target', 'high_target',
                             'fair_target', 'low_target', 'low_agent_max'
                         ]],
                         on='team_zuid',
                         how='inner')
    
    # Apply default values post-merge for any missing team-related columns or NaN values
    for column, default in AgentConnectionTargetsRecommender.DEFAULT_VALUES.items():
        if column not in merged_df.columns:
            merged_df[
                column] = default  # Adds a column with default value if it doesn't exist
        else:
            merged_df.loc[:, column] = merged_df.loc[:, column].fillna(
                default)  # Fills NaN values with defaults using .loc
  
    merged_df[['max_cxns',
               'max_reason']] = merged_df.apply(self.get_max_cxns_and_reason,
                                                axis=1,
                                                result_type='expand')
    
    return merged_df

  def get_max_cxns_and_reason(self, row):

    requested_cxns = row.get('requested_cxns', float('inf'))

    # Normalize zhl_preapprovals_bucket and cvr_bucket
    cvr_bucket = 'NA' if row['cvr_bucket'] is None else row['cvr_bucket']
    zhl_preapprovals_bucket = 'NA' if row['zhl_preapprovals_bucket'] is None else row['zhl_preapprovals_bucket']

    performance_bucket = row['performance_bucket']

    # FIRST PASS: HARD RULES (ONLY ONE APPLIES AND THEN THE CODE EXITS)
    #######################################################################

    if row['lifetime_cxns'] <= 25:
        return row[
            'new_agent_target'], "Less than 25 lifetime cxns, ramp slowly"

    if row['cxns_l30'] > 30:
        return row[
            'at_risk_target'], f"Limiting due to heavy recent volume ({row['cxns_l30']} cxns in the last 30 days)"

    # SECOND PASS: GENERAL PERFORMANCE DRIVEN RULES
    #######################################################################

    max_cxns_by_performance = self.get_max_cxns_by_performance(
        cvr_bucket, zhl_preapprovals_bucket,
        AgentConnectionTargetsRecommender.IDEAL_CXNS_CONFIG)  # Returns a single cxn number

    # In the event that the agent has no performance bucket or buckets are broken
    if max_cxns_by_performance is None:
        max_cxns_by_performance = row['fair_target']

    # Non-High Performers who are unresponsive to the SMS text will get fewer cxns
    if row.get('desired_cxns_status'
                ) == 'Unresponsive' and performance_bucket == 'High':
        l30_adjusted_max = row['cxns_l30'] + 10
    elif row.get('desired_cxns_status') == 'Unresponsive':
        l30_adjusted_max = max(row['cxns_l30'] - 2, 1)
    else:
        l30_adjusted_max = row[
            'cxns_l30'] + 5  # Limits the cxns to 5 more than the l30

    # Respect High performers desired connection value regardless of other limits
    if (performance_bucket == 'High'
            and isinstance(requested_cxns,
                            (int, float)) and not pd.isnull(requested_cxns)
            and row.get('desired_cxns_status') == 'Ok'):
        final_max_cxns = requested_cxns
    else:
        final_max_cxns = min(max_cxns_by_performance, l30_adjusted_max,
                              requested_cxns)

    pre_pickup_rate_penalty_max_cxns = final_max_cxns

    # If the pickup rate penalty is applied, reduce the max cxns by 2, minimum of 1
    if row.get('pickup_rate_penalty_applied') == True:
        final_max_cxns = max(pre_pickup_rate_penalty_max_cxns - 2, 1)

    # Constructing reason based on the limiting factor
    cvr_bucket_text = "Fair" if cvr_bucket == "Fair" else cvr_bucket
    zhl_preapprovals_bucket_text = "Fair" if zhl_preapprovals_bucket == "Fair" else zhl_preapprovals_bucket

    if zhl_preapprovals_bucket == 'NA':
        reason = f'{cvr_bucket_text} pCVR performance'
    else:
        reason = f'{cvr_bucket_text} pCVR and {zhl_preapprovals_bucket_text} ZHL Pre-approvals performance'

    if (pre_pickup_rate_penalty_max_cxns == l30_adjusted_max
            and l30_adjusted_max < max_cxns_by_performance
            and row['cxns_l30'] < 10):
        reason += ", low recent cxn volume"

    if pre_pickup_rate_penalty_max_cxns == requested_cxns and row.get(
            'desired_cxns_status') == 'Ok':
        reason += f" AND agent requested {int(requested_cxns)} cxns"

    if row.get('desired_cxns_status') == 'Unresponsive':
        reason += " AND unresponsive to desired cxns SMS"
        requested_cxns = row.get('requested_cxns')
        if pd.notnull(requested_cxns) and performance_bucket == 'High':
            reason += f", last desired was {int(requested_cxns)} cxns"

    if row.get('pickup_rate_penalty_applied') == True:
        reason += " AND low pickup rate"

    if reason:  # Capitalize the first letter of the reason if it's not empty
        reason = reason[0].upper() + reason[1:]

    return final_max_cxns, reason

  @staticmethod
  def get_max_cxns_by_performance(cvr_bucket, zhl_preapprovals_bucket, config):

    try:
        return config['ideal_cxns']['cvr_bucket'][cvr_bucket]['zhl_preapprovals_bucket'][
            zhl_preapprovals_bucket]
    except KeyError as e:
        # Print detailed error message for debugging
        if 'ideal_cxns' not in config:
            print("Error: 'ideal_cxns' key is missing from the configuration.")
        elif cvr_bucket not in config['ideal_cxns']['cvr_bucket']:
            print(
                f"Error: CVR bucket '{cvr_bucket}' not found in the configuration."
            )
        elif 'zhl_preapprovals_bucket' not in config['ideal_cxns']['cvr_bucket'][
                cvr_bucket]:
            print(
                "Error: 'zhl_preapprovals_bucket' key is missing from the CVR bucket in the configuration."
            )
        elif zhl_preapprovals_bucket not in config['ideal_cxns']['cvr_bucket'][cvr_bucket][
                'zhl_preapprovals_bucket']:
            print(
                f"Error: ZHL Pre-approval bucket '{zhl_preapprovals_bucket}' not found for CVR bucket '{cvr_bucket}' in the configuration."
            )
        else:
            print("Unknown KeyError occurred.")

        print(f"Returning None for CVR: {cvr_bucket}, ZHL Pre-approval: {zhl_preapprovals_bucket}")
        return None
  
  def adjust_cxn_targets_based_on_team_allocation(self, calculated_df):

    # Merge with team_config to get team_cxn_target
    team_cxn_df = self.team_config_df[['team_zuid', 'team_cxn_target']]
    merged_df = pd.merge(calculated_df,
                         team_cxn_df,
                         on='team_zuid',
                         how='left')

    # Calculate initial total cxn_target per team
    initial_totals = merged_df.groupby('team_zuid')['cxn_target'].sum(
    ).reset_index(name='initial_total_cxn_targets')
    merged_df = pd.merge(merged_df, initial_totals, on='team_zuid', how='left')

    # Calculate 'cxn_diff' for each team
    merged_df['cxn_diff'] = merged_df['team_cxn_target'] - merged_df[
        'initial_total_cxn_targets']

    # Adjust cxn_targets based on 'cxn_diff'
    for team_zuid, group in merged_df.groupby('team_zuid', as_index=False):
        remainder = group['cxn_diff'].iloc[0]

        if remainder > 0:
            # Directly modify the group within merged_df
            merged_df.loc[group.index, :] = self.handle_above_capacity_teams(
                merged_df.loc[group.index, :], remainder)[0]

        elif remainder < 0:
            # Directly modify the group within merged_df
            merged_df.loc[group.index, :] = self.handle_below_capacity_teams(
                merged_df.loc[group.index, :], remainder)[0]

    return merged_df
  
  @staticmethod
  def handle_above_capacity_teams(group, remainder):
    categories = ['high', 'fair', 'low']  # Use lower case for categories.
    cxn_increments = [2, 1, 1]
    team_all_agent_max = group['all_agent_max'].max()

    for category, increment in zip(categories, cxn_increments):
        eligible_agents = group[group['performance_bucket'].str.lower() ==
                                category]

        for idx, agent in eligible_agents.iterrows():
            if remainder <= 0:
                return group, remainder  # Exit if no remainder left.

            # Calculate actual increment ensuring it does not exceed all_agent_max
            potential_new_target = agent['cxn_target'] + increment
            if potential_new_target > agent['all_agent_max']:
                continue  # Skip this increment to avoid exceeding the max allowed connections

            if (potential_new_target > agent['low_agent_max']) and (agent['performance_bucket'].lower() == 'low'):
                continue  # Skip this increment to avoid exceeding the max allowed connections for low performers

            actual_increment = min(increment, remainder)
            group.at[idx, 'cxn_target'] += actual_increment
            remainder -= actual_increment

    # Aggressive distribution to ensure all connections are distributed
    low_performer_relax_increment = 0
    low_performer_limit_incremented = False
    while remainder > 0:
        distribution_happened = False
        for idx, agent in group.iterrows():
            if remainder <= 0:
                break

            if (agent['cxn_target'] + 1 > agent['low_agent_max'] + low_performer_relax_increment) and (agent['performance_bucket'].lower() == 'low'):
                continue  # Skip this increment to avoid exceeding the max allowed connections for low performers

            # Further check to ensure no agent exceeds current team_all_agent_max
            if agent['cxn_target'] + 1 > team_all_agent_max:
                continue  # Skip this agent as increasing would exceed their current max connections

            # Distribute 1 connection at a time to each agent until no remainder
            group.at[idx, 'cxn_target'] += 1
            remainder -= 1
            distribution_happened = True

        # Increment the team_all_agent_max value for the next iteration
        team_all_agent_max += 1

        # Check if distribution happened to determine if we should relax low performer limit or prevent infinite loop
        if distribution_happened:
            # Since a distribution was made, we can reset the indicator for incrementing the low performer limit
            low_performer_limit_incremented = False
            # Skip the rest of the while loop and continue with normal distribution logic
            continue

        # At this point, no distribution happened in the last iteration

        # Check if we've already attempted relaxing the low performer limit in last iteration, if so, break to avoid inifite loop
        if low_performer_limit_incremented:
            print(
                f"Warning: {group['team_zuid'].iloc[0]} - Not all connections could be distributed. Remainder: {remainder}"
            )
            break

        # Relax the low performer limit the first time if we've gone through a loop and haven't distributed any connections
        # Determine the blocked low performers
        blocked_low_performers = group[
            (group['performance_bucket'].str.lower() == 'low') &
            (group['cxn_target'] >= group['low_agent_max'])
        ]

        # Calculate the minimum relaxation needed to unblock at least one low performer
        # This is max of:
        # 1. The minimum relaxation needed to unblock a blocked low performer
        # 2. The current relaxation increment + 1
        if not blocked_low_performers.empty:
            low_performer_relax_increment = max(
                (blocked_low_performers['cxn_target'] - blocked_low_performers['low_agent_max'] + 1).min(),
                low_performer_relax_increment + 1
            )
        else:
            low_performer_relax_increment += 1

        low_performer_limit_incremented = True

    if low_performer_relax_increment > 0:
        print(f"Note: {group['team_zuid'].iloc[0]} - Low performers were allowed to exceed low_agent_max by {low_performer_relax_increment} connection(s).")
    return group, remainder

  @staticmethod
  def handle_below_capacity_teams(group, remainder):
      # Sort agents by their rank in descending order, assuming higher rank means lower priority
      sorted_agents = group.sort_values(by='rank', ascending=False)

      # determine what the minimum number of connections can be for each team if we only allow each agent to go down to 1
      min_1_team_total = sum([min(1, x) for x in group['cxn_target']])

      # set the minimum number of connections allowed for each agent when subtracting
      min_allowed = 1

      stop_flag = False

      while (remainder < 0) and (stop_flag == False) and (sum(group['cxn_target']) > 0):
          
        # if we are at the point where we still need to reduce connections but have reached the minimum number of connections
        # when we require each agent to keep 1, we need to relax this constraint and allow some agents to go to 0
        if sum(group['cxn_target']) <= min_1_team_total:
            min_allowed = 0
      
        # iterate from the bottom of the team to the top by rank
        for idx in sorted_agents.index:

            # remove a connection from the agent if doing so would keep them above min_allowed
            if (group.at[idx, 'cxn_target'] - 1) >= min_allowed:
                group.at[idx, 'cxn_target'] -= 1
                remainder += 1

                if group.at[idx, 'cxn_target'] == 0:
                    print(
                        f"Adjusted Agent {group.at[idx, 'agent_zuid']} cxn_target to 0 by necessity."
                    )

            if remainder == 0:
                # set flag to exit while loop
                stop_flag = True
                # exit for loop
                break

      return group, remainder
  
  def calculate_recommended_agent_connection_targets(self):
    """
    This operates similar to target_table_utils.compute_and_insert_agent_targets
    """

    # Step 1: Calculate max connections and reasons
    try:
        calculated_df = self.calculate_max_cxns_and_reasons()
        # Ensure 'max_cxns' column exists in calculated_df to avoid KeyError
        if 'max_cxns' not in calculated_df.columns:
            print(
                "Error: 'max_cxns' column not found in the output of calculate_max_cxns_and_reasons."
            )
            return
        calculated_df['cxn_target'] = calculated_df['max_cxns']
    except Exception as e:
        print(f"Error during calculations: {e}")
        return
    
    # Step 2: Start with max connections and revise based on team cxn target
    try:
        adjusted_df = self.adjust_cxn_targets_based_on_team_allocation(
            calculated_df)
    except Exception as e:
        print(f"Error during adjustment: {e}")
        return
    
    # Ensure the adjusted DataFrame has all necessary columns for insertion
    required_columns = [
        'agent_zuid','team_zuid','max_cxns',
        'max_reason','performance_bucket', 'cxn_target'
    ]
    missing_columns = [
        col for col in required_columns if col not in adjusted_df.columns
    ]
    if missing_columns:
        print(f"Error: Missing required columns for insertion: {missing_columns}")
        return

    # Type conversion for SQL compatibility
    adjusted_df = adjusted_df.astype({
        'agent_zuid': 'int64',
        'team_zuid': 'int64',
        'max_cxns': 'int64',
        'cxn_target': 'int64'
    })

    # make the assignment to the final variable
    self.recommended_agent_connection_targets = adjusted_df

    print("calculated recommended agent connection targets")
  
  def validate_recommended_agent_connection_targets(self):
      
    columns_to_check_for_nulls = [
        'agent_zuid',
        'team_zuid',
        'cxn_target'
    ]
      
    # check for null values in columns_to_check_for_nulls
    for column in columns_to_check_for_nulls:
        if self.recommended_agent_connection_targets[column].isnull().any():
            raise ValueError(f"Error: '{column}' column contains null values.")

    # Check for duplicate pairs in 'agent_zuid' and 'team_zuid'
    duplicate_pairs = self.recommended_agent_connection_targets.duplicated(subset=['agent_zuid', 'team_zuid'], keep=False)
    if duplicate_pairs.any():
        raise ValueError("Error: Duplicate pairs found in 'agent_zuid' and 'team_zuid' columns.")
    
    print("validated recommended agent connection targets")

    return True

  def get_recommended_agent_connection_targets(self):

    return self.recommended_agent_connection_targets