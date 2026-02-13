## Integration Points

### Cross-Skill Workflow Coordination

#### Primary Integration Relationships

| Related Skill | Integration Type | Common Workflows |
|---------------|------------------|------------------|
| `backend-test-development` | **Testing Integration** | TDD workflows, DatabaseTestCase usage, PHPUnit coverage validation |
| `database-operations` | **Data Layer** | ActiveRecord patterns, query optimization, schema migrations |
| `serena-mcp` | **Code Analysis** | Lithium framework analysis, dependency mapping, refactoring guidance |
| `email-parser-development` | **Parser Implementation** | EmailParser inheritance, parsing logic, test fixture creation |
| `gitlab-mr-management` | **Version Control** | Branch management, merge requests, deployment to FUB environments |
| `support-investigation` | **Bug Resolution** | Root cause analysis, fix validation, production debugging |
| `datadog-management` | **Monitoring** | Performance validation, error tracking, metrics collection |
| `claude-code-maintenance` | **Accuracy Validation** | Verify development patterns, validate code examples, maintain FUB standards consistency |

#### Multi-Skill Operation Examples

**Email Parser Development Workflow:**
```bash
# Complete email parser development cycle
email-parser-development --parser_name="RealtyMX" --sample_email="realty_mx_lead.txt" |\
  code-development --task="Implement RealtyMX email parser" --scope="small-feature" |\
  backend-test-development --target="RealtyMxEmailParserTest" --test_type="integration"
```

**Feature Development with Database Changes:**
```bash
# Full feature development requiring schema changes
database-operations --operation="schema-migration" --environment="development" |\
  code-development --task="Add contact export feature with filtering" --scope="small-feature" |\
  backend-test-development --target="ContactsControllerTest" --test_type="integration"
```

**Bug Fix with Investigation:**
```bash
# Complete bug resolution workflow
support-investigation --issue="Contact import failure PROJ-12345" --environment="production" |\
  serena-mcp --task="Analyze contact import code flow" --scope="targeted-analysis" |\
  code-development --task="Fix contact import validation in PROJ-12345" --scope="bug-fix"
```

#### Workflow Handoff Patterns

**To code-development ← Other Skills:**
- Receives architecture analysis and framework patterns from `serena-mcp`
- Gets schema requirements and ActiveRecord patterns from `database-operations`
- Obtains parser specifications and test fixtures from `email-parser-development`
- Accepts bug analysis and reproduction steps from `support-investigation`

**From code-development → Other Skills:**
- Provides implemented features requiring comprehensive testing to `backend-test-development`
- Supplies new ActiveRecord models and queries to `database-operations`
- Delivers completed parsers for monitoring setup to `email-parser-development`
- Offers production fixes requiring deployment to `gitlab-pipeline-monitoring`

### Bidirectional Integration Examples

**code-development ↔ backend-test-development:**
```markdown
→ Development provides: New controllers, models, services requiring DatabaseTestCase testing
← Testing provides: Test requirements, fixture specifications, coverage gap identification
Integration: TDD workflows with Arrange-Act-Assert patterns, $sut naming conventions
```

**code-development ↔ email-parser-development:**
```markdown
→ Development provides: EmailParser base class implementations, parsing logic validation
← Parser Dev provides: Parser specifications, sample email fixtures, validation requirements
Integration: EmailParser inheritance, test fixture creation, production deployment
```

**code-development ↔ database-operations:**
```markdown
→ Development provides: ActiveRecord usage patterns, performance requirements, query needs
← Database Ops provides: Schema migrations, optimized query patterns, relationship mappings
Integration: ActiveRecord best practices, N+1 query prevention, performance optimization
```

## Planning Integration and Task Accountability

### Proactive Planning Requirements

**MANDATORY**: Code development operations requiring planning (per skills/planning-workflow/SKILL.md):
- Operations affecting >3 files or estimated >30 minutes
- Feature implementations and architectural changes
- Complex bug fixes requiring investigation across multiple components
- Security implementations or vulnerability fixes

### Planning Integration Workflow

**Complete Planning-to-Development Lifecycle:**

```bash
# Phase 1: Comprehensive Planning
/planning --operation="create-plan" --task_context="feature-implementation" --scope_estimate="medium"
# [Creates structured task breakdown with dependencies and validation criteria]

# Phase 2: Development with Task Tracking
/code-development --task="Implement planned feature components" --scope="planned-feature"
# [Execute development with continuous task status updates]

# Phase 3: Progress Validation
/planning --operation="check-progress"
# [Monitor development progress against planned tasks]

# Phase 4: Completion Verification
/planning --operation="validate-completion"
# [Verify implementation meets planning validation criteria]
```

### Task Management Integration

**Required Task Tracking Protocol:**

```markdown
Before starting development:
1. Create tasks with TaskCreate for each major component
2. Set up dependencies with TaskUpdate blocking relationships
3. Define validation criteria in task descriptions
4. Update task status to "in_progress" when beginning work

During development:
1. Update task progress regularly using TaskUpdate
2. Create new tasks for emergent requirements (don't expand existing tasks)
3. Document scope changes and rationale in task descriptions
4. Monitor scope limits (5 major tasks, 3 dependency chains, 2 integrations)

After completion:
1. Validate each task against its acceptance criteria
2. Mark tasks as "completed" only after full validation
3. Create follow-up tasks for monitoring, documentation, or technical debt
```

**Task Creation Examples for Code Development:**

```bash
# Architecture Analysis Task
TaskCreate --subject="Analyze authentication system architecture" \
           --description="Review existing auth patterns, identify MFA extension points, document integration approach. Success: Clear architectural understanding, documented extension points, no integration conflicts identified." \
           --activeForm="Analyzing authentication architecture"

# Implementation Task with Dependencies
TaskCreate --subject="Implement MFA validation endpoints" \
           --description="Create MFA verification API endpoints following FUB security patterns. Dependencies: Architecture analysis complete. Success: Working endpoints with proper error handling, security review passed." \
           --activeForm="Implementing MFA endpoints"

# Testing Task with Quality Gates
TaskCreate --subject="Add comprehensive MFA testing" \
           --description="Create PHPUnit tests for MFA implementation with 85% coverage. Dependencies: Endpoint implementation complete. Success: All tests pass, coverage target met, edge cases covered." \
           --activeForm="Adding MFA testing"
```

### Planning-Enhanced Development Workflow

**Integration with Existing Development Steps:**

#### 1. Pre-Development Planning Phase
```markdown
Before Environment and Safety Verification:
- Execute planning workflow to create comprehensive task breakdown
- Validate scope against session limits
- Establish task dependencies and blocking relationships
- Define specific validation criteria for each development task
```

#### 2. Development Execution with Task Tracking
```markdown
Enhanced FUB Framework Context Analysis:
- Update task status to "in_progress" before beginning analysis
- Document architectural findings in task descriptions
- Create additional tasks if analysis reveals new requirements
- Validate analysis completeness against task acceptance criteria

Enhanced Safe File Editing Protocol:
- Update task progress as files are modified
- Document changes and rationale in task updates
- Verify changes meet task-specific validation criteria
- Monitor scope adherence throughout development process
```

#### 3. Post-Development Validation Integration
```markdown
Enhanced Quality Validation:
- Validate implementation against original task acceptance criteria
- Verify all task dependencies have been resolved
- Mark tasks as complete only after comprehensive validation
- Create follow-up tasks for monitoring, documentation, or improvements
```

### Cross-Skill Planning Integration

**Enhanced Integration Patterns with Planning:**

```bash
# Planning-Enhanced Feature Development
/planning --operation="create-plan" --task_context="feature-implementation"
/serena-mcp --task="Analyze codebase for feature integration points"
/code-development --task="Implement feature with planned approach" --scope="planned-feature"
/backend-test-development --target="FeatureTest" --test_type="comprehensive"
/planning --operation="validate-completion"
/planning --operation="review-session"

# Planning-Enhanced Bug Resolution
/planning --operation="create-plan" --task_context="bug-investigation"
/support-investigation --issue="PROJ-12345" --environment="production"
/code-development --task="Fix identified bug with planned approach" --scope="planned-fix"
/planning --operation="validate-completion"

# Planning-Enhanced Database Integration
/planning --operation="create-plan" --task_context="integration"
/database-operations --operation="schema-analysis" --environment="development"
/code-development --task="Implement schema changes with planned approach" --scope="planned-schema"
/planning --operation="validate-completion"
```

### Emergency and Critical Path Integration

**Modified Planning for Critical Development:**

```bash
# Emergency Development with Streamlined Planning
TaskCreate --subject="Emergency production fix for [ISSUE]" \
           --description="Critical fix for production issue. Full planning review required post-fix. Success: Production restored, issue resolved, comprehensive post-mortem completed." \
           --activeForm="Implementing emergency fix"

/code-development --task="Emergency fix implementation" --scope="critical-path"
# [Execute critical fix following safety protocols]

/planning --operation="review-session" --task_context="maintenance"
# [Post-incident planning assessment and improvement identification]
```

### Planning Validation Integration

**Quality Gates Enhanced with Planning Requirements:**

```markdown
Pre-Development Quality Gates:
□ Planning workflow completed for complex operations (>3 files, >30 min)
□ Tasks created with specific acceptance criteria
□ Dependencies mapped and blocking relationships established
□ Scope validated against session limits (5 tasks, 3 chains, 2 integrations)
□ Validation criteria specified for each task

Development Quality Gates:
□ Task status updated to "in_progress" before beginning work
□ Progress monitored and documented throughout development
□ Scope adherence maintained (new requirements → new tasks)
□ Task completion criteria validated before marking complete

Post-Development Quality Gates:
□ All tasks validated against acceptance criteria
□ Quality standards met (test coverage, security review, performance)
□ Integration verification completed
□ Follow-up tasks created for ongoing requirements
□ Planning effectiveness assessed for continuous improvement
```

