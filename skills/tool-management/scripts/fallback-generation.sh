#!/bin/bash

# Fallback Generation - Intelligent fallback chain generation and alternatives
# Provides context-aware alternative suggestions when tools are unavailable

# Set strict error handling
set -euo pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" && pwd)"
source "$SCRIPT_DIR/tool-utils.sh"

# Fallback chain generation
get_fallback_chain() {
    local operation_context="$1"
    local failed_tool="${2:-}"

    log_info "Generating fallback chain for: $operation_context"

    case "$operation_context" in
        # Jira Operations
        "jira-search"|"jira-get"|"jira-create"|"jira-update"|"jira-"*)
            echo "atlassian.searchJiraIssuesUsingJql → acli jira list → browser:https://zillowgroup.atlassian.net"
            ;;

        # Confluence Operations
        "confluence-search"|"confluence-get"|"confluence-create"|"confluence-update"|"confluence-"*)
            echo "atlassian.getConfluencePage → chrome_devtools.navigate → browser:https://zillowgroup.atlassian.net/wiki"
            ;;

        # GitLab Operations
        "gitlab-mr-search"|"gitlab-mr-create"|"gitlab-mr-analysis"|"gitlab-pipeline"|"gitlab-"*)
            echo "gitlab-sidekick.gitlab_mrOverview → glab mr list → browser:https://gitlab.zgtools.net"
            ;;

        # Code Analysis Operations
        "code-analysis"|"semantic-search"|"symbol-navigation"|"code-"*)
            echo "serena-mcp → grep/find → manual_code_search"
            ;;

        # SQL and Database Operations
        "sql-query"|"data-analysis"|"databricks-query"|"database-"*)
            echo "databricks.execute_sql_query → mysql_client → adminer_web_ui"
            ;;

        # Documentation Operations
        "documentation-search"|"library-docs"|"api-reference"|"glean-"*)
            echo "glean.search → context7.query-docs → web_search"
            ;;

        # Browser Automation
        "browser-automation"|"web-testing"|"chrome-"*)
            echo "chrome-devtools → selenium_standalone → manual_testing"
            ;;

        # Datadog Operations
        "monitoring"|"logs-analysis"|"metrics"|"datadog-"*)
            echo "datadog-mcp → datadog_cli → datadog_web_ui"
            ;;

        # General Operations
        *)
            echo "primary_tool → cli_alternative → manual_workflow"
            ;;
    esac
}

# Generate intelligent alternatives based on context
suggest_alternatives() {
    local operation_context="$1"
    local failed_tool_category="${2:-}"
    local failed_tool_name="${3:-}"

    log_info "Suggesting alternatives for $operation_context (failed: $failed_tool_category)"

    local alternatives=()

    case "$operation_context" in
        "jira-"*)
            if [[ "$failed_tool_category" == "mcp" ]]; then
                alternatives+=("🔧 CLI Alternative: acli jira list/view/create/update")
                alternatives+=("🌐 Web Alternative: https://zillowgroup.atlassian.net")
                alternatives+=("📖 Setup Guide: Run '/tool-management --operation=install-guidance --tool_name=acli'")
                alternatives+=("🔄 Recovery: Check '/tool-management --operation=health-check --tool_category=mcp'")
            elif [[ "$failed_tool_category" == "cli" ]]; then
                alternatives+=("🌐 Web Alternative: Use Jira web interface directly")
                alternatives+=("🔄 MCP Recovery: Check '/tool-management --operation=health-check --tool_category=mcp'")
                alternatives+=("🔧 Manual: Search and navigate issues manually in browser")
            fi
            ;;

        "confluence-"*)
            if [[ "$failed_tool_category" == "mcp" ]]; then
                alternatives+=("🌐 Web Alternative: https://zillowgroup.atlassian.net/wiki")
                alternatives+=("🤖 Browser Automation: Use chrome-devtools MCP for automated navigation")
                alternatives+=("🔄 Recovery: Restart Atlassian MCP server")
            fi
            ;;

        "gitlab-"*)
            if [[ "$failed_tool_category" == "mcp" ]]; then
                alternatives+=("🔧 CLI Alternative: glab mr list/view/create")
                alternatives+=("🌐 Web Alternative: https://gitlab.zgtools.net")
                alternatives+=("📖 Setup Guide: Run 'brew install glab && glab auth login'")
            elif [[ "$failed_tool_category" == "cli" ]]; then
                alternatives+=("🌐 Web Alternative: GitLab web interface")
                alternatives+=("🔄 Installation: Run '/tool-management --operation=install-guidance --tool_name=glab'")
            fi
            ;;

        "code-analysis"|"semantic-"*)
            if [[ "$failed_tool_category" == "mcp" ]]; then
                alternatives+=("🔍 CLI Alternative: grep -r 'pattern' . && find . -name '*.php'")
                alternatives+=("🛠️ IDE Alternative: Use VSCode/PhpStorm search and navigation")
                alternatives+=("📖 Recovery: Check serena-mcp server status and configuration")
                alternatives+=("🔧 Manual: Use file explorer and manual code reading")
            fi
            ;;

        "sql-query"|"databricks-"*)
            if [[ "$failed_tool_category" == "mcp" ]]; then
                alternatives+=("🔧 CLI Alternative: mysql/psql command line clients")
                alternatives+=("🌐 Web Alternative: Databricks web interface")
                alternatives+=("🛠️ GUI Alternative: MySQL Workbench, pgAdmin, or Adminer")
                alternatives+=("📖 Recovery: Check Databricks MCP connection and credentials")
            fi
            ;;

        "documentation-"*)
            if [[ "$failed_tool_category" == "mcp" ]]; then
                alternatives+=("🔍 Web Search: Use Google, official docs, GitHub")
                alternatives+=("📚 Context7 MCP: Try library documentation lookup")
                alternatives+=("🌐 Direct Access: Visit library/framework official documentation")
            fi
            ;;

        "monitoring"|"datadog-"*)
            if [[ "$failed_tool_category" == "mcp" ]]; then
                alternatives+=("🔧 CLI Alternative: datadog command line tool")
                alternatives+=("🌐 Web Alternative: Datadog web interface")
                alternatives+=("📊 Local Tools: Use local log analysis tools (grep, awk, jq)")
            fi
            ;;
    esac

    # Add general recovery suggestions
    alternatives+=("🔄 General Recovery: Run '/tool-management --operation=health-check --suggest_alternatives=true'")
    alternatives+=("🛠️ Tool Status: Check '/tool-management --operation=check-availability --tool_category=all'")

    printf '%s\n' "${alternatives[@]}"
}

# Generate comprehensive fallback strategy
generate_fallback_strategy() {
    local operation_context="$1"
    local primary_tools=("${@:2}")

    log_info "Generating comprehensive fallback strategy for: $operation_context"

    echo "=== Fallback Strategy for $operation_context ==="
    echo ""

    # Primary tools assessment
    echo "Primary Tools:"
    for tool in "${primary_tools[@]}"; do
        if validate_tool_availability "$tool"; then
            echo "  ✅ $tool - Available"
        else
            echo "  ❌ $tool - Unavailable"
        fi
    done
    echo ""

    # Fallback chain
    echo "Fallback Chain:"
    local chain
    chain=$(get_fallback_chain "$operation_context")
    echo "$chain" | sed 's/ → /\n  ↳ /g' | sed 's/^/  /'
    echo ""

    # Alternative suggestions
    echo "Alternative Options:"
    suggest_alternatives "$operation_context" "mcp" | head -5
    echo ""

    # Recovery recommendations
    echo "Recovery Steps:"
    echo "  1. Check tool availability: /tool-management --operation=check-availability"
    echo "  2. Validate authentication: /tool-management --operation=validate --validate_auth=true"
    echo "  3. Install missing tools: /tool-management --operation=install-guidance"
    echo "  4. Health check: /tool-management --operation=health-check --tool_category=all"
    echo ""
}

# Smart fallback selection based on context
select_best_fallback() {
    local operation_context="$1"
    local available_tools="$2"  # Space-separated list of available tools

    log_info "Selecting best fallback for $operation_context from available tools"

    # Convert available tools to array
    IFS=' ' read -ra available_array <<< "$available_tools"

    case "$operation_context" in
        "jira-"*)
            # Prefer MCP > CLI > Web
            for tool in "mcp:atlassian" "cli:acli" "manual:browser"; do
                if [[ " ${available_array[*]} " =~ " $tool " ]]; then
                    echo "$tool"
                    return 0
                fi
            done
            ;;

        "gitlab-"*)
            # Prefer MCP > CLI > Web
            for tool in "mcp:gitlab-sidekick" "cli:glab" "manual:browser"; do
                if [[ " ${available_array[*]} " =~ " $tool " ]]; then
                    echo "$tool"
                    return 0
                fi
            done
            ;;

        "code-analysis"*)
            # Prefer MCP > CLI tools > Manual
            for tool in "mcp:serena" "cli:grep" "cli:find" "manual:ide"; do
                if [[ " ${available_array[*]} " =~ " $tool " ]]; then
                    echo "$tool"
                    return 0
                fi
            done
            ;;

        *)
            # Return first available tool
            if [[ ${#available_array[@]} -gt 0 ]]; then
                echo "${available_array[0]}"
                return 0
            fi
            ;;
    esac

    echo "manual:fallback"
    return 1
}

# Validate tool availability for fallback selection
validate_tool_availability() {
    local tool_spec="$1"

    # Use the validation functions from tool-validation.sh
    source "$SCRIPT_DIR/tool-validation.sh"

    validate_tool "$tool_spec" "false" >/dev/null 2>&1
    return $?
}

# Generate context-specific installation priority
get_installation_priority() {
    local operation_context="$1"

    case "$operation_context" in
        "jira-"*)
            echo "1:mcp:atlassian 2:cli:acli 3:browser:extension"
            ;;
        "gitlab-"*)
            echo "1:mcp:gitlab-sidekick 2:cli:glab 3:browser:bookmark"
            ;;
        "code-analysis"*)
            echo "1:mcp:serena 2:cli:grep 2:cli:find 3:ide:vscode"
            ;;
        "sql-"*|"databricks-"*)
            echo "1:mcp:databricks 2:cli:mysql 2:cli:psql 3:gui:workbench"
            ;;
        "documentation-"*)
            echo "1:mcp:glean-tools 1:mcp:context7 2:web:search 3:local:docs"
            ;;
        *)
            echo "1:builtin:tools 2:cli:common 3:manual:workflow"
            ;;
    esac
}

# Interactive fallback selection
interactive_fallback_selection() {
    local operation_context="$1"
    local failed_tools=("${@:2}")

    echo "❌ The following tools failed for $operation_context:"
    for tool in "${failed_tools[@]}"; do
        echo "   - $tool"
    done
    echo ""

    echo "🔄 Available alternatives:"
    local chain
    chain=$(get_fallback_chain "$operation_context")
    echo "$chain" | sed 's/ → /\n/g' | nl -w2 -s'. '
    echo ""

    echo "📋 Suggested next steps:"
    suggest_alternatives "$operation_context" "mcp" | head -3 | nl -w2 -s'. '
    echo ""

    echo "🛠️  For automated recovery:"
    echo "   /tool-management --operation=health-check --operation_context=\"$operation_context\""
}

# Main execution function
main() {
    local operation="${1:-fallback-chain}"
    local operation_context="${2:-general}"
    local failed_tool="${3:-}"

    case "$operation" in
        "fallback-chain")
            get_fallback_chain "$operation_context" "$failed_tool"
            ;;
        "suggest-fallbacks")
            suggest_alternatives "$operation_context" "${failed_tool%%:*}" "${failed_tool#*:}"
            ;;
        "strategy")
            shift 2
            generate_fallback_strategy "$operation_context" "$@"
            ;;
        "select-best")
            shift 2
            select_best_fallback "$operation_context" "$*"
            ;;
        "priority")
            get_installation_priority "$operation_context"
            ;;
        "interactive")
            shift 2
            interactive_fallback_selection "$operation_context" "$@"
            ;;
        *)
            log_error "Unknown operation: $operation"
            echo "Usage: $0 {fallback-chain|suggest-fallbacks|strategy|select-best|priority|interactive} operation_context [args...]"
            return 1
            ;;
    esac
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]:-}" == "${0}" ]]; then
    main "$@"
fi