from pyspark.sql.types import StructField, StructType, StringType, LongType, IntegerType, DoubleType, BooleanType

team_config_schema = StructType([
    StructField('team_zuid', LongType(), True),
    StructField('team_cxn_target', IntegerType(), True),
    StructField('at_risk_target', IntegerType(), True),
    StructField('new_agent_target', IntegerType(), True),
    StructField('fair_target', IntegerType(), True),
    StructField('low_target', IntegerType(), True),
    StructField('high_target', IntegerType(), True),
    StructField('all_agent_max', IntegerType(), True),
    StructField('low_agent_max', IntegerType(), True),
])

agent_data_schema = StructType([
    StructField('team_zuid', LongType(), True),
    StructField('agent_zuid', LongType(), True),
    StructField('em_flag', BooleanType(), True),
    StructField('cvr_bucket', StringType(), True),
    StructField('zhl_preapprovals_bucket', StringType(), True),
    StructField('performance_bucket', StringType(), True),
    StructField('cxns_l30', IntegerType(), True),
    StructField('lifetime_cxns', IntegerType(), True),
    StructField('pickup_rate_penalty_applied', BooleanType(), True),
    StructField('rank', IntegerType(), True)
])

desired_connections_schema = StructType([
    StructField('agent_zuid', LongType(), True),
    StructField('requested_cxns', IntegerType(), True),
    StructField('desired_cxns_status', StringType(), True),
])