# Verified Datadog Query Examples for FUB

Production-proven Datadog query patterns extracted from actual FUB usage, reference documentation, and established investigation workflows.

## Verified Log Search Queries

All queries below are sourced from actual FUB production patterns and established investigation workflows.

### Account-Specific Investigation (Proven Patterns)

**Basic account error search (from support-investigation workflow):**
```javascript
{
  filter: {
    query: "@context.account_id:12345 status:error",
    from: "now-24h"
  },
  limit: 50
}
```

**Apache logs account search (from support-investigation patterns):**
```javascript
{
  filter: {
    query: "@context.account_id:12345 source:apache",
    from: "now-24h",
    to: "now"
  },
  limit: 100
}
```

**Account-specific API errors (from MCP integration examples):**
```javascript
{
  filter: {
    query: "service:fub-api @account_id:12345 status:error",
    from: "now-24h"
  },
  limit: 50
}
```

### Service-Specific Queries (From FUB Architecture Documentation)

**FUB API service errors (from observability patterns):**
```javascript
{
  filter: {
    query: "service:fub status:error",
    from: "now-1h",
    to: "now"
  },
  limit: 100
}
```

**Service-specific searches (from support-investigation):**
- `service:fub-api` - API controllers and endpoints
- `service:fub-csd` - CSD controllers and user interface
- `service:fub-richdesk` - Richdesk controllers and functionality
- `service:fub-worker` - Background jobs and async processing
- `service:fub-resque` - Queue workers and job processing

### OAuth and Authentication (From Production Patterns)

**OAuth error detection (from common query examples):**
```javascript
{
  filter: {
    query: "message:\"OAuth\" service:fub @fub_level:error",
    from: "now-1h",
    to: "now"
  }
}
```

### Performance Analysis (From Observability Patterns)

**Slow operations detection (from performance investigation pattern):**
```javascript
{
  filter: {
    query: "service:fub @http.response_time:>5000",
    from: "now-1h",
    to: "now"
  },
  limit: 100
}
```

**Database query performance (from common query examples):**
```javascript
{
  filter: {
    query: "service:fub @database.query_time:>1000",
    from: "now-1h",
    to: "now"
  },
  limit: 100
}
```

**Performance metrics calculation (from observability patterns):**
```javascript
{
  filter: {
    query: "service:fub @http.status_code:200",
    from: "now-1h",
    to: "now"
  },
  compute: [
    { aggregation: "avg", metric: "@http.response_time" },
    { aggregation: "max", metric: "@http.response_time" },
    { aggregation: "percentile", metric: "@http.response_time" }
  ]
}
```

### Correlation ID Tracking (From Support Investigation)

**Full request trace by correlation ID (from support-investigation patterns):**
```javascript
{
  filter: {
    query: "@correlation_id:\"abc-123-def\"",
    from: "now-1h",
    to: "now"
  }
}
```

### Function-Specific Analysis (From Support Investigation)

**Function-specific searches (from support-investigation patterns):**
```javascript
{
  filter: {
    query: "@function:\"li3:smartlist:perform\"",
    from: "now-2h",
    to: "now"
  }
}
```

**Time-based analysis (from support-investigation patterns):**
```javascript
{
  filter: {
    query: "service:fub-api @account_id:12345 @timestamp:[now-24h TO now]"
  }
}
```

## Verified Log Aggregation Queries

### Error Pattern Analysis (From Observability Patterns)

**Error count by service (from common query examples):**
```javascript
{
  filter: {
    query: "status:error",
    from: "now-1h",
    to: "now"
  },
  groupBy: [
    { facet: "service", limit: 10 }
  ],
  compute: [{ aggregation: "count" }]
}
```

**Error code pattern analysis (from error investigation pattern):**
```javascript
{
  filter: {
    query: "service:fub status:error",
    from: "now-1h",
    to: "now"
  },
  groupBy: [
    {
      facet: "@context.errorCode",
      limit: 10,
      sort: { aggregation: "count", order: "desc" }
    }
  ],
  compute: [{ aggregation: "count" }]
}
```

## Verified Monitor and Metrics Queries

### Monitor Management (From Observability Patterns)

**Team-specific monitor alerts (from common query examples):**
```javascript
{
  monitorTags: "team:zyno",
  groupStates: ["alert"],
  limit: 50
}
```

**Service-specific monitor check (from error investigation pattern):**
```javascript
{
  monitorTags: "service:fub",
  groupStates: ["alert", "warn"]
}
```

### Metrics Analysis (From Production Usage)

**FUB performance metrics (from performance investigation pattern):**
```javascript
{
  metricName: "fubweb.performance.response_time"
}
```

**Error metrics query (from MCP integration examples):**
```javascript
{
  q: "fub.api.errors{service:authentication}"
}
```

**FUB web metrics search (from Confluence documentation):**
```javascript
{
  q: "fubweb.*"
}
```

## Verified Event and Deployment Queries

### Deployment Event Correlation (From Observability Patterns)

**Find deployment events (from deployment correlation pattern):**
```javascript
{
  start: 1727222400,  // Unix timestamp
  end: 1727827200,
  sources: "deployment",
  tags: "env:production"
}
```

**Deployment events for today (from common query examples):**
```javascript
{
  start: Math.floor(new Date().setHours(0,0,0,0) / 1000),
  end: Math.floor(Date.now() / 1000),
  sources: "deployment",
  tags: "env:production"
}
```

**Post-deployment log analysis (from deployment correlation pattern):**
```javascript
{
  filter: {
    query: "service:fub status:error",
    from: "now-30m",
    to: "now"
  },
  limit: 100
}
```

## Production-Validated Investigation Workflows

### Workflow 1: Error Investigation (From Support Investigation Skill)

**Step 1 - Account error search:**
```javascript
const logs = await mcp_datadog_production.search_logs({
  filter: {
    query: "service:fub-api @account_id:12345 status:error",
    from: "now-24h"
  },
  limit: 50
});
```

**Step 2 - Error pattern aggregation:**
```javascript
const patterns = await mcp_datadog_production.aggregate_logs({
  filter: {
    query: "service:fub status:error",
    from: "now-1h",
    to: "now"
  },
  groupBy: [
    {
      facet: "@context.errorCode",
      limit: 10,
      sort: { aggregation: "count", order: "desc" }
    }
  ],
  compute: [{ aggregation: "count" }]
});
```

**Step 3 - Related monitor check:**
```javascript
const monitors = await mcp_datadog_production.get_monitors({
  monitorTags: "service:fub",
  groupStates: ["alert", "warn"]
});
```

### Workflow 2: Performance Investigation (From Observability Patterns)

**Step 1 - Slow operation detection:**
```javascript
{
  filter: {
    query: "service:fub @http.response_time:>5000",
    from: "now-1h",
    to: "now"
  },
  limit: 100
}
```

**Step 2 - Performance metrics calculation:**
```javascript
{
  filter: {
    query: "service:fub @http.status_code:200",
    from: "now-1h",
    to: "now"
  },
  compute: [
    { aggregation: "avg", metric: "@http.response_time" },
    { aggregation: "max", metric: "@http.response_time" },
    { aggregation: "percentile", metric: "@http.response_time" }
  ]
}
```

**Step 3 - Performance metric lookup:**
```javascript
{
  metricName: "fubweb.performance.response_time"
}
```

## Field Reference (From FUB Production Logs)

### Verified Context Fields
- `@context.account_id` - FUB account identifier
- `@context.errorCode` - Application error codes
- `@context.userId` - User performing action
- `@correlation_id` - Request correlation tracking
- `@function` - Specific function names (e.g., "li3:smartlist:perform")
- `@fub_level` - FUB-specific log levels (error, warning, info)

### Verified HTTP Fields
- `@http.response_time` - Response time in milliseconds
- `@http.status_code` - HTTP status codes
- `@http.url_details.path` - API endpoint paths

### Verified Service Names
- `service:fub-api` - API service
- `service:fub-csd` - Customer Service Dashboard
- `service:fub-richdesk` - Main application
- `service:fub-worker` - Background workers
- `service:fub-resque` - Queue workers

### Verified Metric Names (From Confluence Documentation)
- `fubweb.*` - FUB web application metrics
- `fubweb.performance.response_time` - Response timing
- `fub.api.errors{service:authentication}` - API error metrics

## Query Efficiency Guidelines (From Production Experience)

### Verified Best Practices

1. **Always include time ranges** (from observability patterns)
   ```javascript
   from: "now-1h", to: "now"  // Standard pattern
   ```

2. **Use service filters for FUB** (from all examples)
   ```javascript
   "service:fub status:error"  // Combines service + status
   ```

3. **Account ID is critical for investigations** (from support patterns)
   ```javascript
   "@context.account_id:12345 status:error"
   ```

4. **Standard result limits** (from production usage)
   - Investigation queries: 50-100 results
   - Pattern analysis: 25-50 results
   - Monitor checks: 50 results

### Verified Time Ranges (From Production Patterns)

- `now-15m` - Recent errors (monitoring)
- `now-1h` - Standard investigation window
- `now-3h` - Extended investigation
- `now-24h` - Daily pattern analysis
- `now-1d` to `now-1w` - Historical analysis

All patterns in this document are extracted from actual FUB production usage, established investigation workflows, and official FUB documentation. They represent proven, working query patterns that have been validated in production environments.