## Integration Points

### Cross-Skill Workflow Patterns

**Databricks → Support Investigation:**
```bash
# Analyze data patterns for support issue investigation
/databricks-analytics --operation="investigate" --query="Contact lifecycle analysis for account 12345" |
  /support-investigation --issue="Data inconsistency in contact stages" --environment="production"
```

**Databricks → Datadog Management:**
```bash
# Monitor data pipeline health and create alerts
/databricks-analytics --operation="monitor" --catalog="fub" --timeframe="today" |
  /datadog-management --operation="create-alert" --metric="databricks.pipeline.health"
```

**Databricks → Code Development:**
```bash
# Analyze data structure for feature development
/databricks-analytics --operation="schema" --catalog="fub" --schema="contacts_silver" |
  /code-development --task="Implement contact analytics API" --scope="backend-feature"

# Coordinate database migrations with Databricks exports
/databricks-analytics --operation="monitor" --catalog="fub" --timeframe="today" |
  /code-development --task="Plan migration impact on nightly export" --scope="database-migration"
```

**Databricks → Support Investigation:**
```bash
# Investigate nightly export failures
/databricks-analytics --operation="monitor" --catalog="all" --timeframe="today" |
  /support-investigation --issue="Databricks export pipeline failure" --environment="production"
```

### Multi-Skill Operation Examples

**Complete Business Intelligence Workflow:**
1. `/databricks-analytics` - Execute comprehensive lead attribution analysis
2. `/datadog-management` - Monitor query performance and system health
3. `/confluence-management` - Document insights and business recommendations
4. `/support-investigation` - Validate findings against known operational issues

**Complete Data Pipeline Monitoring:**
1. `/databricks-analytics` - Check data freshness and quality metrics
2. `/gitlab-pipeline-monitoring` - Verify ETL pipeline status and health
3. `/datadog-management` - Set up alerting for data quality thresholds
4. `/support-investigation` - Investigate any data pipeline failures

## Cross-Environment Validation Patterns

### Safe Query Development Workflow

```sql
-- 1. Develop and test in sandbox
SELECT COUNT(*) FROM sandbox_fub.u_matttu.test_contacts;

-- 2. Validate against staging data
SELECT
    stage_id,
    COUNT(*) as contact_count,
    AVG(calls_outgoing) as avg_calls
FROM stage_fub.contacts_silver.contacts
WHERE created_at >= CURRENT_DATE - INTERVAL 7 DAYS
GROUP BY stage_id
LIMIT 10;

-- 3. Execute in production after validation
SELECT
    stage_id,
    COUNT(*) as contact_count,
    AVG(calls_outgoing) as avg_calls
FROM fub.contacts_silver.contacts
WHERE created_at >= CURRENT_DATE - INTERVAL 7 DAYS
GROUP BY stage_id;
```

## Environment Safety Guidelines

| Environment | Purpose | Safety Level | Query Restrictions |
|-------------|---------|--------------|-------------------|
| **Production** (`fub`, `fub_zg`) | Live reporting, BI | **HIGH CAUTION** | Read-only, performance-conscious |
| **Staging** (`stage_fub`, `stage_fub_zg`) | Query validation | **MODERATE** | Full testing allowed |
| **Sandbox** (`sandbox_fub`) | Development, testing | **LOW** | Experimentation allowed |

### Schema Categories by Data Tier

**Silver Tier (Primary Analytics):**
- `contacts_silver` - Contact records and properties (534M+ records)
- `agents_silver` - Agent information and performance data
- `activities_silver` - Communication and engagement tracking
- `communications_silver` - Email, SMS, call records

**Gold Tier (Business Metrics):**
- `reporting_gold` - Pre-aggregated business intelligence
- `kpis_gold` - Executive dashboard metrics

### Environment-Specific Use Cases

**Production (`fub` / `fub_zg`):**
- Live business intelligence and reporting
- Production dashboards and metrics
- Real-time operational analytics
- Executive KPI tracking
- **Nightly export source data** (midnight PT export process)
- Post-migration data validation and monitoring

**Staging (`stage_fub` / `stage_fub_zg`):**
- Query validation and testing
- ETL pipeline validation
- Data quality verification
- Performance testing with realistic data volumes

**Sandbox (`sandbox_fub`):**
- Algorithm development and testing
- ML model training and evaluation
- Experimental data analysis
- User-specific development projects
- Pilot program data analysis