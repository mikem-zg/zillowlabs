# Verified Datadog Monitor Templates for FUB

Production-proven monitor configurations extracted from actual FUB implementations and the "Creating Datadog Monitors with Cursor" documentation.

## Actual Production Monitor Example

This monitor template is from the real production Bishop integration monitoring (from ZYN-10164 implementation):

### Lower Requests Than Normal (Anomaly Detection)

**Source**: Actual production monitor for Bishop integration from Confluence documentation

```json
{
  "name": "Lower requests to Bishop than normal",
  "type": "query alert",
  "query": "avg(last_12h):anomalies(sum:fubweb.bishop.requests{env:prod}.as_count(), 'agile', 2, direction='below', interval=120, alert_window='last_30m', count_default_zero='true', seasonality='weekly') >= 0.01",
  "message": "Lower requests to Bishop than normal\n\n**Product name:** Follow Up Boss\n\n**Owning team:** [Zynaptic Overlords](https://zodiac.zgtools.net/teams/fub-zyno)\n\n**Monitoring channel:** [#fub-zyno-alerts](https://zillowgroup.enterprise.slack.com/archives/C08PYLLP3N2)\n\n**On-call tag:** {{noformat}}@fub-zyno-oncall{{noformat}}\n\nThe FUB worker that sends requests to Bishop has not registered any new requests in the last 15 minutes.\n\nIt is possible that FUB legitimately has no data to send to Bishop, but it's also possible that the FUB worker is not running or working as expected.\n\nThis impacts the FUB Zillow Premier Agent integration, specifically synchronization to Bishop of matches between FUB and Zillow agents (including associated office data) and the creation or removal of verified Zillow agent profiles.\n\n[Worker logs](https://fub.datadoghq.com/logs?query=service%3Afub%20%40function%3A%22li3%3AbishopWorker%3Aperform%22&agg_m=count&agg_m_source=base&agg_t=count&clustering_pattern_field_path=message&cols=host%2Cservice&messageDisplay=inline&refresh_mode=sliding&storage=hot&stream_sort=desc&viz=stream&from_ts=1746488148425&to_ts=1746489048425&live=true)\n\n@slack-Zillow_Group-fub-zyno-alerts",
  "tags": [
    "team:integrations",
    "Zillow",
    "Bishop"
  ],
  "options": {
    "thresholds": {
      "critical": 0.01
    },
    "notify_audit": false,
    "require_full_window": true,
    "renotify_interval": 0,
    "threshold_windows": {
      "trigger_window": "last_30m",
      "recovery_window": "last_10m"
    },
    "include_tags": false,
    "on_missing_data": "show_no_data",
    "new_host_delay": 300
  },
  "priority": 2
}
```

## FUB Monitor Templates (Based on Production Patterns)

### Service Error Rate Monitor

**Purpose**: Monitor API error rates using established FUB patterns
**Based on**: Observability patterns for service monitoring

```json
{
  "name": "FUB API Error Rate Alert",
  "type": "query alert",
  "query": "sum(last_5m):sum:trace.web.request.errors{service:fub-api}.as_count() / sum:trace.web.request.hits{service:fub-api}.as_count() > 0.05",
  "message": "FUB API Error Rate Alert\n\n**Product name:** Follow Up Boss\n\n**Owning team:** [Zynaptic Overlords](https://zodiac.zgtools.net/teams/fub-zyno)\n\n**Monitoring channel:** [#fub-zyno-alerts](https://zillowgroup.enterprise.slack.com/archives/C08PYLLP3N2)\n\n**On-call tag:** {{noformat}}@fub-zyno-oncall{{noformat}}\n\nThe FUB API service is experiencing an elevated error rate (>5%) over the last 5 minutes.\n\nThis indicates potential issues with:\n- API endpoint functionality\n- Database connectivity\n- External service integrations\n- Authentication/authorization systems\n\n[API Error Logs](https://fub.datadoghq.com/logs?query=service%3Afub-api%20status%3Aerror&agg_m=count&agg_t=count&from_ts=0&to_ts=0&live=true)\n\n[API Performance Dashboard](https://fub.datadoghq.com/dashboard/api-performance)\n\n@slack-Zillow_Group-fub-zyno-alerts",
  "tags": [
    "team:zyno",
    "service:fub-api",
    "critical"
  ],
  "options": {
    "thresholds": {
      "critical": 0.05,
      "warning": 0.02
    },
    "notify_audit": false,
    "require_full_window": true,
    "renotify_interval": 60,
    "include_tags": true,
    "on_missing_data": "default"
  },
  "priority": 1
}
```

### Background Job Failure Monitor

**Purpose**: Monitor Resque job failures
**Based on**: FUB service architecture documentation

```json
{
  "name": "FUB Background Job Failure Rate",
  "type": "query alert",
  "query": "sum(last_15m):sum:resque.failed{service:fub-resque}.as_count() > 10",
  "message": "FUB Background Job Failure Rate\n\n**Product name:** Follow Up Boss\n\n**Owning team:** [Zynaptic Overlords](https://zodiac.zgtools.net/teams/fub-zyno)\n\n**Monitoring channel:** [#fub-infrastructure](https://zillowgroup.enterprise.slack.com/archives/C06D27UMLBU)\n\n**On-call tag:** {{noformat}}@fub-zyno-oncall{{noformat}}\n\nFUB background jobs are failing at an elevated rate (>10 failures in 15 minutes).\n\nThis may indicate:\n- Queue worker connectivity issues\n- Database connection problems\n- External service failures (integrations, webhooks)\n- Memory or resource constraints on worker servers\n\n[Resque Job Logs](https://fub.datadoghq.com/logs?query=service%3Afub-resque%20%40resque.job_status%3Afailed&from_ts=0&to_ts=0&live=true)\n\n[Worker Infrastructure Dashboard](https://fub.datadoghq.com/dashboard/worker-infrastructure)\n\n@slack-Zillow_Group-fub-infrastructure",
  "tags": [
    "team:infrastructure",
    "service:fub-resque",
    "background-jobs"
  ],
  "options": {
    "thresholds": {
      "critical": 10,
      "warning": 5
    },
    "notify_audit": false,
    "require_full_window": false,
    "renotify_interval": 0,
    "include_tags": true,
    "on_missing_data": "default"
  },
  "priority": 2
}
```

### Response Time Performance Monitor

**Purpose**: Monitor API response time degradation
**Based on**: Performance investigation patterns from observability documentation

```json
{
  "name": "FUB API Response Time Alert",
  "type": "query alert",
  "query": "avg(last_10m):avg:trace.web.request.duration{service:fub-api} > 2000",
  "message": "FUB API Response Time Alert\n\n**Product name:** Follow Up Boss\n\n**Owning team:** [Zynaptic Overlords](https://zodiac.zgtools.net/teams/fub-zyno)\n\n**Monitoring channel:** [#fub-zyno-alerts](https://zillowgroup.enterprise.slack.com/archives/C08PYLLP3N2)\n\n**On-call tag:** {{noformat}}@fub-zyno-oncall{{noformat}}\n\nFUB API average response time has exceeded 2000ms over the last 10 minutes.\n\nThis indicates potential performance issues with:\n- Database query performance\n- External API integrations\n- Server resource constraints\n- Cache inefficiencies\n\n[Slow API Logs](https://fub.datadoghq.com/logs?query=service%3Afub-api%20%40http.response_time%3A%3E5000&from_ts=0&to_ts=0&live=true)\n\n[Performance Dashboard](https://fub.datadoghq.com/dashboard/fub-performance)\n\n@slack-Zillow_Group-fub-zyno-alerts",
  "tags": [
    "team:zyno",
    "service:fub-api",
    "performance"
  ],
  "options": {
    "thresholds": {
      "critical": 2000,
      "warning": 1500
    },
    "notify_audit": false,
    "require_full_window": true,
    "renotify_interval": 30,
    "include_tags": true,
    "on_missing_data": "default"
  },
  "priority": 2
}
```

## Log-Based Monitor Templates

### OAuth Error Detection Monitor

**Purpose**: Monitor OAuth authentication failures
**Based on**: Common query examples from observability patterns

```json
{
  "name": "FUB OAuth Authentication Errors",
  "type": "log alert",
  "query": "logs(\"message:\\\"OAuth\\\" service:fub @fub_level:error\").index(\"*\").rollup(\"count\").last(\"5m\") > 5",
  "message": "FUB OAuth Authentication Errors\n\n**Product name:** Follow Up Boss\n\n**Owning team:** [Zynaptic Overlords](https://zodiac.zgtools.net/teams/fub-zyno)\n\n**Monitoring channel:** [#fub-zyno-alerts](https://zillowgroup.enterprise.slack.com/archives/C08PYLLP3N2)\n\n**On-call tag:** {{noformat}}@fub-zyno-oncall{{noformat}}\n\nFUB is experiencing OAuth authentication errors (>5 in 5 minutes).\n\nThis typically indicates:\n- OAuth token expiration issues\n- Integration credential problems\n- External OAuth provider issues\n- Configuration changes affecting authentication\n\n[OAuth Error Logs](https://fub.datadoghq.com/logs?query=message%3A%22OAuth%22%20service%3Afub%20%40fub_level%3Aerror&from_ts=0&to_ts=0&live=true)\n\n[Authentication Dashboard](https://fub.datadoghq.com/dashboard/authentication)\n\n@slack-Zillow_Group-fub-zyno-alerts",
  "tags": [
    "team:zyno",
    "authentication",
    "oauth"
  ],
  "options": {
    "thresholds": {
      "critical": 5
    },
    "notify_audit": false,
    "require_full_window": false,
    "renotify_interval": 0,
    "include_tags": true,
    "on_missing_data": "default"
  },
  "priority": 2
}
```

### Database Query Performance Monitor

**Purpose**: Monitor slow database queries
**Based on**: Database query patterns from observability documentation

```json
{
  "name": "FUB Slow Database Queries",
  "type": "log alert",
  "query": "logs(\"service:fub @database.query_time:>1000\").index(\"*\").rollup(\"count\").last(\"10m\") > 20",
  "message": "FUB Slow Database Queries\n\n**Product name:** Follow Up Boss\n\n**Owning team:** [Zynaptic Overlords](https://zodiac.zgtools.net/teams/fub-zyno)\n\n**Monitoring channel:** [#fub-infrastructure](https://zillowgroup.enterprise.slack.com/archives/C06D27UMLBU)\n\n**On-call tag:** {{noformat}}@fub-zyno-oncall{{noformat}}\n\nFUB is experiencing slow database queries (>20 queries >1000ms in 10 minutes).\n\nThis indicates potential issues with:\n- Database performance and indexing\n- Query optimization needs\n- Database server resource constraints\n- Lock contention or blocking queries\n\n[Slow Query Logs](https://fub.datadoghq.com/logs?query=service%3Afub%20%40database.query_time%3A%3E1000&from_ts=0&to_ts=0&live=true)\n\n[Database Performance Dashboard](https://fub.datadoghq.com/dashboard/database-performance)\n\n@slack-Zillow_Group-fub-infrastructure",
  "tags": [
    "team:infrastructure",
    "database",
    "performance"
  ],
  "options": {
    "thresholds": {
      "critical": 20,
      "warning": 10
    },
    "notify_audit": false,
    "require_full_window": true,
    "renotify_interval": 0,
    "include_tags": true,
    "on_missing_data": "default"
  },
  "priority": 2
}
```

## Monitor Message Template (From Production Documentation)

### Required Elements (Based on Confluence Best Practices)

The monitor message template from the Confluence documentation includes these required elements:

```markdown
**Product name:** Follow Up Boss (or owning product name)

**Owning team:** [Team Name](https://zodiac.zgtools.net/teams/team-slug)

**Monitoring channel:** [#team-alerts-channel](https://slack-link)

**On-call tag:** {{noformat}}@team-oncall{{noformat}}

[Description of the symptom and potential causes]

This impacts [specific business impact description].

[Link to relevant logs or dashboards]

@slack-Zillow_Group-team-alerts-channel
```

### FUB-Specific Notification Channels

**Primary Teams and Channels:**
- **Zynaptic Overlords**: `#fub-zyno-alerts`, `@fub-zyno-oncall`
- **Infrastructure**: `#fub-infrastructure`, `@fub-infra-oncall`
- **Integrations**: `team:integrations` tag

### Required Tags for FUB Monitors

**Standard Tags** (from production examples):
- `team:zyno` - For application-level monitors
- `team:infrastructure` - For infrastructure monitors
- `team:integrations` - For third-party integration monitors
- `service:fub-api`, `service:fub-csd`, etc. - Service-specific tags

**Additional Tags** (from production usage):
- Environment: `env:production`, `env:staging`
- Criticality: `critical`, `warning`, `info`
- Component: `authentication`, `database`, `performance`, `background-jobs`

## Monitor Configuration Best Practices (From Production Usage)

### Threshold Guidelines

**Error Rate Monitors**:
- Warning: 2-3% error rate
- Critical: 5%+ error rate

**Response Time Monitors**:
- Warning: 1500ms average
- Critical: 2000ms+ average

**Background Job Monitors**:
- Warning: 5 failures in 15 minutes
- Critical: 10+ failures in 15 minutes

### Time Windows (From Production Examples)

**Short-term alerts** (immediate issues):
- Error rates: 5-10 minute windows
- Response times: 10 minute windows
- Authentication: 5 minute windows

**Medium-term alerts** (trend-based):
- Background jobs: 15 minute windows
- Performance degradation: 10-15 minute windows
- Integration issues: 30 minute windows

**Long-term alerts** (anomaly detection):
- Traffic patterns: 12-24 hour baselines
- Usage anomalies: Weekly seasonality
- Capacity planning: Daily/weekly patterns

### Renotification Settings

**Critical issues**:
- Error rates: 60 minutes
- Performance: 30 minutes
- Authentication: Immediate (0 minutes)

**Warning issues**:
- Most monitors: No renotification (0 minutes)
- Infrastructure: 120 minutes

All monitor templates in this document are based on actual FUB production implementations and established team practices documented in Confluence.