## MCP Server Integration for Investigation

### Datadog MCP Integration

**Production Environment Analysis:**
```bash
# Search production logs with specific patterns
datadog-production --operation="search-logs" --query="account_id:12345 error" --timeframe="past_2h"

# Aggregate error patterns for pattern analysis
datadog-production --operation="aggregate-logs" --query="service:fub-api status:error" --timeframe="past_24h"

# Monitor specific metrics for performance correlation
datadog-production --operation="get-metrics" --metric="fub.api.response_time" --tags="account_id:12345"
```

**Staging Environment Analysis:**
```bash
# Staging environment log analysis for development issues
datadog-staging --operation="search-logs" --query="correlation_id:abc123 level:ERROR"

# Performance metrics correlation in staging
datadog-staging --operation="get-metrics" --metric="database.query_time" --timeframe="past_1h"
```

### Databricks MCP Integration

**Production Data Analysis:**
```bash
# Account configuration queries with 15-minute timeout
databricks --query="SELECT * FROM accounts WHERE id = 12345" --environment="production" --timeout="15min"

# User activity analysis for investigation context
databricks --query="SELECT * FROM activity_logs WHERE account_id = 12345 AND created_at > '2024-01-01'" --environment="production"

# Feature flag status validation
databricks --query="SELECT flag_name, enabled FROM feature_flags WHERE account_id = 12345" --environment="production"
```

### Serena MCP Integration

**Semantic Code Investigation:**
```bash
# Find authentication-related code changes
serena-mcp --task="Find recent authentication changes" --scope="auth"

# Locate error handling patterns
serena-mcp --task="Find error handling for API endpoints" --scope="controllers"

# Search for specific function implementations
serena-mcp --task="Find webhook processing logic" --scope="integrations"
```

**Code Relationship Analysis:**
```bash
# Find all references to a specific function
serena-mcp --task="Find all calls to AuthService::validateToken" --include_references=true

# Understand class hierarchy and dependencies
serena-mcp --task="Analyze ZillowService class dependencies" --include_hierarchy=true

# Find error sources
serena-mcp --task="Trace authentication error flow" --scope="auth"

# Integration point analysis
serena-mcp --task="Find webhook integration code" --scope="integrations"
```

### GitLab Sidekick MCP Integration

**Pipeline and Deployment Analysis:**
```bash
# List recent deployments correlating with issue timeline
gitlab-sidekick --operation="list_pipelines" --project="fub" --timeframe="past_24h"

# Analyze specific merge request changes
gitlab-sidekick --operation="mr_overview" --mr_id="1234" --include_changes=true

# Review pipeline job failures
gitlab-sidekick --operation="list_pipeline_jobs" --pipeline_id="5678" --status="failed"

# Get detailed job logs for failure analysis
gitlab-sidekick --operation="get_job_log" --job_id="9012" --include_context=true
```

### Atlassian MCP Integration (Jira/Confluence)

**Issue Context Gathering:**
```bash
# Retrieve full Jira issue details with history
atlassian --operation="get_jira_issue" --issue_key="ZYN-10585" --include_history=true

# Search for related issues and patterns
atlassian --operation="search_jira_issues" --jql="project = ZYN AND component = Authentication AND created >= -30d"

# Update issue with investigation progress
atlassian --operation="add_comment_to_jira_issue" --issue_key="ZYN-10585" --comment="Investigation findings: [details]"
```

**Knowledge Base Documentation:**
```bash
# Search existing documentation for similar issues
atlassian --operation="search_confluence" --query="authentication failures zillow integration" --space="ENG"

# Create comprehensive documentation page
atlassian --operation="create_confluence_page" --space="ENG" --title="Authentication Investigation ZYN-10585" --content="[investigation_summary]"

# Update runbook with new findings
atlassian --operation="update_confluence_page" --page_id="12345" --content="[updated_procedures]"
```

### Glean MCP Integration

**Historical Context and Knowledge Discovery:**
```bash
# Search internal documentation and past investigations
glean --operation="search" --query="zillow authentication failures" --filters="type:confluence"

# Find team communications about similar issues
glean --operation="search" --query="ZYN-10585 OR similar authentication issues" --filters="type:slack"

# Locate relevant code documentation
glean --operation="search" --query="AuthService ZillowTokenService validation" --filters="type:code_docs"

# Employee expertise discovery
glean --operation="employee_search" --query="zillow integration authentication expert" --include_projects=true
```

### Chrome DevTools MCP Integration

**CSD Investigation and User Replication:**
```bash
# Navigate to specific account for investigation
chrome-devtools --operation="navigate_page" --url="https://csd.followupboss.com/account/12345/settings"

# Take screenshots of configuration for documentation
chrome-devtools --operation="take_screenshot" --filename="account_12345_settings.png"

# Fill forms to replicate user workflows
chrome-devtools --operation="fill_form" --form_data="{'email': 'test@example.com', 'action': 'authenticate'}"

# Monitor network requests during issue replication
chrome-devtools --operation="list_network_requests" --filter_type="XHR" --include_responses=true

# Execute JavaScript for advanced debugging
chrome-devtools --operation="evaluate_script" --script="console.log('Account ID:', window.accountId); return window.featureFlags;"
```

### MCP Tool Integration Patterns

**Cross-Tool Investigation Workflow:**
1. **Issue Discovery**: Glean MCP → Find historical context and similar issues
2. **Code Analysis**: Serena MCP → Understand current implementation and recent changes
3. **Data Verification**: Databricks MCP → Validate account configuration and data integrity
4. **Log Analysis**: Datadog MCP → Trace specific error patterns and timing
5. **User Replication**: Chrome DevTools MCP → Replicate issue scenarios in CSD
6. **Deployment Correlation**: GitLab Sidekick MCP → Correlate with recent deployments
7. **Documentation**: Atlassian MCP → Update tickets and create knowledge base entries

**Automated Investigation Scripts:**
```bash
# Comprehensive investigation automation
investigate_issue() {
    local issue_id="$1"
    local account_id="$2"

    # Gather context
    glean --operation="search" --query="$issue_id" --max_results=10

    # Check recent deployments
    gitlab-sidekick --operation="list_pipelines" --timeframe="past_48h"

    # Analyze account data
    databricks --query="SELECT * FROM accounts WHERE id = $account_id" --timeout="15min"

    # Search logs for patterns
    datadog-production --operation="search-logs" --query="account_id:$account_id error" --timeframe="past_24h"

    # Document findings
    atlassian --operation="add_comment_to_jira_issue" --issue_key="$issue_id" --comment="Automated investigation completed"
}
```

### MCP Server Health and Fallback Strategies

**Connection Monitoring:**
```bash
# Verify MCP server connectivity
mcp-server-management --operation="health_check" --server="datadog-production"
mcp-server-management --operation="health_check" --server="serena"
mcp-server-management --operation="health_check" --server="atlassian"

# Automatic server restart on failure
mcp-server-management --operation="restart" --server="databricks" --reason="connection_timeout"
```

**Fallback Procedures:**
- **Datadog MCP Failure**: Use web interface with manual queries
- **Serena MCP Failure**: Use direct Grep/Glob tools for code search
- **Atlassian MCP Failure**: Use acli CLI tools for Jira operations
- **Databricks MCP Failure**: Use direct SSH to database hosts (development only)
- **GitLab Sidekick MCP Failure**: Use direct GitLab API or web interface

### Error Handling and Recovery

**MCP Server Timeout Management:**
```bash
# Implement timeout handling for long-running queries
timeout_handler() {
    local server="$1"
    local operation="$2"
    local timeout="$3"

    if ! timeout "$timeout" $server --operation="$operation"; then
        echo "Operation timed out, falling back to alternative approach"
        mcp-server-management --operation="restart" --server="$server"
        return 1
    fi
}
```

**Error Recovery Patterns:**
- **Connection Failures**: Automatic retry with exponential backoff
- **Authentication Errors**: Refresh tokens and re-authenticate
- **Rate Limiting**: Queue operations and respect API limits
- **Timeout Errors**: Switch to alternative investigation methods
- **Data Access Errors**: Escalate to appropriate system administrators