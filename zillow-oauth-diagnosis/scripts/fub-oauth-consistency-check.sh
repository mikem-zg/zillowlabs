#!/bin/bash
# OAuth Consistency Check Script for FUB Zillow Integration
# Cross-validate zillow_auth and zillow_sync_users table consistency
#
# Usage:
#   ./fub-oauth-consistency-check.sh ACCOUNT_ID [USER_ID]  # Single user or account-wide
# Examples:
#   ./fub-oauth-consistency-check.sh 148261 571          # Single user analysis
#   ./fub-oauth-consistency-check.sh 148261              # Account-wide analysis

set -euo pipefail

ACCOUNT_ID="${1:-}"
USER_ID="${2:-}"

# Script directory for relative path resolution
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FUB_DB_SCRIPT="$SCRIPT_DIR/../../database-operations/scripts/fub-db.sh"

usage() {
    cat << EOF
OAuth Consistency Check for FUB Zillow Integration

USAGE:
    $0 ACCOUNT_ID [USER_ID]

PARAMETERS:
    ACCOUNT_ID    FUB account identifier
    USER_ID       FUB user identifier (optional - if omitted, analyzes entire account)

EXAMPLES:
    $0 148261 571    # Single user consistency analysis
    $0 148261        # Account-wide consistency analysis

ANALYSIS:
    - Record pattern identification (Both Records, Auth Only, Sync Only)
    - ZUID consistency validation
    - Migration priority recommendations
    - Token health distribution
EOF
}

validate_inputs() {
    if [[ -z "$ACCOUNT_ID" ]]; then
        echo "❌ Error: ACCOUNT_ID is required"
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

    if [[ ! -x "$FUB_DB_SCRIPT" ]]; then
        echo "❌ Error: fub-db.sh not found at $FUB_DB_SCRIPT"
        echo "   Please ensure database-operations skill is available"
        exit 1
    fi
}

analyze_record_patterns() {
    echo "=== Record Pattern Analysis ==="

    local where_clause=""
    if [[ -n "$USER_ID" ]]; then
        where_clause="AND za.user_id = $USER_ID"
        echo "Scope: Single user ($USER_ID) in account $ACCOUNT_ID"
    else
        echo "Scope: Account-wide analysis ($ACCOUNT_ID)"
    fi

    # Comprehensive pattern analysis query
    local pattern_query="
        SELECT
            'Both Records' as pattern_type,
            COUNT(*) as count,
            ROUND(AVG(TIMESTAMPDIFF(DAY, za.created_at, NOW())), 1) as avg_age_days
        FROM zillow_auth za
        INNER JOIN zillow_sync_users zsu ON za.account_id = zsu.account_id AND za.user_id = zsu.user_id
        WHERE za.account_id = $ACCOUNT_ID $where_clause

        UNION ALL

        SELECT
            'Auth Only' as pattern_type,
            COUNT(*) as count,
            ROUND(AVG(TIMESTAMPDIFF(DAY, za.created_at, NOW())), 1) as avg_age_days
        FROM zillow_auth za
        LEFT JOIN zillow_sync_users zsu ON za.account_id = zsu.account_id AND za.user_id = zsu.user_id
        WHERE za.account_id = $ACCOUNT_ID AND zsu.id IS NULL $where_clause

        UNION ALL

        SELECT
            'Sync Only' as pattern_type,
            COUNT(*) as count,
            ROUND(AVG(TIMESTAMPDIFF(DAY, zsu.created_at, NOW())), 1) as avg_age_days
        FROM zillow_sync_users zsu
        LEFT JOIN zillow_auth za ON zsu.account_id = za.account_id AND zsu.user_id = za.user_id
        WHERE zsu.account_id = $ACCOUNT_ID AND za.id IS NULL $where_clause

        UNION ALL

        SELECT
            'No Records' as pattern_type,
            0 as count,
            NULL as avg_age_days;
    "

    echo "Pattern Distribution:"
    local pattern_result
    pattern_result=$("$FUB_DB_SCRIPT" query dev common "$pattern_query" 2>/dev/null | grep -v "Reading\|Found\|mysql:" | grep -v "^$" || echo "ERROR")

    if [[ "$pattern_result" == "ERROR" || -z "$pattern_result" ]]; then
        echo "❌ Error querying record patterns"
        return 1
    fi

    echo "$pattern_result" | while IFS=$'\t' read -r pattern_type count avg_age; do
        if [[ "$count" -gt 0 ]]; then
            echo "   📊 $pattern_type: $count records (avg age: ${avg_age:-'N/A'} days)"
        fi
    done
}

check_zuid_consistency() {
    echo -e "\n=== ZUID Consistency Validation ==="

    local where_clause=""
    if [[ -n "$USER_ID" ]]; then
        where_clause="AND za.user_id = $USER_ID"
    fi

    # Check for ZUID mismatches between systems
    local zuid_query="
        SELECT
            za.user_id,
            za.zuid as auth_zuid,
            zsu.zuid as sync_zuid,
            CASE
                WHEN za.zuid = zsu.zuid THEN 'MATCH'
                WHEN za.zuid IS NOT NULL AND zsu.zuid IS NOT NULL THEN 'MISMATCH'
                WHEN za.zuid IS NULL THEN 'AUTH_MISSING'
                WHEN zsu.zuid IS NULL THEN 'SYNC_MISSING'
                ELSE 'UNKNOWN'
            END as consistency_status,
            za.created_at as auth_created,
            zsu.created_at as sync_created
        FROM zillow_auth za
        INNER JOIN zillow_sync_users zsu ON za.account_id = zsu.account_id AND za.user_id = zsu.user_id
        WHERE za.account_id = $ACCOUNT_ID $where_clause
        ORDER BY consistency_status, za.user_id;
    "

    echo "ZUID Consistency Check:"
    local zuid_result
    zuid_result=$("$FUB_DB_SCRIPT" query dev common "$zuid_query" 2>/dev/null | grep -v "Reading\|Found\|mysql:" | grep -v "^$" || echo "")

    if [[ -n "$zuid_result" ]]; then
        local match_count=0
        local mismatch_count=0
        local missing_count=0

        echo "$zuid_result" | while IFS=$'\t' read -r user_id auth_zuid sync_zuid status auth_created sync_created; do
            case "$status" in
                "MATCH")
                    echo "   ✅ User $user_id: ZUID $auth_zuid (consistent)"
                    ((match_count++)) || true
                    ;;
                "MISMATCH")
                    echo "   ⚠️  User $user_id: Auth ZUID $auth_zuid ≠ Sync ZUID $sync_zuid"
                    ((mismatch_count++)) || true
                    ;;
                "AUTH_MISSING")
                    echo "   🔍 User $user_id: ZillowAuth missing ZUID (sync has $sync_zuid)"
                    ((missing_count++)) || true
                    ;;
                "SYNC_MISSING")
                    echo "   🔍 User $user_id: ZillowSyncUser missing ZUID (auth has $auth_zuid)"
                    ((missing_count++)) || true
                    ;;
            esac
        done

        # Summary statistics (run in main shell, not subshell)
        local match_count=$(echo "$zuid_result" | grep -c "MATCH" || echo "0")
        local mismatch_count=$(echo "$zuid_result" | grep -c "MISMATCH" || echo "0")
        local missing_count=$(echo "$zuid_result" | grep -cE "(AUTH_MISSING|SYNC_MISSING)" || echo "0")

        echo -e "\nZUID Consistency Summary:"
        echo "   ✅ Matching ZUIDs: $match_count"
        echo "   ⚠️  Mismatched ZUIDs: $mismatch_count"
        echo "   🔍 Missing ZUIDs: $missing_count"

        if [[ "$mismatch_count" -gt 0 ]]; then
            echo "   🚨 Action Required: Investigate ZUID mismatches"
        fi
    else
        echo "   ℹ️  No overlapping records found (Both Records pattern)"
    fi
}

analyze_token_health() {
    echo -e "\n=== Token Health Distribution ==="

    local where_clause=""
    if [[ -n "$USER_ID" ]]; then
        where_clause="AND user_id = $USER_ID"
    fi

    # ZillowAuth token health
    local auth_health_query="
        SELECT
            CASE
                WHEN encrypted_refresh_token IS NOT NULL THEN 'HEALTHY'
                ELSE 'NO_TOKEN'
            END as token_status,
            COUNT(*) as count,
            ROUND(AVG(TIMESTAMPDIFF(HOUR, updated_at, NOW())), 1) as avg_hours_since_update
        FROM zillow_auth
        WHERE account_id = $ACCOUNT_ID $where_clause
        GROUP BY token_status;
    "

    echo "ZillowAuth Token Health:"
    local auth_health_result
    auth_health_result=$("$FUB_DB_SCRIPT" query dev common "$auth_health_query" 2>/dev/null | grep -v "Reading\|Found\|mysql:" | grep -v "^$" || echo "")

    if [[ -n "$auth_health_result" ]]; then
        echo "$auth_health_result" | while IFS=$'\t' read -r status count avg_hours; do
            echo "   📊 $status: $count records (avg ${avg_hours} hours since update)"
        done
    else
        echo "   ℹ️  No ZillowAuth records found"
    fi

    # ZillowSyncUser connection health
    local sync_health_query="
        SELECT
            CASE
                WHEN zillow_integration_id IS NOT NULL AND problem_at IS NULL THEN 'HEALTHY'
                WHEN zillow_integration_id IS NOT NULL AND problem_at IS NOT NULL THEN 'ERROR'
                WHEN zillow_integration_id IS NULL THEN 'DISABLED'
                ELSE 'UNKNOWN'
            END as health_status,
            COUNT(*) as count,
            ROUND(AVG(CASE WHEN last_agent_sync_at IS NOT NULL THEN TIMESTAMPDIFF(HOUR, last_agent_sync_at, NOW()) ELSE NULL END), 1) as avg_hours_since_sync
        FROM zillow_sync_users
        WHERE account_id = $ACCOUNT_ID $where_clause
        GROUP BY health_status;
    "

    echo -e "\nZillowSyncUser Connection Health:"
    local sync_health_result
    sync_health_result=$("$FUB_DB_SCRIPT" query dev common "$sync_health_query" 2>/dev/null | grep -v "Reading\|Found\|mysql:" | grep -v "^$" || echo "")

    if [[ -n "$sync_health_result" ]]; then
        echo "$sync_health_result" | while IFS=$'\t' read -r status count avg_hours; do
            echo "   📊 $status: $count records (avg ${avg_hours:-'N/A'} hours since sync)"
        done
    else
        echo "   ℹ️  No ZillowSyncUser records found"
    fi
}

generate_migration_priorities() {
    echo -e "\n=== Migration Priority Recommendations ==="

    local where_clause=""
    if [[ -n "$USER_ID" ]]; then
        where_clause="AND zsu.user_id = $USER_ID"
        echo "User-Specific Recommendations:"
    else
        echo "Account-Wide Migration Priorities:"
    fi

    # Identify high-priority migration candidates
    local migration_query="
        SELECT
            zsu.user_id,
            CASE WHEN zsu.zillow_integration_id IS NOT NULL THEN 1 ELSE 0 END as integration_enabled,
            CASE WHEN zsu.problem_at IS NULL THEN 'healthy' ELSE 'error' END as health_status,
            zsu.lead_count,
            TIMESTAMPDIFF(DAY, zsu.last_agent_sync_at, NOW()) as days_since_sync,
            CASE
                WHEN zsu.zillow_integration_id IS NOT NULL AND zsu.lead_count > 10 AND zsu.problem_at IS NULL THEN 'HIGH'
                WHEN zsu.zillow_integration_id IS NOT NULL AND zsu.lead_count > 0 THEN 'MEDIUM'
                WHEN zsu.zillow_integration_id IS NOT NULL THEN 'LOW'
                ELSE 'SKIP'
            END as migration_priority
        FROM zillow_sync_users zsu
        LEFT JOIN zillow_auth za ON zsu.account_id = za.account_id AND zsu.user_id = za.user_id
        WHERE zsu.account_id = $ACCOUNT_ID
        AND za.id IS NULL  -- Only users without ZillowAuth records
        $where_clause
        ORDER BY migration_priority DESC, zsu.lead_count DESC;
    "

    local migration_result
    migration_result=$("$FUB_DB_SCRIPT" query dev common "$migration_query" 2>/dev/null | grep -v "Reading\|Found\|mysql:" | grep -v "^$" || echo "")

    if [[ -n "$migration_result" ]]; then
        echo -e "\nMigration Candidates (ZillowSyncUser → ZillowAuth):"

        local high_count=0
        local medium_count=0
        local low_count=0

        echo "$migration_result" | while IFS=$'\t' read -r user_id enabled health lead_count days_since_sync priority; do
            case "$priority" in
                "HIGH")
                    echo "   🔴 HIGH: User $user_id (${lead_count} leads, ${days_since_sync:-'N/A'} days since sync)"
                    ;;
                "MEDIUM")
                    echo "   🟡 MEDIUM: User $user_id (${lead_count} leads, ${days_since_sync:-'N/A'} days since sync)"
                    ;;
                "LOW")
                    echo "   🟢 LOW: User $user_id (${lead_count} leads, ${days_since_sync:-'N/A'} days since sync)"
                    ;;
            esac
        done

        # Priority distribution
        local high_count=$(echo "$migration_result" | grep -c "HIGH" || echo "0")
        local medium_count=$(echo "$migration_result" | grep -c "MEDIUM" || echo "0")
        local low_count=$(echo "$migration_result" | grep -c "LOW" || echo "0")

        echo -e "\nMigration Priority Distribution:"
        echo "   🔴 High Priority: $high_count users"
        echo "   🟡 Medium Priority: $medium_count users"
        echo "   🟢 Low Priority: $low_count users"

    else
        echo "   ✅ All eligible users already have ZillowAuth records"
    fi
}

check_integration_enablement_consistency() {
    echo -e "\n=== Integration Enablement Consistency ==="

    local where_clause=""
    if [[ -n "$USER_ID" ]]; then
        where_clause="AND za.user_id = $USER_ID"
    fi

    # Check for misalignment between OAuth presence and integration enablement
    local enablement_query="
        SELECT
            za.user_id,
            CASE WHEN za.encrypted_refresh_token IS NOT NULL THEN 'HAS_TOKEN' ELSE 'NO_TOKEN' END as auth_status,
            COALESCE(zsu.zillow_integration_enabled, 0) as sync_enabled,
            COALESCE(zsu.connection_health_status, 'no_record') as health_status,
            za.created_at as auth_created,
            zsu.created_at as sync_created
        FROM zillow_auth za
        LEFT JOIN zillow_sync_users zsu ON za.account_id = zsu.account_id AND za.user_id = zsu.user_id
        WHERE za.account_id = $ACCOUNT_ID $where_clause

        UNION ALL

        SELECT
            zsu.user_id,
            'NO_AUTH_RECORD' as auth_status,
            zsu.zillow_integration_enabled as sync_enabled,
            zsu.connection_health_status as health_status,
            NULL as auth_created,
            zsu.created_at as sync_created
        FROM zillow_sync_users zsu
        LEFT JOIN zillow_auth za ON zsu.account_id = za.account_id AND zsu.user_id = za.user_id
        WHERE zsu.account_id = $ACCOUNT_ID AND za.id IS NULL $where_clause

        ORDER BY user_id;
    "

    echo "Integration Enablement Analysis:"
    local enablement_result
    enablement_result=$("$FUB_DB_SCRIPT" query dev common "$enablement_query" 2>/dev/null | grep -v "Reading\|Found\|mysql:" | grep -v "^$" || echo "")

    if [[ -n "$enablement_result" ]]; then
        echo "$enablement_result" | while IFS=$'\t' read -r user_id auth_status sync_enabled health_status auth_created sync_created; do
            case "$auth_status-$sync_enabled" in
                "HAS_TOKEN-1")
                    echo "   ✅ User $user_id: Consistent (OAuth + Integration enabled)"
                    ;;
                "HAS_TOKEN-0")
                    echo "   ⚠️  User $user_id: Has OAuth token but integration disabled"
                    ;;
                "NO_TOKEN-1")
                    echo "   🚨 User $user_id: Integration enabled but no OAuth token"
                    ;;
                "NO_AUTH_RECORD-1")
                    echo "   📜 User $user_id: Legacy setup (ZillowSyncUser only, enabled)"
                    ;;
                "NO_TOKEN-0"|"NO_AUTH_RECORD-0")
                    echo "   ℹ️  User $user_id: Correctly disabled"
                    ;;
            esac
        done
    fi
}

generate_consistency_summary() {
    echo -e "\n=== Consistency Summary & Action Items ==="

    local scope_desc="account $ACCOUNT_ID"
    if [[ -n "$USER_ID" ]]; then
        scope_desc="user $USER_ID in account $ACCOUNT_ID"
    fi

    echo "Analysis Scope: $scope_desc"
    echo "Timestamp: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"

    echo -e "\nRecommended Actions:"

    # Check if we have any inconsistencies by running simplified checks
    local has_mismatches=false
    local has_missing_auth=false
    local has_disabled_with_token=false

    # Simple check for common issues
    if "$FUB_DB_SCRIPT" query dev common "
        SELECT COUNT(*) FROM zillow_auth za
        INNER JOIN zillow_sync_users zsu ON za.account_id = zsu.account_id AND za.user_id = zsu.user_id
        WHERE za.account_id = $ACCOUNT_ID AND za.zuid != zsu.zuid
        ${USER_ID:+AND za.user_id = $USER_ID}
    " 2>/dev/null | grep -v "Reading\|Found\|mysql:" | grep -q "^[1-9]"; then
        has_mismatches=true
    fi

    if "$FUB_DB_SCRIPT" query dev common "
        SELECT COUNT(*) FROM zillow_sync_users zsu
        LEFT JOIN zillow_auth za ON zsu.account_id = za.account_id AND zsu.user_id = za.user_id
        WHERE zsu.account_id = $ACCOUNT_ID AND za.id IS NULL AND zsu.zillow_integration_id IS NOT NULL
        ${USER_ID:+AND zsu.user_id = $USER_ID}
    " 2>/dev/null | grep -v "Reading\|Found\|mysql:" | grep -q "^[1-9]"; then
        has_missing_auth=true
    fi

    if [[ "$has_mismatches" == "true" ]]; then
        echo "   🚨 CRITICAL: Investigate ZUID mismatches"
        echo "      - Check for duplicate OAuth flows"
        echo "      - Verify identity resolution accuracy"
    fi

    if [[ "$has_missing_auth" == "true" ]]; then
        echo "   📈 OPPORTUNITY: Migrate ZillowSyncUser → ZillowAuth"
        echo "      - Use migration priority recommendations above"
        echo "      - Test with low-priority users first"
    fi

    echo "   📊 MONITOR: Set up consistency monitoring"
    echo "      - Weekly consistency checks"
    echo "      - Alert on new ZUID mismatches"
    echo "      - Track migration progress"

    echo -e "\nMonitoring Queries:"
    echo "   # Daily consistency check"
    echo "   $(basename "$0") $ACCOUNT_ID"
    echo ""
    echo "   # ZUID mismatch detection"
    echo "   grep -i 'zuid.*mismatch' /var/log/fub-api.log"
    echo ""
    echo "   # OAuth record creation monitoring"
    echo "   grep -i 'ZillowAuth.*created' /var/log/fub-api.log | tail -10"
}

main() {
    echo "🔍 FUB OAuth Consistency Check"
    local scope_desc="Account $ACCOUNT_ID"
    if [[ -n "$USER_ID" ]]; then
        scope_desc="User $USER_ID in Account $ACCOUNT_ID"
    fi
    echo "Scope: $scope_desc"
    echo "Timestamp: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
    echo "----------------------------------------"

    validate_inputs

    analyze_record_patterns
    check_zuid_consistency
    analyze_token_health
    generate_migration_priorities
    check_integration_enablement_consistency
    generate_consistency_summary

    echo -e "\n----------------------------------------"
    echo "Consistency check complete. For OAuth troubleshooting, see:"
    echo "https://zillowgroup.atlassian.net/wiki/spaces/FUB/pages/1863421945/Zillow+sync+FAQ+Troubleshooting"
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi