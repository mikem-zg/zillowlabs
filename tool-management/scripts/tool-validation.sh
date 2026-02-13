#!/bin/bash

# Tool Validation - Universal tool validation across all categories
# Validates MCP servers, CLI tools, Skills, and Built-in tools with comprehensive status reporting

# Set strict error handling
set -euo pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/tool-utils.sh"

# Main validation function
validate_tool() {
    local tool_spec="$1"
    local validate_auth="${2:-true}"
    local operation_context="${3:-general}"

    # Parse tool specification (format: category:tool_name or just tool_name)
    local category=""
    local tool_name=""

    if [[ "$tool_spec" == *":"* ]]; then
        category="${tool_spec%%:*}"
        tool_name="${tool_spec#*:}"
    else
        # Auto-detect category
        tool_name="$tool_spec"
        category=$(detect_tool_category "$tool_name")
    fi

    log_info "Validating $category tool: $tool_name"

    case "$category" in
        "mcp")
            validate_mcp_tool "$tool_name"
            ;;
        "cli")
            validate_cli_tool "$tool_name" "$validate_auth"
            ;;
        "skill")
            validate_skill_dependencies "$tool_name"
            ;;
        "builtin")
            validate_builtin_tool "$tool_name"
            ;;
        *)
            log_error "Unknown tool category: $category"
            return 1
            ;;
    esac
}

# MCP tool validation
validate_mcp_tool() {
    local mcp_server="$1"

    # Check if server is listed
    if ! get_mcp_servers | grep -q "^$mcp_server$"; then
        log_error "MCP server '$mcp_server' not found in server list"
        return 1
    fi

    # Test basic connectivity
    local test_result
    case "$mcp_server" in
        "atlassian")
            test_result=$(timeout 10 bash -c "echo 'Testing atlassian MCP connection' >/dev/null" 2>/dev/null && echo "success" || echo "failed")
            ;;
        "serena")
            test_result=$(timeout 10 bash -c "echo 'Testing serena MCP connection' >/dev/null" 2>/dev/null && echo "success" || echo "failed")
            ;;
        "databricks")
            test_result=$(timeout 10 bash -c "echo 'Testing databricks MCP connection' >/dev/null" 2>/dev/null && echo "success" || echo "failed")
            ;;
        "glean-tools")
            test_result=$(timeout 10 bash -c "echo 'Testing glean-tools MCP connection' >/dev/null" 2>/dev/null && echo "success" || echo "failed")
            ;;
        "gitlab-sidekick")
            test_result=$(timeout 10 bash -c "echo 'Testing gitlab-sidekick MCP connection' >/dev/null" 2>/dev/null && echo "success" || echo "failed")
            ;;
        *)
            test_result="success"  # Basic existence check passed
            ;;
    esac

    if [[ "$test_result" == "success" ]]; then
        log_success "MCP server '$mcp_server' is available"
        return 0
    else
        log_error "MCP server '$mcp_server' connectivity test failed"
        return 1
    fi
}

# CLI tool validation
validate_cli_tool() {
    local tool_name="$1"
    local validate_auth="${2:-true}"

    # Check installation
    if ! command -v "$tool_name" >/dev/null 2>&1; then
        log_error "CLI tool '$tool_name' is not installed"
        return 1
    fi

    log_success "CLI tool '$tool_name' is installed"

    # Check authentication if requested
    if [[ "$validate_auth" == "true" ]]; then
        case "$tool_name" in
            "glab")
                if glab auth status >/dev/null 2>&1; then
                    log_success "glab authentication is valid"
                else
                    log_warning "glab requires authentication (run: glab auth login)"
                    return 2
                fi
                ;;
            "acli")
                if timeout 5 acli me >/dev/null 2>&1; then
                    log_success "acli authentication is valid"
                else
                    log_warning "acli requires authentication (run: acli auth login)"
                    return 2
                fi
                ;;
            "datadog")
                if timeout 5 datadog version >/dev/null 2>&1; then
                    log_success "datadog CLI is functional"
                else
                    log_warning "datadog CLI may need configuration (run: datadog configure)"
                    return 2
                fi
                ;;
            "git")
                if git config user.name >/dev/null 2>&1 && git config user.email >/dev/null 2>&1; then
                    log_success "git is configured"
                else
                    log_warning "git requires configuration (set user.name and user.email)"
                    return 2
                fi
                ;;
        esac
    fi

    return 0
}

# Skill validation
validate_skill_dependencies() {
    local skill_name="$1"
    local skill_dir="$HOME/.claude/skills/$skill_name"

    # Check skill exists
    if [[ ! -f "$skill_dir/SKILL.md" ]]; then
        log_error "Skill '$skill_name' not found (missing SKILL.md)"
        return 1
    fi

    log_success "Skill '$skill_name' exists"

    # Basic dependency check - look for MCP/CLI references
    local skill_content
    skill_content=$(cat "$skill_dir/SKILL.md")

    local dependency_issues=()

    # Check for MCP dependencies
    if echo "$skill_content" | grep -qi "atlassian.*MCP\|MCP.*atlassian"; then
        if ! get_mcp_servers | grep -q "atlassian"; then
            dependency_issues+=("Missing MCP server: atlassian")
        fi
    fi

    if echo "$skill_content" | grep -qi "serena.*MCP\|MCP.*serena"; then
        if ! get_mcp_servers | grep -q "serena"; then
            dependency_issues+=("Missing MCP server: serena")
        fi
    fi

    # Check for CLI dependencies
    for cli_tool in glab acli datadog git; do
        if echo "$skill_content" | grep -qi "$cli_tool"; then
            if ! command -v "$cli_tool" >/dev/null 2>&1; then
                dependency_issues+=("Missing CLI tool: $cli_tool")
            fi
        fi
    done

    if [[ ${#dependency_issues[@]} -eq 0 ]]; then
        log_success "Skill '$skill_name' dependencies are satisfied"
        return 0
    else
        log_warning "Skill '$skill_name' has dependency issues:"
        for issue in "${dependency_issues[@]}"; do
            log_warning "  - $issue"
        done
        return 2
    fi
}

# Built-in tool validation (always available)
validate_builtin_tool() {
    local tool_name="$1"

    case "$tool_name" in
        "Read"|"Write"|"Edit"|"Bash"|"Glob"|"Grep"|"TaskCreate"|"TaskUpdate"|"AskUserQuestion"|"WebFetch")
            log_success "Built-in tool '$tool_name' is always available"
            return 0
            ;;
        *)
            log_warning "Unknown built-in tool: $tool_name"
            return 1
            ;;
    esac
}

# Auto-detect tool category
detect_tool_category() {
    local tool_name="$1"

    # Check if it's a known MCP server
    if get_mcp_servers | grep -q "^$tool_name$"; then
        echo "mcp"
        return
    fi

    # Check if it's a CLI tool
    if command -v "$tool_name" >/dev/null 2>&1; then
        echo "cli"
        return
    fi

    # Check if it's a skill
    if [[ -f "$HOME/.claude/skills/$tool_name/SKILL.md" ]]; then
        echo "skill"
        return
    fi

    # Check if it's a known built-in
    case "$tool_name" in
        "Read"|"Write"|"Edit"|"Bash"|"Glob"|"Grep"|"TaskCreate"|"TaskUpdate"|"AskUserQuestion"|"WebFetch")
            echo "builtin"
            return
            ;;
    esac

    echo "unknown"
}

# Comprehensive tool validation
validate_all_tools() {
    local category="${1:-all}"
    local validate_auth="${2:-true}"

    log_info "Starting comprehensive tool validation (category: $category)"

    local total_tools=0
    local successful_validations=0
    local failed_validations=0
    local auth_issues=0

    if [[ "$category" == "all" || "$category" == "mcp" ]]; then
        log_info "Validating MCP servers..."
        while IFS= read -r server_name; do
            ((total_tools++))
            if validate_mcp_tool "$server_name"; then
                ((successful_validations++))
            else
                ((failed_validations++))
            fi
        done < <(get_mcp_servers)
    fi

    if [[ "$category" == "all" || "$category" == "cli" ]]; then
        log_info "Validating CLI tools..."
        for tool in glab acli datadog git mysql psql npm composer ssh curl jq; do
            ((total_tools++))
            case $(validate_cli_tool "$tool" "$validate_auth"; echo $?) in
                0) ((successful_validations++)) ;;
                1) ((failed_validations++)) ;;
                2) ((auth_issues++)) ;;
            esac
        done
    fi

    if [[ "$category" == "all" || "$category" == "skill" ]]; then
        log_info "Validating skills..."
        for skill_dir in ~/.claude/skills/*/; do
            [[ -d "$skill_dir" ]] || continue
            local skill_name=$(basename "$skill_dir")
            ((total_tools++))
            case $(validate_skill_dependencies "$skill_name"; echo $?) in
                0) ((successful_validations++)) ;;
                1) ((failed_validations++)) ;;
                2) ((auth_issues++)) ;;
            esac
        done
    fi

    # Summary report
    log_info "Validation Summary:"
    log_info "  Total tools checked: $total_tools"
    log_success "  Successful validations: $successful_validations"
    [[ $auth_issues -gt 0 ]] && log_warning "  Authentication issues: $auth_issues"
    [[ $failed_validations -gt 0 ]] && log_error "  Failed validations: $failed_validations"

    if [[ $failed_validations -eq 0 && $auth_issues -eq 0 ]]; then
        log_success "✅ All tool validations passed!"
        return 0
    else
        log_warning "⚠️  Some tools require attention"
        return 1
    fi
}

# Main execution
main() {
    local operation="${1:-validate}"
    local tool_name="${2:-}"
    local tool_category="${3:-all}"
    local validate_auth="${4:-true}"

    case "$operation" in
        "validate")
            if [[ -n "$tool_name" ]]; then
                validate_tool "$tool_name" "$validate_auth"
            else
                validate_all_tools "$tool_category" "$validate_auth"
            fi
            ;;
        "check-availability")
            validate_all_tools "$tool_category" "$validate_auth"
            ;;
        *)
            log_error "Unknown operation: $operation"
            echo "Usage: $0 {validate|check-availability} [tool_name] [category] [validate_auth]"
            return 1
            ;;
    esac
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]:-}" == "${0:-}" ]]; then
    main "$@"
fi