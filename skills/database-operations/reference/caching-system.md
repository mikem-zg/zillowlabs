## Caching System

The database-operations skill includes an intelligent caching system to improve performance for schema queries.

### Cached Operations
- `SHOW TABLES` - Results cached per database
- `DESCRIBE table_name` - Results cached per table
- `SHOW COLUMNS FROM table_name` - Results cached per table (same as DESCRIBE)
- Schema queries are cached indefinitely until invalidated

### Cache Management Commands
```bash
# Show cache status
./.claude/skills/database-operations/scripts/fub-db.sh cache dev common status

# Clear all caches for a database
./.claude/skills/database-operations/scripts/fub-db.sh cache dev common clear

# Clear cache for specific table
./.claude/skills/database-operations/scripts/fub-db.sh cache dev common clear-table accounts
```

### Cache Behavior
- **Cache Location**: `.claude/skills/database-operations/data/cache/`
- **Cache Keys**: Separated by environment, database type, and account
- **Invalidation**: Automatic when table/column errors are encountered
- **Debug Mode**: Use `DEBUG=1` to see cache hits/misses

### Cache Implementation Details

**Cache Directory Structure:**
```
.claude/skills/database-operations/data/cache/
├── dev/
│   ├── common/
│   │   ├── tables.cache
│   │   ├── accounts_columns.cache
│   │   └── contacts_columns.cache
│   └── client/
│       ├── 12345_tables.cache
│       └── 12345_contacts_columns.cache
├── qa/
└── production/
```

**Cache Key Format:**
- **Tables**: `{environment}_{database_type}_{account_id}_tables`
- **Columns**: `{environment}_{database_type}_{account_id}_{table}_columns`
- **Common Database**: Uses 'common' instead of account_id

**Cache File Format:**
```json
{
    "timestamp": 1640995200,
    "data": [
        {"table_name": "accounts", "table_type": "BASE TABLE"},
        {"table_name": "contacts", "table_type": "BASE TABLE"}
    ]
}
```

### Cache Management Functions

**Cache Validation:**
```bash
validate_cache() {
    local cache_file="$1"
    local max_age_seconds="${2:-86400}"  # Default 24 hours for schema data

    if [[ ! -f "$cache_file" ]]; then
        return 1  # Cache miss
    fi

    local cache_timestamp=$(jq -r '.timestamp' "$cache_file" 2>/dev/null)
    local current_timestamp=$(date +%s)
    local age=$((current_timestamp - cache_timestamp))

    if [[ $age -gt $max_age_seconds ]]; then
        echo "Cache expired (age: ${age}s)" >&2
        return 1  # Cache expired
    fi

    return 0  # Cache valid
}

get_cached_data() {
    local cache_file="$1"

    if validate_cache "$cache_file"; then
        jq -r '.data[]' "$cache_file" 2>/dev/null
        return 0
    fi

    return 1  # Cache miss or invalid
}

set_cache_data() {
    local cache_file="$1"
    local data="$2"

    mkdir -p "$(dirname "$cache_file")"

    jq -n --arg timestamp "$(date +%s)" --argjson data "$data" \
        '{timestamp: $timestamp, data: $data}' > "$cache_file"
}
```

**Intelligent Cache Invalidation:**
```bash
invalidate_cache_on_error() {
    local exit_code="$1"
    local cache_file="$2"
    local operation="$3"

    # Invalidate cache on specific database errors
    if [[ $exit_code -ne 0 ]]; then
        case "$operation" in
            "SHOW TABLES"|"list-tables")
                if [[ -f "$cache_file" ]]; then
                    echo "Invalidating tables cache due to error" >&2
                    rm -f "$cache_file"
                fi
                ;;
            "DESCRIBE"|"SHOW COLUMNS"|"list-columns")
                if [[ -f "$cache_file" ]]; then
                    echo "Invalidating columns cache due to error" >&2
                    rm -f "$cache_file"
                fi
                ;;
        esac
    fi
}

# Auto-invalidation on schema changes
detect_schema_changes() {
    local environment="$1"
    local database_type="$2"
    local account_id="$3"

    # Monitor for schema-modifying operations
    local schema_operations=("CREATE TABLE" "DROP TABLE" "ALTER TABLE" "CREATE INDEX" "DROP INDEX")

    for operation in "${schema_operations[@]}"; do
        if echo "$LAST_QUERY" | grep -qi "$operation"; then
            echo "Schema change detected: $operation" >&2
            invalidate_all_caches "$environment" "$database_type" "$account_id"
            break
        fi
    done
}

invalidate_all_caches() {
    local environment="$1"
    local database_type="$2"
    local account_id="$3"

    local cache_pattern=".claude/skills/database-operations/data/cache/${environment}/${database_type}"

    if [[ "$database_type" == "client" && -n "$account_id" ]]; then
        cache_pattern="${cache_pattern}/${account_id}_*.cache"
    else
        cache_pattern="${cache_pattern}/*.cache"
    fi

    find "$cache_pattern" -name "*.cache" -delete 2>/dev/null
    echo "Invalidated all caches for $environment/$database_type" >&2
}
```

### Performance Optimization with Caching

**Cache Hit Rate Monitoring:**
```bash
track_cache_performance() {
    local operation="$1"
    local cache_hit="$2"  # true/false

    local stats_file=".claude/skills/database-operations/data/cache_stats.json"

    # Initialize stats file if it doesn't exist
    if [[ ! -f "$stats_file" ]]; then
        echo '{"total_requests": 0, "cache_hits": 0, "cache_misses": 0}' > "$stats_file"
    fi

    # Update statistics
    if [[ "$cache_hit" == "true" ]]; then
        jq '.total_requests += 1 | .cache_hits += 1' "$stats_file" > "${stats_file}.tmp" && mv "${stats_file}.tmp" "$stats_file"
    else
        jq '.total_requests += 1 | .cache_misses += 1' "$stats_file" > "${stats_file}.tmp" && mv "${stats_file}.tmp" "$stats_file"
    fi

    # Log cache performance periodically
    local total_requests=$(jq -r '.total_requests' "$stats_file")
    if (( total_requests % 100 == 0 )); then
        local hit_rate=$(jq -r '(.cache_hits / .total_requests * 100) | floor' "$stats_file")
        echo "Cache hit rate: ${hit_rate}% (${total_requests} requests)" >&2
    fi
}

# Cache warming for frequently accessed tables
warm_cache() {
    local environment="$1"
    local database_type="$2"
    local account_id="$3"

    echo "Warming cache for $environment/$database_type..." >&2

    # Pre-load common tables
    ./.claude/skills/database-operations/scripts/fub-db.sh list-tables "$environment" "$database_type" "$account_id" >/dev/null

    # Pre-load column information for critical tables
    local critical_tables=("accounts" "contacts" "deals" "users")
    for table in "${critical_tables[@]}"; do
        ./.claude/skills/database-operations/scripts/fub-db.sh list-columns "$environment" "$database_type" "$account_id" "$table" >/dev/null 2>&1
    done

    echo "Cache warming complete" >&2
}
```

### Cache Maintenance

**Automatic Cache Cleanup:**
```bash
cleanup_expired_cache() {
    local cache_dir=".claude/skills/database-operations/data/cache"
    local max_age_days="${1:-7}"  # Default 7 days
    local cleaned_files=0

    find "$cache_dir" -name "*.cache" -type f | while read -r cache_file; do
        if ! validate_cache "$cache_file" $((max_age_days * 86400)); then
            rm -f "$cache_file"
            ((cleaned_files++))
        fi
    done

    if [[ $cleaned_files -gt 0 ]]; then
        echo "Cleaned $cleaned_files expired cache files" >&2
    fi
}

# Periodic cache maintenance
schedule_cache_maintenance() {
    local maintenance_marker=".claude/skills/database-operations/data/.last_maintenance"
    local current_time=$(date +%s)

    # Check if maintenance was run in the last 24 hours
    if [[ -f "$maintenance_marker" ]]; then
        local last_maintenance=$(cat "$maintenance_marker")
        local time_since_maintenance=$((current_time - last_maintenance))

        if [[ $time_since_maintenance -lt 86400 ]]; then
            return 0  # Skip maintenance
        fi
    fi

    echo "Running scheduled cache maintenance..." >&2

    # Cleanup expired caches
    cleanup_expired_cache

    # Rebuild cache statistics
    rebuild_cache_statistics

    # Update maintenance marker
    echo "$current_time" > "$maintenance_marker"

    echo "Cache maintenance complete" >&2
}

rebuild_cache_statistics() {
    local cache_dir=".claude/skills/database-operations/data/cache"
    local stats_file=".claude/skills/database-operations/data/cache_stats.json"

    local total_files=$(find "$cache_dir" -name "*.cache" | wc -l)
    local total_size=$(du -sb "$cache_dir" 2>/dev/null | cut -f1)

    # Reset statistics with current cache status
    jq -n --arg total_files "$total_files" --arg total_size "$total_size" '{
        total_requests: .total_requests // 0,
        cache_hits: .cache_hits // 0,
        cache_misses: .cache_misses // 0,
        total_cache_files: ($total_files | tonumber),
        total_cache_size: ($total_size | tonumber),
        last_cleanup: now
    }' > "$stats_file"
}
```

### Integration with Database Operations

**Cached Query Execution:**
```bash
execute_cached_query() {
    local environment="$1"
    local database_type="$2"
    local account_id="$3"
    local operation="$4"
    local query="$5"

    local cache_key="${environment}_${database_type}_${account_id}_$(echo "$operation" | tr ' ' '_')"
    local cache_file=".claude/skills/database-operations/data/cache/$cache_key.cache"

    # Try cache first
    if get_cached_data "$cache_file"; then
        track_cache_performance "$operation" "true"
        return 0
    fi

    # Execute query and cache result
    local result
    if result=$(execute_query "$environment" "$database_type" "$account_id" "$query"); then
        echo "$result" | jq -R -s 'split("\n")[:-1]' | set_cache_data "$cache_file" -
        echo "$result"
        track_cache_performance "$operation" "false"
        return 0
    else
        invalidate_cache_on_error $? "$cache_file" "$operation"
        return 1
    fi
}
```