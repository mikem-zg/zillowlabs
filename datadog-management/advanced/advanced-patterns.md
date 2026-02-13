## Advanced Datadog Patterns and Complex Analysis

### Complex Log Aggregation and Analysis

#### Multi-Service Error Correlation
```javascript
// Aggregate errors across all FUB services with impact analysis
await mcp__datadog_production__aggregate_logs({
  filter: {
    query: "status:error service:(fub-api OR fub-worker OR fub-resque OR fub-csd OR fub-richdesk)",
    from: "now-24h",
    to: "now"
  },
  groupBy: [
    { facet: "service", limit: 10 },
    { facet: "@context.errorCode", limit: 20 },
    { facet: "@timeseries", limit: 288 } // 5-minute buckets over 24h
  ],
  compute: [
    { aggregation: "count" },
    { aggregation: "cardinality", metric: "@context.account_id" },
    { aggregation: "cardinality", metric: "@correlation_id" }
  ]
});

// Cross-service correlation analysis
await mcp__datadog_production__search_logs({
  filter: {
    query: "@correlation_id:* status:error",
    from: "now-4h",
    to: "now"
  },
  sort: "timestamp",
  limit: 200
}).then(logs => {
  // Group by correlation_id to trace request paths
  const correlationMap = logs.reduce((acc, log) => {
    const corrId = log.attributes['@correlation_id'];
    if (!acc[corrId]) acc[corrId] = [];
    acc[corrId].push({
      service: log.service,
      timestamp: log.timestamp,
      message: log.message,
      function: log.attributes['@function']
    });
    return acc;
  }, {});

  // Identify cascading failures
  Object.entries(correlationMap).forEach(([corrId, events]) => {
    if (events.length > 1) {
      console.log(`Cascade detected for ${corrId}:`, events);
    }
  });
});
```

#### Advanced Performance Metrics Calculation
```javascript
// Comprehensive performance analysis with percentiles and SLA tracking
await mcp__datadog_production__aggregate_logs({
  filter: {
    query: "service:fub-api @http.status_code:200",
    from: "now-24h",
    to: "now"
  },
  groupBy: [
    { facet: "@http.method", limit: 10 },
    { facet: "@http.url_details.path", limit: 50 },
    { facet: "@timeseries", limit: 288 }
  ],
  compute: [
    { aggregation: "count" },
    { aggregation: "avg", metric: "@http.response_time" },
    { aggregation: "min", metric: "@http.response_time" },
    { aggregation: "max", metric: "@http.response_time" },
    { aggregation: "pc50", metric: "@http.response_time" },
    { aggregation: "pc90", metric: "@http.response_time" },
    { aggregation: "pc95", metric: "@http.response_time" },
    { aggregation: "pc99", metric: "@http.response_time" },
    { aggregation: "pc99.9", metric: "@http.response_time" }
  ]
}).then(results => {
  // Calculate SLA compliance (< 2000ms for 95% of requests)
  const slaThreshold = 2000;
  const slaCompliance = results.buckets.map(bucket => ({
    timestamp: bucket.by['@timeseries'],
    slaCompliant: bucket.by['pc95'] < slaThreshold,
    p95ResponseTime: bucket.by['pc95']
  }));

  console.log('SLA Compliance Analysis:', slaCompliance);
});
```

#### Database Performance Deep Analysis
```javascript
// Complex database performance correlation
await mcp__datadog_production__aggregate_logs({
  filter: {
    query: "service:(fub-api OR fub-worker) @database.query_time:>0",
    from: "now-4h",
    to: "now"
  },
  groupBy: [
    { facet: "@database.statement", limit: 100 },
    { facet: "@database.table", limit: 50 },
    { facet: "service", limit: 10 },
    { facet: "@function", limit: 100 }
  ],
  compute: [
    { aggregation: "count" },
    { aggregation: "sum", metric: "@database.query_time" },
    { aggregation: "avg", metric: "@database.query_time" },
    { aggregation: "max", metric: "@database.query_time" },
    { aggregation: "pc95", metric: "@database.query_time" }
  ]
}).then(results => {
  // Identify slow queries and patterns
  const slowQueries = results.buckets
    .filter(bucket => bucket.by.avg > 1000) // > 1 second average
    .sort((a, b) => b.by.sum - a.by.sum) // Sort by total time impact
    .slice(0, 10);

  console.log('Top 10 Slow Query Patterns:', slowQueries);
});
```

### Advanced Monitor Configuration

#### Composite Service Health Monitors
```javascript
// Multi-service health composite monitor
const serviceHealthComposite = {
  name: "FUB Platform Health Composite",
  type: "composite",
  query: "(a && b && c) || d",
  message: "FUB platform experiencing degraded performance across multiple services @fub-oncall @fub-leadership",
  tags: ["service:platform", "team:engineering", "severity:critical"],
  options: {
    notify_audit: true,
    locked: false,
    timeout_h: 0,
    new_host_delay: 300,
    require_full_window: false,
    notify_no_data: false,
    renotify_interval: 15
  },
  monitors: [
    {
      id: "api_error_rate_monitor_id",  // Reference to API error rate monitor
      alias: "a"
    },
    {
      id: "database_connection_monitor_id",  // Reference to DB connection monitor
      alias: "b"
    },
    {
      id: "background_job_monitor_id",  // Reference to job failure monitor
      alias: "c"
    },
    {
      id: "request_volume_anomaly_monitor_id",  // Reference to volume anomaly
      alias: "d"
    }
  ]
};

// Account-specific SLA monitor
const accountSlaMonitor = {
  name: "Account SLA Compliance Monitor",
  query: "avg(last_15m):avg:trace.web.request.duration{service:fub-api} by {account_id} > 3000",
  type: "metric alert",
  message: "Account {{account_id.name}} experiencing SLA violations (>3s response time) @fub-account-managers",
  tags: ["service:fub-api", "sla-monitoring", "account-specific"],
  options: {
    thresholds: {
      critical: 3000,  // 3 seconds
      warning: 2000,   // 2 seconds
      critical_recovery: 2500,
      warning_recovery: 1500
    },
    notify_audit: false,
    require_full_window: true,
    notify_no_data: true,
    no_data_timeframe: 20,
    renotify_interval: 60,
    evaluation_delay: 120
  }
};
```

#### Machine Learning-Based Anomaly Monitors
```javascript
// Advanced anomaly detection with seasonal patterns
const seasonalAnomalyMonitor = {
  name: "FUB API Traffic Seasonal Anomaly",
  query: "anomalies(avg(last_2w):sum:trace.web.request.hits{service:fub-api}.as_rate(), 'robust', 3, direction='both', alert_window='last_30m', interval=300, count_default_zero='true', seasonality='weekly')",
  type: "query alert",
  message: "API traffic showing significant deviation from seasonal patterns - investigate for potential issues or unexpected usage spikes @fub-analytics @fub-product",
  tags: ["service:fub-api", "anomaly-detection", "seasonal", "machine-learning"],
  options: {
    thresholds: { critical: 1 },
    notify_audit: false,
    require_full_window: false,
    notify_no_data: false,
    renotify_interval: 120,
    evaluation_delay: 300
  }
};

// Performance regression detection
const performanceRegressionMonitor = {
  name: "FUB API Performance Regression Detection",
  query: "anomalies(avg(last_7d):avg:trace.web.request.duration{service:fub-api}.as_count(), 'agile', 2, direction='above', alert_window='last_20m', interval=300)",
  type: "query alert",
  message: "Performance regression detected in FUB API - response times significantly above baseline @fub-performance-team @fub-engineering-leads",
  tags: ["service:fub-api", "performance", "regression-detection"],
  options: {
    thresholds: { critical: 1 },
    notify_audit: true,
    require_full_window: false,
    notify_no_data: true,
    no_data_timeframe: 30,
    renotify_interval: 60
  }
};
```

### Performance Optimization and Cost Management

#### Query Optimization Strategies
```javascript
// Optimized high-volume log search with field selection
const optimizedLogSearch = {
  filter: {
    query: "service:fub-api status:error",
    from: "now-1h",
    to: "now"
  },
  limit: 50,  // Limit result set size
  sort: "timestamp",
  page: {
    cursor: null,  // Use pagination for large datasets
    limit: 50
  },
  // Select only necessary fields to reduce bandwidth
  select: [
    "timestamp",
    "message",
    "service",
    "@context.account_id",
    "@http.status_code",
    "@correlation_id"
  ]
};

// Cost-efficient aggregation with selective grouping
const costEfficientAggregation = {
  filter: {
    query: "service:fub-api",
    from: "now-1h",  // Shorter time ranges
    to: "now"
  },
  groupBy: [
    { facet: "@http.status_code", limit: 5 },  // Limit cardinality
    { facet: "@timeseries", limit: 12 }       // 5-minute buckets for 1 hour
  ],
  compute: [
    { aggregation: "count" },
    { aggregation: "avg", metric: "@http.response_time" }
  ]
};
```

#### High-Cardinality Metrics Management
```javascript
// Identify high-cardinality metrics for cost optimization
const analyzeMetricCardinality = async () => {
  const metrics = await mcp__datadog_production__get_metrics({
    q: "fubweb.*"
  });

  // Analyze tag cardinality for cost optimization
  const cardinalityAnalysis = metrics.map(metric => ({
    metric: metric,
    estimatedCardinality: metric.tags?.length || 0,
    costImpact: calculateCostImpact(metric)
  })).sort((a, b) => b.costImpact - a.costImpact);

  console.log('High-cardinality metrics analysis:', cardinalityAnalysis);

  // Generate optimization recommendations
  const recommendations = cardinalityAnalysis
    .filter(m => m.costImpact > 100)
    .map(m => ({
      metric: m.metric,
      recommendation: generateOptimizationRecommendation(m)
    }));

  return recommendations;
};

function calculateCostImpact(metric) {
  // Simplified cost calculation based on tag cardinality
  const baseCost = 1;
  const cardinalityMultiplier = Math.pow(2, metric.tags?.length || 0);
  return baseCost * cardinalityMultiplier;
}

function generateOptimizationRecommendation(metricAnalysis) {
  if (metricAnalysis.estimatedCardinality > 10) {
    return "Consider reducing tag cardinality by removing unnecessary tags or using tag aggregation";
  }
  if (metricAnalysis.costImpact > 1000) {
    return "High cost impact - review metric necessity and consider sampling";
  }
  return "Monitor cardinality growth";
}
```

### Multi-Environment Investigation Workflows

#### Cross-Environment Correlation Analysis
```javascript
// Compare production vs staging error patterns
const crossEnvironmentAnalysis = async (timeRange = "now-4h") => {
  const [productionErrors, stagingErrors] = await Promise.all([
    mcp__datadog_production__aggregate_logs({
      filter: {
        query: "service:fub-api status:error",
        from: timeRange,
        to: "now"
      },
      groupBy: [{ facet: "@context.errorCode", limit: 20 }],
      compute: [{ aggregation: "count" }]
    }),
    mcp__datadog_staging__aggregate_logs({
      filter: {
        query: "service:fub-api status:error",
        from: timeRange,
        to: "now"
      },
      groupBy: [{ facet: "@context.errorCode", limit: 20 }],
      compute: [{ aggregation: "count" }]
    })
  ]);

  // Identify environment-specific issues
  const productionErrorCodes = new Set(productionErrors.buckets.map(b => b.by['@context.errorCode']));
  const stagingErrorCodes = new Set(stagingErrors.buckets.map(b => b.by['@context.errorCode']));

  const productionOnlyErrors = [...productionErrorCodes].filter(code => !stagingErrorCodes.has(code));
  const stagingOnlyErrors = [...stagingErrorCodes].filter(code => !productionErrorCodes.has(code));

  return {
    commonErrors: [...productionErrorCodes].filter(code => stagingErrorCodes.has(code)),
    productionOnlyErrors,
    stagingOnlyErrors,
    analysis: {
      environmentSpecific: productionOnlyErrors.length > 0 || stagingOnlyErrors.length > 0,
      recommendation: generateEnvironmentRecommendation(productionOnlyErrors, stagingOnlyErrors)
    }
  };
};

function generateEnvironmentRecommendation(prodOnly, stagingOnly) {
  if (prodOnly.length > 0 && stagingOnly.length === 0) {
    return "Production-specific errors detected - investigate production environment configuration";
  }
  if (stagingOnly.length > 0 && prodOnly.length === 0) {
    return "Staging-specific errors - may indicate test data or configuration issues";
  }
  if (prodOnly.length > 0 && stagingOnly.length > 0) {
    return "Environment-specific errors in both - review configuration differences";
  }
  return "Error patterns consistent across environments";
}
```

#### Deployment Impact Analysis
```javascript
// Comprehensive deployment impact assessment
const analyzeDeploymentImpact = async (deploymentTime, comparisonWindow = 3600) => {
  const deploymentTimestamp = Math.floor(new Date(deploymentTime).getTime() / 1000);

  // Get deployment events
  const deploymentEvents = await mcp__datadog_production__get_events({
    start: deploymentTimestamp - 300, // 5 minutes before
    end: deploymentTimestamp + 300,   // 5 minutes after
    sources: "deployment",
    tags: "env:production"
  });

  // Analyze metrics before and after deployment
  const [preDeployment, postDeployment] = await Promise.all([
    // Pre-deployment baseline
    mcp__datadog_production__aggregate_logs({
      filter: {
        query: "service:fub-api",
        from: deploymentTimestamp - (comparisonWindow * 2),
        to: deploymentTimestamp
      },
      compute: [
        { aggregation: "count" },
        { aggregation: "avg", metric: "@http.response_time" },
        { aggregation: "cardinality", metric: "@context.errorCode" }
      ]
    }),
    // Post-deployment metrics
    mcp__datadog_production__aggregate_logs({
      filter: {
        query: "service:fub-api",
        from: deploymentTimestamp,
        to: deploymentTimestamp + comparisonWindow
      },
      compute: [
        { aggregation: "count" },
        { aggregation: "avg", metric: "@http.response_time" },
        { aggregation: "cardinality", metric: "@context.errorCode" }
      ]
    })
  ]);

  // Calculate impact metrics
  const impactAnalysis = {
    requestVolumeChange: calculatePercentageChange(
      preDeployment.buckets[0]?.by.count || 0,
      postDeployment.buckets[0]?.by.count || 0
    ),
    responseTimeChange: calculatePercentageChange(
      preDeployment.buckets[0]?.by.avg || 0,
      postDeployment.buckets[0]?.by.avg || 0
    ),
    errorDiversityChange: calculatePercentageChange(
      preDeployment.buckets[0]?.by.cardinality || 0,
      postDeployment.buckets[0]?.by.cardinality || 0
    ),
    deploymentEvents: deploymentEvents.events,
    assessment: null
  };

  // Generate assessment
  impactAnalysis.assessment = generateDeploymentAssessment(impactAnalysis);

  return impactAnalysis;
};

function calculatePercentageChange(before, after) {
  if (before === 0) return after > 0 ? 100 : 0;
  return ((after - before) / before) * 100;
}

function generateDeploymentAssessment(impact) {
  const thresholds = {
    responseTimeWarning: 20,    // 20% increase
    responseTimeCritical: 50,   // 50% increase
    volumeWarning: -30,         // 30% decrease
    errorWarning: 50            // 50% increase in error diversity
  };

  const issues = [];

  if (impact.responseTimeChange > thresholds.responseTimeCritical) {
    issues.push("CRITICAL: Significant response time degradation");
  } else if (impact.responseTimeChange > thresholds.responseTimeWarning) {
    issues.push("WARNING: Response time increase detected");
  }

  if (impact.requestVolumeChange < thresholds.volumeWarning) {
    issues.push("WARNING: Significant drop in request volume");
  }

  if (impact.errorDiversityChange > thresholds.errorWarning) {
    issues.push("WARNING: Increase in error types/frequency");
  }

  return {
    status: issues.length === 0 ? "HEALTHY" : issues.some(i => i.includes("CRITICAL")) ? "CRITICAL" : "WARNING",
    issues: issues,
    recommendation: issues.length === 0 ?
      "Deployment appears successful with no significant impact" :
      "Review deployment and consider rollback if issues persist"
  };
}
```

### Automated Incident Response

#### Intelligent Alert Aggregation
```javascript
// Smart alert correlation and escalation
const intelligentAlertProcessor = async () => {
  // Get all active alerts
  const activeMonitors = await mcp__datadog_production__get_monitors({
    groupStates: ["alert", "warn"],
    limit: 100
  });

  // Correlate related alerts
  const alertCorrelation = correlateAlerts(activeMonitors);

  // Generate incident summaries
  const incidents = alertCorrelation.map(cluster => ({
    severity: calculateIncidentSeverity(cluster),
    services: extractAffectedServices(cluster),
    timeline: buildIncidentTimeline(cluster),
    evidence: gatherSupportingEvidence(cluster),
    recommendedActions: generateActionPlan(cluster)
  }));

  return incidents;
};

function correlateAlerts(monitors) {
  // Group monitors by service, time proximity, and error correlation
  const clusters = [];
  const processed = new Set();

  monitors.forEach(monitor => {
    if (processed.has(monitor.id)) return;

    const cluster = [monitor];
    const monitorTags = new Set(monitor.tags);
    const monitorTime = monitor.overall_state_modified;

    // Find related monitors
    monitors.forEach(otherMonitor => {
      if (otherMonitor.id === monitor.id || processed.has(otherMonitor.id)) return;

      const otherTags = new Set(otherMonitor.tags);
      const timeProximity = Math.abs(monitorTime - otherMonitor.overall_state_modified);
      const tagOverlap = [...monitorTags].filter(tag => otherTags.has(tag)).length;

      // Correlation criteria: same service or close timing with tag overlap
      if (tagOverlap > 0 && (timeProximity < 300 || hasServiceOverlap(monitorTags, otherTags))) {
        cluster.push(otherMonitor);
        processed.add(otherMonitor.id);
      }
    });

    clusters.push(cluster);
    processed.add(monitor.id);
  });

  return clusters;
}

function calculateIncidentSeverity(alertCluster) {
  const hasCritical = alertCluster.some(alert => alert.overall_state === "Alert");
  const serviceCount = new Set(alertCluster.flatMap(alert =>
    alert.tags.filter(tag => tag.startsWith('service:'))
  )).size;

  if (hasCritical && serviceCount > 2) return "CRITICAL";
  if (hasCritical || serviceCount > 1) return "HIGH";
  return "MEDIUM";
}

function hasServiceOverlap(tags1, tags2) {
  const services1 = [...tags1].filter(tag => tag.startsWith('service:'));
  const services2 = [...tags2].filter(tag => tag.startsWith('service:'));
  return services1.some(service => services2.includes(service));
}
```

#### Auto-Recovery Monitoring
```javascript
// Automated health check and recovery validation
const autoRecoveryValidator = async (incidentId, expectedRecoveryTime) => {
  const recoveryWindow = 600; // 10 minutes
  const validationMetrics = [];

  // Monitor key health indicators
  const healthChecks = [
    {
      name: "error_rate",
      query: "service:fub-api status:error",
      threshold: { warning: 0.02, critical: 0.05 },
      metric: "error_rate"
    },
    {
      name: "response_time",
      query: "service:fub-api @http.response_time:*",
      threshold: { warning: 2000, critical: 5000 },
      metric: "avg_response_time"
    },
    {
      name: "request_volume",
      query: "service:fub-api",
      threshold: { warning: -0.3, critical: -0.5 },
      metric: "request_volume_change"
    }
  ];

  // Continuous monitoring during recovery window
  for (let elapsed = 0; elapsed < recoveryWindow; elapsed += 60) {
    const timestamp = expectedRecoveryTime + elapsed;

    const healthSnapshot = await Promise.all(
      healthChecks.map(async check => {
        const result = await mcp__datadog_production__aggregate_logs({
          filter: {
            query: check.query,
            from: timestamp - 300, // 5 minutes before
            to: timestamp + 300    // 5 minutes after
          },
          compute: [
            { aggregation: "count" },
            { aggregation: "avg", metric: "@http.response_time" }
          ]
        });

        return {
          check: check.name,
          timestamp: timestamp,
          value: calculateMetricValue(result, check.metric),
          status: evaluateThreshold(result, check.threshold),
          healthy: evaluateThreshold(result, check.threshold) === "HEALTHY"
        };
      })
    );

    validationMetrics.push({
      timestamp: timestamp,
      elapsed: elapsed,
      checks: healthSnapshot,
      overallHealth: healthSnapshot.every(check => check.healthy) ? "HEALTHY" : "DEGRADED"
    });

    // Early termination if consistently healthy
    if (elapsed >= 300 && validationMetrics.slice(-3).every(m => m.overallHealth === "HEALTHY")) {
      break;
    }
  }

  return {
    incidentId: incidentId,
    recoveryValidated: validationMetrics.slice(-1)[0].overallHealth === "HEALTHY",
    recoveryTime: validationMetrics.find(m => m.overallHealth === "HEALTHY")?.elapsed || null,
    fullMetrics: validationMetrics,
    recommendation: generateRecoveryRecommendation(validationMetrics)
  };
};
```

These advanced patterns provide sophisticated monitoring, analysis, and automation capabilities for complex Datadog operations in production environments.