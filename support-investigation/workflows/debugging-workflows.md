## FUB System Debugging Patterns

### API-Centric Investigation Approach

**Frontend Issue → API Problem Pattern:**
- Frontend issues usually manifest from API problems
- Use New Relic error reporting for non-2xx responses
- Check network inspector in browser developer tools for client-side issues
- Use CSD to impersonate user and replicate issue scenarios

**Systematic API Debugging:**
```bash
# Check API health and recent errors
datadog-production --operation="search-logs" --query="service:fub-api status:error" --timeframe="past_2h"

# Analyze specific endpoint performance
datadog-production --operation="get-metrics" --metric="fub.api.endpoint_response_time" --tags="endpoint:/api/auth/login"

# Review recent API deployments
gitlab-sidekick --operation="list_pipelines" --project="fub-api" --branch="main" --timeframe="past_24h"
```

### Redis Mutex Management (FUB Development Environment)

**Safe Redis Operations:**
```bash
# Use provided scripts for safer Redis operations
cd ~/.claude/skills/support-investigation/

# List all current mutexes
./clear-mutex.sh list

# Clear specific mutex (common for stuck migrations)
./clear-mutex.sh clear migrations

# Direct Redis commands (use with caution)
./redis-cli.sh ping
./redis-cli.sh keys "fubapp:mutex:*"
./redis-cli.sh exists "fubapp:mutex:migrations-script"
./redis-cli.sh del "fubapp:mutex:migrations-script"
```

### Database Investigation Templates

**User Account Status and Configuration:**
```sql
-- User account status and configuration
SELECT u.id, u.email, u.status, u.created_at, u.last_login_at,
       a.name as account_name, a.status as account_status
FROM users u JOIN accounts a ON u.account_id = a.id WHERE u.account_id = ?;
```

**Recent User Activity and Login Attempts:**
```sql
-- Recent user activity and login attempts
SELECT * FROM activity_logs WHERE user_id = ? AND account_id = ?
ORDER BY created_at DESC LIMIT 50;
```

**Feature Flag Status for Account:**
```sql
-- Feature flag status for account
SELECT ff.flag_name, ff.enabled, ff.configuration, ff.updated_at
FROM feature_flags ff WHERE ff.account_id = ? OR ff.account_id IS NULL;
```

**Lead Flow and Integration Status:**
```sql
-- Lead flow configuration and status
SELECT lf.id, lf.name, lf.source, lf.status, lf.configuration,
       lfi.external_id, lfi.last_sync_at, lfi.sync_status
FROM lead_flows lf
LEFT JOIN lead_flow_integrations lfi ON lf.id = lfi.lead_flow_id
WHERE lf.account_id = ?;
```

**Webhook Configuration and Recent Activity:**
```sql
-- Webhook endpoints and recent activity
SELECT w.id, w.url, w.event_types, w.status, w.created_at,
       COUNT(wl.id) as recent_deliveries,
       AVG(wl.response_time) as avg_response_time
FROM webhooks w
LEFT JOIN webhook_logs wl ON w.id = wl.webhook_id AND wl.created_at > DATE_SUB(NOW(), INTERVAL 24 HOUR)
WHERE w.account_id = ?
GROUP BY w.id;
```

### Investigation Documentation Templates

**Investigation Log Template:**
```markdown
# Investigation: [Issue Description]
**Issue ID**: [Jira ticket]
**Account ID**: [FUB account ID]
**Environment**: [development/qa/production]

### YYYY-MM-DD HH:MM - [Investigation Step]
**MCP Tools Used**: [Specific tools and queries]
**Key Findings**: [Direct evidence only]
**Analysis**: [Mark speculation as (Inference)]

#### Database Query Results
```sql
-- Query used
SELECT * FROM users WHERE account_id = 12345;

-- Results
| id | email | status | last_login_at |
|----|-------|--------|---------------|
| 1  | test@example.com | active | 2024-01-15 10:30:00 |
```

#### Log Analysis
```
2024-01-15 10:30:15 ERROR [auth] Authentication failed for user 1: Invalid token
2024-01-15 10:30:16 INFO [auth] Token refresh attempted for user 1
2024-01-15 10:30:17 ERROR [auth] Token refresh failed: Zillow API unavailable
```

#### Screenshots and Evidence
- `screenshot_account_settings_2024-01-15.png` - Account configuration at time of issue
- `network_logs_authentication_flow.har` - Browser network activity during replication

### Resolution Plan Template
1. **Immediate Action**: [Specific steps to resolve immediate user impact]
2. **Short-term Fix**: [Targeted solution to address root cause]
3. **Quality Assurance**: [Testing approach to validate fix]
4. **Monitoring Enhancement**: [Proactive measures to prevent recurrence]
```

### Quality Assurance Checklist

**Investigation Completeness:**
- [ ] Critical information collected (account ID, user email, timeframe, environment)
- [ ] All speculation clearly labeled as (Inference) with rationale
- [ ] Root cause identified with multiple sources of supporting evidence
- [ ] Resolution plan documented with specific steps and monitoring approach
- [ ] Markdown linting performed on all investigation documents

### Investigation-Specific Automation Integration

**Test Automation for Issue Validation:**
```bash
# Claude Code skill invocation for issue reproduction
/backend-test-development --target="reproduce_issue" --test_type="targeted" --issue_context="ZYN-10585"

# Claude Code skill invocation for regression testing after fix
/backend-test-development --target="validate_fix" --test_type="regression" --coverage_analysis=true
```

**Static Analysis Integration:**
```bash
# Shell commands for code quality assessment during investigation
vendor/bin/psalm --threads=auto  # Standard quality check
vendor/bin/psalm --show-info=true  # Comprehensive issue analysis
vendor/bin/psalm --set-baseline=psalm-baseline.xml  # Track new issues
```

**Framework Console for Data Investigation:**
```bash
# Shell commands for interactive model inspection
ssh fubdev-matttu-dev-01 "cd ~/mutagen/fub && libraries/lithium/console/li3"

# Shell command for specific data queries
ssh fubdev-matttu-dev-01 "cd ~/mutagen/fub && libraries/lithium/console/li3 console \"User::find('first', ['conditions' => ['id' => \$user_id]])\""
```

### Automated Investigation Patterns

**Issue Pattern Recognition:**
```bash
# Automated pattern detection for common issues
detect_common_patterns() {
    local account_id="$1"
    local timeframe="${2:-past_24h}"

    # Check for authentication patterns
    datadog-production --operation="search-logs" --query="account_id:$account_id auth error" --timeframe="$timeframe"

    # Check for integration failures
    datadog-production --operation="search-logs" --query="account_id:$account_id zillow webhook" --timeframe="$timeframe"

    # Check for database connection issues
    datadog-production --operation="search-logs" --query="account_id:$account_id database timeout" --timeframe="$timeframe"
}
```

**Correlation Analysis:**
```bash
# Cross-system correlation for impact analysis
correlation_analysis() {
    local issue_timestamp="$1"
    local account_id="$2"

    # Check deployment correlation
    gitlab-sidekick --operation="list_pipelines" --completed_before="$issue_timestamp" --completed_after="$(date -d '$issue_timestamp - 2 hours')"

    # Check feature flag changes
    databricks --query="SELECT * FROM feature_flag_changes WHERE account_id = $account_id AND changed_at < '$issue_timestamp' ORDER BY changed_at DESC LIMIT 10"

    # Check external service status
    datadog-production --operation="get-metrics" --metric="external_service.response_time" --tags="service:zillow"
}
```

### Cross-Skill Investigation Patterns

**Integration Workflow Examples:**
- **Issue Reproduction:** `/backend-test-development` for systematic test creation and execution
- **Code Analysis:** `/serena-mcp` for semantic code search and recent changes analysis
- **Database Investigation:** `/database-operations` for safe production queries and data validation
- **Performance Analysis:** `/datadog-management` for comprehensive monitoring and log analysis
- **Static Analysis:** Shell command `vendor/bin/psalm` workflows for code quality assessment

**Automated Escalation Patterns:**
```bash
# Escalate critical issues based on investigation findings
escalate_if_critical() {
    local severity="$1"
    local impact="$2"
    local confidence="$3"

    if [[ "$severity" == "critical" && "$impact" == "multiple_accounts" && "$confidence" == "high" ]]; then
        # Create high-priority Jira ticket
        atlassian --operation="create_jira_issue" --project="INCIDENT" --issue_type="Critical Bug" --priority="Highest"

        # Notify team via Slack
        # (Implementation depends on Slack integration availability)

        # Create monitoring alert
        datadog-production --operation="create-monitor" --type="log" --query="[investigation pattern]"
    fi
}
```