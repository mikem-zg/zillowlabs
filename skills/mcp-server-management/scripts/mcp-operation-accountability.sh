#!/bin/bash

# MCP Operation Accountability
# Focused planning validation and execution tracking for MCP operations

# Get script directory for relative imports
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/mcp-utils.sh"

# MCP operation tracking
MCP_OPERATION_LOG="$HOME/.claude/mcp-operations.log"

# Initialize MCP operation tracking
initialize_mcp_tracking() {
    mkdir -p "$(dirname "$MCP_OPERATION_LOG")"
    if [[ ! -f "$MCP_OPERATION_LOG" ]]; then
        echo "# MCP Operation Tracking Log" > "$MCP_OPERATION_LOG"
        echo "# Format: TIMESTAMP|OPERATION|SERVER|STATUS|DETAILS" >> "$MCP_OPERATION_LOG"
    fi
}

# Validate MCP operation before execution (focused scope)
# Usage: validate_mcp_operation "operation_description" "server_name"
validate_mcp_operation() {
    local operation_description="$1"
    local server_name="$2"
    local validation_passed=true

    log_info "🔍 Validating MCP operation: $operation_description"

    # Get current list of MCP servers dynamically
    local available_servers
    available_servers=$(get_mcp_servers)

    if [[ -z "$available_servers" ]]; then
        log_error "No MCP servers configured or accessible"
        return 1
    fi

    # Validate server exists in current configuration
    if ! echo "$available_servers" | grep -q "^$server_name$"; then
        log_warning "❌ Server '$server_name' not in configured MCP servers"
        echo "Available servers:"
        echo "$available_servers" | sed 's/^/   - /'
        validation_passed=false
    fi

    # Test server health before operation
    if [[ "$validation_passed" == "true" ]]; then
        if ! test_mcp_server "$server_name" 5; then
            log_warning "⚠️ Server '$server_name' not responding - operation may fail"
            echo "Recommendation: Include server restart in operation plan"
        fi
    fi

    # Validate operation has clear success criteria
    if ! echo "$operation_description" | grep -qiE "(test|verify|check|confirm|validate|ensure)"; then
        log_warning "⚠️ Operation lacks clear validation criteria"
        echo "Recommendation: Include specific validation steps in operation description"
    fi

    if [[ "$validation_passed" == "true" ]]; then
        log_success "✅ MCP operation validation passed"
        return 0
    else
        log_error "❌ MCP operation validation failed"
        return 1
    fi
}

# Track MCP operation execution with accountability
# Usage: track_mcp_operation "operation" "server" "command" "expected_outcome"
track_mcp_operation() {
    local operation="$1"
    local server="$2"
    local command="$3"
    local expected_outcome="$4"
    local timestamp=$(date -Iseconds)

    initialize_mcp_tracking

    # Validate before execution
    if ! validate_mcp_operation "$operation" "$server"; then
        log_error "Pre-execution validation failed for: $operation"
        echo "$timestamp|$operation|$server|VALIDATION_FAILED|Pre-execution validation failed" >> "$MCP_OPERATION_LOG"
        return 1
    fi

    # Log operation start
    echo "$timestamp|$operation|$server|STARTED|Command: $command" >> "$MCP_OPERATION_LOG"
    log_info "🚀 Starting tracked MCP operation: $operation"

    # Execute with existing enhanced recovery
    if execute_with_enhanced_recovery "$command" "$operation" 3; then
        # Validate expected outcome
        if validate_mcp_outcome "$server" "$expected_outcome"; then
            echo "$timestamp|$operation|$server|SUCCESS|Expected outcome achieved" >> "$MCP_OPERATION_LOG"
            log_success "✅ MCP operation completed successfully with validation"
            return 0
        else
            echo "$timestamp|$operation|$server|PARTIAL_SUCCESS|Command succeeded but outcome validation failed" >> "$MCP_OPERATION_LOG"
            log_warning "⚠️ Operation completed but expected outcome not fully achieved"
            return 1
        fi
    else
        echo "$timestamp|$operation|$server|FAILED|Command execution failed" >> "$MCP_OPERATION_LOG"
        log_error "❌ MCP operation failed"
        return 1
    fi
}

# Validate MCP operation outcome
# Usage: validate_mcp_outcome "server_name" "expected_outcome"
validate_mcp_outcome() {
    local server_name="$1"
    local expected_outcome="$2"

    log_info "🔍 Validating outcome: $expected_outcome"

    # Standard validation patterns for MCP operations
    case "$expected_outcome" in
        *"server healthy"*|*"server responds"*)
            test_mcp_server "$server_name" 5
            ;;
        *"restart successful"*|*"server restarted"*)
            sleep 3  # Allow restart to complete
            test_mcp_server "$server_name" 10
            ;;
        *"tools available"*|*"tools working"*)
            # Check if MCP tools are responsive (basic test)
            timeout 10 bash -c "claude mcp status $server_name >/dev/null 2>&1" || return 1
            ;;
        *)
            log_info "Custom outcome validation - assuming success"
            return 0
            ;;
    esac
}

# Generate MCP operation accountability report
# Usage: generate_mcp_operation_report [days]
generate_mcp_operation_report() {
    local days="${1:-7}"

    if [[ ! -f "$MCP_OPERATION_LOG" ]]; then
        log_info "No MCP operation history found"
        return 0
    fi

    local since_date
    if command -v gdate >/dev/null 2>&1; then
        since_date=$(gdate -d "$days days ago" "+%Y-%m-%d")
    else
        since_date=$(date -v-${days}d "+%Y-%m-%d")
    fi

    echo "=== MCP Operation Accountability Report ==="
    echo "Period: Last $days days (since $since_date)"
    echo "Generated: $(date)"
    echo

    # Current MCP server status
    echo "=== Current MCP Server Status ==="
    local servers
    servers=$(get_mcp_servers)
    if [[ -n "$servers" ]]; then
        echo "$servers" | while read -r server; do
            if [[ -n "$server" ]]; then
                if test_mcp_server "$server" 3; then
                    echo "✅ $server: Healthy"
                else
                    echo "❌ $server: Not responding"
                fi
            fi
        done
    else
        echo "No MCP servers configured"
    fi
    echo

    # Analyze recent operations
    awk -F'|' -v since="$since_date" '
    $1 >= since && NF >= 4 {
        operations++
        servers[$3]++

        if ($4 == "SUCCESS") {
            successes++
            server_success[$3]++
        } else if ($4 == "FAILED") {
            failures++
            server_failures[$3]++
        } else if ($4 == "PARTIAL_SUCCESS") {
            partial++
        } else if ($4 == "VALIDATION_FAILED") {
            validation_failures++
        }
    }
    END {
        print "=== Operation Statistics ==="
        print "Total operations:", operations
        if (operations > 0) {
            success_rate = int((successes + 0) / operations * 100)
            print "Success rate:", success_rate "%"
            if (successes > 0) print "✅ Successful:", successes
            if (failures > 0) print "❌ Failed:", failures
            if (partial > 0) print "⚠️ Partially successful:", partial
            if (validation_failures > 0) print "🚫 Validation failures:", validation_failures
        }
        print ""

        if (length(servers) > 0) {
            print "=== By MCP Server ==="
            for (server in servers) {
                server_ops = servers[server]
                server_succ = server_success[server] + 0
                server_rate = (server_ops > 0 ? int(server_succ / server_ops * 100) : 0)
                print server ":", server_ops, "operations,", server_rate "% success"

                # Highlight problematic servers
                if (server_failures[server] >= 2) {
                    print "  🔧 Attention needed: " server_failures[server] " failures"
                }
            }
        }
    }
    ' "$MCP_OPERATION_LOG"

    echo
    echo "=== Recent Operations ==="
    tail -10 "$MCP_OPERATION_LOG" | grep -v "^#" | awk -F'|' '
    NF >= 4 {
        status_icon = "📝"
        if ($4 == "SUCCESS") status_icon = "✅"
        else if ($4 == "FAILED") status_icon = "❌"
        else if ($4 == "PARTIAL_SUCCESS") status_icon = "⚠️"
        else if ($4 == "VALIDATION_FAILED") status_icon = "🚫"

        print status_icon, substr($1, 12, 8), $2, "on", $3, ":", $4
    }'

    echo
    echo "=== Recommendations ==="

    # Check for patterns that need attention
    local problem_servers
    problem_servers=$(awk -F'|' -v since="$since_date" '
    $1 >= since && ($4 == "FAILED" || $4 == "VALIDATION_FAILED") {
        server_issues[$3]++
    }
    END {
        for (server in server_issues) {
            if (server_issues[server] >= 2) {
                print server, server_issues[server]
            }
        }
    }' "$MCP_OPERATION_LOG")

    if [[ -n "$problem_servers" ]]; then
        echo "$problem_servers" | while read -r server count; do
            echo "🔧 $server: $count recent failures - investigate server health and configuration"
        done
    else
        echo "✅ No servers showing concerning failure patterns"
    fi
}

# Check for incomplete or stale MCP operations
# Usage: check_incomplete_mcp_operations
check_incomplete_mcp_operations() {
    if [[ ! -f "$MCP_OPERATION_LOG" ]]; then
        log_info "No MCP operation log found"
        return 0
    fi

    log_info "🔍 Checking for incomplete MCP operations..."

    # Look for STARTED operations without completion status
    local incomplete
    incomplete=$(awk -F'|' '
    $4 == "STARTED" { started[$2 "|" $3] = $1 }
    $4 ~ /SUCCESS|FAILED|PARTIAL_SUCCESS/ { delete started[$2 "|" $3] }
    END {
        for (op in started) {
            print started[op] "|" op
        }
    }' "$MCP_OPERATION_LOG")

    if [[ -n "$incomplete" ]]; then
        echo
        log_warning "⚠️ Incomplete MCP operations detected:"
        echo "$incomplete" | while IFS='|' read -r timestamp operation server; do
            echo "   - $operation on $server (started: $timestamp)"
        done
        echo
        echo "These operations may need manual verification or cleanup"
        return 1
    else
        log_success "✅ All MCP operations have completed status"
        return 0
    fi
}

# Export accountability functions
export -f validate_mcp_operation track_mcp_operation validate_mcp_outcome
export -f generate_mcp_operation_report check_incomplete_mcp_operations
export -f initialize_mcp_tracking