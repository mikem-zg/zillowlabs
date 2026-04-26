import pandas as pd
import pyspark.sql.functions as F
import pyspark.sql.types as T
from pyspark.sql.functions import current_date

# import base sql queries
import recommended_agent_connection_targets_algorithm_lib.query_scripts.team_config as tcq
import recommended_agent_connection_targets_algorithm_lib.query_scripts.agent_data as adq
import recommended_agent_connection_targets_algorithm_lib.query_scripts.desired_connections as dcq

# import input and output schemas
from recommended_agent_connection_targets_algorithm_lib.schemas import input_data_schemas
from recommended_agent_connection_targets_algorithm_lib.schemas import output_data_schemas

# import utility functions
from recommended_agent_connection_targets_algorithm_lib.utilities.utility_functions import apply_schema_and_select_columns_spark
from recommended_agent_connection_targets_algorithm_lib.utilities.utility_functions import validate_dataframe

# import main target setting logic
from recommended_agent_connection_targets_algorithm_lib.agent_connection_targets_recommender import AgentConnectionTargetsRecommender


class UpdateRecommendedAgentConnectionTargetsTask():
  """
  This class is used to facilitate the process of updating the recommended agent connection targets.
  It handles retrieving the input data, processing it, combining it, passing to an instance of AgentConnectionTargetsRecommender, and writing the results.
  """

  OUTPUT_SCHEMA_RENAMING_MAP = {
    'team_zuid': 'team_lead_zuid',
    'agent_zuid': 'team_member_zuid',
    'requested_cxns': 'desired_connections',
    'max_cxns': 'ideal_connections',
    'max_reason': 'recommendation_reason',
    'cxn_target': 'recommended_connection_target',
  }

  def __init__(self, spark, env, catalog, schema, output_table):

    self.spark = spark
    self.env = env
    self.catalog = catalog
    self.schema = schema
    self.output_table = output_table

    self.current_run_date = self.spark.sql(
      "select date(from_utc_timestamp(current_timestamp(), 'America/Los_Angeles'))"
    ).collect()[0][0]

    print(f'Spark version {self.spark.version}')
    print(f'Environment: {self.env}')
    print(f'Output Catalog: {self.catalog}')
    print(f'Output Schema: {self.schema}')
    print(f'Output Table: {self.output_table}')
    print(f'Current Run Date: {self.current_run_date}')

  def get_team_config(self):

    self.raw_team_config_data = self.spark.sql(tcq.team_config_query)

    self.raw_team_config_data.cache()

    print("retrieved team config")

    prepared_team_config_data = self.process_raw_team_config(self.raw_team_config_data)

    return prepared_team_config_data

  def get_agent_data(self):

    self.raw_agent_data = self.spark.sql(adq.agent_data_query)

    self.raw_agent_data.cache()

    print("retrieved agent data")

    prepared_agent_data = self.process_raw_agent_data(self.raw_agent_data)

    return prepared_agent_data

  def get_desired_connections(self):

    self.raw_desired_connections_data = self.spark.sql(dcq.desired_connections_query)

    self.raw_desired_connections_data.cache()

    print("retrieved desired connections")

    prepared_desired_connections_data = self.process_raw_desired_connections(self.raw_desired_connections_data)

    return prepared_desired_connections_data

  def process_raw_team_config(self, raw_team_config_data):

    team_config_date = raw_team_config_data.select(F.min('effective_date')).collect()[0][0]
    print(f'Using team allocation data from : {team_config_date}')

    # add other columns that are static (apply to all teams)
    static_team_config_columns = [
      'new_agent_target',
      'at_risk_target',
      'low_target', 
      'fair_target',
      'high_target',
      'all_agent_max',
      'low_agent_max',
    ]

    for static_col in static_team_config_columns:
      raw_team_config_data = raw_team_config_data \
        .withColumn(
          static_col,
          F.lit(AgentConnectionTargetsRecommender.DEFAULT_VALUES[static_col])
        )

    processed_team_config_data = apply_schema_and_select_columns_spark(raw_team_config_data, input_data_schemas.team_config_schema)

    validate_dataframe(processed_team_config_data, ['team_zuid'])

    print("processed team config")

    return processed_team_config_data

  def process_raw_agent_data(self, raw_agent_data):

    agent_metrics_date = raw_agent_data.select(F.max('agent_performance_date')).collect()[0][0]
    print(f'Using agent_performance_date: {agent_metrics_date}')

    processed_agent_data = apply_schema_and_select_columns_spark(raw_agent_data, input_data_schemas.agent_data_schema)

    # map some column values to expected names
    processed_agent_data = processed_agent_data \
      .withColumn(
        'cvr_bucket',
        F.when(
          F.col('cvr_bucket') == 'N/A',
          F.lit('NA')
        ).when(
          F.col('cvr_bucket') == 'Mid',
          F.lit('Fair')
        ).otherwise(F.col('cvr_bucket'))
      ) \
      .withColumn(
        'zhl_preapprovals_bucket',
        F.when(
          F.col('zhl_preapprovals_bucket') == 'N/A',
          F.lit('NA')
        ).when(
          F.col('zhl_preapprovals_bucket') == 'Mid',
          F.lit('Fair')
        ).otherwise(F.col('zhl_preapprovals_bucket'))
      )

    validate_dataframe(processed_agent_data, ['team_zuid', 'agent_zuid'], ['em_flag', 'performance_bucket'])

    print("processed agent data")

    return processed_agent_data

  def process_raw_desired_connections(self, raw_desired_connections_data):

    # derive column `desired_cxns_status`
    raw_desired_connections_data = raw_desired_connections_data \
      .withColumn(
        'n_days_since_update',
        F.datediff(F.lit(self.current_run_date), F.col('last_update').cast(T.DateType()))
      ) \
      .withColumn(
        'desired_cxns_status',
        F.when(
          (F.col('last_update').isNull()) | (F.col('n_days_since_update') > 21),
          'Unresponsive'
        ).otherwise('Ok')
      )

    processed_desired_connections_data = apply_schema_and_select_columns_spark(raw_desired_connections_data, input_data_schemas.desired_connections_schema)

    validate_dataframe(processed_desired_connections_data, ['agent_zuid'])

    print("processed desired connections")

    return processed_desired_connections_data

  def collect_input_data(self):

      # call the data retrieval functions
      self.team_config_data = self.get_team_config()
      self.agent_data = self.get_agent_data()
      self.desired_connections_data = self.get_desired_connections()
    
  def combine_and_convert_input_data(self):

    self.combined_agent_data = self.agent_data.join(
      self.desired_connections_data,
      on='agent_zuid',
      how='left'
    ) \
    .toPandas() \
    .fillna(
      {
        'desired_cxns_status': '',
        'cxns_l30': 0,
        'lifetime_cxns':0,
        'l90_optins': 0,
        'rank': 0
      }
    )

    self.team_config_data = self.team_config_data.toPandas()

    # clear the cached raw input datsets
    self.raw_team_config_data.unpersist()
    self.raw_agent_data.unpersist()
    self.raw_desired_connections_data.unpersist()

    print("combined input data and converted to pandas dfs")
  
  def calculate_recommended_agent_connection_targets(self):

    recommender_object = AgentConnectionTargetsRecommender(self.combined_agent_data, self.team_config_data)

    print("starting target recommendation algorithm")

    recommender_object.calculate_recommended_agent_connection_targets()

    recommender_object.validate_recommended_agent_connection_targets()

    self.recommended_agent_connection_targets = recommender_object.get_recommended_agent_connection_targets()

    return None
  
  def write_recommended_agent_connection_targets(self):

    output_table_path = f"{self.catalog}.{self.schema}.{self.output_table}"
    current_date_str = self.current_run_date.strftime("%Y-%m-%d")

    # convert to a spark df
    self.recommended_agent_connection_targets = self.spark.createDataFrame(self.recommended_agent_connection_targets)

    # add partition column
    self.recommended_agent_connection_targets = self.recommended_agent_connection_targets \
      .withColumn(
        'snapshot_date',
        F.lit(self.current_run_date)
      )

    # rename some columns for output table
    for old_name, new_name in UpdateRecommendedAgentConnectionTargetsTask.OUTPUT_SCHEMA_RENAMING_MAP.items():
      self.recommended_agent_connection_targets = self.recommended_agent_connection_targets \
        .withColumnRenamed(old_name, new_name)

    # in lab, add additional columns to the output schema
    output_table_schema = output_data_schemas.recommended_agent_connection_target_output_schema
    if self.env == 'lab':
      output_table_schema = T.StructType(output_table_schema.fields + output_data_schemas.additional_debug_columns_schema.fields)

    # enforce schema
    self.recommended_agent_connection_targets = apply_schema_and_select_columns_spark(self.recommended_agent_connection_targets, output_table_schema)

    # Write data to table
    # overwrite the existing date's partition if one already exists
    self.recommended_agent_connection_targets.write.mode('overwrite').partitionBy('snapshot_date').option("partitionOverwriteMode", "dynamic").option("mergeSchema", "true").saveAsTable(output_table_path)

    print(f"Wrote recommended targets to table {output_table_path} with partition date {current_date_str}")


  def run_internal(self):

    self.collect_input_data()

    self.combine_and_convert_input_data()

    self.calculate_recommended_agent_connection_targets()

    self.write_recommended_agent_connection_targets()

    print("completed task")