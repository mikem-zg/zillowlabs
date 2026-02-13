---
name: datadog-management
description: Comprehensive Datadog observability and monitoring management for FUB environments, including log analysis, metrics monitoring, dashboard creation, and incident investigation using MCP tools
---

## Overview

Comprehensive Datadog observability and monitoring management for Follow Up Boss (FUB) environments. Provides systematic log analysis, metrics monitoring, dashboard creation, and incident investigation using specialized MCP tools across production and staging environments with automatic resilience and recovery.

📋 **Monitoring Templates**: [templates/monitoring-templates.md](templates/monitoring-templates.md)
🚀 **Advanced Patterns**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
🔗 **Integration Workflows**: [workflows/integration-workflows.md](workflows/integration-workflows.md)
📖 **Reference Guide**: [reference/datadog-reference.md](reference/datadog-reference.md)

## Core Workflow

### Essential Operations (Most Common - 90% of Usage)

**1. Account-Specific Investigation (`investigate`)**
```bash
# Account error investigation
datadog-management --task_type="investigate" --environment="production" --query_context="account 12345 login errors"

# Account performance analysis
datadog-management --task_type="investigate" --query_context="account 12345 response times last 4h"

# Account activity pattern analysis
datadog-management --task_type="investigate" --query_context="account 12345 last 24h"
```

**2. Service Performance Analysis (`metrics`)**
```bash
# API service performance
datadog-management --task_type="metrics" --query_context="fub-api response times last 4h"

# Background job monitoring
datadog-management --task_type="metrics" --query_context="fub-worker job failure rate"

# Service health overview
datadog-management --task_type="metrics" --query_context="service health overview last 1h"
```

**3. Monitor Management (`monitor`)**
```bash
# Check service monitors
datadog-management --task_type="monitor" --query_context="fub-api alerts status"

# Review background job monitors
datadog-management --task_type="monitor" --query_context="fub-worker job failure rate"

# Monitor system health
datadog-management --task_type="monitor" --query_context="platform health check"
```

**4. Incident Response (`incident`)**
```bash
# Service degradation investigation
datadog-management --task_type="incident" --query_context="service degradation investigation"

# System outage analysis
datadog-management --task_type="incident" --query_context="system outage impact assessment"

# Performance regression analysis
datadog-management --task_type="incident" --query_context="performance regression analysis"
```

### Primary Investigation Patterns

#### Account-Specific Searches
```javascript
// Account error investigation
mcp__datadog_production__search_logs({
  filter: {
    query: "@context.account_id:12345 status:error",
    from: "now-24h",
    to: "now"
  },
  limit: 100
});

// Account performance impact
mcp__datadog_production__aggregate_logs({
  filter: {
    query: "@context.account_id:12345",
    from: "now-4h",
    to: "now"
  },
  compute: [
    { aggregation: "avg", metric: "@http.response_time" },
    { aggregation: "count" }
  ]
});
```

#### Service Health Analysis
```javascript
// Service error patterns
mcp__datadog_production__search_logs({
  filter: {
    query: "service:fub-api @http.status_code:>=500",
    from: "now-4h",
    to: "now"
  },
  limit: 50
});

// Background job failures
mcp__datadog_production__search_logs({
  filter: {
    query: "service:fub-resque @resque.job_status:failed",
    from: "now-6h",
    to: "now"
  }
});
```

#### Monitor Status Validation
```javascript
// Active alerts check
mcp__datadog_production__get_monitors({
  groupStates: ["alert", "warn"],
  tags: "service:fub-api",
  limit: 20
});

// Service monitor details
mcp__datadog_production__get_monitor({
  monitorId: 12345
});
```

→ **Complete monitoring patterns and templates**: [templates/monitoring-templates.md](templates/monitoring-templates.md)

### FUB Service Architecture

#### Primary Services
- **fub-api**: API controllers (`apps/fub_api/controllers/*Controller.php`)
- **fub-csd**: Customer Service Dashboard (`apps/fub_csd/controllers/*Controller.php`)
- **fub-richdesk**: Main application (`apps/richdesk/controllers/*Controller.php`)
- **fub-worker**: Background job processing and cron jobs
- **fub-resque**: Queue workers and asynchronous processing
- **fub-spa**: Frontend JavaScript application
- **fub-mobile-api**: Mobile-specific API endpoints

#### Common Log Fields
- `@context.account_id`: Account identifier for customer investigations
- `@correlation_id`: Request correlation across services
- `@function`: Specific function/method being executed
- `@http.status_code`: HTTP response status
- `@http.response_time`: Response time in milliseconds
- `@database.query_time`: Database query execution time
- `service`: Service name (fub-api, fub-worker, etc.)
- `status`: Log level (info, warn, error)

### Task Type Workflows

#### Investigation Workflow
1. **Context Validation**: Parse account ID, service, time range
2. **Primary Search**: Account or service-specific error patterns
3. **Correlation Analysis**: Cross-service and timeline correlation
4. **Evidence Collection**: Log samples with supporting metrics
5. **Impact Assessment**: Business and technical impact analysis

#### Monitor Workflow
1. **Status Review**: Check existing monitors by service tags
2. **Alert Analysis**: Review active alerts and warning states
3. **Threshold Validation**: Verify monitor configurations
4. **Recommendation**: Monitor optimization and tuning advice

#### Metrics Workflow
1. **Performance Analysis**: Service response times and throughput
2. **Trend Identification**: Pattern analysis and capacity planning
3. **Comparison**: Historical baseline comparison
4. **Reporting**: Performance summary and recommendations

#### Incident Workflow
1. **Evidence Collection**: Comprehensive incident data gathering
2. **Impact Analysis**: Service availability and user impact
3. **Correlation**: Timeline correlation with deployments/changes
4. **Resolution Tracking**: Monitor recovery and system health

## Environment Configuration

### Production Environment
- **MCP Tools**: `mcp__datadog-production__*`
- **Dashboard**: fub.datadoghq.com
- **Retention**: 15-day log retention limit
- **Purpose**: Real-time monitoring, alerting, and incident response

### Staging Environment
- **MCP Tools**: `mcp__datadog-staging__*`
- **Dashboard**: fubstaging.datadoghq.com
- **Purpose**: Development validation, QA testing, pre-production monitoring

## Integration Patterns

### Cross-Skill Workflows

**Performance Investigation:**
```bash
# Comprehensive performance analysis
datadog-management --task_type="metrics" --query_context="fub-api response times last 4h"
serena-mcp --operation="find-recent-changes" --path="apps/fub_api/controllers"
database-operations --operation="performance-analysis" --environment="production"
support-investigation --issue="API performance degradation"
```

**Incident Response:**
```bash
# Complete incident coordination
datadog-management --task_type="incident" --query_context="service degradation investigation"
support-investigation --issue="System outage" --environment="production"
gitlab-pipeline-monitoring --operation="recent-deployments" --timeframe="last_4h"
datadog-management --task_type="monitor" --query_context="validate system recovery"
```

**Deployment Monitoring:**
```bash
# Post-deployment validation
gitlab-pipeline-monitoring --operation="monitor" --branch="main" --environment="production"
datadog-management --task_type="investigate" --query_context="post-deployment validation"
datadog-management --task_type="metrics" --query_context="deployment impact analysis"
```

### Common Integration Workflows

| Skill | Integration | Output |
|-------|-------------|--------|
| `support-investigation` | Primary coordination | Error analysis, evidence collection, user impact |
| `database-operations` | Performance monitoring | Database metrics, query performance, health checks |
| `gitlab-pipeline-monitoring` | Deployment monitoring | Impact analysis, deployment correlation |
| `serena-mcp` | Code correlation | Change impact analysis, performance regression |
| `planning-workflow` | Monitoring integration | Performance planning, validation criteria |

→ **Complete integration workflows**: [workflows/integration-workflows.md](workflows/integration-workflows.md)

## Advanced Patterns

### Complex Analysis
- Multi-service error correlation with impact analysis
- Performance metrics calculation with SLA tracking
- Database performance deep analysis with optimization recommendations
- Cross-environment correlation analysis

### Sophisticated Monitoring
- Composite service health monitors with smart alerting
- Machine learning-based anomaly detection
- Performance regression detection with baseline comparison
- Cost optimization through query and metrics management

### Incident Response Automation
- Intelligent alert aggregation and correlation
- Automated evidence collection with comprehensive analysis
- Auto-recovery validation with health monitoring
- Post-incident analysis with improvement recommendations

→ **Advanced implementation patterns**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)

## Quick Reference

### Essential Commands
```bash
# Account investigation
datadog-management --task_type="investigate" --query_context="account 12345 login errors"

# Service metrics
datadog-management --task_type="metrics" --query_context="fub-api performance last 4h"

# Monitor status
datadog-management --task_type="monitor" --query_context="service alerts"

# Incident response
datadog-management --task_type="incident" --query_context="service degradation"
```

### Common Queries
```javascript
// Account errors
{ query: "@context.account_id:12345 status:error", from: "now-24h" }

// Service errors
{ query: "service:fub-api @http.status_code:>=500", from: "now-4h" }

// Performance issues
{ query: "service:fub-api @http.response_time:>5000", from: "now-1h" }

// Background job failures
{ query: "service:fub-resque @resque.job_status:failed", from: "now-6h" }
```

### MCP Resilience Integration
- Automatic health checking for production and staging MCP servers
- Circuit breaker protection for failing Datadog connections
- Intelligent retry with exponential backoff for API timeouts
- Transparent error communication with fallback to direct Datadog CLI

→ **Complete command reference and troubleshooting**: [reference/datadog-reference.md](reference/datadog-reference.md)

## Preconditions

- Datadog MCP servers (production and staging) must be accessible with automatic resilience
- Proper authentication and permissions for target Datadog environments
- Understanding of FUB service architecture and monitoring patterns
- Knowledge of incident response and escalation procedures

## Refusal Conditions

The skill must refuse if:
- Datadog MCP servers are not accessible and fallback options are exhausted
- Required authentication credentials are missing or invalid
- Query context is insufficient for targeted investigation
- Environment specification conflicts with available MCP server access
- Task type requirements cannot be met with available monitoring data

When refusing, explain which requirement prevents execution and provide specific steps to resolve the issue, including MCP server health checks, authentication verification, query context clarification, or environment access resolution procedures.

## Supporting Infrastructure

→ **Advanced patterns and complex monitoring**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
→ **Comprehensive monitoring templates and patterns**: [templates/monitoring-templates.md](templates/monitoring-templates.md)

This skill provides comprehensive Datadog observability and monitoring management while maintaining systematic investigation workflows, automated resilience, and seamless integration with FUB's development and operations ecosystem.