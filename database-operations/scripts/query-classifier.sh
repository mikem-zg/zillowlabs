#!/usr/bin/env bash
# Query classification for caching decisions

classify_query_for_cache() {
    local sql_query="$1"

    # Normalize whitespace for easier matching
    sql_query=$(echo "$sql_query" | tr -s '[:space:]' ' ' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')

    if [[ "$sql_query" =~ ^SHOW[[:space:]]+TABLES ]]; then
        echo "tables"
    elif [[ "$sql_query" =~ ^DESCRIBE[[:space:]] ]] || [[ "$sql_query" =~ ^DESC[[:space:]] ]]; then
        # Extract table name using parameter expansion - more reliable than regex capture
        local table_part="${sql_query#DESCRIBE }"
        table_part="${table_part#DESC }"
        local table_name=$(echo "$table_part" | awk '{print $1}')
        echo "schema:$table_name"
    elif [[ "$sql_query" =~ ^SHOW[[:space:]]+COLUMNS[[:space:]]+FROM[[:space:]] ]]; then
        # Extract table name after FROM
        local from_part="${sql_query#*FROM }"
        local table_name=$(echo "$from_part" | awk '{print $1}')
        echo "schema:$table_name"
    elif [[ "$sql_query" =~ ^SELECT ]]; then
        echo "select"
    else
        echo "other"
    fi
}