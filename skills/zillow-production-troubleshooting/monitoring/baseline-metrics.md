## Production Scale Context and Baseline Metrics

### System Health Baseline

**Overall System Health:** 98.80% across 677+ million sync events
- This represents the expected healthy state across all Zillow integration systems
- Deviations below 95% indicate degraded performance requiring investigation
- Critical threshold at 90% triggers immediate escalation

### Agent Resolution Method Distribution (Production Baseline)

**Expected Distribution:**
- **CONNECTED**: 46.72% (OAuth authenticated agents)
- **INFERRED**: 15.99% (Team-based matching)
- **UNMATCHED**: 37.29% (No resolution available)

**Deviation Thresholds:**
- **Normal Variance**: ±2% from baseline percentages
- **Investigation Threshold**: ±5% from baseline percentages
- **Critical Threshold**: ±10% from baseline percentages (immediate escalation)

**Monitoring Query:**
```sql
SELECT resolution_method, COUNT(*) as count,
       (COUNT(*) * 100.0 / SUM(COUNT(*)) OVER()) as percentage
FROM zillow_agents
GROUP BY resolution_method;
```

### Critical Datadog Queries for Immediate Triage

#### OAuth Failures (Immediate Attention Required)
```javascript
// OAuth failures requiring immediate attention
"service:fub @context.method:*oauth* status:error -@message:*rate*limit*"
```

#### Transaction Sync Failures (Pipeline Blocked)
```javascript
// Transaction sync failures (pipeline blocked)
"service:fub @context.method:getDealZillowUsers @context.agentCount:0"
```

#### Rate Limiting Events (Potential Data Loss)
```javascript
// Rate limiting events (potential data loss)
"service:fub @context.error_message:*429* @context.service:zillow"
```

#### Connection Health Emergencies
```javascript
// Connection health emergencies
"service:fub @context.connection_health_status:error"
```

#### Agent Resolution Tracking
```javascript
// Agent resolution method monitoring
"@correlation_id:zillow-agent-resolution @resolution_method:(CONNECTED OR INFERRED OR UNMATCHED)"
```

### Dynamic Baseline Adjustment

#### Adaptive Baseline Monitoring
```bash
# Adaptive baseline monitoring based on account behavior
update_dynamic_baselines() {
    local account_id="$1"
    local observation_window="24h"

    # Calculate rolling baseline for account-specific patterns
    current_metrics=$(get_account_metrics "$account_id" "$observation_window")
    historical_baseline=$(get_historical_baseline "$account_id" "30d")

    # Detect significant deviations from historical patterns
    deviation_score=$(calculate_deviation_score "$current_metrics" "$historical_baseline")

    if [[ $deviation_score -gt 2.0 ]]; then
        alert_significant_behavior_change "$account_id" "$deviation_score"
        adjust_monitoring_sensitivity "$account_id" "increased"
    fi
}
```

#### Proactive Alerting Based on Leading Indicators
```bash
# Proactive alerting based on leading indicators
setup_predictive_alerts() {
    local issue_type="$1"

    # Leading indicators for each issue type
    case "$issue_type" in
        "oauth_failure")
            monitor_token_expiration_patterns
            track_oauth_app_health_metrics
            ;;
        "rate_limiting")
            monitor_api_request_velocity
            track_webhook_processing_lag
            ;;
        "transaction_sync")
            monitor_agent_resolution_distribution_drift
            track_deal_creation_patterns
            ;;
    esac
}
```

### System Performance Metrics

#### Key Performance Indicators
- **OAuth Token Success Rate**: >99.5% (warning at 99%, critical at 98%)
- **Transaction Sync Success Rate**: >98% (warning at 97%, critical at 95%)
- **Agent Resolution Accuracy**: Baseline distribution ±2%
- **API Response Time**: <500ms p95 (warning at 1s, critical at 2s)
- **Webhook Processing Latency**: <30s p95 (warning at 60s, critical at 120s)

#### Health Check Queries
```bash
# System health baseline: 98.80% across 677+ million sync events
# Agent resolution distribution verification:
# - CONNECTED: 46.72% (OAuth authenticated)
# - INFERRED: 15.99% (Team-based matching)
# - UNMATCHED: 37.29% (No resolution available)

assess_system_health_baseline() {
    current_health=$(calculate_current_system_health)
    baseline_health="98.80"

    if (( $(echo "$current_health < 95.0" | bc -l) )); then
        echo "🚨 CRITICAL: System health below 95% - immediate investigation required"
        return 1
    elif (( $(echo "$current_health < 97.0" | bc -l) )); then
        echo "⚠️  WARNING: System health below 97% - monitoring recommended"
        return 2
    else
        echo "✅ HEALTHY: System health within normal parameters ($current_health%)"
        return 0
    fi
}

check_agent_resolution_distribution() {
    # Query current distribution
    current_distribution=$(query_resolution_distribution)

    # Compare against baseline
    connected_variance=$(calculate_variance "$current_distribution" "46.72" "CONNECTED")
    inferred_variance=$(calculate_variance "$current_distribution" "15.99" "INFERRED")
    unmatched_variance=$(calculate_variance "$current_distribution" "37.29" "UNMATCHED")

    # Check for significant deviations
    if [[ $connected_variance -gt 10 ]] || [[ $inferred_variance -gt 10 ]] || [[ $unmatched_variance -gt 10 ]]; then
        echo "🚨 CRITICAL: Agent resolution distribution significantly deviated from baseline"
        return 1
    elif [[ $connected_variance -gt 5 ]] || [[ $inferred_variance -gt 5 ]] || [[ $unmatched_variance -gt 5 ]]; then
        echo "⚠️  WARNING: Agent resolution distribution outside normal variance"
        return 2
    fi

    echo "✅ NORMAL: Agent resolution distribution within expected parameters"
    return 0
}

identify_baseline_deviations() {
    echo "=== BASELINE DEVIATION ANALYSIS ==="

    # System health check
    assess_system_health_baseline
    health_status=$?

    # Agent resolution distribution check
    check_agent_resolution_distribution
    resolution_status=$?

    # Overall assessment
    if [[ $health_status -eq 1 ]] || [[ $resolution_status -eq 1 ]]; then
        echo "🚨 OVERALL STATUS: CRITICAL - immediate escalation required"
        return 1
    elif [[ $health_status -eq 2 ]] || [[ $resolution_status -eq 2 ]]; then
        echo "⚠️  OVERALL STATUS: WARNING - enhanced monitoring recommended"
        return 2
    else
        echo "✅ OVERALL STATUS: HEALTHY - all systems within normal parameters"
        return 0
    fi
}
```

### Real Production Example References

#### Historical Baseline Data
- **Nov 17, 2025 Rate Limiting Incident:**
  - Affected Events: 212,631 webhook events
  - Data Loss: 2 permanent losses
  - Recovery Time: 4 hours
  - Baseline Impact: Temporary reduction to 94.2% health

- **Agent Resolution Inconsistency (Account 14009):**
  - Symptom: "Inferred" status despite OAuth connection
  - Duration: 2 days undetected
  - Impact: Incorrect identity resolution for 47 agents
  - Resolution: Manual correction + enhanced monitoring

- **ZIM Installation Race Condition (Account 75172):**
  - Symptom: Timing-related installation failures
  - Frequency: 3.2% of OAuth completions
  - Impact: Incomplete onboarding flow
  - Resolution: Retry logic with exponential backoff

### Alerting Thresholds and Escalation

#### Tiered Alerting System
```bash
# Tier 1: Information (Log only)
# - Minor deviations within 2% of baseline
# - Single account issues with < 100 users

# Tier 2: Warning (Team notification)
# - Deviations 2-5% from baseline
# - Multiple account issues or accounts > 100 users
# - Performance degradation 10-20%

# Tier 3: Critical (Immediate escalation)
# - Deviations > 5% from baseline
# - System-wide issues affecting > 10 accounts
# - Performance degradation > 20%
# - Data loss risk identified

# Tier 4: Incident (Emergency response)
# - Complete system failure
# - Large-scale data loss (> 100 records)
# - Security implications identified
```

### Monitoring Dashboard Requirements

#### Key Metrics Dashboard
1. **System Health Overview**
   - Current overall health percentage
   - Health trend over 24h/7d/30d
   - Critical threshold indicators

2. **Agent Resolution Distribution**
   - Current vs. baseline distribution
   - Trend analysis for each resolution method
   - Deviation alerts and thresholds

3. **Performance Metrics**
   - API response times (p50, p95, p99)
   - OAuth success rates
   - Transaction sync success rates
   - Error rate trends

4. **Incident Tracking**
   - Active incidents and severity
   - Recent incident history
   - Mean time to resolution trends