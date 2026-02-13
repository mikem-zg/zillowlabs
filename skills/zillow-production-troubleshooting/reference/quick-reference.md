## Quick Reference

### Essential Commands

#### Critical Issue Types and Escalation Paths
```bash
# Critical OAuth authentication failures - immediate triage
/zillow-production-troubleshooting --issue="oauth_failure" --severity="critical"

# Agent resolution showing incorrect status - escalate to diagnosis
/zillow-production-troubleshooting --issue="agent_resolution" --account_id="14009"

# Transaction sync failures - check eligibility pipeline
/zillow-production-troubleshooting --issue="transaction_sync" --deal_id="12345"

# Rate limiting incident response (like Nov 17, 2025)
/zillow-production-troubleshooting --issue="rate_limiting" --severity="incident"

# System health degradation - preventive monitoring
/zillow-production-troubleshooting --issue="connection_health" --preventive=true
```

#### Account-Specific Troubleshooting
```bash
# Account-specific troubleshooting
/zillow-production-troubleshooting --issue="agent_resolution" --account_id="14009"

# Deal-specific sync issues
/zillow-production-troubleshooting --issue="transaction_sync" --deal_id="12345" --account_id="67890"

# Preventive monitoring for high-value accounts
/zillow-production-troubleshooting --issue="connection_health" --account_id="12345" --preventive=true
```

### Issue Classification Matrix

| Issue Type | Severity Levels | First Response | Escalation Target |
|------------|----------------|----------------|-------------------|
| **oauth_failure** | critical, high, normal | Token status check → OAuth app validation | `zillow-oauth-diagnosis` |
| **transaction_sync** | critical, high, normal | Agent count verification → Sync eligibility | `zillow-sync-diagnosis` |
| **rate_limiting** | incident, high, normal | Rate limit analysis → Batch retry setup | `zillow-incident-recovery` |
| **agent_resolution** | high, normal | Resolution distribution check → Data integrity | `zillow-sync-diagnosis` |
| **connection_health** | monitoring, preventive | Health baseline comparison → Proactive monitoring | `zillow-system-monitoring` |

### Critical Datadog Queries (Immediate Triage)

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

#### Account-Specific Error Tracking
```javascript
// Account-specific Zillow integration errors
"@context.account_id:12345 @message:*Zillow* status:error"

// OAuth authentication failure tracking for specific account
"@context.account_id:12345 @service:fub-api @message:*ZillowAuth* @zillow_error_type:authentication_failed"

// Transaction sync failures for specific account
"@context.account_id:12345 @message:*zillow_transaction* @event:transaction_sync_failed"
```

### Production Baseline Metrics

#### System Health Overview
**Expected Baseline:** 98.80% overall health across 677+ million sync events

**Agent Resolution Distribution (Expected):**
- **CONNECTED**: 46.72% (OAuth authenticated agents)
- **INFERRED**: 15.99% (Team-based matching)
- **UNMATCHED**: 37.29% (No resolution available)

#### Performance Thresholds
- **OAuth Token Success Rate**: >99.5% (warning at 99%, critical at 98%)
- **Transaction Sync Success Rate**: >98% (warning at 97%, critical at 95%)
- **Agent Resolution Accuracy**: Baseline distribution ±2%
- **API Response Time**: <500ms p95 (warning at 1s, critical at 2s)

### Team Escalation Contacts

**Engineering Manager:** CL Nolen
**Support Channel:** #fub-zyno-support (Slack)
**Team:** Zynaptic Overlords (Zillow integration specialists)

### Specialized Skills Routing

| Specialized Skill | Purpose | When to Use |
|-------------------|---------|-------------|
| **`zillow-oauth-diagnosis`** | OAuth authentication troubleshooting | oauth_failure issues, token validation |
| **`zillow-sync-diagnosis`** | Transaction sync and agent verification | transaction_sync, agent_resolution issues |
| **`zillow-incident-recovery`** | Rate limiting incident response | rate_limiting incidents, batch recovery |
| **`zillow-system-monitoring`** | Proactive health monitoring | connection_health, baseline analysis |

### Quick Response Checklists

#### For Critical OAuth Failures
- [ ] Check token status in zillow_auth table
- [ ] Verify OAuth app configuration
- [ ] Check frontend useZillowAuth hook state
- [ ] Escalate to zillow-oauth-diagnosis

#### For Transaction Sync Failures
- [ ] Verify deal has agents assigned
- [ ] Check agent resolution distribution
- [ ] Validate four-path agent verification
- [ ] Escalate to zillow-sync-diagnosis

#### For Rate Limiting Incidents
- [ ] Identify affected webhook events
- [ ] Assess potential data loss
- [ ] Implement rate limiting response
- [ ] Escalate to zillow-incident-recovery

#### For Connection Health Issues
- [ ] Compare against baseline metrics
- [ ] Check problem_at timestamps
- [ ] Assess degradation patterns
- [ ] Set up proactive monitoring

### Real Production Example References

#### Historical Incident Data
- **Nov 17, 2025 Rate Limiting**: 212,631 webhook events, 2 permanent losses
- **Agent Resolution Inconsistency**: Account 14009, "Inferred" despite OAuth
- **ZIM Installation Race**: Account 75172, timing-related failures

#### Common Issue Patterns
```bash
# Pattern 1: OAuth token expiration cascade
# Symptoms: Multiple accounts losing sync simultaneously
# Query: "service:fub @context.method:*oauth* @context.error:*expired*"

# Pattern 2: Agent resolution drift
# Symptoms: Resolution percentages deviating from baseline
# Query: "@correlation_id:zillow-agent-resolution @resolution_method:UNMATCHED"

# Pattern 3: Transaction sync bottleneck
# Symptoms: Deals not appearing in Zillow Premier Agent
# Query: "service:fub @context.method:getDealZillowUsers @context.agentCount:0"

# Pattern 4: Rate limiting cascade
# Symptoms: Webhook processing backlog
# Query: "service:fub @context.error_message:*429* @context.service:zillow"
```

### Progressive Disclosure Framework

#### Level 1: Critical Issues (Immediate Response)
- **OAuth Authentication Failures** → Immediate token validation
- **Transaction Sync Failures** → Agent verification check
- **Rate Limiting Events** → Backlog assessment

#### Level 2: System Health (Monitoring)
- **Connection Health Degradation** → Baseline comparison
- **Agent Resolution Inconsistencies** → Distribution analysis

#### Level 3: Integration Issues (Investigation)
- **ZIM Installation Failures** → Race condition analysis
- **Cross-system Dependencies** → Impact assessment

### Emergency Contact Information

#### Immediate Escalation (< 5 minutes)
- **Slack Channel**: #fub-zyno-support
- **Primary Contact**: Engineering Manager CL Nolen
- **Team**: Zynaptic Overlords

#### Incident Command Structure
- **Incident Commander**: Engineering Manager or senior engineer
- **Technical Lead**: System subject matter expert
- **Communications Lead**: Stakeholder update coordinator
- **Documentation Lead**: Timeline and resolution tracker

### Monitoring Dashboard Quick Links

#### Key Performance Dashboards
- System Health Overview: Current health percentage and trends
- Agent Resolution Distribution: Current vs. baseline comparison
- Error Rate Trends: OAuth, sync, and API error patterns
- Incident Tracking: Active incidents and resolution status

#### Alert Configuration
```bash
# Tier 1: Information (Log only)
# - Minor baseline deviations (< 2%)
# - Single account issues (< 100 users)

# Tier 2: Warning (Team notification)
# - Moderate deviations (2-5%)
# - Multiple accounts or large accounts (> 100 users)

# Tier 3: Critical (Immediate escalation)
# - Major deviations (> 5%)
# - System-wide issues (> 10 accounts)
# - Performance degradation (> 20%)

# Tier 4: Incident (Emergency response)
# - Complete system failure
# - Large-scale data loss
# - Security implications
```