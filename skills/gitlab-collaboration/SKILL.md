---
name: gitlab-collaboration
description: GitLab merge request comment triage, review workflows, and collaboration management with intelligent comment classification, discussion resolution, and team coordination using GitLab Sidekick MCP integration
---

## Overview

GitLab merge request comment triage, review workflows, and collaboration management with intelligent comment classification, discussion resolution, and team coordination using GitLab Sidekick MCP integration. Streamlines code review processes with automated comment triage, reviewer coordination, and resolution tracking for efficient FUB team collaboration.

## Usage

```bash
/gitlab-collaboration --operation=<op_type> --mr_iid=<id> [--project_path=<path>] [--mode=<mode>] [--selection=<selection>] [--include_bots=<bool>] [--include_resolved=<bool>] [--include_system=<bool>] [--reviewer_action=<action>]
```

## Examples

```bash
# Get comprehensive comment triage summary
/gitlab-collaboration --operation="triage" --mr_iid="123" --mode="summary" --project_path="fub/fub"

# Show details for critical comments
/gitlab-collaboration --operation="triage" --mr_iid="456" --mode="show" --selection="critical"

# Review and approve MR after addressing comments
/gitlab-collaboration --operation="review" --mr_iid="789" --reviewer_action="approve"

# Analyze unresolved discussions
/gitlab-collaboration --operation="discussions" --mr_iid="123" --include_resolved=false

# Propose fixes for specific comments
/gitlab-collaboration --operation="triage" --mr_iid="456" --mode="propose" --selection="1,3,5"
```

# GitLab Collaboration & Review Management

Advanced GitLab merge request collaboration system with intelligent comment classification, automated discussion resolution, and streamlined review workflows. Optimized for FUB team collaboration with comprehensive triage capabilities and review coordination.

## Core Workflow

### Essential Operations (Most Common - 90% of Usage)

**1. Comment Triage and Analysis**
```bash
# Daily MR review: Get comment triage summary
gitlab-collaboration --operation="triage" --mr_iid="123" --mode="summary"

# Deep dive into critical issues
gitlab-collaboration --operation="triage" --mr_iid="456" --mode="show" --selection="critical"

# Quick overview of discussion status
gitlab-collaboration --operation="discussions" --mr_iid="789" --include_resolved=false
```

**2. Review Process Management**
```bash
# Conduct comprehensive MR review
gitlab-collaboration --operation="review" --mr_iid="123" --reviewer_action="request_changes"

# Approve MR after all issues resolved
gitlab-collaboration --operation="review" --mr_iid="456" --reviewer_action="approve"

# Add review comments without formal approval
gitlab-collaboration --operation="review" --mr_iid="789" --reviewer_action="comment_only"
```

**3. Discussion Resolution and Coordination**
```bash
# Propose fixes for identified issues
gitlab-collaboration --operation="triage" --mr_iid="123" --mode="propose" --selection="1,2,4"

# Apply automated fixes where possible
gitlab-collaboration --operation="triage" --mr_iid="456" --mode="apply" --selection="3,5,7"

# Track resolution progress
gitlab-collaboration --operation="discussions" --mr_iid="789" --mode="resolution_status"
```

### Preconditions

- **MR Access**: Valid merge request with existing comments or discussions
- **Project Permissions**: Appropriate access level for review and comment operations
- **GitLab Sidekick MCP**: Available for advanced comment analysis and classification (with automatic resilience)
- **Review Context**: Understanding of FUB code review standards and practices

**MCP Resilience Integration**: This skill implements standardized MCP resilience patterns:
- Automatic health checking for GitLab Sidekick MCP server before comment operations
- Seamless fallback to glab CLI for basic comment retrieval when MCP fails
- Circuit breaker protection for failing GitLab Sidekick connections
- Transparent error communication and recovery with manual comment analysis guidance

### Comment Classification System

**Severity Levels:**
```markdown
🚨 **Critical**: Security issues, breaking changes, major bugs
⚠️  **Major**: Significant logic issues, performance problems, design concerns
💡 **Minor**: Code style, optimization suggestions, best practice recommendations
📝 **Nitpick**: Formatting, naming conventions, minor style preferences
✅ **Positive**: Approval, appreciation, positive feedback
🤖 **Bot**: Automated tool feedback (linting, security scans, coverage)
```

## Quick Reference

### Triage Operation Modes

| Mode | Description | Use Case | Output Format |
|------|-------------|----------|---------------|
| `summary` | **Categorized overview** | Daily review, quick assessment | Grouped by severity with counts |
| `show` | **Detailed view** | Deep investigation, specific issues | Full comment content with context |
| `propose` | **Fix suggestions** | Active problem solving | Code diffs and proposed changes |
| `apply` | **Automated fixes** | Batch resolution | Applied changes with confirmation |

### Comment Triage Response Format

**Summary Mode Response:**
```markdown
## MR Comment Triage Summary - MR #123

### 🚨 Critical Issues (2)
1. [Security] SQL injection vulnerability in user query
2. [Breaking] API response format change without version update

### ⚠️ Major Issues (3)
3. [Performance] N+1 query in user listing endpoint
4. [Logic] Race condition in payment processing
5. [Design] Inconsistent error handling pattern

### 💡 Minor Suggestions (5)
6. [Style] Use consistent variable naming convention
7. [Optimization] Cache expensive calculation result
8. [Best Practice] Add input validation for user data
9. [Documentation] Missing docstring for public method
10. [Testing] Add edge case test for empty input

### 📝 Nitpicks (2)
11. [Formatting] Inconsistent indentation in config file
12. [Naming] Use more descriptive variable name

### Summary
- Total Comments: 12 active discussions
- Blocking Issues: 2 critical, 3 major
- Ready for Merge: ❌ (address critical/major issues first)
- Estimated Resolution Time: 2-4 hours

**Next Actions**: Address items 1-5, then re-request review
```

### Review Workflow Standards

**FUB Review Process:**
```markdown
Review Stages:
1. **Initial Triage**: Categorize all comments by severity
2. **Critical Resolution**: Address security and breaking changes immediately
3. **Major Issues**: Fix logic, performance, and design problems
4. **Minor Improvements**: Address style and optimization suggestions
5. **Final Approval**: Confirm all blocking issues resolved

Approval Criteria:
✅ No critical or major unresolved issues
✅ All discussions marked resolved or explicitly acknowledged
✅ Pipeline passing with required checks
✅ Appropriate test coverage for changes
✅ Documentation updated where necessary
```

## Advanced Patterns

### Intelligent Comment Analysis

**Context-Aware Classification:**
```bash
# Advanced triage with code context analysis
gitlab-collaboration --operation="triage" --mr_iid="123" --analyze_context=true
# Analyzes: file importance, change impact, code complexity, team ownership

# Cross-MR comment pattern analysis
gitlab-collaboration --operation="analyze" --timeframe="past_month" --patterns="recurring_issues"
# Identifies: common review feedback, team improvement opportunities
```

**Automated Issue Detection:**
```markdown
Smart Detection Capabilities:
- **Security Vulnerabilities**: SQL injection, XSS, authentication bypasses
- **Performance Issues**: N+1 queries, inefficient algorithms, memory leaks
- **Logic Errors**: Race conditions, null pointer risks, edge case failures
- **Design Problems**: Tight coupling, SRP violations, inconsistent patterns
- **Style Violations**: Naming conventions, formatting, documentation gaps
```

### Advanced Review Coordination

**Multi-Reviewer Orchestration:**
```bash
# Coordinate review assignments based on expertise
gitlab-collaboration --operation="assign_reviewers" --mr_iid="123" --expertise_matching=true

# Manage review dependencies and sequencing
gitlab-collaboration --operation="review_workflow" --mr_iid="456" --sequential_reviews=true

# Cross-team collaboration for complex changes
gitlab-collaboration --operation="stakeholder_review" --mr_iid="789" --teams="backend,frontend,security"
```

**Review Quality Enhancement:**
```markdown
Review Quality Features:
- **Expertise Matching**: Route reviews to team members with relevant domain knowledge
- **Review Load Balancing**: Distribute review workload evenly across team members
- **Conflict Resolution**: Mediate disagreements between reviewers with escalation paths
- **Review Templates**: Structured review checklists for consistent quality standards
```

### Automated Resolution Capabilities

**Smart Fix Proposals:**
```bash
# Generate fix proposals for common issues
gitlab-collaboration --operation="propose_fixes" --mr_iid="123" --auto_generate=true
# Generates: code suggestions, test additions, documentation updates

# Apply safe automated fixes
gitlab-collaboration --operation="auto_fix" --mr_iid="456" --safety_level="conservative"
# Applies: formatting fixes, simple refactors, documentation additions
```

**Resolution Tracking and Verification:**
```markdown
Resolution Management:
- **Progress Tracking**: Monitor comment resolution progress in real-time
- **Verification Checks**: Confirm proposed fixes actually address reported issues
- **Regression Prevention**: Ensure fixes don't introduce new problems
- **Resolution Quality**: Validate that fixes meet team standards
```

### Team Collaboration Optimization

**Communication Enhancement:**
```bash
# Generate discussion summaries for stakeholders
gitlab-collaboration --operation="summarize" --mr_iid="123" --audience="management"

# Create action item tracking from review comments
gitlab-collaboration --operation="action_items" --mr_iid="456" --assign_owners=true

# Cross-MR impact analysis for related changes
gitlab-collaboration --operation="impact_analysis" --mr_ids="123,456,789"
```

**Knowledge Sharing Integration:**
```markdown
Learning and Improvement:
- **Review Pattern Analysis**: Identify common feedback themes for team education
- **Best Practice Extraction**: Derive coding standards from successful reviews
- **Mentorship Support**: Pair junior developers with experienced reviewers
- **Knowledge Base Updates**: Capture review insights for future reference
```

## Integration Points

### Cross-Skill Workflow Patterns

**Primary Integration Relationships:**

| Related Skill | Integration Type | Common Workflows |
|---------------|------------------|------------------|
| `gitlab-mr-search` | **Discovery Integration** | Search MRs needing review → Analyze comments → Prioritize review work |
| `gitlab-mr-management` | **Review Lifecycle** | Create MR → Triage comments → Update based on feedback → Approve for merge |
| `code-development` | **Development Iteration** | Code changes → Review feedback → Address comments → Re-review cycle |
| `support-investigation` | **Issue Analysis** | Bug reports → Code review → Root cause discussion → Resolution validation |
| `serena-mcp` | **Code Analysis** | Review comments → Code exploration → Impact analysis → Fix implementation |
| `jira-management` | **Issue Tracking** | Link review feedback → Track resolution progress → Update issue status |

**Multi-Skill Operation Examples:**

```bash
# Complete review cycle with development integration
gitlab-collaboration --operation="triage" --mr_iid="123" --mode="summary" |\
  code-development --task="Address review feedback items 1-5" |\
  gitlab-collaboration --operation="review" --reviewer_action="approve"

# Investigation-driven review workflow
support-investigation --issue="Payment processing errors" |\
  gitlab-mr-search --query="payment processing recent changes" |\
  gitlab-collaboration --operation="triage" --focus="security,performance" |\
  code-development --task="Implement security improvements"

# Cross-MR review coordination
gitlab-mr-search --query="milestone:'Auth Redesign' ready-for-review" |\
  gitlab-collaboration --operation="batch_triage" --coordination_mode=true |\
  gitlab-collaboration --operation="cross_mr_review" --focus="consistency"
```

### Workflow Handoff Patterns

**From gitlab-collaboration → Other Skills:**
- Provides review feedback for development iteration and code improvement
- Supplies comment analysis for issue investigation and root cause analysis
- Delivers approval status for merge readiness and deployment coordination
- Offers team collaboration insights for process improvement and training

**To gitlab-collaboration ← Other Skills:**
- Receives MR creation notifications for review assignment and scheduling
- Gets code changes for review impact analysis and comment contextualization
- Obtains issue resolution feedback for discussion closure and validation
- Accepts team feedback for review process optimization and improvement

### Integration Architecture

**FUB Review Ecosystem Integration:**
```markdown
gitlab-collaboration serves as the review coordination hub:

1. **Quality Assurance Gateway**: Ensures code quality through systematic review processes
2. **Knowledge Sharing Platform**: Facilitates team learning and best practice dissemination
3. **Communication Coordination**: Manages cross-team collaboration and stakeholder engagement
4. **Process Optimization**: Provides insights for review process improvement and efficiency
5. **Compliance Validation**: Ensures review standards meet regulatory and security requirements
```

**Review State Management:**
```markdown
Review Lifecycle Integration:
- **Review Request**: Notification and reviewer assignment coordination
- **Active Review**: Comment triage, discussion management, feedback coordination
- **Resolution Phase**: Fix tracking, verification, and progress monitoring
- **Approval Decision**: Final validation and merge readiness assessment
- **Post-Review**: Learning capture, process feedback, and improvement identification
```

This focused skill provides comprehensive collaboration and review management capabilities while maintaining seamless integration with the broader FUB development workflow and quality assurance processes.