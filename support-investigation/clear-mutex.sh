#!/bin/sh
#
# clear-mutex.sh - Safely manage Redis mutexes in FUB development environment
#
# Usage:
#   ./clear-mutex.sh <command> [mutex-name]
#
# Commands:
#   list                  - List all current mutexes
#   clear <mutex-name>    - Clear a specific mutex
#   clear-all             - Clear all mutexes (with confirmation)
#
# Common mutex names:
#   migrations            - Clear migrations mutex (fubapp:mutex:migrations-script)
#   deploy                - Clear deployment mutex
#   worker                - Clear worker mutex
#
# Examples:
#   ./clear-mutex.sh list                    # Show all mutexes
#   ./clear-mutex.sh clear migrations        # Clear migrations mutex
#   ./clear-mutex.sh clear-all               # Clear all (interactive)
#
# Features:
#   - Prevents typos in Redis keys (production risk)
#   - Shows mutex status before clearing
#   - Safety confirmations for destructive operations
#   - Color-coded output for readability
#
# Requirements:
#   - redis-cli.sh must be in the same directory
#   - Connection to FUB Redis instance
#

set -eu

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
MUTEX_PREFIX="fubapp:mutex:"
SCRIPT_DIR="$(dirname "$0")"
REDIS_CLI="$SCRIPT_DIR/redis-cli.sh"

# Check if redis-cli.sh exists
if [ ! -f "$REDIS_CLI" ]; then
    printf "${RED}Error: redis-cli.sh not found in %s${NC}\n" "$SCRIPT_DIR"
    exit 1
fi

# Map friendly mutex names to Redis keys
get_mutex_key() {
    case "$1" in
        migrations)
            echo "fubapp:mutex:migrations-script"
            ;;
        deploy)
            echo "fubapp:mutex:deploy"
            ;;
        worker)
            echo "fubapp:mutex:worker"
            ;;
        *)
            # Return empty string for unknown names
            echo ""
            ;;
    esac
}

# Usage function
usage() {
    cat << EOF
Usage: $(basename "$0") <command> [mutex-name]

Safely manage Redis mutexes in FUB development environment.

Commands:
  list                  List all current mutexes
  clear <mutex-name>    Clear a specific mutex (with confirmation)
  clear-all             Clear all mutexes (with confirmation)

Common mutex names:
  migrations            Clear migrations mutex (fubapp:mutex:migrations-script)
  deploy                Clear deployment mutex
  worker                Clear worker mutex

Options:
  -h, --help            Show this help message and exit

Examples:
  $(basename "$0") list                    # Show all mutexes
  $(basename "$0") clear migrations        # Clear migrations mutex
  $(basename "$0") clear-all               # Clear all (interactive)

EOF
    exit 0
}

# Execute redis-cli command via wrapper script
redis_cmd() {
    "$REDIS_CLI" "$@"
}

# List all mutexes
list_mutexes() {
    printf "${BLUE}=== Current Mutexes ===${NC}\n"
    printf "\n"

    # Get all mutex keys
    KEYS=$(redis_cmd KEYS "${MUTEX_PREFIX}*" 2>/dev/null) || {
        printf "${RED}Error: Failed to connect to Redis${NC}\n"
        exit 1
    }

    if [ -z "$KEYS" ]; then
        printf "${GREEN}No mutexes currently held${NC}\n"
        return 0
    fi

    # Display each mutex with TTL
    echo "$KEYS" | while IFS= read -r key; do
        if [ -n "$key" ]; then
            TTL=$(redis_cmd TTL "$key" 2>/dev/null || echo "?")
            VALUE=$(redis_cmd GET "$key" 2>/dev/null || echo "?")

            printf "${CYAN}Key:${NC} %s\n" "$key"
            printf "${CYAN}TTL:${NC} %s seconds\n" "$TTL"
            printf "${CYAN}Value:${NC} %s\n" "$VALUE"
            printf "\n"
        fi
    done

    printf "${YELLOW}Total mutexes:${NC} %s\n" "$(echo "$KEYS" | grep -c .)"
}

# Clear a specific mutex
clear_mutex() {
    MUTEX_NAME="$1"
    REDIS_KEY=""

    # Check if it's a known mutex name
    KNOWN_KEY=$(get_mutex_key "$MUTEX_NAME")
    if [ -n "$KNOWN_KEY" ]; then
        REDIS_KEY="$KNOWN_KEY"
    else
        # Assume it's a full key or construct one
        case "$MUTEX_NAME" in
            fubapp:*)
                REDIS_KEY="$MUTEX_NAME"
                ;;
            *)
                REDIS_KEY="${MUTEX_PREFIX}${MUTEX_NAME}"
                ;;
        esac
    fi

    printf "${BLUE}=== Clear Mutex ===${NC}\n"
    printf "${BLUE}Mutex:${NC} %s\n" "$MUTEX_NAME"
    printf "${BLUE}Redis Key:${NC} %s\n" "$REDIS_KEY"
    printf "\n"

    # Check if mutex exists
    EXISTS=$(redis_cmd EXISTS "$REDIS_KEY" 2>/dev/null || echo "0")

    if [ "$EXISTS" = "0" ]; then
        printf "${YELLOW}Mutex does not exist (already cleared or never set)${NC}\n"
        return 0
    fi

    # Show current value
    VALUE=$(redis_cmd GET "$REDIS_KEY" 2>/dev/null || echo "?")
    TTL=$(redis_cmd TTL "$REDIS_KEY" 2>/dev/null || echo "?")
    printf "${CYAN}Current value:${NC} %s\n" "$VALUE"
    printf "${CYAN}TTL:${NC} %s seconds\n" "$TTL"
    printf "\n"

    # Confirmation
    printf "Clear this mutex? (y/N) "
    read -r REPLY
    echo

    case "$REPLY" in
        [Yy]|[Yy][Ee][Ss])
            redis_cmd DEL "$REDIS_KEY" >/dev/null 2>&1 || {
                printf "${RED}Error: Failed to delete key${NC}\n"
                exit 1
            }
            printf "${GREEN}✓ Mutex cleared${NC}\n"
            ;;
        *)
            printf "${YELLOW}Cancelled${NC}\n"
            ;;
    esac
}

# Clear all mutexes
clear_all_mutexes() {
    printf "${BLUE}=== Clear All Mutexes ===${NC}\n"
    printf "\n"

    # Get all mutex keys
    KEYS=$(redis_cmd KEYS "${MUTEX_PREFIX}*" 2>/dev/null) || {
        printf "${RED}Error: Failed to connect to Redis${NC}\n"
        exit 1
    }

    if [ -z "$KEYS" ]; then
        printf "${GREEN}No mutexes to clear${NC}\n"
        return 0
    fi

    # Count and show keys
    COUNT=$(echo "$KEYS" | grep -c .)
    printf "${YELLOW}Found %s mutex(es):${NC}\n" "$COUNT"
    echo "$KEYS" | while IFS= read -r key; do
        printf "  - %s\n" "$key"
    done
    printf "\n"

    # Strong confirmation
    printf "${RED}WARNING: This will clear ALL mutexes${NC}\n"
    printf "Are you sure? Type 'yes' to confirm: "
    read -r REPLY
    echo

    if [ "$REPLY" = "yes" ]; then
        echo "$KEYS" | while IFS= read -r key; do
            if [ -n "$key" ]; then
                redis_cmd DEL "$key" >/dev/null 2>&1
                printf "${GREEN}✓${NC} Cleared: %s\n" "$key"
            fi
        done
        printf "\n"
        printf "${GREEN}All mutexes cleared${NC}\n"
    else
        printf "${YELLOW}Cancelled${NC}\n"
    fi
}

# Main logic
if [ $# -lt 1 ]; then
    usage
fi

COMMAND="$1"

# Handle help flag
if [ "$COMMAND" = "-h" ] || [ "$COMMAND" = "--help" ]; then
    usage
fi

case "$COMMAND" in
    list)
        list_mutexes
        ;;
    clear)
        if [ $# -lt 2 ]; then
            printf "${RED}Error: Mutex name required${NC}\n"
            printf "${YELLOW}Usage:${NC} %s clear <mutex-name>\n" "$0"
            exit 1
        fi
        clear_mutex "$2"
        ;;
    clear-all)
        clear_all_mutexes
        ;;
    *)
        printf "${RED}Error: Unknown command: %s${NC}\n" "$COMMAND"
        printf "\n"
        usage
        ;;
esac