#!/bin/bash

# Enhanced Error Recovery for Claude Code MCP Operations
# Advanced error classification, recovery strategies, and intelligent retry logic
# Enhanced with Remote Connectivity Management Skill integration

# Get script directory for relative imports
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/mcp-utils.sh"
source "$SCRIPT_DIR/session-management.sh"

# Try to integrate with Remote Connectivity Management Skill for enhanced SSH/VPN error handling
CONNECTIVITY_SKILL_AVAILABLE=false
if [[ -f "$SCRIPT_DIR/../../remote-connectivity-management/integration/skill-bridge.sh" ]]; then
    # Temporarily disable strict mode for sourcing
    set +e
    source "$SCRIPT_DIR/../../remote-connectivity-management/integration/skill-bridge.sh" 2>/dev/null
    if [[ $? -eq 0 ]] && command -v validate_ssh_with_vpn_check >/dev/null 2>&1; then
        CONNECTIVITY_SKILL_AVAILABLE=true
        log_info "Enhanced error recovery with Remote Connectivity Management Skill"
    fi
    set -e
fi

# Enhanced retry configuration with adaptive backoff
ENHANCED_MAX_RETRIES=5
ENHANCED_BASE_DELAY=10
ENHANCED_MAX_DELAY=300
ENHANCED_JITTER_RANGE=5

# Error classification patterns
declare -A ERROR_PATTERNS=(
    ["connection_refused"]="Connection refused|ECONNREFUSED|connection reset"
    ["timeout"]="timeout|ETIMEDOUT|operation timed out"
    ["authentication"]="unauthorized|authentication failed|401|403"
    ["not_found"]="not found|404|ENOTFOUND|does not exist"
    ["rate_limit"]="rate limit|429|too many requests"
    ["server_error"]="internal server error|500|503|service unavailable"
    ["network_error"]="network is unreachable|DNS resolution|no route to host"
    ["ssh_key"]="permission denied|public key|ssh key|agent has no identities"
    ["mcp_specific"]="mcp.*error|server terminated|connection closed unexpectedly"
    ["tool_unavailable"]="tool.*not available|filtering out tool|no such tool"
)

# Recovery strategy mapping (Enhanced with Remote Connectivity Management Skill)
declare -A RECOVERY_STRATEGIES=(
    ["connection_refused"]="restart_service,check_network,wait_retry"
    ["timeout"]="increase_timeout,retry_with_backoff,check_server_load,check_vpn_conflicts"
    ["authentication"]="refresh_credentials,check_permissions,manual_auth"
    ["not_found"]="verify_resource,check_spelling,alternative_resource"
    ["rate_limit"]="exponential_backoff,reduce_request_rate,wait_longer"
    ["server_error"]="retry_later,check_server_status,escalate_support"
    ["network_error"]="enhanced_connectivity_check,vpn_conflict_analysis,dns_resolution"
    ["ssh_key"]="enhanced_ssh_recovery,interactive_ssh_troubleshoot,alternative_auth"
    ["mcp_specific"]="restart_mcp_server,reconnect_mcp,use_fallback"
    ["tool_unavailable"]="refresh_tool_cache,use_alternative_tool,manual_operation"
)

# Enhanced error classification
# Usage: classify_error "error_message"
classify_error() {
    local error_message="$1"
    local error_class="unknown"

    for pattern_name in "${!ERROR_PATTERNS[@]}"; do
        local pattern="${ERROR_PATTERNS[$pattern_name]}"
        if echo "$error_message" | grep -qiE "$pattern"; then
            error_class="$pattern_name"
            break
        fi
    done

    echo "$error_class"
}

# Intelligent retry with adaptive backoff and jitter
# Usage: intelligent_retry "command" "max_attempts" "error_context"
intelligent_retry() {
    local command="$1"
    local max_attempts="${2:-$ENHANCED_MAX_RETRIES}"
    local error_context="${3:-operation}"
    local attempt=1
    local delay=$ENHANCED_BASE_DELAY

    log_info "🔄 Starting intelligent retry for: $error_context"

    while [[ $attempt -le $max_attempts ]]; do
        log_info "Attempt $attempt/$max_attempts: $command"

        # Capture both stdout and stderr with exit code
        local output
        local exit_code
        output=$(eval "$command" 2>&1)
        exit_code=$?

        if [[ $exit_code -eq 0 ]]; then
            log_success "✅ Operation successful on attempt $attempt"
            echo "$output"
            return 0
        fi

        # Analyze error and determine strategy
        local error_class
        error_class=$(classify_error "$output")
        log_warning "❌ Attempt $attempt failed with error class: $error_class"

        # Apply error-specific recovery if not last attempt
        if [[ $attempt -lt $max_attempts ]]; then
            apply_error_recovery "$error_class" "$output" "$command"

            # Calculate adaptive delay with jitter
            local jitter=$((RANDOM % ENHANCED_JITTER_RANGE))
            local actual_delay=$((delay + jitter))

            log_info "🕒 Waiting ${actual_delay}s before retry (class: $error_class)"
            sleep "$actual_delay"

            # Adaptive backoff based on error type
            case "$error_class" in
                "rate_limit"|"server_error")
                    delay=$((delay * 3))  # Aggressive backoff for server issues
                    ;;
                "network_error"|"timeout")
                    delay=$((delay * 2))  # Standard exponential backoff
                    ;;
                "authentication"|"ssh_key")
                    delay=$((delay + 10)) # Linear increase for auth issues
                    ;;
                *)
                    delay=$((delay * 2))  # Default exponential backoff
                    ;;
            esac

            # Cap maximum delay
            if [[ $delay -gt $ENHANCED_MAX_DELAY ]]; then
                delay=$ENHANCED_MAX_DELAY
            fi
        fi

        attempt=$((attempt + 1))
    done

    log_error "❌ All $max_attempts attempts failed for: $error_context"
    suggest_manual_recovery "$error_class" "$output" "$command"
    return 1
}

# Apply error-specific recovery strategies
# Usage: apply_error_recovery "error_class" "error_message" "original_command"
apply_error_recovery() {
    local error_class="$1"
    local error_message="$2"
    local original_command="$3"

    log_info "🛠️ Applying recovery strategy for error class: $error_class"

    case "$error_class" in
        "mcp_specific")
            apply_mcp_recovery "$error_message" "$original_command"
            ;;
        "ssh_key")
            apply_ssh_key_recovery "$error_message"
            ;;
        "authentication")
            apply_auth_recovery "$error_message" "$original_command"
            ;;
        "network_error")
            apply_network_recovery "$error_message"
            ;;
        "timeout")
            apply_timeout_recovery "$error_message"
            ;;
        "rate_limit")
            apply_rate_limit_recovery "$error_message"
            ;;
        "tool_unavailable")
            apply_tool_availability_recovery "$error_message"
            ;;
        *)
            log_info "No specific recovery strategy for error class: $error_class"
            ;;
    esac
}

# MCP-specific recovery strategies
apply_mcp_recovery() {
    local error_message="$1"
    local original_command="$2"

    # Extract server name from command if possible
    local server_name=""
    if [[ "$original_command" =~ mcp__([^_]+)__ ]]; then
        server_name="${BASH_REMATCH[1]}"
    fi

    if [[ -n "$server_name" ]]; then
        log_info "🔄 Attempting MCP server recovery for: $server_name"

        # Try restarting the specific MCP server
        if restart_mcp_server "$server_name"; then
            log_success "✅ MCP server $server_name restarted successfully"
            sleep 5  # Allow server to fully initialize
        else
            log_warning "❌ Failed to restart MCP server $server_name"
        fi
    else
        log_info "🔄 Attempting general MCP recovery"
        # General MCP health check and recovery
        claude mcp restart >/dev/null 2>&1 || true
        sleep 3
    fi
}

# SSH key recovery strategies (Enhanced with Remote Connectivity Management Skill)
apply_ssh_key_recovery() {
    local error_message="$1"
    local server="${2:-}"

    log_info "🔑 Enhanced SSH key recovery..."

    # Use Remote Connectivity Management Skill if available
    if [[ "$CONNECTIVITY_SKILL_AVAILABLE" == "true" ]]; then
        log_info "Using Remote Connectivity Management Skill for SSH recovery"

        # Enhanced SSH key recovery with VPN awareness
        if command -v apply_ssh_key_recovery >/dev/null 2>&1; then
            apply_ssh_key_recovery "$server" true  # force reload
            return $?
        fi
    fi

    # Fallback to original logic if skill not available
    log_info "Using fallback SSH key recovery"

    # Check if ssh-agent is running
    if ! ssh-add -l >/dev/null 2>&1; then
        log_info "Starting ssh-agent..."
        eval "$(ssh-agent -s)" >/dev/null 2>&1
    fi

    # Try to add common SSH keys automatically
    for key_path in ~/.ssh/id_rsa ~/.ssh/id_ed25519 ~/.ssh/id_ecdsa; do
        if [[ -f "$key_path" ]]; then
            log_info "Adding SSH key: $key_path"
            ssh-add "$key_path" >/dev/null 2>&1 || true
        fi
    done

    # Verify keys are loaded
    local key_count
    key_count=$(ssh-add -l 2>/dev/null | wc -l)
    if [[ $key_count -gt 0 ]]; then
        log_success "✅ SSH keys loaded: $key_count key(s) available"
    else
        log_warning "⚠️ No SSH keys found or loaded"
        log_info "Consider using: claude /remote-connectivity-management --operation=troubleshoot --interactive=true"
    fi
}

# Authentication recovery strategies
apply_auth_recovery() {
    local error_message="$1"
    local original_command="$2"

    log_info "🔐 Attempting authentication recovery..."

    # Check for MCP authentication issues
    if echo "$error_message" | grep -qi "mcp\|atlassian"; then
        log_info "MCP authentication issue detected - checking connection..."
        # This would trigger MCP reconnection prompts
        return 0
    fi

    # Check for git authentication
    if echo "$original_command" | grep -qi "git\|gitlab\|github"; then
        log_info "Git authentication issue - checking credentials..."
        git config --get user.name >/dev/null 2>&1 || log_warning "Git user.name not configured"
        git config --get user.email >/dev/null 2>&1 || log_warning "Git user.email not configured"
    fi
}

# Network recovery strategies (Enhanced with VPN conflict detection)
apply_network_recovery() {
    local error_message="$1"

    log_info "🌐 Enhanced network connectivity analysis..."

    # Use Remote Connectivity Management Skill for comprehensive VPN analysis if available
    if [[ "$CONNECTIVITY_SKILL_AVAILABLE" == "true" ]]; then
        log_info "Using Remote Connectivity Management Skill for network analysis"

        # Comprehensive VPN and network check
        if command -v vpn_comprehensive_check >/dev/null 2>&1; then
            local vpn_status
            vpn_status=$(vpn_comprehensive_check)

            # Analyze results
            if echo "$vpn_status" | grep -q "internet:failed"; then
                log_error "❌ Internet connectivity failed"
                return 1
            fi

            if echo "$vpn_status" | grep -q "dns:failed"; then
                log_warning "⚠️ DNS resolution issues detected"
            fi

            # Check for VPN conflicts
            if command -v detect_cisco_vpn_conflict >/dev/null 2>&1 && detect_cisco_vpn_conflict; then
                log_warning "⚠️ VPN conflict detected - may affect MCP operations"
                echo "Consider running: claude /remote-connectivity-management --operation=cisco-conflict-detect"
            fi

            log_success "✅ Enhanced network analysis complete"
            return 0
        fi
    fi

    # Fallback to original logic if skill not available
    log_info "Using fallback network connectivity check"

    # Basic connectivity test
    if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
        log_success "✅ Internet connectivity available"
    else
        log_error "❌ No internet connectivity detected"
        return 1
    fi

    # DNS resolution test
    if nslookup google.com >/dev/null 2>&1; then
        log_success "✅ DNS resolution working"
    else
        log_warning "⚠️ DNS resolution issues detected"
    fi

    # VPN check (basic)
    if route -n get default 2>/dev/null | grep -q "interface: utun\|interface: tun"; then
        log_info "VPN connection detected"
        log_info "For detailed VPN analysis: claude /remote-connectivity-management --operation=vpn-status"
    fi
}

# Timeout recovery strategies
apply_timeout_recovery() {
    local error_message="$1"

    log_info "⏱️ Applying timeout recovery..."

    # Increase timeout for next attempt (this would need to be handled by calling function)
    export ENHANCED_TIMEOUT=$((${ENHANCED_TIMEOUT:-15} * 2))
    if [[ $ENHANCED_TIMEOUT -gt 120 ]]; then
        ENHANCED_TIMEOUT=120
    fi

    log_info "Increased timeout to ${ENHANCED_TIMEOUT}s for next attempt"

    # Check system load as timeout cause
    local load_avg
    load_avg=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | tr -d ',')
    if (( $(echo "$load_avg > 2.0" | bc -l 2>/dev/null) )); then
        log_warning "⚠️ High system load detected: $load_avg"
    fi
}

# Rate limit recovery strategies
apply_rate_limit_recovery() {
    local error_message="$1"

    log_info "🚦 Rate limit detected - implementing backoff strategy"

    # Extract rate limit info if available
    if echo "$error_message" | grep -qi "retry.*after\|retry-after"; then
        local retry_after
        retry_after=$(echo "$error_message" | grep -oiE "retry.*after[^0-9]*([0-9]+)" | grep -oE "[0-9]+")
        if [[ -n "$retry_after" ]]; then
            log_info "Server requested retry after ${retry_after}s"
            export ENHANCED_RATE_LIMIT_DELAY="$retry_after"
        fi
    fi
}

# Tool availability recovery strategies
apply_tool_availability_recovery() {
    local error_message="$1"

    log_info "🔧 Tool availability issue detected"

    # Check MCP tool cache
    if echo "$error_message" | grep -qi "filtering out tool\|tool.*not available"; then
        log_info "Refreshing MCP tool cache..."
        # This would trigger tool refresh in the calling context
        export TOOL_CACHE_REFRESH_NEEDED=1
    fi
}

# Comprehensive error recovery orchestrator
# Usage: recover_from_error "error_class" "error_message" "original_command" "context"
recover_from_error() {
    local error_class="$1"
    local error_message="$2"
    local original_command="$3"
    local context="${4:-operation}"

    log_info "🏥 Starting comprehensive error recovery for: $context"
    log_info "Error class: $error_class"

    # Track error for circuit breaker logic
    track_error "$error_class" "$context"

    # Apply immediate recovery strategies
    apply_error_recovery "$error_class" "$error_message" "$original_command"

    # Wait for recovery actions to take effect
    sleep 2

    # Validate recovery success
    case "$error_class" in
        "mcp_specific")
            validate_mcp_recovery "$original_command"
            ;;
        "ssh_key")
            validate_ssh_recovery
            ;;
        "network_error")
            validate_network_recovery
            ;;
        *)
            log_info "No specific recovery validation for: $error_class"
            return 0
            ;;
    esac
}

# Recovery validation functions
validate_mcp_recovery() {
    local original_command="$1"

    if [[ "$original_command" =~ mcp__([^_]+)__ ]]; then
        local server_name="${BASH_REMATCH[1]}"
        if test_mcp_server "$server_name" 3; then
            log_success "✅ MCP server $server_name recovery validated"
            return 0
        else
            log_warning "❌ MCP server $server_name still not responding"
            return 1
        fi
    fi
    return 0
}

validate_ssh_recovery() {
    # Use enhanced SSH validation if available
    if [[ "$CONNECTIVITY_SKILL_AVAILABLE" == "true" ]] && command -v ssh_validate_keys >/dev/null 2>&1; then
        ssh_validate_keys
    else
        # Fallback validation
        if ssh-add -l >/dev/null 2>&1; then
            log_success "✅ SSH key recovery validated"
            return 0
        else
            log_warning "❌ SSH keys still not available"
            return 1
        fi
    fi
}

validate_network_recovery() {
    if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
        log_success "✅ Network recovery validated"
        return 0
    else
        log_error "❌ Network still not available"
        return 1
    fi
}

# Error tracking for pattern analysis
# Usage: track_error "error_class" "context"
track_error() {
    local error_class="$1"
    local context="$2"
    local timestamp=$(date -Iseconds)

    # Create error tracking directory if it doesn't exist
    local error_log_dir="$HOME/.claude/error-tracking"
    mkdir -p "$error_log_dir"

    # Log error with metadata
    echo "$timestamp|$error_class|$context" >> "$error_log_dir/error-history.log"

    # Maintain error statistics
    local stats_file="$error_log_dir/error-stats.json"
    if [[ ! -f "$stats_file" ]]; then
        echo "{}" > "$stats_file"
    fi

    # Update error count using jq if available
    if command -v jq >/dev/null 2>&1; then
        jq --arg class "$error_class" --arg time "$timestamp" \
           '.[$class] += 1 | .last_seen[$class] = $time' \
           "$stats_file" > "${stats_file}.tmp" && \
           mv "${stats_file}.tmp" "$stats_file"
    fi
}

# Suggest manual recovery when all automated attempts fail
# Usage: suggest_manual_recovery "error_class" "error_message" "original_command"
suggest_manual_recovery() {
    local error_class="$1"
    local error_message="$2"
    local original_command="$3"

    echo
    log_error "🆘 Automated recovery failed - manual intervention required"
    echo "Error class: $error_class"
    echo "Original command: $original_command"
    echo

    case "$error_class" in
        "mcp_specific")
            echo "Manual MCP recovery steps:"
            echo "1. Check Claude Code MCP server status in settings"
            echo "2. Restart MCP servers manually: Claude Code → Settings → MCP"
            echo "3. Verify MCP server configuration files"
            echo "4. Try alternative tools or manual operations"
            ;;
        "ssh_key")
            echo "Enhanced SSH key recovery options:"
            if [[ "$CONNECTIVITY_SKILL_AVAILABLE" == "true" ]]; then
                echo "1. Interactive troubleshooting: claude /remote-connectivity-management --operation=troubleshoot --interactive=true"
                echo "2. Quick key check: claude /remote-connectivity-management --operation=key-check"
                echo "3. Recovery guidance: claude /remote-connectivity-management --operation=recovery-guide"
            else
                echo "1. Generate new SSH key: ssh-keygen -t ed25519 -C 'your_email@example.com'"
                echo "2. Add to ssh-agent: ssh-add ~/.ssh/id_ed25519"
                echo "3. Add public key to service (GitHub, GitLab, etc.)"
                echo "4. Test connection: ssh -T git@github.com"
            fi
            ;;
        "authentication")
            echo "Manual authentication recovery steps:"
            echo "1. Verify credentials are correct"
            echo "2. Check for 2FA/MFA requirements"
            echo "3. Regenerate API tokens if needed"
            echo "4. Review service-specific authentication docs"
            ;;
        "network_error")
            echo "Enhanced network recovery options:"
            if [[ "$CONNECTIVITY_SKILL_AVAILABLE" == "true" ]]; then
                echo "1. VPN status analysis: claude /remote-connectivity-management --operation=vpn-status"
                echo "2. Cisco VPN conflict check: claude /remote-connectivity-management --operation=cisco-conflict-detect"
                echo "3. Full network diagnosis: claude /remote-connectivity-management --operation=full-diagnosis"
                echo "4. Interactive troubleshooting: claude /remote-connectivity-management --operation=troubleshoot --interactive=true"
            else
                echo "1. Check internet connection and WiFi"
                echo "2. Verify VPN connection if required"
                echo "3. Check DNS settings (try 8.8.8.8 or 1.1.1.1)"
                echo "4. Restart network interface or router"
            fi
            ;;
        *)
            echo "General recovery steps:"
            echo "1. Review error details above"
            echo "2. Check service status pages"
            echo "3. Try alternative approaches or tools"
            echo "4. Consult documentation or support"
            ;;
    esac
    echo
}

# Enhanced wrapper for any command with intelligent retry
# Usage: execute_with_enhanced_recovery "command" "description" [max_attempts]
execute_with_enhanced_recovery() {
    local command="$1"
    local description="$2"
    local max_attempts="${3:-$ENHANCED_MAX_RETRIES}"

    log_info "🚀 Executing with enhanced recovery: $description"

    if intelligent_retry "$command" "$max_attempts" "$description"; then
        return 0
    else
        log_error "❌ Enhanced recovery failed for: $description"
        return 1
    fi
}

# Export enhanced recovery functions
export -f classify_error intelligent_retry apply_error_recovery recover_from_error
export -f apply_mcp_recovery apply_ssh_key_recovery apply_auth_recovery
export -f apply_network_recovery apply_timeout_recovery apply_rate_limit_recovery
export -f execute_with_enhanced_recovery suggest_manual_recovery track_error