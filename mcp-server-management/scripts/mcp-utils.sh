#!/bin/bash

# MCP Server Management Utility Functions
# Common functions for MCP server operations and health monitoring

# Set strict error handling
set -euo pipefail

# Global configuration
MCP_HEALTH_TIMEOUT=10
MCP_RESTART_TIMEOUT=30
DEBUG_LOG_PATH="$HOME/.claude/debug/latest"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Get list of configured MCP servers
get_mcp_servers() {
    claude mcp list 2>/dev/null | awk '{print $1}' | grep -v '^$' || true
}

# Test basic MCP server connectivity
test_mcp_server() {
    local server_name="$1"
    local timeout="${2:-$MCP_HEALTH_TIMEOUT}"

    if timeout "$timeout" claude mcp get "$server_name" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Get server response time in milliseconds
get_server_response_time() {
    local server_name="$1"
    local start_time end_time response_time_ms

    start_time=$(date +%s%N)

    if timeout "$MCP_HEALTH_TIMEOUT" claude mcp get "$server_name" >/dev/null 2>&1; then
        end_time=$(date +%s%N)
        response_time_ms=$(( (end_time - start_time) / 1000000 ))
        echo "$response_time_ms"
        return 0
    else
        echo "-1"
        return 1
    fi
}

# Count recent errors for a specific server
count_server_errors() {
    local server_name="$1"
    local since_hours="${2:-1}"

    if [[ ! -f "$DEBUG_LOG_PATH" ]]; then
        echo "0"
        return 0
    fi

    # Count errors in the last N hours
    local since_time=$(date -d "$since_hours hours ago" "+%Y-%m-%dT%H:%M:%S" 2>/dev/null || date -v-${since_hours}H "+%Y-%m-%dT%H:%M:%S")

    grep "MCP server \"$server_name\"" "$DEBUG_LOG_PATH" 2>/dev/null | \
    awk -v since="$since_time" '$1 " " $2 >= since' | \
    grep -c -E "(Failed|Error|timeout)" || echo "0"
}

# Check if server has recent tool filtering warnings
has_tool_filtering_warnings() {
    local server_name="$1"

    if [[ ! -f "$DEBUG_LOG_PATH" ]]; then
        return 1
    fi

    grep "Filtering out tool_reference for unavailable tool: mcp__${server_name}__" "$DEBUG_LOG_PATH" >/dev/null 2>&1
}

# Get server health status
get_server_health() {
    local server_name="$1"
    local response_time error_count

    # Test basic connectivity
    if ! test_mcp_server "$server_name" 5; then
        echo "failed"
        return 0
    fi

    # Check response time
    response_time=$(get_server_response_time "$server_name")

    # Check for recent errors
    error_count=$(count_server_errors "$server_name" 1)

    # Check for tool filtering warnings
    if has_tool_filtering_warnings "$server_name"; then
        echo "degraded"
        return 0
    fi

    # Determine health status
    if [[ $error_count -gt 3 ]] || [[ $response_time -gt 5000 ]]; then
        echo "degraded"
    elif [[ $response_time -gt 0 ]]; then
        echo "healthy"
    else
        echo "failed"
    fi
}

# Restart MCP server using claude mcp commands
restart_mcp_server() {
    local server_name="$1"
    local force="${2:-false}"

    log_info "Restarting MCP server: $server_name"

    # Check if server is actually down (unless forced)
    if [[ "$force" != "true" ]] && test_mcp_server "$server_name" 5; then
        log_warning "Server $server_name appears healthy - use --force_restart=true to restart anyway"
        return 0
    fi

    # Get current server configuration
    local current_config
    current_config=$(claude mcp get "$server_name" 2>/dev/null) || true

    if [[ -z "$current_config" ]]; then
        log_error "Cannot restart $server_name - no configuration found"
        return 1
    fi

    # Remove server
    log_info "Removing $server_name..."
    if ! claude mcp remove "$server_name" --force >/dev/null 2>&1; then
        log_warning "Failed to remove $server_name cleanly"
    fi

    sleep 2

    # Re-add server based on known configurations
    log_info "Re-adding $server_name..."
    case "$server_name" in
        "atlassian")
            claude mcp add --transport http atlassian https://mcp.atlassian.com/v1/sse
            ;;
        "glean-tools")
            claude mcp add --transport http glean-tools https://zillow-be.glean.com/mcp/default
            ;;
        *)
            log_error "Automatic restart not implemented for $server_name - manual intervention required"
            return 1
            ;;
    esac

    # Verify restart success
    sleep 3
    if timeout "$MCP_RESTART_TIMEOUT" claude mcp get "$server_name" >/dev/null 2>&1; then
        log_success "Successfully restarted $server_name"
        return 0
    else
        log_error "Failed to restart $server_name - server not responding"
        return 1
    fi
}

# Suggest fallback for a failed server
suggest_fallback() {
    local server_name="$1"
    local operation="${2:-general}"

    case "$server_name" in
        "atlassian")
            log_info "Atlassian MCP unavailable - suggested fallbacks:"
            echo "  Jira operations: acli jira get-issue ZYN-12345"
            echo "  Confluence: acli confluence get-content --title 'Page Title'"
            echo "  Search: acli jira search --jql 'project = ZYN AND status = Open'"
            ;;
        "gitlab-sidekick")
            log_info "GitLab Sidekick MCP unavailable - suggested fallbacks:"
            echo "  MR operations: glab mr view 12345"
            echo "  Pipeline logs: glab ci trace --job-id 84825710"
            echo "  Issue search: glab issue list --state=opened"
            ;;
        "serena")
            log_info "Serena MCP unavailable - suggested fallbacks:"
            echo "  File search: find . -name '*.php' | grep -E 'EmailParser|Controller'"
            echo "  Code search: grep -r 'function parseEmail' apps/richdesk/"
            echo "  Symbol navigation: Use IDE or direct file browsing"
            ;;
        "datadog-production"|"datadog-staging")
            log_info "Datadog MCP unavailable - suggested fallbacks:"
            echo "  Log search: datadog logs --query 'service:fub error' --from '1h'"
            echo "  Metrics: datadog metric list --tags 'environment:production'"
            echo "  Direct API: curl -H 'DD-API-KEY: \$DD_API_KEY' 'https://api.datadoghq.com/api/v1/logs-queries/list'"
            ;;
        "databricks")
            log_info "Databricks MCP unavailable - suggested fallbacks:"
            echo "  Direct SQL: Use Databricks SQL editor or CLI"
            echo "  API access: Use databricks CLI or REST API"
            ;;
        "glean-tools")
            log_info "Glean Tools MCP unavailable - suggested fallbacks:"
            echo "  Manual search: Use Glean web interface"
            echo "  Documentation: Check Confluence or internal wikis"
            ;;
        *)
            log_warning "No specific fallback configured for $server_name"
            echo "Consider using alternative tools or direct API access"
            ;;
    esac
}

# Generate JSON health report for a server
generate_server_report() {
    local server_name="$1"
    local health response_time error_count

    health=$(get_server_health "$server_name")
    response_time=$(get_server_response_time "$server_name")
    error_count=$(count_server_errors "$server_name" 24)

    cat << EOF
{
  "server": "$server_name",
  "health": "$health",
  "response_time_ms": $response_time,
  "recent_errors_24h": $error_count,
  "last_checked": "$(date -Iseconds)",
  "has_tool_warnings": $(has_tool_filtering_warnings "$server_name" && echo "true" || echo "false")
}
EOF
}

# Check if all required commands are available
check_dependencies() {
    local missing_deps=()

    if ! command_exists "claude"; then
        missing_deps+=("claude")
    fi

    if ! command_exists "jq"; then
        missing_deps+=("jq")
    fi

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_error "Missing required dependencies: ${missing_deps[*]}"
        log_info "Please install missing dependencies before using MCP server management"
        return 1
    fi

    return 0
}

# Export functions for use in other scripts
export -f log_info log_success log_warning log_error
export -f command_exists get_mcp_servers test_mcp_server
export -f get_server_response_time count_server_errors has_tool_filtering_warnings
export -f get_server_health restart_mcp_server suggest_fallback
export -f generate_server_report check_dependencies