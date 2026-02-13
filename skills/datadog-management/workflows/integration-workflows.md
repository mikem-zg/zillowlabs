## Cross-Skill Integration Workflows and Coordination Patterns

### Cross-Skill Workflow Coordination

#### Primary Integration Relationships

| Related Skill | Integration Type | Common Workflows |
|---------------|------------------|------------------|
| `support-investigation` | **Primary Coordination** | Log analysis for incident investigation, error pattern correlation, system health validation |
| `database-operations` | **Performance Monitoring** | Database query performance analysis, migration impact monitoring, connection health tracking |
| `backend-test-development` | **Testing Integration** | Performance test monitoring, staging environment validation, test failure correlation |
| `gitlab-pipeline-monitoring` | **Deployment Monitoring** | Pipeline health tracking, deployment impact analysis, infrastructure change correlation |
| `serena-mcp` | **Code Correlation** | Code change impact analysis, deployment correlation, performance regression tracking |
| `mutagen-management` | **Development Environment** | Remote development monitoring, sync performance tracking, development workflow health |
| `planning-workflow` | **Monitoring Integration** | Performance planning, monitoring setup, implementation validation |

#### Multi-Skill Operation Examples

**Complete Performance Investigation Workflow:**
```bash
# 1. Detect performance degradation through monitoring
/datadog-management --task_type="metrics" --query_context="fub-api response times last 4h"

# 2. Analyze recent code changes for potential impact
/serena-mcp --operation="find-recent-changes" --path="apps/fub_api/controllers"

# 3. Investigate database performance correlation
/database-operations --operation="performance-analysis" --environment="production"

# 4. Correlate with user-reported issues
/support-investigation --issue="API performance degradation" --account_data="from_datadog"

# 5. Create follow-up monitoring tasks
/planning-workflow --operation="create-plan" --task_context="performance-optimization" --scope_estimate="medium"
```

**Complete Incident Response Workflow:**
```bash
# 1. Detect and analyze incident through monitoring
/datadog-management --task_type="incident" --query_context="service degradation investigation"

# 2. Correlate with user impact and support tickets
/support-investigation --issue="System outage" --environment="production"

# 3. Review recent deployments for correlation
/gitlab-pipeline-monitoring --operation="list" --timeframe="last_4h"

# 4. Monitor resolution and validate recovery
/datadog-management --task_type="monitor" --query_context="validate system recovery"

# 5. Plan post-incident improvements
/planning-workflow --operation="create-plan" --task_context="incident-response-improvement"
```

**Development Deployment Monitoring:**
```bash
# 1. Execute deployment with monitoring setup
/gitlab-pipeline-monitoring --operation="monitor" --branch="main" --environment="production"

# 2. Monitor deployment impact in real-time
/datadog-management --task_type="investigate" --query_context="post-deployment validation"

# 3. Validate functionality with smoke tests
/backend-test-development --target="All" --test_type="smoke" --environment="production"

# 4. Track performance metrics post-deployment
/datadog-management --task_type="metrics" --query_context="deployment impact analysis"
```

### Workflow Handoff Patterns

#### From datadog-management → Other Skills

**To support-investigation:**
- **Error Analysis Data**: Provides structured error patterns, frequency analysis, and account-specific impact metrics
- **Service Health Metrics**: Supplies comprehensive service performance data and availability statistics
- **Correlation Analysis**: Delivers timeline correlation between system events and user-reported issues
- **Evidence Collection**: Offers detailed log samples, performance metrics, and system health indicators

**To database-operations:**
- **Performance Metrics**: Provides database query performance data, connection pool statistics, and transaction timing
- **Impact Analysis**: Supplies pre/post change performance comparisons and trend analysis
- **Health Monitoring**: Delivers database connection health, query execution patterns, and resource utilization data
- **Alert Context**: Offers database-related alert information and performance threshold breaches

**To gitlab-pipeline-monitoring:**
- **Deployment Correlation**: Provides deployment impact analysis, performance regression detection, and system health changes
- **Infrastructure Metrics**: Supplies service performance data before/during/after deployments
- **Alert Timeline**: Delivers alert correlation with deployment events and infrastructure changes
- **Performance Baselines**: Offers performance baseline data for deployment impact assessment

**To planning-workflow:**
- **Monitoring Requirements**: Provides monitoring setup specifications, alert configuration needs, and dashboard requirements
- **Performance Planning**: Supplies capacity planning data, resource utilization trends, and scaling recommendations
- **Issue Context**: Delivers incident analysis for improvement planning and technical debt identification
- **Validation Criteria**: Offers metrics-based success criteria for monitoring implementation tasks

#### To datadog-management ← Other Skills

**From support-investigation:**
- **Investigation Context**: Receives specific account IDs, error descriptions, user-reported symptoms, and business impact assessments
- **Issue Prioritization**: Gets severity levels, affected user counts, and business criticality context
- **Timeline Information**: Obtains incident timelines, user report timestamps, and business impact windows
- **Resolution Validation**: Receives user confirmation requests and business impact verification needs

**From database-operations:**
- **Change Context**: Gets migration deployment timing, schema change impact expectations, and performance baseline requirements
- **Performance Context**: Obtains query optimization results, database configuration changes, and expected performance improvements
- **Health Context**: Receives database maintenance schedules, backup operations timing, and infrastructure changes
- **Monitoring Requests**: Gets specific database performance monitoring requirements and alert threshold adjustments

**From gitlab-pipeline-monitoring:**
- **Deployment Context**: Receives deployment timing, infrastructure changes, service updates, and release information
- **Pipeline Context**: Obtains build and deployment success/failure information, infrastructure provisioning data
- **Change Correlation**: Gets code change information, feature deployment details, and infrastructure modification data
- **Monitoring Coordination**: Receives deployment monitoring requests and performance validation requirements

**From planning-workflow:**
- **Task Context**: Gets monitoring implementation requirements, performance optimization tasks, and incident response improvements
- **Validation Requirements**: Obtains success criteria for monitoring tasks, performance benchmarks, and quality gates
- **Priority Context**: Receives task prioritization, business impact context, and urgency levels
- **Integration Needs**: Gets cross-skill coordination requirements and workflow integration specifications

### Bidirectional Integration Examples

#### datadog-management ↔ support-investigation

**Outbound Integration (datadog → support):**
```bash
# Provide comprehensive incident evidence
provide_incident_evidence() {
    local account_id="$1"
    local timeframe="$2"

    # Gather multi-dimensional evidence
    local error_analysis=$(mcp__datadog_production__search_logs --filter="{\"query\":\"@context.account_id:$account_id status:error\",\"from\":\"$timeframe\"}")

    local performance_impact=$(mcp__datadog_production__aggregate_logs --filter="{\"query\":\"@context.account_id:$account_id\",\"from\":\"$timeframe\"}" --compute="[{\"aggregation\":\"avg\",\"metric\":\"@http.response_time\"}]")

    local service_correlation=$(mcp__datadog_production__search_logs --filter="{\"query\":\"@context.account_id:$account_id\",\"from\":\"$timeframe\"}" --groupBy="[{\"facet\":\"service\"}]")

    # Format for support investigation
    echo "=== Datadog Evidence Package ==="
    echo "Account: $account_id"
    echo "Time Range: $timeframe"
    echo "Error Patterns: $error_analysis"
    echo "Performance Impact: $performance_impact"
    echo "Service Correlation: $service_correlation"
    echo "Datadog URLs: [Generated investigation links]"
}
```

**Inbound Integration (support → datadog):**
```bash
# Receive targeted investigation requests
handle_support_investigation_request() {
    local investigation_context="$1"
    local priority_level="$2"
    local affected_accounts="$3"

    echo "=== Support Investigation Request ==="
    echo "Context: $investigation_context"
    echo "Priority: $priority_level"
    echo "Affected Accounts: $affected_accounts"

    # Execute targeted Datadog investigation
    for account in $affected_accounts; do
        /datadog-management --task_type="investigate" --query_context="account $account $investigation_context"
    done

    # Provide structured response back to support
    generate_support_evidence_report "$investigation_context" "$affected_accounts"
}
```

#### datadog-management ↔ database-operations

**Outbound Integration (datadog → database):**
```bash
# Provide database performance insights
provide_database_insights() {
    local analysis_timeframe="$1"
    local performance_threshold="$2"

    # Database performance analysis
    local slow_queries=$(mcp__datadog_production__aggregate_logs --filter="{\"query\":\"@database.query_time:>$performance_threshold\",\"from\":\"$analysis_timeframe\"}")

    local connection_patterns=$(mcp__datadog_production__aggregate_logs --filter="{\"query\":\"service:(fub-api OR fub-worker) @database.connections:*\",\"from\":\"$analysis_timeframe\"}")

    local transaction_analysis=$(mcp__datadog_production__search_logs --filter="{\"query\":\"@database.transaction_time:>5000\",\"from\":\"$analysis_timeframe\"}")

    echo "=== Database Performance Analysis ==="
    echo "Slow Query Patterns: $slow_queries"
    echo "Connection Usage: $connection_patterns"
    echo "Long Transactions: $transaction_analysis"
    echo "Performance Recommendations: [Generated based on analysis]"
}
```

**Inbound Integration (database → datadog):**
```bash
# Handle database change monitoring requests
handle_database_change_monitoring() {
    local change_description="$1"
    local expected_impact="$2"
    local change_timestamp="$3"

    echo "=== Database Change Monitoring Setup ==="
    echo "Change: $change_description"
    echo "Expected Impact: $expected_impact"
    echo "Change Time: $change_timestamp"

    # Set up pre/post change monitoring
    setup_change_impact_monitoring "$change_timestamp" "$expected_impact"

    # Schedule performance validation
    schedule_performance_validation "$change_timestamp" "$change_description"
}
```

#### datadog-management ↔ gitlab-pipeline-monitoring

**Outbound Integration (datadog → gitlab):**
```bash
# Provide deployment impact analysis
provide_deployment_impact() {
    local deployment_time="$1"
    local services_deployed="$2"

    # Analyze deployment impact across multiple dimensions
    local performance_impact=$(analyze_deployment_performance_impact "$deployment_time" "$services_deployed")
    local error_rate_changes=$(analyze_deployment_error_changes "$deployment_time" "$services_deployed")
    local volume_impact=$(analyze_deployment_volume_impact "$deployment_time" "$services_deployed")

    echo "=== Deployment Impact Analysis ==="
    echo "Deployment Time: $deployment_time"
    echo "Services: $services_deployed"
    echo "Performance Impact: $performance_impact"
    echo "Error Rate Changes: $error_rate_changes"
    echo "Volume Impact: $volume_impact"
    echo "Overall Assessment: [HEALTHY|WARNING|CRITICAL]"
    echo "Recommendations: [Generated based on analysis]"
}
```

**Inbound Integration (gitlab → datadog):**
```bash
# Handle deployment monitoring requests
handle_deployment_monitoring_request() {
    local deployment_id="$1"
    local deployment_time="$2"
    local services="$3"
    local environment="$4"

    echo "=== Deployment Monitoring Request ==="
    echo "Deployment ID: $deployment_id"
    echo "Time: $deployment_time"
    echo "Services: $services"
    echo "Environment: $environment"

    # Set up comprehensive deployment monitoring
    setup_deployment_health_monitoring "$deployment_time" "$services" "$environment"

    # Schedule impact assessment
    schedule_deployment_impact_assessment "$deployment_id" "$deployment_time"
}
```

### Integration Architecture

#### FUB Monitoring Ecosystem Coordination

**Centralized Monitoring Hub:**
The datadog-management skill serves as the central monitoring and observability hub for FUB operations:

1. **Incident Detection and Analysis**: First line of defense for system health monitoring
2. **Performance Tracking**: Comprehensive application and infrastructure performance monitoring
3. **Evidence Collection**: Systematic evidence gathering for incident investigation
4. **Cross-System Correlation**: Correlation analysis across services, deployments, and user impact
5. **Proactive Monitoring**: Trend analysis and predictive alerting for issue prevention

**Multi-Skill Coordination Patterns:**

```bash
# Complete system health workflow coordination
coordinate_system_health_monitoring() {
    local monitoring_context="$1"

    echo "=== System Health Coordination ==="

    # 1. Real-time health monitoring (datadog-management)
    /datadog-management --task_type="metrics" --query_context="system health overview"

    # 2. User impact correlation (support-investigation)
    /support-investigation --operation="impact-analysis" --environment="production"

    # 3. Infrastructure health validation (database-operations)
    /database-operations --operation="health-check" --environment="production"

    # 4. Deployment correlation (gitlab-pipeline-monitoring)
    /gitlab-pipeline-monitoring --operation="recent-deployments" --timeframe="last_24h"

    # 5. Performance optimization planning (planning-workflow)
    /planning-workflow --operation="create-plan" --task_context="performance-monitoring" --scope_estimate="medium"
}
```

**Evidence-Based Investigation Framework:**

All monitoring operations integrate with evidence-based investigation standards:

1. **Structured Evidence Collection**: Systematic gathering of logs, metrics, and correlation data
2. **Cross-Skill Evidence Sharing**: Standardized evidence format for cross-skill collaboration
3. **Timeline Correlation**: Unified timeline analysis across monitoring, deployments, and user reports
4. **Impact Assessment**: Comprehensive impact analysis combining technical metrics and business context
5. **Resolution Validation**: Multi-dimensional validation of issue resolution and system recovery

**Monitoring Integration Standards:**

All monitoring workflows integrate through:

1. **Unified Alert Context**: Standardized alert information sharing across skills
2. **Performance Baseline Management**: Consistent performance baseline tracking and comparison
3. **Incident Response Coordination**: Coordinated incident response with automated evidence collection
4. **Deployment Impact Tracking**: Systematic deployment monitoring with cross-skill impact analysis
5. **Continuous Improvement**: Monitoring-driven improvement identification and implementation planning

This comprehensive integration framework ensures datadog-management coordinates effectively with all related skills while maintaining systematic monitoring, evidence-based investigation, and proactive system health management throughout the FUB development and operations ecosystem.