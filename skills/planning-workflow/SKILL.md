---
name: planning-workflow
description: Comprehensive project planning and task management workflow with proactive scope control, dependency mapping, and accountability tracking for FUB development operations
---

## Overview

Comprehensive project planning and task management workflow with proactive scope control, dependency mapping, and accountability tracking for FUB development operations. Implements systematic task tracking with scope limits, validation criteria, and follow-up protocols.

📋 **Planning Templates**: [templates/planning-templates.md](templates/planning-templates.md)
🚀 **Advanced Patterns**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
🔗 **Integration Workflows**: [workflows/integration-workflows.md](workflows/integration-workflows.md)
📖 **Reference Guide**: [reference/planning-reference.md](reference/planning-reference.md)

## Core Workflow

### Essential Operations (Most Common - 90% of Usage)

**1. Create Comprehensive Plan (`create-plan`)**
```bash
# Start new planning session
planning-workflow --operation="create-plan" --task_context="feature-implementation" --scope_estimate="medium"

# Emergency planning with minimal ceremony
planning-workflow --operation="create-plan" --task_context="maintenance" --scope_estimate="critical"
```

**2. Progress Monitoring (`check-progress`)**
```bash
# Monitor current progress
planning-workflow --operation="check-progress"

# Review task status and blockers
TaskList
```

**3. Completion Validation (`validate-completion`)**
```bash
# Validate task completion with evidence
planning-workflow --operation="validate-completion"

# Verify quality gates passed
TaskGet --taskId="completed-task-id"
```

**4. Session Review (`review-session`)**
```bash
# Assess planning effectiveness and create follow-ups
planning-workflow --operation="review-session" --task_context="feature-implementation"
```

### Task Creation Protocol

#### Standard Task Creation
```bash
# Basic task creation template
TaskCreate --subject="[Action] [Component/Feature]" \
           --description="[Detailed requirements]. Success Criteria: [Specific validation criteria]" \
           --activeForm="[Present continuous description]"
```

#### Dependency Setup
```bash
# Establish task blocking relationships
TaskUpdate --taskId="implementation-task" --addBlockedBy=["analysis-task"]
TaskUpdate --taskId="testing-task" --addBlockedBy=["implementation-task"]
TaskUpdate --taskId="integration-task" --addBlockedBy=["implementation-task", "testing-task"]
```

#### Common FUB Task Patterns
- **Feature Implementation**: "Implement user authentication with JWT tokens"
- **Bug Investigation**: "Investigate and resolve login timeout issues"
- **Database Migration**: "Add user preferences table with indexes"
- **API Integration**: "Integrate with Zillow OAuth endpoints"
- **Testing Setup**: "Create comprehensive test suite for payment flow"

→ **Complete task templates and patterns**: [templates/planning-templates.md](templates/planning-templates.md)

### Scope Management

#### Scope Limits (MANDATORY)
- Maximum 5 major implementation tasks
- Maximum 3 separate dependency chains
- Maximum 2 external system integrations

#### Scope Assessment Protocol
```bash
echo "=== Scope Validation ==="
echo "Major Tasks: [Count] / 5 maximum"
echo "Dependency Chains: [Count] / 3 maximum"
echo "External Integrations: [Count] / 2 maximum"
```

#### Scope Management Guidelines

| Scope Level | Task Count | Dependency Chains | External Integrations | Session Duration |
|-------------|------------|------------------|---------------------|------------------|
| **Small** | 1-2 tasks | 1 chain | 0-1 integration | <30 minutes |
| **Medium** | 3-4 tasks | 2 chains | 1 integration | 30-120 minutes |
| **Large** | 4-5 tasks | 3 chains | 2 integrations | >2 hours |
| **Critical** | Emergency scope | Minimal dependencies | Essential only | Variable |

### Validation Standards

#### Quality Gate Verification (MANDATORY)
Before marking tasks complete:
- [ ] **Functional Testing**: All acceptance criteria demonstrated
- [ ] **Code Quality**: Standards compliance, review completion
- [ ] **Integration Testing**: Compatibility verified
- [ ] **Documentation**: Changes documented, knowledge transferred
- [ ] **Security Review**: Security implications assessed
- [ ] **Performance Validation**: Performance impact acceptable

#### Task Completion Evidence
```bash
validate_task_completion() {
    local task_id="$1"

    echo "=== Task Completion Validation ==="
    echo "Required Evidence:"
    echo "□ Implementation evidence (code changes, commits)"
    echo "□ Testing evidence (test results, coverage reports)"
    echo "□ Performance evidence (metrics, benchmarks)"
    echo "□ Integration evidence (system verification)"
    echo "□ Stakeholder evidence (approvals where required)"
}
```

## Integration Patterns

### Cross-Skill Workflows

**Planning → Development → Review:**
```bash
# Complete feature development lifecycle
planning-workflow --operation="create-plan" --task_context="feature-implementation"
code-development --task="Implement planned feature" --scope="planned-feature"
planning-workflow --operation="validate-completion"
```

**Emergency Incident Response:**
```bash
# Production incident coordination
planning-workflow --operation="create-plan" --task_context="maintenance" --scope_estimate="critical"
support-investigation --issue="Production failures" --environment="production"
database-operations --operation="health-check" --environment="production"
planning-workflow --operation="review-session" --task_context="maintenance"
```

### Common Integration Workflows

| Skill | Integration | Output |
|-------|-------------|--------|
| `code-development` | Execution partnership | Task structure → Implementation → Validation |
| `database-operations` | Safety coordination | Planning → Database changes → Monitoring |
| `support-investigation` | Issue resolution | Incident planning → Investigation → Follow-up |
| `datadog-management` | Monitoring integration | Performance planning → Monitoring setup |
| `jira-management` | Issue tracking | Task planning → Jira sync → Progress tracking |

→ **Complete integration workflows**: [workflows/integration-workflows.md](workflows/integration-workflows.md)

## Advanced Patterns

### Complex Project Management
- Multi-phase feature development with phase gates
- Cross-system integration with rollback strategies
- Technical debt remediation with impact analysis
- Resource-constrained planning with optimization

### Task Orchestration
- Parallel execution planning with synchronization points
- Dynamic scope adjustment with impact assessment
- Risk-based planning with contingency procedures
- High-velocity development with streamlined validation

### Enterprise Coordination
- Multi-team planning coordination with shared dependencies
- Compliance-driven planning with audit trails
- Emergency response planning with escalation procedures
- Performance optimization with resource allocation

→ **Advanced implementation patterns**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)

## Emergency Protocols

### Production Incident Response
```bash
# Emergency task creation
TaskCreate --subject="Resolve production incident" \
           --description="Emergency fix with post-incident review required. Success: Service restored, incident documented." \
           --activeForm="Resolving production incident"
```

### Security Issue Response
Enhanced protocol requiring:
- Security impact assessment in task descriptions
- Security team review in validation criteria
- Security testing in completion verification
- Post-fix security monitoring in follow-up tasks

→ **Complete emergency protocols**: [reference/planning-reference.md](reference/planning-reference.md)

## Quick Reference

### Essential Commands
```bash
# Create plan
planning-workflow --operation="create-plan" --task_context="feature-implementation" --scope_estimate="medium"

# Check progress
planning-workflow --operation="check-progress"

# Validate completion
planning-workflow --operation="validate-completion"

# Review session
planning-workflow --operation="review-session"
```

### Task Management
```bash
# Create task
TaskCreate --subject="Task title" --description="Details and success criteria" --activeForm="Present continuous"

# Update status
TaskUpdate --taskId="task-123" --status="in_progress"

# Add dependencies
TaskUpdate --taskId="task-456" --addBlockedBy=["task-123"]

# List tasks
TaskList

# Get details
TaskGet --taskId="task-123"
```

→ **Complete command reference**: [reference/planning-reference.md](reference/planning-reference.md)

## Preconditions

- Must have access to TaskCreate, TaskUpdate, TaskList, and TaskGet tools for task management
- Must have clear understanding of project requirements and scope
- Must have access to relevant development environments and systems
- Must coordinate with team members and stakeholders for task validation
- Must follow FUB quality standards and validation protocols

## Refusal Conditions

The skill must refuse if:
- Task management tools are not available or accessible
- Project requirements are unclear or incomplete
- Scope exceeds maximum limits without proper breakdown
- Validation criteria cannot be defined or measured
- Emergency protocols cannot be followed safely
- Quality standards cannot be met or verified

When refusing, explain which requirement prevents execution and provide specific steps to resolve the issue, including tool setup requirements, requirement clarification needs, scope reduction strategies, or quality standard alignment procedures.

## Supporting Infrastructure

→ **Advanced patterns and complex orchestration**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
→ **Comprehensive templates and task patterns**: [templates/planning-templates.md](templates/planning-templates.md)

This skill provides systematic development orchestration while maintaining flexibility for FUB's diverse development scenarios and ensuring accountability through comprehensive task tracking and validation protocols.