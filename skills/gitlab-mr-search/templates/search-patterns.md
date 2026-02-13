## GitLab MR Search Patterns and Templates

### Essential Daily Operations

**1. Daily MR Discovery**
```bash
# Get health summary of all my open MRs
/gitlab-mr-search --query="author:me state:opened"

# Find MRs ready for review
/gitlab-mr-search --query="state:opened label:ready-for-review"

# Search for specific feature MRs
/gitlab-mr-search --query="feature authentication" --project_path="fub/fub"
```

**2. Individual MR Analysis**
```bash
# Get comprehensive MR details with merge readiness
/gitlab-mr-search --mr_iid="123" --project_path="fub/fub"

# Quick MR triage assessment
/gitlab-mr-search --mr_iid="456" --operation="triage-summary"

# Cross-project MR search
/gitlab-mr-search --query="API integration"
```

**3. Team Collaboration**
```bash
# Find MRs requiring attention
/gitlab-mr-search --query="reviewer:me state:opened"

# Search by label or milestone
/gitlab-mr-search --query="milestone:'Sprint 23'" --project_path="fub/fub-spa"

# Find blocked or failing MRs
/gitlab-mr-search --query="label:blocked OR label:pipeline-failed"
```

### Common Search Patterns

| Search Type | Query Pattern | Example |
|------------|---------------|---------|
| **By Author** | `author:username` | `author:me`, `author:john.smith` |
| **By State** | `state:opened/closed/merged` | `state:opened` |
| **By Label** | `label:"label-name"` | `label:"ready-for-review"` |
| **By Milestone** | `milestone:"name"` | `milestone:"Sprint 23"` |
| **By Reviewer** | `reviewer:username` | `reviewer:me` |
| **By Branch** | `source_branch:name` | `source_branch:feature/auth` |
| **Combined** | Multiple filters with AND/OR | `author:me state:opened label:bug` |

### FUB Project Shortcuts

| Short Name | Full Project Path | Common Use Cases |
|------------|------------------|------------------|
| `fub` | `fub/fub` | Main application MRs, backend changes |
| `fub-spa` | `fub/fub-spa` | Frontend/SPA related changes |
| `fub-ios` | `fub/fub-ios` | iOS application development |
| `fub-android` | `fub/fub-android` | Android application development |
| `fub-api` | `fub/fub-api` | API service modifications |
| `pegasus` | `fub/pegasus` | Integration platform changes |

### Search Response Format

**MR List Response:**
- Title, IID, author, state, labels
- Merge readiness indicators (conflicts, approvals, pipelines)
- Comment count and unresolved discussion indicators
- Last updated timestamp and activity level

**Individual MR Response:**
- Complete description and metadata
- Approval status and reviewer assignments
- Pipeline status and test results
- Merge conflicts and readiness assessment
- Discussion summary with blocker identification

### MR Health and Readiness Assessment

**Merge Readiness Indicators:**
```markdown
MR Analysis Response Format:
✓ Approvals: [2/2 required approvals obtained]
✓ Pipeline: [All checks passed]
⚠ Discussions: [3 unresolved, 1 blocking]
✗ Conflicts: [Merge conflicts detected with main]
📊 Coverage: [+2.3% line coverage, 94.2% total]

Status: Ready for merge (after resolving discussions)
```

**Automated Triage Classification:**
```markdown
Triage Categories:
🚨 **Blockers**: Unresolved blocking comments, pipeline failures
⚠️  **Issues**: Merge conflicts, missing approvals, failing tests
💡 **Improvements**: Suggestions, code style, non-critical feedback
✅ **Ready**: All checks passed, ready to merge
```

### Team Workflow Integration

**Sprint Planning Assistance:**
```bash
# Sprint planning assistance
/gitlab-mr-search --query="milestone:'Sprint 24' state:opened"

# Release preparation
/gitlab-mr-search --query="target_branch:release/v2.1 state:opened"

# Hotfix tracking
/gitlab-mr-search --query="label:hotfix created_after:yesterday"
```

**Cross-Project Feature Tracking:**
```bash
# Track feature implementation across microservices
/gitlab-mr-search --query="milestone:'Auth Redesign'"
# Searches: fub/fub, fub/fub-spa, fub/fub-api automatically

# Dependencies and related changes
/gitlab-mr-search --query="label:dependency user-service"
```

These search patterns provide efficient MR discovery and analysis capabilities optimized for FUB development workflows.
