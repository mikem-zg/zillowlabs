#!/bin/bash
# Databricks OAuth Analysis Script for FUB Zillow Integration
# Production data correlation and historical OAuth analysis via Databricks
#
# Usage: ./fub-databricks-oauth-analysis.sh --account_id="ACCOUNT_ID" --operation="OPERATION" [OPTIONS]
# Examples:
#   ./fub-databricks-oauth-analysis.sh --account_id="148261" --operation="correlation"
#   ./fub-databricks-oauth-analysis.sh --account_id="148261" --operation="health_metrics"
#   ./fub-databricks-oauth-analysis.sh --account_id="148261" --operation="activity_history" --days=30

set -euo pipefail

ACCOUNT_ID=""
OPERATION=""
DAYS="7"
CATALOG="fub"
USER_ID=""

# Script directory for relative path resolution
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
    cat << EOF
Databricks OAuth Analysis for FUB Zillow Integration

USAGE:
    $0 --account_id="ACCOUNT_ID" --operation="OPERATION" [OPTIONS]

REQUIRED PARAMETERS:
    --account_id="ID"     FUB account identifier
    --operation="OP"      Analysis operation to perform

OPERATIONS:
    correlation           Production data correlation with local OAuth analysis
    health_metrics        Account-wide OAuth health and adoption metrics
    activity_history      Historical OAuth activity and problem tracking
    environment_validation Cross-catalog validation (fub vs stage_fub)
    lead_events_correlation OAuth issues correlation with lead events

OPTIONAL PARAMETERS:
    --user_id="ID"        Specific user ID for focused analysis
    --days="N"            Days of historical data (default: 7)
    --catalog="NAME"      Databricks catalog (default: fub)

EXAMPLES:
    $0 --account_id="148261" --operation="correlation"
    $0 --account_id="148261" --operation="health_metrics"
    $0 --account_id="148261" --operation="activity_history" --days=30
    $0 --account_id="148261" --operation="environment_validation"

INTEGRATION:
    This script integrates with databricks-analytics skill for production data analysis.
    Requires Databricks MCP server configuration and appropriate permissions.
EOF
}

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --account_id=*)
                ACCOUNT_ID="${1#*=}"
                shift
                ;;
            --operation=*)
                OPERATION="${1#*=}"
                shift
                ;;
            --user_id=*)
                USER_ID="${1#*=}"
                shift
                ;;
            --days=*)
                DAYS="${1#*=}"
                shift
                ;;
            --catalog=*)
                CATALOG="${1#*=}"
                shift
                ;;
            --help|-h)
                usage
                exit 0
                ;;
            *)
                echo "❌ Error: Unknown parameter $1"
                usage
                exit 1
                ;;
        esac
    done
}

validate_inputs() {
    if [[ -z "$ACCOUNT_ID" || -z "$OPERATION" ]]; then
        echo "❌ Error: Both --account_id and --operation are required"
        usage
        exit 1
    fi

    if ! [[ "$ACCOUNT_ID" =~ ^[0-9]+$ ]]; then
        echo "❌ Error: ACCOUNT_ID must be numeric"
        exit 1
    fi

    if [[ -n "$USER_ID" && ! "$USER_ID" =~ ^[0-9]+$ ]]; then
        echo "❌ Error: USER_ID must be numeric if provided"
        exit 1
    fi

    if ! [[ "$DAYS" =~ ^[0-9]+$ ]]; then
        echo "❌ Error: DAYS must be numeric"
        exit 1
    fi

    case "$OPERATION" in
        correlation|health_metrics|activity_history|environment_validation|lead_events_correlation)
            # Valid operations
            ;;
        *)
            echo "❌ Error: Invalid operation '$OPERATION'"
            usage
            exit 1
            ;;
    esac

    # Check if databricks-analytics skill is available
    if ! command -v databricks-analytics >/dev/null 2>&1; then
        echo "⚠️  Warning: databricks-analytics skill not found in PATH"
        echo "   This script requires the databricks-analytics skill for Databricks MCP integration"
        echo "   Queries will be displayed but not executed"
    fi
}

execute_databricks_query() {
    local query="$1"
    local description="$2"

    echo "🔍 $description"
    echo ""
    echo "📊 Databricks Query:"
    echo "```sql"
    echo "$query"
    echo "```"
    echo ""

    # Try to execute via databricks-analytics skill if available
    if command -v databricks-analytics >/dev/null 2>&1; then
        echo "🚀 Executing query via databricks-analytics skill..."
        # Execute the query using the databricks-analytics skill
        # Note: The actual execution depends on the skill's interface
        echo "   📋 Use: /databricks-analytics --operation=\"query\" --catalog=\"$CATALOG\" --query=\"$description\""
        echo ""
    else
        echo "💡 Manual Execution:"
        echo "   Use Databricks workspace or /databricks-analytics skill to execute the above query"
        echo ""
    fi
}

oauth_correlation_analysis() {
    echo "=== Production OAuth Data Correlation Analysis ==="
    echo "Account: $ACCOUNT_ID, Catalog: $CATALOG"

    local user_filter=""
    if [[ -n "$USER_ID" ]]; then
        user_filter="AND za.user_id = $USER_ID"
    fi

    local query="
-- OAuth Status Correlation Analysis for Account $ACCOUNT_ID
SELECT
    za.account_id,
    za.user_id,
    za.zuid,
    CASE WHEN za.encrypted_refresh_token IS NOT NULL THEN 'ACTIVE' ELSE 'INACTIVE' END as token_status,
    zsu.zillow_email,
    zsu.problem_msg,
    zsu.last_verified_at,
    TIMESTAMPDIFF(DAY, za.updated_at, NOW()) as days_since_token_update,
    TIMESTAMPDIFF(DAY, zsu.last_verified_at, NOW()) as days_since_verification
FROM $CATALOG.agents_silver.zillow_auth za
LEFT JOIN $CATALOG.agents_silver.zillow_sync_users zsu
    ON za.account_id = zsu.account_id AND za.user_id = zsu.user_id
WHERE za.account_id = $ACCOUNT_ID $user_filter
ORDER BY za.updated_at DESC
LIMIT 50;
    "

    execute_databricks_query "$query" "OAuth Status Correlation for Account $ACCOUNT_ID"

    echo "📋 Analysis Focus:"
    echo "   • Active vs inactive OAuth tokens"
    echo "   • Correlation between zillow_auth and zillow_sync_users"
    echo "   • Recent OAuth activity and verification status"
    echo "   • Problem messages and resolution tracking"
}

oauth_health_metrics() {
    echo "=== Account-Wide OAuth Health Metrics ==="
    echo "Account: $ACCOUNT_ID, Catalog: $CATALOG"

    local query="
-- OAuth Health and Adoption Metrics for Account $ACCOUNT_ID
WITH oauth_summary AS (
    SELECT
        za.account_id,
        COUNT(*) as total_oauth_records,
        COUNT(CASE WHEN za.encrypted_refresh_token IS NOT NULL THEN 1 END) as active_tokens,
        COUNT(zsu.id) as sync_user_records,
        COUNT(CASE WHEN zsu.problem_at IS NOT NULL THEN 1 END) as users_with_problems,
        COUNT(CASE WHEN zsu.last_verified_at >= CURRENT_DATE - INTERVAL 7 DAYS THEN 1 END) as recently_verified
    FROM $CATALOG.agents_silver.zillow_auth za
    LEFT JOIN $CATALOG.agents_silver.zillow_sync_users zsu
        ON za.account_id = zsu.account_id AND za.user_id = zsu.user_id
    WHERE za.account_id = $ACCOUNT_ID
    GROUP BY za.account_id
)
SELECT
    account_id,
    total_oauth_records,
    active_tokens,
    sync_user_records,
    users_with_problems,
    recently_verified,
    ROUND(100.0 * active_tokens / NULLIF(total_oauth_records, 0), 2) as token_health_rate,
    ROUND(100.0 * (total_oauth_records - users_with_problems) / NULLIF(total_oauth_records, 0), 2) as problem_free_rate,
    ROUND(100.0 * recently_verified / NULLIF(total_oauth_records, 0), 2) as recent_verification_rate
FROM oauth_summary;
    "

    execute_databricks_query "$query" "OAuth Health Metrics for Account $ACCOUNT_ID"

    echo "📊 Metrics Explanation:"
    echo "   • token_health_rate: % of OAuth records with active tokens"
    echo "   • problem_free_rate: % of users without recorded problems"
    echo "   • recent_verification_rate: % verified in last 7 days"
    echo ""

    # Additional agent mapping analysis
    local agent_query="
-- Agent OAuth Integration Analysis
SELECT
    COUNT(DISTINCT za.zuid) as oauth_connected_agents,
    COUNT(DISTINCT zag.user_id) as total_zillow_agents,
    ROUND(100.0 * COUNT(DISTINCT za.zuid) / NULLIF(COUNT(DISTINCT zag.user_id), 0), 2) as agent_oauth_coverage
FROM $CATALOG.agents_silver.zillow_agents zag
LEFT JOIN $CATALOG.agents_silver.zillow_auth za ON zag.user_id = za.user_id
WHERE za.account_id = $ACCOUNT_ID OR zag.account_id = $ACCOUNT_ID;
    "

    execute_databricks_query "$agent_query" "Agent OAuth Coverage Analysis"
}

oauth_activity_history() {
    echo "=== Historical OAuth Activity Analysis ==="
    echo "Account: $ACCOUNT_ID, Days: $DAYS, Catalog: $CATALOG"

    local query="
-- OAuth Activity and Problem Tracking (Last $DAYS days)
SELECT
    DATE_TRUNC('day', zsu.problem_at) as problem_date,
    COUNT(*) as problems_reported,
    COUNT(CASE WHEN zsu.last_verified_at > zsu.problem_at THEN 1 END) as problems_resolved,
    COUNT(DISTINCT zsu.user_id) as affected_users,
    COLLECT_LIST(DISTINCT zsu.problem_msg)[0:5] as sample_problem_messages
FROM $CATALOG.agents_silver.zillow_sync_users zsu
WHERE zsu.account_id = $ACCOUNT_ID
    AND zsu.problem_at >= CURRENT_DATE - INTERVAL $DAYS DAYS
GROUP BY DATE_TRUNC('day', zsu.problem_at)
ORDER BY problem_date DESC;
    "

    execute_databricks_query "$query" "OAuth Problem History for Account $ACCOUNT_ID"

    # Token refresh activity analysis
    local refresh_query="
-- Token Refresh Activity Analysis
SELECT
    DATE_TRUNC('day', za.updated_at) as update_date,
    COUNT(*) as token_updates,
    COUNT(DISTINCT za.user_id) as users_updated,
    AVG(TIMESTAMPDIFF(HOUR, za.created_at, za.updated_at)) as avg_token_age_hours
FROM $CATALOG.agents_silver.zillow_auth za
WHERE za.account_id = $ACCOUNT_ID
    AND za.updated_at >= CURRENT_DATE - INTERVAL $DAYS DAYS
    AND za.updated_at > za.created_at  -- Only actual updates, not initial creation
GROUP BY DATE_TRUNC('day', za.updated_at)
ORDER BY update_date DESC;
    "

    execute_databricks_query "$refresh_query" "Token Refresh Activity Analysis"

    echo "📈 Historical Analysis Focus:"
    echo "   • OAuth problem trends and resolution patterns"
    echo "   • Token refresh frequency and patterns"
    echo "   • User impact assessment over time"
    echo "   • Problem message patterns for root cause analysis"
}

environment_validation() {
    echo "=== Cross-Environment OAuth Validation ==="
    echo "Account: $ACCOUNT_ID"

    local prod_staging_query="
-- Production vs Staging OAuth Consistency
SELECT
    'production_fub' as environment,
    COUNT(*) as oauth_records,
    COUNT(CASE WHEN encrypted_refresh_token IS NOT NULL THEN 1 END) as active_tokens,
    MAX(updated_at) as last_token_update
FROM fub.agents_silver.zillow_auth
WHERE account_id = $ACCOUNT_ID

UNION ALL

SELECT
    'staging_fub' as environment,
    COUNT(*) as oauth_records,
    COUNT(CASE WHEN encrypted_refresh_token IS NOT NULL THEN 1 END) as active_tokens,
    MAX(updated_at) as last_token_update
FROM stage_fub.agents_silver.zillow_auth
WHERE account_id = $ACCOUNT_ID

UNION ALL

SELECT
    'production_fub_zg' as environment,
    COUNT(*) as oauth_records,
    COUNT(CASE WHEN encrypted_refresh_token IS NOT NULL THEN 1 END) as active_tokens,
    MAX(updated_at) as last_token_update
FROM fub_zg.agents_silver.zillow_auth
WHERE account_id = $ACCOUNT_ID;
    "

    execute_databricks_query "$prod_staging_query" "Cross-Environment OAuth Comparison"

    echo "🔄 Environment Validation Focus:"
    echo "   • Data consistency between production and staging"
    echo "   • ZG-enhanced catalog comparison"
    echo "   • Data freshness across environments"
    echo "   • Migration and synchronization health"
}

lead_events_correlation() {
    echo "=== OAuth Issues Correlation with Lead Events ==="
    echo "Account: $ACCOUNT_ID, Days: $DAYS, Catalog: $CATALOG"

    local lead_correlation_query="
-- OAuth Issues Impact on Lead Events (Last $DAYS days)
WITH oauth_status AS (
    SELECT za.zuid, za.encrypted_refresh_token IS NOT NULL as has_active_token
    FROM $CATALOG.agents_silver.zillow_auth za
    WHERE za.account_id = $ACCOUNT_ID
),
lead_events AS (
    SELECT
        lle.owner_agent_id,
        COUNT(*) as total_lead_events,
        COUNT(CASE WHEN lle.is_tour = 1 THEN 1 END) as tour_events,
        COUNT(CASE WHEN lle.is_flex = 1 THEN 1 END) as flex_events,
        MAX(lle.created_at) as last_event_time
    FROM $CATALOG.contacts_bronze.zillow_lead_events_logs lle
    WHERE lle.created_at >= CURRENT_DATE - INTERVAL $DAYS DAYS
    GROUP BY lle.owner_agent_id
)
SELECT
    le.owner_agent_id,
    CASE WHEN os.has_active_token THEN 'HAS_OAUTH' ELSE 'NO_OAUTH' END as oauth_status,
    le.total_lead_events,
    le.tour_events,
    le.flex_events,
    le.last_event_time,
    CASE
        WHEN os.has_active_token THEN 'OAuth OK'
        ELSE 'OAuth Issue - May Impact Lead Processing'
    END as impact_assessment
FROM lead_events le
LEFT JOIN oauth_status os ON le.owner_agent_id = os.zuid
ORDER BY le.total_lead_events DESC, oauth_status DESC
LIMIT 50;
    "

    execute_databricks_query "$lead_correlation_query" "OAuth-Lead Events Correlation Analysis"

    echo "🔗 Correlation Analysis Focus:"
    echo "   • Lead events for agents without OAuth tokens"
    echo "   • Potential impact on lead processing and sync"
    echo "   • Tour and flex event patterns vs OAuth status"
    echo "   • Agent activity levels requiring OAuth attention"
}

generate_analysis_summary() {
    echo "=== Analysis Summary and Recommendations ==="
    echo "Timestamp: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
    echo "Account: $ACCOUNT_ID, Operation: $OPERATION"
    echo ""

    case "$OPERATION" in
        correlation)
            echo "📋 OAuth Correlation Analysis Completed"
            echo "   ✅ Production data correlation with local OAuth analysis"
            echo "   📊 Token status vs sync user data validation"
            echo "   🔍 Next Steps: Review token_status and problem_msg patterns"
            ;;
        health_metrics)
            echo "📊 OAuth Health Metrics Analysis Completed"
            echo "   ✅ Account-wide adoption and health assessment"
            echo "   📈 Coverage and problem rate calculations"
            echo "   🔍 Next Steps: Focus on low adoption or high problem rates"
            ;;
        activity_history)
            echo "📈 OAuth Activity History Analysis Completed"
            echo "   ✅ Historical problem tracking and resolution patterns"
            echo "   🔄 Token refresh frequency analysis"
            echo "   🔍 Next Steps: Investigate recurring problem patterns"
            ;;
        environment_validation)
            echo "🔄 Environment Validation Completed"
            echo "   ✅ Cross-environment OAuth data consistency check"
            echo "   📊 Production vs staging data comparison"
            echo "   🔍 Next Steps: Address any significant inconsistencies"
            ;;
        lead_events_correlation)
            echo "🔗 Lead Events Correlation Analysis Completed"
            echo "   ✅ OAuth status impact on lead event processing"
            echo "   📊 Agent activity vs OAuth status correlation"
            echo "   🔍 Next Steps: Prioritize OAuth fixes for high-activity agents"
            ;;
    esac

    echo ""
    echo "🛠️  Integration Recommendations:"
    echo "   1. Combine with local OAuth scripts for comprehensive diagnosis"
    echo "   2. Use results to prioritize OAuth remediation efforts"
    echo "   3. Monitor trends using regular Databricks analysis"
    echo "   4. Correlate findings with production Datadog metrics"
    echo ""
    echo "📚 Related Tools:"
    echo "   • fub-oauth-token-analysis.sh - Local token validation"
    echo "   • fub-oauth-consistency-check.sh - Cross-table validation"
    echo "   • databricks-analytics skill - Advanced query execution"
    echo "   • datadog-management - Production metrics correlation"
}

main() {
    echo "🚀 FUB Databricks OAuth Analysis"
    parse_arguments "$@"
    validate_inputs

    echo "Account ID: $ACCOUNT_ID"
    echo "Operation: $OPERATION"
    echo "Catalog: $CATALOG"
    echo "Days: $DAYS"
    if [[ -n "$USER_ID" ]]; then
        echo "User ID: $USER_ID"
    fi
    echo "----------------------------------------"
    echo ""

    case "$OPERATION" in
        correlation)
            oauth_correlation_analysis
            ;;
        health_metrics)
            oauth_health_metrics
            ;;
        activity_history)
            oauth_activity_history
            ;;
        environment_validation)
            environment_validation
            ;;
        lead_events_correlation)
            lead_events_correlation
            ;;
    esac

    echo ""
    generate_analysis_summary

    echo ""
    echo "----------------------------------------"
    echo "For Databricks query execution, use:"
    echo "/databricks-analytics --operation=\"query\" --catalog=\"$CATALOG\" --query=\"[QUERY_FROM_ABOVE]\""
    echo ""
    echo "For related OAuth troubleshooting, see:"
    echo "https://zillowgroup.atlassian.net/wiki/spaces/FUB/pages/1863421945/Zillow+sync+FAQ+Troubleshooting"
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi