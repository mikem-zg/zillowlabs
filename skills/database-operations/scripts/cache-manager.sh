#!/usr/bin/env bash
# Core caching functions for database-operations skill

get_cache_path() {
    local environment="$1"
    local db_type="$2"
    local account_id="$3"
    local query_type="$4"
    local target="$5"

    local base_path="$(dirname "$0")/../data/cache"

    if [[ "$db_type" == "client" ]]; then
        if [[ "$query_type" == "tables" ]]; then
            echo "${base_path}/client/${environment}/account_${account_id}/tables.cache"
        else
            echo "${base_path}/client/${environment}/account_${account_id}/schemas/${target}.cache"
        fi
    else
        if [[ "$query_type" == "tables" ]]; then
            echo "${base_path}/common/${environment}/tables.cache"
        else
            echo "${base_path}/common/${environment}/schemas/${target}.cache"
        fi
    fi
}

check_cache() {
    local environment="$1"
    local db_type="$2"
    local account_id="$3"
    local query_classification="$4"

    local cache_path
    if [[ "$query_classification" == "tables" ]]; then
        cache_path=$(get_cache_path "$environment" "$db_type" "$account_id" "tables" "")
    elif [[ "$query_classification" == schema:* ]]; then
        # Extract table name using parameter expansion
        local table_name="${query_classification#schema:}"
        cache_path=$(get_cache_path "$environment" "$db_type" "$account_id" "schema" "$table_name")
    else
        return 1  # No caching for other queries
    fi

    if [[ -f "$cache_path" ]]; then
        # Skip timestamp line and return cached data
        tail -n +2 "$cache_path"
        return 0
    fi
    return 1
}

update_cache() {
    local environment="$1"
    local db_type="$2"
    local account_id="$3"
    local query_classification="$4"
    local query_result="$5"

    local cache_path
    if [[ "$query_classification" == "tables" ]]; then
        cache_path=$(get_cache_path "$environment" "$db_type" "$account_id" "tables" "")
    elif [[ "$query_classification" == schema:* ]]; then
        # Extract table name using parameter expansion
        local table_name="${query_classification#schema:}"
        cache_path=$(get_cache_path "$environment" "$db_type" "$account_id" "schema" "$table_name")
    else
        return 0  # No caching for other queries
    fi

    # Ensure directory exists
    mkdir -p "$(dirname "$cache_path")"

    # Write result with timestamp
    echo "# Cached on $(date)" > "$cache_path"
    echo "$query_result" >> "$cache_path"
}

invalidate_related_cache() {
    local environment="$1"
    local db_type="$2"
    local account_id="$3"
    local failed_query="$4"

    local cache_base
    if [[ "$db_type" == "client" ]]; then
        cache_base="$(dirname "$0")/../data/cache/client/${environment}/account_${account_id}"
    else
        cache_base="$(dirname "$0")/../data/cache/common/${environment}"
    fi

    # If query mentioned a specific table, invalidate that table's schema cache
    if [[ "$failed_query" =~ (FROM|INTO|UPDATE|ALTER|DROP)[[:space:]]+([a-zA-Z0-9_]+) ]]; then
        local table_name="${BASH_REMATCH[2]}"
        local schema_cache="${cache_base}/schemas/${table_name}.cache"
        if [[ -f "$schema_cache" ]]; then
            rm "$schema_cache"
            if [[ "${DEBUG:-}" == "1" ]]; then
                echo "DEBUG: Invalidated schema cache for table: $table_name" >&2
            fi
        fi

        # Also refresh SHOW TABLES to verify table existence
        local tables_cache="${cache_base}/tables.cache"
        if [[ -f "$tables_cache" ]]; then
            rm "$tables_cache"
            if [[ "${DEBUG:-}" == "1" ]]; then
                echo "DEBUG: Invalidated tables cache due to table error" >&2
            fi
        fi
    fi
}

clear_all_cache() {
    local environment="$1"
    local db_type="$2"
    local account_id="$3"

    local cache_path
    if [[ "$db_type" == "client" ]]; then
        cache_path="$(dirname "$0")/../data/cache/client/${environment}/account_${account_id}"
    else
        cache_path="$(dirname "$0")/../data/cache/common/${environment}"
    fi

    if [[ -d "$cache_path" ]]; then
        rm -rf "$cache_path"
        echo "Cleared cache for: $environment $db_type ${account_id:+account_$account_id}"
    else
        echo "No cache found for: $environment $db_type ${account_id:+account_$account_id}"
    fi
}

show_cache_status() {
    local environment="$1"
    local db_type="$2"
    local account_id="$3"

    local cache_base="$(dirname "$0")/../data/cache"

    if [[ "$db_type" == "client" && -n "$account_id" ]]; then
        local cache_path="${cache_base}/client/${environment}/account_${account_id}"
    elif [[ "$db_type" == "common" ]]; then
        local cache_path="${cache_base}/common/${environment}"
    else
        # Show all caches
        local cache_path="$cache_base"
    fi

    echo "Cache Status for: $environment $db_type ${account_id:+account_$account_id}"
    echo "Cache location: $cache_path"

    if [[ -d "$cache_path" ]]; then
        echo "Cache files found:"
        find "$cache_path" -name "*.cache" -type f -exec sh -c '
            echo "  $(basename "$1" .cache): $(wc -l < "$1") lines, modified $(date -r "$1" "+%Y-%m-%d %H:%M:%S")"
        ' sh {} \;

        local total_files=$(find "$cache_path" -name "*.cache" -type f | wc -l)
        echo "Total cached items: $total_files"
    else
        echo "No cache directory found"
    fi
}