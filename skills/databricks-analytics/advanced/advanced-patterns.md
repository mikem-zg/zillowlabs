## Advanced Patterns

### Complex Multi-Environment Analytics Workflows

#### Cross-Catalog Data Pipeline Analysis
**Advanced pattern for analyzing data flow across production, staging, and sandbox environments:**

```sql
-- Multi-environment data consistency validation
WITH prod_summary AS (
  SELECT
    'production' as environment,
    catalog_name,
    schema_name,
    table_name,
    row_count,
    last_updated
  FROM fub.information_schema.table_statistics
  WHERE catalog_name IN ('fub', 'fub_zg')
),
stage_summary AS (
  SELECT
    'staging' as environment,
    catalog_name,
    schema_name,
    table_name,
    row_count,
    last_updated
  FROM stage_fub.information_schema.table_statistics
  WHERE catalog_name IN ('stage_fub', 'stage_fub_zg')
)
SELECT
  p.schema_name,
  p.table_name,
  p.row_count as prod_count,
  s.row_count as stage_count,
  ABS(p.row_count - s.row_count) as row_diff,
  CASE
    WHEN ABS(p.row_count - s.row_count) / p.row_count > 0.05
    THEN 'SIGNIFICANT_VARIANCE'
    ELSE 'ACCEPTABLE'
  END as variance_status
FROM prod_summary p
JOIN stage_summary s ON p.schema_name = s.schema_name
  AND p.table_name = s.table_name
WHERE p.row_count > 1000
ORDER BY row_diff DESC;
```

#### Advanced Time-Series Analysis for FUB Business Intelligence
**Complex temporal analytics for lead lifecycle and conversion patterns:**

```sql
-- Lead conversion funnel with temporal cohort analysis
WITH monthly_cohorts AS (
  SELECT
    DATE_TRUNC('month', c.created_at) as cohort_month,
    c.id as contact_id,
    c.lead_source,
    MIN(a.created_at) as first_activity,
    MIN(CASE WHEN a.activity_type = 'showing' THEN a.created_at END) as first_showing,
    MIN(CASE WHEN a.activity_type = 'offer' THEN a.created_at END) as first_offer
  FROM fub.contacts_silver.contacts c
  LEFT JOIN fub.activities_silver.activities a ON c.id = a.contact_id
  WHERE c.created_at >= CURRENT_DATE - INTERVAL 12 MONTHS
  GROUP BY 1, 2, 3
),
funnel_metrics AS (
  SELECT
    cohort_month,
    lead_source,
    COUNT(*) as total_leads,
    COUNT(first_activity) as engaged_leads,
    COUNT(first_showing) as showing_leads,
    COUNT(first_offer) as offer_leads,
    AVG(DATEDIFF(first_activity, cohort_month)) as avg_days_to_engagement,
    AVG(DATEDIFF(first_showing, first_activity)) as avg_days_engagement_to_showing
  FROM monthly_cohorts
  GROUP BY 1, 2
)
SELECT
  cohort_month,
  lead_source,
  total_leads,
  ROUND(engaged_leads / total_leads * 100, 2) as engagement_rate_pct,
  ROUND(showing_leads / engaged_leads * 100, 2) as showing_conversion_pct,
  ROUND(offer_leads / showing_leads * 100, 2) as offer_conversion_pct,
  avg_days_to_engagement,
  avg_days_engagement_to_showing
FROM funnel_metrics
WHERE total_leads >= 10
ORDER BY cohort_month DESC, total_leads DESC;
```

### Business Intelligence Workflows

**Lead Attribution Analysis:**
```sql
-- Multi-touch attribution across channels
WITH lead_journey AS (
  SELECT
    c.id as contact_id,
    c.lead_source_id,
    ls.name as lead_source,
    c.created_at as first_touch,
    c.assigned_at as assignment_date,
    c.last_activity_date as last_engagement
  FROM fub.contacts_silver.contacts c
  JOIN fub.contacts_silver.lead_sources ls ON c.lead_source_id = ls.id
  WHERE c.created_at >= CURRENT_DATE - INTERVAL 90 DAYS
)
SELECT
  lead_source,
  COUNT(*) as total_leads,
  AVG(DATEDIFF(assignment_date, first_touch)) as avg_assignment_delay,
  COUNT(CASE WHEN last_engagement > assignment_date THEN 1 END) as engaged_leads
FROM lead_journey
GROUP BY lead_source
ORDER BY total_leads DESC;
```

### Cross-System Analytics

**Zillow Integration Performance:**
```sql
-- Compare Zillow-enhanced vs standard agent performance
SELECT
    'zillow_integrated' as agent_type,
    COUNT(DISTINCT za.user_id) as agent_count,
    AVG(c.calls_outgoing) as avg_calls,
    AVG(c.conversion_rate) as avg_conversion
FROM fub.agents_silver.zillow_agents za
JOIN fub.contacts_silver.contacts c ON za.user_id = c.assigned_user_id
WHERE c.last_activity_date >= CURRENT_DATE - INTERVAL 30 DAYS
UNION ALL
SELECT
    'standard' as agent_type,
    COUNT(DISTINCT c.assigned_user_id) as agent_count,
    AVG(c.calls_outgoing) as avg_calls,
    AVG(c.conversion_rate) as avg_conversion
FROM fub.contacts_silver.contacts c
WHERE c.assigned_user_id NOT IN (SELECT user_id FROM fub.agents_silver.zillow_agents)
  AND c.last_activity_date >= CURRENT_DATE - INTERVAL 30 DAYS;
```

## Security and Best Practices

### Query Optimization Guidelines

1. **Use Appropriate Filters:**
   - Always include date ranges for large tables
   - Leverage partition keys (account_id, created_at)
   - Use LIMIT for exploratory queries

2. **Environment Selection Strategy:**
   - Use `fub` / `fub_zg` for production analytics and live business intelligence
   - Use `stage_fub` / `stage_fub_zg` for testing complex queries before production
   - Use `sandbox_fub` for development, experimentation, and model testing
   - Use gold tables for executive reporting across all environments

3. **Performance Optimization:**
   - Cache frequently accessed datasets
   - Use delta table features for incremental updates
   - Leverage cluster columns for better performance

### Data Privacy and Compliance

- All queries must respect PII protection guidelines
- Use aggregated views for reporting when possible
- Implement row-level security based on account access
- Log all data access for audit trails

## Documentation and Resources

### Official Documentation
- **FUB Databricks Onboarding Guide:** [Confluence Link](https://zillowgroup.atlassian.net/wiki/spaces/~7120204c31365177164c70a31213cb148f959c/pages/2061434980/FUB+Databricks+Onboarding+Guide)
- **FUB Deployment Guide - Database Migrations:** [Deploying FUB](https://zillowgroup.atlassian.net/wiki/spaces/FUB/pages/749307761/Deploying+fub#Database-Migrations-and-effect-on-nightly-export-to-Databricks)
- **Data Catalog Documentation:** Available in information_schema tables
- **Business Logic Documentation:** Embedded in silver table transformations

### Schema Reference

**Key Table Relationships:**
- `contacts.assigned_user_id` → `agents.accounts.id`
- `contacts.lead_source_id` → `contacts.lead_sources.id`
- `contacts.stage_id` → `contacts.stages.id`
- `contacts.timeframe_id` → `contacts.timeframes.id`

**Common Join Patterns:**
- Contact → Agent: `contacts.assigned_user_id = accounts.id`
- Contact → Lead Source: `contacts.lead_source_id = lead_sources.id`
- Agent → Zillow Integration: `accounts.id = zillow_agents.user_id`

## Refusal Conditions

The skill must refuse if:
- Databricks MCP server is unavailable after automatic recovery attempts
- Query attempts to access unauthorized catalogs or schemas
- Request involves modifying data (INSERT, UPDATE, DELETE operations)
- Query lacks proper filtering and could impact system performance
- Request involves accessing PII data without proper justification
- Query timeout exceeds 15-minute Databricks session limit
- Request for database migration guidance without proper coordination context

When refusing, provide specific guidance:
- How to check Databricks MCP server configuration and recovery options
- Proper query optimization techniques
- Alternative approaches for data analysis
- Data privacy and security best practices
- Integration patterns with other FUB systems
- MCP resilience status and available recovery mechanisms

**MCP Recovery Features:**
- Automatic Databricks MCP health checking and restart attempts
- Intelligent retry with exponential backoff for connection issues
- Circuit breaker protection prevents repeated failures on unhealthy connections
- Clear error communication with recovery guidance and alternative approaches