## Planning Reference Guide and Quick Commands

### Quick Reference Commands

#### Essential Planning Commands
```bash
# Start new planning session
/planning-workflow --operation="create-plan" --task_context="feature-implementation" --scope_estimate="medium"

# Check current progress
/planning-workflow --operation="check-progress"

# Validate task completion
/planning-workflow --operation="validate-completion"

# Review session effectiveness
/planning-workflow --operation="review-session"
```

#### Task Management Quick Commands
```bash
# Create new task
TaskCreate --subject="[Action] [Component]" --description="[Details and success criteria]" --activeForm="[Present continuous]"

# Update task status
TaskUpdate --taskId="task-123" --status="in_progress"

# Add task dependencies
TaskUpdate --taskId="task-456" --addBlockedBy=["task-123"]

# List all tasks
TaskList

# Get task details
TaskGet --taskId="task-123"
```

### Scope Management Guidelines

| Scope Level | Task Count | Dependency Chains | External Integrations | Session Duration |
|-------------|------------|------------------|---------------------|------------------|
| **Small** | 1-2 tasks | 1 chain | 0-1 integration | <30 minutes |
| **Medium** | 3-4 tasks | 2 chains | 1 integration | 30-120 minutes |
| **Large** | 4-5 tasks | 3 chains | 2 integrations | >2 hours |
| **Critical** | Emergency scope | Minimal dependencies | Essential only | Variable |

#### Scope Validation Protocol
```bash
echo "=== Scope Validation ==="
echo "Major Tasks: [Count] / 5 maximum"
echo "Dependency Chains: [Count] / 3 maximum"
echo "External Integrations: [Count] / 2 maximum"

# If scope exceeds limits:
# 1. Break down into smaller tasks
# 2. Create separate planning sessions
# 3. Defer non-critical tasks
# 4. Document scope decisions
```

### Task Creation Patterns

#### Standard Task Template
```bash
TaskCreate --subject="[Action] [Component/Feature]" \
           --description="[Detailed requirements]. Success Criteria: [Specific validation criteria]" \
           --activeForm="[Present continuous description]"
```

#### Common FUB Task Patterns
- **Feature Implementation**: "Implement user authentication with JWT tokens"
- **Bug Investigation**: "Investigate and resolve login timeout issues"
- **Database Migration**: "Add user preferences table with indexes"
- **API Integration**: "Integrate with Zillow OAuth endpoints"
- **Testing Setup**: "Create comprehensive test suite for payment flow"

### Progress Validation Checklists

#### Task Progress Checklist
For each in-progress task:
- [ ] Task progressing according to plan?
- [ ] Acceptance criteria still accurate?
- [ ] Dependencies resolved as expected?
- [ ] Quality standards being maintained?
- [ ] Timeline realistic based on current progress?

#### Completion Validation Checklist
**MANDATORY CHECKS** before marking tasks complete:
- [ ] **Functional Testing**: All acceptance criteria demonstrated
- [ ] **Code Quality**: Standards compliance, review completion
- [ ] **Integration Testing**: Compatibility with existing systems verified
- [ ] **Documentation**: Changes documented, knowledge transferred
- [ ] **Security Review**: Security implications assessed and addressed
- [ ] **Performance Validation**: Performance impact measured and acceptable

### Emergency Protocols

#### Production Incident Response
**STREAMLINED EMERGENCY PLANNING**: Modified protocol for critical production issues:

```bash
# Emergency planning protocol
TaskCreate --subject="Resolve production incident" \
           --description="Emergency fix for production issue. Full planning review required post-incident. Success: Production service restored, incident documented." \
           --activeForm="Resolving production incident"

# [Execute emergency fix following safety protocols]

# Post-incident planning review
/planning-workflow --operation="review-session" --task_context="maintenance"
```

#### Security Issue Response
**ENHANCED SECURITY PROTOCOL**: Security issues require additional validation:
- Security impact assessment in task descriptions
- Security team review in validation criteria
- Security testing in completion verification
- Post-fix security monitoring in follow-up tasks

#### Critical System Failure
```bash
# Immediate response tasks
TaskCreate --subject="Execute system recovery procedure" \
           --description="Immediate system recovery with impact assessment. Success: System operational, impact documented." \
           --activeForm="Executing system recovery"

TaskCreate --subject="Investigate root cause of system failure" \
           --description="Comprehensive investigation to prevent recurrence. Success: Root cause identified, prevention measures implemented." \
           --activeForm="Investigating system failure"
```

### Quality Assurance Integration

#### Quality Standards Compliance
**STANDARDS ALIGNMENT**: Planning validation criteria must align with FUB quality standards:
- Test coverage requirements (70% backend, 75% frontend)
- Security review protocols for security-sensitive changes
- Performance validation for database and API changes
- Documentation standards for feature additions
- Evidence-based completion claims per accuracy standards
- Task lifecycle validation per delivery tracking requirements

#### Database Operations Integration
**ENHANCED SAFETY**: Database operations require additional planning rigor:
```bash
# Database change planning with enhanced validation
/planning-workflow --operation="create-plan" --task_context="integration" --scope_estimate="large"
# [Enhanced planning for database operations]
/database-operations --operation="schema-change" --environment="development"
# [Database operations with mandatory approval]
/planning-workflow --operation="validate-completion"
```

### Task Completion Evidence Standards

#### Implementation Evidence Template
```markdown
## Implementation Evidence
- **Code Changes**: [List files modified with line ranges or commit hashes]
- **Repository**: [Git repository and branch information]
- **Integration Points**: [Systems, APIs, databases affected]
- **Deployment**: [Where changes are deployed and verified]
```

#### Validation Evidence Template
```markdown
## Validation Evidence
- **Acceptance Criteria Met**: [Checklist of requirements with verification method]
  - Criteria 1: [How verified, evidence provided]
  - Criteria 2: [Testing approach used, results obtained]
  - Criteria 3: [Validation method, proof of completion]
- **Quality Validation**: [Test coverage, performance metrics, security review results]
- **Integration Validation**: [Cross-system testing results, compatibility verification]
```

#### Business Impact Evidence Template
```markdown
## Business Impact Evidence
- **User Impact**: [Effect on end users with measurements where possible]
- **System Impact**: [Performance changes, reliability improvements, efficiency gains]
- **Process Impact**: [Workflow improvements, automation benefits, time savings]
- **Risk Mitigation**: [Security improvements, compliance achievements, stability gains]
```

### Tool Integration Reference

#### MCP Integration Commands
**COMPREHENSIVE TOOL SUPPORT**: Leverage FUB's MCP tools for enhanced planning:

```bash
# Jira Integration
/jira-management --operation="create-issue" --project="FUB" --summary="[Task Summary]" --description="[Task Details]"

# Confluence Integration
/confluence-management --operation="create" --title="Planning Session Results" --content="[Planning Outcomes]"

# GitLab Integration
/gitlab-pipeline-monitoring --operation="status" --project="fub/main" --branch="feature-branch"

# Datadog Integration
/datadog-management --operation="dashboard-creation" --service="[Service Name]"
```

#### Helper Script Integration
**AUTOMATION SUPPORT**: Integrate with FUB helper scripts for execution efficiency:
- Include script execution in task validation criteria
- Plan for script integration testing
- Document script dependencies in task descriptions
- Validate script results in completion verification

### Troubleshooting Guide

#### Common Planning Issues

| Issue | Symptoms | Solution |
|-------|----------|----------|
| **Scope Creep** | Tasks expanding beyond original requirements | Apply scope validation protocol, create new tasks for additional work |
| **Blocked Dependencies** | Tasks waiting on unresolved prerequisites | Review dependency chain, escalate blockers, consider alternative approaches |
| **Incomplete Validation** | Tasks marked complete without evidence | Apply evidence-based completion framework, require validation evidence |
| **Resource Conflicts** | Multiple tasks competing for same resources | Resource allocation optimization, task prioritization, timeline adjustment |
| **Quality Gate Failures** | Tasks failing validation criteria | Quality standards review, additional testing, process improvement |

#### Task Management Troubleshooting

**Task Creation Issues:**
```bash
# Issue: Task descriptions too vague
# Solution: Apply task creation template with specific criteria
TaskCreate --subject="Specific actionable task title" \
           --description="Detailed requirements with measurable success criteria and validation methods" \
           --activeForm="Present continuous form for progress tracking"

# Issue: Missing dependencies
# Solution: Systematic dependency analysis
TaskUpdate --taskId="dependent-task" --addBlockedBy=["prerequisite-task-1", "prerequisite-task-2"]
```

**Progress Monitoring Issues:**
```bash
# Issue: Tasks stuck in progress
# Solution: Progress assessment and blocker resolution
echo "=== Blocker Resolution ==="
echo "1. Identify specific blocking factors"
echo "2. Determine resolution approach"
echo "3. Escalate if necessary"
echo "4. Update task status and dependencies"
```

#### Planning Session Recovery

**Session Scope Recovery:**
```bash
recover_session_scope() {
    local session_id="$1"

    echo "=== Session Scope Recovery: $session_id ==="

    # Assess current scope
    TaskList | grep "in_progress\|pending" | wc -l

    # Identify scope expansion factors
    echo "Scope Analysis:"
    echo "□ Original scope vs. current scope comparison"
    echo "□ New requirement identification"
    echo "□ Complexity assessment updates"
    echo "□ Resource availability changes"

    # Recovery actions
    echo "Recovery Actions:"
    echo "1. Defer non-critical tasks to future sessions"
    echo "2. Break down oversized tasks into manageable chunks"
    echo "3. Reassess dependencies and optimize critical path"
    echo "4. Document scope changes and rationale"
}
```

**Quality Recovery Protocol:**
```bash
recover_quality_standards() {
    local failed_task_id="$1"

    echo "=== Quality Recovery: $failed_task_id ==="

    # Quality issue assessment
    echo "Quality Issue Analysis:"
    echo "□ Specific quality standard violations identified"
    echo "□ Root cause of quality failure determined"
    echo "□ Impact assessment completed"
    echo "□ Remediation approach planned"

    # Recovery task creation
    TaskCreate --subject="Remediate quality issues in $failed_task_id" \
               --description="Address quality standard violations and strengthen validation process. Success: Quality standards met, process improved." \
               --activeForm="Remediating quality issues"
}
```

### Performance Optimization

#### Planning Session Efficiency
- **Preparation**: Review requirements and context before planning sessions
- **Focus**: Maintain scope discipline throughout planning process
- **Validation**: Apply validation criteria consistently across all tasks
- **Documentation**: Record decisions and rationale for future reference
- **Improvement**: Regular session review and process optimization

#### Task Execution Efficiency
- **Clarity**: Ensure task descriptions provide clear guidance for execution
- **Dependencies**: Map dependencies accurately to prevent blocking
- **Resources**: Consider resource availability in task planning
- **Monitoring**: Regular progress monitoring and adjustment
- **Quality**: Build quality validation into task execution workflow

This comprehensive reference guide provides quick access to essential planning commands, protocols, and troubleshooting procedures for efficient FUB development operations.