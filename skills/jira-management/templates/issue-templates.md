## Jira Issue Templates and Common Patterns

### Issue Creation Templates

**Basic Issue Creation:**
```bash
# Create basic task
/jira-management --operation="create-issue" --project_key="FUB" --summary="Fix login bug" --issue_type="Bug" --priority="High"

# Create story with description
/jira-management --operation="create-issue" --project_key="FUB" --issue_type="Story" --summary="User profile enhancement" --description="Add profile photo upload functionality" --assignee="currentUser()"

# Create epic for large features
/jira-management --operation="create-issue" --project_key="FUB" --issue_type="Epic" --summary="Authentication System Overhaul" --description="Complete redesign of authentication system"
```

### Issue Search Patterns

**Basic Search Operations:**
```bash
# Search by project and status
/jira-management --operation="search" --project_key="FUB" --status="Open"

# Search assigned to current user
/jira-management --operation="search" --jql="assignee = currentUser() AND status IN (Open, 'In Progress')"

# Search by component
/jira-management --operation="search" --jql="project = FUB AND component = 'Authentication'"
```

**Advanced JQL Search Patterns:**
```bash
# Issues updated in last week
/jira-management --operation="search" --jql="project = FUB AND updated >= -1w"

# High priority bugs
/jira-management --operation="search" --jql="project = FUB AND issuetype = Bug AND priority IN (High, Critical)"

# Sprint planning query
/jira-management --operation="search" --jql="project = FUB AND sprint in openSprints() ORDER BY rank"

# Epic breakdown
/jira-management --operation="search" --jql="'Epic Link' = FUB-100"
```

### Issue Update Patterns

**Field Updates:**
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

# Common workflow transitions
/jira-management --operation="transition" --issue_key="FUB-1234" --status="In Progress"
/jira-management --operation="transition" --issue_key="FUB-1234" --status="In Review"
/jira-management --operation="transition" --issue_key="FUB-1234" --status="Done"
```

### Comment Patterns

**Adding Comments:**
```bash
# Add simple comment
/jira-management --operation="add-comment" --issue_key="FUB-1234" --comment_body="Work in progress, ETA tomorrow"

# Add formatted comment with mentions
/jira-management --operation="add-comment" --issue_key="FUB-1234" --comment_body="Fixed the issue. [~john.doe] please review."
```

### Development Integration Templates

**Branch and Issue Lifecycle:**
```bash
# Get issue for development work
issue_data=$(/jira-management --operation="get-issue" --issue_key="FUB-1234")

# Update issue on commit
/jira-management --operation="add-comment" --issue_key="FUB-1234" --comment_body="Implementation started in branch feature/FUB-1234"

# Auto-transition on merge
/jira-management --operation="transition" --issue_key="FUB-1234" --status="Done"
```

### Project Management Templates

**Project Information:**
```bash
# List accessible projects
/jira-management --operation="list-projects"

# Get project metadata
/jira-management --operation="get-project-meta" --project_key="FUB"

# Sprint and Epic Management
/jira-management --operation="search" --jql="project = FUB AND sprint in openSprints()"
/jira-management --operation="get-epic-issues" --issue_key="EPIC-100"
```

These templates provide standardized approaches for common Jira operations in FUB development workflows.
