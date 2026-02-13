#!/bin/bash

# MCP Server Restart Script
# Safe restart procedures for MCP servers with verification

# Get script directory for relative imports
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/mcp-utils.sh"

# Default values
SERVER_NAME=""
FORCE_RESTART=false
VERIFY_HEALTH=true
WAIT_TIME=3

# Usage function
usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Safely restart MCP servers with health verification

OPTIONS:
    -s, --server <name>     Server name to restart (required)
    -f, --force            Force restart even if server appears healthy
    --no-verify            Skip post-restart health verification
    -w, --wait <seconds>   Wait time between remove and re-add (default: 3)
    -h, --help             Show this help message

EXAMPLES:
    $0 --server atlassian              # Restart Atlassian MCP server
    $0 --server serena --force         # Force restart even if healthy
    $0 --server gitlab-sidekick --wait 5   # Wait 5 seconds between operations

SUPPORTED SERVERS:
    atlassian, glean-tools, serena, gitlab-sidekick, databricks,
    datadog-production, datadog-staging, context7, chrome-devtools
EOF
}

# Parse command line arguments
parse_args() {
    if [[ $# -eq 0 ]]; then
        log_error "Server name is required"
        usage
        exit 1
    fi

    while [[ $# -gt 0 ]]; do
        case $1 in
            -s|--server)
                SERVER_NAME="$2"
                shift 2
                ;;
            -f|--force)
                FORCE_RESTART=true
                shift
                ;;
            --no-verify)
                VERIFY_HEALTH=false
                shift
                ;;
            -w|--wait)
                WAIT_TIME="$2"
                shift 2
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                # If no flag provided, assume first argument is server name
                if [[ -z "$SERVER_NAME" ]]; then
                    SERVER_NAME="$1"
                    shift
                else
                    log_error "Unknown option: $1"
                    usage
                    exit 1
                fi
                ;;
        esac
    done

    if [[ -z "$SERVER_NAME" ]]; then
        log_error "Server name is required"
        usage
        exit 1
    fi
}

# Validate server name
validate_server() {
    local server="$1"
    local valid_servers=("atlassian" "glean-tools" "serena" "gitlab-sidekick" "databricks" "datadog-production" "datadog-staging" "context7" "chrome-devtools")

    for valid_server in "${valid_servers[@]}"; do
        if [[ "$server" == "$valid_server" ]]; then
            return 0
        fi
    done

    log_error "Unsupported server: $server"
    log_info "Supported servers: ${valid_servers[*]}"
    return 1
}

# Pre-restart health check
pre_restart_check() {
    local server="$1"

    log_info "Performing pre-restart health check for $server..."

    # Check if server exists in configuration
    if ! claude mcp get "$server" >/dev/null 2>&1; then
        log_error "Server $server is not configured"
        log_info "Available servers: $(get_mcp_servers | tr '\n' ' ')"
        return 1
    fi

    # Test current health
    local current_health=$(get_server_health "$server")

    case "$current_health" in
        "healthy")
            if [[ "$FORCE_RESTART" != "true" ]]; then
                log_warning "Server $server appears healthy"
                log_info "Current status: $current_health"
                log_info "Use --force to restart anyway, or run health check:"
                log_info "  /mcp-server-management --operation=health-check --server_name=$server"
                return 1
            else
                log_info "Forcing restart of healthy server $server"
            fi
            ;;
        "degraded")
            log_warning "Server $server is degraded - restart recommended"
            ;;
        "failed")
            log_info "Server $server has failed - restart required"
            ;;
        *)
            log_warning "Server $server status unknown - proceeding with restart"
            ;;
    esac

    return 0
}

# Get server configuration for re-adding
get_server_config() {
    local server="$1"

    case "$server" in
        "atlassian")
            echo "claude mcp add --transport http atlassian https://mcp.atlassian.com/v1/sse"
            ;;
        "glean-tools")
            echo "claude mcp add --transport http glean-tools https://zillow-be.glean.com/mcp/default"
            ;;
        "serena")
            echo "claude mcp add serena -- serena-mcp-server"
            ;;
        "gitlab-sidekick")
            echo "claude mcp add gitlab-sidekick -- gitlab-sidekick-mcp-server"
            ;;
        "databricks")
            echo "claude mcp add databricks -- databricks-mcp-server"
            ;;
        "datadog-production")
            echo "claude mcp add datadog-production -- datadog-production-mcp-server"
            ;;
        "datadog-staging")
            echo "claude mcp add datadog-staging -- datadog-staging-mcp-server"
            ;;
        "context7")
            echo "claude mcp add context7 -- context7-mcp-server"
            ;;
        "chrome-devtools")
            echo "claude mcp add chrome-devtools -- chrome-devtools-mcp-server"
            ;;
        *)
            return 1
            ;;
    esac
}

# Perform server restart
restart_server() {
    local server="$1"
    local config_command

    log_info "Starting restart process for $server..."

    # Get current configuration
    log_info "Backing up current configuration..."
    local current_config
    current_config=$(claude mcp get "$server" 2>/dev/null) || true

    if [[ -z "$current_config" ]]; then
        log_error "Unable to backup current configuration for $server"
        return 1
    fi

    # Step 1: Remove server
    log_info "Removing server $server..."
    if ! claude mcp remove "$server" --force >/dev/null 2>&1; then
        log_warning "Server removal had issues, but continuing..."
    fi

    # Step 2: Wait for cleanup
    log_info "Waiting ${WAIT_TIME}s for cleanup..."
    sleep "$WAIT_TIME"

    # Step 3: Re-add server
    log_info "Re-adding server $server..."
    config_command=$(get_server_config "$server")

    if [[ -z "$config_command" ]]; then
        log_error "No automatic configuration available for $server"
        log_error "Manual restart required. Current config was:"
        echo "$current_config"
        return 1
    fi

    # Execute the configuration command
    if eval "$config_command" >/dev/null 2>&1; then
        log_success "Server $server re-added successfully"
    else
        log_error "Failed to re-add server $server"
        log_info "You may need to manually re-configure the server"
        log_info "Previous config: $current_config"
        return 1
    fi

    return 0
}

# Post-restart verification
verify_restart() {
    local server="$1"
    local max_wait=30
    local wait_interval=2
    local elapsed=0

    log_info "Verifying restart success for $server..."

    # Wait for server to be available
    while [[ $elapsed -lt $max_wait ]]; do
        if test_mcp_server "$server" 5; then
            log_success "Server $server is responding after ${elapsed}s"
            break
        fi

        sleep $wait_interval
        elapsed=$((elapsed + wait_interval))

        if [[ $((elapsed % 6)) -eq 0 ]]; then
            log_info "Still waiting for $server to respond... (${elapsed}/${max_wait}s)"
        fi
    done

    if [[ $elapsed -ge $max_wait ]]; then
        log_error "Server $server not responding after ${max_wait}s"
        return 1
    fi

    # Additional health verification
    sleep 2
    local post_health=$(get_server_health "$server")
    local response_time=$(get_server_response_time "$server")

    log_info "Post-restart health check:"
    log_info "  Status: $post_health"
    log_info "  Response time: ${response_time}ms"

    # Check for immediate errors in debug log
    local immediate_errors=$(tail -10 "$DEBUG_LOG_PATH" 2>/dev/null | grep -c "MCP server \"$server\".*Error" || echo "0")

    if [[ $immediate_errors -gt 0 ]]; then
        log_warning "Detected $immediate_errors errors immediately after restart"
        log_info "Recent errors:"
        tail -10 "$DEBUG_LOG_PATH" | grep "MCP server \"$server\".*Error" || true
        return 1
    fi

    case "$post_health" in
        "healthy")
            log_success "Server $server restart completed successfully"
            ;;
        "degraded")
            log_warning "Server $server restarted but showing degraded performance"
            log_info "Monitor the server and consider manual investigation"
            ;;
        "failed")
            log_error "Server $server restart failed - server not functional"
            return 1
            ;;
        *)
            log_warning "Server $server restart status unclear"
            return 1
            ;;
    esac

    return 0
}

# Show recovery suggestions if restart fails
show_recovery_suggestions() {
    local server="$1"

    log_error "Restart of $server failed. Recovery suggestions:"
    echo
    echo "1. Manual restart via Claude Code:"
    echo "   - Remove: claude mcp remove $server --force"
    echo "   - Re-add: $(get_server_config "$server")"
    echo
    echo "2. Check Claude Code debug log:"
    echo "   tail -50 ~/.claude/debug/latest | grep -i $server"
    echo
    echo "3. Use fallback mechanisms:"
    suggest_fallback "$server"
    echo
    echo "4. Verify system dependencies:"
    echo "   - Network connectivity"
    echo "   - Authentication tokens"
    echo "   - Required binaries/packages"
}

# Main function
main() {
    parse_args "$@"

    # Check dependencies
    if ! check_dependencies; then
        exit 1
    fi

    # Validate server name
    if ! validate_server "$SERVER_NAME"; then
        exit 1
    fi

    log_info "MCP Server Restart: $SERVER_NAME"
    echo "Force restart: $FORCE_RESTART"
    echo "Verify health: $VERIFY_HEALTH"
    echo "Wait time: ${WAIT_TIME}s"
    echo

    # Pre-restart checks
    if ! pre_restart_check "$SERVER_NAME"; then
        exit 1
    fi

    echo
    log_info "Proceeding with restart..."

    # Perform restart
    if restart_server "$SERVER_NAME"; then
        echo
        log_success "Restart operation completed for $SERVER_NAME"

        # Verify if requested
        if [[ "$VERIFY_HEALTH" == "true" ]]; then
            echo
            if verify_restart "$SERVER_NAME"; then
                log_success "Server $SERVER_NAME is fully operational"
                exit 0
            else
                log_error "Post-restart verification failed"
                show_recovery_suggestions "$SERVER_NAME"
                exit 1
            fi
        else
            log_info "Skipping health verification (--no-verify specified)"
            log_info "Run health check manually: /mcp-server-management --operation=health-check --server_name=$SERVER_NAME"
            exit 0
        fi
    else
        echo
        log_error "Failed to restart server $SERVER_NAME"
        show_recovery_suggestions "$SERVER_NAME"
        exit 1
    fi
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi