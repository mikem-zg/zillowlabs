---
name: databricks-analytics
description: Comprehensive data analytics and SQL operations on FUB's Databricks platform with catalog navigation, query execution, and business intelligence across production, staging, and sandbox environments with 84+ schemas and 534M+ records
---

## Overview

Comprehensive data analytics and SQL operations on FUB's Databricks platform with catalog navigation, query execution, and business intelligence across production, staging, and sandbox environments with 84+ schemas and 534M+ records. Provides intelligent query optimization, cross-catalog analysis, and business intelligence reporting with proper environment isolation and safety protocols.

## Usage

```bash
/databricks-analytics --operation=<op_type> [--catalog=<catalog_name>] [--schema=<schema_name>] [--query=<sql_query>] [--table=<table_name>] [--timeframe=<time_range>]
```

Common invocations:
- `/databricks-analytics --operation="query" --query="SELECT stage_id, COUNT(*) FROM fub.contacts_silver.contacts GROUP BY stage_id LIMIT 10"`
- `/databricks-analytics --operation="explore" --catalog="fub"`
- `/databricks-analytics --operation="analyze" --catalog="fub" --schema="agents_silver" --timeframe="past_month"`
- `/databricks-analytics --operation="monitor" --catalog="fub_zg" --timeframe="today"`

📁 **Environment Structure**: [architecture/environment-structure.md](architecture/environment-structure.md)

## Core Workflow

### Essential Data Analytics Steps (Most Common - 90% of Usage)

**1. Data Exploration and Discovery**
```bash
# Explore catalog structure
/databricks-analytics --operation="explore" --catalog="fub"

# Get schema overview
/databricks-analytics --operation="schema" --catalog="fub" --schema="contacts_silver"

# Basic query execution
/databricks-analytics --operation="query" --catalog="fub" --query="SELECT COUNT(*) FROM fub.contacts_silver.contacts"
```

**2. Business Intelligence and Analysis**
```bash
# Analyze recent activity
/databricks-analytics --operation="analyze" --catalog="fub" --schema="activities_silver" --timeframe="past_week"

# Cross-catalog comparison
/databricks-analytics --operation="analyze" --catalog="all" --query="Compare agent performance between production environments"

# Focused table analysis
/databricks-analytics --operation="analyze" --catalog="fub" --table="fub.agents_silver.agents" --timeframe="past_month"
```

**3. Safe Testing and Development**
```bash
# Test queries in staging environment
/databricks-analytics --operation="query" --catalog="stage_fub" --query="SELECT TOP 10 * FROM stage_fub.contacts_silver.contacts"

# Development work in sandbox
/databricks-analytics --operation="schema" --catalog="sandbox_fub" --schema="u_matttu"
```

**Preconditions:**
- **Databricks Access**: Valid credentials and permissions for target catalogs
- **SQL Knowledge**: Understanding of FUB data schema and relationships
- **Environment Awareness**: Clear understanding of production vs staging vs sandbox usage

### Behavior

When invoked, execute this systematic analytics workflow:

**1. Environment and Catalog Selection**
- Determine appropriate environment based on operation type and safety requirements
- Validate catalog access permissions and MCP server connectivity
- Apply environment-specific safety protocols and query restrictions

**2. Query Execution and Data Analysis**
- Execute SQL operations with intelligent optimization and resource management
- Implement cross-catalog analysis patterns for comprehensive business intelligence
- Apply data quality checks and freshness validation across bronze/silver/gold tiers

**3. Results Processing and Reporting**
- Format query results with business context and actionable insights
- Provide schema exploration and data discovery recommendations
- Generate cross-environment validation patterns for safe query development

**4. Integration and Handoff**
- Coordinate with nightly export process timing (midnight PT) for migration safety
- Enable integration with support investigation, datadog monitoring, and code development workflows
- Provide MCP resilience status and recovery mechanisms for robust operation

## Quick Reference

📊 **Complete Operations Guide**: [reference/core-operations.md](reference/core-operations.md)

### Environment Safety Guidelines

| Environment | Purpose | Safety Level | Common Use Cases |
|-------------|---------|--------------|------------------|
| **Production** (`fub`, `fub_zg`) | Live reporting, BI | **HIGH CAUTION** | Business intelligence, executive KPIs, nightly export source |
| **Staging** (`stage_fub`, `stage_fub_zg`) | Query validation | **MODERATE** | Query testing, ETL validation, performance testing |
| **Sandbox** (`sandbox_fub`) | Development, testing | **LOW** | ML model training, experimental analysis, pilot programs |

### Key Data Catalogs

**Production Data:**
- `fub` - Main production catalog (23 schemas, 534M+ contacts)
- `fub_zg` - Zillow Group integrated catalog (19 schemas with gold tier metrics)

**Development Data:**
- `stage_fub` / `stage_fub_zg` - Safe testing environments with production data snapshots
- `sandbox_fub` - Development workspace with user-specific schemas

### Essential Query Patterns

```sql
-- Catalog exploration
SHOW SCHEMAS IN fub;
SHOW TABLES IN fub.contacts_silver;

-- Basic analytics
SELECT COUNT(*) FROM fub.contacts_silver.contacts;
SELECT stage_id, COUNT(*) FROM fub.contacts_silver.contacts GROUP BY stage_id;

-- Cross-environment comparison
SELECT 'production' as env, COUNT(*) FROM fub.contacts_silver.contacts
UNION ALL
SELECT 'staging' as env, COUNT(*) FROM stage_fub.contacts_silver.contacts;
```

## Advanced Patterns

🔧 **Advanced Analytics**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)

<details>
<summary>Click to expand advanced analytics patterns and complex workflows</summary>

### Complex Multi-Environment Analytics
- Cross-catalog data consistency validation
- Multi-environment data pipeline analysis
- Advanced time-series cohort analysis

### Business Intelligence Workflows
- Lead attribution and conversion funnel analysis
- Agent performance comparison with Zillow integration metrics
- Financial analytics with revenue attribution patterns

### Data Pipeline Coordination
- Database migration impact assessment on nightly export process
- ETL pipeline health monitoring and data quality validation
- Cross-system analytics with Zillow integration performance tracking

📚 **Complete Advanced Documentation**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)

</details>

## Integration Points

🔗 **Integration Workflows**: [workflows/integration-patterns.md](workflows/integration-patterns.md)

### Cross-Skill Workflow Patterns

**Analytics → Investigation → Monitoring:**
```bash
# Complete data analysis workflow
/databricks-analytics --operation="analyze" --catalog="fub" --schema="contacts_silver" --timeframe="past_week" |\
  support-investigation --issue="Contact data anomaly" --environment="production" |\
  datadog-management --operation="create-alert" --metric="contact.data.quality"
```

**Migration → Analytics → Validation:**
```bash
# Database migration impact assessment
/code-development --task="Plan migration impact" --scope="database-migration" |\
  databricks-analytics --operation="monitor" --catalog="fub" --timeframe="today" |\
  support-investigation --issue="Validate nightly export health"
```

### Related Skills

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| `support-investigation` | **Data Analysis** | Issue investigation, anomaly detection, operational debugging |
| `code-development` | **Migration Coordination** | Database migration planning, nightly export impact assessment |
| `datadog-management` | **Monitoring Integration** | Pipeline health monitoring, data quality alerts, performance tracking |
| `confluence-management` | **Documentation** | Business intelligence reporting, insights documentation |
| `database-operations` | **Data Infrastructure** | Schema analysis, migration coordination, data quality validation |

📋 **Complete Integration Guide**: [workflows/integration-patterns.md](workflows/integration-patterns.md)

### Multi-Skill Operation Examples

**Complete Business Intelligence Workflow:**
1. `databricks-analytics` - Execute comprehensive lead attribution analysis
2. `datadog-management` - Monitor query performance and system health
3. `confluence-management` - Document insights and business recommendations
4. `support-investigation` - Validate findings against known operational issues

**Complete Data Pipeline Monitoring:**
1. `databricks-analytics` - Check data freshness and quality metrics
2. `gitlab-pipeline-monitoring` - Verify ETL pipeline status and health
3. `datadog-management` - Set up alerting for data quality thresholds
4. `support-investigation` - Investigate any data pipeline failures