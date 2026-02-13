#!/bin/bash

# Session Management Utility Functions
# Common functions for session tracking, analytics, and cross-skill integration

# Set strict error handling
set -euo pipefail

# Session management configuration
SESSION_TOOL_LIMIT=50
SESSION_WARNING_THRESHOLD=30
SESSION_RECOMMENDATION_THRESHOLD=20
SESSION_CACHE_DIR="$HOME/.claude/session-management"
SESSION_STATE_FILE="$SESSION_CACHE_DIR/session-state.json"
SESSION_HISTORY_FILE="$SESSION_CACHE_DIR/session-history.log"
DEBUG_LOG_PATH="$HOME/.claude/debug/session-management.log"

# Create session management directories
mkdir -p "$SESSION_CACHE_DIR"
mkdir -p "$(dirname "$DEBUG_LOG_PATH")"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
    [[ -f "$DEBUG_LOG_PATH" ]] && echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" >> "$DEBUG_LOG_PATH"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
    [[ -f "$DEBUG_LOG_PATH" ]] && echo "[$(date '+%Y-%m-%d %H:%M:%S')] [SUCCESS] $1" >> "$DEBUG_LOG_PATH"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
    [[ -f "$DEBUG_LOG_PATH" ]] && echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WARNING] $1" >> "$DEBUG_LOG_PATH"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    [[ -f "$DEBUG_LOG_PATH" ]] && echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" >> "$DEBUG_LOG_PATH"
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

# Format tool status output
format_session_status() {
    local status="$1"
    local details="${2:-}"

    local status_icon=""
    case "$status" in
        "healthy"|"within_limits") status_icon="✅" ;;
        "degraded"|"approaching_limits") status_icon="⚠️" ;;
        "critical"|"over_limits") status_icon="🚨" ;;
        "optimization_needed") status_icon="💡" ;;
        "diversity_warning") status_icon="🔄" ;;
        *) status_icon="ℹ️" ;;
    esac

    printf "%s %s" "$status_icon" "$status"
    [[ -n "$details" ]] && printf " (%s)" "$details"
    printf "\n"
}

# Check if session state file exists and is valid
is_session_active() {
    [[ -f "$SESSION_STATE_FILE" ]] && [[ -s "$SESSION_STATE_FILE" ]]
}

# Get session age in seconds
get_session_age() {
    if ! is_session_active; then
        echo "0"
        return 1
    fi

    local start_time
    start_time=$(jq -r '.start_time' "$SESSION_STATE_FILE" 2>/dev/null || echo "0")
    local current_time=$(date +%s)

    echo $((current_time - start_time))
}

# Check if session is stale (>2 hours)
is_session_stale() {
    local session_age
    session_age=$(get_session_age)
    [[ $session_age -gt 7200 ]] # 2 hours
}

# Get current session complexity score
get_complexity_score() {
    if ! is_session_active; then
        echo "0"
        return 1
    fi

    jq -r '.complexity_score' "$SESSION_STATE_FILE" 2>/dev/null || echo "0"
}

# Get current tool call count
get_tool_calls() {
    if ! is_session_active; then
        echo "0"
        return 1
    fi

    jq -r '.tool_calls' "$SESSION_STATE_FILE" 2>/dev/null || echo "0"
}

# Get unique tools count
get_unique_tools_count() {
    if ! is_session_active; then
        echo "0"
        return 1
    fi

    jq -r '.unique_tools | length' "$SESSION_STATE_FILE" 2>/dev/null || echo "0"
}

# Determine session status based on metrics
determine_session_status() {
    local tool_calls
    tool_calls=$(get_tool_calls)
    local unique_tools
    unique_tools=$(get_unique_tools_count)

    if [[ $tool_calls -ge $SESSION_TOOL_LIMIT ]]; then
        echo "critical"
    elif [[ $tool_calls -ge $SESSION_WARNING_THRESHOLD ]]; then
        echo "degraded"
    elif [[ $tool_calls -ge $SESSION_RECOMMENDATION_THRESHOLD ]]; then
        echo "optimization_needed"
    elif [[ $unique_tools -gt 15 && $tool_calls -gt 25 ]]; then
        echo "diversity_warning"
    else
        echo "healthy"
    fi
}

# Archive current session to history
archive_current_session() {
    if is_session_active; then
        local session_data
        session_data=$(cat "$SESSION_STATE_FILE")
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Session archived: $(echo "$session_data" | jq -c .)" >> "$SESSION_HISTORY_FILE"
        log_info "Session archived to history"
    fi
}

# Clean up old session history (keep last 100 entries)
cleanup_session_history() {
    if [[ -f "$SESSION_HISTORY_FILE" ]]; then
        local temp_file=$(mktemp)
        tail -100 "$SESSION_HISTORY_FILE" > "$temp_file" && mv "$temp_file" "$SESSION_HISTORY_FILE"
    fi
}

# Get session statistics for analytics
get_session_statistics() {
    if ! is_session_active; then
        echo "{}"
        return 1
    fi

    local session_data
    session_data=$(cat "$SESSION_STATE_FILE")

    local tool_calls unique_tools complexity_score session_age
    tool_calls=$(echo "$session_data" | jq -r '.tool_calls')
    unique_tools=$(echo "$session_data" | jq -r '.unique_tools | length')
    complexity_score=$(echo "$session_data" | jq -r '.complexity_score')
    session_age=$(get_session_age)

    # Calculate efficiency metrics
    local tool_efficiency=0
    if [[ $tool_calls -gt 0 && $unique_tools -gt 0 ]]; then
        tool_efficiency=$(( (unique_tools * 100) / tool_calls ))
    fi

    local avg_calls_per_tool=0
    if [[ $unique_tools -gt 0 ]]; then
        avg_calls_per_tool=$(( tool_calls / unique_tools ))
    fi

    cat << EOF
{
  "tool_calls": $tool_calls,
  "unique_tools": $unique_tools,
  "complexity_score": $complexity_score,
  "session_age": $session_age,
  "tool_efficiency": $tool_efficiency,
  "avg_calls_per_tool": $avg_calls_per_tool,
  "status": "$(determine_session_status)"
}
EOF
}

# Export functions for use in other scripts
export -f log_info log_success log_warning log_error
export -f format_duration format_session_status
export -f is_session_active get_session_age is_session_stale
export -f get_complexity_score get_tool_calls get_unique_tools_count
export -f determine_session_status archive_current_session cleanup_session_history
export -f get_session_statistics