#!/bin/bash

# Integration Patterns - Standardized integration functions for other skills
# Provides common integration patterns and utility functions for embedding tool management into other Claude Code skills

# Set strict error handling
set -euo pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" && pwd)"
source "$SCRIPT_DIR/tool-utils.sh"
source "$SCRIPT_DIR/tool-validation.sh"
source "$SCRIPT_DIR/fallback-generation.sh"

# Integration configuration
INTEGRATION_LOG_PATH="$TOOL_CACHE_DIR/integration.log"

# Standardized tool validation for skills
validate_skill_tools() {
    local skill_name="$1"
    shift
    local required_tools=("$@")

    log_info "Validating tools for skill: $skill_name"

    local validation_failed=false
    local failed_tools=()
    local available_tools=()

    for tool_spec in "${required_tools[@]}"; do
        if validate_tool "$tool_spec" "false" >/dev/null 2>&1; then
            available_tools+=("$tool_spec")
            log_success "✅ $tool_spec - Available"
        else
            validation_failed=true
            failed_tools+=("$tool_spec")
            log_warning "❌ $tool_spec - Unavailable"
        fi
    done

    if [[ "$validation_failed" == "true" ]]; then
        echo ""
        echo "⚠️  Some tools unavailable for skill: $skill_name"
        echo "Failed tools: ${failed_tools[*]}"
        echo ""

        # Generate fallback suggestions
        echo "🔄 Available alternatives:"
        for failed_tool in "${failed_tools[@]}"; do
            local operation_context="${skill_name%-*}"  # Extract operation context from skill name
            suggest_alternatives "$operation_context" "${failed_tool%%:*}" "${failed_tool#*:}" | head -3
        done
        echo ""

        echo "🛠️  Quick recovery: /tool-management --operation=health-check --suggest_alternatives=true"
        return 1
    else
        log_success "✅ All required tools available for $skill_name"
        return 0
    fi
}

# Pre-operation tool validation pattern
pre_operation_validation() {
    local operation_name="$1"
    local operation_context="${2:-general}"
    shift 2
    local required_tools=("$@")

    log_info "Pre-operation validation for: $operation_name"

    # Quick cache check first
    local cache_key="${operation_context}_${operation_name}"
    if cached_status=$(get_cached_tool_status "$cache_key" 300); then
        if [[ "$cached_status" == "valid" ]]; then
            log_info "✅ Cached validation passed for $operation_name"
            return 0
        fi
    fi

    # Full validation
    local validation_result=true
    for tool_spec in "${required_tools[@]}"; do
        if ! validate_tool "$tool_spec" "true" >/dev/null 2>&1; then
            validation_result=false
            break
        fi
    done

    if [[ "$validation_result" == "true" ]]; then
        cache_tool_status "$cache_key" "valid"
        log_success "✅ Pre-operation validation passed for $operation_name"
        return 0
    else
        cache_tool_status "$cache_key" "invalid"
        echo "❌ Pre-operation validation failed for $operation_name"

        # Provide intelligent fallback suggestions
        echo ""
        echo "🔄 Suggested alternatives:"
        get_fallback_chain "$operation_context" | sed 's/ → /\n  ↳ /g' | sed 's/^/  /'
        echo ""
        echo "🛠️  Recovery options:"
        echo "  1. Install missing tools: /tool-management --operation=install-guidance"
        echo "  2. Use alternative workflow: See fallback chain above"
        echo "  3. Check tool health: /tool-management --operation=health-check"

        return 1
    fi
}

# Universal error handling for tool failures
handle_tool_failure() {
    local operation_name="$1"
    local failed_tool="$2"
    local operation_context="${3:-general}"
    local error_details="${4:-Unknown error}"

    echo "❌ Tool failure during: $operation_name"
    echo "   Failed tool: $failed_tool"
    echo "   Error: $error_details"
    echo ""

    # Log the failure
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] Tool failure: $failed_tool in $operation_name - $error_details" >> "$INTEGRATION_LOG_PATH"

    # Get intelligent fallbacks
    echo "🔄 Recovery options:"

    # Primary fallback chain
    local fallback_chain
    fallback_chain=$(get_fallback_chain "$operation_context" "$failed_tool")
    echo "   Fallback chain: $fallback_chain"

    # Specific alternatives
    echo ""
    echo "🔧 Immediate alternatives:"
    suggest_alternatives "$operation_context" "${failed_tool%%:*}" "${failed_tool#*:}" | head -3

    echo ""
    echo "🛠️  Automated recovery:"
    echo "   /tool-management --operation=health-check --operation_context=\"$operation_context\""
    echo "   /tool-management --operation=install-guidance --tool_name=\"${failed_tool#*:}\""
}

# Graceful degradation pattern
implement_graceful_degradation() {
    local primary_tools=("$1")
    local operation_context="$2"
    shift 2
    local fallback_tools=("$@")

    log_info "Implementing graceful degradation for $operation_context"

    # Try primary tools first
    for tool in "${primary_tools[@]}"; do
        if validate_tool "$tool" "false" >/dev/null 2>&1; then
            echo "primary:$tool"
            return 0
        fi
    done

    # Fall back to secondary tools
    for tool in "${fallback_tools[@]}"; do
        if validate_tool "$tool" "false" >/dev/null 2>&1; then
            echo "fallback:$tool"
            return 0
        fi
    done

    # No tools available
    echo "manual:required"
    return 1
}

# Skill dependency checker
check_skill_dependencies() {
    local skill_name="$1"
    local skill_path="$HOME/.claude/skills/$skill_name"

    if [[ ! -f "$skill_path/SKILL.md" ]]; then
        echo "❌ Skill not found: $skill_name"
        return 1
    fi

    log_info "Checking dependencies for skill: $skill_name"

    local skill_content
    skill_content=$(cat "$skill_path/SKILL.md")

    local dependencies=()
    local missing_dependencies=()

    # Extract MCP dependencies
    while IFS= read -r line; do
        if [[ "$line" =~ (atlassian|serena|databricks|glean|gitlab-sidekick|chrome-devtools|context7|datadog) ]]; then
            local mcp_server=$(echo "$line" | grep -o -E "(atlassian|serena|databricks|glean|gitlab-sidekick|chrome-devtools|context7|datadog)" | head -1)
            dependencies+=("mcp:$mcp_server")
        fi
    done <<< "$skill_content"

    # Extract CLI dependencies
    while IFS= read -r line; do
        if [[ "$line" =~ (glab|acli|datadog|git|mysql|psql) ]]; then
            local cli_tool=$(echo "$line" | grep -o -E "(glab|acli|datadog|git|mysql|psql)" | head -1)
            dependencies+=("cli:$cli_tool")
        fi
    done <<< "$skill_content"

    # Validate each dependency
    for dep in "${dependencies[@]}"; do
        if ! validate_tool "$dep" "false" >/dev/null 2>&1; then
            missing_dependencies+=("$dep")
        fi
    done

    # Report results
    if [[ ${#missing_dependencies[@]} -eq 0 ]]; then
        log_success "✅ All dependencies satisfied for skill: $skill_name"
        return 0
    else
        echo "⚠️  Missing dependencies for skill: $skill_name"
        for dep in "${missing_dependencies[@]}"; do
            echo "   - $dep"
        done
        echo ""
        echo "🔧 Install missing dependencies:"
        for dep in "${missing_dependencies[@]}"; do
            local category="${dep%%:*}"
            local tool_name="${dep#*:}"
            echo "   /tool-management --operation=install-guidance --tool_name=\"$tool_name\" --tool_category=\"$category\""
        done
        return 1
    fi
}

# Tool availability matrix for operations
generate_availability_matrix() {
    local operations=("$@")

    echo "🔍 Tool Availability Matrix"
    echo "=========================="
    echo ""

    # Header
    printf "%-20s | %-15s | %-15s | %-20s | %s\n" "Operation" "Primary Tool" "Backup Tool" "Manual Alternative" "Status"
    echo "$(printf '%*s' 80 '' | tr ' ' '-')"

    for operation in "${operations[@]}"; do
        local chain
        chain=$(get_fallback_chain "$operation")

        # Parse fallback chain
        IFS=' → ' read -ra tools <<< "$chain"
        local primary="${tools[0]:-N/A}"
        local backup="${tools[1]:-N/A}"
        local manual="${tools[2]:-N/A}"

        # Check primary tool status
        local status="❌"
        if validate_tool "$primary" "false" >/dev/null 2>&1; then
            status="✅"
        elif [[ ${#tools[@]} -gt 1 ]] && validate_tool "$backup" "false" >/dev/null 2>&1; then
            status="⚠️"
        fi

        printf "%-20s | %-15s | %-15s | %-20s | %s\n" "$operation" "$primary" "$backup" "$manual" "$status"
    done

    echo ""
    echo "Legend: ✅ Primary Available | ⚠️ Fallback Available | ❌ Manual Required"
}

# Automated tool installation workflow
auto_install_workflow() {
    local operation_context="$1"
    local required_tools=("${@:2}")

    log_info "Starting automated installation workflow for: $operation_context"

    local install_queue=()
    local failed_installs=()

    # Identify missing tools
    for tool_spec in "${required_tools[@]}"; do
        if ! validate_tool "$tool_spec" "false" >/dev/null 2>&1; then
            install_queue+=("$tool_spec")
        fi
    done

    if [[ ${#install_queue[@]} -eq 0 ]]; then
        log_success "✅ All tools already available for $operation_context"
        return 0
    fi

    echo "📦 Installation queue for $operation_context:"
    for tool_spec in "${install_queue[@]}"; do
        echo "   - $tool_spec"
    done
    echo ""

    # Installation instructions
    echo "🔧 Installation commands:"
    for tool_spec in "${install_queue[@]}"; do
        local category="${tool_spec%%:*}"
        local tool_name="${tool_spec#*:}"

        case "$category" in
            "cli")
                case "$tool_name" in
                    "glab") echo "   brew install glab && glab auth login" ;;
                    "acli") echo "   brew install atlassian-labs/acli/acli && acli auth login" ;;
                    "datadog") echo "   pip install datadog && datadog configure" ;;
                    *) echo "   # Install $tool_name via package manager" ;;
                esac
                ;;
            "mcp")
                echo "   # Configure $tool_name MCP server in Claude Code settings"
                ;;
        esac
    done

    echo ""
    echo "🤖 Automated setup:"
    echo "   /tool-management --operation=install-guidance --operation_context=\"$operation_context\""
}

# Integration health check for skills
integration_health_check() {
    local skill_name="$1"

    log_info "Running integration health check for: $skill_name"

    # Check skill existence
    if ! check_skill_dependencies "$skill_name"; then
        echo "❌ Skill integration health check failed"
        return 1
    fi

    # Check tool ecosystem health
    echo ""
    echo "🔍 Tool ecosystem health for $skill_name:"

    # Run focused health check
    if perform_comprehensive_health_check "all" "true" "summary" >/dev/null 2>&1; then
        log_success "✅ Tool ecosystem is healthy"
    else
        log_warning "⚠️ Tool ecosystem has issues - see health check for details"
    fi

    # Generate integration report
    echo ""
    echo "📊 Integration Status Report:"
    echo "   Skill: $skill_name"
    echo "   Dependencies: $(check_skill_dependencies "$skill_name" >/dev/null && echo "✅ Satisfied" || echo "❌ Missing")"
    echo "   Tool Ecosystem: $(perform_comprehensive_health_check "all" "true" "summary" >/dev/null && echo "✅ Healthy" || echo "⚠️ Issues")"

    return 0
}

# Common integration patterns for different skill types
apply_integration_pattern() {
    local skill_type="$1"
    local skill_name="$2"

    case "$skill_type" in
        "mcp-heavy")
            # Skills that primarily use MCP servers
            echo "🔧 MCP-Heavy Skill Integration Pattern"
            echo "   1. Pre-validate MCP servers: /tool-management --operation=validate --tool_category=mcp"
            echo "   2. Fallback to CLI alternatives: Automatic via fallback chains"
            echo "   3. Manual workflow: Browser-based operations"
            ;;
        "cli-heavy")
            # Skills that primarily use CLI tools
            echo "🔧 CLI-Heavy Skill Integration Pattern"
            echo "   1. Pre-validate CLI tools and auth: /tool-management --operation=validate --tool_category=cli --validate_auth=true"
            echo "   2. Installation guidance: Automatic via install-guidance"
            echo "   3. Web UI fallback: Available for most operations"
            ;;
        "hybrid")
            # Skills that use both MCP and CLI
            echo "🔧 Hybrid Skill Integration Pattern"
            echo "   1. Full ecosystem validation: /tool-management --operation=health-check --tool_category=all"
            echo "   2. Intelligent degradation: MCP → CLI → Manual"
            echo "   3. Context-aware fallbacks: Operation-specific alternatives"
            ;;
        "system")
            # Skills that only use built-in tools
            echo "🔧 System Skill Integration Pattern"
            echo "   1. Built-in tools only: Always available"
            echo "   2. File system validation: Check permissions and access"
            echo "   3. Configuration validation: Verify skill setup"
            ;;
    esac
}

# Export integration functions
export_integration_functions() {
    cat << 'EOF'
# Tool Management Integration Functions
# Source this file in your skill scripts to use standardized integration patterns

# Validate tools before operation
validate_before_operation() {
    local operation="$1"
    shift
    local tools=("$@")

    /tool-management --operation=validate --operation_context="$operation" "${tools[@]}"
}

# Handle tool failures gracefully
on_tool_failure() {
    local operation="$1"
    local failed_tool="$2"
    local error="$3"

    /tool-management --operation=suggest-fallbacks --operation_context="$operation" --tool_name="$failed_tool"
}

# Quick health check
quick_health_check() {
    /tool-management --operation=health-check --tool_category=all --output=summary
}

# Installation guidance
get_install_help() {
    local tool="$1"
    /tool-management --operation=install-guidance --tool_name="$tool"
}
EOF
}

# Main execution function
main() {
    local operation="${1:-help}"
    local skill_name="${2:-}"

    case "$operation" in
        "validate-skill")
            [[ -n "$skill_name" ]] || { echo "Usage: $0 validate-skill <skill_name> [tools...]"; return 1; }
            shift 2
            validate_skill_tools "$skill_name" "$@"
            ;;
        "pre-validate")
            [[ -n "$skill_name" ]] || { echo "Usage: $0 pre-validate <operation_name> [context] [tools...]"; return 1; }
            local context="${3:-general}"
            shift 3
            pre_operation_validation "$skill_name" "$context" "$@"
            ;;
        "handle-failure")
            [[ -n "$skill_name" ]] || { echo "Usage: $0 handle-failure <operation> <failed_tool> [context] [error]"; return 1; }
            local failed_tool="${3:-unknown}"
            local context="${4:-general}"
            local error="${5:-Unknown error}"
            handle_tool_failure "$skill_name" "$failed_tool" "$context" "$error"
            ;;
        "check-dependencies")
            [[ -n "$skill_name" ]] || { echo "Usage: $0 check-dependencies <skill_name>"; return 1; }
            check_skill_dependencies "$skill_name"
            ;;
        "availability-matrix")
            shift
            generate_availability_matrix "$@"
            ;;
        "auto-install")
            [[ -n "$skill_name" ]] || { echo "Usage: $0 auto-install <context> [tools...]"; return 1; }
            shift 2
            auto_install_workflow "$skill_name" "$@"
            ;;
        "integration-check")
            [[ -n "$skill_name" ]] || { echo "Usage: $0 integration-check <skill_name>"; return 1; }
            integration_health_check "$skill_name"
            ;;
        "pattern")
            local pattern_type="${3:-hybrid}"
            apply_integration_pattern "$pattern_type" "$skill_name"
            ;;
        "export-functions")
            export_integration_functions
            ;;
        "help"|*)
            echo "Tool Management Integration Patterns"
            echo ""
            echo "Usage: $0 <operation> [arguments...]"
            echo ""
            echo "Operations:"
            echo "  validate-skill <skill> [tools...]     - Validate tools for specific skill"
            echo "  pre-validate <op> [context] [tools...] - Pre-operation validation"
            echo "  handle-failure <op> <tool> [ctx] [err] - Handle tool failure"
            echo "  check-dependencies <skill>             - Check skill dependencies"
            echo "  availability-matrix [operations...]    - Generate availability matrix"
            echo "  auto-install <context> [tools...]     - Automated installation"
            echo "  integration-check <skill>              - Integration health check"
            echo "  pattern <type> <skill>                 - Apply integration pattern"
            echo "  export-functions                       - Export integration functions"
            echo ""
            ;;
    esac
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]:-}" == "${0}" ]]; then
    main "$@"
fi