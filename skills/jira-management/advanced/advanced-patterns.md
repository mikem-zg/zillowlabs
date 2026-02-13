## Advanced Jira Management Patterns

### Bulk Operations and Batch Processing

**Process Multiple Issues:**
```bash
# Search and bulk update
/jira-management --operation="search" --jql="project = FUB AND status = 'To Do' AND assignee is EMPTY" |\
  jq -r '.issues[].key' |\
  xargs -I {} /jira-management --operation="update-issue" --issue_key={} --assignee="currentUser()"

# Bulk status transition
/jira-management --operation="bulk-transition" --jql="project = FUB AND status = 'In Review'" --status="Done"
```

**Efficient Large-Scale Operations:**
```bash
# Process issues in batches
process_issues_efficiently() {
    local jql="$1"
    local batch_size=50

    /jira-management --operation="search" --jql="$jql" --max_results=0 | \
    jq -r '.total' | {
        read total
        for ((start=0; start<total; start+=batch_size)); do
            /jira-management --operation="search" --jql="$jql" \
                --max_results="$batch_size" --start_at="$start" | \
            jq -r '.issues[].key' | \
            xargs -I {} echo "Processing: {}"
            sleep 1  # Rate limiting
        done
    }
}
```

### MCP Integration and Fallback System

**Primary MCP Operations:**
```bash
# User and resource information
mcp__atlassian__atlassianUserInfo
mcp__atlassian__getAccessibleAtlassianResources

# Issue operations
mcp__atlassian__getJiraIssue --issueKey="FUB-1234"
mcp__atlassian__createJiraIssue --project="FUB" --data='{"summary":"Test","issuetype":{"name":"Task"}}'
mcp__atlassian__editJiraIssue --issueKey="FUB-1234" --data='{"fields":{"summary":"Updated"}}'

# Search and discovery
mcp__atlassian__searchJiraIssuesUsingJql --jql="project = FUB" --maxResults=50
mcp__atlassian__getVisibleJiraProjects
```

**Automatic Fallback System:**
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

### Performance and Optimization

**Issue Data Caching:**
```bash
# Cache frequently accessed issues
CACHE_TTL=300  # 5 minutes
get_issue_with_cache() {
    local issue_key="$1"
    local cache_file=".cache/jira/$issue_key.json"

    if [[ -f "$cache_file" ]] && [[ $(($(date +%s) - $(stat -f %m "$cache_file"))) -lt $CACHE_TTL ]]; then
        cat "$cache_file"
        return 0
    fi

    local issue_data
    if issue_data=$(mcp__atlassian__getJiraIssue --issueKey="$issue_key"); then
        mkdir -p "$(dirname "$cache_file")"
        echo "$issue_data" > "$cache_file"
        echo "$issue_data"
    fi
}
```

### Error Handling and Recovery

**Automatic Error Recovery:**
```bash
# Retry with exponential backoff
retry_with_backoff() {
    local max_attempts=3
    local delay=1
    local operation="$1"
    shift

    for attempt in $(seq 1 $max_attempts); do
        if $operation "$@"; then
            return 0
        fi
        echo "Attempt $attempt failed, retrying in ${delay}s..." >&2
        sleep $delay
        delay=$((delay * 2))
    done
    return 1
}
```

**Health Monitoring:**
```bash
# Check overall system health
/jira-management --operation="health-check"

# Monitor MCP connection status
/jira-management --operation="monitor-connection" --continuous=true
```

### Security and Compliance

**Secure Operations:**
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

# Audit trail for sensitive operations
audit_operation() {
    local operation="$1"
    local details="$2"

    echo "$(date -Iseconds): $operation - $details" >> ~/.claude/logs/jira-audit.log
}
```

**Input Sanitization:**
```bash
# Sanitize JQL queries
sanitize_jql() {
    local jql="$1"
    # Remove potentially dangerous SQL injection patterns
    echo "$jql" | sed 's/;.*//g' | sed "s/'[^']*'//g"
}
```

### Custom Workflows

**FUB-Specific Issue Workflows:**
```bash
# FUB bug workflow
fub_bug_workflow() {
    local summary="$1"
    local description="$2"

    # Create bug with FUB-specific fields
    local issue_key=$(/jira-management --operation="create-issue" \
        --project_key="FUB" --issue_type="Bug" \
        --summary="$summary" --description="$description" \
        --priority="High" | jq -r '.key')

    # Auto-assign based on component
    auto_assign_by_component "$issue_key"

    # Add to current sprint if appropriate
    add_to_current_sprint "$issue_key"

    echo "Created bug: $issue_key"
}
```

### Advanced Search and Reporting

**Complex JQL Patterns:**
```bash
# Advanced reporting queries
/jira-management --operation="search" --jql="project = FUB AND created >= startOfWeek() AND assignee = currentUser()"
/jira-management --operation="search" --jql="project = FUB AND resolved >= startOfMonth() ORDER BY resolved DESC"
/jira-management --operation="search" --jql="project = FUB AND 'Story Points' is not EMPTY AND sprint in closedSprints() ORDER BY resolved DESC"
```

**Performance Analytics:**
```bash
# Sprint velocity calculation
calculate_sprint_velocity() {
    local sprint_id="$1"
    /jira-management --operation="search" --jql="sprint = $sprint_id AND resolved is not EMPTY" | \
    jq '[.issues[] | select(.fields."Story Points" != null) | .fields."Story Points"] | add'
}

# Bug trend analysis
analyze_bug_trends() {
    local project="$1"
    /jira-management --operation="search" --jql="project = $project AND issuetype = Bug AND created >= -30d" | \
    jq '.issues | group_by(.fields.created[:10]) | map({date: .[0].fields.created[:10], count: length})'
}
```

These advanced patterns provide sophisticated Jira management capabilities for complex development workflows and enterprise-scale operations.
