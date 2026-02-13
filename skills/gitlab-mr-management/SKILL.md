---
name: gitlab-mr-management
description: GitLab merge request creation, updates, and lifecycle management with automated templates, approval workflows, and merge operations using GitLab Sidekick MCP and glab CLI integration
---

## Examples

```bash
# Create feature MR with automatic template detection
/gitlab-mr-management --operation="create" --title="Add user authentication system"

# Create MR with specific labels and reviewers
/gitlab-mr-management --operation="create" --title="Fix payment processing bug" --labels="bug,P1,ready-for-review" --assignees="john.doe,jane.smith"

# Update existing MR description and labels
/gitlab-mr-management --operation="update" --mr_iid="123" --labels="ready-for-merge" --project_path="fub/fub"

# Merge MR after all checks pass
/gitlab-mr-management --operation="merge" --mr_iid="456" --project_path="fub/fub-spa"

# Create hotfix MR with expedited template
/gitlab-mr-management --operation="create" --source_branch="hotfix/critical-security-fix" --labels="hotfix,P0"
```

## Overview

GitLab merge request creation, updates, and lifecycle management with automated templates, approval workflows, and merge operations using GitLab Sidekick MCP and glab CLI integration. Comprehensive MR management with intelligent template application, automated approval workflows, and safe merge operations optimized for FUB development standards.

## Usage

```bash
/gitlab-mr-management --operation=<op_type> [--mr_iid=<id>] [--project_path=<path>] [--title=<title>] [--description=<desc>] [--source_branch=<branch>] [--target_branch=<branch>] [--labels=<labels>] [--assignees=<users>] [--draft=<bool>] [--delete_source_branch=<bool>]
```

# GitLab MR Management & Lifecycle

## Core Workflow

### Essential Operations (Most Common - 90% of Usage)

**1. MR Creation**
```bash
# Standard feature MR creation (auto-detects branch and applies template)
gitlab-mr-management --operation="create" --title="Implement OAuth integration"

# Bug fix MR with priority and labels
gitlab-mr-management --operation="create" --title="Fix login timeout issue" --labels="bug,P2"

# Draft MR for work-in-progress
gitlab-mr-management --operation="create" --title="WIP: Payment gateway integration" --draft=true
```

**2. MR Updates and Refinement**
```bash
# Update MR to ready-for-review status
gitlab-mr-management --operation="update" --mr_iid="123" --labels="ready-for-review" --draft=false

# Assign reviewers and add milestone
gitlab-mr-management --operation="update" --mr_iid="456" --assignees="tech.lead,senior.dev"

# Update description with testing details
gitlab-mr-management --operation="update" --mr_iid="789" --description="Updated with comprehensive test results"
```

**3. MR Merging and Completion**
```bash
# Safe merge with validation checks
gitlab-mr-management --operation="merge" --mr_iid="123" --project_path="fub/fub"

# Merge and delete source branch
gitlab-mr-management --operation="merge" --mr_iid="456" --delete_source_branch=true

# Close MR without merging (superseded or cancelled)
gitlab-mr-management --operation="close" --mr_iid="789"
```

### Preconditions

- **Git Repository Context**: Must be run from within FUB git repository with:
  - Valid remote origin configured for GitLab
  - Current branch pushed to GitLab (for MR creation)
  - Proper git configuration (user.name, user.email)
- **GitLab Permissions**: User must have:
  - Developer access to source project for MR creation
  - Maintainer access for merging operations
  - Project access for target branch operations
- **Tool Availability**:
  - GitLab Sidekick MCP server for advanced operations with automatic resilience integration
  - glab CLI installed and authenticated for basic operations and MCP failover
  - Git CLI available for branch operations

**MCP Resilience Integration**: This skill implements standardized MCP resilience patterns:
- Automatic health checking for GitLab Sidekick MCP server before MR operations
- Circuit breaker protection for failing GitLab Sidekick connections during MR workflows
- Seamless fallback to glab CLI when MCP operations fail
- Transparent error communication and recovery with glab CLI alternatives
- Integration with mcp-server-management skill for automated recovery and connection restart

### Template Detection and Application

**Automatic Template Selection:**
```markdown
Branch Pattern → Template Applied:
feature/* → Feature MR template
bugfix/* → Bug fix template
hotfix/* → Hotfix template (expedited)
refactor/* → Refactoring template
docs/* → Documentation template
WIP-* → Draft MR with work-in-progress template
```

## Quick Reference

### MR Templates (Auto-Applied by Branch Type)

**Feature MR Template:**
```markdown
## What does this MR do?
[Brief description of the feature]

## Related issues
Closes #[issue_number]

## Author's checklist
- [ ] Feature implemented according to requirements
- [ ] Tests added/updated and passing
- [ ] Documentation updated
- [ ] Code review checklist completed
- [ ] Database migrations (if any) are reversible

## Review checklist
- [ ] Code follows FUB style guidelines
- [ ] Security considerations addressed
- [ ] Performance impact assessed
- [ ] Breaking changes documented

/label ~feature ~"ready-for-review"
```

**Bug Fix Template:**
```markdown
## 🐛 Bug Fix Summary
Brief description of the bug and fix

## Steps to reproduce
1. Step one
2. Step two
3. Observe issue

## What changed
- Specific changes made to fix the issue
- Root cause analysis

## Testing
- [ ] Bug reproduction test added
- [ ] Regression tests updated
- [ ] Manual testing completed

## Related issues
Fixes #[issue_number]

/label ~bug ~"ready-for-review"
```

**Hotfix Template:**
```markdown
## 🚨 Hotfix Summary
Critical issue requiring immediate deployment

## Changes Made
[Detailed description of changes]

## Testing Performed
- [ ] Production-like environment testing
- [ ] Smoke tests completed
- [ ] Rollback procedure verified

## Deployment Notes
- [ ] Deployment window: [time/date]
- [ ] Rollback plan confirmed
- [ ] Monitoring alerts configured

/label ~hotfix ~P0 ~"ready-for-merge"
```

### Label and Workflow Management

**Standard Label Categories:**
```markdown
Priority: P0 (critical), P1 (high), P2 (medium), P3 (low)
Type: feature, bug, hotfix, refactor, docs, infrastructure
Status: draft, ready-for-review, ready-for-merge, blocked
Review: needs-review, changes-requested, approved
Domain: frontend, backend, mobile, infrastructure, security
```

**Automatic Label Application Rules:**
```markdown
Branch Pattern → Auto Labels:
hotfix/* → hotfix, P0
bugfix/* → bug, P2
feature/* → feature, P3
refactor/* → refactor, P3
docs/* → documentation, P3
security/* → security, P1
```

## Advanced Patterns

### Intelligent MR Creation

**Context-Aware MR Generation:**
```bash
# Analyze git history and generate comprehensive MR
gitlab-mr-management --operation="create" --title="Auto-analyze changes"
# Scans: commit messages, changed files, related issues, test coverage

# Cross-branch impact analysis during creation
gitlab-mr-management --operation="create" --source_branch="feature/auth-redesign"
# Analyzes: conflicts with other branches, dependency impacts, breaking changes
```

**Smart Template Customization:**
```markdown
Template Enhancement Based on Analysis:
- **File Changes**: Auto-add database migration checklist if schema changes detected
- **Test Coverage**: Include coverage requirements if test files modified
- **Security Impact**: Add security review checklist for auth/permission changes
- **Performance Impact**: Include performance testing requirements for core services
- **Breaking Changes**: Auto-generate breaking change documentation template
```

### Advanced Update and Lifecycle Management

**Conditional MR Updates:**
```bash
# Update MR based on pipeline status
gitlab-mr-management --operation="update" --mr_iid="123" --condition="pipeline_success" --labels="ready-for-merge"

# Bulk label management based on milestone
gitlab-mr-management --operation="update" --milestone="Sprint 24" --labels="sprint-complete"

# Auto-rebase and update when target branch changes
gitlab-mr-management --operation="update" --mr_iid="456" --rebase=true --force_update=true
```

**Merge Strategy Optimization:**
```markdown
Merge Method Selection Logic:
- **Feature branches**: Merge commit (preserves feature context)
- **Hotfix branches**: Fast-forward (clean history for emergency fixes)
- **Refactor branches**: Squash merge (single clean commit)
- **Documentation**: Fast-forward (minimal history impact)
```

### Quality Gates and Validation

**Pre-Merge Validation Pipeline:**
```markdown
Automated Checks Before Merge:
✓ All required approvals obtained
✓ Pipeline status: passed
✓ No unresolved blocking discussions
✓ No merge conflicts with target branch
✓ Required labels present (ready-for-merge)
✓ Security scan passed (if security-sensitive changes)
✓ Performance impact assessed (if core service changes)
```

**Compliance and Audit Trail:**
```bash
# Create compliance-tracked MR for sensitive changes
gitlab-mr-management --operation="create" --compliance_mode=true --title="Update user permissions"
# Includes: audit trail, change justification, approval workflow documentation

# SOX compliance for financial data changes
gitlab-mr-management --operation="create" --sox_compliance=true --reviewers="compliance.team"
```

### Cross-Project MR Coordination

**Multi-Repository Feature Coordination:**
```bash
# Create coordinated MRs across microservices
gitlab-mr-management --operation="create" --coordination_group="auth-redesign" --projects="fub/fub,fub/fub-api,fub/fub-spa"

# Dependency-aware merge sequencing
gitlab-mr-management --operation="merge" --mr_iid="123" --wait_for_dependencies="fub/fub-api#456"
```

**Release Branch Management:**
```bash
# Create release preparation MR
gitlab-mr-management --operation="create" --target_branch="release/v2.1" --source_branch="develop" --template="release"

# Cherry-pick hotfix to multiple branches
gitlab-mr-management --operation="cherry-pick" --mr_iid="789" --target_branches="release/v2.0,release/v2.1,main"
```

## Integration Points

### Cross-Skill Workflow Patterns

**Primary Integration Relationships:**

| Related Skill | Integration Type | Common Workflows |
|---------------|------------------|------------------|
| `gitlab-mr-search` | **Discovery → Management** | Search existing MRs → Create related MR → Link dependencies |
| `gitlab-pipeline-monitoring` | **CI/CD Validation** | Create MR → Monitor pipeline → Update based on results → Merge when ready |
| `gitlab-collaboration` | **Review Process** | Create MR → Triage reviews → Update based on feedback → Merge after approval |
| `code-development` | **Development Lifecycle** | Implement changes → Create MR → Iterate based on reviews → Deploy via merge |
| `jira-management` | **Issue Tracking** | Link Jira tickets → Create MR → Update issue status → Close on merge |
| `datadog-management` | **Deployment Monitoring** | Merge MR → Monitor deployment metrics → Rollback if issues detected |

**Multi-Skill Operation Examples:**

```bash
# Complete feature development workflow
code-development --task="Implement user notifications" |\
  gitlab-mr-management --operation="create" --title="Add notification system" |\
  gitlab-collaboration --operation="request-review" |\
  gitlab-mr-management --operation="merge"

# Bug fix with investigation and deployment monitoring
support-investigation --issue="Login timeout errors" |\
  code-development --task="Fix session timeout handling" |\
  gitlab-mr-management --operation="create" --labels="hotfix,P1" |\
  datadog-management --monitor="deployment impact"

# Release management workflow
gitlab-mr-search --query="milestone:'Release 2.1' ready-for-merge" |\
  gitlab-mr-management --operation="batch-merge" --target_branch="release/v2.1" |\
  gitlab-pipeline-monitoring --operation="release-validation"
```

### Workflow Handoff Patterns

**From gitlab-mr-management → Other Skills:**
- Provides MR creation notifications for pipeline monitoring
- Supplies merge events for deployment tracking and monitoring
- Delivers MR metadata for collaboration and review coordination
- Offers branch and commit information for code development context

**To gitlab-mr-management ← Other Skills:**
- Receives development completion signals from code implementation
- Gets approval status updates from collaboration and review workflows
- Obtains pipeline validation results for merge readiness assessment
- Accepts deployment feedback for merge strategy optimization

### Integration Architecture

**FUB Development Lifecycle Integration:**
```markdown
gitlab-mr-management orchestrates the central MR lifecycle:

1. **Code Integration Hub**: Receives development work and creates trackable MRs
2. **Quality Gateway**: Enforces standards, templates, and validation requirements
3. **Review Coordination**: Manages reviewer assignments and approval workflows
4. **Deployment Orchestration**: Controls merge timing and deployment coordination
5. **Compliance Management**: Ensures audit trails and regulatory requirements
```

**MR State Management:**
```markdown
State Transitions Managed:
Draft → Ready for Review → Changes Requested → Approved → Ready for Merge → Merged

Integration Points at Each State:
- Draft: Code development feedback, early collaboration
- Ready for Review: Review assignment, pipeline validation
- Changes Requested: Development iteration, code improvement
- Approved: Final validation, deployment preparation
- Ready for Merge: Deployment coordination, monitoring setup
- Merged: Deployment tracking, post-merge validation
```

This focused skill provides comprehensive MR lifecycle management while maintaining clean integration points with other GitLab workflow components and FUB development processes.