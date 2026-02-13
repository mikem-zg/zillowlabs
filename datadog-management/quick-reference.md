# Datadog Management Quick Reference

Fast reference for common FUB Datadog operations using Claude Code MCP tools.

## Skill Invocation

```
/datadog-management task_type="investigate" environment="production" query_context="account 12345 login errors last 24h"
```

**Task Types:**
- `investigate` - Log analysis and error investigation
- `monitor` - Monitor creation and management
- `dashboard` - Dashboard management
- `metrics` - Metrics analysis
- `incident` - Incident response

**Environments:**
- `production` (default) - fub.datadoghq.com
- `staging` - fubstaging.datadoghq.com

## Investigation Quick Commands

### Account Error Investigation

**Find account-specific errors:**
```javascript
// Query context: "account 12345 errors"
{
  filter: {
    query: "@context.account_id:12345 status:error",
    from: "now-24h"
  },
  limit: 50
}
```

### Service Health Check

**Check API service errors:**
```javascript
// Query context: "fub-api errors last 1h"
{
  filter: {
    query: "service:fub-api status:error",
    from: "now-1h",
    to: "now"
  },
  limit: 100
}
```

### Performance Analysis

**Find slow operations:**
```javascript
// Query context: "fub performance slow responses"
{
  filter: {
    query: "service:fub @http.response_time:>5000",
    from: "now-1h",
    to: "now"
  },
  limit: 100
}
```

## Common MCP Tool Calls

### Search Production Logs

```javascript
await mcp_datadog_production.search_logs({
  filter: {
    query: "service:fub-api @account_id:12345 status:error",
    from: "now-24h"
  },
  limit: 50
});
```

### Aggregate Error Patterns

```javascript
await mcp_datadog_production.aggregate_logs({
  filter: {
    query: "service:fub status:error",
    from: "now-1h",
    to: "now"
  },
  groupBy: [
    { facet: "@context.errorCode", limit: 10 }
  ],
  compute: [{ aggregation: "count" }]
});
```

### Check Monitor Status

```javascript
await mcp_datadog_production.get_monitors({
  monitorTags: "team:zyno",
  groupStates: ["alert", "warn"],
  limit: 50
});
```

### Find Metrics

```javascript
await mcp_datadog_production.get_metrics({
  q: "fubweb.*"
});
```

## FUB Service Reference

**Service Names:**
- `fub-api` - API controllers (`apps/fub_api/controllers/*Controller.php`)
- `fub-csd` - Customer Service Dashboard (`apps/fub_csd/controllers/*Controller.php`)
- `fub-richdesk` - Main application (`apps/richdesk/controllers/*Controller.php`)
- `fub-worker` - Background jobs and cron
- `fub-resque` - Queue workers and async processing
- `fub-spa` - Frontend JavaScript

**Log Fields:**
- `@context.account_id` - FUB account ID
- `@context.errorCode` - Application error codes
- `@correlation_id` - Request tracking
- `@function` - Function names (e.g., `"li3:smartlist:perform"`)
- `@fub_level` - FUB log levels (error, warning, info)
- `@http.response_time` - Response timing
- `status` - Log status (error, info, warn)

## Time Ranges (From Production Usage)

**Investigation Windows:**
- `now-15m` - Recent errors/monitoring
- `now-1h` - Standard investigation
- `now-3h` - Extended investigation
- `now-24h` - Daily analysis
- `now-1w` - Historical patterns

## Team Tags and Channels

**Monitor Tags:**
- `team:zyno` - Application development
- `team:infrastructure` - Infrastructure
- `team:integrations` - Third-party integrations

**Slack Channels:**
- `#fub-zyno-alerts` - Application alerts
- `#fub-infrastructure` - Infrastructure alerts
- On-call: `@fub-zyno-oncall`

## Investigation Workflow Templates

### Standard Error Investigation

1. **Account-specific search:**
   ```javascript
   query: "@context.account_id:XXXXX status:error"
   from: "now-24h"
   ```

2. **Error pattern analysis:**
   ```javascript
   groupBy: [{ facet: "@context.errorCode", limit: 10 }]
   compute: [{ aggregation: "count" }]
   ```

3. **Monitor status check:**
   ```javascript
   monitorTags: "service:fub"
   groupStates: ["alert", "warn"]
   ```

### Performance Investigation

1. **Slow response detection:**
   ```javascript
   query: "service:fub @http.response_time:>5000"
   from: "now-1h"
   ```

2. **Performance metrics:**
   ```javascript
   compute: [
     { aggregation: "avg", metric: "@http.response_time" },
     { aggregation: "max", metric: "@http.response_time" }
   ]
   ```

3. **Metric metadata:**
   ```javascript
   metricName: "fubweb.performance.response_time"
   ```

## Common Error Patterns

### OAuth Issues
```javascript
query: "message:\"OAuth\" service:fub @fub_level:error"
```

### Database Performance
```javascript
query: "service:fub @database.query_time:>1000"
```

### Background Job Failures
```javascript
query: "service:fub-resque @resque.job_status:failed"
```

### Correlation ID Tracking
```javascript
query: "@correlation_id:\"abc-123-def\""
```

## Monitor Quick Setup

### Error Rate Monitor
```json
{
  "query": "sum(last_5m):sum:trace.web.request.errors{service:fub-api}.as_count() / sum:trace.web.request.hits{service:fub-api}.as_count() > 0.05",
  "thresholds": { "critical": 0.05, "warning": 0.02 },
  "tags": ["team:zyno", "service:fub-api"]
}
```

### Response Time Monitor
```json
{
  "query": "avg(last_10m):avg:trace.web.request.duration{service:fub-api} > 2000",
  "thresholds": { "critical": 2000, "warning": 1500 },
  "tags": ["team:zyno", "service:fub-api", "performance"]
}
```

## Production Links

**Datadog Instances:**
- Production: [fub.datadoghq.com](https://fub.datadoghq.com/)
- Staging: [fubstaging.datadoghq.com](https://fubstaging.datadoghq.com/)

**Log Search Templates:**
- [API Errors](https://fub.datadoghq.com/logs?query=service%3Afub-api%20status%3Aerror)
- [Account Errors](https://fub.datadoghq.com/logs?query=%40context.account_id%3A12345%20status%3Aerror)
- [OAuth Errors](https://fub.datadoghq.com/logs?query=message%3A%22OAuth%22%20service%3Afub%20%40fub_level%3Aerror)

**Cost Monitoring:**
- [Cost Summary](https://fub.datadoghq.com/cost/overview/summary)

## Troubleshooting

### Query Too Slow
- Add service filter: `service:fub-api`
- Reduce time range: `now-1h` instead of `now-24h`
- Add account filter: `@context.account_id:XXXXX`
- Use smaller result limit: `limit: 25`

### No Results Found
- Check time range is correct
- Verify service names (fub-api vs fub_api)
- Check field names (@context.account_id vs @account_id)
- Try broader search first, then narrow

### Monitor Not Alerting
- Verify query syntax with log search first
- Check threshold values are appropriate
- Confirm notification channels are correct
- Test with manual data injection

### High Datadog Costs
- Review high-cardinality metrics
- Check log retention policies
- Monitor service tag usage
- Use Cost Summary dashboard for attribution

All patterns in this reference are from actual FUB production usage and established team workflows.