#!/bin/bash

# Intelligent Retry Controller - User-Specific Requirements Implementation
# Enhanced error handling with specific behaviors:
# - SSH key errors: immediate user prompt for key addition
# - Network timeouts: 30-second wait with user notification before retry
# - 2-attempt threshold: escalate to user with alternative approaches
# - No silent retries: always inform user of retry attempts
# Enhanced with Remote Connectivity Management Skill integration for VPN conflict detection

# Set strict error handling
set -euo pipefail

# Get the directory where this script is located
SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" && pwd)"
source "$SCRIPTS_DIR/tool-utils.sh"

# Try to integrate with Remote Connectivity Management Skill for enhanced SSH/VPN handling
CONNECTIVITY_SKILL_AVAILABLE=false
if [[ -f "$SCRIPTS_DIR/../../remote-connectivity-management/integration/skill-bridge.sh" ]]; then
    # Temporarily disable strict mode for sourcing
    set +e
    source "$SCRIPTS_DIR/../../remote-connectivity-management/integration/skill-bridge.sh" 2>/dev/null
    if [[ $? -eq 0 ]] && command -v validate_ssh_with_vpn_check >/dev/null 2>&1; then
        CONNECTIVITY_SKILL_AVAILABLE=true
        log_info "Enhanced retry controller with Remote Connectivity Management Skill"
    fi
    set -e
fi

# Source enhanced error recovery for error classification (fallback)
if [[ -f "$HOME/.claude/skills/mcp-server-management/scripts/enhanced-error-recovery.sh" ]]; then
    source "$HOME/.claude/skills/mcp-server-management/scripts/enhanced-error-recovery.sh"
fi

# User-specific retry configuration
USER_MAX_ATTEMPTS=2  # User requirement: 2-attempt threshold
USER_NETWORK_WAIT=30  # User requirement: 30-second wait for network timeouts

# Enhanced error patterns for user-specific requirements (bash 3.2 compatible)
get_error_pattern() {
    case "$1" in
        "ssh_key_immediate")
            echo "permission denied \(publickey\)|ssh.*key.*not.*found|agent has no identities|public key.*denied"
            ;;
        "network_timeout_30s")
            echo "connection timed out|network unreachable|timeout.*exceeded|read timeout|connection reset"
            ;;
        "mcp_connection_failure")
            echo "mcp.*connection.*failed|server.*terminated|connection.*closed"
            ;;
        "authentication_expired")
            echo "token.*expired|session.*invalid|401.*unauthorized"
            ;;
        "rate_limit_backoff")
            echo "rate.*limit|429|too many requests|quota exceeded"
            ;;
    esac
}

# Main intelligent retry function matching user requirements
execute_with_intelligent_retry() {
    local command="$1"
    local context="${2:-operation}"
    local skill_name="${3:-unknown}"
    local max_attempts="$USER_MAX_ATTEMPTS"  # User requirement: 2-attempt threshold

    log_info "🔄 Starting intelligent retry for: $context"

    for attempt in $(seq 1 $max_attempts); do
        echo "🔄 Attempt $attempt/$max_attempts: $context"

        # Execute with error capture (no silent failures)
        local output
        local exit_code
        output=$(eval "$command" 2>&1)
        exit_code=$?

        if [[ $exit_code -eq 0 ]]; then
            log_success "✅ Operation successful on attempt $attempt"

            # Track successful retry in session if session-management is available
            if command -v /session-management >/dev/null 2>&1; then
                /session-management --operation=track-operation \
                    --skill_name="$skill_name" \
                    --tool_name="retry_success" \
                    --context="$context" >/dev/null 2>&1 || true
            fi

            return 0
        fi

        # Classify error and apply specific handling
        local error_type=$(classify_error_enhanced "$output")
        log_warning "❌ Attempt $attempt failed with error class: $error_type"

        # Track retry attempt in session complexity if available
        if command -v /session-management >/dev/null 2>&1; then
            /session-management --operation=track-operation \
                --skill_name="$skill_name" \
                --tool_name="retry_attempt" \
                --context="$error_type" >/dev/null 2>&1 || true
        fi

        if [[ $attempt -lt $max_attempts ]]; then
            handle_error_with_user_notification "$error_type" "$output" "$attempt" "$context"
        else
            escalate_with_alternatives "$error_type" "$output" "$command" "$context"
            return 1
        fi
    done
}

# Enhanced error classification for user requirements
classify_error_enhanced() {
    local error_message="$1"

    # Check user-specific patterns first
    for error_type in "ssh_key_immediate" "network_timeout_30s" "mcp_connection_failure" "authentication_expired" "rate_limit_backoff"; do
        local pattern=$(get_error_pattern "$error_type")
        if [[ "$error_message" =~ $pattern ]]; then
            echo "$error_type"
            return 0
        fi
    done

    # Fall back to existing classification if available
    if command -v classify_error >/dev/null 2>&1; then
        classify_error "$error_message"
    else
        echo "unknown"
    fi
}

# Enhanced error handling for user requirements
handle_error_with_user_notification() {
    local error_type="$1"
    local error_output="$2"
    local attempt="$3"
    local context="$4"

    case "$error_type" in
        "ssh_key_immediate")
            # User requirement: immediate prompt for SSH key addition
            handle_ssh_key_immediate_prompt "$error_output" "$context"
            ;;
        "network_timeout_30s")
            # User requirement: 30s wait with user notification
            handle_network_timeout_30s "$attempt" "$context"
            ;;
        "mcp_connection_failure")
            # MCP-specific retry with standard wait
            handle_mcp_connection_failure "$error_output" "$attempt" "$context"
            ;;
        "authentication_expired")
            # Authentication retry with credential refresh guidance
            handle_authentication_failure "$error_output" "$attempt" "$context"
            ;;
        "rate_limit_backoff")
            # Rate limiting with respectful backoff
            handle_rate_limit_backoff "$attempt" "$context"
            ;;
        *)
            # Standard retry with user notification (no silent retries)
            echo "❌ Operation failed: $error_type"
            echo "🔄 Retrying in 30 seconds..."
            sleep 30
            ;;
    esac
}

# SSH Key immediate prompt handler (Enhanced with Remote Connectivity Management Skill)
handle_ssh_key_immediate_prompt() {
    local error_details="$1"
    local context="$2"

    echo ""
    echo "🔑 Enhanced SSH Key Error Resolution"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Context: $context"
    echo "Error Details: $error_details"
    echo ""

    # Use Remote Connectivity Management Skill if available
    if [[ "$CONNECTIVITY_SKILL_AVAILABLE" == "true" ]]; then
        echo "Enhanced SSH troubleshooting options:"
        echo "1. Interactive SSH troubleshooting: claude /remote-connectivity-management --operation=troubleshoot --interactive=true"
        echo "2. Quick SSH key check: claude /remote-connectivity-management --operation=key-check"
        echo "3. Manual SSH key loading (continue below)"
        echo ""
        echo "Choose option or press Enter to continue with manual resolution..."
        read -t 10 -p "" || true  # 10-second timeout for enhanced options
        echo ""

        # Try enhanced SSH recovery first
        if command -v apply_ssh_key_recovery >/dev/null 2>&1; then
            echo "Attempting enhanced SSH recovery..."
            if apply_ssh_key_recovery ""; then
                log_success "✅ Enhanced SSH recovery successful"
                return 0
            else
                echo "Enhanced recovery partially successful, manual confirmation needed"
            fi
        fi
    fi

    # Fallback to manual resolution (preserves user requirements)
    echo "Manual SSH key resolution:"
    echo "1. Add existing key: ssh-add ~/.ssh/id_rsa"
    echo "2. Generate new key: ssh-keygen -t ed25519 -C 'your.email@domain.com'"
    echo "3. Copy public key to service (GitHub/GitLab/etc.)"
    echo ""

    # Wait for user confirmation before proceeding (no timeout - user control)
    read -p "Press Enter after resolving SSH key issue (or Ctrl+C to abort)..."

    # Enhanced key validation if skill available
    if [[ "$CONNECTIVITY_SKILL_AVAILABLE" == "true" ]] && command -v ssh_validate_keys >/dev/null 2>&1; then
        if ssh_validate_keys >/dev/null 2>&1; then
            log_success "✅ SSH keys validated, proceeding with retry"
        else
            log_warning "⚠️ SSH key validation failed, but proceeding as requested"
        fi
    else
        # Fallback verification
        if ssh-add -l >/dev/null 2>&1; then
            log_success "✅ SSH keys detected, proceeding with retry"
        else
            log_warning "⚠️ No SSH keys found, but proceeding as requested"
        fi
    fi
    echo ""
}

# Network timeout handler (Enhanced with VPN conflict detection, preserves user requirement: 30s wait)
handle_network_timeout_30s() {
    local attempt="$1"
    local context="$2"

    echo ""
    echo "🌐 Enhanced Network Timeout Analysis"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Context: $context"
    echo "Attempt: $attempt/$USER_MAX_ATTEMPTS"
    echo ""

    # Enhanced network analysis if skill available
    if [[ "$CONNECTIVITY_SKILL_AVAILABLE" == "true" ]]; then
        echo "Running enhanced network diagnostics..."

        # Check for VPN conflicts
        if command -v detect_cisco_vpn_conflict >/dev/null 2>&1 && detect_cisco_vpn_conflict; then
            echo "⚠️ VPN Conflict Detected!"
            echo ""
            echo "This timeout may be caused by VPN routing conflicts."
            echo "Quick resolution options:"
            echo "1. Run VPN analysis: claude /remote-connectivity-management --operation=cisco-conflict-detect"
            echo "2. Check VPN status: claude /remote-connectivity-management --operation=vpn-status"
            echo ""
            read -t 15 -p "Press Enter to continue with 30s wait, or Ctrl+C to resolve VPN conflicts first..." || true
            echo ""
        fi

        # Quick connectivity check
        if command -v test_internet_connectivity >/dev/null 2>&1; then
            if ! test_internet_connectivity >/dev/null 2>&1; then
                echo "❌ Internet connectivity issues detected"
                echo "This may require more than a 30-second wait to resolve."
                echo ""
            fi
        fi
    fi

    echo "Waiting ${USER_NETWORK_WAIT} seconds due to network connectivity issues..."
    echo "This allows temporary network issues to resolve."
    echo ""

    # 30-second countdown with user feedback (transparent, not silent)
    for i in $(seq $USER_NETWORK_WAIT -1 1); do
        echo -ne "⏳ Retrying in ${i}s...\\r"
        sleep 1
    done
    echo "                    \\r"  # Clear countdown line

    echo "🔄 Proceeding with retry attempt"
    echo ""
}

# MCP connection failure handler
handle_mcp_connection_failure() {
    local error_output="$1"
    local attempt="$2"
    local context="$3"

    echo ""
    echo "🔌 MCP Connection Failure"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Context: $context"
    echo "Attempt: $attempt/$USER_MAX_ATTEMPTS"
    echo ""
    echo "MCP server appears unavailable. Waiting 30 seconds for recovery..."

    sleep 30
    echo "🔄 Attempting MCP reconnection"
    echo ""
}

# Authentication failure handler
handle_authentication_failure() {
    local error_output="$1"
    local attempt="$2"
    local context="$3"

    echo ""
    echo "🔐 Authentication Failure"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Context: $context"
    echo "Attempt: $attempt/$USER_MAX_ATTEMPTS"
    echo ""
    echo "Authentication may have expired. Waiting 15 seconds before retry..."
    echo "Consider refreshing credentials if issue persists."

    sleep 15
    echo "🔄 Retrying with current credentials"
    echo ""
}

# Rate limit backoff handler
handle_rate_limit_backoff() {
    local attempt="$1"
    local context="$2"

    echo ""
    echo "⏱️ Rate Limit Detected"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Context: $context"
    echo "Attempt: $attempt/$USER_MAX_ATTEMPTS"
    echo ""
    echo "API rate limit reached. Waiting 60 seconds to respect rate limits..."

    sleep 60
    echo "🔄 Proceeding with retry (rate limit window reset)"
    echo ""
}

# Escalation protocol (user requirement: after 2 failed attempts)
escalate_with_alternatives() {
    local error_type="$1"
    local error_details="$2"
    local original_command="$3"
    local context="$4"

    echo ""
    echo "🚨 Escalation: 2-Attempt Threshold Exceeded"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Context: $context"
    echo "Error type: $error_type"
    echo "Command: $original_command"
    echo ""

    case "$error_type" in
        "ssh_key_immediate")
            echo "🔄 Enhanced SSH Key Alternative Approaches:"
            if [[ "$CONNECTIVITY_SKILL_AVAILABLE" == "true" ]]; then
                echo "1. Interactive SSH troubleshooting: claude /remote-connectivity-management --operation=troubleshoot --interactive=true"
                echo "2. SSH recovery guide: claude /remote-connectivity-management --operation=recovery-guide"
                echo "3. Quick SSH validation: claude /remote-connectivity-management --operation=key-check"
                echo "4. Switch to HTTPS authentication: git remote set-url origin https://..."
                echo "5. Use personal access token for authentication"
            else
                echo "1. Verify SSH agent status: ssh-add -l"
                echo "2. Switch to HTTPS authentication: git remote set-url origin https://..."
                echo "3. Use personal access token for authentication"
                echo "4. Check SSH key permissions: ls -la ~/.ssh/"
                echo "5. Test SSH connection: ssh -T git@github.com"
            fi
            ;;
        "network_timeout_30s")
            echo "🔄 Enhanced Network Alternative Approaches:"
            if [[ "$CONNECTIVITY_SKILL_AVAILABLE" == "true" ]]; then
                echo "1. VPN conflict analysis: claude /remote-connectivity-management --operation=cisco-conflict-detect"
                echo "2. Comprehensive VPN status: claude /remote-connectivity-management --operation=vpn-status"
                echo "3. Full network diagnosis: claude /remote-connectivity-management --operation=full-diagnosis"
                echo "4. Try different network connection or VPN configuration"
                echo "5. Use offline/cached resources if available"
            else
                echo "1. Check internet connectivity: ping google.com"
                echo "2. Try different network connection or VPN"
                echo "3. Use offline/cached resources if available"
                echo "4. Check firewall and proxy settings"
                echo "5. Try alternative endpoints or mirrors"
            fi
            ;;
        "mcp_connection_failure")
            echo "🔄 MCP Alternative Approaches:"
            if command -v suggest_cli_alternative >/dev/null 2>&1; then
                suggest_cli_alternative "$original_command"
            else
                echo "1. Use CLI equivalent tools (glab, acli, etc.)"
                echo "2. Try browser-based operations"
                echo "3. Check MCP server status in Claude settings"
                echo "4. Restart MCP servers if possible"
            fi
            ;;
        "authentication_expired")
            echo "🔄 Authentication Alternative Approaches:"
            echo "1. Refresh authentication tokens manually"
            echo "2. Re-login to the service (glab auth login, acli auth login)"
            echo "3. Check credential expiration dates"
            echo "4. Use alternative authentication methods"
            ;;
        "rate_limit_backoff")
            echo "🔄 Rate Limit Alternative Approaches:"
            echo "1. Wait longer before retrying (rate limits may be hourly)"
            echo "2. Use different API endpoints if available"
            echo "3. Reduce request frequency"
            echo "4. Use cached data if acceptable"
            ;;
        *)
            echo "🔄 General Alternative Approaches:"
            echo "1. Try manual operation through web interface"
            echo "2. Use alternative tools or methods"
            echo "3. Check service status pages for outages"
            echo "4. Contact system administrator if needed"
            ;;
    esac

    echo ""
    log_error "❌ Automated retry failed. Manual intervention required."
}

# Retry-aware tool validation wrapper
validate_tool_with_retry() {
    local tool_name="$1"
    local validate_auth="${2:-true}"
    local operation_context="${3:-general}"

    log_info "🔍 Validating tool with intelligent retry: $tool_name"

    case "$tool_name" in
        "glab"|"acli"|"git")
            # CLI tools that may need SSH keys or network access
            execute_with_intelligent_retry "validate_cli_tool '$tool_name' '$validate_auth'" "$tool_name validation" "tool-validation"
            ;;
        "atlassian"|"gitlab-sidekick"|"databricks"|"serena"|"glean-tools")
            # MCP servers that may have network issues
            execute_with_intelligent_retry "validate_mcp_tool '$tool_name'" "$tool_name MCP validation" "tool-validation"
            ;;
        *)
            # Use existing validation for other tools
            if command -v validate_tool >/dev/null 2>&1; then
                validate_tool "$tool_name" "$validate_auth" "$operation_context"
            else
                log_warning "No validation available for tool: $tool_name"
                return 1
            fi
            ;;
    esac
}

# Export functions for use by other skills
export -f execute_with_intelligent_retry
export -f classify_error_enhanced
export -f validate_tool_with_retry
export -f handle_ssh_key_immediate_prompt
export -f handle_network_timeout_30s
export -f escalate_with_alternatives

# Main execution function for direct script usage
main() {
    case "${1:-}" in
        "test-ssh")
            handle_ssh_key_immediate_prompt "Test SSH error" "test context"
            ;;
        "test-network")
            handle_network_timeout_30s "1" "test context"
            ;;
        "test-retry")
            execute_with_intelligent_retry "false" "test command" "test-skill"
            ;;
        *)
            echo "Intelligent Retry Controller loaded successfully"
            echo "Available functions:"
            echo "  - execute_with_intelligent_retry"
            echo "  - validate_tool_with_retry"
            echo "  - classify_error_enhanced"
            echo ""
            echo "Test functions:"
            echo "  $0 test-ssh    - Test SSH key prompt"
            echo "  $0 test-network - Test network timeout"
            echo "  $0 test-retry   - Test retry logic"
            ;;
    esac
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]:-}" == "${0:-}" ]]; then
    main "$@"
fi