## Planning Templates and Task Creation Patterns

### Task Creation Templates

#### Standard Task Template
```bash
TaskCreate --subject="[Action] [Component/Feature]" \
           --description="[Detailed requirements]. Success Criteria: [Specific validation criteria]" \
           --activeForm="[Present continuous description]"
```

#### Architecture Analysis Task Template
```bash
TaskCreate --subject="Analyze existing system architecture" \
           --description="Review current implementation patterns, identify extension points, and document integration approaches. Success Criteria: Clear architectural understanding, documented extension points, identified potential conflicts." \
           --activeForm="Analyzing system architecture"
```

#### Implementation Planning Task Template
```bash
TaskCreate --subject="Design implementation approach" \
           --description="Create detailed implementation plan with component breakdown, API design, and integration strategy. Success Criteria: Comprehensive design document, API specifications, integration checklist." \
           --activeForm="Designing implementation approach"
```

#### Database Change Task Template
```bash
TaskCreate --subject="Design database schema changes" \
           --description="Plan database modifications with migration strategy, rollback plan, and performance impact analysis. Success Criteria: Migration scripts ready, rollback tested, performance impact assessed." \
           --activeForm="Designing database schema changes"
```

#### Testing Implementation Task Template
```bash
TaskCreate --subject="Implement comprehensive test suite" \
           --description="Create test coverage for new functionality including unit tests, integration tests, and end-to-end validation. Success Criteria: 75% test coverage, all tests passing, edge cases covered." \
           --activeForm="Implementing test suite"
```

#### Security Review Task Template
```bash
TaskCreate --subject="Conduct security impact assessment" \
           --description="Analyze security implications of changes, perform threat modeling, and implement security controls. Success Criteria: Security review completed, vulnerabilities addressed, controls implemented." \
           --activeForm="Conducting security assessment"
```

### Common FUB Task Patterns

#### Feature Implementation Tasks
```bash
# User Authentication Feature
TaskCreate --subject="Implement JWT-based user authentication" \
           --description="Build secure authentication system with token generation, validation, and refresh capabilities. Success Criteria: Secure login flow, token management, session handling, audit logging." \
           --activeForm="Implementing user authentication"

# API Integration
TaskCreate --subject="Integrate with Zillow API endpoints" \
           --description="Implement OAuth integration with Zillow API, handle rate limiting, and manage data synchronization. Success Criteria: OAuth flow working, API calls authenticated, data sync operational." \
           --activeForm="Integrating Zillow API"

# Frontend Component
TaskCreate --subject="Build responsive property search interface" \
           --description="Create React component for property search with filtering, sorting, and pagination. Success Criteria: Component responsive, search functional, performance optimized." \
           --activeForm="Building search interface"
```

#### Bug Investigation Tasks
```bash
# Performance Issue
TaskCreate --subject="Investigate slow database query performance" \
           --description="Analyze query execution plans, identify bottlenecks, and implement optimization strategies. Success Criteria: Query performance improved by 50%, monitoring in place, documentation updated." \
           --activeForm="Investigating query performance"

# Integration Failure
TaskCreate --subject="Resolve third-party API timeout issues" \
           --description="Debug API connection failures, implement retry logic, and add monitoring. Success Criteria: Timeouts resolved, retry logic implemented, failure monitoring active." \
           --activeForm="Resolving API timeouts"

# User Experience Bug
TaskCreate --subject="Fix mobile responsive layout issues" \
           --description="Identify and resolve layout problems on mobile devices, test across different screen sizes. Success Criteria: Layout working on all target devices, responsive tests passing." \
           --activeForm="Fixing mobile layout"
```

#### Maintenance and Refactoring Tasks
```bash
# Code Refactoring
TaskCreate --subject="Refactor legacy authentication module" \
           --description="Modernize authentication code, improve maintainability, and enhance security. Success Criteria: Code refactored, tests updated, security enhanced, documentation current." \
           --activeForm="Refactoring authentication module"

# Technical Debt
TaskCreate --subject="Upgrade deprecated dependencies" \
           --description="Update outdated libraries, resolve security vulnerabilities, and test compatibility. Success Criteria: Dependencies updated, security issues resolved, tests passing." \
           --activeForm="Upgrading dependencies"

# Infrastructure Improvement
TaskCreate --subject="Implement database connection pooling" \
           --description="Add connection pooling to improve database performance and resource utilization. Success Criteria: Pooling implemented, performance improved, monitoring configured." \
           --activeForm="Implementing connection pooling"
```

### Task Dependency Setup Patterns

#### Sequential Dependency Chain
```bash
# Analysis → Design → Implementation → Testing
TaskUpdate --taskId="analysis-task" --status="pending"
TaskUpdate --taskId="design-task" --addBlockedBy=["analysis-task"]
TaskUpdate --taskId="implementation-task" --addBlockedBy=["design-task"]
TaskUpdate --taskId="testing-task" --addBlockedBy=["implementation-task"]
```

#### Parallel with Convergence
```bash
# Frontend and Backend development converging to integration
TaskUpdate --taskId="frontend-task" --status="pending"
TaskUpdate --taskId="backend-task" --status="pending"
TaskUpdate --taskId="integration-task" --addBlockedBy=["frontend-task", "backend-task"]
TaskUpdate --taskId="end-to-end-testing" --addBlockedBy=["integration-task"]
```

#### Complex Multi-Dependency
```bash
# Database → Backend API, Frontend → Integration → Testing
TaskUpdate --taskId="database-schema" --status="pending"
TaskUpdate --taskId="backend-api" --addBlockedBy=["database-schema"]
TaskUpdate --taskId="frontend-components" --status="pending"
TaskUpdate --taskId="api-integration" --addBlockedBy=["backend-api", "frontend-components"]
TaskUpdate --taskId="full-system-test" --addBlockedBy=["api-integration"]
```

### Validation Criteria Templates

#### Functional Validation Template
```markdown
## Functional Success Criteria
- [ ] All specified requirements implemented and demonstrated
- [ ] User acceptance criteria met with evidence
- [ ] Edge cases handled appropriately
- [ ] Error conditions managed gracefully
- [ ] Performance targets achieved
```

#### Quality Validation Template
```markdown
## Quality Standards Checklist
- [ ] Code review completed and approved
- [ ] Test coverage meets requirements (70% backend, 75% frontend)
- [ ] Security review passed (for security-sensitive changes)
- [ ] Documentation updated and accurate
- [ ] Performance impact assessed and acceptable
```

#### Integration Validation Template
```markdown
## Integration Verification
- [ ] Compatibility with existing systems verified
- [ ] API contracts maintained or properly versioned
- [ ] Database changes backward compatible
- [ ] Third-party integrations tested
- [ ] Environment-specific testing completed
```

#### Rollback Validation Template
```markdown
## Rollback Plan Verification
- [ ] Current state documented before changes
- [ ] Rollback procedure tested in development
- [ ] Rollback doesn't break dependent systems
- [ ] Production rollback steps documented
- [ ] Emergency rollback contacts identified
```

### Follow-Up Task Templates

#### Performance Monitoring Follow-Up
```bash
TaskCreate --subject="Monitor performance impact of new feature" \
           --description="Set up monitoring dashboards, establish performance baselines, and track impact of recent changes. Success: Performance monitoring in place with alerting configured." \
           --activeForm="Setting up performance monitoring"
```

#### Documentation Follow-Up
```bash
TaskCreate --subject="Update system documentation" \
           --description="Document architectural changes, update API documentation, and create user guides. Success: Documentation current, accessible, and validated by team." \
           --activeForm="Updating system documentation"
```

#### Technical Debt Follow-Up
```bash
TaskCreate --subject="Address identified technical debt" \
           --description="Plan and implement improvements for code quality issues identified during development. Success: Technical debt items prioritized and implementation planned." \
           --activeForm="Addressing technical debt"
```

#### Security Follow-Up
```bash
TaskCreate --subject="Implement additional security controls" \
           --description="Add enhanced security measures based on security review findings. Success: Additional controls implemented, security posture improved." \
           --activeForm="Implementing security controls"
```

### Scope Management Templates

#### Scope Assessment Template
```bash
echo "=== Scope Validation ==="
echo "Major Tasks: [Count] / 5 maximum"
echo "Dependency Chains: [Count] / 3 maximum"
echo "External Integrations: [Count] / 2 maximum"
echo "Estimated Duration: [Time] / Session limits"

# Scope Management Actions:
# - Document any new requirements as separate tasks
# - Assess overall session scope if significant changes emerge
# - Consider breaking session if scope becomes unmanageable
# - Update task descriptions with rationale for any changes
```

#### Task Breakdown Template
```bash
# Feature: User Profile Management
echo "=== Task Breakdown ==="
echo "1. Backend API Development"
echo "   - Database schema design"
echo "   - API endpoint implementation"
echo "   - Validation and security"
echo "2. Frontend Implementation"
echo "   - Profile editing interface"
echo "   - Image upload functionality"
echo "   - Form validation"
echo "3. Integration and Testing"
echo "   - API integration testing"
echo "   - End-to-end user flows"
echo "   - Performance validation"
echo "4. Deployment and Monitoring"
echo "   - Production deployment"
echo "   - Monitoring setup"
echo "   - Performance tracking"
```

### Progress Tracking Templates

#### Progress Review Template
```bash
echo "=== Progress Assessment ==="
echo "Tasks In Progress: [List active tasks with status]"
echo "Blocked Tasks: [List tasks waiting for dependencies]"
echo "Completed Tasks: [List finished tasks with validation status]"
echo "Scope Changes: [Any modifications to original plan]"
echo "Risk Factors: [Issues that may impact timeline or quality]"
```

#### Quality Gate Template
```bash
# Quality Gate Verification Checklist
validate_quality_gates() {
    echo "=== Quality Gate Verification ==="
    echo "□ Functional Testing: All acceptance criteria demonstrated"
    echo "□ Code Quality: Standards compliance, review completion"
    echo "□ Integration Testing: Compatibility verified"
    echo "□ Documentation: Changes documented, knowledge transferred"
    echo "□ Security Review: Security implications assessed"
    echo "□ Performance Validation: Performance impact acceptable"
    echo "□ Rollback Testing: Rollback procedures verified"
}
```

### Emergency Response Templates

#### Production Incident Task
```bash
TaskCreate --subject="Resolve production incident" \
           --description="Emergency fix for production issue. Full planning review required post-incident. Success: Production service restored, incident documented, post-mortem completed." \
           --activeForm="Resolving production incident"
```

#### Security Incident Task
```bash
TaskCreate --subject="Address security vulnerability" \
           --description="Emergency security fix with impact assessment and monitoring setup. Success: Vulnerability patched, security validated, monitoring enhanced." \
           --activeForm="Addressing security vulnerability"
```

#### Data Recovery Task
```bash
TaskCreate --subject="Execute data recovery procedure" \
           --description="Recover lost or corrupted data using backup systems and validation procedures. Success: Data recovered, integrity verified, backup systems validated." \
           --activeForm="Executing data recovery"
```

These templates provide standardized patterns for creating comprehensive, well-structured tasks that align with FUB's development standards and accountability requirements.