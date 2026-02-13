#!/bin/bash

# Session Management Skill - Main Entry Point
# Comprehensive session efficiency and context management for Claude Code

# Set strict error handling
set -euo pipefail

# Get the directory where this script is located
SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPTS_DIR/.." && pwd)"

# Source all required modules
source "$SCRIPTS_DIR/session-utils.sh"
source "$SCRIPTS_DIR/session-complexity.sh"

# Parse skill parameters
parse_skill_parameters() {
    local operation="summary"
    local context="general"
    local skill_name=""
    local tool_name=""
    local reset_confirmation="false"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --operation=*)
                operation="${1#*=}"
                shift
                ;;
            --context=*)
                context="${1#*=}"
                shift
                ;;
            --skill_name=*)
                skill_name="${1#*=}"
                shift
                ;;
            --tool_name=*)
                tool_name="${1#*=}"
                shift
                ;;
            --reset_confirmation=*)
                reset_confirmation="${1#*=}"
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
    export SKILL_CONTEXT="$context"
    export SKILL_SKILL_NAME="$skill_name"
    export SKILL_TOOL_NAME="$tool_name"
    export SKILL_RESET_CONFIRMATION="$reset_confirmation"
}

# Main skill execution
execute_skill_operation() {
    local operation="$SKILL_OPERATION"
    local context="$SKILL_CONTEXT"
    local skill_name="$SKILL_SKILL_NAME"
    local tool_name="$SKILL_TOOL_NAME"
    local reset_confirmation="$SKILL_RESET_CONFIRMATION"

    log_info "Executing session-management operation: $operation"

    case "$operation" in
        "summary")
            echo "📊 Current Session Analysis"
            echo ""
            get_session_summary "text"
            ;;

        "optimize")
            optimize_session
            ;;

        "reset")
            if [[ "$reset_confirmation" != "true" ]]; then
                echo "⚠️  Session Reset Requires Confirmation"
                echo ""
                echo "To reset your session complexity tracking, use:"
                echo "  /session-management --operation=reset --reset_confirmation=true"
                echo ""
                echo "This will:"
                echo "  • Archive current session to history"
                echo "  • Reset all complexity counters to zero"
                echo "  • Start fresh session tracking"
                echo ""
                return 1
            fi
            reset_session
            ;;

        "new-session")
            start_new_session
            ;;

        "guidelines")
            get_efficiency_recommendations "$context"
            ;;

        "check-complexity")
            local session_status
            session_status=$(determine_session_status)

            case "$session_status" in
                "healthy")
                    echo "✅ Session complexity: Within limits"
                    return 0
                    ;;
                "optimization_needed")
                    echo "💡 Session complexity: Optimization suggested"
                    echo "   Consider focusing workflow and batching operations"
                    return 1
                    ;;
                "degraded")
                    echo "⚠️ Session complexity: Approaching limits"
                    echo "   Consider session break or workflow focus"
                    return 1
                    ;;
                "critical")
                    echo "🚨 Session complexity: Over limits"
                    echo "   Session reset recommended for optimal performance"
                    return 2
                    ;;
                *)
                    echo "❓ Session complexity: Unknown status"
                    return 1
                    ;;
            esac
            ;;

        "track-operation")
            if [[ -z "$skill_name" ]]; then
                log_error "Skill name required for operation tracking"
                return 1
            fi

            # Record the operation for session complexity tracking
            record_tool_usage "$operation" "${tool_name:-unknown}" "$context"

            # Return quietly - this is internal API used by other skills
            return 0
            ;;

        *)
            log_error "Unknown operation: $operation"
            echo ""
            echo "Available operations:"
            echo ""
            echo "Session Analysis:"
            echo "  summary               - View current session complexity analysis"
            echo "  optimize              - Get session optimization recommendations"
            echo "  check-complexity      - Quick complexity status check"
            echo ""
            echo "Session Management:"
            echo "  reset                 - Reset session tracking (requires --reset_confirmation=true)"
            echo "  new-session          - Start a new session"
            echo "  guidelines           - Show context-specific efficiency guidelines"
            echo ""
            echo "Integration API (Internal):"
            echo "  track-operation      - Track operation from other skills"
            echo ""
            echo "Example usage:"
            echo "  /session-management --operation=summary"
            echo "  /session-management --operation=optimize"
            echo "  /session-management --operation=guidelines --context=jira"
            echo "  /session-management --operation=reset --reset_confirmation=true"
            return 1
            ;;
    esac
}

# Skill initialization
initialize_skill() {
    # Initialize session tracking
    initialize_session_tracking

    # Clean up old session history
    cleanup_session_history

    log_info "Session Management Skill initialized"
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
    log_info "Session Management Skill completed (exit code: $exit_code)"

    return $exit_code
}

# Execute main function
main "$@"