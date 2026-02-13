#!/bin/bash

# Retry Integration Bridge
# Bridges existing MCP error recovery with user-specific retry requirements
# Provides compatibility between bash 3.2 and newer bash versions

# Set strict error handling
set -euo pipefail

# Get script directories
SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" && pwd)"

# Source the intelligent retry controller
if [[ -f "$SCRIPTS_DIR/intelligent-retry-controller.sh" ]]; then
    source "$SCRIPTS_DIR/intelligent-retry-controller.sh"
fi

# Source existing enhanced error recovery (if available and compatible)
if [[ -f "$HOME/.claude/skills/mcp-server-management/scripts/enhanced-error-recovery.sh" ]]; then
    # Check if bash version supports associative arrays
    if bash --version | grep -q "version [4-9]"; then
        source "$HOME/.claude/skills/mcp-server-management/scripts/enhanced-error-recovery.sh"
        ENHANCED_ERROR_RECOVERY_AVAILABLE=true
    else
        # For bash 3.2, provide compatibility functions
        ENHANCED_ERROR_RECOVERY_AVAILABLE=false
        log_info "Note: Using bash 3.2 compatibility mode for error classification"
    fi
else
    ENHANCED_ERROR_RECOVERY_AVAILABLE=false
fi

# Bash 3.2 compatible error classification fallback
classify_error_fallback() {
    local error_message="$1"

    # Check for SSH key errors first (user priority)
    if echo "$error_message" | grep -qiE "permission denied.*publickey|ssh.*key.*not.*found|agent has no identities"; then
        echo "ssh_key"
        return 0
    fi

    # Check for network timeouts (user priority)
    if echo "$error_message" | grep -qiE "connection timed out|network unreachable|timeout.*exceeded|read timeout"; then
        echo "timeout"
        return 0
    fi

    # Check for other common patterns
    if echo "$error_message" | grep -qiE "connection refused|ECONNREFUSED"; then
        echo "connection_refused"
    elif echo "$error_message" | grep -qiE "unauthorized|authentication failed|401|403"; then
        echo "authentication"
    elif echo "$error_message" | grep -qiE "rate limit|429|too many requests"; then
        echo "rate_limit"
    elif echo "$error_message" | grep -qiE "mcp.*error|server terminated|connection closed"; then
        echo "mcp_specific"
    elif echo "$error_message" | grep -qiE "not found|404|ENOTFOUND"; then
        echo "not_found"
    else
        echo "unknown"
    fi
}

# Unified error classification (uses enhanced if available, fallback otherwise)
classify_error_unified() {
    local error_message="$1"

    # First, try user-specific patterns from intelligent retry controller
    local user_error_type=$(classify_error_enhanced "$error_message" 2>/dev/null || echo "")

    if [[ -n "$user_error_type" && "$user_error_type" != "unknown" ]]; then
        echo "$user_error_type"
        return 0
    fi

    # Fall back to existing enhanced error recovery if available
    if [[ "$ENHANCED_ERROR_RECOVERY_AVAILABLE" == "true" ]] && command -v classify_error >/dev/null 2>&1; then
        classify_error "$error_message"
    else
        # Use bash 3.2 compatible fallback
        classify_error_fallback "$error_message"
    fi
}

# Smart retry dispatcher (chooses between user-specific and legacy retry)
execute_smart_retry() {
    local command="$1"
    local context="${2:-operation}"
    local skill_name="${3:-unknown}"

    # Check if this is a user-priority error type
    local test_output=$(eval "$command" 2>&1 || echo "test command failed")
    local error_type=$(classify_error_unified "$test_output")

    case "$error_type" in
        "ssh_key_immediate"|"network_timeout_30s")
            # Use user-specific retry logic for priority cases
            log_info "Using user-specific retry logic for: $error_type"
            execute_with_intelligent_retry "$command" "$context" "$skill_name"
            ;;
        *)
            # Use existing retry logic for other cases (if available)
            if [[ "$ENHANCED_ERROR_RECOVERY_AVAILABLE" == "true" ]] && command -v intelligent_retry >/dev/null 2>&1; then
                # But override to use user's 2-attempt limit
                intelligent_retry "$command" 2 "$context"
            else
                # Fall back to user-specific retry for compatibility
                execute_with_intelligent_retry "$command" "$context" "$skill_name"
            fi
            ;;
    esac
}

# Tool validation with integrated retry (replaces existing validate_tool)
validate_tool_integrated() {
    local tool_name="$1"
    local validate_auth="${2:-true}"
    local operation_context="${3:-general}"

    log_info "🔍 Integrated tool validation: $tool_name"

    # Use the retry-aware validation from intelligent retry controller
    if command -v validate_tool_with_retry >/dev/null 2>&1; then
        validate_tool_with_retry "$tool_name" "$validate_auth" "$operation_context"
    else
        log_warning "Retry-aware validation not available, using standard validation"
        return 1
    fi
}

# Enhanced MCP operation wrapper (integrates with existing mcp-resilience-utils)
execute_mcp_with_smart_retry() {
    local server_name="$1"
    local operation_command="$2"
    local fallback_command="${3:-}"
    local skill_name="${4:-unknown}"

    log_info "🔄 MCP operation with smart retry: $server_name"

    # Track session complexity if available
    if command -v /session-management >/dev/null 2>&1; then
        /session-management --operation=track-operation \
            --skill_name="$skill_name" \
            --tool_name="mcp_$server_name" \
            --context="retry_integration" >/dev/null 2>&1 || true
    fi

    # Try primary MCP operation with smart retry
    if execute_smart_retry "$operation_command" "$server_name operation" "$skill_name"; then
        log_success "✅ MCP operation succeeded: $server_name"
        return 0
    fi

    # If MCP fails, try fallback if provided
    if [[ -n "$fallback_command" ]]; then
        log_info "🔄 Trying fallback command for $server_name"
        if execute_smart_retry "$fallback_command" "$server_name fallback" "$skill_name"; then
            log_success "✅ Fallback operation succeeded: $server_name"
            return 0
        fi
    fi

    log_error "❌ Both MCP and fallback operations failed: $server_name"
    return 1
}

# Transparent retry wrapper (eliminates silent failures)
execute_transparently() {
    local command="$1"
    local context="${2:-operation}"
    local skill_name="${3:-unknown}"

    echo "🔄 Executing with transparent retry: $context"

    # No silent operations - always show what's happening
    execute_smart_retry "$command" "$context" "$skill_name"
}

# Export functions for use by other skills
export -f classify_error_unified
export -f execute_smart_retry
export -f validate_tool_integrated
export -f execute_mcp_with_smart_retry
export -f execute_transparently

# Status check function
check_retry_integration_status() {
    echo "🔧 Retry Integration Bridge Status"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Enhanced Error Recovery Available: $ENHANCED_ERROR_RECOVERY_AVAILABLE"
    echo "Bash Version: $(bash --version | head -1)"
    echo "User-Specific Retry Controller: $(if command -v execute_with_intelligent_retry >/dev/null 2>&1; then echo "Available"; else echo "Not Available"; fi)"
    echo "Session Management Integration: $(if command -v /session-management >/dev/null 2>&1; then echo "Available"; else echo "Not Available"; fi)"
    echo ""

    echo "Available Functions:"
    echo "  - execute_smart_retry           : Smart retry dispatcher"
    echo "  - validate_tool_integrated      : Integrated tool validation"
    echo "  - execute_mcp_with_smart_retry  : MCP operations with retry"
    echo "  - execute_transparently         : No silent failures"
    echo "  - classify_error_unified        : Unified error classification"
}

# Main function for direct script execution
main() {
    case "${1:-}" in
        "status")
            check_retry_integration_status
            ;;
        "test-integration")
            echo "Testing retry integration..."
            execute_smart_retry "echo 'Test command successful'" "integration test" "test-skill"
            ;;
        *)
            echo "Retry Integration Bridge loaded successfully"
            echo ""
            check_retry_integration_status
            echo ""
            echo "Usage:"
            echo "  $0 status           - Show integration status"
            echo "  $0 test-integration - Test integration functionality"
            ;;
    esac
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]:-}" == "${0:-}" ]]; then
    main "$@"
fi