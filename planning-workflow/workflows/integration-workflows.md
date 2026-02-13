## Cross-Skill Integration Workflows and Coordination Patterns

### Cross-Skill Workflow Coordination

#### Primary Integration Relationships

| Related Skill | Integration Type | Common Workflows |
|---------------|------------------|------------------|
| `code-development` | **Execution Partnership** | Plan creation → Implementation → Validation → Review |
| `database-operations` | **Safety Coordination** | Planning → Database changes → Validation → Monitoring |
| `support-investigation` | **Issue Resolution** | Incident planning → Investigation → Resolution → Follow-up |
| `datadog-management` | **Monitoring Integration** | Performance planning → Implementation → Monitoring setup |
| `jira-management` | **Issue Tracking** | Task planning → Jira synchronization → Progress tracking |
| `confluence-management` | **Documentation** | Planning decisions → Knowledge capture → Documentation updates |

#### Multi-Skill Operation Examples

**Complete Feature Development Lifecycle:**
```bash
# 1. Comprehensive planning with task creation
/planning-workflow --operation="create-plan" --task_context="feature-implementation" --scope_estimate="large"

# 2. Execute development with task tracking
/code-development --task="Implement user authentication system" --scope="feature-complete"

# 3. Database integration with safety protocols
/database-operations --operation="schema-change" --environment="development"

# 4. Performance monitoring setup
/datadog-management --operation="dashboard-creation" --service="authentication"

# 5. Completion validation and review
/planning-workflow --operation="validate-completion"
```

**Production Incident Response Coordination:**
```bash
# 1. Emergency planning with minimal ceremony
/planning-workflow --operation="create-plan" --task_context="maintenance" --scope_estimate="critical"

# 2. Issue investigation and diagnosis
/support-investigation --issue="Production authentication failures" --environment="production"

# 3. Database safety validation
/database-operations --operation="health-check" --environment="production"

# 4. Monitoring analysis
/datadog-management --analysis_type="incident_investigation" --service="auth-service"

# 5. Post-incident planning review
/planning-workflow --operation="review-session" --task_context="maintenance"
```

**Integration Testing Workflow:**
```bash
# 1. Integration planning with dependency mapping
/planning-workflow --operation="create-plan" --task_context="integration" --scope_estimate="medium"

# 2. API testing and validation
/code-development --task="Test API integration endpoints" --validation_type="integration"

# 3. Database migration coordination
/database-operations --operation="migration-test" --environment="staging"

# 4. End-to-end monitoring setup
/datadog-management --operation="integration-monitoring" --systems="auth,api,database"

# 5. Documentation and knowledge transfer
/confluence-management --operation="create" --title="Integration Guide" --content_type="technical"
```

### Workflow Handoff Patterns

#### From planning-workflow → Other Skills

**To code-development:**
- **Structured Task Lists**: Provides detailed task breakdown with acceptance criteria
- **Validation Requirements**: Supplies completion criteria and quality standards
- **Dependency Mapping**: Delivers prerequisite information and blocking relationships
- **Scope Boundaries**: Defines work limits and constraints for implementation

**To database-operations:**
- **Safety Protocols**: Provides rollback plans and validation requirements
- **Change Planning**: Supplies impact analysis and coordination requirements
- **Validation Criteria**: Defines success metrics and testing requirements
- **Risk Assessment**: Delivers safety considerations and mitigation strategies

**To support-investigation:**
- **Incident Structure**: Provides systematic investigation framework
- **Follow-up Planning**: Supplies post-resolution improvement tasks
- **Validation Framework**: Defines resolution verification criteria
- **Learning Integration**: Delivers process improvement requirements

**To datadog-management:**
- **Monitoring Requirements**: Provides performance and health monitoring specifications
- **Alert Configuration**: Supplies threshold and notification requirements
- **Dashboard Planning**: Defines visualization and tracking needs
- **Integration Context**: Delivers system relationship and dependency information

#### To planning-workflow ← Other Skills

**From code-development:**
- **Completion Notifications**: Receives task completion status with evidence
- **Scope Change Requests**: Gets requirement modifications and impact assessments
- **Implementation Feedback**: Obtains technical insights and lessons learned
- **Quality Validation**: Receives code review and testing results

**From database-operations:**
- **Change Completion**: Gets database modification confirmation and validation
- **Performance Impact**: Receives performance metrics and optimization recommendations
- **Safety Validation**: Obtains rollback verification and safety confirmations
- **Monitoring Data**: Gets database health and performance information

**From support-investigation:**
- **Issue Resolution**: Receives incident resolution status and root cause analysis
- **Process Improvement**: Gets recommendations for planning and execution improvements
- **Risk Identification**: Obtains new risk factors and mitigation requirements
- **Knowledge Updates**: Receives lessons learned and best practice updates

**From datadog-management:**
- **Performance Metrics**: Gets system performance data and trends
- **Alert Notifications**: Receives health and performance alerts
- **Capacity Planning**: Obtains resource utilization and scaling recommendations
- **Incident Correlation**: Gets correlation data for issue investigation

### Bidirectional Integration Examples

#### planning-workflow ↔ code-development

**Outbound Integration (planning → code):**
```bash
# Planning provides structured implementation guidance
plan_code_development() {
    local feature_name="$1"

    # Create comprehensive development tasks
    TaskCreate --subject="Implement $feature_name core functionality" \
               --description="Build primary feature components with comprehensive test coverage and documentation. Success: Core functionality complete, tests passing, code reviewed." \
               --activeForm="Implementing $feature_name core functionality"

    TaskCreate --subject="Integrate $feature_name with existing systems" \
               --description="Connect new feature with existing codebase, maintain compatibility. Success: Integration complete, regression tests passing." \
               --activeForm="Integrating $feature_name with existing systems"

    # Provide validation framework
    echo "Development Validation Criteria:"
    echo "□ Code quality standards met (linting, formatting, complexity)"
    echo "□ Test coverage requirements achieved (70% backend, 75% frontend)"
    echo "□ Security review completed for security-sensitive changes"
    echo "□ Performance impact assessed and optimized"
    echo "□ Documentation updated and reviewed"
}
```

**Inbound Integration (code → planning):**
```bash
# Code development provides completion feedback
handle_development_completion() {
    local task_id="$1"
    local completion_evidence="$2"

    # Update task status with evidence
    TaskUpdate --taskId="$task_id" --status="completed" \
               --metadata="{\"completion_evidence\":\"$completion_evidence\",\"validation_method\":\"code_review\"}"

    # Generate follow-up tasks based on development insights
    TaskCreate --subject="Review development lessons learned" \
               --description="Analyze development process and identify improvements for future planning. Success: Lessons documented, process updated." \
               --activeForm="Reviewing development lessons"

    # Update planning effectiveness metrics
    echo "Development Completion Metrics:"
    echo "- Task accuracy: Was planning accurate for actual work?"
    echo "- Scope management: Did scope remain controlled throughout development?"
    echo "- Quality achievement: Were quality standards met efficiently?"
}
```

#### planning-workflow ↔ database-operations

**Outbound Integration (planning → database):**
```bash
# Planning provides database change coordination
plan_database_operations() {
    local change_description="$1"
    local risk_level="$2"

    # Create database planning tasks
    TaskCreate --subject="Plan database schema changes" \
               --description="Design database modifications with migration strategy and rollback plan. Success: Schema changes planned, migration scripts ready." \
               --activeForm="Planning database schema changes"

    TaskCreate --subject="Validate database change safety" \
               --description="Test database changes in development, verify rollback procedures. Success: Changes tested, rollback validated." \
               --activeForm="Validating database change safety"

    # Provide safety protocols
    echo "Database Change Safety Protocols:"
    echo "□ Backup verification completed before changes"
    echo "□ Rollback procedures tested and documented"
    echo "□ Performance impact assessed and acceptable"
    echo "□ Change approval obtained from database team"
    echo "□ Monitoring configured for post-change validation"
}
```

**Inbound Integration (database → planning):**
```bash
# Database operations provide completion and monitoring data
handle_database_completion() {
    local change_id="$1"
    local performance_impact="$2"

    # Update planning with database completion
    TaskUpdate --taskId="database-change-$change_id" --status="completed" \
               --metadata="{\"performance_impact\":\"$performance_impact\",\"rollback_verified\":true}"

    # Generate monitoring and follow-up tasks
    TaskCreate --subject="Monitor database change impact" \
               --description="Track database performance and stability post-change. Success: Monitoring active, performance stable." \
               --activeForm="Monitoring database change impact"

    # Update database change planning based on results
    echo "Database Change Results:"
    echo "- Performance impact: $performance_impact"
    echo "- Planning accuracy: How did actual vs planned impact compare?"
    echo "- Process effectiveness: Were safety protocols sufficient?"
}
```

### Integration Architecture

#### FUB Development Lifecycle Orchestration

**Project Initiation Flow:**
```bash
initiate_development_project() {
    local project_name="$1"
    local project_type="$2"

    echo "=== Project Initiation: $project_name ($project_type) ==="

    # 1. Initial Planning Phase
    /planning-workflow --operation="create-plan" --task_context="$project_type" --scope_estimate="medium"

    # 2. Requirements Documentation
    /confluence-management --operation="create" --title="$project_name Requirements" --template="requirements"

    # 3. Technical Analysis
    /code-development --task="Analyze technical requirements for $project_name" --analysis_type="requirements"

    # 4. Resource Planning
    /datadog-management --operation="capacity-planning" --service="$project_name"

    # 5. Issue Tracking Setup
    /jira-management --operation="create-epic" --title="$project_name" --description="Epic for $project_name development"

    echo "Project initiation complete. Ready for execution phase."
}
```

**Execution Coordination Flow:**
```bash
coordinate_project_execution() {
    local project_name="$1"

    echo "=== Execution Coordination: $project_name ==="

    # Monitor progress across all integrated skills
    TaskList | while read task; do
        local task_status=$(echo "$task" | jq -r '.status')
        local task_owner=$(echo "$task" | jq -r '.owner')

        case "$task_status" in
            "in_progress")
                echo "Monitoring task: $task"
                /planning-workflow --operation="check-progress"
                ;;
            "blocked")
                echo "Resolving blocked task: $task"
                resolve_task_blockers "$task"
                ;;
            "completed")
                echo "Validating completed task: $task"
                /planning-workflow --operation="validate-completion"
                ;;
        esac
    done
}
```

**Quality Assurance Integration:**
```bash
integrate_quality_assurance() {
    local project_name="$1"

    echo "=== Quality Assurance Integration: $project_name ==="

    # Code Quality Validation
    /code-development --task="Execute comprehensive code quality review" --quality_gates="all"

    # Database Quality Validation
    /database-operations --operation="performance-validation" --environment="staging"

    # System Integration Quality
    /datadog-management --operation="integration-validation" --system="$project_name"

    # Documentation Quality
    /confluence-management --operation="quality-review" --content="$project_name"

    # Planning Effectiveness Review
    /planning-workflow --operation="review-session" --task_context="quality-assurance"
}
```

#### Accountability Framework Integration

**Task Lifecycle Tracking:**
```bash
track_task_lifecycle() {
    local task_id="$1"

    echo "=== Task Lifecycle Tracking: $task_id ==="

    # Creation Phase
    echo "□ Task created with clear acceptance criteria"
    echo "□ Dependencies identified and mapped"
    echo "□ Validation methods specified"
    echo "□ Success metrics defined"

    # Execution Phase
    echo "□ Progress monitored and reported"
    echo "□ Blockers identified and resolved"
    echo "□ Quality standards maintained"
    echo "□ Scope changes managed appropriately"

    # Completion Phase
    echo "□ Acceptance criteria validated with evidence"
    echo "□ Quality gates passed successfully"
    echo "□ Integration testing completed"
    echo "□ Documentation updated appropriately"

    # Follow-up Phase
    echo "□ Lessons learned documented"
    echo "□ Process improvements identified"
    echo "□ Knowledge transferred to team"
    echo "□ Monitoring and maintenance planned"
}
```

**Evidence-Based Completion Framework:**
```bash
validate_evidence_based_completion() {
    local task_id="$1"

    echo "=== Evidence-Based Completion Validation: $task_id ==="

    # Technical Evidence
    echo "Technical Evidence Required:"
    echo "□ Code changes documented with file paths and line ranges"
    echo "□ Test results provided with coverage metrics"
    echo "□ Performance benchmarks measured and documented"
    echo "□ Security review completed with findings addressed"

    # Functional Evidence
    echo "Functional Evidence Required:"
    echo "□ Acceptance criteria demonstrated with screenshots/videos"
    echo "□ User acceptance testing completed successfully"
    echo "□ Integration testing results documented"
    echo "□ Error handling validated and tested"

    # Process Evidence
    echo "Process Evidence Required:"
    echo "□ Code review completed with approvals"
    echo "□ Documentation updated and reviewed"
    echo "□ Deployment procedures tested successfully"
    echo "□ Rollback procedures validated"

    # Business Evidence
    echo "Business Evidence Required:"
    echo "□ Business requirements satisfied and validated"
    echo "□ Stakeholder approval obtained where required"
    echo "□ Success metrics achieved and measured"
    echo "□ Risk assessment updated with mitigation status"
}
```

This comprehensive integration framework ensures planning-workflow coordinates seamlessly with all related skills while maintaining systematic development orchestration, quality assurance, and accountability tracking throughout the FUB development lifecycle.