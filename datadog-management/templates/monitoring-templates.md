## Datadog Monitoring Templates and Common Patterns

### Log Search Templates

#### Account-Specific Investigation
```javascript
// Basic account error search
mcp__datadog_production__search_logs({
  filter: {
    query: "@context.account_id:12345 status:error",
    from: "now-24h",
    to: "now"
  },
  limit: 100
});

// Account performance analysis
mcp__datadog_production__search_logs({
  filter: {
    query: "@context.account_id:12345 @http.response_time:>5000",
    from: "now-4h",
    to: "now"
  },
  limit: 50
});

// Account correlation tracking
mcp__datadog_production__search_logs({
  filter: {
    query: "@context.account_id:12345 @correlation_id:*",
    from: "now-1h",
    to: "now"
  }
});
```

#### Service-Specific Analysis
```javascript
// API service errors
mcp__datadog_production__search_logs({
  filter: {
    query: "service:fub-api @http.status_code:>=500",
    from: "now-4h",
    to: "now"
  },
  limit: 50
});

// API performance monitoring
mcp__datadog_production__search_logs({
  filter: {
    query: "service:fub-api @http.response_time:>5000",
    from: "now-1h",
    to: "now"
  }
});

// Background job monitoring
mcp__datadog_production__search_logs({
  filter: {
    query: "service:fub-resque @resque.job_status:failed",
    from: "now-6h",
    to: "now"
  }
});

// Worker process analysis
mcp__datadog_production__search_logs({
  filter: {
    query: "service:fub-worker @fub_level:error",
    from: "now-2h",
    to: "now"
  }
});
```

#### Function-Specific Investigation
```javascript
// Function error tracking
mcp__datadog_production__search_logs({
  filter: {
    query: "@function:\"UserController::login\" status:error",
    from: "now-24h",
    to: "now"
  }
});

// Database query analysis
mcp__datadog_production__search_logs({
  filter: {
    query: "@function:*Model* @database.query_time:>1000",
    from: "now-4h",
    to: "now"
  }
});
```

### Aggregation Templates

#### Error Rate Calculation
```javascript
// Service error rate over time
mcp__datadog_production__aggregate_logs({
  filter: {
    query: "service:fub-api",
    from: "now-24h",
    to: "now"
  },
  groupBy: [
    { facet: "@http.status_code", limit: 10 },
    { facet: "@timeseries", limit: 100 }
  ],
  compute: [{ aggregation: "count" }]
});

// Account error distribution
mcp__datadog_production__aggregate_logs({
  filter: {
    query: "status:error",
    from: "now-24h",
    to: "now"
  },
  groupBy: [
    { facet: "@context.account_id", limit: 20 },
    { facet: "service", limit: 10 }
  ],
  compute: [
    { aggregation: "count" },
    { aggregation: "cardinality", metric: "@correlation_id" }
  ]
});
```

#### Performance Analysis
```javascript
// Response time percentiles
mcp__datadog_production__aggregate_logs({
  filter: {
    query: "service:fub-api @http.status_code:200",
    from: "now-1h",
    to: "now"
  },
  compute: [
    { aggregation: "avg", metric: "@http.response_time" },
    { aggregation: "max", metric: "@http.response_time" },
    { aggregation: "pc95", metric: "@http.response_time" },
    { aggregation: "pc99", metric: "@http.response_time" }
  ]
});

// Database performance analysis
mcp__datadog_production__aggregate_logs({
  filter: {
    query: "service:(fub-api OR fub-worker) @database.query_time:>0",
    from: "now-4h",
    to: "now"
  },
  groupBy: [{ facet: "@database.table", limit: 20 }],
  compute: [
    { aggregation: "avg", metric: "@database.query_time" },
    { aggregation: "max", metric: "@database.query_time" }
  ]
});
```

### Monitor Templates

#### Critical Service Monitors

**API Error Rate Monitor**
```javascript
{
  query: "sum(last_5m):sum:trace.web.request.errors{service:fub-api}.as_count() / sum:trace.web.request.hits{service:fub-api}.as_count() > 0.05",
  name: "FUB API Error Rate Critical",
  message: "API error rate exceeded 5% threshold @fub-zyno-alerts",
  tags: ["service:fub-api", "team:zyno", "critical"],
  thresholds: { critical: 0.05, warning: 0.03 },
  type: "metric alert",
  options: {
    thresholds: { critical: 0.05, warning: 0.03 },
    notify_audit: false,
    require_full_window: false,
    notify_no_data: true,
    renotify_interval: 0,
    evaluation_delay: 60
  }
}
```

**Background Job Failure Monitor**
```javascript
{
  query: "sum(last_15m):sum:resque.failed{service:fub-resque}.as_count() > 10",
  name: "FUB Background Job Failures",
  message: "High job failure rate detected @fub-infrastructure",
  tags: ["service:fub-resque", "team:infrastructure"],
  thresholds: { critical: 10, warning: 5 },
  type: "metric alert",
  options: {
    thresholds: { critical: 10, warning: 5 },
    notify_audit: false,
    require_full_window: true,
    notify_no_data: false,
    renotify_interval: 30
  }
}
```

**Database Connection Monitor**
```javascript
{
  query: "avg(last_5m):avg:mysql.net.connections{host:*} > 80",
  name: "FUB Database Connection Count High",
  message: "Database connection count is high, potential connection leak @fub-database-team",
  tags: ["service:mysql", "team:database", "warning"],
  thresholds: { critical: 100, warning: 80 },
  type: "metric alert"
}
```

#### Anomaly Detection Monitors

**Request Volume Anomaly**
```javascript
{
  query: "anomalies(avg(last_4h):sum:trace.web.request.hits{service:fub-api}.as_rate(), 'basic', 2, direction='below', alert_window='last_15m', interval=60, count_default_zero='true')",
  name: "FUB API Request Volume Anomaly",
  message: "Unusual drop in API request volume detected - possible service issue @fub-oncall",
  tags: ["service:fub-api", "anomaly-detection", "volume"],
  type: "query alert",
  options: {
    thresholds: { critical: 1 },
    notify_audit: false,
    require_full_window: false,
    notify_no_data: false,
    renotify_interval: 60
  }
}
```

**Response Time Anomaly**
```javascript
{
  query: "anomalies(avg(last_1h):avg:trace.web.request.duration{service:fub-api}.as_count(), 'agile', 2, direction='above', alert_window='last_5m', interval=60)",
  name: "FUB API Response Time Anomaly",
  message: "API response time showing unusual patterns @fub-performance-team",
  tags: ["service:fub-api", "anomaly-detection", "performance"],
  type: "query alert"
}
```

### Dashboard Templates

#### Service Health Dashboard
```javascript
{
  title: "FUB Service Health Overview",
  description: "Comprehensive monitoring dashboard for FUB services",
  template_variables: [
    {
      name: "service",
      default: "fub-api",
      prefix: "service"
    },
    {
      name: "env",
      default: "production",
      prefix: "env"
    }
  ],
  widgets: [
    // Request Volume Widget
    {
      definition: {
        type: "timeseries",
        requests: [{
          q: "sum:trace.web.request.hits{service:$service,env:$env}.as_rate()",
          display_type: "line",
          style: {
            palette: "dog_classic",
            line_type: "solid",
            line_width: "normal"
          }
        }],
        title: "Request Volume (req/s)",
        yaxis: {
          scale: "linear",
          min: "auto",
          max: "auto"
        }
      },
      layout: { x: 0, y: 0, width: 4, height: 3 }
    },

    // Error Rate Widget
    {
      definition: {
        type: "query_value",
        requests: [{
          q: "sum:trace.web.request.errors{service:$service,env:$env}.as_count() / sum:trace.web.request.hits{service:$service,env:$env}.as_count()",
          aggregator: "last"
        }],
        title: "Current Error Rate (%)",
        precision: 2,
        text_align: "center"
      },
      layout: { x: 4, y: 0, width: 2, height: 3 }
    },

    // Response Time Widget
    {
      definition: {
        type: "timeseries",
        requests: [
          {
            q: "avg:trace.web.request.duration{service:$service,env:$env}.as_count()",
            display_type: "line",
            style: { palette: "warm" }
          },
          {
            q: "p95:trace.web.request.duration{service:$service,env:$env}.as_count()",
            display_type: "line",
            style: { palette: "orange" }
          }
        ],
        title: "Response Time (ms)",
        yaxis: { scale: "linear" }
      },
      layout: { x: 6, y: 0, width: 4, height: 3 }
    }
  ]
}
```

#### Account-Specific Investigation Dashboard
```javascript
{
  title: "Account Investigation Dashboard",
  template_variables: [
    {
      name: "account_id",
      default: "*",
      prefix: "@context.account_id"
    }
  ],
  widgets: [
    // Account Activity Widget
    {
      definition: {
        type: "timeseries",
        requests: [{
          q: "sum:trace.web.request.hits{@context.account_id:$account_id}.as_rate()",
          display_type: "bars"
        }],
        title: "Account Activity"
      }
    },

    // Account Errors Widget
    {
      definition: {
        type: "toplist",
        requests: [{
          q: "top(sum:log.error{@context.account_id:$account_id} by {service,@context.errorCode}, 10, 'sum', 'desc')"
        }],
        title: "Top Errors by Service"
      }
    }
  ]
}
```

### Event and Incident Templates

#### Deployment Event Search
```javascript
// Find recent deployments
mcp__datadog_production__get_events({
  start: Math.floor(Date.now() / 1000) - 3600,
  end: Math.floor(Date.now() / 1000),
  sources: "deployment",
  tags: "env:production"
});

// Correlate deployment with errors
mcp__datadog_production__search_logs({
  filter: {
    query: "service:fub-api status:error",
    from: "now-1h",  // Adjust based on deployment time
    to: "now"
  }
});
```

#### Incident Evidence Collection
```javascript
// Comprehensive incident data gathering
async function collectIncidentEvidence(accountId, timeRange) {
  const evidence = {};

  // Error patterns
  evidence.errors = await mcp__datadog_production__search_logs({
    filter: {
      query: `@context.account_id:${accountId} status:error`,
      from: timeRange.from,
      to: timeRange.to
    }
  });

  // Performance metrics
  evidence.performance = await mcp__datadog_production__aggregate_logs({
    filter: {
      query: `@context.account_id:${accountId}`,
      from: timeRange.from,
      to: timeRange.to
    },
    compute: [
      { aggregation: "avg", metric: "@http.response_time" },
      { aggregation: "count" }
    ]
  });

  // Related monitors
  evidence.monitors = await mcp__datadog_production__get_monitors({
    groupStates: ["alert", "warn"],
    tags: `account:${accountId}`
  });

  return evidence;
}
```

### Common Time Range Patterns

#### Standard Time Ranges
```javascript
// Last hour
{ from: "now-1h", to: "now" }

// Last 4 hours (standard investigation window)
{ from: "now-4h", to: "now" }

// Last 24 hours (daily pattern analysis)
{ from: "now-24h", to: "now" }

// Last week (trend analysis)
{ from: "now-7d", to: "now" }

// Custom range with epoch timestamps
{
  from: Math.floor(Date.now() / 1000) - 3600,  // 1 hour ago
  to: Math.floor(Date.now() / 1000)            // now
}
```

#### Business Hours Patterns
```javascript
// Business hours only (9 AM - 6 PM EST)
{
  from: "now-1d",
  to: "now",
  timezone: "America/New_York"
}
```

### FUB Service Architecture Reference

#### Primary Services
- **fub-api**: API controllers (`apps/fub_api/controllers/*Controller.php`)
- **fub-csd**: Customer Service Dashboard (`apps/fub_csd/controllers/*Controller.php`)
- **fub-richdesk**: Main application controllers (`apps/richdesk/controllers/*Controller.php`)
- **fub-worker**: Background job processing and cron jobs
- **fub-resque**: Queue workers and asynchronous processing
- **fub-spa**: Frontend JavaScript application
- **fub-mobile-api**: Mobile-specific API endpoints

#### Common Log Fields
- `@context.account_id`: Account identifier for customer-specific investigations
- `@correlation_id`: Request correlation across services
- `@function`: Specific function/method being executed
- `@http.status_code`: HTTP response status
- `@http.response_time`: Response time in milliseconds
- `@database.query_time`: Database query execution time
- `@resque.job_status`: Background job status
- `service`: Service name (fub-api, fub-worker, etc.)
- `status`: Log level (info, warn, error)

These templates provide the foundation for most Datadog monitoring and investigation tasks in the FUB environment.