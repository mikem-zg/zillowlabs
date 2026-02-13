---
name: jira-management
description: Comprehensive Jira issue management including search, retrieval, creation, and updates with Atlassian MCP integration and acli CLI fallback
---

## Overview

Comprehensive Jira issue management with Atlassian MCP integration providing seamless issue operations, advanced search capabilities, and robust fallback mechanisms. Optimized for FUB development workflows with intelligent error handling and cross-skill integration.

📋 **Issue Templates**: [templates/issue-templates.md](templates/issue-templates.md)
🚀 **Advanced Patterns**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
🔗 **Integration Workflows**: [workflows/integration-workflows.md](workflows/integration-workflows.md)
🔧 **Troubleshooting**: [reference/troubleshooting.md](reference/troubleshooting.md)

## Usage

```bash
/jira-management --operation=<operation> [options]
```

## Core Operations

### Issue Search and Retrieval

**Basic Search:**
```bash
# Search by project and status
/jira-management --operation="search" --project_key="FUB" --status="Open"

# Advanced JQL search
/jira-management --operation="search" --jql="project = FUB AND assignee = currentUser() AND status IN (Open, 'In Progress')"

# Search with field filtering
/jira-management --operation="search" --jql="project = FUB" --fields="summary,status,assignee" --max_results=25
```

**Issue Details:**
```bash
# Get complete issue details
/jira-management --operation="get-issue" --issue_key="FUB-1234"

# Get specific fields only
/jira-management --operation="get-issue" --issue_key="FUB-1234" --fields="summary,description,status,assignee"
```

### Issue Creation

**Quick Issue Creation:**
```bash
# Create basic task
/jira-management --operation="create-issue" --project_key="FUB" --summary="Fix login bug" --issue_type="Bug" --priority="High"

# Create story with description
/jira-management --operation="create-issue" --project_key="FUB" --issue_type="Story" --summary="User profile enhancement" --description="Add profile photo upload functionality" --assignee="currentUser()"
```

→ **Complete issue templates and creation patterns**: [templates/issue-templates.md](templates/issue-templates.md)

### Issue Updates and Transitions

**Update Issue Fields:**
```bash
# Update summary and description
/jira-management --operation="update-issue" --issue_key="FUB-1234" --summary="Updated summary" --description="Updated description"

# Assign issue
/jira-management --operation="update-issue" --issue_key="FUB-1234" --assignee="john.doe"

# Change priority
/jira-management --operation="update-issue" --issue_key="FUB-1234" --priority="Critical"
```

**Status Transitions:**
```bash
# Get available transitions
/jira-management --operation="get-transitions" --issue_key="FUB-1234"

# Transition to In Progress
/jira-management --operation="transition" --issue_key="FUB-1234" --status="In Progress"

# Close issue
/jira-management --operation="transition" --issue_key="FUB-1234" --status="Done"
```

**Add Comments:**
```bash
# Add simple comment
/jira-management --operation="add-comment" --issue_key="FUB-1234" --comment_body="Work in progress, ETA tomorrow"

# Add formatted comment with mentions
/jira-management --operation="add-comment" --issue_key="FUB-1234" --comment_body="Fixed the issue. [~john.doe] please review."
```

## Essential Workflows

### Development Integration

**Branch and Issue Lifecycle:**
```bash
# Get issue for development work
issue_data=$(/jira-management --operation="get-issue" --issue_key="FUB-1234")

# Create branch from issue (integration with git)
/jira-management --operation="create-branch" --issue_key="FUB-1234"

# Update issue on commit
/jira-management --operation="add-comment" --issue_key="FUB-1234" --comment_body="Implementation started in branch feature/FUB-1234"

# Auto-transition on merge
/jira-management --operation="transition" --issue_key="FUB-1234" --status="Done"
```

### Project Management

**Project Information:**
```bash
# List accessible projects
/jira-management --operation="list-projects"

# Get project metadata
/jira-management --operation="get-project-meta" --project_key="FUB"

# Get issue types for project
/jira-management --operation="get-issue-types" --project_key="FUB"
```

**Sprint and Epic Management:**
```bash
# Get sprint issues
/jira-management --operation="search" --jql="project = FUB AND sprint in openSprints()"

# Get epic breakdown
/jira-management --operation="get-epic-issues" --issue_key="EPIC-100"

# Sprint progress report
/jira-management --operation="sprint-report" --sprint_id="123"
```

## MCP Integration and Resilience

### Primary MCP Operations

**Core MCP Functions:**
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

### Automatic Fallback System

**Health Monitoring:**
```bash
# Check overall system health
/jira-management --operation="health-check"

# Monitor MCP connection status
/jira-management --operation="monitor-connection" --continuous=true
```

→ **Advanced patterns and bulk operations**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)

## Cross-Skill Integration

### Primary Integration Relationships

**Development Workflow Integration:**
```bash
# Issue-driven development
/jira-management --operation="get-issue" --issue_key="FUB-1234" |\
  development-investigation --task="Implement FUB-1234" --scope="feature"

# Code review integration
/jira-management --operation="transition" --issue_key="FUB-1234" --status="In Review" |\
  code-development --workflow="review" --issue="FUB-1234"
```

**Support Investigation Integration:**
```bash
# Bug investigation workflow
/jira-management --operation="create-issue" --issue_type="Bug" |\
  support-investigation --issue="Bug investigation" --environment="production"

# Investigation findings to issue
/support-investigation --operation="complete" |\
  jira-management --operation="update-issue" --add_investigation_results=true
```

**GitLab Pipeline Integration:**
```bash
# Pipeline status updates
/gitlab-pipeline-monitoring --project="fub-core" |\
  jira-management --operation="update-pipeline-status" --auto_detect_issues=true

# Deployment notifications
/jira-management --operation="get-ready-issues" |\
  gitlab-pipeline-monitoring --operation="deploy-with-notifications"
```

→ **Complete integration workflows and coordination patterns**: [workflows/integration-workflows.md](workflows/integration-workflows.md)

## Error Handling and Recovery

### Common Error Patterns

| **Error Type** | **Detection** | **Recovery** |
|----------------|---------------|--------------|
| **MCP Connection Failed** | Connection timeout, authentication errors | Switch to acli fallback, restart MCP server |
| **Rate Limiting** | 429 HTTP errors | Implement exponential backoff, reduce request frequency |
| **Permission Denied** | 403 errors | Validate user permissions, check project access |
| **Invalid JQL** | JQL syntax errors | Validate query syntax, provide corrected examples |
| **Issue Not Found** | 404 errors | Verify issue key format, check issue existence |

**Emergency Recovery:**
```bash
# Complete system recovery
/jira-management --operation="emergency-recovery"
```

→ **Complete troubleshooting guide and MCP fallback reference**: [reference/troubleshooting.md](reference/troubleshooting.md)

## Security and Best Practices

**Authentication Management:**
- Validate user permissions before operations
- Audit trail for sensitive operations
- Input sanitization for JQL queries

**Data Safety:**
- Backup before bulk operations
- Validate input parameters
- Rate limiting for large-scale operations

## Refusal Conditions

The skill must refuse if:

- **Authentication Issues**: MCP authentication fails and acli fallback is unavailable
- **Data Safety Violations**: Bulk operations without proper confirmation on production data
- **Rate Limiting Violations**: Requests exceed Atlassian API rate limits

When refusing, provide specific steps to resolve the issue including authentication refresh procedures, permission verification steps, and safe operation alternatives.

**Critical Safety Note**: All operations prioritize data integrity, user permissions, and system stability. When in doubt about safety or permissions, always request explicit confirmation before proceeding.

## Supporting Infrastructure

→ **Advanced patterns, bulk operations, and performance optimization**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
→ **Essential issue templates and creation patterns**: [templates/issue-templates.md](templates/issue-templates.md)
→ **Cross-skill integration workflows and coordination patterns**: [workflows/integration-workflows.md](workflows/integration-workflows.md)

This skill provides comprehensive Jira issue management with intelligent MCP integration, robust fallback mechanisms, and seamless coordination with FUB development workflows.
