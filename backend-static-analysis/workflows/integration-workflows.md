## Cross-Skill Integration Workflows

### Backend Static Analysis → Code Development Integration

**Pre-Development Type Safety Assessment:**
```bash
# Assess current type safety state before new feature development
/backend-static-analysis --baseline |\
  code-development --workflow="feature" --task="User authentication" --include_type_safety=true

# Validate type safety during development iterations
/code-development --operation="review-changes" |\
  backend-static-analysis --target="modified-files" --strict=true
```

**Code Quality Gates Integration:**
```bash
# Complete development workflow with type safety validation
/code-development --task="Add user validation" --scope="feature" |\
  backend-static-analysis . --baseline |\
  backend-test-development --target="UserValidator" --type_coverage=true |\
  gitlab-pipeline-monitoring --operation="psalm-validation"
```

### Backend Static Analysis → Planning Workflow Integration

**Technical Debt Estimation:**
```bash
# Include type safety effort in sprint planning
/backend-static-analysis . --baseline |\
  planning-workflow --project="Psalm Baseline Reduction" --scope="tech-debt" --estimate_effort=true

# Coordinate baseline reduction across teams
/planning-workflow --operation="tech-initiative" --initiative="Type Safety" |\
  backend-static-analysis --team-coordination --baseline-goals=true
```

**Sprint Goal Integration:**
```bash
# Set type safety goals for sprint planning
/backend-static-analysis --trend-analysis --weeks=4 |\
  planning-workflow --operation="sprint-goals" --include_quality_metrics=true

# Progress tracking for Backend Guild coordination
/backend-static-analysis --team-progress |\
  planning-workflow --operation="progress-report" --stakeholder="backend-guild"
```

### Backend Static Analysis → Database Operations Integration

**Schema Change Type Validation:**
```bash
# Validate type safety implications of database schema changes
/database-operations --operation="schema-migration" --environment="development" |\
  backend-static-analysis --validate-model-types --strict=true

# Check ActiveRecord model compliance after schema updates
/database-operations --operation="migration-complete" |\
  backend-static-analysis --focus="activerecord-patterns" --validate-properties=true
```

**Model Property Analysis:**
```bash
# Analyze type safety for database model properties
/backend-static-analysis --focus="model-properties" |\
  database-operations --operation="property-validation" --models="Contact,Deal,Account"

# Coordinate migration type safety with database changes
/database-operations --operation="prepare-migration" |\
  backend-static-analysis --pre-migration-check --predict-type-issues=true
```

### Backend Static Analysis → GitLab Pipeline Integration

**CI/CD Type Safety Enforcement:**
```bash
# Monitor Psalm job status in GitLab pipelines
/gitlab-pipeline-monitoring --operation="status_check" --job="psalm" |\
  backend-static-analysis --ci-integration --report-failures=true

# Coordinate deployment gates with type safety validation
/backend-static-analysis --ci-check |\
  gitlab-pipeline-monitoring --operation="deployment-gate" --gate="type-safety"
```

**Pipeline Performance Optimization:**
```bash
# Optimize Psalm CI job performance
/backend-static-analysis --performance-analysis |\
  gitlab-pipeline-monitoring --operation="optimize-job" --job="psalm" --target="execution-time"

# Monitor pipeline health with type safety metrics
/gitlab-pipeline-monitoring --operation="health-metrics" |\
  backend-static-analysis --pipeline-metrics --dashboard=true
```

### Backend Static Analysis → Backend Test Development Integration

**Test Type Safety Validation:**
```bash
# Validate type safety in test code
/backend-test-development --target="TestCase" --operation="analyze" |\
  backend-static-analysis --include-tests --test-type-safety=true

# Coordinate test coverage with type safety improvements
/backend-static-analysis --coverage-gaps |\
  backend-test-development --target="type-safety-tests" --generate-tests=true
```

**Quality Assurance Integration:**
```bash
# Complete quality validation workflow
/backend-static-analysis --comprehensive |\
  backend-test-development --target="quality-gates" --type="comprehensive" |\
  review --coverage_target=80 --type_safety=required
```

### Multi-Skill Operational Workflows

**Complete Code Quality Improvement Workflow:**
```bash
# 1. Current state assessment
/backend-static-analysis . --baseline --comprehensive |\
  planning-workflow --operation="quality-assessment" --scope="type-safety"

# 2. Development with type safety focus
/planning-workflow --operation="start-sprint" |\
  code-development --task="Type safety improvements" --scope="refactoring" |\
  backend-static-analysis --track-progress --continuous=true

# 3. Testing and validation
/code-development --operation="complete" |\
  backend-test-development --target="TypeSafetyTest" --coverage="type-annotations" |\
  backend-static-analysis --validate-improvements

# 4. Pipeline integration and monitoring
/backend-test-development --operation="complete" |\
  gitlab-pipeline-monitoring --operation="type-safety-gate" |\
  datadog-management --operation="quality-metrics" --track="psalm-baseline"

# 5. Progress reporting and coordination
/gitlab-pipeline-monitoring --operation="complete" |\
  backend-static-analysis --generate-report --stakeholders="backend-guild" |\
  confluence-management --operation="update-progress" --page="type-safety-initiative"
```

**Technical Debt Reduction Sprint:**
```bash
# 1. Debt assessment and prioritization
/backend-static-analysis --debt-analysis --prioritize=true |\
  planning-workflow --project="Technical Debt Reduction" --scope="type-safety"

# 2. Targeted improvement execution
/planning-workflow --operation="start-work" |\
  code-development --task="Fix critical type issues" --scope="debt-reduction" |\
  backend-static-analysis --track-baseline-reduction --target-percentage=20

# 3. Automated improvement where possible
/backend-static-analysis --use-psalter --automated-fixes=true |\
  backend-test-development --validate-changes --regression-check=true

# 4. Team coordination and progress tracking
/backend-test-development --operation="complete" |\
  datadog-management --task_type="metrics" --query_context="code_quality" |\
  planning-workflow --operation="progress-update" --initiative="type-safety"
```

**Pre-deployment Quality Validation:**
```bash
# 1. Type safety validation
/backend-static-analysis . --ci-check --strict=true |\
  gitlab-pipeline-monitoring --operation="pre-deployment-check" --gate="psalm"

# 2. Database schema validation
/backend-static-analysis --validate-schema-types |\
  database-operations --operation="schema_validation" --environment="staging" --type-check=true

# 3. Integration testing with type safety
/database-operations --operation="validation-complete" |\
  backend-test-development --target="integration-tests" --type-safety-required=true

# 4. Production readiness assessment
/backend-test-development --operation="complete" |\
  backend-static-analysis --production-readiness --report-blockers=true |\
  gitlab-pipeline-monitoring --operation="deployment-approval" --quality-gates=true
```

### Team Coordination Workflows

**Backend Guild Monthly Sync:**
```bash
# Generate comprehensive type safety report for Backend Guild
generate_backend_guild_report() {
    echo "📊 Backend Guild Type Safety Report - $(date +%B\ %Y)"
    echo "================================================"

    # Overall health assessment
    /backend-static-analysis --health-score --all-projects

    # Progress trends
    /backend-static-analysis --trend-analysis --weeks=4 --teams=all

    # Team-specific metrics
    for team in backend api infrastructure frontend; do
        echo -e "\n🏗️  $team Team Metrics:"
        /backend-static-analysis --team-focus="$team" --baseline-contribution
    done

    # Upcoming initiatives coordination
    echo -e "\n🎯 Upcoming Initiatives:"
    /planning-workflow --operation="upcoming-initiatives" --domain="type-safety" --timeline="next-quarter"

    # Recommendations and action items
    echo -e "\n📋 Recommendations:"
    /backend-static-analysis --generate-recommendations --scope="guild-coordination"
}

# Execute and distribute report
generate_backend_guild_report | tee backend-guild-report-$(date +%Y-%m).md
```

**Cross-Team Migration Coordination:**
```bash
# Coordinate large-scale type safety migration
coordinate_migration() {
    local migration_name="$1"
    local timeline="$2"

    echo "🚀 Coordinating $migration_name migration over $timeline"

    # 1. Impact assessment
    /backend-static-analysis --migration-impact --scope="$migration_name" |\
      planning-workflow --operation="impact-assessment" --coordination=true

    # 2. Team capacity planning
    /planning-workflow --operation="capacity-planning" --initiative="$migration_name" |\
      backend-static-analysis --effort-estimation --team-distribution=true

    # 3. Phased rollout planning
    /backend-static-analysis --rollout-strategy --migration="$migration_name" |\
      planning-workflow --operation="phased-rollout" --timeline="$timeline"

    # 4. Coordination checkpoints
    /planning-workflow --operation="checkpoint-schedule" |\
      backend-static-analysis --checkpoint-validation --automated=true
}

# Usage examples
coordinate_migration "baseline-elimination" "8-weeks"
coordinate_migration "error-level-2-upgrade" "12-weeks"
```

**Developer Onboarding Integration:**
```bash
# New developer type safety onboarding
onboard_developer_type_safety() {
    local developer="$1"

    echo "👨‍💻 Onboarding $developer to FUB type safety practices"

    # 1. Current project assessment
    /backend-static-analysis --onboarding-assessment --developer="$developer"

    # 2. Learning path creation
    /planning-workflow --operation="learning-path" --domain="type-safety" --role="developer" |\
      documentation-retrieval --context="psalm-best-practices" --personalized=true

    # 3. Practical exercises
    /backend-static-analysis --training-exercises --level="beginner" |\
      code-development --workflow="training" --supervised=true

    # 4. Progress tracking
    /planning-workflow --operation="track-progress" --person="$developer" --domain="type-safety" |\
      backend-static-analysis --skill-assessment --periodic=true
}
```

### Integration Monitoring and Metrics

**Quality Metrics Dashboard Integration:**
```bash
# Comprehensive quality metrics for management dashboards
generate_quality_dashboard_data() {
    echo "📊 Generating quality metrics for dashboard integration..."

    # Type safety health scores
    /backend-static-analysis --health-metrics --json-output |\
      datadog-management --task_type="custom-metrics" --namespace="code-quality.type-safety"

    # Progress trends for executive reporting
    /backend-static-analysis --executive-summary --trend-analysis |\
      datadog-management --task_type="dashboard" --dashboard="executive-quality-overview"

    # Team performance metrics
    /backend-static-analysis --team-metrics --comparative |\
      datadog-management --task_type="team-dashboard" --breakdown="by-team"

    # Deployment impact correlation
    /backend-static-analysis --deployment-correlation |\
      gitlab-pipeline-monitoring --operation="quality-correlation" |\
      datadog-management --task_type="correlation-analysis" --metric="deployment-success"
}
```

**Automated Health Alerts:**
```bash
# Set up automated alerts for type safety degradation
setup_type_safety_alerts() {
    echo "🚨 Setting up automated type safety health alerts..."

    # Baseline growth alerts
    /backend-static-analysis --alert-thresholds --baseline-growth=10% |\
      datadog-management --operation="create_monitor" --alert_type="code-quality"

    # CI failure rate alerts
    /gitlab-pipeline-monitoring --operation="psalm-failure-rate" |\
      datadog-management --operation="pipeline-health-monitor" --job="psalm"

    # Team coordination alerts
    /backend-static-analysis --coordination-alerts --stakeholder="backend-guild" |\
      datadog-management --operation="stakeholder-alerts" --channel="backend-guild-alerts"
}
```

### Best Practices for Integration

**Workflow Handoff Patterns:**

**To backend-static-analysis ← From Other Skills:**
- **`code-development`**: Requests type safety validation for new/modified code
- **`planning-workflow`**: Provides technical debt estimation and sprint goals
- **`database-operations`**: Requires model property type validation
- **`backend-test-development`**: Requests test code type safety analysis

**From backend-static-analysis → To Other Skills:**
- **`code-development`**: Provides specific type safety issues and remediation patterns
- **`planning-workflow`**: Supplies effort estimates for baseline reduction work
- **`gitlab-pipeline-monitoring`**: Delivers CI job performance and failure analysis
- **`datadog-management`**: Provides baseline metrics for quality dashboards

**Integration Architecture:**

**Quality Gates Integration:**
1. **Pre-commit**: Type safety validation before code commit
2. **Code Review**: Automated Psalm results in merge request analysis
3. **Sprint Planning**: Baseline reduction goals integrated into capacity planning
4. **Production Deployment**: Type safety validation as deployment gate

**Monitoring Integration:**
- **Baseline Size Tracking**: Real-time monitoring of error count trends
- **Team Progress Dashboards**: Integration with Datadog for quality visualization
- **CI/CD Pipeline Health**: Psalm job success rates and performance monitoring
- **Executive Reporting**: High-level type safety health in management dashboards

**Communication Integration:**
- **Backend Guild Coordination**: Monthly progress reports and initiative planning
- **Developer Training**: Onboarding integration with type safety best practices
- **Cross-Team Migration**: Large-scale type safety migration coordination
- **Stakeholder Updates**: Executive and product team type safety impact communication