## Core Operations

### Essential Operations (Most Common - 90% of Usage)

**1. Contact Analytics and Segmentation**
```sql
-- Contact lifecycle analysis
SELECT
    stage_id,
    timeframe_id,
    COUNT(*) as contact_count,
    AVG(last_activity_date) as avg_last_activity
FROM fub.contacts_silver.contacts
WHERE created_at >= CURRENT_DATE - INTERVAL 30 DAYS
GROUP BY stage_id, timeframe_id
ORDER BY contact_count DESC;

-- Lead source performance
SELECT
    ls.name as lead_source,
    COUNT(c.id) as total_leads,
    COUNT(CASE WHEN c.stage_id IN (4,5,6) THEN 1 END) as qualified_leads
FROM fub.contacts_silver.contacts c
JOIN fub.contacts_silver.lead_sources ls ON c.lead_source_id = ls.id
WHERE c.created_at >= CURRENT_DATE - INTERVAL 90 DAYS
GROUP BY ls.name
ORDER BY qualified_leads DESC;
```

**2. Agent Performance Analysis**
```sql
-- Agent activity and performance metrics
SELECT
    acc.name as agent_name,
    COUNT(DISTINCT c.id) as total_contacts,
    AVG(c.calls_outgoing + c.calls_incoming) as avg_calls,
    AVG(c.emails_sent + c.emails_received) as avg_emails
FROM fub.agents_silver.accounts acc
JOIN fub.contacts_silver.contacts c ON acc.id = c.assigned_user_id
WHERE c.last_activity_date >= CURRENT_DATE - INTERVAL 30 DAYS
GROUP BY acc.id, acc.name
ORDER BY total_contacts DESC;

-- Smart list utilization
SELECT
    sl.name as smart_list_name,
    slc.count as contact_count,
    COUNT(DISTINCT usl.user_id) as users_using
FROM fub.agents_silver.smart_lists sl
JOIN fub.agents_silver.smart_list_counts slc ON sl.id = slc.smart_list_id
JOIN fub.agents_silver.users_smart_lists usl ON sl.id = usl.smart_list_id
GROUP BY sl.id, sl.name, slc.count
ORDER BY contact_count DESC;
```

**3. Communication Analytics**
```sql
-- Communication effectiveness analysis
SELECT
    communication_type,
    DATE_TRUNC('day', created_at) as date,
    COUNT(*) as total_communications,
    AVG(CASE WHEN success = 1 THEN 1.0 ELSE 0.0 END) as success_rate
FROM fub.communications_silver.events
WHERE created_at >= CURRENT_DATE - INTERVAL 7 DAYS
GROUP BY communication_type, DATE_TRUNC('day', created_at)
ORDER BY date DESC, total_communications DESC;
```

**4. Cross-Catalog Data Quality Monitoring**
```sql
-- Data freshness monitoring
SELECT
    'fub.contacts_silver.contacts' as table_name,
    MAX(updated_at) as last_updated,
    COUNT(*) as record_count
FROM fub.contacts_silver.contacts
UNION ALL
SELECT
    'fub_zg.contacts_gold.contacts' as table_name,
    MAX(updated_at) as last_updated,
    COUNT(*) as record_count
FROM fub_zg.contacts_gold.contacts;
```

### Advanced Operations (10% of Usage)

**5. AI Insights Analysis**
```sql
-- AI recommendation effectiveness
SELECT
    insight_type,
    confidence_score,
    COUNT(*) as insight_count,
    AVG(outcome_success) as success_rate
FROM fub.interactions_ai_silver.insights
WHERE created_at >= CURRENT_DATE - INTERVAL 30 DAYS
GROUP BY insight_type, confidence_score
ORDER BY success_rate DESC;
```

**6. Financial Analytics Integration**
```sql
-- Revenue attribution analysis
SELECT
    acc.plan_id,
    COUNT(DISTINCT acc.id) as accounts,
    SUM(usage.monthly_value) as total_usage_value
FROM fub.agents_silver.accounts acc
JOIN fub.usage_silver.account_usage usage ON acc.id = usage.account_id
WHERE usage.month_year = DATE_FORMAT(CURRENT_DATE, '%Y-%m')
GROUP BY acc.plan_id
ORDER BY total_usage_value DESC;
```

## Data Pipeline Operations and ETL Management

### Database Migrations and Nightly Databricks Export

**FUB runs a nightly process at approximately midnight Pacific time** that exports large portions of FUB production data to be ingested into Databricks. This process executes SQL queries and exports CSV files for data pipeline ingestion.

#### Migration Impact on Databricks Export

**Database migrations can break the nightly export process** through:

- **Column Removal**: Removing a column from a table currently being exported nightly to Databricks
- **Schema Changes**: Altering the name or datatype of a column in exported tables
- **Table Removal**: Removing an entire table currently being exported to Databricks

#### Migration Coordination Process

**To minimize export disruptions:**

1. **Pre-Migration Review**: Coordinate with **@Jason Schuchert** to review migrations that may affect Databricks exports
2. **Downstream Coordination**: Migration timing requires coordination with downstream Databricks export processes
3. **Case-by-Case Evaluation**: Each migration is evaluated individually for potential impact

#### Migration Timing Considerations

```sql
-- Migration timing conflicts with nightly export (midnight PT)
-- If migration overlaps with export time, temporary table breakages may occur
-- This is acceptable but should be minimized when possible
```

#### Adding New Data to Databricks

**For new columns or tables that should be exported to Databricks:**

- **Contact**: **@Jason Schuchert** in Slack **#fub-infrastructure**
- **Timeline**: New data exports typically handled within days to weeks
- **Priority**: Timeline depends on business importance of the data

#### Export Recovery Process

- **Automated Detection**: Export errors are detected and addressed automatically
- **Error Handling**: Problems are addressed after they occur with minimal downtime
- **Monitoring**: Export process health is continuously monitored

### Data Pipeline Architecture

```sql
-- Understanding the nightly export process
-- 1. Production database queries (midnight PT)
-- 2. CSV file generation and export
-- 3. Databricks ingestion and processing
-- 4. Bronze -> Silver -> Gold tier processing

-- Example of export-safe migration planning:
-- GOOD: Adding new columns (coordinate for inclusion)
ALTER TABLE contacts ADD COLUMN new_engagement_score DECIMAL(5,2);

-- RISKY: Dropping exported columns (requires coordination)
-- ALTER TABLE contacts DROP COLUMN email; -- DON'T DO without coordination

-- SAFE: Renaming columns with coordination
-- 1. Add new column
-- 2. Migrate data
-- 3. Update export process
-- 4. Remove old column
```

## Data Quality and Monitoring

### Preconditions

- Databricks MCP server must be configured and accessible (with automatic resilience and recovery)
- Proper authentication and permissions for target catalogs
- Understanding of data lineage and business logic
- Awareness of data freshness and update schedules
- Understanding of nightly export process timing (midnight PT)

**MCP Resilience Integration**: This skill implements standardized MCP resilience patterns for Databricks operations:
- Automatic health checking before Databricks MCP operations
- Circuit breaker protection for failing Databricks connections
- Intelligent retry with exponential backoff for connection timeouts
- Transparent error communication and recovery guidance

### Data Quality Checks

**Record Count Validation:**
```sql
-- Validate record counts across tiers
SELECT
    'bronze' as tier,
    COUNT(*) as contact_count
FROM fub.contacts_bronze.contacts
UNION ALL
SELECT
    'silver' as tier,
    COUNT(*) as contact_count
FROM fub.contacts_silver.contacts;
```

**Data Freshness Monitoring:**
```sql
-- Check data pipeline health
SELECT
    table_schema,
    table_name,
    MAX(updated_at) as last_update,
    DATEDIFF(CURRENT_TIMESTAMP, MAX(updated_at)) as days_since_update
FROM information_schema.tables t
JOIN (SELECT * FROM fub.contacts_silver.contacts LIMIT 1) c ON 1=1
GROUP BY table_schema, table_name
HAVING days_since_update > 1;
```