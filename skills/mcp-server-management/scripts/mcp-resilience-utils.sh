#!/bin/bash

# MCP Resilience utility functions for other Claude Code skills
# Source this file to add MCP resilience patterns to any skill

# Get script directory for relative imports
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/mcp-utils.sh"
source "$SCRIPT_DIR/session-management.sh"
source "$SCRIPT_DIR/enhanced-error-recovery.sh"
source "$SCRIPT_DIR/mcp-operation-accountability.sh"

# Global retry configuration
MCP_MAX_RETRIES=2
MCP_RETRY_DELAY=30
MCP_TIMEOUT=15

# Standardized MCP operation with automatic failover
# Usage: mcp_operation_with_fallback "server_name" "operation_command" [fallback_command] [skill_name]
mcp_operation_with_fallback() {
    local server_name="$1"
    local operation_command="$2"
    local fallback_command="$3"
    local skill_name="${4:-unknown}"
    local attempt=1

    # Track session complexity before operation
    issue_complexity_warning
    local complexity_status=$?

    # Extract tool name from operation command for tracking
    local tool_name
    if [[ "$operation_command" =~ mcp__[^_]+__([^\ ]+) ]]; then
        tool_name="mcp_${server_name}_${BASH_REMATCH[1]}"
    else
        tool_name="mcp_${server_name}"
    fi

    # Track this tool usage
    track_tool_usage "$tool_name" "$skill_name"

    log_info "Executing MCP operation: $server_name (session complexity check: $complexity_status)"

    # Create command with health check and timeout
    local mcp_command_with_health_check="
        if ! test_mcp_server '$server_name' 5; then
            log_warning 'MCP server $server_name not responding - attempting restart'
            if restart_mcp_server '$server_name'; then
                sleep 3
                log_success 'Server restart successful'
            else
                log_warning 'Server restart failed'
                exit 1
            fi
        fi

        # Execute the actual MCP operation
        timeout $MCP_TIMEOUT bash -c '$operation_command'
    "

    # Use accountability tracking for the operation
    if track_mcp_operation "$skill_name MCP operation" "$server_name" "$mcp_command_with_health_check" "server responds and tools work"; then
        return 0
    fi

    # All MCP attempts failed, try fallback
    log_error "🚨 MCP operation failed after $MCP_MAX_RETRIES attempts"

    if [[ -n "$fallback_command" ]]; then
        log_info "🔄 Using fallback mechanism..."
        suggest_fallback "$server_name"
        echo
        log_info "Executing fallback: $fallback_command"

        if bash -c "$fallback_command"; then
            log_success "✅ Fallback operation completed successfully"
            return 0
        else
            log_error "❌ Fallback operation also failed"
            return 1
        fi
    else
        log_error "❌ No fallback mechanism available"
        suggest_fallback "$server_name"
        return 1
    fi
}

# Enhanced error handler for MCP-dependent skills
# Usage: handle_mcp_error "skill_name" "server_name" "operation" "error_message"
handle_mcp_error() {
    local skill_name="$1"
    local server_name="$2"
    local operation="$3"
    local error_message="$4"

    echo
    log_error "🚨 MCP Error in $skill_name:"
    echo "   Server: $server_name"
    echo "   Operation: $operation"
    echo "   Error: $error_message"
    echo

    # Classify the error for intelligent recovery
    local error_class
    error_class=$(classify_error "$error_message")
    log_info "Error classified as: $error_class"

    # Apply comprehensive error recovery
    if recover_from_error "$error_class" "$error_message" "$operation" "$skill_name"; then
        log_success "✅ Automated recovery successful"
        log_info "💡 You can now retry your original operation"
        return 0
    else
        log_warning "❌ Automated recovery failed"
        log_info "🛠️ Using fallback mechanisms:"
        suggest_fallback "$server_name"

        # Provide enhanced manual recovery guidance
        suggest_manual_recovery "$error_class" "$error_message" "$operation"
        return 1
    fi
}

# Check if MCP operation should use fallback (circuit breaker pattern)
# Usage: should_use_fallback "server_name"
should_use_fallback() {
    local server_name="$1"
    local error_count

    error_count=$(count_server_errors "$server_name" 1)

    # Use fallback if more than 3 errors in the last hour
    if [[ $error_count -gt 3 ]]; then
        log_warning "🚨 High error rate for $server_name ($error_count errors/hour) - using fallback"
        return 0
    fi

    # Check if server is currently failing
    if ! test_mcp_server "$server_name" 3; then
        log_warning "🚨 MCP server $server_name not responding - using fallback"
        return 0
    fi

    return 1
}

# Enhanced tool usage with availability validation
# Usage: execute_tool_with_validation "tool_name" "command" [fallback_command]
execute_tool_with_validation() {
    local tool_name="$1"
    local command="$2"
    local fallback_command="$3"

    # Check if it's an MCP tool
    if [[ "$tool_name" =~ ^mcp__([^_]+)__ ]]; then
        local server_name="${BASH_REMATCH[1]}"

        # Use circuit breaker pattern
        if should_use_fallback "$server_name"; then
            if [[ -n "$fallback_command" ]]; then
                log_info "🔄 Using fallback due to server issues: $fallback_command"
                bash -c "$fallback_command"
                return $?
            else
                suggest_fallback "$server_name"
                return 1
            fi
        fi

        # Use MCP operation with failover
        mcp_operation_with_fallback "$server_name" "$command" "$fallback_command"
        return $?
    else
        # Non-MCP tool - execute directly
        log_info "Executing: $command"
        bash -c "$command"
        return $?
    fi
}

# Session complexity management
# Usage: check_session_complexity [current_tool_count]
check_session_complexity() {
    local tool_count="${1:-0}"

    # Try to get actual tool count from current session if not provided
    if [[ $tool_count -eq 0 ]]; then
        # This would need to be implemented based on how Claude Code tracks this
        tool_count=$(ps -ef | grep -c "claude.*tool" 2>/dev/null || echo "0")
    fi

    if [[ $tool_count -ge 50 ]]; then
        log_warning "⚠️ Session complexity is very high (${tool_count}+ tools used)"
        log_info "Consider breaking into focused sessions for better performance"
        return 2
    elif [[ $tool_count -ge 30 ]]; then
        log_warning "⚠️ Session complexity is getting high (${tool_count} tools used)"
        log_info "Consider simplifying approach or breaking into smaller tasks"
        return 1
    fi

    return 0
}

# SSH key error recovery
# Usage: handle_ssh_error "error_message" "retry_command"
handle_ssh_error() {
    local error_message="$1"
    local retry_command="$2"

    log_error "🔑 SSH Key Error: $error_message"
    echo
    log_info "To resolve this issue:"
    echo "1. Add your SSH key:"
    echo "   ssh-add ~/.ssh/id_rsa"
    echo "   # Or for specific key: ssh-add ~/.ssh/your_key_name"
    echo
    echo "2. Verify key is loaded:"
    echo "   ssh-add -l"
    echo
    echo "3. Then retry the operation:"
    echo "   $retry_command"
    echo

    # Wait for user confirmation
    echo -n "Press Enter after adding SSH key to retry automatically..."
    read -r

    log_info "🔄 Retrying operation..."
    if bash -c "$retry_command"; then
        log_success "✅ Operation successful after SSH key addition"
        return 0
    else
        log_error "❌ Operation still failed - manual intervention required"
        return 1
    fi
}

# Network timeout handling with exponential backoff
# Usage: handle_network_timeout "command" [max_retries]
handle_network_timeout() {
    local command="$1"
    local max_retries="${2:-3}"
    local attempt=1
    local delay=30

    while [[ $attempt -le $max_retries ]]; do
        log_info "Executing: $command (attempt $attempt/$max_retries)"

        if timeout 60 bash -c "$command"; then
            log_success "✅ Operation completed successfully"
            return 0
        fi

        if [[ $attempt -lt $max_retries ]]; then
            log_warning "❌ Network timeout occurred"
            log_info "🕒 Retrying in ${delay}s due to network issues..."
            sleep $delay

            # Exponential backoff
            delay=$((delay * 2))
            if [[ $delay -gt 120 ]]; then
                delay=120  # Cap at 2 minutes
            fi
        fi

        attempt=$((attempt + 1))
    done

    log_error "❌ Operation failed after $max_retries attempts due to network timeouts"
    log_info "🛠️ Troubleshooting suggestions:"
    echo "   - Check internet connectivity"
    echo "   - Verify VPN connection if required"
    echo "   - Try again later if service is experiencing issues"
    return 1
}

# Proactive health check before operations
# Usage: ensure_mcp_health "server1,server2,server3"
ensure_mcp_health() {
    local servers="$1"
    local unhealthy_servers=()

    IFS=',' read -ra server_array <<< "$servers"

    log_info "🏥 Performing proactive health check..."

    for server in "${server_array[@]}"; do
        if ! test_mcp_server "$server" 5; then
            unhealthy_servers+=("$server")
        fi
    done

    if [[ ${#unhealthy_servers[@]} -gt 0 ]]; then
        log_warning "⚠️ Unhealthy MCP servers detected: ${unhealthy_servers[*]}"
        log_info "🔄 Attempting recovery..."

        for server in "${unhealthy_servers[@]}"; do
            if restart_mcp_server "$server"; then
                log_success "✅ Recovered $server"
            else
                log_warning "❌ Could not recover $server - fallback required"
                suggest_fallback "$server"
            fi
        done

        return 1
    fi

    log_success "✅ All MCP servers healthy"
    return 0
}

# Export functions for use in other skills
export -f mcp_operation_with_fallback handle_mcp_error should_use_fallback
export -f execute_tool_with_validation check_session_complexity
export -f handle_ssh_error handle_network_timeout ensure_mcp_health
export -f classify_error intelligent_retry recover_from_error execute_with_enhanced_recovery
export -f validate_mcp_operation track_mcp_operation generate_mcp_operation_report check_incomplete_mcp_operations