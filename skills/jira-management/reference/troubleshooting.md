## Jira Management Troubleshooting Guide

### Common Error Patterns and Recovery

| **Error Type** | **Detection** | **Recovery** |
|----------------|---------------|--------------|
| **MCP Connection Failed** | Connection timeout, authentication errors | Switch to acli fallback, restart MCP server |
| **Rate Limiting** | 429 HTTP errors | Implement exponential backoff, reduce request frequency |
| **Permission Denied** | 403 errors | Validate user permissions, check project access |
| **Invalid JQL** | JQL syntax errors | Validate query syntax, provide corrected examples |
| **Issue Not Found** | 404 errors | Verify issue key format, check issue existence |

### MCP Integration and Fallback System

**Health Monitoring:**
```bash
# Check overall system health
/jira-management --operation="health-check"

# Monitor MCP connection status
/jira-management --operation="monitor-connection" --continuous=true
```

**Fallback Detection and Switching:**
```bash
# Automatic fallback on MCP failure
validate_mcp_connection() {
    if ! mcp__atlassian__atlassianUserInfo > /dev/null 2>&1; then
        echo "MCP connection failed, enabling fallback mode" >&2
        export JIRA_FALLBACK_MODE=true
        return 1
    fi
    return 0
}

# Resilient operation execution
execute_with_fallback() {
    local operation="$1"
    shift

    if [[ "$JIRA_FALLBACK_MODE" == "true" ]] || ! validate_mcp_connection; then
        echo "Using acli fallback for: $operation" >&2
        acli jira "$operation" "$@"
    else
        "mcp__atlassian__${operation}" "$@"
    fi
}
```

**Emergency Recovery:**
```bash
# Complete system recovery
/jira-management --operation="emergency-recovery"
```

### Authentication and Permission Issues

**Authentication Validation:**
```bash
# Validate user permissions before operations
validate_permissions() {
    local operation="$1"
    local project_key="$2"

    if ! mcp__atlassian__getVisibleJiraProjects | jq -e ".[] | select(.key == \"$project_key\")" > /dev/null; then
        echo "Access denied: No permission for project $project_key" >&2
        return 1
    fi
}
```

**Token Refresh:**
```bash
# Refresh authentication tokens
refresh_jira_tokens() {
    echo "Refreshing Jira authentication tokens..."
    # Implementation depends on authentication method
    unset JIRA_FALLBACK_MODE
    validate_mcp_connection
}
```

### Performance and Rate Limiting

**Request Throttling:**
```bash
# Implement rate limiting for bulk operations
throttle_requests() {
    local delay=${1:-1}
    sleep "$delay"
}

# Process with rate limiting
rate_limited_bulk_operation() {
    local operation="$1"
    shift
    
    for item in "$@"; do
        $operation "$item"
        throttle_requests 0.5  # 500ms delay between requests
    done
}
```

**Cache Management:**
```bash
# Clear stale cache
clear_jira_cache() {
    rm -rf .cache/jira/
    echo "Jira cache cleared"
}

# Validate cache integrity
validate_cache() {
    local cache_dir=".cache/jira"
    if [[ -d "$cache_dir" ]]; then
        find "$cache_dir" -name "*.json" -mtime +1 -delete
        echo "Stale cache entries removed"
    fi
}
```

### Input Validation and Security

**JQL Query Validation:**
```bash
# Validate JQL syntax
validate_jql() {
    local jql="$1"
    
    # Basic syntax validation
    if [[ -z "$jql" ]]; then
        echo "Error: Empty JQL query" >&2
        return 1
    fi
    
    # Check for balanced quotes
    local single_quotes=$(echo "$jql" | tr -cd "'" | wc -c)
    if (( single_quotes % 2 != 0 )); then
        echo "Error: Unbalanced single quotes in JQL" >&2
        return 1
    fi
    
    return 0
}

# Sanitize JQL queries
sanitize_jql() {
    local jql="$1"
    # Remove potentially dangerous patterns
    echo "$jql" | sed 's/;.*//g' | sed "s/'[^']*'//g"
}
```

**Issue Key Validation:**
```bash
# Validate issue key format
validate_issue_key() {
    local issue_key="$1"
    
    if [[ ! "$issue_key" =~ ^[A-Z]+-[0-9]+$ ]]; then
        echo "Error: Invalid issue key format: $issue_key" >&2
        echo "Expected format: PROJECT-123" >&2
        return 1
    fi
    
    return 0
}
```

### Data Safety and Backup

**Backup Before Bulk Operations:**
```bash
# Create backup before bulk operations
backup_issues() {
    local jql="$1"
    local backup_file="jira-backup-$(date +%Y%m%d-%H%M%S).json"
    
    echo "Creating backup for query: $jql"
    /jira-management --operation="search" --jql="$jql" --max_results=1000 > "$backup_file"
    echo "Backup saved to: $backup_file"
}

# Verify backup integrity
verify_backup() {
    local backup_file="$1"
    
    if jq empty "$backup_file" 2>/dev/null; then
        echo "✅ Backup file is valid JSON"
        return 0
    else
        echo "❌ Backup file is corrupted"
        return 1
    fi
}
```

### Connectivity and Network Issues

**Network Diagnostics:**
```bash
# Test Atlassian connectivity
test_atlassian_connectivity() {
    local domains=("atlassian.net" "atlassian.com" "jira.com")
    
    for domain in "${domains[@]}"; do
        if ping -c 1 "$domain" >/dev/null 2>&1; then
            echo "✅ Connectivity to $domain: OK"
        else
            echo "❌ Connectivity to $domain: FAILED"
        fi
    done
}

# Proxy configuration check
check_proxy_configuration() {
    if [[ -n "$HTTP_PROXY" ]] || [[ -n "$HTTPS_PROXY" ]]; then
        echo "Proxy configuration detected:"
        echo "HTTP_PROXY: ${HTTP_PROXY:-not set}"
        echo "HTTPS_PROXY: ${HTTPS_PROXY:-not set}"
    else
        echo "No proxy configuration found"
    fi
}
```

### Audit and Logging

**Operation Auditing:**
```bash
# Audit trail for sensitive operations
audit_operation() {
    local operation="$1"
    local details="$2"
    local log_file="$HOME/.claude/logs/jira-audit.log"
    
    mkdir -p "$(dirname "$log_file")"
    echo "$(date -Iseconds): $operation - $details" >> "$log_file"
}

# Review audit log
review_audit_log() {
    local log_file="$HOME/.claude/logs/jira-audit.log"
    
    if [[ -f "$log_file" ]]; then
        echo "Recent Jira operations:"
        tail -20 "$log_file"
    else
        echo "No audit log found"
    fi
}
```

### Refusal Conditions and Safety

The skill must refuse if:

**Authentication Issues:**
- MCP authentication fails and acli fallback is unavailable
- User lacks required Jira permissions for requested operation
- API tokens are expired or invalid

**Data Safety Violations:**
- Bulk operations without proper confirmation on production data
- JQL queries with potential injection vulnerabilities
- Operations that would violate data retention policies

**Rate Limiting Violations:**
- Requests exceed Atlassian API rate limits
- Bulk operations without proper throttling mechanisms
- Concurrent operations that could overwhelm the system

### Resolution Steps

When refusing, provide specific steps to resolve the issue:

**Authentication Refresh Procedures:**
```bash
# Refresh MCP connection
/mcp-server-management --operation="restart-server" --server="atlassian"

# Verify user permissions
/jira-management --operation="list-projects" --verbose=true

# Test fallback mechanisms
/jira-management --operation="health-check" --use_fallback=true
```

**Permission Verification Steps:**
```bash
# Check project access
/jira-management --operation="get-project-meta" --project_key="PROJECT"

# Verify user role
mcp__atlassian__atlassianUserInfo

# List accessible resources
mcp__atlassian__getAccessibleAtlassianResources
```

**Safe Operation Alternatives:**
- Use smaller batch sizes for bulk operations
- Implement proper rate limiting and delays
- Create backups before destructive operations
- Validate input parameters before execution

**Critical Safety Note**: All operations prioritize data integrity, user permissions, and system stability. When in doubt about safety or permissions, always request explicit confirmation before proceeding with potentially destructive operations.

This troubleshooting guide provides comprehensive support for resolving common issues and maintaining safe, reliable Jira management operations in FUB development environments.
