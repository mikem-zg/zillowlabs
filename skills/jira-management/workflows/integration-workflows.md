## Cross-Skill Integration Workflows and Coordination Patterns

### Development Workflow Integration

**Issue-Driven Development:**
```bash
# Issue-driven development workflow
/jira-management --operation="get-issue" --issue_key="FUB-1234" |\
  development-investigation --task="Implement FUB-1234" --scope="feature"

# Code review integration
/jira-management --operation="transition" --issue_key="FUB-1234" --status="In Review" |\
  code-development --workflow="review" --issue="FUB-1234"
```

**Branch and Development Lifecycle:**
```bash
# Complete development workflow with Jira integration
issue_driven_development() {
    local issue_key="$1"
    
    # 1. Get issue details and create branch
    issue_data=$(/jira-management --operation="get-issue" --issue_key="$issue_key")
    summary=$(echo "$issue_data" | jq -r '.fields.summary')
    
    # 2. Transition to In Progress
    /jira-management --operation="transition" --issue_key="$issue_key" --status="In Progress"
    
    # 3. Add development start comment
    /jira-management --operation="add-comment" --issue_key="$issue_key" \
        --comment_body="Development started - branch: feature/$issue_key"
    
    # 4. On completion, transition to review
    /jira-management --operation="transition" --issue_key="$issue_key" --status="In Review"
    /jira-management --operation="add-comment" --issue_key="$issue_key" \
        --comment_body="Implementation complete - ready for code review"
}
```

### Support Investigation Integration

**Bug Investigation Workflow:**
```bash
# Bug investigation with Jira issue creation
/jira-management --operation="create-issue" --issue_type="Bug" |\
  support-investigation --issue="Bug investigation" --environment="production"

# Investigation findings to issue
/support-investigation --operation="complete" |\
  jira-management --operation="update-issue" --add_investigation_results=true
```

**Incident Response Integration:**
```bash
# Incident response with Jira tracking
incident_response_workflow() {
    local incident_summary="$1"
    local environment="$2"
    
    # 1. Create incident ticket
    local issue_key=$(/jira-management --operation="create-issue" \
        --project_key="FUB" --issue_type="Bug" --priority="Critical" \
        --summary="[INCIDENT] $incident_summary" | jq -r '.key')
    
    # 2. Start support investigation
    /support-investigation --issue="$incident_summary" --environment="$environment" \
        --jira_issue="$issue_key"
    
    # 3. Regular status updates
    /jira-management --operation="add-comment" --issue_key="$issue_key" \
        --comment_body="Investigation in progress - checking system metrics"
    
    echo "Incident tracked in: $issue_key"
}
```

### GitLab Pipeline Integration

**Pipeline Status Updates:**
```bash
# Pipeline status updates to Jira issues
/gitlab-pipeline-monitoring --project="fub-core" |\
  jira-management --operation="update-pipeline-status" --auto_detect_issues=true

# Deployment notifications
/jira-management --operation="get-ready-issues" |\
  gitlab-pipeline-monitoring --operation="deploy-with-notifications"
```

**CI/CD Integration:**
```bash
# Complete CI/CD workflow with Jira integration
cicd_integration_workflow() {
    local issue_key="$1"
    local merge_request_id="$2"
    
    # 1. Link MR to Jira issue
    /jira-management --operation="add-comment" --issue_key="$issue_key" \
        --comment_body="Merge request created: [MR !$merge_request_id|https://gitlab.com/fub/core/merge_requests/$merge_request_id]"
    
    # 2. Monitor pipeline status
    pipeline_status=$(/gitlab-pipeline-monitoring --operation="get-pipeline-status" --mr_id="$merge_request_id")
    
    # 3. Update Jira based on pipeline results
    if [[ "$pipeline_status" == "success" ]]; then
        /jira-management --operation="add-comment" --issue_key="$issue_key" \
            --comment_body="✅ Pipeline passed - ready for merge"
        /jira-management --operation="transition" --issue_key="$issue_key" --status="Ready for Deploy"
    else
        /jira-management --operation="add-comment" --issue_key="$issue_key" \
            --comment_body="❌ Pipeline failed - see details in MR !$merge_request_id"
    fi
}
```

### Database Operations Integration

**Database Change Management:**
```bash
# Database changes with Jira tracking
database_change_workflow() {
    local issue_key="$1"
    local change_description="$2"
    
    # 1. Update Jira with database change plan
    /jira-management --operation="add-comment" --issue_key="$issue_key" \
        --comment_body="Database changes planned: $change_description"
    
    # 2. Execute database operations with tracking
    /database-operations --operation="schema-change" --description="$change_description" \
        --jira_issue="$issue_key"
    
    # 3. Update Jira with completion status
    /jira-management --operation="add-comment" --issue_key="$issue_key" \
        --comment_body="✅ Database changes applied successfully"
}
```

### Confluence Integration

**Documentation Updates:**
```bash
# Update documentation with issue tracking
documentation_update_workflow() {
    local issue_key="$1"
    local page_title="$2"
    
    # 1. Link documentation update to issue
    /jira-management --operation="add-comment" --issue_key="$issue_key" \
        --comment_body="Updating documentation: $page_title"
    
    # 2. Update Confluence page
    /confluence-management --operation="update-page" --title="$page_title" \
        --content="Updated for issue $issue_key"
    
    # 3. Link back to Confluence
    page_url=$(/confluence-management --operation="get-page-url" --title="$page_title")
    /jira-management --operation="add-comment" --issue_key="$issue_key" \
        --comment_body="📝 Documentation updated: [$page_title|$page_url]"
}
```

### Multi-Skill Coordination Examples

**Complete Feature Development Workflow:**
```bash
# End-to-end feature development with full integration
complete_feature_workflow() {
    local feature_summary="$1"
    
    # 1. Create feature story
    local issue_key=$(/jira-management --operation="create-issue" \
        --project_key="FUB" --issue_type="Story" \
        --summary="$feature_summary" | jq -r '.key')
    
    # 2. Development phase
    /jira-management --operation="transition" --issue_key="$issue_key" --status="In Progress"
    /code-development --task="Implement $feature_summary" --issue="$issue_key"
    
    # 3. Testing phase
    /jira-management --operation="add-comment" --issue_key="$issue_key" \
        --comment_body="Implementation complete - starting testing"
    /backend-test-development --target="FeatureTest" --issue="$issue_key"
    
    # 4. Code review and deployment
    /jira-management --operation="transition" --issue_key="$issue_key" --status="In Review"
    /gitlab-pipeline-monitoring --operation="create-mr" --issue="$issue_key"
    
    # 5. Documentation
    /confluence-management --operation="create-page" --title="$feature_summary Documentation"
    /jira-management --operation="transition" --issue_key="$issue_key" --status="Done"
    
    echo "Feature workflow completed for: $issue_key"
}
```

**Bug Resolution Workflow:**
```bash
# Complete bug resolution with cross-skill coordination
bug_resolution_workflow() {
    local bug_summary="$1"
    local environment="$2"
    
    # 1. Create bug ticket
    local issue_key=$(/jira-management --operation="create-issue" \
        --project_key="FUB" --issue_type="Bug" --priority="High" \
        --summary="$bug_summary" | jq -r '.key')
    
    # 2. Investigation phase
    /jira-management --operation="transition" --issue_key="$issue_key" --status="In Progress"
    /support-investigation --issue="$bug_summary" --environment="$environment" \
        --jira_issue="$issue_key"
    
    # 3. Fix implementation
    /code-development --task="Fix: $bug_summary" --scope="bugfix" --issue="$issue_key"
    
    # 4. Testing and verification
    /backend-test-development --target="BugFix" --test_type="regression" \
        --issue="$issue_key"
    
    # 5. Deployment and monitoring
    /gitlab-pipeline-monitoring --operation="deploy" --issue="$issue_key"
    /datadog-management --task_type="monitor" --query_context="bug fix verification"
    
    # 6. Resolution and documentation
    /jira-management --operation="add-comment" --issue_key="$issue_key" \
        --comment_body="✅ Bug resolved and deployed to production"
    /jira-management --operation="transition" --issue_key="$issue_key" --status="Done"
    
    echo "Bug resolution completed for: $issue_key"
}
```

### Integration Monitoring and Health Checks

**System Health Integration:**
```bash
# Monitor cross-skill integration health
integration_health_check() {
    echo "=== Jira Integration Health Check ==="
    
    # 1. Check MCP connection
    if /jira-management --operation="health-check"; then
        echo "✅ Jira MCP connection healthy"
    else
        echo "❌ Jira MCP connection issues detected"
    fi
    
    # 2. Check GitLab integration
    if /gitlab-pipeline-monitoring --operation="health-check"; then
        echo "✅ GitLab integration healthy"
    else
        echo "❌ GitLab integration issues detected"
    fi
    
    # 3. Check Confluence integration
    if /confluence-management --operation="health-check"; then
        echo "✅ Confluence integration healthy"
    else
        echo "❌ Confluence integration issues detected"
    fi
    
    # 4. Generate integration status report
    /jira-management --operation="create-issue" --project_key="ADMIN" \
        --issue_type="Task" --summary="Integration Health Report $(date +%Y-%m-%d)" \
        --description="Automated integration health check results"
}
```

These integration workflows provide comprehensive coordination between Jira management and all related FUB development skills, ensuring seamless issue tracking throughout the entire development lifecycle.
