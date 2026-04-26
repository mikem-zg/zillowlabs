import pandas as pd
import pytest
import mock

from recommended_agent_connection_targets_algorithm\
    .recommended_agent_connection_targets_algorithm_lib\
    .agent_connection_targets_recommender import AgentConnectionTargetsRecommender

@pytest.fixture(scope='function')
def agent_connection_targets_recommender_mock():
    # Mock up pandas dataframe with dummy data
    dummy_agent_data = {
        'team_zuid': [1, 1, 2],
        'agent_zuid': [11, 12, 21],
        'requested_cxns': [10, 5, 10],
        'cvr_bucket': ['Low', 'Fair', 'High'],
        'zhl_preapprovals_bucket': ['High', 'Low-Fair', 'Low'],
        'performance_bucket': ['Low', 'High', 'Low'],
        'cxns_l30': [10, 12, 17],
        'lifetime_cxns': [100, 150, 200],
        'desired_cxns_status': ['Ok', 'Ok', 'Unresponsive'],
        'rank': [1, 2, 3]

    }
    agent_df = pd.DataFrame(dummy_agent_data)

    dummy_team_data = {
        'team_zuid': [1, 2],
        'team_cxn_target': [30, 21],
        'at_risk_target': [1, 1],
        'new_agent_target': [5, 5],
        'fair_target': [10, 10],
        'low_target': [2, 2],
        'high_target': [15, 15],
        'all_agent_max': [20, 20],
        'low_agent_max': [5, 5],
    }

    team_df = pd.DataFrame(dummy_team_data)

    return AgentConnectionTargetsRecommender(agent_df, team_df)

def test_calculate_recommended_agent_connection_targets(agent_connection_targets_recommender_mock):
    # Test if the recommender runs end to end without errors
    agent_connection_targets_recommender_mock.calculate_recommended_agent_connection_targets()

def test_get_max_cxns_and_reason(agent_connection_targets_recommender_mock):
    """
    1. first pass rules
    team zuid 0 cases: show which rules trigger first
    team zuid 2 cases: when cxns_l30 > 30
    team zuid 3 cases: when lifetime_cxns <=25


    2. second pass rules
    team zuid 4 cases: 25 default cases (hardcode perf buecket to Fair to test)
    team zuid 5 cases: unexpected value in cvr/zhl pre approval bucket
    team zuid 6 cases: adjustments to l30_adjusted_max
    team zuid 7 cases: high performer and responsive
    team zuid 8 cases: default, cvr perf reason options
    team zuid 9 cases: default, low recent volume
    team zuid 10 cases: default, unresponsive and high performer
    team zuid 11 cases: adjustments to l30_adjusted_max for unresponsive test minimum value
    team zuid 12 cases: pickup rate penalty applied (performance_bucket cannot be High when penalty applied)
    team zuid 13 cases: pickup rate penalty not applied with first-pass hard rules
    """
    test_data = {
        'team_zuid': [0,
                      2,
                      3,
                      4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,
                      5,
                      6, 6,
                      7,
                      8,
                      9,
                      10,
                      11,
                      12, 12, 12, 12,
                      13, 13,],
        'agent_zuid': [1,
                       21,
                       31,
                       401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425,
                       51,
                       61, 62,
                       71,
                       81,
                       91,
                       101,
                       111,
                       121, 122, 123, 124,
                       131, 132,],
        'requested_cxns': [None,
                           None,
                           None,
                           50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
                           50,
                           None, 50,
                           50,
                           50,
                           50,
                           50,
                           50,
                           50, 50, 50, 10,
                           None, None,],
        'cvr_bucket': [None,
                       'High',
                       'High',
                       'Low', 'Low', 'Low', 'Low', 'Low', 'Low-Fair', 'Low-Fair', 'Low-Fair', 'Low-Fair', 'Low-Fair', 'NA', 'NA', 'NA', 'NA', 'NA', 'Fair', 'Fair', 'Fair', 'Fair', 'Fair', 'High', 'High', 'High', 'High', 'High',
                       'unexpected',
                       'Fair', 'Fair',
                       'Fair',
                       'Fair',
                       'Fair',
                       'Fair',
                       'Fair',
                       'Low', 'Fair', 'High', 'Fair',
                       None, None,],
        'zhl_preapprovals_bucket': [None,
                       'High',
                       'High',
                       'Low', 'Low-Fair', 'NA', 'Fair', 'High', 'Low', 'Low-Fair', 'NA', 'Fair', 'High', 'Low', 'Low-Fair', 'NA', 'Fair', 'High', 'Low', 'Low-Fair', 'NA', 'Fair', 'High', 'Low', 'Low-Fair', 'NA', 'Fair', 'High',
                       'unexpected',
                       'Fair', 'Fair',
                       'Fair',
                       None,
                       'Fair',
                       'Fair',
                       'Fair',
                       'Low', 'Fair', 'High', 'Fair',
                       None, None,],
        'performance_bucket': ['Low',
                               None,
                               None,
                               'Fair', 'Fair', 'Fair', 'Fair', 'Fair', 'Fair', 'Fair', 'Fair', 'Fair', 'Fair', 'Fair', 'Fair', 'Fair', 'Fair', 'Fair', 'Fair', 'Fair', 'Fair', 'Fair', 'Fair', 'Fair', 'Fair', 'Fair', 'Fair', 'Fair',
                               'Fair',
                               'High', 'Fair',
                               'High',
                               'Fair',
                               'Fair',
                               'High',
                               'Fair',
                               'Low', 'Fair', 'Fair', 'Fair',
                               None, None,],
        'cxns_l30': [50,
                     35,
                     5,
                     10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,
                     10,
                     10, 10,
                     10,
                     10,
                     1,
                     10,
                     2,
                     10, 1, 2, 10,
                     5, 35,],
        'lifetime_cxns': [5,
                          30,
                          5,
                          30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30,
                          30,
                          30, 30,
                          30,
                          30,
                          30,
                          30,
                          30,
                          30, 30, 30, 30,
                          5, 30,],
        'desired_cxns_status': [None,
                               None,
                               None,
                               'Ok', 'Ok', 'Ok', 'Ok', 'Ok', 'Ok', 'Ok', 'Ok', 'Ok', 'Ok', 'Ok', 'Ok', 'Ok', 'Ok', 'Ok', 'Ok', 'Ok', 'Ok', 'Ok', 'Ok', 'Ok', 'Ok', 'Ok', 'Ok', 'Ok',
                               'Ok',
                               'Unresponsive', 'Unresponsive',
                               'Ok',
                               'Ok',
                               'Ok',
                               'Unresponsive',
                               'Unresponsive',
                               'Ok', 'Ok', 'Unresponsive', 'Ok',
                               None, None,],
        'pickup_rate_penalty_applied': [False,
                               False,
                               False,
                               False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False,
                               False,
                               False, False,
                               False,
                               False,
                               False,
                               False,
                               False,
                               True, True, True, True,
                               True, True],
    }

    # Create DataFrame
    test_df = pd.DataFrame(test_data)

    # add defaults which are static
    for column, default in AgentConnectionTargetsRecommender.DEFAULT_VALUES.items():
        test_df[column] = default

    # Expected results based on assumed logic in get_max_cxns_and_reason
    expected_results = [

        [7.0, 'Less than 25 lifetime cxns, ramp slowly'],

        [1.0, 'Limiting due to heavy recent volume (35 cxns in the last 30 days)'],

        [7.0, 'Less than 25 lifetime cxns, ramp slowly'],

        # start team 4
        [1.0, 'Low pCVR and Low ZHL Pre-approvals performance'],
        [10.0, 'Low pCVR and Low-Fair ZHL Pre-approvals performance'],
        [3.0, 'Low pCVR performance'],
        [1.0, 'Low pCVR and Fair ZHL Pre-approvals performance'],
        [3.0, 'Low pCVR and High ZHL Pre-approvals performance'],

        [3.0, 'Low-Fair pCVR and Low ZHL Pre-approvals performance'],
        [10.0, 'Low-Fair pCVR and Low-Fair ZHL Pre-approvals performance'],
        [5.0, 'Low-Fair pCVR performance'],
        [5.0, 'Low-Fair pCVR and Fair ZHL Pre-approvals performance'],
        [5.0, 'Low-Fair pCVR and High ZHL Pre-approvals performance'],

        [7.0, 'NA pCVR and Low ZHL Pre-approvals performance'],
        [10.0, 'NA pCVR and Low-Fair ZHL Pre-approvals performance'],
        [7.0, 'NA pCVR performance'],
        [7.0, 'NA pCVR and Fair ZHL Pre-approvals performance'],
        [7.0, 'NA pCVR and High ZHL Pre-approvals performance'],

        [3.0, 'Fair pCVR and Low ZHL Pre-approvals performance'],
        [10.0, 'Fair pCVR and Low-Fair ZHL Pre-approvals performance'],
        [10.0, 'Fair pCVR performance'],
        [10.0, 'Fair pCVR and Fair ZHL Pre-approvals performance'],
        [15.0, 'Fair pCVR and High ZHL Pre-approvals performance'],

        [5.0, 'High pCVR and Low ZHL Pre-approvals performance'],
        [10.0, 'High pCVR and Low-Fair ZHL Pre-approvals performance'],
        [15.0, 'High pCVR performance'],
        [12.0, 'High pCVR and Fair ZHL Pre-approvals performance'],
        [15.0, 'High pCVR and High ZHL Pre-approvals performance'],
        # end team 4

        [10.0, 'Unexpected pCVR and unexpected ZHL Pre-approvals performance'],

        [10.0, 'Fair pCVR and Fair ZHL Pre-approvals performance AND unresponsive to desired cxns SMS'],
        [8.0, 'Fair pCVR and Fair ZHL Pre-approvals performance AND unresponsive to desired cxns SMS'],

        [50.0, 'Fair pCVR and Fair ZHL Pre-approvals performance AND agent requested 50 cxns'],

        [10.0, 'Fair pCVR performance'],

        [6.0, 'Fair pCVR and Fair ZHL Pre-approvals performance, low recent cxn volume'],

        [10.0, 'Fair pCVR and Fair ZHL Pre-approvals performance AND unresponsive to desired cxns SMS, last desired was 50 cxns'],

        [1.0, 'Fair pCVR and Fair ZHL Pre-approvals performance, low recent cxn volume AND unresponsive to desired cxns SMS'],

        # pickup_rate_penalty_applied=True: final_max_cxns reduced by 2 (min 1), reason includes " AND low pickup rate"
        # Row 37: Low/Low, Low, Ok, cxns_l30=10 → pre_pickup=1, resulting in 1
        [1.0, 'Low pCVR and Low ZHL Pre-approvals performance AND low pickup rate'],
        # Row 38: Fair/Fair, Fair, Ok, cxns_l30=1 → pre_pickup=6 (l30 limiter), "low recent cxn volume", resulting in 4
        [4.0, 'Fair pCVR and Fair ZHL Pre-approvals performance, low recent cxn volume AND low pickup rate'],
        # Row 39: High/High, Fair, Unresponsive, cxns_l30=2 → pre_pickup=1, "low recent cxn volume" + unresponsive, resulting in 1
        [1.0, 'High pCVR and High ZHL Pre-approvals performance, low recent cxn volume AND unresponsive to desired cxns SMS AND low pickup rate'],
        # Row 40: Fair/Fair, Fair, Ok, requested_cxns=10 → pre_pickup=10 (requested limiter), "agent requested 10 cxns", resulting in 8
        [8.0, 'Fair pCVR and Fair ZHL Pre-approvals performance AND agent requested 10 cxns AND low pickup rate'],
        # pickup_rate_penalty_applied=True with first-pass hard rules: penalty should NOT apply (early return)
        # Row 41: lifetime_cxns=5, pickup_rate_penalty_applied=True → should return same as row 0/2 (penalty ignored)
        [7.0, 'Less than 25 lifetime cxns, ramp slowly'],
        # Row 42: cxns_l30=35, pickup_rate_penalty_applied=True → should return same as row 1 (penalty ignored)
        [1.0, 'Limiting due to heavy recent volume (35 cxns in the last 30 days)'],
    ]

    results = test_df.apply(agent_connection_targets_recommender_mock.get_max_cxns_and_reason,
                            axis=1,
                            result_type='expand').values.tolist()

    assert results == expected_results

def test_handle_above_capacity_teams(agent_connection_targets_recommender_mock):

    # case 1: handle all adds without entering aggressive loop
    # case 2: builds on case 1, needs partial loop through aggressive loop
    # case 3: (special) needs to skip a low performer in top loop
    # case 4: builds on case 2, needs to skip a low performer in bottom loop
    # case 5: builds on case 2, needs to exceed all_agent_max to meet target
    # case 6: tests low_performer_relax_increment - all low performers, forces low performer to exceed low_agent_max
    test_data = {
        'team_zuid': [1, 1, 1,
                 2, 2, 2,
                 3, 3, 3,
                 4, 4, 4,
                 5, 5, 5,
                 6, 6, 6,
                 7,
                 8, 8,],
        'agent_zuid': [11, 12, 13,
                       21, 22, 23,
                       31, 32, 33,
                       41, 42, 43,
                       51, 52, 53,
                       61, 62, 63,
                       71,
                       81, 82,],
        'performance_bucket': ['High', 'Fair', 'Low',
                               'High', 'Fair', 'Low',
                               'High', 'Fair', 'Low',
                               'High', 'Fair', 'Low',
                               'High', 'Fair', 'Low',
                               'Low', 'Low', 'Low',
                               'Low',
                               'Low', 'Low',],
        'cxn_target': [16, 7, 4,
                       16, 7, 4,
                       16, 7, 5,
                       16, 7, 4,
                       16, 7, 4,
                       5, 3, 3,
                       7,
                       3, 7,],
        'initial_total_cxn_targets': [27, 27, 27,
                                      27, 27, 27,
                                      28, 28, 28,
                                      27, 27, 27,
                                      27, 27, 27,
                                      11, 11, 11,
                                      7,
                                      3, 7,],
        'team_cxn_target': [30, 30, 30,
                            33, 33, 33,
                            32, 32, 32,
                            34, 34, 34,
                            68, 68, 68,
                            20, 20, 20,
                            18,
                            15, 15,],
        'all_agent_max': [AgentConnectionTargetsRecommender.DEFAULT_VALUES['all_agent_max']] * 21,
        'low_agent_max': [AgentConnectionTargetsRecommender.DEFAULT_VALUES['low_agent_max']] * 21,

    }

    test_df = pd.DataFrame(test_data)

    test_remainders = [3, 6, 4, 7, 41, 9, 11, 5,]

    all_case_results = []

    for i in range(1, len(test_remainders)+1):

        result, rem = agent_connection_targets_recommender_mock.handle_above_capacity_teams(
            test_df[test_df['team_zuid'] == i],
            test_remainders[i-1]
        )

        all_case_results.append(result[['team_zuid', 'agent_zuid', 'cxn_target']].values.tolist())

    expected_results = [
        [[1, 11, 18],
        [1, 12, 8],
        [1, 13, 4]],

        [[2, 21, 19],
        [2, 22, 9],
        [2, 23, 5]],

        [[3, 31, 19],
         [3, 32, 8],
         [3, 33, 5]],
        
        [[4, 41, 20],
         [4, 42, 9],
         [4, 43, 5]],
        
        [[5, 51, 37],
         [5, 52, 26],
         [5, 53, 5]],

        [[6, 61, 7],
         [6, 62, 7],
         [6, 63, 6]],

        [[7, 71, 18]],

        [[8, 81, 8],
         [8, 82, 7]],
    ]

    assert all_case_results == expected_results


def test_handle_below_capacity_teams(agent_connection_targets_recommender_mock):
    # case 1: base case subtract from lowest ranked agents only
    # case 2: skip removing from agent down to 0
    # case 3: skip agent at 0
    # case 4: skip removing from two agents down to 0
    # case 5: base case, multiple loops through, removing in order
    # case 6: base case, multiple loops through, removing in order, require setting some to 0
    # case 7: base case, test if target is = 0
    # case 8: base case, test if target is < 0

    test_data = {
        'case': [1, 1, 1,
                 2, 2, 2,
                 3, 3, 3,
                 4, 4, 4,
                 5, 5, 5,
                 6, 6, 6,
                 7, 7, 7,
                 8, 8, 8,],
        'agent_zuid': [11, 12, 13,
                       21, 22, 23,
                       31, 32, 33,
                       41, 42, 43,
                       51, 52, 53,
                       61, 62, 63,
                       71, 72, 73,
                       81, 82, 83,],
        'rank': [1, 2, 3,
                 1, 2, 3,
                 1, 2, 3,
                 1, 2, 3,
                 1, 2, 3,
                 1, 2, 3,
                 1, 2, 3,
                 1, 2, 3,],
        'cxn_target': [20, 16, 4,
                       20, 16, 1,
                       20, 16, 0,
                       20, 0, 1,
                       20, 16, 4,
                       20, 16, 4,
                       20, 16, 4,
                       20, 16, 4,],
        'initial_total_cxn_targets': [40, 40, 40,
                                      37, 37, 37,
                                      36, 36, 36,
                                      40, 40, 40,
                                      21, 21, 21,
                                      40, 40, 40,
                                      40, 40, 40,
                                      40, 40, 40,],
        'team_cxn_target': [39, 39, 39,
                            36, 36, 36,
                            35, 35, 35,
                            20, 20, 20,
                            30, 30, 30,
                            2, 2, 2,
                            0, 0, 0,
                            -1, -1, -1
                            ],
    }

    test_df = pd.DataFrame(test_data)

    test_remainders = [-1, -1, -1, -1, -10 , -38, -40, -41]

    all_case_results = []

    for i in range(1, len(test_remainders) + 1):
        result, rem = agent_connection_targets_recommender_mock.handle_below_capacity_teams(
            test_df[test_df['case'] == i],
            test_remainders[i - 1]
        )

        all_case_results.append(result[['case', 'agent_zuid', 'cxn_target']].values.tolist())

    expected_results = [
        [[1, 11, 20],
         [1, 12, 16],
         [1, 13, 3]],

        [[2, 21, 20],
         [2, 22, 15],
         [2, 23, 1]],

        [[3, 31, 20],
         [3, 32, 15],
         [3, 33, 0]],

        [[4, 41, 19],
         [4, 42, 0],
         [4, 43, 1]],
        
        [[5, 51, 17],
         [5, 52, 12],
         [5, 53, 1]],
        
        [[6, 61, 1],
         [6, 62, 1],
         [6, 63, 0]],
        
        [[7, 71, 0],
         [7, 72, 0],
         [7, 73, 0]],
        
        [[8, 81, 0],
         [8, 82, 0],
         [8, 83, 0]],
    ]

    assert all_case_results == expected_results

def test_validate_recommended_agent_connection_targets(agent_connection_targets_recommender_mock):
    null_case_test_data = {
        'agent_zuid': [None],
        'team_zuid': [None],
        'cxn_target': [None]
    }

    null_test_df = pd.DataFrame(null_case_test_data)

    agent_connection_targets_recommender_mock.recommended_agent_connection_targets = null_test_df

    with pytest.raises(ValueError):
        agent_connection_targets_recommender_mock.validate_recommended_agent_connection_targets()

    duplicate_key_case_test_data = {
        'agent_zuid': [11, 11, 21],
        'team_zuid': [1, 1, 2],
        'cxn_target': [1, 2, 3]
    }

    duplicate_key_case_test_df = pd.DataFrame(duplicate_key_case_test_data)

    agent_connection_targets_recommender_mock.recommended_agent_connection_targets = duplicate_key_case_test_df

    with pytest.raises(ValueError, match="Error: Duplicate pairs found in 'agent_zuid' and 'team_zuid' columns."):
        agent_connection_targets_recommender_mock.validate_recommended_agent_connection_targets()

    valid_case_test_data = {
        'agent_zuid': [11, 21, 31],
        'team_zuid': [1, 2, 3],
        'rank': [1, 2, 3],
        'cxns_l30': [10, 20, 30],
        'max_cxns': [20, 20, 20],
        'max_reason': ['a', 'b', 'c'],
        'performance_bucket': ['High', 'Low', 'Fair'],
        'cxn_target': [5, 10, 20],
    }

    valid_case_test_df = pd.DataFrame(valid_case_test_data)

    agent_connection_targets_recommender_mock.recommended_agent_connection_targets = valid_case_test_df

    agent_connection_targets_recommender_mock.validate_recommended_agent_connection_targets()