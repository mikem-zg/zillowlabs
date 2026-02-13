#!/bin/bash

# Session Complexity Management - Session efficiency and context management
# Provides session tracking, complexity monitoring, and guidance for optimal tool usage

# Set strict error handling
set -euo pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" && pwd)"
source "$SCRIPT_DIR/session-utils.sh"

# Session complexity configuration is now in session-utils.sh

# Initialize session tracking
initialize_session_tracking() {
    log_info "Initializing session complexity tracking"

    # Create session state file if it doesn't exist
    if [[ ! -f "$SESSION_STATE_FILE" ]]; then
        cat > "$SESSION_STATE_FILE" << 'EOF'
{
  "session_id": "",
  "start_time": "",
  "tool_calls": 0,
  "unique_tools": [],
  "operations": [],
  "complexity_score": 0,
  "last_activity": "",
  "warnings_issued": []
}
EOF
    fi

    # Rotate session if it's too old (>2 hours)
    local current_time=$(date +%s)
    local session_start
    session_start=$(jq -r '.start_time' "$SESSION_STATE_FILE" 2>/dev/null || echo "0")

    if [[ -z "$session_start" || "$session_start" == "null" || $((current_time - session_start)) -gt 7200 ]]; then
        start_new_session
    fi
}

# Start a new session
start_new_session() {
    local session_id
    session_id=$(date +%s)-$$
    local current_time=$(date +%s)

    log_info "Starting new session: $session_id"

    # Archive current session if it exists
    if [[ -f "$SESSION_STATE_FILE" ]] && [[ -s "$SESSION_STATE_FILE" ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Session archived: $(jq -c . "$SESSION_STATE_FILE")" >> "$SESSION_HISTORY_FILE"
    fi

    # Create new session state
    cat > "$SESSION_STATE_FILE" << EOF
{
  "session_id": "$session_id",
  "start_time": $current_time,
  "tool_calls": 0,
  "unique_tools": [],
  "operations": [],
  "complexity_score": 0,
  "last_activity": "$current_time",
  "warnings_issued": []
}
EOF

    log_success "New session initialized: $session_id"
}

# Record tool usage in session
record_tool_usage() {
    local operation="$1"
    local tool_name="${2:-unknown}"
    local tool_category="${3:-general}"

    if [[ ! -f "$SESSION_STATE_FILE" ]]; then
        initialize_session_tracking
    fi

    # Update session state
    local current_time=$(date +%s)
    local temp_file=$(mktemp)

    # Read current state and update
    jq --arg op "$operation" \
       --arg tool "$tool_name" \
       --arg category "$tool_category" \
       --arg time "$current_time" '
    .tool_calls += 1 |
    .unique_tools |= if . | index($tool) then . else . + [$tool] end |
    .operations += [{operation: $op, tool: $tool, category: $category, timestamp: ($time | tonumber)}] |
    .last_activity = ($time | tonumber) |
    .complexity_score = (.tool_calls + (.unique_tools | length) * 2)
    ' "$SESSION_STATE_FILE" > "$temp_file" && mv "$temp_file" "$SESSION_STATE_FILE"

    # Check if we need to issue warnings or guidance
    check_session_complexity
}

# Check session complexity and provide guidance
check_session_complexity() {
    local session_data
    session_data=$(cat "$SESSION_STATE_FILE")

    local tool_calls
    tool_calls=$(echo "$session_data" | jq -r '.tool_calls')

    local unique_tools_count
    unique_tools_count=$(echo "$session_data" | jq -r '.unique_tools | length')

    local complexity_score
    complexity_score=$(echo "$session_data" | jq -r '.complexity_score')

    local warnings_issued
    warnings_issued=$(echo "$session_data" | jq -r '.warnings_issued')

    # Check for various complexity thresholds
    if [[ $tool_calls -ge $SESSION_TOOL_LIMIT ]]; then
        if ! echo "$warnings_issued" | jq -e '. | index("limit_exceeded")' >/dev/null; then
            issue_complexity_warning "limit_exceeded" "$tool_calls" "$unique_tools_count"
        fi
    elif [[ $tool_calls -ge $SESSION_WARNING_THRESHOLD ]]; then
        if ! echo "$warnings_issued" | jq -e '. | index("approaching_limit")' >/dev/null; then
            issue_complexity_warning "approaching_limit" "$tool_calls" "$unique_tools_count"
        fi
    elif [[ $tool_calls -ge $SESSION_RECOMMENDATION_THRESHOLD ]]; then
        if ! echo "$warnings_issued" | jq -e '. | index("optimization_suggestion")' >/dev/null; then
            issue_complexity_warning "optimization_suggestion" "$tool_calls" "$unique_tools_count"
        fi
    fi

    # Check for tool diversity issues
    if [[ $unique_tools_count -gt 15 && $tool_calls -gt 25 ]]; then
        if ! echo "$warnings_issued" | jq -e '. | index("tool_diversity")' >/dev/null; then
            issue_complexity_warning "tool_diversity" "$tool_calls" "$unique_tools_count"
        fi
    fi
}

# Issue complexity warnings and guidance
issue_complexity_warning() {
    local warning_type="$1"
    local tool_calls="$2"
    local unique_tools="$3"

    case "$warning_type" in
        "limit_exceeded")
            echo ""
            echo "🚨 Session Complexity Alert: Tool Limit Exceeded"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "   Tool calls: $tool_calls (limit: $SESSION_TOOL_LIMIT)"
            echo "   Unique tools: $unique_tools"
            echo ""
            echo "⚠️  Session has exceeded recommended complexity limits."
            echo "🎯 Recommendations:"
            echo "   1. Consider breaking into focused sub-sessions"
            echo "   2. Use /session-management --operation=summary for analysis"
            echo "   3. Start fresh session: /session-management --operation=reset"
            echo ""
            ;;

        "approaching_limit")
            echo ""
            echo "⚠️  Session Complexity Warning: Approaching Limits"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "   Tool calls: $tool_calls (warning at: $SESSION_WARNING_THRESHOLD)"
            echo "   Unique tools: $unique_tools"
            echo ""
            echo "💡 Consider focusing your approach to avoid complexity issues."
            echo "🎯 Suggestions:"
            echo "   • Use targeted operations instead of broad exploration"
            echo "   • Consolidate similar tool operations"
            echo "   • Consider session break if task scope is expanding"
            echo ""
            ;;

        "optimization_suggestion")
            echo ""
            echo "💡 Session Efficiency Suggestion"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "   Tool calls: $tool_calls"
            echo "   Unique tools: $unique_tools"
            echo ""
            echo "🎯 Optimization opportunities:"
            echo "   • Focus on fewer, more targeted tools"
            echo "   • Batch similar operations together"
            echo "   • Use /session-management --operation=optimize for analysis"
            echo ""
            ;;

        "tool_diversity")
            echo ""
            echo "🔄 Tool Diversity Notice"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "   Using many different tools ($unique_tools) in this session"
            echo "   Total operations: $tool_calls"
            echo ""
            echo "💡 Consider specializing your workflow:"
            echo "   • Focus on a specific tool category (MCP, CLI, etc.)"
            echo "   • Use tool-specific skills for complex operations"
            echo "   • Break complex tasks into focused sessions"
            echo ""
            ;;
    esac

    # Record that warning was issued
    local temp_file=$(mktemp)
    jq --arg warning "$warning_type" '.warnings_issued += [$warning]' "$SESSION_STATE_FILE" > "$temp_file" && mv "$temp_file" "$SESSION_STATE_FILE"
}

# Get session summary
get_session_summary() {
    local output_format="${1:-text}"

    if [[ ! -f "$SESSION_STATE_FILE" ]]; then
        echo "No active session found"
        return 1
    fi

    local session_data
    session_data=$(cat "$SESSION_STATE_FILE")

    case "$output_format" in
        "json")
            echo "$session_data"
            ;;
        *)
            echo "📊 Session Complexity Summary"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo ""

            local session_id tool_calls unique_tools complexity_score start_time
            session_id=$(echo "$session_data" | jq -r '.session_id')
            tool_calls=$(echo "$session_data" | jq -r '.tool_calls')
            unique_tools=$(echo "$session_data" | jq -r '.unique_tools | length')
            complexity_score=$(echo "$session_data" | jq -r '.complexity_score')
            start_time=$(echo "$session_data" | jq -r '.start_time')

            echo "Session ID: $session_id"
            echo "Duration: $(format_duration $(($(date +%s) - start_time)))"
            echo ""
            echo "Tool Usage:"
            echo "  Total calls: $tool_calls"
            echo "  Unique tools: $unique_tools"
            echo "  Complexity score: $complexity_score"
            echo ""

            # Show status
            if [[ $tool_calls -ge $SESSION_TOOL_LIMIT ]]; then
                echo "Status: 🚨 Over limit ($SESSION_TOOL_LIMIT)"
            elif [[ $tool_calls -ge $SESSION_WARNING_THRESHOLD ]]; then
                echo "Status: ⚠️  Approaching limit"
            else
                echo "Status: ✅ Within limits"
            fi
            echo ""

            # Show most used tools
            echo "Most Used Tools:"
            echo "$session_data" | jq -r '.operations | group_by(.tool) | sort_by(length) | reverse | .[:5] | .[] | "\(.length)x \(.[0].tool)"' | sed 's/^/  /'
            echo ""

            # Show recommendations
            if [[ $tool_calls -ge $SESSION_WARNING_THRESHOLD ]]; then
                echo "🎯 Recommendations:"
                echo "  • Consider session break or focus"
                echo "  • Use /session-management --operation=reset"
                echo "  • Analyze with /session-management --operation=optimize"
            fi
            ;;
    esac
}

# Format duration in human-readable format
format_duration() {
    local seconds="$1"
    local hours=$((seconds / 3600))
    local minutes=$(((seconds % 3600) / 60))
    local secs=$((seconds % 60))

    if [[ $hours -gt 0 ]]; then
        echo "${hours}h ${minutes}m ${secs}s"
    elif [[ $minutes -gt 0 ]]; then
        echo "${minutes}m ${secs}s"
    else
        echo "${secs}s"
    fi
}

# Optimize session and provide recommendations
optimize_session() {
    if [[ ! -f "$SESSION_STATE_FILE" ]]; then
        echo "No active session to optimize"
        return 1
    fi

    local session_data
    session_data=$(cat "$SESSION_STATE_FILE")

    echo "🔧 Session Optimization Analysis"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Analyze tool usage patterns
    local tool_calls unique_tools
    tool_calls=$(echo "$session_data" | jq -r '.tool_calls')
    unique_tools=$(echo "$session_data" | jq -r '.unique_tools | length')

    # Calculate efficiency metrics
    local tool_efficiency=$((tool_calls > 0 ? (unique_tools * 100) / tool_calls : 0))

    echo "Efficiency Metrics:"
    echo "  Tool diversity ratio: $tool_efficiency% (higher = more diverse)"
    echo "  Average calls per tool: $((tool_calls > 0 && unique_tools > 0 ? tool_calls / unique_tools : 0))"
    echo ""

    # Analyze tool categories
    echo "Tool Category Analysis:"
    echo "$session_data" | jq -r '.operations | group_by(.category) | .[] | "\(.[0].category): \(length) calls"' | sort -k2 -nr | sed 's/^/  /'
    echo ""

    # Provide specific optimization recommendations
    echo "🎯 Optimization Recommendations:"

    if [[ $tool_efficiency -lt 20 ]]; then
        echo "  📈 Low tool diversity detected:"
        echo "     • You're using few tools repeatedly"
        echo "     • Consider batching similar operations"
        echo "     • Look for tool-specific skills for complex workflows"
    fi

    if [[ $unique_tools -gt 15 ]]; then
        echo "  🎯 High tool diversity detected:"
        echo "     • Focus on fewer, more powerful tools"
        echo "     • Use tool categories (MCP, CLI) instead of individual tools"
        echo "     • Consider breaking into specialized sessions"
    fi

    if [[ $tool_calls -gt $SESSION_RECOMMENDATION_THRESHOLD ]]; then
        echo "  ⚡ Session complexity management:"
        echo "     • Consider session break for better focus"
        echo "     • Use targeted operations instead of exploration"
        echo "     • Leverage tool-management fallback chains"
    fi

    # Suggest session reset if needed
    if [[ $tool_calls -ge $SESSION_WARNING_THRESHOLD ]]; then
        echo ""
        echo "💡 Consider starting a fresh session:"
        echo "   /session-management --operation=reset"
    fi
}

# Reset current session
reset_session() {
    if [[ -f "$SESSION_STATE_FILE" ]]; then
        # Archive current session
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Session reset: $(jq -c . "$SESSION_STATE_FILE")" >> "$SESSION_HISTORY_FILE"
        log_info "Current session archived to history"
    fi

    # Start fresh session
    start_new_session
    echo "✅ Session reset complete. Starting with clean complexity tracking."
}

# Get session efficiency recommendations
get_efficiency_recommendations() {
    local current_context="${1:-general}"

    echo "📋 Session Efficiency Guidelines"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🎯 Best Practices:"
    echo ""
    echo "1. **Tool Call Limits**"
    echo "   • Stay under $SESSION_TOOL_LIMIT tool calls per session"
    echo "   • Warning issued at $SESSION_WARNING_THRESHOLD calls"
    echo "   • Optimization suggested at $SESSION_RECOMMENDATION_THRESHOLD calls"
    echo ""
    echo "2. **Focused Approach**"
    echo "   • Use fewer, more targeted tools"
    echo "   • Batch similar operations together"
    echo "   • Leverage tool-specific skills for complex workflows"
    echo ""
    echo "3. **Session Management**"
    echo "   • Break complex tasks into focused sessions"
    echo "   • Use /session-management --operation=summary for tracking"
    echo "   • Reset session when approaching limits"
    echo ""
    echo "4. **Tool Selection Priority**"
    echo "   • Built-in tools: Always preferred (Read, Write, Edit, Bash)"
    echo "   • Specialized skills: For domain-specific operations"
    echo "   • MCP tools: When specific integrations needed"
    echo "   • CLI tools: For system operations and automation"
    echo ""

    case "$current_context" in
        "jira"|"confluence"|"atlassian")
            echo "🎯 Context-Specific Tips (Atlassian):"
            echo "   • Use jira-management or confluence-management skills"
            echo "   • Batch multiple Jira operations together"
            echo "   • Leverage MCP → CLI → Web fallback chain"
            ;;
        "gitlab"|"git")
            echo "🎯 Context-Specific Tips (GitLab):"
            echo "   • Use gitlab-mr-search or gitlab-pipeline-monitoring skills"
            echo "   • Combine GitLab operations in single workflows"
            echo "   • Leverage glab CLI for efficiency"
            ;;
        "code"|"development")
            echo "🎯 Context-Specific Tips (Code Development):"
            echo "   • Use serena-mcp for semantic navigation"
            echo "   • Batch file operations with Read/Write/Edit"
            echo "   • Use code-development skill for complex workflows"
            ;;
    esac
}

# Main execution function
main() {
    local operation="${1:-summary}"
    local context="${2:-general}"

    case "$operation" in
        "init"|"initialize")
            initialize_session_tracking
            ;;
        "record")
            shift 2
            record_tool_usage "$context" "$@"
            ;;
        "check")
            check_session_complexity
            ;;
        "summary")
            get_session_summary "${3:-text}"
            ;;
        "optimize")
            optimize_session
            ;;
        "reset")
            reset_session
            ;;
        "guidelines"|"recommendations")
            get_efficiency_recommendations "$context"
            ;;
        "new-session")
            start_new_session
            ;;
        *)
            log_error "Unknown operation: $operation"
            echo "Usage: $0 {init|record|check|summary|optimize|reset|guidelines|new-session} [context] [args...]"
            return 1
            ;;
    esac
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]:-}" == "${0:-}" ]]; then
    main "$@"
fi