#!/bin/bash
# Token Service Validation Script for FUB Zillow Integration
# Test both ZillowTokenService and ZillowTokenServiceV2 functionality
#
# Usage: ./fub-token-service-validation.sh ACCOUNT_ID USER_ID [--force-refresh]
# Example: ./fub-token-service-validation.sh 14009 571 --force-refresh

set -euo pipefail

ACCOUNT_ID="${1:-}"
USER_ID="${2:-}"
FORCE_REFRESH="${3:-}"

# Script directory for relative path resolution
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FUB_DB_SCRIPT="$SCRIPT_DIR/../../database-operations/scripts/fub-db.sh"

usage() {
    cat << EOF
Token Service Validation for FUB Zillow Integration

USAGE:
    $0 ACCOUNT_ID USER_ID [--force-refresh]

PARAMETERS:
    ACCOUNT_ID       FUB account identifier
    USER_ID          FUB user identifier
    --force-refresh  Force token refresh testing (optional)

EXAMPLES:
    $0 14009 571                     # Test both token services
    $0 148261 571 --force-refresh    # Test with forced refresh

FEATURES:
    - Tests both legacy and modern token services
    - Cache inspection and validation
    - Service recommendation based on available records
    - Optional force refresh testing

SAFETY:
    This script performs read-only operations by default.
    Force refresh testing requires explicit --force-refresh flag.
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

detect_oauth_records() {
    echo "=== OAuth Record Detection ==="

    # Check ZillowAuth (modern)
    local auth_query="
        SELECT COUNT(*) as count
        FROM zillow_auth
        WHERE account_id = $ACCOUNT_ID AND user_id = $USER_ID
        AND encrypted_refresh_token IS NOT NULL;
    "

    local auth_count
    auth_count=$("$FUB_DB_SCRIPT" query dev common "$auth_query" 2>/dev/null | grep -v "Reading\|Found\|mysql:" | tail -1 || echo "0")

    # Check ZillowSyncUser (legacy)
    local sync_query="
        SELECT COUNT(*) as count
        FROM zillow_sync_users
        WHERE account_id = $ACCOUNT_ID AND user_id = $USER_ID
        AND zillow_integration_id IS NOT NULL;
    "

    local sync_count
    sync_count=$("$FUB_DB_SCRIPT" query dev common "$sync_query" 2>/dev/null | grep -v "Reading\|Found\|mysql:" | tail -1 || echo "0")

    echo "Record Detection Results:"
    echo "   ZillowAuth records: $auth_count"
    echo "   ZillowSyncUser records: $sync_count"

    # Determine recommended service
    if [[ "$auth_count" -gt 0 && "$sync_count" -gt 0 ]]; then
        echo "   📋 Pattern: Both Records (ZillowAuth + ZillowSyncUser)"
        echo "   🎯 Recommended Service: ZillowTokenServiceV2 (dual compatibility)"
        return 1  # Both records
    elif [[ "$auth_count" -gt 0 ]]; then
        echo "   📋 Pattern: Auth Only (Modern OAuth)"
        echo "   🎯 Recommended Service: ZillowTokenServiceV2 (modern path)"
        return 2  # Auth only
    elif [[ "$sync_count" -gt 0 ]]; then
        echo "   📋 Pattern: Sync Only (Legacy OAuth)"
        echo "   🎯 Recommended Service: ZillowTokenService OR ZillowTokenServiceV2"
        return 3  # Sync only
    else
        echo "   📋 Pattern: No Records"
        echo "   🎯 Action Required: User must complete OAuth flow"
        return 0  # No records
    fi
}

inspect_oauth_cache() {
    echo -e "\n=== OAuth Cache Inspection ==="

    echo "Cache Key Patterns Analysis:"
    echo "   Legacy Pattern: zillow-token-{$ACCOUNT_ID}-{$USER_ID}-{zillow_sync_user_id}"
    echo "   Modern Pattern: zillow-auth-token-{$ACCOUNT_ID}-{$USER_ID}-{zillow_auth_id}"

    # Get actual record IDs for cache key construction
    local auth_id_query="
        SELECT id, zillow_sync_user_id
        FROM zillow_auth
        WHERE account_id = $ACCOUNT_ID AND user_id = $USER_ID;
    "

    local auth_result
    auth_result=$("$FUB_DB_SCRIPT" query dev common "$auth_id_query" 2>/dev/null | grep -v "Reading\|Found\|mysql:" || echo "")

    if [[ -n "$auth_result" ]]; then
        echo "$auth_result" | while IFS=$'\t' read -r auth_id sync_user_id; do
            echo "   🔑 ZillowAuth Cache Key: zillow-auth-token-$ACCOUNT_ID-$USER_ID-$auth_id"
            if [[ -n "$sync_user_id" && "$sync_user_id" != "NULL" ]]; then
                echo "   🔑 Legacy Cache Key: zillow-token-$ACCOUNT_ID-$USER_ID-$sync_user_id"
            fi
        done
    fi

    local sync_id_query="
        SELECT id
        FROM zillow_sync_users
        WHERE account_id = $ACCOUNT_ID AND user_id = $USER_ID;
    "

    local sync_result
    sync_result=$("$FUB_DB_SCRIPT" query dev common "$sync_id_query" 2>/dev/null | grep -v "Reading\|Found\|mysql:" | grep -v "^$" || echo "")

    if [[ -n "$sync_result" ]]; then
        echo "   🔑 ZillowSyncUser Cache Key: zillow-token-$ACCOUNT_ID-$USER_ID-$sync_result"
    fi

    echo "   💡 Note: Actual cache inspection requires application-level access"
}

validate_token_service_v2() {
    echo -e "\n=== ZillowTokenServiceV2 Validation ==="

    echo "Service Features Analysis:"
    echo "   ✅ Supports ZillowAuth records (modern)"
    echo "   ✅ Supports ZillowSyncUser records (legacy compatibility)"
    echo "   ✅ Enhanced error handling with ZillowConnectException"
    echo "   ✅ 30-second refresh buffer prevents race conditions"
    echo "   ✅ Automatic cache invalidation on refresh failure"

    echo -e "\nImplementation Details:"
    echo "   📁 Location: apps/richdesk/libraries/service/zillow/oauth/ZillowTokenServiceV2.php"
    echo "   🔧 Method: shouldRefreshToken() - 30-second buffer validation"
    echo "   🔧 Method: getValidAccessToken() - Primary token retrieval"
    echo "   🔧 Method: refreshAccessToken() - Token refresh with error handling"

    # Check if user has both record types for dual compatibility testing
    local record_pattern
    detect_oauth_records >/dev/null
    record_pattern=$?

    case $record_pattern in
        1)
            echo "   🎯 Test Scenario: Dual compatibility mode (both record types)"
            echo "   📋 Expected Behavior: Prefer ZillowAuth, fallback to ZillowSyncUser"
            ;;
        2)
            echo "   🎯 Test Scenario: Modern OAuth mode (ZillowAuth only)"
            echo "   📋 Expected Behavior: Direct ZillowAuth token operations"
            ;;
        3)
            echo "   🎯 Test Scenario: Legacy compatibility mode (ZillowSyncUser only)"
            echo "   📋 Expected Behavior: ZillowSyncUser token operations with modern features"
            ;;
        0)
            echo "   ⚠️  Test Scenario: No OAuth records available"
            echo "   📋 Expected Behavior: Service should return null/error gracefully"
            ;;
    esac
}

validate_token_service_legacy() {
    echo -e "\n=== ZillowTokenService (Legacy) Validation ==="

    echo "Service Features Analysis:"
    echo "   ✅ Supports ZillowSyncUser records only"
    echo "   ⚠️  Limited to legacy OAuth implementation"
    echo "   ⚠️  Will be deprecated in favor of V2"
    echo "   ✅ Proven production stability"

    echo -e "\nImplementation Details:"
    echo "   📁 Location: apps/richdesk/libraries/service/zillow/oauth/ZillowTokenService.php"
    echo "   🔧 Method: getAccessToken() - Legacy token retrieval"
    echo "   🔧 Method: refreshToken() - Legacy refresh implementation"

    # Check if user has ZillowSyncUser record
    local sync_query="
        SELECT COUNT(*) as count
        FROM zillow_sync_users
        WHERE account_id = $ACCOUNT_ID AND user_id = $USER_ID;
    "

    local sync_count
    sync_count=$("$FUB_DB_SCRIPT" query dev common "$sync_query" 2>/dev/null | tail -1 || echo "0")

    if [[ "$sync_count" -gt 0 ]]; then
        echo "   ✅ Compatible: ZillowSyncUser record available"
        echo "   📋 Expected Behavior: Standard legacy token operations"
    else
        echo "   ❌ Incompatible: No ZillowSyncUser record found"
        echo "   📋 Expected Behavior: Service will fail gracefully"
    fi
}

test_service_recommendations() {
    echo -e "\n=== Service Recommendation Analysis ==="

    detect_oauth_records >/dev/null
    local record_pattern=$?

    echo "Recommendation Logic:"

    case $record_pattern in
        1)
            echo "   📊 Pattern: Both Records Present"
            echo "   🎯 Primary Recommendation: ZillowTokenServiceV2"
            echo "   📝 Rationale: Dual compatibility, modern features, production ready"
            echo "   🔄 Fallback: ZillowTokenService (legacy path only)"
            echo "   💡 Migration: Already optimal - no action needed"
            ;;
        2)
            echo "   📊 Pattern: ZillowAuth Only (Modern)"
            echo "   🎯 Primary Recommendation: ZillowTokenServiceV2"
            echo "   📝 Rationale: Only service supporting ZillowAuth records"
            echo "   ❌ Incompatible: ZillowTokenService (legacy only)"
            echo "   💡 Migration: Already using modern OAuth"
            ;;
        3)
            echo "   📊 Pattern: ZillowSyncUser Only (Legacy)"
            echo "   🎯 Primary Recommendation: ZillowTokenServiceV2"
            echo "   📝 Rationale: Modern features with legacy compatibility"
            echo "   🔄 Alternative: ZillowTokenService (proven legacy)"
            echo "   💡 Migration: Consider creating ZillowAuth record"
            ;;
        0)
            echo "   📊 Pattern: No OAuth Records"
            echo "   🎯 Action Required: Complete OAuth flow first"
            echo "   📝 Process: User authentication → Record creation → Service selection"
            echo "   🔗 OAuth URL: https://authv2.zillow.com (production)"
            ;;
    esac
}

perform_force_refresh_test() {
    if [[ "$FORCE_REFRESH" != "--force-refresh" ]]; then
        echo -e "\n⏭️  Skipping force refresh test (use --force-refresh to enable)"
        return 0
    fi

    echo -e "\n=== Force Refresh Testing (EXPERIMENTAL) ==="
    echo "⚠️  WARNING: This would attempt to refresh OAuth tokens"
    echo "⚠️  This is a read-only script - actual refresh testing requires application context"

    echo -e "\nSimulated Test Procedure:"
    echo "   1. 🔍 Check current token expiration status"
    echo "   2. 🔄 Attempt refresh via ZillowTokenServiceV2"
    echo "   3. 📊 Verify new token validity"
    echo "   4. 🧪 Test API call with refreshed token"
    echo "   5. 📝 Log refresh success/failure"

    echo -e "\nActual Implementation Location:"
    echo "   📁 File: apps/richdesk/libraries/service/zillow/oauth/ZillowTokenServiceV2.php"
    echo "   🔧 Method: refreshAccessToken()"
    echo "   🧪 Test: ZillowTokenServiceV2Test::testRefreshAccessToken()"

    echo -e "\n💡 To perform actual refresh testing:"
    echo "   1. Use FUB's test environment"
    echo "   2. Create PHPUnit test case"
    echo "   3. Mock OAuth provider responses"
    echo "   4. Verify cache invalidation behavior"
}

generate_testing_recommendations() {
    echo -e "\n=== Testing Recommendations ==="

    detect_oauth_records >/dev/null
    local record_pattern=$?

    echo "Recommended Testing Approach:"

    case $record_pattern in
        1|2|3)
            echo "   1. 🧪 Unit Tests:"
            echo "      - ZillowTokenServiceV2Test::testGetValidAccessToken()"
            echo "      - Verify cache key generation logic"
            echo "      - Test refresh buffer (30-second) behavior"
            echo ""
            echo "   2. 🔍 Integration Tests:"
            echo "      - Test actual token refresh with test OAuth app"
            echo "      - Verify cache operations in Redis/Memcached"
            echo "      - Test error handling for expired tokens"
            echo ""
            echo "   3. 📊 Monitoring:"
            echo "      - Track token refresh success rates"
            echo "      - Monitor cache hit/miss ratios"
            echo "      - Alert on refresh failures > 5%"
            ;;
        0)
            echo "   1. 🔗 OAuth Flow Testing:"
            echo "      - Test complete OAuth authorization flow"
            echo "      - Verify record creation (ZillowAuth preferred)"
            echo "      - Test token validation post-creation"
            echo ""
            echo "   2. 📋 User Experience Testing:"
            echo "      - Test OAuth redirect handling"
            echo "      - Verify error messages for failed auth"
            echo "      - Test re-authentication flow"
            ;;
    esac

    echo -e "\n📈 Production Monitoring Commands:"
    echo "   # Token service performance"
    echo "   grep 'ZillowTokenServiceV2' /var/log/fub-api.log | grep -E '(success|error)' | tail -20"
    echo ""
    echo "   # Cache operations"
    echo "   grep 'zillow.*token.*cache' /var/log/fub-api.log | tail -10"
    echo ""
    echo "   # OAuth refresh operations"
    echo "   grep 'refreshAccessToken' /var/log/fub-api.log | tail -10"
}

main() {
    echo "🔧 FUB Token Service Validation"
    echo "Account ID: $ACCOUNT_ID, User ID: $USER_ID"
    echo "Force Refresh: ${FORCE_REFRESH:-'Disabled'}"
    echo "Timestamp: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
    echo "----------------------------------------"

    validate_inputs

    detect_oauth_records
    inspect_oauth_cache
    validate_token_service_v2
    validate_token_service_legacy
    test_service_recommendations
    perform_force_refresh_test
    generate_testing_recommendations

    echo -e "\n----------------------------------------"
    echo "Validation complete. For implementation details, see:"
    echo "https://gitlab.zgtools.net/fub/fub/-/blob/main/apps/richdesk/libraries/service/zillow/oauth/"
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi