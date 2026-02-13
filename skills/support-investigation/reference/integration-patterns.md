## Cross-Skill Workflow Patterns

### Support Investigation → Backend Testing

**Issue Reproduction with Targeted Tests:**
```bash
# Reproduce issue with targeted tests
support-investigation --issue="ZYN-10585" --account_id="12345" |
  backend-test-development --target="AuthController::authenticate" --test_type="api" --auth_mode="fub-spa"

# Test database consistency after investigation findings
support-investigation identify_data_integrity_issue |
  database-operations --operation="validate_consistency" --table="users"
```

**Regression Testing Workflow:**
```bash
# Complete validation cycle after fix implementation
support-investigation document_root_cause |
  backend-test-development --target="validate_fix" --test_type="regression" --coverage_analysis=true
```

### Support Investigation → Datadog Analysis

**Performance Correlation Analysis:**
```bash
# Correlate investigation findings with monitoring data
support-investigation --issue="performance-degradation" --environment="production" |
  datadog-management --analysis_type="performance" --service="fub-api" --timeframe="past-24h"

# Create alerts based on investigation patterns
support-investigation document_error_patterns |
  datadog-management --operation="create_monitor" --alert_type="error_rate"
```

**Log Analysis Integration:**
```bash
# Deep-dive log analysis for specific account issues
support-investigation --issue="auth-failures" --account_id="12345" |
  datadog-management --operation="search-logs" --query="account_id:12345 auth error" --timeframe="past_48h"
```

### Support Investigation → Code Analysis

**Recent Changes Investigation:**
```bash
# Investigate code changes related to reported issues
support-investigation --issue="authentication-failures" |
  serena-mcp --task="Find recent authentication changes"

# Analyze deployment correlation with issue timing
support-investigation timeline_analysis |
  gitlab-pipeline-monitoring --operation="list" --branch="main" --timeframe="past-week"
```

**Semantic Code Analysis:**
```bash
# Find integration points and dependencies
support-investigation --issue="zillow-sync-failures" |
  serena-mcp --task="Find ZillowService integration patterns" --include_dependencies=true
```

### Related Skills Integration Matrix

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| `backend-test-development` | **Issue Reproduction** | Create tests to reproduce reported bugs, validate fixes |
| `datadog-management` | **Log Analysis** | Systematic log investigation, performance monitoring, alert creation |
| `serena-mcp` | **Code Investigation** | Recent change analysis, semantic code search, deployment correlation |
| `database-operations` | **Data Investigation** | Production queries, data integrity checks, configuration validation |
| `jira-management` | **Issue Tracking** | Update tickets with findings, link related issues, document resolution |
| `confluence-management` | **Knowledge Documentation** | Create comprehensive documentation, update team knowledge base |
| `gitlab-pipeline-monitoring` | **Deployment Analysis** | Correlate issues with deployments, analyze pipeline failures |
| `zillow-integration-systems` | **Specialized Debugging** | Zillow-specific issue investigation, integration troubleshooting |
| `fub-integrations` | **System Knowledge** | Codebase navigation, architectural understanding, integration patterns |
| `chrome-devtools` | **User Replication** | CSD navigation, issue replication, configuration screenshots |

### Multi-Skill Operation Examples

**Complete Support Issue Resolution Workflow:**
1. `support-investigation` - Conduct systematic investigation with evidence collection
2. `serena-mcp` - Analyze related code changes and deployment timeline
3. `datadog-management` - Deep-dive log analysis and performance correlation
4. `database-operations` - Validate data integrity and configuration consistency
5. `backend-test-development` - Create tests to reproduce issue and validate fixes
6. `jira-management` - Update tickets with findings and resolution plan
7. `confluence-management` - Document investigation for team knowledge base

**Zillow Integration Issue Investigation:**
```bash
# Comprehensive Zillow integration debugging
support-investigation --issue="zillow-auth-failures" --account_id="12345" |
  zillow-oauth-diagnosis --account_id="12345" --verify_tokens=true |
  serena-mcp --task="Find ZillowTokenService recent changes" |
  datadog-management --query="service:zillow-integration status:error account_id:12345"
```

**Performance Degradation Investigation:**
```bash
# Multi-faceted performance analysis
support-investigation --issue="slow-response-times" --scientific_mode=true |
  datadog-management --analysis_type="performance" --service="fub-api" |
  database-operations --operation="analyze_slow_queries" --timeframe="past_24h" |
  gitlab-pipeline-monitoring --operation="list" --include_performance_metrics=true
```

### Investigation Pattern Libraries

**Authentication Issue Pattern:**
```bash
# Standard authentication investigation workflow
investigate_auth_issue() {
    local account_id="$1"
    local user_email="$2"

    # Initial investigation
    support-investigation --issue="auth-failure" --account_id="$account_id" --scientific_mode=true

    # Code analysis
    serena-mcp --task="Find authentication flow for account type" --scope="auth"

    # Database verification
    database-operations --query="SELECT * FROM users WHERE email='$user_email' AND account_id=$account_id"

    # Log analysis
    datadog-management --query="account_id:$account_id auth error" --timeframe="past_24h"

    # Token validation (if Zillow-related)
    if grep -q "zillow" <<< "$issue_description"; then
        zillow-oauth-diagnosis --account_id="$account_id" --verify_tokens=true
    fi
}
```

**Integration Failure Pattern:**
```bash
# Standard integration failure investigation
investigate_integration_issue() {
    local integration_type="$1"
    local account_id="$2"

    # System investigation
    support-investigation --issue="integration-failure" --account_id="$account_id" --require_alternatives=true

    # Integration-specific analysis
    case "$integration_type" in
        "zillow")
            zillow-integration-systems --operation="diagnose" --account_id="$account_id"
            ;;
        "webhook")
            serena-mcp --task="Find webhook processing code" --scope="integrations"
            ;;
    esac

    # Deployment correlation
    gitlab-pipeline-monitoring --operation="list" --project="fub" --timeframe="past_48h"

    # External service status
    datadog-management --query="service:external-$integration_type status:error" --timeframe="past_6h"
}
```

### Knowledge Management Integration

**Documentation Workflow:**
```bash
# Comprehensive documentation creation from investigation
create_investigation_docs() {
    local issue_id="$1"
    local investigation_dir="$2"

    # Create Confluence page from investigation
    confluence-management --operation="create_page" \
        --title="Investigation: $issue_id" \
        --content="$(cat $investigation_dir/root-cause-summary.md)"

    # Update Jira with documentation link
    jira-management --operation="add_comment" \
        --issue="$issue_id" \
        --comment="Investigation completed. Documentation: [Confluence link]"

    # Create knowledge base entry for similar issues
    confluence-management --operation="update_page" \
        --page_id="troubleshooting-runbook" \
        --append_content="## $issue_id Pattern\n$(cat $investigation_dir/investigation-patterns.md)"
}
```

**Team Knowledge Sharing:**
```bash
# Share investigation patterns with team
share_investigation_insights() {
    local investigation_type="$1"
    local insights_file="$2"

    # Create reusable investigation template
    skill-development --operation="create_template" \
        --template_type="investigation_pattern" \
        --source="$insights_file"

    # Update team documentation
    confluence-management --operation="update_space" \
        --space="ENG" \
        --page_type="investigation_patterns" \
        --content="$insights_file"
}
```

### Automation Integration Patterns

**Automated Investigation Triggers:**
```bash
# CI/CD integration for automatic investigation
.gitlab-ci.yml_investigation_stage() {
    cat << 'EOF'
investigate_deployment_issues:
  stage: post-deploy
  script:
    - |
      if [[ $DEPLOYMENT_ERRORS -gt 0 ]]; then
        support-investigation --issue="deployment-failure-$CI_PIPELINE_ID" \
          --environment="$CI_ENVIRONMENT_NAME" \
          --scientific_mode=true \
          --auto_document=true
      fi
  when: on_failure
EOF
}
```

**Monitoring Integration:**
```bash
# Datadog alert to investigation automation
datadog_alert_handler() {
    local alert_type="$1"
    local account_id="$2"
    local severity="$3"

    case "$severity" in
        "critical")
            # Immediate investigation for critical issues
            support-investigation --issue="critical-$alert_type" \
                --account_id="$account_id" \
                --scientific_mode=advanced \
                --confidence_minimum=high \
                --auto_escalate=true
            ;;
        "warning")
            # Queue for batch investigation
            echo "$alert_type,$account_id,$(date)" >> /tmp/investigation_queue.csv
            ;;
    esac
}
```