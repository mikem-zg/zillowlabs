## Environment Structure

### Production Environments

**`fub`** - Production data catalog (23 schemas, 534M+ records)
**`fub_zg`** - Zillow Group integrated production catalog (19 schemas)

### Staging Environments

**`stage_fub`** - Staging mirror of production fub catalog (23 schemas)
**`stage_fub_zg`** - Staging mirror of production fub_zg catalog (19 schemas)

### Development & Testing

**`sandbox_fub`** - Development sandbox with test data and user workspaces (6+ schemas)

## Data Architecture Tiers

**Bronze Tier** - Raw, unprocessed data
- Direct ingestion from source systems
- Minimal transformation and validation
- Historical data retention

**Silver Tier** - Cleaned and enriched data
- Business logic applied
- Data quality validation
- Ready for analytical queries

**Gold Tier** - Aggregated business metrics
- Pre-calculated KPIs and metrics
- Optimized for reporting and dashboards
- Executive-level insights

## FUB Catalog (`fub`) - 23 Schemas

### Core Business Schemas

**Customer Data:**
- `contacts_bronze` - Raw contact ingestion
- `contacts_silver` - 534M+ cleaned contact records with full customer lifecycle
- `agents_bronze` - Raw agent data
- `agents_silver` - Agent accounts, smart lists, Zillow integration data

**Communication & Activities:**
- `activities_bronze` - Raw activity streams
- `activities_silver` - Customer interaction timeline and engagement metrics
- `communications_bronze` - Raw communication logs
- `communications_silver` - Email, SMS, call records with delivery status

**AI & Analytics:**
- `ai_insights_bronze` - Raw AI processing data
- `interactions_ai_bronze` - Raw interaction analysis
- `interactions_ai_silver` - Processed AI insights and recommendations

**Operational Data:**
- `call_transcription_bronze` - Raw call transcription data
- `usage_bronze` / `usage_silver` - Platform usage analytics and metrics
- `fub_operator_bronze` - Internal operational data

**Financial & Support:**
- `stripe_bronze` - Raw payment and billing data
- `zendesk_bronze` - Customer support ticket data
- `shared_internal_bronze` / `shared_internal_silver` - Cross-system shared data

**System Management:**
- `airbyte_internal` - Data pipeline management
- `internal` - System configuration and metadata
- `information_schema` - Database structure and schema information

## FUB ZG Catalog (`fub_zg`) - 19 Schemas

### Zillow Group Integration Schemas

**Enhanced Customer Data:**
- `contacts_gold` / `contacts_silver` - Zillow-enriched contact data
- `agents_bronze` / `agents_silver` / `agents_gold` - Full agent hierarchy with Zillow integration
- `identity_bronze` / `identity_silver` / `identity_gold` - Unified identity resolution

**Advanced Analytics:**
- `communications_gold` / `communications_silver` - Enhanced communication analytics
- `metrics_gold` - Executive KPIs and business metrics
- `ai_exp_bronze` - Experimental AI features and analysis

**Specialized Data:**
- `activities_silver` - Zillow-enhanced activity tracking
- `interactions_ai_bronze` - AI-powered interaction analysis
- `stripe_silver` - Enhanced financial analytics
- `support_silver` - Advanced support analytics

**System Integration:**
- `shared_internal_silver` - Cross-platform data integration
- `internal` - ZG-specific system configuration
- `information_schema` - Schema metadata and structure

## Staging Environments (`stage_fub` / `stage_fub_zg`)

### Purpose and Usage

**Staging environments mirror production data structure** with recent production data snapshots for safe testing and validation.

**Stage FUB Catalog (`stage_fub`) - 23 Schemas:**
- Identical schema structure to production `fub` catalog
- Refreshed data snapshots from production (typically daily/weekly)
- Safe environment for testing queries before production execution
- Used for ETL pipeline testing and validation

**Stage FUB ZG Catalog (`stage_fub_zg`) - 19 Schemas:**
- Mirrors production `fub_zg` catalog structure
- Zillow integration testing and validation
- Cross-system integration testing environment

### Staging Best Practices

```sql
-- Always test complex queries in staging first
-- Example: Test a complex lead attribution query
SELECT
    ls.name as lead_source,
    COUNT(*) as leads_count,
    AVG(DATEDIFF(c.assigned_at, c.created_at)) as avg_assignment_delay
FROM stage_fub.contacts_silver.contacts c
JOIN stage_fub.contacts_silver.lead_sources ls ON c.lead_source_id = ls.id
WHERE c.created_at >= CURRENT_DATE - INTERVAL 30 DAYS
GROUP BY ls.name
LIMIT 10;

-- Then execute against production with confidence
-- SELECT ... FROM fub.contacts_silver.contacts c ...
```

## Sandbox Environment (`sandbox_fub`)

### Development and Testing Workspace

**Sandbox FUB Catalog (`sandbox_fub`) - 6+ Schemas:**
- `_fivetran_setup_test` - Connector testing and setup
- `call_summary_feedback_model_graded_evaluation` - ML model evaluation data
- `fub_operator_test` - Operator system testing
- `listing_soon_pilot` - Pilot program data and testing
- `u_matttu` - User-specific development workspace
- `information_schema` - Schema metadata

### Sandbox Usage Patterns

```sql
-- Personal development workspace
CREATE TABLE sandbox_fub.u_matttu.my_analysis_table AS
SELECT
    contact_id,
    stage_id,
    lead_source_id,
    created_at
FROM stage_fub.contacts_silver.contacts
WHERE created_at >= '2024-01-01'
LIMIT 1000;

-- ML model testing and evaluation
SELECT * FROM sandbox_fub.call_summary_feedback_model_graded_evaluation.evaluation_results
WHERE model_version = 'v2.1' AND evaluation_date >= CURRENT_DATE - INTERVAL 7 DAYS;

-- Pilot program analysis
SELECT
    pilot_status,
    COUNT(*) as participant_count,
    AVG(engagement_score) as avg_engagement
FROM sandbox_fub.listing_soon_pilot.participants
GROUP BY pilot_status;
```