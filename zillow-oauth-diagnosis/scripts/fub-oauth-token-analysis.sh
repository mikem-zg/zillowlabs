#!/bin/bash
# OAuth Token Analysis Script for FUB Zillow Integration
# Comprehensive analysis of OAuth token status across both FUB storage systems
#
# Usage: ./fub-oauth-token-analysis.sh ACCOUNT_ID USER_ID
# Example: ./fub-oauth-token-analysis.sh 148261 571

set -euo pipefail

ACCOUNT_ID="${1:-}"
USER_ID="${2:-}"

# Script directory for relative path resolution
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FUB_DB_SCRIPT="$SCRIPT_DIR/../../database-operations/scripts/fub-db.sh"

usage() {
    cat << EOF
OAuth Token Analysis for FUB Zillow Integration

USAGE:
    $0 ACCOUNT_ID USER_ID

PARAMETERS:
    ACCOUNT_ID    FUB account identifier
    USER_ID       FUB user identifier

EXAMPLES:
    $0 148261 571                    # Analyze specific user OAuth status
    $0 14009 571                     # Check token refresh issues

OUTPUT:
    - ZillowAuth record status and token freshness
    - ZillowSyncUser legacy OAuth analysis
    - Token service compatibility recommendations
    - Recent OAuth activity correlation
EOF
}

validate_inputs() {
    if [[ -z "$ACCOUNT_ID" || -z "$USER_ID" ]]; then
        echo "❌ Error: Both ACCOUNT_ID and USER_ID are required"
        usage
        exit 1
    fi

    if ! [[ "$ACCOUNT_ID" =~ ^[0-9]+$ ]] || ! [[ "$USER_ID" =~ ^[0-9]+$ ]]; then
        echo "❌ Error: ACCOUNT_ID and USER_ID must be numeric"
        exit 1
    fi

    if [[ ! -x "$FUB_DB_SCRIPT" ]]; then
        echo "❌ Error: fub-db.sh not found at $FUB_DB_SCRIPT"
        echo "   Please ensure database-operations skill is available"
        exit 1
    fi
}

# Safe database query execution with output filtering
safe_db_query() {
    local query="$1"
    local result
    result=$("$FUB_DB_SCRIPT" query dev common "$query" 2>/dev/null | grep -v "Reading\|Found\|mysql:" | grep -v "^$" || echo "")
    echo "$result"
}

check_zillow_auth_status() {
    echo "=== ZillowAuth Analysis (Modern OAuth System) ==="

    local auth_query="
        SELECT
            id,
            account_id,
            user_id,
            zuid,
            CASE
                WHEN encrypted_refresh_token IS NOT NULL THEN 'PRESENT'
                ELSE 'MISSING'
            END as token_status,
            zillow_sync_user_id,
            created_at,
            updated_at,
            TIMESTAMPDIFF(HOUR, updated_at, NOW()) as hours_since_update
        FROM zillow_auth
        WHERE account_id = $ACCOUNT_ID AND user_id = $USER_ID;
    "

    local auth_result
    auth_result=$(safe_db_query "$auth_query")

    if [[ -z "$auth_result" ]]; then
        echo "❌ No ZillowAuth record found for account $ACCOUNT_ID, user $USER_ID"
        return 1
    else
        echo "✅ ZillowAuth record found:"
        echo "$auth_result" | while IFS=$'\t' read -r id account_id user_id zuid token_status zillow_sync_user_id created_at updated_at hours_since_update; do
            echo "   Record ID: $id"
            echo "   ZUID: $zuid"
            echo "   Token Status: $token_status"
            echo "   Associated ZillowSyncUser ID: ${zillow_sync_user_id:-'None'}"
            echo "   Created: $created_at"
            echo "   Last Updated: $updated_at ($hours_since_update hours ago)"

            if [[ "$hours_since_update" -gt 168 ]]; then  # 1 week
                echo "   ⚠️  Warning: Token not updated in over a week"
            elif [[ "$hours_since_update" -gt 24 ]]; then
                echo "   ℹ️  Note: Token last updated over 24 hours ago"
            fi
        done
        return 0
    fi
}

check_zillow_sync_user_status() {
    echo -e "\n=== ZillowSyncUser Analysis (Legacy OAuth System) ==="

    local sync_query="
        SELECT
            id,
            account_id,
            user_id,
            CASE WHEN zillow_integration_id IS NOT NULL THEN 1 ELSE 0 END as integration_enabled,
            lead_count,
            last_agent_sync_at,
            CASE WHEN problem_at IS NOT NULL THEN 'error' ELSE 'healthy' END as health_status,
            problem_msg,
            problem_at,
            created_at,
            last_verified_at
        FROM zillow_sync_users
        WHERE account_id = $ACCOUNT_ID AND user_id = $USER_ID;
    "

    local sync_result
    sync_result=$(safe_db_query "$sync_query")

    if [[ -z "$sync_result" ]]; then
        echo "❌ No ZillowSyncUser record found for account $ACCOUNT_ID, user $USER_ID"
        return 1
    else
        echo "✅ ZillowSyncUser record found:"
        echo "$sync_result" | while IFS=$'\t' read -r id account_id user_id enabled lead_count last_sync health_status problem_msg problem_at created_at last_verified; do
            echo "   Record ID: $id"
            echo "   Integration Enabled: $enabled"
            echo "   Lead Count: ${lead_count:-0}"
            echo "   Last Sync: ${last_sync:-'Never'}"
            echo "   Health Status: ${health_status:-'Unknown'}"

            if [[ -n "$problem_msg" && "$problem_msg" != "NULL" && -n "$problem_msg" ]]; then
                echo "   ⚠️  Problem Message: $problem_msg"
            fi

            if [[ -n "$problem_at" && "$problem_at" != "NULL" ]]; then
                echo "   ⚠️  Problems Detected At: $problem_at"
            fi

            echo "   Created: $created_at"
            echo "   Last Verified: ${last_verified:-'Never'}"
        done
        return 0
    fi
}

analyze_token_service_compatibility() {
    echo -e "\n=== Token Service Compatibility Analysis ==="

    # Check if both systems have records
    local auth_exists=$([[ $(check_zillow_auth_status >/dev/null 2>&1; echo $?) == 0 ]] && echo "true" || echo "false")
    local sync_exists=$([[ $(check_zillow_sync_user_status >/dev/null 2>&1; echo $?) == 0 ]] && echo "true" || echo "false")

    echo "Record Pattern Analysis:"
    if [[ "$auth_exists" == "true" && "$sync_exists" == "true" ]]; then
        echo "   ✅ Both Records Pattern: ZillowAuth + ZillowSyncUser"
        echo "   📋 Recommendation: Use ZillowTokenServiceV2 (supports both systems)"
        echo "   🔧 Service: ZillowTokenServiceV2 with backward compatibility"
    elif [[ "$auth_exists" == "true" && "$sync_exists" == "false" ]]; then
        echo "   🆕 Auth Only Pattern: Modern OAuth implementation"
        echo "   📋 Recommendation: Use ZillowTokenServiceV2 (modern path)"
        echo "   🔧 Service: ZillowTokenServiceV2 for ZillowAuth records"
    elif [[ "$auth_exists" == "false" && "$sync_exists" == "true" ]]; then
        echo "   📜 Sync Only Pattern: Legacy OAuth implementation"
        echo "   📋 Recommendation: Use ZillowTokenService OR ZillowTokenServiceV2"
        echo "   🔧 Service: Either service supports ZillowSyncUser records"
        echo "   💡 Migration Opportunity: Consider creating ZillowAuth record"
    else
        echo "   ❌ No Records Pattern: No OAuth connection found"
        echo "   📋 Recommendation: User must complete OAuth flow"
        echo "   🔧 Action Required: Redirect to OAuth authorization"
    fi
}

check_recent_oauth_activity() {
    echo -e "\n=== Recent OAuth Activity Correlation ==="

    echo "Checking for recent OAuth-related activity..."

    # Check for correlation between ZillowAuth and ZillowSyncUser records
    local correlation_query="
        SELECT
            za.id as auth_id,
            za.zillow_sync_user_id as linked_sync_id,
            zsu.id as sync_id,
            TIMESTAMPDIFF(MINUTE, za.updated_at, NOW()) as auth_minutes_ago,
            TIMESTAMPDIFF(MINUTE, COALESCE(zsu.last_verified_at, zsu.created_at), NOW()) as sync_minutes_ago
        FROM zillow_auth za
        LEFT JOIN zillow_sync_users zsu ON za.account_id = zsu.account_id AND za.user_id = zsu.user_id
        WHERE za.account_id = $ACCOUNT_ID AND za.user_id = $USER_ID;
    "

    local correlation_result
    correlation_result=$(safe_db_query "$correlation_query")

    if [[ -n "$correlation_result" ]]; then
        echo "✅ OAuth Records Correlation:"
        echo "$correlation_result" | while IFS=$'\t' read -r auth_id linked_sync_id sync_id auth_minutes sync_minutes; do
            echo "   ZillowAuth ID: $auth_id (updated ${auth_minutes:-'unknown'} minutes ago)"
            if [[ -n "$sync_id" && "$sync_id" != "NULL" ]]; then
                echo "   ZillowSyncUser ID: $sync_id (verified ${sync_minutes:-'unknown'} minutes ago)"
                if [[ -n "$linked_sync_id" && "$linked_sync_id" != "NULL" ]]; then
                    echo "   🔗 Records are linked (zillow_sync_user_id: $linked_sync_id)"
                else
                    echo "   ⚠️  Records exist but are not linked"
                fi
            else
                echo "   ℹ️  No corresponding ZillowSyncUser record"
            fi
        done
    else
        echo "ℹ️  No OAuth correlation data available"
    fi

    # Optional: Try to check ZillowAgent records if client database access is available
    echo -e "\n🔍 ZillowAgent Record Check:"
    if command -v mysql >/dev/null 2>&1; then
        echo "   💡 Client database queries available via direct MySQL connection"
        echo "   📋 Manual check: Query zillow_agents table in client_${ACCOUNT_ID} database"
        echo "   🔧 Resolution methods: 1=CONNECTED, 3=INFERRED, 4=UNMATCHED"
    else
        echo "   ℹ️  Client database access not configured for this environment"
        echo "   📋 Alternative: Check agent resolution via FUB admin interface"
    fi
}

generate_recommendations() {
    echo -e "\n=== Diagnostic Recommendations ==="

    local auth_exists=$([[ $(check_zillow_auth_status >/dev/null 2>&1; echo $?) == 0 ]] && echo "true" || echo "false")
    local sync_exists=$([[ $(check_zillow_sync_user_status >/dev/null 2>&1; echo $?) == 0 ]] && echo "true" || echo "false")

    echo "Next Steps:"

    if [[ "$auth_exists" == "false" && "$sync_exists" == "false" ]]; then
        echo "   1. 🚨 CRITICAL: User must re-authenticate via OAuth flow"
        echo "   2. 📍 OAuth URL: https://authv2.zillow.com (production)"
        echo "   3. 🔧 Integration: Verify Zillow Premier Agent integration is enabled"
        echo "   4. 📊 Monitor: Check for successful token creation after OAuth"
    elif [[ "$auth_exists" == "true" ]]; then
        echo "   1. ✅ Modern OAuth: ZillowAuth record present"
        echo "   2. 🔧 Service: Use ZillowTokenServiceV2 for token operations"
        echo "   3. 🧪 Test: Verify token refresh functionality"
        echo "   4. 📊 Monitor: Check for successful API calls with current token"
    else
        echo "   1. 📜 Legacy OAuth: ZillowSyncUser record present"
        echo "   2. 🔧 Service: Use ZillowTokenService or ZillowTokenServiceV2"
        echo "   3. 💡 Upgrade: Consider migrating to ZillowAuth for modern features"
        echo "   4. 🧪 Test: Verify legacy token refresh functionality"
    fi

    echo -e "\nDebugging Commands:"
    echo "   # Check token service logs"
    echo "   grep -i 'ZillowTokenService' /var/log/fub-api.log | tail -20"
    echo ""
    echo "   # Monitor OAuth cache operations"
    echo "   grep -i 'zillow.*token.*cache' /var/log/fub-api.log | tail -10"
    echo ""
    echo "   # Check for recent OAuth errors"
    echo "   grep -i 'ZillowConnectException' /var/log/fub-api.log | tail -5"
}

main() {
    echo "🔍 FUB OAuth Token Analysis"
    echo "Account ID: $ACCOUNT_ID, User ID: $USER_ID"
    echo "Timestamp: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
    echo "----------------------------------------"

    validate_inputs

    local auth_status=1
    local sync_status=1

    check_zillow_auth_status && auth_status=0 || auth_status=1
    check_zillow_sync_user_status && sync_status=0 || sync_status=1

    analyze_token_service_compatibility
    check_recent_oauth_activity
    generate_recommendations

    echo -e "\n----------------------------------------"
    echo "Analysis complete. For detailed troubleshooting, see:"
    echo "https://zillowgroup.atlassian.net/wiki/spaces/FUB/pages/1863421945/Zillow+sync+FAQ+Troubleshooting"
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi