## Implementation Details and Supporting Scripts

### Supporting Scripts Architecture

The tool management functionality is implemented through comprehensive standalone scripts:

- `scripts/main-entrypoint.sh` - Main skill entry point and parameter parsing
- `scripts/tool-validation.sh` - Universal tool validation across all categories
- `scripts/fallback-generation.sh` - Intelligent fallback chain generation and alternatives
- `scripts/install-guidance.sh` - Installation and setup guidance for all tool types
- `scripts/health-monitoring.sh` - Continuous tool ecosystem health monitoring
- `scripts/integration-patterns.sh` - Standardized integration functions for other skills
- `scripts/tool-utils.sh` - Common utility functions for tool management operations

All scripts are located in the skill's `scripts/` directory and provide comprehensive tool management capabilities that can be executed independently or through the skill interface.

### Script Implementation Details

#### Main Entry Point (`main-entrypoint.sh`)
```bash
#!/bin/bash
# Main skill entry point with parameter parsing and operation routing

set -e

# Source utility functions
source "$(dirname "$0")/tool-utils.sh"

# Parse parameters
OPERATION="${1:-validate}"
TOOL_NAME="$2"
TOOL_CATEGORY="${3:-all}"
OPERATION_CONTEXT="$4"
SUGGEST_ALTERNATIVES="${5:-true}"
VALIDATE_AUTH="${6:-true}"

# Route to appropriate handler
case "$OPERATION" in
    "validate")
        source "$(dirname "$0")/tool-validation.sh"
        validate_tool "$TOOL_NAME" "$TOOL_CATEGORY" "$OPERATION_CONTEXT"
        ;;
    "check-availability")
        source "$(dirname "$0")/tool-validation.sh"
        check_tool_availability "$TOOL_CATEGORY" "$VALIDATE_AUTH"
        ;;
    "suggest-fallbacks")
        source "$(dirname "$0")/fallback-generation.sh"
        suggest_fallbacks "$TOOL_NAME" "$OPERATION_CONTEXT"
        ;;
    "health-check")
        source "$(dirname "$0")/health-monitoring.sh"
        perform_health_check "$TOOL_CATEGORY"
        ;;
    "install-guidance")
        source "$(dirname "$0")/install-guidance.sh"
        provide_install_guidance "$TOOL_NAME" "$TOOL_CATEGORY"
        ;;
    "fallback-chain")
        source "$(dirname "$0")/fallback-generation.sh"
        generate_fallback_chain "$OPERATION_CONTEXT" "$SUGGEST_ALTERNATIVES"
        ;;
    *)
        echo "❌ Unknown operation: $OPERATION"
        show_usage
        exit 1
        ;;
esac
```

#### Tool Validation Core (`tool-validation.sh`)
```bash
#!/bin/bash
# Universal tool validation across all categories

validate_mcp_tool() {
    local tool_name="$1"
    local server_name="${tool_name%.*}"

    # Check MCP server connectivity
    if ! claude mcp list | grep -q "$server_name"; then
        return 1
    fi

    # Test specific tool availability
    if ! claude mcp test "$tool_name" >/dev/null 2>&1; then
        return 1
    fi

    return 0
}

validate_cli_tool() {
    local tool_name="$1"
    local validate_auth="$2"

    # Check installation
    if ! command -v "$tool_name" >/dev/null 2>&1; then
        return 1
    fi

    # Check authentication if required
    if [[ "$validate_auth" == "true" ]]; then
        case "$tool_name" in
            "glab")
                glab auth status >/dev/null 2>&1 || return 1
                ;;
            "acli")
                acli auth status >/dev/null 2>&1 || return 1
                ;;
            "gh")
                gh auth status >/dev/null 2>&1 || return 1
                ;;
        esac
    fi

    return 0
}

validate_skill_tool() {
    local skill_name="$1"
    local skills_dir=".claude/skills"

    # Check skill directory exists
    if [[ ! -d "$skills_dir/$skill_name" ]]; then
        return 1
    fi

    # Check SKILL.md exists
    if [[ ! -f "$skills_dir/$skill_name/SKILL.md" ]]; then
        return 1
    fi

    # Validate skill dependencies
    validate_skill_dependencies "$skill_name"
}
```

#### Fallback Generation (`fallback-generation.sh`)
```bash
#!/bin/bash
# Intelligent fallback chain generation

generate_fallback_chain() {
    local operation_context="$1"
    local include_alternatives="$2"

    case "$operation_context" in
        "jira-"*)
            echo "Fallback chain for Jira operations:"
            echo "1. MCP: atlassian.getJiraIssue"
            echo "2. CLI: acli jira view"
            echo "3. Manual: Jira web interface"
            ;;
        "gitlab-"*)
            echo "Fallback chain for GitLab operations:"
            echo "1. MCP: gitlab-sidekick tools"
            echo "2. CLI: glab commands"
            echo "3. Manual: GitLab web interface"
            ;;
        "confluence-"*)
            echo "Fallback chain for Confluence operations:"
            echo "1. MCP: atlassian.getConfluencePage"
            echo "2. MCP: chrome-devtools automation"
            echo "3. Manual: Confluence web interface"
            ;;
        "database-"*)
            echo "Fallback chain for database operations:"
            echo "1. MCP: databricks.execute_sql_query"
            echo "2. CLI: mysql/psql clients"
            echo "3. Manual: Database web interfaces"
            ;;
        *)
            generate_generic_fallback_chain "$operation_context"
            ;;
    esac

    if [[ "$include_alternatives" == "true" ]]; then
        provide_installation_alternatives "$operation_context"
    fi
}

suggest_intelligent_fallback() {
    local failed_tool="$1"
    local operation_context="$2"

    # Analyze failure reason
    local failure_reason=$(determine_failure_reason "$failed_tool")

    # Suggest appropriate alternative based on context and failure
    case "$failure_reason" in
        "not_installed")
            provide_installation_guidance "$failed_tool"
            ;;
        "auth_failure")
            provide_authentication_guidance "$failed_tool"
            ;;
        "connectivity")
            suggest_connectivity_solutions "$failed_tool"
            ;;
        "permission")
            provide_permission_guidance "$failed_tool"
            ;;
    esac
}
```

#### Health Monitoring (`health-monitoring.sh`)
```bash
#!/bin/bash
# Continuous tool ecosystem health monitoring

perform_health_check() {
    local tool_category="$1"

    echo "🔍 Performing health check for $tool_category tools..."

    case "$tool_category" in
        "mcp"|"all")
            check_mcp_health
            ;;
        "cli"|"all")
            check_cli_health
            ;;
        "skill"|"all")
            check_skill_health
            ;;
    esac

    generate_health_report "$tool_category"
}

check_mcp_health() {
    echo "Checking MCP server health..."

    local mcp_servers=("atlassian" "serena" "databricks" "chrome-devtools" "glean")

    for server in "${mcp_servers[@]}"; do
        if claude mcp list | grep -q "$server"; then
            echo "✅ $server: Available"

            # Test connectivity
            if claude mcp test "$server" >/dev/null 2>&1; then
                echo "✅ $server: Responsive"
            else
                echo "⚠️ $server: Connection issues"
            fi
        else
            echo "❌ $server: Not configured"
        fi
    done
}

check_cli_health() {
    echo "Checking CLI tool health..."

    local cli_tools=("glab" "acli" "git" "mysql" "gh" "docker" "mutagen")

    for tool in "${cli_tools[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            echo "✅ $tool: Installed"

            # Check version
            local version
            case "$tool" in
                "glab")
                    version=$(glab version 2>/dev/null | head -n1)
                    ;;
                "acli")
                    version=$(acli version 2>/dev/null)
                    ;;
                *)
                    version=$($tool --version 2>/dev/null | head -n1)
                    ;;
            esac

            if [[ -n "$version" ]]; then
                echo "📋 $tool: $version"
            fi

            # Check authentication where applicable
            check_tool_authentication "$tool"
        else
            echo "❌ $tool: Not installed"
        fi
    done
}

monitor_tool_performance() {
    local tool="$1"
    local operation="$2"

    local start_time=$(date +%s%N)

    # Execute operation
    case "$tool" in
        "mcp_"*)
            execute_mcp_operation "$tool" "$operation"
            ;;
        *)
            execute_cli_operation "$tool" "$operation"
            ;;
    esac

    local end_time=$(date +%s%N)
    local duration=$(( (end_time - start_time) / 1000000 ))  # Convert to milliseconds

    log_performance_metric "$tool" "$operation" "$duration"
}
```

#### Installation Guidance (`install-guidance.sh`)
```bash
#!/bin/bash
# Installation and setup guidance

provide_install_guidance() {
    local tool_name="$1"
    local tool_category="$2"

    echo "📦 Installation guidance for $tool_name"

    case "$tool_name" in
        "glab")
            echo "GitLab CLI installation:"
            echo "  macOS: brew install glab"
            echo "  Linux: curl -s https://raw.githubusercontent.com/profclems/glab/main/scripts/install.sh | bash"
            echo "  Auth: glab auth login"
            ;;
        "acli")
            echo "Atlassian CLI installation:"
            echo "  macOS: brew install atlassian-labs/acli/acli"
            echo "  Manual: Download from https://github.com/atlassian-labs/atlassian-cli"
            echo "  Auth: acli auth login"
            ;;
        "mysql")
            echo "MySQL client installation:"
            echo "  macOS: brew install mysql-client"
            echo "  Linux: apt-get install mysql-client"
            echo "  Config: Set up connection string"
            ;;
        "docker")
            echo "Docker installation:"
            echo "  macOS: brew install --cask docker"
            echo "  Linux: curl -fsSL https://get.docker.com | sh"
            echo "  Setup: Start Docker Desktop"
            ;;
        *)
            provide_generic_install_guidance "$tool_name" "$tool_category"
            ;;
    esac

    # Provide verification steps
    echo ""
    echo "🔍 Verification steps:"
    echo "  1. Run: command -v $tool_name"
    echo "  2. Test: $tool_name --version"
    echo "  3. Validate: /tool-management --operation=validate --tool_name=$tool_name"
}
```

### Utility Functions (`tool-utils.sh`)

```bash
#!/bin/bash
# Common utility functions

log_tool_event() {
    local event_type="$1"
    local tool_name="$2"
    local message="$3"

    local timestamp=$(date -Iseconds)
    echo "[$timestamp] $event_type: $tool_name - $message" >> ".claude/logs/tool-management.log"
}

cache_tool_status() {
    local tool_name="$1"
    local status="$2"
    local cache_file=".claude/cache/tool-status.json"

    # Update cache with tool status
    jq --arg tool "$tool_name" --arg status "$status" --arg timestamp "$(date -Iseconds)" \
        '.[$tool] = {status: $status, timestamp: $timestamp}' "$cache_file" > "$cache_file.tmp" && \
        mv "$cache_file.tmp" "$cache_file"
}

get_cached_tool_status() {
    local tool_name="$1"
    local cache_file=".claude/cache/tool-status.json"

    if [[ -f "$cache_file" ]]; then
        jq -r --arg tool "$tool_name" '.[$tool].status // "unknown"' "$cache_file"
    else
        echo "unknown"
    fi
}
```

### Configuration Management

#### Tool Configuration (`config/tool-config.json`)
```json
{
    "mcp_servers": {
        "atlassian": {
            "required_tools": ["getJiraIssue", "searchConfluenceUsingCql"],
            "fallback": "acli",
            "health_check": "ping"
        },
        "serena": {
            "required_tools": ["find_symbol", "get_symbols_overview"],
            "fallback": "grep",
            "health_check": "list_dir"
        }
    },
    "cli_tools": {
        "glab": {
            "install": "brew install glab",
            "auth": "glab auth login",
            "test": "glab auth status"
        },
        "acli": {
            "install": "brew install atlassian-labs/acli/acli",
            "auth": "acli auth login",
            "test": "acli auth status"
        }
    }
}
```

**Critical Integration Note**: This skill provides comprehensive tool validation and fallback orchestration for the entire Claude Code ecosystem, absorbing and expanding MCP server management functionality while adding CLI tools, Skills, and Built-in tool validation with intelligent context-aware alternatives and seamless integration patterns for eliminating workflow disruption from tool unavailability.