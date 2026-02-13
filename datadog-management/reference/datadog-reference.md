## Datadog Reference Guide and Quick Commands

### Quick Reference Commands

#### Essential Investigation Commands
```bash
# Account-specific error investigation
datadog-management --task_type="investigate" --environment="production" --query_context="account 12345 login errors"

# Service performance analysis
datadog-management --task_type="metrics" --query_context="fub-api response times last 4h"

# Monitor status validation
datadog-management --task_type="monitor" --query_context="fub-worker job failure rate"

# Dashboard review and optimization
datadog-management --task_type="dashboard" --environment="production"

# Incident response coordination
datadog-management --task_type="incident" --query_context="service degradation investigation"
```

#### Common MCP Tool Commands
```javascript
// Basic log search
mcp__datadog_production__search_logs({
  filter: { query: "service:fub-api status:error", from: "now-24h" },
  limit: 100
})

// Log aggregation
mcp__datadog_production__aggregate_logs({
  filter: { query: "service:fub-api", from: "now-24h" },
  groupBy: [{ facet: "@context.errorCode", limit: 10 }],
  compute: [{ aggregation: "count" }]
})

// Monitor status
mcp__datadog_production__get_monitors({
  monitorTags: "service:fub-api",
  groupStates: ["alert", "warn"],
  limit: 50
})
```

### FUB Service Architecture Quick Reference

#### Primary Services
- **fub-api**: API controllers (`apps/fub_api/controllers/*Controller.php`)
- **fub-csd**: Customer Service Dashboard (`apps/fub_csd/controllers/*Controller.php`)
- **fub-richdesk**: Main application (`apps/richdesk/controllers/*Controller.php`)
- **fub-worker**: Background job processing and cron jobs
- **fub-resque**: Queue workers and asynchronous processing
- **fub-spa**: Frontend JavaScript application
- **fub-mobile-api**: Mobile-specific API endpoints

#### Common Log Fields
- `@context.account_id`: Account identifier
- `@correlation_id`: Request correlation across services
- `@function`: Specific function/method being executed
- `@http.status_code`: HTTP response status
- `@http.response_time`: Response time in milliseconds
- `@database.query_time`: Database query execution time
- `@resque.job_status`: Background job status
- `service`: Service name (fub-api, fub-worker, etc.)
- `status`: Log level (info, warn, error)

### Common Search Patterns

#### Account-Specific Investigation
```javascript
// Basic account errors
{ query: "@context.account_id:12345 status:error", from: "now-24h" }

// Account performance issues
{ query: "@context.account_id:12345 @http.response_time:>5000", from: "now-4h" }

// Account activity patterns
{ query: "@context.account_id:12345", from: "now-7d" }
```

#### Service-Specific Analysis
```javascript
// API service errors
{ query: "service:fub-api @http.status_code:>=500", from: "now-4h" }

// Background job failures
{ query: "service:fub-resque @resque.job_status:failed", from: "now-6h" }

// Worker process errors
{ query: "service:fub-worker @fub_level:error", from: "now-2h" }
```

#### Function-Specific Investigation
```javascript
// Function error tracking
{ query: "@function:\"UserController::login\" status:error", from: "now-24h" }

// Database query analysis
{ query: "@function:*Model* @database.query_time:>1000", from: "now-4h" }

// Correlation tracking
{ query: "@correlation_id:\"abc-123-def\"", from: "now-1h" }
```

### Environment Configuration Reference

#### Production Environment
- **Tools**: `mcp__datadog-production__*`
- **Dashboard**: fub.datadoghq.com
- **Retention**: 15-day log retention limit
- **Monitoring**: Real-time alerting and monitoring
- **Usage**: Primary production monitoring and incident response

#### Staging Environment
- **Tools**: `mcp__datadog-staging__*`
- **Dashboard**: fubstaging.datadoghq.com
- **Purpose**: Development validation and pre-production testing
- **Usage**: QA testing, deployment validation, development monitoring

### Task Type Workflows Reference

| Task Type | Purpose | Common Query Contexts | Expected Outputs |
|-----------|---------|----------------------|------------------|
| **investigate** | Log analysis and error investigation | Account IDs, service names, error descriptions | Error patterns, correlation analysis, log samples |
| **monitor** | Monitor creation and management | Service names, metric thresholds, alert conditions | Monitor configurations, alert status, recommendations |
| **metrics** | Metrics discovery and analysis | Service names, time ranges, performance criteria | Performance analysis, trend identification, capacity data |
| **dashboard** | Dashboard management | Service names, business metrics, infrastructure data | Dashboard configurations, widget optimization, visualization |
| **incident** | Incident response coordination | Service degradation, system outages, impact assessment | Evidence collection, impact analysis, resolution tracking |

### Time Range Patterns

#### Standard Time Ranges
```javascript
// Last hour (typical real-time investigation)
{ from: "now-1h", to: "now" }

// Last 4 hours (standard investigation window)
{ from: "now-4h", to: "now" }

// Last 24 hours (daily pattern analysis)
{ from: "now-24h", to: "now" }

// Last week (trend analysis)
{ from: "now-7d", to: "now" }

// Business hours (9 AM - 6 PM EST)
{ from: "now-1d", to: "now", timezone: "America/New_York" }
```

#### Custom Time Ranges
```javascript
// Specific time window
{
  from: Math.floor(new Date('2024-01-15T14:00:00Z').getTime() / 1000),
  to: Math.floor(new Date('2024-01-15T16:00:00Z').getTime() / 1000)
}

// Deployment correlation window
{
  from: deploymentTimestamp - 1800,  // 30 minutes before
  to: deploymentTimestamp + 3600     // 1 hour after
}
```

### Troubleshooting Guide

#### Common Issues and Solutions

| Issue | Symptoms | Solution |
|-------|----------|----------|
| **MCP Connection Failed** | Tool timeouts, connection errors | Check MCP server status, retry with exponential backoff |
| **Query Timeout** | Long-running queries, no response | Reduce time range, add service filters, use pagination |
| **No Results Found** | Empty result sets | Verify query syntax, check time range, validate service names |
| **Rate Limit Exceeded** | API rate limit errors | Implement request throttling, reduce query frequency |
| **Invalid Query Syntax** | Query parsing errors | Validate query syntax, check field names, escape special characters |
| **Authentication Failed** | Permission denied errors | Verify Datadog API credentials, check environment configuration |

#### Query Optimization Guidelines

**Performance Optimization:**
```javascript
// Good: Specific time range and service filter
{
  query: "service:fub-api status:error",
  from: "now-1h",
  to: "now",
  limit: 50
}

// Poor: Broad query without filters
{
  query: "status:error",
  from: "now-7d",
  to: "now",
  limit: 1000
}
```

**Cost Optimization:**
- Use specific time ranges to limit data scanning
- Include service filters to reduce result set size
- Implement proper WHERE clauses in aggregations
- Use pagination for large result sets
- Limit aggregation facet cardinality

#### Error Message Troubleshooting

**Common Error Patterns:**
```bash
# Connection timeout
Error: "Request timeout after 30000ms"
Solution: Retry with exponential backoff, check MCP server health

# Invalid query syntax
Error: "Query parsing failed at position X"
Solution: Validate query syntax, check field names, escape special characters

# Rate limit exceeded
Error: "Rate limit exceeded, retry after X seconds"
Solution: Implement request throttling, reduce query frequency

# No data found
Error: "No results found for query"
Solution: Verify time range, check service names, validate query filters
```

### Monitor Configuration Reference

#### Standard Monitor Thresholds
- **Error Rate**: Warning: 3%, Critical: 5%
- **Response Time**: Warning: 2000ms, Critical: 5000ms
- **Request Volume**: Warning: -30% change, Critical: -50% change
- **Database Query Time**: Warning: 1000ms, Critical: 3000ms
- **Job Failure Rate**: Warning: 5 failures/15min, Critical: 10 failures/15min

#### Alert Escalation Patterns
```javascript
// Standard escalation timing
{
  renotify_interval: 60,        // Re-alert every 60 minutes
  escalation_delay: 15,         // Escalate after 15 minutes
  recovery_delay: 5,            // Wait 5 minutes before recovery
  auto_resolve: false           // Manual resolution required
}

// Critical service escalation
{
  renotify_interval: 15,        // Re-alert every 15 minutes
  escalation_delay: 5,          // Escalate after 5 minutes
  recovery_delay: 2,            // Wait 2 minutes before recovery
  notify_audit: true,           // Audit all notifications
  priority: 1                   // Highest priority
}
```

### Dashboard Widget Reference

#### Common Widget Types
- **Timeseries**: Line graphs for metrics over time
- **Query Value**: Single metric values with thresholds
- **Toplist**: Ranked lists of metrics
- **Heatmap**: Distribution of values across dimensions
- **Log Stream**: Real-time log display
- **SLO**: Service level objective tracking

#### Widget Configuration Patterns
```javascript
// Performance timeseries widget
{
  type: "timeseries",
  requests: [{
    q: "avg:trace.web.request.duration{service:fub-api}",
    display_type: "line"
  }],
  title: "API Response Time"
}

// Error rate query value widget
{
  type: "query_value",
  requests: [{
    q: "sum:trace.web.request.errors{service:fub-api}.as_count() / sum:trace.web.request.hits{service:fub-api}.as_count()"
  }],
  title: "Current Error Rate (%)"
}
```

### Investigation Workflow Templates

#### Standard Investigation Process
1. **Context Gathering**: Collect account ID, timeframe, service scope
2. **Initial Search**: Broad error pattern search
3. **Pattern Analysis**: Identify error frequency and distribution
4. **Correlation Analysis**: Cross-service and timeline correlation
5. **Evidence Collection**: Gather log samples and metrics
6. **Impact Assessment**: Determine business and technical impact
7. **Documentation**: Record findings with supporting evidence

#### Incident Response Checklist
- [ ] Identify affected services and scope of impact
- [ ] Collect error patterns and frequency data
- [ ] Analyze timeline correlation with deployments
- [ ] Gather performance impact metrics
- [ ] Document user impact and business consequences
- [ ] Coordinate with relevant teams for resolution
- [ ] Monitor recovery and validate system health
- [ ] Create post-incident analysis and recommendations

### Performance Benchmarks

#### SLA Targets
- **API Response Time**: 95th percentile < 2000ms
- **Error Rate**: < 1% for critical endpoints
- **Availability**: > 99.9% uptime
- **Database Query Time**: 95th percentile < 500ms
- **Background Job Processing**: < 5 minutes average processing time

#### Capacity Planning Metrics
- **Request Volume**: Track trends and growth patterns
- **Resource Utilization**: Monitor CPU, memory, and database connections
- **Error Distribution**: Identify error hotspots and patterns
- **Performance Trends**: Track response time degradation over time

This reference guide provides essential information for efficient Datadog monitoring and investigation in the FUB environment.