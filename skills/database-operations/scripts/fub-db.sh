#!/usr/bin/env bash
if [[ "${DEBUG:-}" == "1" ]]; then
    echo "DEBUG: Script started with $# arguments: $@"
    echo "DEBUG: Individual arguments:"
    for i in $(seq 1 $#); do
        echo "  \$${i}: '${!i}'"
    done
fi
#
# fub-db.sh - Connect to FUB databases (common or client) on dev/qa environments
#
# Usage:
#   ./fub-db.sh connect <environment> <database-type> [account-id]
#   ./fub-db.sh credentials <environment> <database-type> [account-id]
#   ./fub-db.sh query <environment> <database-type> [account-id] <sql>
#
# Subcommands:
#   connect       - Interactive MySQL connection (original behavior)
#   credentials   - Show database credentials only (Claude Code friendly)
#   query        - Execute single SQL query and return results
#
# Arguments:
#   environment    - dev or qa
#   database-type  - common or client
#   account-id     - Required for client databases (e.g., 123)
#
# Examples:
#   ./fub-db.sh connect dev common              # Connect to dev common database
#   ./fub-db.sh connect qa client 123          # Connect to dev client DB for account 123
#   ./fub-db.sh credentials dev client 123     # Show account 123's DB credentials
#   ./fub-db.sh query dev common "SELECT COUNT(*) FROM accounts"  # Execute query
#
# Features:
#   - Reads credentials from apps/richdesk/config/bootstrap/connections.php
#   - Automatic credential lookup for client databases via common database query
#   - Environment-specific connection handling
#   - Proper SSH agent forwarding
#   - Claude Code friendly: credentials/query modes for automation
#
# Requirements:
#   - SSH access to fubdev configured
#   - mysql client installed locally or on remote
#   - Appropriate database permissions

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Source cache utilities if available
CACHE_UTILS_PATH="$(dirname "$0")/cache-manager.sh"
QUERY_CLASSIFIER_PATH="$(dirname "$0")/query-classifier.sh"

if [[ -f "$CACHE_UTILS_PATH" && -f "$QUERY_CLASSIFIER_PATH" ]]; then
    source "$CACHE_UTILS_PATH"
    source "$QUERY_CLASSIFIER_PATH"
    CACHE_AVAILABLE=1
else
    CACHE_AVAILABLE=0
fi

# Usage function
usage() {
    cat << EOF
Usage: $(basename "$0") <subcommand> [environment] <database-type> [account-id] [arguments]

Connect to FUB databases (common or client) on dev/qa environments.

Subcommands:
  connect         Interactive MySQL connection (original behavior)
  credentials     Show database credentials only (Claude Code friendly)
  query           Execute single SQL query and return results
  cache           Manage query result cache (clear, status, clear-table)
  list-tables     List all tables in the specified database (cached)
  list-columns    List columns for a given table (cached)

Arguments:
  environment      dev or qa (defaults to dev for list-tables and list-columns)
  database-type    common or client
  account-id       Account ID for client databases (e.g., 123). Optional for client - will auto-discover
  sql             SQL query (required for query subcommand)
  table-name      Table name (required for list-columns subcommand)

Options:
  -h, --help       Show this help message and exit

Features:
  - Reads credentials from apps/richdesk/config/bootstrap/connections.php
  - Automatic credential lookup for client databases via common database query
  - Auto-discovery of client databases (client_0, client_1, etc.) when account ID not specified
  - Environment-specific connection handling
  - Proper SSH agent forwarding
  - Claude Code friendly: credentials/query modes for automation
  - Caching support for table listings and schema queries

Requirements:
  - SSH access to fubdev configured
  - mysql client installed locally or on remote
  - Appropriate database permissions

Examples:
  $(basename "$0") connect dev common                    # Connect to dev common database
  $(basename "$0") connect qa client 123                # Connect to qa client DB for account 123
  $(basename "$0") connect qa client                     # Connect to qa client DB (auto-discover)
  $(basename "$0") credentials dev client 123           # Show account 123's DB credentials
  $(basename "$0") query dev common "SELECT COUNT(*) FROM accounts"      # Execute query
  $(basename "$0") cache dev common status              # Show cache status
  $(basename "$0") list-tables common                   # List tables in dev common database
  $(basename "$0") list-tables dev common               # List tables in dev common database
  $(basename "$0") list-tables qa client 123            # List tables in qa client database
  $(basename "$0") list-tables client                   # List tables in dev client database (auto-discover)
  $(basename "$0") list-columns common accounts         # List columns in accounts table (dev common)
  $(basename "$0") list-columns dev client 123 users    # List columns in users table (dev client)
  $(basename "$0") list-columns client users            # List columns in users table (dev client auto-discover)
  $(basename "$0") --help                               # Show this help

EOF
    exit 0
}

# Handle help flag first
if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
    usage
fi

# Parse arguments - handle new subcommands with environment defaulting
SUBCOMMAND="$1"

# For list-tables and list-columns, allow environment to default to 'dev'
if [[ "$SUBCOMMAND" =~ ^(list-tables|list-columns)$ ]]; then
    # Check if second argument looks like an environment or database type
    if [[ "${2:-}" =~ ^(dev|qa)$ ]]; then
        # Traditional format: subcommand environment db-type ...
        if [[ $# -lt 3 ]]; then
            echo -e "${RED}Error: Insufficient arguments${NC}"
            echo ""
            usage
        fi
        ENVIRONMENT="$2"
        DB_TYPE="$3"
        SHIFT_OFFSET=0
    else
        # Environment omitted, default to 'dev': subcommand db-type ...
        if [[ $# -lt 2 ]]; then
            echo -e "${RED}Error: Insufficient arguments${NC}"
            echo ""
            usage
        fi
        ENVIRONMENT="dev"
        DB_TYPE="$2"
        SHIFT_OFFSET=1  # Arguments shifted by one position
    fi
else
    # Traditional subcommands require all arguments
    if [[ $# -lt 3 ]]; then
        echo -e "${RED}Error: Insufficient arguments${NC}"
        echo ""
        usage
    fi
    ENVIRONMENT="$2"
    DB_TYPE="$3"
    SHIFT_OFFSET=0
fi

# Handle optional account ID and additional arguments positioning
if [[ "$DB_TYPE" == "client" ]]; then
    if [[ $SHIFT_OFFSET -eq 0 ]]; then
        # Traditional format: subcommand env client [account-id] [table-name/sql]
        ACCOUNT_ID="${4:-}"
        SQL_QUERY="${5:-}"
        TABLE_NAME="${5:-}"  # For list-columns
    else
        # Environment omitted: subcommand client [account-id-or-table] [table-name]
        # Need to determine if position 3 is account ID or table name
        ARG3="${3:-}"
        ARG4="${4:-}"

        # For list-columns, if we have both ARG3 and ARG4, ARG3 is account_id and ARG4 is table
        # If we only have ARG3, it could be either account_id or table name
        # Heuristic: if ARG3 is numeric, treat as account_id; otherwise treat as table name
        if [[ "$SUBCOMMAND" == "list-columns" ]]; then
            if [[ -n "$ARG4" ]]; then
                # Both present: ARG3=account_id, ARG4=table_name
                ACCOUNT_ID="$ARG3"
                TABLE_NAME="$ARG4"
                SQL_QUERY="$ARG4"
            elif [[ "$ARG3" =~ ^[0-9]+$ ]]; then
                # ARG3 is numeric, likely account_id, missing table name
                ACCOUNT_ID="$ARG3"
                TABLE_NAME=""
                SQL_QUERY=""
            else
                # ARG3 is not numeric, likely table name for auto-discovery
                ACCOUNT_ID=""
                TABLE_NAME="$ARG3"
                SQL_QUERY="$ARG3"
            fi
        else
            # For other subcommands (list-tables)
            if [[ "$ARG3" =~ ^[0-9]+$ ]]; then
                # Numeric, treat as account_id
                ACCOUNT_ID="$ARG3"
                SQL_QUERY="$ARG4"
                TABLE_NAME="$ARG4"
            else
                # Non-numeric, for list-tables this would be unexpected, but handle gracefully
                ACCOUNT_ID=""
                SQL_QUERY="$ARG3"
                TABLE_NAME="$ARG3"
            fi
        fi
    fi
else
    # For common database, account ID not needed
    if [[ $SHIFT_OFFSET -eq 0 ]]; then
        ACCOUNT_ID=""
        SQL_QUERY="${4:-}"
        TABLE_NAME="${4:-}"  # For list-columns
    else
        ACCOUNT_ID=""
        SQL_QUERY="${3:-}"
        TABLE_NAME="${3:-}"  # For list-columns
    fi
fi

# Debug argument parsing results
if [[ "${DEBUG:-}" == "1" ]]; then
    echo "DEBUG: Parsed arguments:"
    echo "  SUBCOMMAND: '$SUBCOMMAND'"
    echo "  ENVIRONMENT: '$ENVIRONMENT'"
    echo "  DB_TYPE: '$DB_TYPE'"
    echo "  ACCOUNT_ID: '${ACCOUNT_ID:-<not set>}'"
    echo "  SQL_QUERY: '${SQL_QUERY:-<not set>}' (${#SQL_QUERY} chars)"
fi

# Validate subcommand
if [[ ! "$SUBCOMMAND" =~ ^(connect|credentials|query|cache|list-tables|list-columns)$ ]]; then
    echo -e "${RED}Error: Invalid subcommand '$SUBCOMMAND'${NC}"
    echo -e "${YELLOW}Valid subcommands: connect, credentials, query, cache, list-tables, list-columns${NC}"
    exit 1
fi

# Validate environment
if [[ ! "$ENVIRONMENT" =~ ^(dev|qa)$ ]]; then
    echo -e "${RED}Error: Environment must be 'dev' or 'qa'${NC}"
    exit 1
fi

# Validate database type
if [[ ! "$DB_TYPE" =~ ^(common|client)$ ]]; then
    echo -e "${RED}Error: Database type must be 'common' or 'client'${NC}"
    exit 1
fi

# Validate account ID for client databases (except for new subcommands that support auto-discovery)
if [[ "$DB_TYPE" == "client" ]] && [[ -z "$ACCOUNT_ID" ]] && [[ ! "$SUBCOMMAND" =~ ^(list-tables|list-columns)$ ]]; then
    echo -e "${RED}Error: Account ID required for client databases with this subcommand${NC}"
    echo -e "${YELLOW}Usage:${NC} $0 $SUBCOMMAND $ENVIRONMENT client <account-id>"
    echo -e "${YELLOW}Note:${NC} list-tables and list-columns support auto-discovery: $0 $SUBCOMMAND client"
    exit 1
fi

# Configuration - Environment-specific remote hosts
CURRENT_USER=$(whoami)
if [[ "$ENVIRONMENT" == "dev" ]]; then
    REMOTE_HOST="fubdev-${CURRENT_USER}-dev-01"
elif [[ "$ENVIRONMENT" == "qa" ]]; then
    # Dynamically find QA server IP from Tailscale
    QA_IP=$(tailscale status | grep fub-control-qa-01 | awk '{print $1}')
    if [[ -z "$QA_IP" ]]; then
        echo -e "${RED}Error: Could not find fub-control-qa-01 in Tailscale status${NC}"
        echo -e "${YELLOW}Run 'tailscale status' to check available hosts${NC}"
        exit 1
    fi
    REMOTE_HOST="root@${QA_IP}"
else
    echo -e "${RED}Error: Unsupported environment '$ENVIRONMENT'${NC}"
    exit 1
fi

# Helper function to extract socket path from unix(...) format
# Arguments: host_string (e.g., "unix(/var/run/mysql.sock)")
# Returns: clean socket path (e.g., "/var/run/mysql.sock")
extract_socket_path() {
    local host_string="$1"
    echo "$host_string" | sed 's/unix(//' | sed 's/)//'
}

# Function to get working database credentials with connection testing and fallback logic
get_working_credentials() {
    local environment="$1"
    local database_type="${2:-common}"  # Default to common database

    # Parse connections.php to get initial configuration
    local connections_result
    connections_result=$(ssh "$REMOTE_HOST" "cd /var/www/fub && cat apps/richdesk/config/bootstrap/connections.php" 2>/dev/null)

    if [[ -z "$connections_result" ]]; then
        # Fallback to connections.php.example
        connections_result=$(ssh "$REMOTE_HOST" "cd /var/www/fub && cat apps/richdesk/config/bootstrap/connections.php.example" 2>/dev/null)
        if [[ -z "$connections_result" ]]; then
            echo "Error: Could not read connections.php or connections.php.example" >&2
            exit 1
        fi
    fi

    # Local helper function to parse individual credential fields from current_section
    # Arguments: field_name (e.g., "host", "login", "password", "database")
    # Returns: extracted field value from current_section variable
    parse_field() {
        local field_name="$1"
        echo "$current_section" | grep "'$field_name'" | head -n 1 | sed "s/.*=> *'//" | sed "s/'.*//"
    }

    # Helper function to test MySQL connection with provided credentials
    # Arguments: host, login, password, database
    # Returns: non-empty string if connection successful, empty string if failed
    test_mysql_connection() {
        local test_host="$1"
        local test_login="$2"
        local test_password="$3"
        local test_database="$4"

        local mysql_env=""
        if [[ -n "$test_password" ]]; then
            mysql_env="MYSQL_PWD='$test_password' "
        fi

        if [[ "$test_host" == unix* ]]; then
            local socket_path
            socket_path=$(extract_socket_path "$test_host")
            ssh "$REMOTE_HOST" "cd /var/www/fub && ${mysql_env}mysql -S $socket_path -u '$test_login' '$test_database' -e 'SELECT 1;' 2>/dev/null" || echo ""
        else
            ssh "$REMOTE_HOST" "cd /var/www/fub && ${mysql_env}mysql -h '$test_host' -u '$test_login' '$test_database' -e 'SELECT 1;' 2>/dev/null" || echo ""
        fi
    }

    # Helper function to load all credentials from connections.php section
    # Arguments: sed_pattern (e.g., "/if.*test/,/} else {/p")
    # Side effects: Sets host, login, password, database variables
    load_credentials() {
        local sed_pattern="$1"
        current_section=$(echo "$connections_result" | sed -n "$sed_pattern")
        host=$(parse_field "host")
        login=$(parse_field "login")
        password=$(parse_field "password")
        database=$(parse_field "database")
    }

    # Parse initial configuration based on environment
    local host login password database current_section
    if [[ "$environment" == "dev" ]]; then
        # Test actual PHP conditions from connections.php
        local is_test_env
        is_test_env=$(ssh "$REMOTE_HOST" "cd /var/www/fub && php -r '
            \$is_test = preg_match(\"/(^|\\\\.)test\\\\./\", \$_SERVER[\"HTTP_HOST\"] ?? \"\") ||
                       (\$_SERVER[\"ENVIRONMENT\"] ?? \"\") === \"test\" ||
                       getenv(\"ENVIRONMENT\") === \"test\";
            echo \$is_test ? \"true\" : \"false\";
        '")

        if [[ "$is_test_env" == "true" ]]; then
            load_credentials "/if.*test/,/} else {/p"
        else
            load_credentials "/} else {/,/^}/p"
        fi
    else
        # For other environments, parse connections.php ArConnections::add section
        current_section=$(ssh "$REMOTE_HOST" "cd /var/www/fub && sed -n \"/ArConnections::add('common'/,/));/p\" apps/richdesk/config/bootstrap/connections.php | head -n 20" 2>/dev/null)

        if [[ -z "$current_section" ]]; then
            if [[ "${DEBUG:-}" == "1" ]]; then
                echo -e "${RED}Error: Could not read connections.php${NC}" >&2
            else
                echo "Error: Could not read connections.php" >&2
            fi
            exit 1
        fi

        # Parse credentials using helper functions, filtering out commented lines
        host=$(echo "$current_section" | grep "'host'" | grep -v "^[[:space:]]*//.*'host'" | head -n 1 | sed "s/.*=> *'//" | sed "s/'.*//" | tail -n 1)
        login=$(echo "$current_section" | grep "'login'" | grep -v "^[[:space:]]*//.*'login'" | head -n 1 | sed "s/.*=> *'//" | sed "s/'.*//" | tail -n 1)
        password=$(echo "$current_section" | grep "'password'" | grep -v "^[[:space:]]*//.*'password'" | head -n 1 | sed "s/.*=> *'//" | sed "s/'.*//" | tail -n 1)
        database=$(echo "$current_section" | grep "'database'" | grep -v "^[[:space:]]*//.*'database'" | head -n 1 | sed "s/.*=> *'//" | sed "s/'.*//" | tail -n 1)
    fi

    if [[ "${DEBUG:-}" == "1" ]]; then
        echo "DEBUG: Initial credentials parsed:" >&2
        echo "  host='$host'" >&2
        echo "  login='$login'" >&2
        echo "  password='$password'" >&2
        echo "  database='$database'" >&2
    fi

    # Validate basic parsing
    if [[ -z "$host" || -z "$login" || -z "$database" ]]; then
        if [[ "${DEBUG:-}" == "1" ]]; then
            echo -e "${RED}Error: Could not parse all database credentials${NC}" >&2
        else
            echo "Error: Could not parse all database credentials" >&2
        fi
        exit 1
    fi

    # Test the connection and apply fallback logic if needed
    local test_connection
    test_connection=$(test_mysql_connection "$host" "$login" "$password" "$database")

    # Apply intelligent fallback logic for dev environment
    if [[ -z "$test_connection" && "$environment" == "dev" ]]; then
        if [[ "${DEBUG:-}" == "1" ]]; then
            echo "DEBUG: Initial connection test failed, applying fallback logic" >&2
        fi

        # Try parsed test configuration as fallback
        if [[ "$database" == "common" ]]; then
            if [[ "${DEBUG:-}" == "1" ]]; then
                echo "DEBUG: Falling back to parsed test database configuration" >&2
            fi
            load_credentials "/if.*test/,/} else {/p"

            # Test fallback connection
            test_connection=$(test_mysql_connection "$host" "$login" "$password" "$database")

            if [[ -n "$test_connection" ]]; then
                if [[ "${DEBUG:-}" == "1" ]]; then
                    echo "DEBUG: Fallback configuration successful" >&2
                fi
            else
                if [[ "${DEBUG:-}" == "1" ]]; then
                    echo "DEBUG: Fallback configuration also failed" >&2
                fi
            fi
        fi
    fi

    # Final validation - warn but don't fail if connection test fails in non-debug mode
    if [[ -z "$test_connection" ]]; then
        if [[ "${DEBUG:-}" == "1" ]]; then
            echo "DEBUG: Warning - Connection test failed, but proceeding with parsed credentials" >&2
        fi
    else
        if [[ "${DEBUG:-}" == "1" ]]; then
            echo "DEBUG: Connection test successful" >&2
        fi
    fi

    # Warn about empty password in debug mode but allow it
    if [[ -z "$password" && "${DEBUG:-}" == "1" ]]; then
        echo "DEBUG: Warning - empty password (allowed in dev environment)" >&2
    fi

    echo "$host|$login|$password|$database"
}

# Function to auto-discover client database
auto_discover_client_db() {
    # First get working common database credentials
    local common_creds
    common_creds=$(get_working_credentials "$ENVIRONMENT" "common")
    IFS='|' read -r COMMON_HOST COMMON_USER COMMON_PASS COMMON_DB <<< "$common_creds"

    # Look for client databases like client_0, client_1, etc.
    local discovery_query="SELECT id, db_host, db_database, db_user, db_pass FROM accounts WHERE db_database LIKE 'client_%' ORDER BY id LIMIT 1;"
    local mysql_cmd

    # Use MYSQL_PWD environment variable for password (FUB pattern)
    local mysql_env=""
    if [[ -n "$COMMON_PASS" ]]; then
        mysql_env="MYSQL_PWD='$COMMON_PASS' "
    fi

    if [[ "$COMMON_HOST" == unix* ]]; then
        # Extract socket path from unix(...) format
        local socket_path
        socket_path=$(extract_socket_path "$COMMON_HOST")
        mysql_cmd="${mysql_env}mysql -S $socket_path -u $COMMON_USER $COMMON_DB"
    else
        # TCP connection
        mysql_cmd="${mysql_env}mysql -h $COMMON_HOST -u $COMMON_USER $COMMON_DB"
    fi

    local query_cmd="cd /var/www/fub && echo \"$discovery_query\" | $mysql_cmd -s -N"
    local result
    result=$(ssh "$REMOTE_HOST" "$query_cmd") || {
        if [[ "${DEBUG:-}" == "1" ]]; then
            echo -e "${RED}Error: Failed to auto-discover client database${NC}" >&2
        else
            echo "Error: Failed to auto-discover client database" >&2
        fi
        exit 1
    }

    if [[ -z "$result" ]]; then
        if [[ "${DEBUG:-}" == "1" ]]; then
            echo -e "${RED}Error: No client databases found for auto-discovery${NC}" >&2
        else
            echo "Error: No client databases found for auto-discovery" >&2
        fi
        exit 1
    fi

    # Parse result: id, db_host, db_database, db_user, db_pass
    IFS=$'\t' read -r DISCOVERED_ID DISCOVERED_HOST DISCOVERED_DB DISCOVERED_USER DISCOVERED_PASS <<< "$result"

    if [[ "${DEBUG:-}" == "1" ]]; then
        echo -e "${GREEN}✓ Auto-discovered client database:${NC} $DISCOVERED_DB (account $DISCOVERED_ID) on $DISCOVERED_HOST" >&2
    fi

    # Return in format expected by get_client_credentials
    echo "$DISCOVERED_HOST"$'\t'"$DISCOVERED_DB"$'\t'"$DISCOVERED_USER"$'\t'"$DISCOVERED_PASS"

    # Set global ACCOUNT_ID for use in caching
    ACCOUNT_ID="$DISCOVERED_ID"
}

# Function to get client database credentials via common database query
get_client_credentials() {
    local account_id="$1"

    # First get working common database credentials
    local common_creds
    common_creds=$(get_working_credentials "$ENVIRONMENT" "common")
    IFS='|' read -r COMMON_HOST COMMON_USER COMMON_PASS COMMON_DB <<< "$common_creds"

    # Query accounts table for client database info
    local client_query="SELECT db_host, db_database, db_user, db_pass FROM accounts WHERE id = $account_id LIMIT 1;"
    local mysql_cmd

    # Use MYSQL_PWD environment variable for password (FUB pattern)
    local mysql_env=""
    if [[ -n "$COMMON_PASS" ]]; then
        mysql_env="MYSQL_PWD='$COMMON_PASS' "
    fi

    if [[ "$COMMON_HOST" == unix* ]]; then
        # Extract socket path from unix(...) format
        local socket_path
        socket_path=$(extract_socket_path "$COMMON_HOST")
        mysql_cmd="${mysql_env}mysql -S $socket_path -u $COMMON_USER $COMMON_DB"
    else
        # TCP connection
        mysql_cmd="${mysql_env}mysql -h $COMMON_HOST -u $COMMON_USER $COMMON_DB"
    fi

    local query_cmd="cd /var/www/fub && echo \"$client_query\" | $mysql_cmd -s -N"
    local result
    result=$(ssh "$REMOTE_HOST" "$query_cmd") || {
        if [[ "${DEBUG:-}" == "1" ]]; then
            echo -e "${RED}Error: Failed to lookup client database credentials for account $account_id${NC}" >&2
        else
            echo "Error: Failed to lookup client database credentials for account $account_id" >&2
        fi
        exit 1
    }

    if [[ -z "$result" ]]; then
        if [[ "${DEBUG:-}" == "1" ]]; then
            echo -e "${RED}Error: Account $account_id not found${NC}" >&2
        else
            echo "Error: Account $account_id not found" >&2
        fi
        exit 1
    fi

    echo "$result"
}

# Function to execute single query and return results
execute_query() {
    local sql_query="$1"

    # Use caching if available
    if [[ "$CACHE_AVAILABLE" == "1" ]]; then
        # Classify query for caching
        local query_classification
        query_classification=$(classify_query_for_cache "$sql_query")

        if [[ "${DEBUG:-}" == "1" ]]; then
            echo "DEBUG: Query classification: '$query_classification'" >&2
        fi

        # Check cache first for SHOW TABLES and DESCRIBE queries
        if [[ "$query_classification" == "tables" ]] || [[ "$query_classification" =~ ^schema: ]]; then
            local cache_result
            if cache_result=$(check_cache "$ENVIRONMENT" "$DB_TYPE" "$ACCOUNT_ID" "$query_classification"); then
                if [[ "${DEBUG:-}" == "1" ]]; then
                    echo "DEBUG: Cache HIT for $query_classification" >&2
                fi
                echo "$cache_result"
                return 0
            fi

            if [[ "${DEBUG:-}" == "1" ]]; then
                echo "DEBUG: Cache MISS for $query_classification" >&2
            fi
        fi
    fi

    # Execute query normally (existing logic)
    build_mysql_command

    if [[ "${DEBUG:-}" == "1" ]]; then
        echo "DEBUG: MYSQL_CMD = '$MYSQL_CMD'" >&2
        echo "DEBUG: REMOTE_HOST = '$REMOTE_HOST'" >&2
    fi

    # Execute query via SSH and capture results
    local query_result
    query_result=$(ssh "$REMOTE_HOST" "cd /var/www/fub && echo \"$sql_query\" | $MYSQL_CMD -s -N" 2>&1)
    local query_exit_code=$?

    # Handle errors and cache invalidation
    if [[ $query_exit_code -ne 0 ]]; then
        # Check for table/column not found errors (strict requirement)
        if [[ "$CACHE_AVAILABLE" == "1" ]] && [[ "$query_result" =~ (Table.*doesn\'t exist|Unknown column) ]]; then
            if [[ "${DEBUG:-}" == "1" ]]; then
                echo "DEBUG: Table/column error detected, invalidating cache" >&2
            fi
            invalidate_related_cache "$ENVIRONMENT" "$DB_TYPE" "$ACCOUNT_ID" "$sql_query"
        fi
        echo "$query_result" >&2
        return $query_exit_code
    fi

    # Update cache for successful SHOW TABLES and DESCRIBE queries
    if [[ "$CACHE_AVAILABLE" == "1" ]] && ([[ "$query_classification" == "tables" ]] || [[ "$query_classification" =~ ^schema: ]]); then
        update_cache "$ENVIRONMENT" "$DB_TYPE" "$ACCOUNT_ID" "$query_classification" "$query_result"
        if [[ "${DEBUG:-}" == "1" ]]; then
            echo "DEBUG: Cache UPDATED for $query_classification" >&2
        fi
    fi

    echo "$query_result"
    return 0
}

handle_cache_operations() {
    # Determine cache operation position based on whether account_id is present
    local cache_operation
    if [[ "$DB_TYPE" == "client" && -n "$ACCOUNT_ID" ]]; then
        cache_operation="${5:-status}"
    else
        cache_operation="${4:-status}"
    fi

    case "$cache_operation" in
        clear)
            if [[ "$CACHE_AVAILABLE" == "1" ]]; then
                clear_all_cache "$ENVIRONMENT" "$DB_TYPE" "$ACCOUNT_ID"
            else
                echo "Cache utilities not available"
                exit 1
            fi
            ;;
        status)
            if [[ "$CACHE_AVAILABLE" == "1" ]]; then
                show_cache_status "$ENVIRONMENT" "$DB_TYPE" "$ACCOUNT_ID"
            else
                echo "Cache utilities not available"
                exit 1
            fi
            ;;
        clear-table)
            # Determine table name position based on whether account_id is present
            local table_name
            if [[ "$DB_TYPE" == "client" && -n "$ACCOUNT_ID" ]]; then
                table_name="$6"
            else
                table_name="$5"
            fi

            if [[ "$CACHE_AVAILABLE" == "1" && -n "$table_name" ]]; then
                invalidate_related_cache "$ENVIRONMENT" "$DB_TYPE" "$ACCOUNT_ID" "FROM $table_name"
                echo "Cleared cache for table: $table_name"
            else
                echo "Usage: $0 cache <env> <db-type> [account-id] clear-table <table-name>"
                exit 1
            fi
            ;;
        *)
            echo "Usage: $0 cache <env> <db-type> [account-id] <clear|status|clear-table>"
            echo "  clear       - Clear all caches for the specified database"
            echo "  status      - Show cache status and statistics"
            echo "  clear-table - Clear cache for a specific table"
            exit 1
            ;;
    esac
}

# Function to build MySQL command based on database type
build_mysql_command() {
    if [[ "$DB_TYPE" == "common" ]]; then
        # Common database - use working credentials with fallback logic
        echo -e "${YELLOW}Reading common database credentials...${NC}"
        local common_creds
        common_creds=$(get_working_credentials "$ENVIRONMENT" "common")
        IFS='|' read -r DB_HOST DB_USER DB_PASS DB_NAME <<< "$common_creds"

        echo -e "${GREEN}✓ Found common database:${NC} $DB_NAME"

        # Build MySQL command components
        local mysql_host_opt=""
        local mysql_pass_opt=""

        # Add host option (socket or TCP)
        if [[ "$DB_HOST" == unix* ]]; then
            # Extract socket path from unix(/path/to/socket) format
            socket_path=$(extract_socket_path "$DB_HOST")
            mysql_host_opt="-S $socket_path"
        else
            mysql_host_opt="-h $DB_HOST"
        fi

        # Use MYSQL_PWD environment variable for password (FUB pattern)
        local mysql_env=""
        if [[ -n "$DB_PASS" ]]; then
            mysql_env="MYSQL_PWD='$DB_PASS' "
        fi

        MYSQL_CMD="${mysql_env}mysql $mysql_host_opt -u $DB_USER $DB_NAME"

    elif [[ "$DB_TYPE" == "client" ]]; then
        # Client database - lookup credentials via common database query or auto-discover
        if [[ -z "$ACCOUNT_ID" ]]; then
            # Auto-discover client database
            echo -e "${YELLOW}Auto-discovering client database...${NC}"
            local client_info
            client_info=$(auto_discover_client_db)
        else
            # Use specified account ID
            if [[ "${DEBUG:-}" == "1" ]]; then
                echo -e "${YELLOW}Looking up client database credentials...${NC}"
            fi
            local client_info
            client_info=$(get_client_credentials "$ACCOUNT_ID")
        fi

        if [[ "${DEBUG:-}" == "1" ]]; then
            echo -e "${YELLOW}Debug - client_info:${NC} '$client_info'"
        fi

        IFS=$'\t' read -r DB_HOST DB_NAME DB_USER DB_PASS <<< "$client_info"

        if [[ "${DEBUG:-}" == "1" ]]; then
            echo -e "${YELLOW}Debug - After parsing:${NC}"
            echo -e "${YELLOW}  DB_HOST: '$DB_HOST'${NC}"
            echo -e "${YELLOW}  DB_NAME: '$DB_NAME'${NC}"
            echo -e "${YELLOW}  DB_USER: '$DB_USER'${NC}"
            echo -e "${YELLOW}  DB_PASS: '$DB_PASS'${NC}"
        fi

        if [[ -z "$ACCOUNT_ID" ]]; then
            echo -e "${GREEN}✓ Auto-discovered client database:${NC} $DB_NAME (account $ACCOUNT_ID) on $DB_HOST"
        else
            echo -e "${GREEN}✓ Found client database:${NC} $DB_NAME on $DB_HOST"
        fi

        # Client databases use credentials from accounts table
        if [[ -n "$DB_PASS" ]]; then
            MYSQL_CMD="mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME"
        else
            MYSQL_CMD="mysql -h $DB_HOST -u $DB_USER $DB_NAME"
        fi
    fi
}

# Function to handle interactive connection (original behavior)
execute_connect() {
    build_mysql_command
    echo -e "${YELLOW}Connecting...${NC}"
    echo -e "${YELLOW}Command: $MYSQL_CMD${NC}"
    echo ""
    ssh -t "$REMOTE_HOST" "cd /var/www/fub && $MYSQL_CMD"

    EXIT_CODE=$?
    if [ $EXIT_CODE -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✓ Connection closed${NC}"
    else
        echo ""
        echo -e "${YELLOW}Connection ended with code $EXIT_CODE${NC}"
    fi
    exit $EXIT_CODE
}

# Function to show credentials only (Claude Code friendly)
show_credentials() {
    echo -e "${YELLOW}DEBUG: show_credentials called${NC}"
    build_mysql_command
    echo -e "${YELLOW}DEBUG: build_mysql_command completed${NC}"
    echo -e "${GREEN}MySQL Command:${NC} $MYSQL_CMD"
    echo -e "${GREEN}Remote Host:${NC} $REMOTE_HOST"

    # Parse and display individual components for easy automation
    if [[ "$MYSQL_CMD" =~ mysql[[:space:]]+(.*)$ ]]; then
        local mysql_args="${BASH_REMATCH[1]}"
        echo -e "${GREEN}MySQL Arguments:${NC} $mysql_args"
    fi

    # Debug output
    echo -e "${YELLOW}Debug - DB_HOST:${NC} ${DB_HOST:-'not set'}"
    echo -e "${YELLOW}Debug - DB_USER:${NC} ${DB_USER:-'not set'}"
    echo -e "${YELLOW}Debug - DB_NAME:${NC} ${DB_NAME:-'not set'}"
}

# Execute subcommand
case "$SUBCOMMAND" in
    connect)
        echo -e "${BLUE}=== FUB Database Connection ===${NC}"
        echo -e "${BLUE}Environment:${NC} $ENVIRONMENT"
        echo -e "${BLUE}Database:${NC} $DB_TYPE$([ -n "$ACCOUNT_ID" ] && echo " (account $ACCOUNT_ID)")"
        echo ""
        execute_connect
        ;;
    credentials)
        echo -e "${BLUE}=== FUB Database Credentials ===${NC}"
        echo -e "${BLUE}Environment:${NC} $ENVIRONMENT"
        echo -e "${BLUE}Database:${NC} $DB_TYPE$([ -n "$ACCOUNT_ID" ] && echo " (account $ACCOUNT_ID)")"
        echo ""
        show_credentials
        ;;
    query)
        if [[ -z "$SQL_QUERY" ]]; then
            echo -e "${RED}Error: SQL query required for query subcommand${NC}"
            echo -e "${YELLOW}Debug: SQL_QUERY variable is empty or not set${NC}"
            echo -e "${YELLOW}Expected argument position: ${NC}"
            if [[ "$DB_TYPE" == "client" ]]; then
                echo -e "  Position 5 (after account-id): \$5 = '${5:-<not provided>}'"
            else
                echo -e "  Position 4: \$4 = '${4:-<not provided>}'"
            fi
            echo ""
            echo -e "${BLUE}Quoting guidelines:${NC}"
            echo -e "  ✓ Good: \"SELECT * FROM table WHERE name = 'value'\""
            echo -e "  ✓ Good: 'SELECT COUNT(*) FROM accounts'"
            echo -e "  ✗ Avoid: 'SELECT * FROM table WHERE name = \"value\"' (nested quotes)"
            echo ""
            echo -e "${BLUE}Examples:${NC}"
            echo -e "  $0 query dev common \"SHOW TABLES LIKE 'pattern'\""
            echo -e "  $0 query qa client 123 'SELECT COUNT(*) FROM users'"
            exit 1
        fi

        # Basic SQL validation
        if [[ ${#SQL_QUERY} -lt 3 ]]; then
            echo -e "${RED}Error: SQL query too short (${#SQL_QUERY} characters): '${SQL_QUERY}'${NC}"
            echo -e "${YELLOW}This might indicate a quoting issue. Check your command syntax.${NC}"
            exit 1
        fi

        # Check for common SQL commands
        if ! [[ "$SQL_QUERY" =~ ^[[:space:]]*(SELECT|SHOW|DESCRIBE|DESC|EXPLAIN|INSERT|UPDATE|DELETE|CREATE|DROP|ALTER|TRUNCATE|CALL|SET|USE)[[:space:]] ]]; then
            echo -e "${YELLOW}Warning: SQL query doesn't start with a recognized command: '${SQL_QUERY}'${NC}"
            echo -e "${YELLOW}Query will still be executed, but please verify it's correct.${NC}"
        fi

        # Check for MySQL-specific quoting issues
        if [[ "$SQL_QUERY" =~ \"[^\"]*\" ]]; then
            echo -e "${YELLOW}Warning: SQL query contains double quotes. In MySQL, use single quotes for string literals.${NC}"
            echo -e "${YELLOW}Example: SHOW TABLES LIKE 'pattern' instead of SHOW TABLES LIKE \"pattern\"${NC}"
        fi

        if [[ "${DEBUG:-}" == "1" ]]; then
            echo -e "${YELLOW}DEBUG: Executing SQL query (${#SQL_QUERY} chars): '${SQL_QUERY}'${NC}"
        fi
        execute_query "$SQL_QUERY"
        ;;
    cache)
        handle_cache_operations "$@"
        ;;
    list-tables)
        # List all tables in the specified database
        echo -e "${BLUE}=== FUB Database Tables ===${NC}"
        echo -e "${BLUE}Environment:${NC} $ENVIRONMENT"
        echo -e "${BLUE}Database:${NC} $DB_TYPE$([ -n "$ACCOUNT_ID" ] && echo " (account $ACCOUNT_ID)")"
        echo ""

        execute_query "SHOW TABLES"
        ;;
    list-columns)
        # List columns for a given table
        if [[ -z "$TABLE_NAME" ]]; then
            echo -e "${RED}Error: Table name required for list-columns subcommand${NC}"
            echo -e "${YELLOW}Usage:${NC} $0 list-columns [environment] <database-type> [account-id] <table-name>"
            echo -e "${BLUE}Examples:${NC}"
            echo -e "  $0 list-columns common accounts"
            echo -e "  $0 list-columns dev common accounts"
            echo -e "  $0 list-columns client users"
            echo -e "  $0 list-columns qa client 123 users"
            exit 1
        fi

        echo -e "${BLUE}=== FUB Table Columns ===${NC}"
        echo -e "${BLUE}Environment:${NC} $ENVIRONMENT"
        echo -e "${BLUE}Database:${NC} $DB_TYPE$([ -n "$ACCOUNT_ID" ] && echo " (account $ACCOUNT_ID)")"
        echo -e "${BLUE}Table:${NC} $TABLE_NAME"
        echo ""

        execute_query "DESCRIBE $TABLE_NAME"
        ;;
esac