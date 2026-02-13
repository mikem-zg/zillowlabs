#!/bin/bash

# Investigation Health Check Utility - MCP server validation for support investigations
# Ensures all required MCP servers are operational before starting multi-tool investigations

# Set strict error handling
set -euo pipefail

# Source MCP resilience utilities with error handling
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -f "$SCRIPT_DIR/../../mcp-server-management/scripts/mcp-resilience-utils.sh" ]]; then
    # Temporarily disable strict mode for sourcing
    set +e
    source "$SCRIPT_DIR/../../mcp-server-management/scripts/mcp-resilience-utils.sh" 2>/dev/null
    source_result=$?
    set -e

    if [[ $source_result -ne 0 ]]; then
        echo "Warning: Could not source MCP resilience utilities"
        # Define fallback logging functions
        log_info() { echo "ℹ️ $*"; }
        log_success() { echo "✅ $*"; }
        log_error() { echo "❌ $*"; }
        log_warning() { echo "⚠️ $*"; }
    fi
else
    echo "Warning: MCP resilience utilities not found"
    # Define fallback logging functions
    log_info() { echo "ℹ️ $*"; }
    log_success() { echo "✅ $*"; }
    log_error() { echo "❌ $*"; }
    log_warning() { echo "⚠️ $*"; }
fi

# Investigation MCP servers configuration
INVESTIGATION_MCP_SERVERS=(
    "atlassian"
    "glean-tools"
    "datadog-production"
    "datadog-staging"
    "databricks"
    "gitlab-sidekick"
)

# Fallback tools availability
FALLBACK_TOOLS=(
    "acli:Atlassian CLI"
    "glab:GitLab CLI"
    "jq:JSON processor"
    "curl:HTTP client"
)

# Perform comprehensive investigation health check
# Usage: perform_investigation_health_check [issue_context]
perform_investigation_health_check() {
    local issue_context="${1:-general}"

    log_info "🏥 Investigation Health Check - Context: $issue_context"
    echo ""

    local mcp_servers_status=()
    local unhealthy_servers=()
    local fallback_available=()
    local fallback_unavailable=()

    # Phase 1: Check MCP server health
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Phase 1: MCP Server Health Assessment"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    for server in "${INVESTIGATION_MCP_SERVERS[@]}"; do
        echo -n "Checking $server... "
        if test_mcp_server "$server" 5; then
            echo "✅ Healthy"
            mcp_servers_status+=("$server:healthy")
        else
            echo "❌ Unhealthy"
            mcp_servers_status+=("$server:unhealthy")
            unhealthy_servers+=("$server")
        fi
    done

    # Phase 2: Check fallback tool availability
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Phase 2: Fallback Tools Assessment"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    for tool_info in "${FALLBACK_TOOLS[@]}"; do
        IFS=':' read -r tool_cmd tool_desc <<< "$tool_info"
        echo -n "Checking $tool_desc ($tool_cmd)... "
        if command -v "$tool_cmd" >/dev/null 2>&1; then
            echo "✅ Available"
            fallback_available+=("$tool_info")
        else
            echo "❌ Not available"
            fallback_unavailable+=("$tool_info")
        fi
    done

    # Phase 3: Generate investigation readiness report
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Phase 3: Investigation Readiness Assessment"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    local healthy_count=$((${#INVESTIGATION_MCP_SERVERS[@]} - ${#unhealthy_servers[@]}))
    local readiness_score=$((healthy_count * 100 / ${#INVESTIGATION_MCP_SERVERS[@]}))

    echo "📊 Investigation Readiness Score: $readiness_score%"
    echo "   Healthy MCP servers: $healthy_count/${#INVESTIGATION_MCP_SERVERS[@]}"
    echo "   Available fallbacks: ${#fallback_available[@]}/${#FALLBACK_TOOLS[@]}"
    echo ""

    # Determine investigation strategy based on health
    if [[ ${#unhealthy_servers[@]} -eq 0 ]]; then
        log_success "✅ All MCP servers healthy - full investigation capability"
        echo ""
        echo "🎯 Recommended approach:"
        echo "   • Use primary MCP tools for optimal efficiency"
        echo "   • Leverage cross-server data correlation"
        echo "   • Full automation available"
        return 0
    elif [[ $readiness_score -ge 60 ]]; then
        log_warning "⚠️ Some MCP servers unhealthy - hybrid approach recommended"
        echo ""
        echo "🎯 Recommended approach:"
        echo "   • Use healthy MCP servers where possible"
        echo "   • Apply fallback mechanisms for unhealthy servers"
        echo "   • Manual verification may be required"

        provide_hybrid_investigation_guidance "$issue_context" "${unhealthy_servers[@]}"
        return 1
    else
        log_error "🚨 Major MCP server issues - fallback-only investigation"
        echo ""
        echo "🎯 Recommended approach:"
        echo "   • Rely primarily on CLI fallback tools"
        echo "   • Manual investigation steps required"
        echo "   • Consider MCP server recovery before proceeding"

        provide_fallback_investigation_guidance "$issue_context"
        return 2
    fi
}

# Provide guidance for hybrid investigation approach
provide_hybrid_investigation_guidance() {
    local issue_context="$1"
    shift
    local unhealthy_servers=("$@")

    echo ""
    echo "🔧 Hybrid Investigation Strategy"
    echo ""

    for server in "${unhealthy_servers[@]}"; do
        case "$server" in
            "atlassian")
                echo "• Atlassian MCP unavailable → Use acli CLI fallback:"
                echo "  - Jira: acli jira issue get ISSUE-KEY"
                echo "  - Confluence: acli confluence page get --id PAGE_ID"
                ;;
            "glean-tools")
                echo "• Glean MCP unavailable → Use direct web access:"
                echo "  - Navigate to internal documentation manually"
                echo "  - Use alternative search methods"
                ;;
            "datadog-production"|"datadog-staging")
                echo "• Datadog MCP unavailable → Use web interface:"
                echo "  - Direct dashboard access via browser"
                echo "  - Manual log analysis in Datadog UI"
                ;;
            "databricks")
                echo "• Databricks MCP unavailable → Use direct SQL access:"
                echo "  - Connect via databricks CLI"
                echo "  - Use web SQL editor for queries"
                ;;
            "gitlab-sidekick")
                echo "• GitLab MCP unavailable → Use glab CLI:"
                echo "  - glab pipeline list --project PROJECT"
                echo "  - glab mr view MR_ID"
                ;;
        esac
        echo ""
    done
}

# Provide guidance for fallback-only investigation
provide_fallback_investigation_guidance() {
    local issue_context="$1"

    echo ""
    echo "🛠️ Fallback-Only Investigation Tools"
    echo ""

    case "$issue_context" in
        "jira"|"issue"|"bug")
            echo "Jira Investigation Fallback:"
            echo "• acli jira issue get ISSUE-KEY"
            echo "• acli jira search --jql 'project = PROJECT'"
            echo "• Browser: https://fub.atlassian.net"
            ;;
        "pipeline"|"ci"|"deployment")
            echo "Pipeline Investigation Fallback:"
            echo "• glab pipeline list --project fub/fub"
            echo "• glab ci trace --job-id JOB_ID"
            echo "• Browser: https://gitlab.com/fub/fub/-/pipelines"
            ;;
        "performance"|"monitoring"|"logs")
            echo "Monitoring Investigation Fallback:"
            echo "• Browser: https://app.datadoghq.com"
            echo "• Direct log analysis via web interface"
            echo "• Manual metric correlation"
            ;;
        *)
            echo "General Investigation Fallback:"
            echo "• Use direct web interfaces"
            echo "• Apply available CLI tools"
            echo "• Manual data correlation required"
            ;;
    esac
    echo ""
}

# Attempt automated MCP server recovery
attempt_mcp_recovery() {
    local servers_to_recover=("$@")

    if [[ ${#servers_to_recover[@]} -eq 0 ]]; then
        log_info "No servers specified for recovery"
        return 0
    fi

    log_info "🔄 Attempting automated MCP server recovery"
    echo ""

    local recovered_servers=()
    local failed_recovery=()

    for server in "${servers_to_recover[@]}"; do
        echo "Recovering $server..."
        if restart_mcp_server "$server"; then
            echo "✅ $server recovery successful"
            recovered_servers+=("$server")
        else
            echo "❌ $server recovery failed"
            failed_recovery+=("$server")
        fi
    done

    echo ""
    log_info "Recovery Summary:"
    echo "   Successful: ${#recovered_servers[@]} servers"
    echo "   Failed: ${#failed_recovery[@]} servers"

    if [[ ${#failed_recovery[@]} -gt 0 ]]; then
        echo ""
        log_warning "Manual recovery required for: ${failed_recovery[*]}"
        echo "Try: /mcp-server-management --operation=restart --server=SERVER_NAME"
    fi

    return $([[ ${#failed_recovery[@]} -eq 0 ]])
}

# Context-aware investigation setup
setup_investigation_context() {
    local issue_type="$1"
    local issue_id="${2:-}"

    echo ""
    echo "🎯 Setting up investigation context for: $issue_type"
    if [[ -n "$issue_id" ]]; then
        echo "   Issue ID: $issue_id"
    fi
    echo ""

    # Determine required MCP servers based on context
    local required_servers=()

    case "$issue_type" in
        "jira"|"bug"|"feature")
            required_servers=("atlassian" "glean-tools")
            ;;
        "pipeline"|"ci"|"deployment")
            required_servers=("gitlab-sidekick" "datadog-production")
            ;;
        "performance"|"monitoring")
            required_servers=("datadog-production" "datadog-staging" "databricks")
            ;;
        "data"|"analytics")
            required_servers=("databricks" "datadog-production")
            ;;
        *)
            required_servers=("${INVESTIGATION_MCP_SERVERS[@]}")
            ;;
    esac

    echo "Required MCP servers for this investigation:"
    for server in "${required_servers[@]}"; do
        echo "   • $server"
    done
    echo ""

    # Check health of required servers specifically
    local unhealthy_required=()
    for server in "${required_servers[@]}"; do
        if ! test_mcp_server "$server" 3; then
            unhealthy_required+=("$server")
        fi
    done

    if [[ ${#unhealthy_required[@]} -gt 0 ]]; then
        log_warning "⚠️ Required servers unhealthy: ${unhealthy_required[*]}"
        echo ""
        echo -n "Attempt recovery? [y/N]: "
        read -r recovery_choice

        if [[ "$recovery_choice" =~ ^[Yy]$ ]]; then
            attempt_mcp_recovery "${unhealthy_required[@]}"
        else
            log_info "Proceeding with fallback tools for unhealthy servers"
        fi
    else
        log_success "✅ All required servers are healthy"
    fi
}

# Generate investigation readiness report
generate_readiness_report() {
    local output_format="${1:-text}"

    case "$output_format" in
        "json")
            echo "{"
            echo "  \"timestamp\": \"$(date -Iseconds)\","
            echo "  \"mcp_servers\": ["
            for i in "${!INVESTIGATION_MCP_SERVERS[@]}"; do
                local server="${INVESTIGATION_MCP_SERVERS[$i]}"
                local comma=$([[ $i -eq $((${#INVESTIGATION_MCP_SERVERS[@]} - 1)) ]] && echo "" || echo ",")
                local status=$(test_mcp_server "$server" 3 && echo "healthy" || echo "unhealthy")
                echo "    {\"name\": \"$server\", \"status\": \"$status\"}$comma"
            done
            echo "  ],"
            echo "  \"fallback_tools\": ["
            for i in "${!FALLBACK_TOOLS[@]}"; do
                IFS=':' read -r tool_cmd tool_desc <<< "${FALLBACK_TOOLS[$i]}"
                local comma=$([[ $i -eq $((${#FALLBACK_TOOLS[@]} - 1)) ]] && echo "" || echo ",")
                local available=$(command -v "$tool_cmd" >/dev/null 2>&1 && echo "true" || echo "false")
                echo "    {\"command\": \"$tool_cmd\", \"description\": \"$tool_desc\", \"available\": $available}$comma"
            done
            echo "  ]"
            echo "}"
            ;;
        *)
            perform_investigation_health_check "general"
            ;;
    esac
}

# Interactive investigation setup wizard
interactive_investigation_setup() {
    echo ""
    echo "🧙 Investigation Setup Wizard"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Step 1: Determine investigation type
    echo "What type of investigation are you conducting?"
    echo "1) Jira issue/bug investigation"
    echo "2) CI/CD pipeline problem"
    echo "3) Performance/monitoring issue"
    echo "4) Data analytics investigation"
    echo "5) General support investigation"
    echo ""
    echo -n "Choose (1-5): "
    read -r investigation_choice

    local investigation_type
    case "$investigation_choice" in
        1) investigation_type="jira" ;;
        2) investigation_type="pipeline" ;;
        3) investigation_type="performance" ;;
        4) investigation_type="data" ;;
        5) investigation_type="general" ;;
        *) investigation_type="general" ;;
    esac

    # Step 2: Get issue identifier if applicable
    local issue_id=""
    if [[ "$investigation_type" != "general" ]]; then
        echo ""
        echo -n "Enter issue ID (optional): "
        read -r issue_id
    fi

    # Step 3: Perform health check and setup
    echo ""
    setup_investigation_context "$investigation_type" "$issue_id"

    # Step 4: Provide next steps
    echo ""
    echo "🎯 Next Steps:"
    case "$investigation_type" in
        "jira")
            echo "   • Use /jira-management or /confluence-management skills"
            echo "   • Search for related issues and documentation"
            ;;
        "pipeline")
            echo "   • Use /gitlab-pipeline-monitoring skill"
            echo "   • Check recent pipeline failures and logs"
            ;;
        "performance")
            echo "   • Use /datadog-management skill"
            echo "   • Analyze metrics, logs, and dashboards"
            ;;
        "data")
            echo "   • Use /databricks-analytics skill"
            echo "   • Execute diagnostic queries and analyze data"
            ;;
        *)
            echo "   • Use appropriate skills based on investigation needs"
            echo "   • Leverage available tools for data gathering"
            ;;
    esac
}

# Main function for command-line usage
main() {
    local operation="${1:-check}"
    local context="${2:-general}"

    case "$operation" in
        "check"|"health")
            perform_investigation_health_check "$context"
            ;;
        "setup")
            setup_investigation_context "$context" "${3:-}"
            ;;
        "recover"|"recovery")
            shift
            attempt_mcp_recovery "$@"
            ;;
        "report")
            local format="${3:-text}"
            generate_readiness_report "$format"
            ;;
        "interactive"|"wizard")
            interactive_investigation_setup
            ;;
        *)
            echo "Usage: $0 {check|setup|recover|report|interactive} [context] [args...]"
            echo ""
            echo "Operations:"
            echo "  check        - Perform investigation health check (default)"
            echo "  setup        - Set up investigation context for specific issue type"
            echo "  recover      - Attempt recovery of unhealthy MCP servers"
            echo "  report       - Generate readiness report (text|json)"
            echo "  interactive  - Interactive investigation setup wizard"
            echo ""
            echo "Contexts: jira, pipeline, performance, data, general"
            return 1
            ;;
    esac
}

# Export functions for use by other scripts
export -f perform_investigation_health_check setup_investigation_context
export -f attempt_mcp_recovery generate_readiness_report provide_hybrid_investigation_guidance

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi