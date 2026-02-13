#!/bin/bash

# Tool Management Skill - Main Entry Point
# Comprehensive tool validation, availability checking, and fallback orchestration

# Set strict error handling
set -euo pipefail

# Get the directory where this script is located
SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPTS_DIR/.." && pwd)"

# Source all required modules
source "$SCRIPTS_DIR/tool-utils.sh"
source "$SCRIPTS_DIR/tool-validation.sh"
source "$SCRIPTS_DIR/fallback-generation.sh"
source "$SCRIPTS_DIR/install-guidance.sh"
source "$SCRIPTS_DIR/health-monitoring.sh"
source "$SCRIPTS_DIR/integration-patterns.sh"

# Source intelligent retry controller and integration bridge
if [[ -f "$SCRIPTS_DIR/retry-integration-bridge.sh" ]]; then
    source "$SCRIPTS_DIR/retry-integration-bridge.sh"
    INTELLIGENT_RETRY_AVAILABLE=true
else
    INTELLIGENT_RETRY_AVAILABLE=false
    log_info "Note: Intelligent retry controller not available"
fi

# Parse skill parameters
parse_skill_parameters() {
    local operation="validate"
    local tool_name=""
    local tool_category="all"
    local operation_context="general"
    local suggest_alternatives="true"
    local validate_auth="true"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --operation=*)
                operation="${1#*=}"
                shift
                ;;
            --tool_name=*)
                tool_name="${1#*=}"
                shift
                ;;
            --tool_category=*)
                tool_category="${1#*=}"
                shift
                ;;
            --operation_context=*)
                operation_context="${1#*=}"
                shift
                ;;
            --suggest_alternatives=*)
                suggest_alternatives="${1#*=}"
                shift
                ;;
            --validate_auth=*)
                validate_auth="${1#*=}"
                shift
                ;;
            *)
                log_warning "Unknown parameter: $1"
                shift
                ;;
        esac
    done

    # Export parsed parameters
    export SKILL_OPERATION="$operation"
    export SKILL_TOOL_NAME="$tool_name"
    export SKILL_TOOL_CATEGORY="$tool_category"
    export SKILL_OPERATION_CONTEXT="$operation_context"
    export SKILL_SUGGEST_ALTERNATIVES="$suggest_alternatives"
    export SKILL_VALIDATE_AUTH="$validate_auth"
}

# Main skill execution
execute_skill_operation() {
    local operation="$SKILL_OPERATION"
    local tool_name="$SKILL_TOOL_NAME"
    local tool_category="$SKILL_TOOL_CATEGORY"
    local operation_context="$SKILL_OPERATION_CONTEXT"
    local suggest_alternatives="$SKILL_SUGGEST_ALTERNATIVES"
    local validate_auth="$SKILL_VALIDATE_AUTH"

    log_info "Executing tool-management operation: $operation"

    # Track operation for session complexity monitoring
    if command -v /session-management >/dev/null 2>&1; then
        /session-management --operation=track-operation --skill_name="tool-management" --tool_name="$tool_name" --context="$tool_category" >/dev/null 2>&1 || true
    fi

    case "$operation" in
        "validate")
            if [[ -n "$tool_name" ]]; then
                echo "🔍 Validating specific tool: $tool_name"
                echo ""

                # Use intelligent retry if available, otherwise standard validation
                local validation_result=0
                if [[ "$INTELLIGENT_RETRY_AVAILABLE" == "true" ]] && command -v validate_tool_integrated >/dev/null 2>&1; then
                    echo "🔄 Using intelligent retry validation"
                    validate_tool_integrated "$tool_name" "$validate_auth" "$operation_context" || validation_result=$?
                else
                    validate_tool "$tool_name" "$validate_auth" "$operation_context" || validation_result=$?
                fi

                if [[ $validation_result -eq 0 ]]; then
                    echo ""
                    log_success "✅ Tool validation successful: $tool_name"
                else
                    echo ""
                    log_error "❌ Tool validation failed: $tool_name"

                    if [[ "$suggest_alternatives" == "true" ]]; then
                        echo ""
                        echo "🔄 Suggested alternatives:"
                        suggest_alternatives "$operation_context" "${tool_name%%:*}" "${tool_name#*:}"
                    fi
                    return 1
                fi
            else
                echo "🔍 Validating all tools (category: $tool_category)"
                echo ""

                if validate_all_tools "$tool_category" "$validate_auth"; then
                    echo ""
                    log_success "✅ All tool validations passed"
                else
                    echo ""
                    log_warning "⚠️ Some tools require attention"

                    if [[ "$suggest_alternatives" == "true" ]]; then
                        echo ""
                        echo "🔧 Recovery options:"
                        echo "   /tool-management --operation=install-guidance --tool_category=$tool_category"
                        echo "   /tool-management --operation=health-check --tool_category=$tool_category"
                    fi
                    return 1
                fi
            fi
            ;;

        "check-availability")
            echo "🏥 Tool Availability Check (category: $tool_category)"
            echo ""

            validate_all_tools "$tool_category" "$validate_auth"
            ;;

        "suggest-fallbacks")
            if [[ -n "$tool_name" ]]; then
                echo "🔄 Fallback Suggestions for: $tool_name"
                echo "Operation Context: $operation_context"
                echo ""

                suggest_alternatives "$operation_context" "${tool_name%%:*}" "${tool_name#*:}"
            else
                log_error "Tool name required for fallback suggestions"
                return 1
            fi
            ;;

        "fallback-chain")
            echo "🔗 Fallback Chain for: $operation_context"
            echo ""

            local chain
            chain=$(get_fallback_chain "$operation_context" "$tool_name")
            echo "Chain: $chain"
            echo ""

            echo "Detailed breakdown:"
            echo "$chain" | sed 's/ → /\n  ↳ /g' | sed 's/^/  /'
            ;;

        "health-check")
            echo "🏥 Tool Ecosystem Health Check"
            echo ""

            if perform_comprehensive_health_check "$tool_category" "$validate_auth" "text"; then
                echo ""
                if [[ "$suggest_alternatives" == "true" ]]; then
                    echo "🎯 Recommendation: All systems operational - no action needed"
                fi
            else
                echo ""
                if [[ "$suggest_alternatives" == "true" ]]; then
                    echo "🔧 Automated recovery available:"
                    echo "   /tool-management --operation=install-guidance"
                    echo "   /tool-management --operation=health-check --suggest_alternatives=false"
                fi
                return 1
            fi
            ;;

        "install-guidance")
            if [[ -n "$tool_name" ]]; then
                case "$tool_category" in
                    "cli")
                        provide_cli_install_guidance "$tool_name"
                        ;;
                    "mcp")
                        provide_mcp_install_guidance "$tool_name"
                        ;;
                    "skill")
                        provide_skill_install_guidance "$tool_name"
                        ;;
                    "environment"|"all")
                        provide_environment_setup
                        ;;
                    *)
                        log_error "Unknown tool category for installation: $tool_category"
                        echo "Supported categories: cli, mcp, skill, environment"
                        return 1
                        ;;
                esac
            else
                echo "🛠️ Installation Guidance Overview"
                echo ""
                echo "Use --tool_name parameter to get specific installation instructions:"
                echo ""
                echo "CLI Tools:"
                echo "  /tool-management --operation=install-guidance --tool_name=glab --tool_category=cli"
                echo "  /tool-management --operation=install-guidance --tool_name=acli --tool_category=cli"
                echo ""
                echo "MCP Servers:"
                echo "  /tool-management --operation=install-guidance --tool_name=atlassian --tool_category=mcp"
                echo "  /tool-management --operation=install-guidance --tool_name=serena --tool_category=mcp"
                echo ""
                echo "Complete Environment:"
                echo "  /tool-management --operation=install-guidance --tool_category=environment"
            fi
            ;;

        "session-summary")
            echo "📊 Current Session Analysis"
            echo ""
            get_session_summary "text"
            ;;

        "session-optimize")
            optimize_session
            ;;

        "session-reset")
            reset_session
            ;;

        "session-guidelines")
            get_efficiency_recommendations "$operation_context"
            ;;

        *)
            log_error "Unknown operation: $operation"
            echo ""
            echo "Available operations:"
            echo ""
            echo "Tool Management:"
            echo "  validate              - Validate tool availability"
            echo "  check-availability    - Check all tools in category"
            echo "  suggest-fallbacks     - Get fallback suggestions for failed tool"
            echo "  fallback-chain        - Get complete fallback chain for operation"
            echo "  health-check          - Comprehensive health check"
            echo "  install-guidance      - Installation instructions"
            echo ""
            echo "Session Management:"
            echo "  session-summary       - View current session complexity analysis"
            echo "  session-optimize      - Get session optimization recommendations"
            echo "  session-reset         - Reset session complexity tracking"
            echo "  session-guidelines    - Show session efficiency guidelines"
            echo ""
            echo "Example usage:"
            echo "  /tool-management --operation=validate --tool_name=atlassian.getJiraIssue"
            echo "  /tool-management --operation=health-check --tool_category=all"
            echo "  /tool-management --operation=install-guidance --tool_name=glab --tool_category=cli"
            echo "  /tool-management --operation=session-summary"
            echo "  /tool-management --operation=session-guidelines --operation_context=jira"
            return 1
            ;;
    esac
}

# Skill initialization
initialize_skill() {
    # Create necessary directories
    mkdir -p "$TOOL_CACHE_DIR"
    mkdir -p "$(dirname "$DEBUG_LOG_PATH")"

    # Clean up old cache files
    cleanup_tool_cache

    log_info "Tool Management Skill initialized"
    return 0
}

# Main execution
main() {
    # Initialize skill
    initialize_skill

    # Parse parameters
    parse_skill_parameters "$@"

    # Execute operation
    execute_skill_operation

    local exit_code=$?

    # Log completion
    log_info "Tool Management Skill completed (exit code: $exit_code)"

    return $exit_code
}

# Execute main function
main "$@"