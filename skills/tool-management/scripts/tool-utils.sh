#!/bin/bash

# Tool Management Utility Functions
# Common functions for tool validation, discovery, and management operations

# Set strict error handling
set -euo pipefail

# Global configuration
TOOL_VALIDATION_TIMEOUT=10
TOOL_CACHE_DIR="$HOME/.claude/tool-management"
DEBUG_LOG_PATH="$HOME/.claude/debug/tool-management.log"

# Create cache directory if it doesn't exist
mkdir -p "$TOOL_CACHE_DIR"

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

# Get list of available MCP servers
get_mcp_servers() {
    # Use dynamic discovery via claude mcp list
    claude mcp list 2>/dev/null | jq -r '.servers[]?.name' 2>/dev/null || {
        # Fallback to known common servers if claude mcp list fails
        echo "atlassian"
        echo "serena"
        echo "databricks"
        echo "glean-tools"
        echo "gitlab-sidekick"
        echo "chrome-devtools"
        echo "context7"
        echo "datadog-production"
        echo "datadog-staging"
    }
}

# Get all available tools across categories
get_all_tools() {
    local category="${1:-all}"

    if [[ "$category" == "all" || "$category" == "mcp" ]]; then
        # MCP tools
        while IFS= read -r server_name; do
            echo "mcp:$server_name"
        done < <(get_mcp_servers)
    fi

    if [[ "$category" == "all" || "$category" == "cli" ]]; then
        # CLI tools
        for cmd in glab acli datadog mysql psql git npm composer ssh curl jq; do
            if command -v "$cmd" >/dev/null 2>&1; then
                echo "cli:$cmd"
            fi
        done
    fi

    if [[ "$category" == "all" || "$category" == "skill" ]]; then
        # Skills
        for skill_dir in ~/.claude/skills/*/; do
            [[ -d "$skill_dir" ]] || continue
            local skill_name=$(basename "$skill_dir")
            echo "skill:$skill_name"
        done
    fi

    if [[ "$category" == "all" || "$category" == "builtin" ]]; then
        # Built-in tools
        for tool in Read Write Edit Bash Glob Grep TaskCreate TaskUpdate AskUserQuestion WebFetch; do
            echo "builtin:$tool"
        done
    fi
}

# Check if a specific MCP server is available
check_mcp_server_availability() {
    local server_name="$1"

    # Check if server is in the list
    if get_mcp_servers | grep -q "^$server_name$"; then
        return 0
    else
        return 1
    fi
}

# Get tool information and metadata
get_tool_info() {
    local tool_spec="$1"
    local category="${tool_spec%%:*}"
    local tool_name="${tool_spec#*:}"

    case "$category" in
        "mcp")
            echo "{\"category\": \"mcp\", \"name\": \"$tool_name\", \"type\": \"server\", \"reliability\": \"medium\"}"
            ;;
        "cli")
            local version=""
            if command -v "$tool_name" >/dev/null 2>&1; then
                version=$($tool_name --version 2>/dev/null | head -1 || echo "unknown")
            fi
            echo "{\"category\": \"cli\", \"name\": \"$tool_name\", \"type\": \"command\", \"version\": \"$version\", \"reliability\": \"high\"}"
            ;;
        "skill")
            local skill_dir="$HOME/.claude/skills/$tool_name"
            if [[ -f "$skill_dir/SKILL.md" ]]; then
                echo "{\"category\": \"skill\", \"name\": \"$tool_name\", \"type\": \"agent_skill\", \"reliability\": \"medium\"}"
            else
                echo "{\"category\": \"skill\", \"name\": \"$tool_name\", \"type\": \"agent_skill\", \"status\": \"missing\"}"
            fi
            ;;
        "builtin")
            echo "{\"category\": \"builtin\", \"name\": \"$tool_name\", \"type\": \"internal\", \"reliability\": \"high\"}"
            ;;
    esac
}

# Cache management functions
cache_tool_status() {
    local tool_spec="$1"
    local status="$2"
    local timestamp=$(date +%s)

    echo "$timestamp:$status" > "$TOOL_CACHE_DIR/${tool_spec//[\/:]/_}.cache"
}

get_cached_tool_status() {
    local tool_spec="$1"
    local cache_file="$TOOL_CACHE_DIR/${tool_spec//[\/:]/_}.cache"
    local max_age="${2:-300}"  # 5 minutes default

    if [[ -f "$cache_file" ]]; then
        local cached_time=$(cut -d: -f1 "$cache_file")
        local current_time=$(date +%s)
        local age=$((current_time - cached_time))

        if [[ $age -le $max_age ]]; then
            cut -d: -f2 "$cache_file"
            return 0
        fi
    fi

    return 1
}

# Tool discovery and classification
discover_tools() {
    local output_format="${1:-text}"

    case "$output_format" in
        "json")
            {
                echo "{"
                echo "  \"mcp_servers\": ["
                while IFS= read -r server; do
                    echo "    \"$server\","
                done < <(get_mcp_servers)
                echo "  ],"
                echo "  \"cli_tools\": ["
                for tool in glab acli datadog git mysql psql npm composer ssh curl jq; do
                    if command -v "$tool" >/dev/null 2>&1; then
                        echo "    \"$tool\","
                    fi
                done
                echo "  ],"
                echo "  \"skills\": ["
                for skill_dir in ~/.claude/skills/*/; do
                    [[ -d "$skill_dir" ]] || continue
                    local skill_name=$(basename "$skill_dir")
                    echo "    \"$skill_name\","
                done
                echo "  ]"
                echo "}"
            } | sed 's/,]/]/g'  # Remove trailing commas
            ;;
        *)
            echo "=== Tool Discovery Report ==="
            echo ""
            echo "MCP Servers:"
            while IFS= read -r server; do
                echo "  - $server"
            done < <(get_mcp_servers)
            echo ""
            echo "CLI Tools:"
            for tool in glab acli datadog git mysql psql npm composer ssh curl jq; do
                if command -v "$tool" >/dev/null 2>&1; then
                    local version=$($tool --version 2>/dev/null | head -1 || echo "")
                    echo "  - $tool ${version:+(${version})}"
                fi
            done
            echo ""
            echo "Skills:"
            for skill_dir in ~/.claude/skills/*/; do
                [[ -d "$skill_dir" ]] || continue
                local skill_name=$(basename "$skill_dir")
                echo "  - $skill_name"
            done
            ;;
    esac
}

# Common tool categories and their expected installation patterns
get_tool_category_info() {
    local category="$1"

    case "$category" in
        "mcp")
            echo "MCP servers require Claude Code configuration and server availability"
            ;;
        "cli")
            echo "CLI tools require installation and may need authentication"
            ;;
        "skill")
            echo "Skills are Claude Code Agent Skills with potential MCP/CLI dependencies"
            ;;
        "builtin")
            echo "Built-in tools are always available in Claude Code"
            ;;
        *)
            echo "Unknown tool category: $category"
            return 1
            ;;
    esac
}

# Utility function to clean old cache files
cleanup_tool_cache() {
    local max_age="${1:-86400}"  # 24 hours default
    local current_time=$(date +%s)

    find "$TOOL_CACHE_DIR" -name "*.cache" -type f | while IFS= read -r cache_file; do
        if [[ -f "$cache_file" ]]; then
            local file_time=$(cut -d: -f1 "$cache_file" 2>/dev/null || echo "0")
            local age=$((current_time - file_time))

            if [[ $age -gt $max_age ]]; then
                rm -f "$cache_file"
                log_info "Cleaned old cache file: $(basename "$cache_file")"
            fi
        fi
    done
}

# Helper function to format tool status output
format_tool_status() {
    local tool_spec="$1"
    local status="$2"
    local details="${3:-}"

    local status_icon=""
    case "$status" in
        "available"|"success") status_icon="✅" ;;
        "unavailable"|"failed") status_icon="❌" ;;
        "auth_required"|"warning") status_icon="⚠️" ;;
        "unknown") status_icon="❓" ;;
        *) status_icon="ℹ️" ;;
    esac

    printf "%s %s: %s" "$status_icon" "$tool_spec" "$status"
    [[ -n "$details" ]] && printf " (%s)" "$details"
    printf "\n"
}

# Export functions for use in other scripts
export -f log_info log_success log_warning log_error
export -f get_mcp_servers get_all_tools check_mcp_server_availability
export -f get_tool_info cache_tool_status get_cached_tool_status
export -f discover_tools get_tool_category_info cleanup_tool_cache format_tool_status