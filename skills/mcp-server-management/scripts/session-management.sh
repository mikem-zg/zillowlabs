#!/bin/bash

# Session Complexity Management for Claude Code
# Helps prevent context bloat and maintains optimal performance

# Get script directory for relative imports
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/mcp-utils.sh"

# Session complexity thresholds
SESSION_WARNING_THRESHOLD=30
SESSION_DANGER_THRESHOLD=50
SESSION_CRITICAL_THRESHOLD=75

# Session tracking file
SESSION_TRACKING_FILE="$HOME/.claude/session-tracking.json"
SESSION_LOG_FILE="$HOME/.claude/session-complexity.log"

# Initialize session tracking if not exists
initialize_session_tracking() {
    if [[ ! -f "$SESSION_TRACKING_FILE" ]]; then
        cat > "$SESSION_TRACKING_FILE" << 'EOF'
{
  "current_session": {
    "session_id": "",
    "start_time": "",
    "tool_count": 0,
    "skill_count": 0,
    "complexity_score": 0,
    "warnings_issued": 0,
    "tools_used": [],
    "skills_used": []
  },
  "session_history": []
}
EOF
    fi
}

# Get current session ID from Claude (if available)
get_current_session_id() {
    # Try to get session ID from environment or recent activity
    # This is a placeholder - actual implementation would depend on how Claude Code exposes session info
    local session_id
    session_id=$(date +%s)_$$
    echo "$session_id"
}

# Update session tracking with new tool usage
track_tool_usage() {
    local tool_name="$1"
    local skill_name="${2:-unknown}"

    initialize_session_tracking

    local session_id=$(get_current_session_id)
    local timestamp=$(date -Iseconds)

    # Update session tracking
    jq --arg tool "$tool_name" \
       --arg skill "$skill_name" \
       --arg session_id "$session_id" \
       --arg timestamp "$timestamp" \
       '
       .current_session.session_id = $session_id |
       .current_session.tool_count += 1 |
       .current_session.tools_used += [$tool] |
       if (.current_session.skills_used | index($skill)) == null then
         .current_session.skills_used += [$skill] |
         .current_session.skill_count += 1
       else . end |
       .current_session.complexity_score = (
         .current_session.tool_count +
         (.current_session.skill_count * 2)
       )
       ' "$SESSION_TRACKING_FILE" > "${SESSION_TRACKING_FILE}.tmp" && \
       mv "${SESSION_TRACKING_FILE}.tmp" "$SESSION_TRACKING_FILE"

    # Log activity
    echo "[$timestamp] Tool: $tool_name, Skill: $skill_name" >> "$SESSION_LOG_FILE"
}

# Get current session complexity
get_session_complexity() {
    initialize_session_tracking

    local tool_count skill_count complexity_score
    tool_count=$(jq -r '.current_session.tool_count // 0' "$SESSION_TRACKING_FILE")
    skill_count=$(jq -r '.current_session.skill_count // 0' "$SESSION_TRACKING_FILE")
    complexity_score=$(jq -r '.current_session.complexity_score // 0' "$SESSION_TRACKING_FILE")

    echo "$tool_count,$skill_count,$complexity_score"
}

# Check if session complexity exceeds thresholds
check_session_complexity_detailed() {
    local complexity_info
    complexity_info=$(get_session_complexity)

    IFS=',' read -r tool_count skill_count complexity_score <<< "$complexity_info"

    # Determine complexity level
    local complexity_level="normal"
    local message=""
    local recommendations=()

    if [[ $tool_count -ge $SESSION_CRITICAL_THRESHOLD ]]; then
        complexity_level="critical"
        message="🚨 CRITICAL: Session complexity extremely high ($tool_count tools, $skill_count skills)"
        recommendations+=(
            "Immediately break into separate sessions"
            "Save current progress and start fresh"
            "Focus on single task completion"
        )
    elif [[ $tool_count -ge $SESSION_DANGER_THRESHOLD ]]; then
        complexity_level="danger"
        message="⚠️ HIGH: Session complexity approaching limits ($tool_count tools, $skill_count skills)"
        recommendations+=(
            "Consider breaking into smaller sessions"
            "Complete current task before adding new ones"
            "Use simpler approaches where possible"
        )
    elif [[ $tool_count -ge $SESSION_WARNING_THRESHOLD ]]; then
        complexity_level="warning"
        message="📊 MODERATE: Session complexity increasing ($tool_count tools, $skill_count skills)"
        recommendations+=(
            "Monitor complexity growth"
            "Consider session optimization"
            "Focus on task completion"
        )
    fi

    # Return structured complexity information
    cat << EOF
{
    "level": "$complexity_level",
    "tool_count": $tool_count,
    "skill_count": $skill_count,
    "complexity_score": $complexity_score,
    "message": "$message",
    "recommendations": [$(printf '"%s",' "${recommendations[@]}" | sed 's/,$//')],
    "should_warn": $([ "$complexity_level" != "normal" ] && echo "true" || echo "false")
}
EOF
}

# Issue complexity warning if threshold exceeded
issue_complexity_warning() {
    local complexity_json
    complexity_json=$(check_session_complexity_detailed)

    local should_warn level message
    should_warn=$(echo "$complexity_json" | jq -r '.should_warn')
    level=$(echo "$complexity_json" | jq -r '.level')
    message=$(echo "$complexity_json" | jq -r '.message')

    if [[ "$should_warn" == "true" ]]; then
        # Update warning count
        jq '.current_session.warnings_issued += 1' "$SESSION_TRACKING_FILE" > "${SESSION_TRACKING_FILE}.tmp" && \
        mv "${SESSION_TRACKING_FILE}.tmp" "$SESSION_TRACKING_FILE"

        echo
        log_warning "$message"

        # Show recommendations
        echo "$complexity_json" | jq -r '.recommendations[]' | while read -r rec; do
            echo "   💡 $rec"
        done
        echo

        # Suggest session break for critical levels
        if [[ "$level" == "critical" ]]; then
            log_error "Session performance may be severely impacted"
            log_info "Strong recommendation: Start a new session"
            return 2
        elif [[ "$level" == "danger" ]]; then
            log_warning "Session approaching performance limits"
            log_info "Consider breaking task into smaller parts"
            return 1
        fi
    fi

    return 0
}

# Analyze session patterns and provide optimization suggestions
analyze_session_patterns() {
    local analysis_period="${1:-7}"  # days

    if [[ ! -f "$SESSION_LOG_FILE" ]]; then
        log_warning "No session history available for analysis"
        return 1
    fi

    log_info "Analyzing session patterns from last $analysis_period days..."

    # Calculate since date
    local since_date
    if command -v gdate >/dev/null 2>&1; then
        since_date=$(gdate -d "$analysis_period days ago" "+%Y-%m-%d")
    else
        since_date=$(date -v-${analysis_period}d "+%Y-%m-%d")
    fi

    # Analyze patterns
    awk -v since="$since_date" '
    BEGIN {
        total_tools = 0
        total_sessions = 0
        max_tools = 0
        skill_usage = ""
        tool_usage = ""
    }
    $1 >= since {
        # Extract tool and skill info
        if (match($0, /Tool: ([^,]+)/, tool_match) && match($0, /Skill: ([^$]+)/, skill_match)) {
            tool = tool_match[1]
            skill = skill_match[1]

            total_tools++

            # Track unique skills
            if (index(skill_usage, skill) == 0) {
                skill_usage = skill_usage skill ","
            }

            # Track tool frequency
            tools[tool]++
            skills[skill]++
        }
    }
    END {
        print "=== Session Pattern Analysis ==="
        print "Analysis period:", since, "to", strftime("%Y-%m-%d")
        print "Total tool calls:", total_tools
        print ""

        print "Most used tools:"
        PROCINFO["sorted_in"] = "@val_num_desc"
        for (tool in tools) {
            if (tools[tool] > 1) {
                printf "  %s: %d calls\n", tool, tools[tool]
            }
        }

        print ""
        print "Most used skills:"
        for (skill in skills) {
            if (skills[skill] > 1) {
                printf "  %s: %d calls\n", skill, skills[skill]
            }
        }

        print ""
        if (total_tools > 0) {
            avg_complexity = total_tools / 7  # Rough daily average
            print "Average daily complexity:", int(avg_complexity), "tools"

            if (avg_complexity > 30) {
                print "⚠️  High average complexity detected"
                print "💡 Consider shorter, more focused sessions"
            } else if (avg_complexity > 15) {
                print "📊 Moderate complexity - within normal range"
            } else {
                print "✅ Good session complexity management"
            }
        }
    }
    ' "$SESSION_LOG_FILE"
}

# Start new session (reset tracking)
start_new_session() {
    initialize_session_tracking

    # Archive current session to history
    local current_session
    current_session=$(jq '.current_session' "$SESSION_TRACKING_FILE")

    if [[ "$current_session" != "null" ]] && [[ $(echo "$current_session" | jq -r '.tool_count') -gt 0 ]]; then
        jq --argjson session "$current_session" \
           '.session_history += [$session]' "$SESSION_TRACKING_FILE" > "${SESSION_TRACKING_FILE}.tmp" && \
           mv "${SESSION_TRACKING_FILE}.tmp" "$SESSION_TRACKING_FILE"
    fi

    # Reset current session
    local new_session_id=$(get_current_session_id)
    local start_time=$(date -Iseconds)

    jq --arg session_id "$new_session_id" \
       --arg start_time "$start_time" \
       '.current_session = {
         "session_id": $session_id,
         "start_time": $start_time,
         "tool_count": 0,
         "skill_count": 0,
         "complexity_score": 0,
         "warnings_issued": 0,
         "tools_used": [],
         "skills_used": []
       }' "$SESSION_TRACKING_FILE" > "${SESSION_TRACKING_FILE}.tmp" && \
       mv "${SESSION_TRACKING_FILE}.tmp" "$SESSION_TRACKING_FILE"

    log_success "Started new session: $new_session_id"
    echo "Session tracking reset - ready for optimal performance"
}

# Get session summary for user
get_session_summary() {
    local complexity_info
    complexity_info=$(get_session_complexity)

    IFS=',' read -r tool_count skill_count complexity_score <<< "$complexity_info"

    echo "=== Current Session Summary ==="
    echo "Tools used: $tool_count"
    echo "Skills used: $skill_count"
    echo "Complexity score: $complexity_score"
    echo

    if [[ $tool_count -eq 0 ]]; then
        echo "✨ Fresh session - optimal performance expected"
    elif [[ $tool_count -lt $SESSION_WARNING_THRESHOLD ]]; then
        echo "✅ Session complexity: Optimal"
    elif [[ $tool_count -lt $SESSION_DANGER_THRESHOLD ]]; then
        echo "📊 Session complexity: Moderate (monitor growth)"
    elif [[ $tool_count -lt $SESSION_CRITICAL_THRESHOLD ]]; then
        echo "⚠️ Session complexity: High (consider breaking up)"
    else
        echo "🚨 Session complexity: Critical (immediate action needed)"
    fi

    # Show most used tools/skills
    if [[ $tool_count -gt 5 ]]; then
        echo
        echo "Recent activity:"
        jq -r '.current_session.tools_used | group_by(.) | map({tool: .[0], count: length}) | sort_by(-.count) | .[0:5][] | "  \(.tool): \(.count) calls"' "$SESSION_TRACKING_FILE"
    fi
}

# Optimize session by providing specific recommendations
optimize_session() {
    local complexity_json
    complexity_json=$(check_session_complexity_detailed)

    local tool_count skill_count level
    tool_count=$(echo "$complexity_json" | jq -r '.tool_count')
    skill_count=$(echo "$complexity_json" | jq -r '.skill_count')
    level=$(echo "$complexity_json" | jq -r '.level')

    echo "=== Session Optimization Recommendations ==="
    echo

    case "$level" in
        "critical")
            log_error "IMMEDIATE ACTION REQUIRED"
            echo "1. 🛑 Stop current session and save progress"
            echo "2. 📝 Document where you left off"
            echo "3. 🔄 Start fresh session with: start_new_session"
            echo "4. 🎯 Focus on single task completion only"
            ;;
        "danger")
            log_warning "SESSION OPTIMIZATION NEEDED"
            echo "1. 🎯 Complete current task before adding new ones"
            echo "2. 🔄 Consider breaking remaining work into phases"
            echo "3. 📊 Use simpler approaches where possible"
            echo "4. 💾 Save progress and consider session break"
            ;;
        "warning")
            log_info "OPTIMIZATION OPPORTUNITIES"
            echo "1. 📋 Prioritize remaining tasks by importance"
            echo "2. 🎯 Focus on task completion over exploration"
            echo "3. 📊 Monitor complexity growth"
            echo "4. 🔍 Use targeted tools rather than broad searches"
            ;;
        *)
            log_success "SESSION RUNNING OPTIMALLY"
            echo "Current session complexity is well-managed"
            echo "Continue with normal operations"
            ;;
    esac

    # Provide tool-specific recommendations
    if [[ $tool_count -gt 20 ]]; then
        echo
        echo "🔧 Tool Usage Optimization:"
        echo "  • Use specific queries instead of broad searches"
        echo "  • Combine related operations where possible"
        echo "  • Prefer CLI fallbacks for simple operations"
        echo "  • Cache information to avoid repeat tool calls"
    fi

    if [[ $skill_count -gt 8 ]]; then
        echo
        echo "🎯 Skill Usage Optimization:"
        echo "  • Focus on 1-2 primary skills per session"
        echo "  • Complete skill-specific tasks before switching"
        echo "  • Use Task management for complex workflows"
    fi
}

# Export functions for use by other scripts/skills
export -f initialize_session_tracking track_tool_usage get_session_complexity
export -f check_session_complexity_detailed issue_complexity_warning
export -f analyze_session_patterns start_new_session get_session_summary optimize_session