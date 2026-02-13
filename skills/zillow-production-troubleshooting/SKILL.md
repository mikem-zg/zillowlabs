---
name: zillow-production-troubleshooting
description: Real-time incident response and critical issue triage for FUB's Zillow integration systems with progressive disclosure focusing on critical issues requiring immediate response
---

## Overview

Real-time incident response and critical issue triage for FUB's Zillow integration systems with progressive disclosure to surface critical issues first. Provides immediate access to diagnostic tools and resolution steps with escalation to specialized sub-skills for detailed investigation across 6 production systems handling 677+ million sync events.

🚨 **Immediate Actions**: [response/immediate-actions.md](response/immediate-actions.md)
👥 **Team Protocols**: [escalation/team-protocols.md](escalation/team-protocols.md)
📊 **Baseline Metrics**: [monitoring/baseline-metrics.md](monitoring/baseline-metrics.md)
📖 **Quick Reference**: [reference/quick-reference.md](reference/quick-reference.md)

## Usage

```bash
/zillow-production-troubleshooting --issue=<issue_type> [--severity=<level>] [--account_id=<id>] [--deal_id=<id>] [--preventive=<bool>]
```

## Examples

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

## Core Workflow

### 1. Issue Classification and Urgency Assessment
**Rapid triage to determine appropriate response level and routing**
```bash
# Classify issue type and determine severity
classify_issue "$issue_type" "$severity"

# Issue classification matrix:
# - oauth_failure: Authentication/authorization problems
# - transaction_sync: Deal sync pipeline failures
# - rate_limiting: API throttling incidents
# - agent_resolution: Identity matching inconsistencies
# - connection_health: System degradation monitoring
```

### 2. Immediate Response Actions
**Critical issues require immediate diagnostic actions before escalation**

#### Critical OAuth Failure Response
```bash
if [[ "$issue_type" == "oauth_failure" && "$severity" == "critical" ]]; then
    # Quick token status verification
    check_oauth_token_status "$account_id" "$user_id"
    # Validate OAuth app configuration
    verify_oauth_app_status
    # → Escalate to zillow-oauth-diagnosis for detailed analysis
fi
```

#### Critical Transaction Sync Response
```bash
if [[ "$issue_type" == "transaction_sync" ]]; then
    # Verify deal has agents assigned
    check_deal_agent_count "$deal_id"
    # Validate agent resolution paths
    verify_agent_resolution_distribution
    # → Escalate to zillow-sync-diagnosis for pipeline analysis
fi
```

### 3. Production System Status Assessment
**Verify system health baseline and identify deviations**

**System Health Baseline:** 98.80% across 677+ million sync events
**Agent Resolution Distribution:**
- **CONNECTED**: 46.72% (OAuth authenticated)
- **INFERRED**: 15.99% (Team-based matching)
- **UNMATCHED**: 37.29% (No resolution available)

### 4. Critical Path Decision Making
**Route to appropriate specialized skills based on classification**
```bash
case "$issue_type" in
    "oauth_failure")
        → zillow-oauth-diagnosis --detailed-token-analysis
        ;;
    "transaction_sync")
        → zillow-sync-diagnosis --agent-verification
        ;;
    "rate_limiting")
        → zillow-incident-recovery --batch-retry-procedures
        ;;
    "connection_health")
        → zillow-system-monitoring --proactive-assessment
        ;;
esac
```

### 5. Team Escalation and Communication
**Ensure appropriate team notification for critical issues**
```bash
# Critical issue escalation protocol
if [[ "$severity" == "critical" || "$severity" == "incident" ]]; then
    notify_zynaptic_overlords_team
    create_incident_tracking
    # Primary Contact: Engineering Manager CL Nolen
    # Support Channel: #fub-zyno-support (Slack)
fi
```

## Progressive Disclosure Framework

### Level 1: Critical Issues (Immediate Response)

**OAuth Authentication Failures (CRITICAL)**
- **Symptoms**: "OAuth credentials valid, but integration disabled", connection failures
- **Impact**: Complete sync loss for affected accounts
- **First Response**: Check token status, validate OAuth app, escalate to oauth-diagnosis

**Transaction Sync Failures (CRITICAL)**
- **Symptoms**: Deals not appearing in Zillow Premier Agent, synced_at IS NULL
- **Impact**: Agents lose pipeline visibility
- **First Response**: Verify four-path agent resolution, escalate to sync-diagnosis

**Rate Limiting Events (INCIDENT)**
- **Symptoms**: HTTP 429 responses, webhook event backlog
- **Impact**: Temporary sync suspension, potential permanent data loss
- **First Response**: Implement rate limiting response, escalate to incident-recovery

### Level 2: System Health (Monitoring)

**Connection Health Degradation**
- **Symptoms**: problem_at timestamps, connection_health_status warnings
- **Impact**: Gradual degradation before failure
- **Response**: Proactive monitoring, health assessment

**Agent Resolution Inconsistencies**
- **Symptoms**: "Inferred" status when OAuth connected
- **Impact**: Incorrect identity resolution
- **Response**: Data integrity validation

## Quick Reference

### Issue Classification Matrix
| Issue Type | Severity Levels | First Response | Escalation Target |
|------------|----------------|----------------|-------------------|
| **oauth_failure** | critical, high, normal | Token status check → OAuth app validation | `zillow-oauth-diagnosis` |
| **transaction_sync** | critical, high, normal | Agent count verification → Sync eligibility | `zillow-sync-diagnosis` |
| **rate_limiting** | incident, high, normal | Rate limit analysis → Batch retry setup | `zillow-incident-recovery` |
| **agent_resolution** | high, normal | Resolution distribution check → Data integrity | `zillow-sync-diagnosis` |
| **connection_health** | monitoring, preventive | Health baseline comparison → Proactive monitoring | `zillow-system-monitoring` |

### Critical Datadog Queries (Immediate Triage)
```javascript
// OAuth failures requiring immediate attention
"service:fub @context.method:*oauth* status:error -@message:*rate*limit*"

// Transaction sync failures (pipeline blocked)
"service:fub @context.method:getDealZillowUsers @context.agentCount:0"

// Rate limiting events (potential data loss)
"service:fub @context.error_message:*429* @context.service:zillow"

// Connection health emergencies
"service:fub @context.connection_health_status:error"
```

### Team Escalation Contacts
- **Engineering Manager**: CL Nolen
- **Support Channel**: #fub-zyno-support (Slack)
- **Team**: Zynaptic Overlords (Zillow integration specialists)

### Specialized Skills Routing
| Specialized Skill | Purpose | When to Use |
|-------------------|---------|-------------|
| **`zillow-oauth-diagnosis`** | OAuth authentication troubleshooting | oauth_failure issues, token validation |
| **`zillow-sync-diagnosis`** | Transaction sync and agent verification | transaction_sync, agent_resolution issues |
| **`zillow-incident-recovery`** | Rate limiting incident response | rate_limiting incidents, batch recovery |
| **`zillow-system-monitoring`** | Proactive health monitoring | connection_health, baseline analysis |

### Real Production Example References
- **Nov 17, 2025 Rate Limiting**: 212,631 webhook events, 2 permanent losses
- **Agent Resolution Inconsistency**: Account 14009, "Inferred" despite OAuth
- **ZIM Installation Race**: Account 75172, timing-related failures

## Advanced Patterns

<details>
<summary>Click to expand production incident automation and complex scenario handling</summary>

### Production Incident Response Automation

**Automated Issue Classification and Routing:**
Advanced triage automation with ML-based classification based on historical patterns and account context. Pattern matching identifies similar incidents and predicts escalation needs.

**Multi-Account Impact Assessment:**
Large-scale incident impact analysis across all affected accounts with automatic escalation to incident command when impact threshold exceeded (>1000 impact score).

**Cross-System Dependency Analysis:**
Map downstream system impacts and detect cascading failures across Zillow integration dependencies.

### Complex Production Scenario Handling

**Race Condition Resolution:**
Handle ZIM installation race conditions with exponential backoff retry logic and asynchronous processing coordination.

**Production Data Reconciliation:**
Large-scale data consistency validation and repair with multiple scopes (account, deal, system-wide) and repair modes.

📊 **Complete Response Guide**: [response/immediate-actions.md](response/immediate-actions.md)
📈 **Baseline Monitoring**: [monitoring/baseline-metrics.md](monitoring/baseline-metrics.md)

</details>

## Integration Points

### Related Skills Integration

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| `zillow-oauth-diagnosis` | **OAuth Troubleshooting** | Token validation, authentication flow debugging |
| `zillow-integration-systems` | **System Navigation** | Codebase knowledge, architecture understanding |
| `support-investigation` | **Comprehensive Analysis** | Evidence-based investigation, root cause documentation |
| `datadog-management` | **Log Analysis** | Error correlation, performance monitoring |
| `database-operations` | **Data Validation** | Health checks, integrity verification |

### Multi-Skill Operation Examples

**Complete Critical Issue Resolution:**
1. `zillow-production-troubleshooting` - Immediate triage and classification
2. `zillow-oauth-diagnosis` - Specialized OAuth troubleshooting (if oauth_failure)
3. `support-investigation` - Comprehensive evidence collection and documentation
4. `datadog-management` - Production log analysis and correlation
5. `database-operations` - Data integrity validation and correction

## Refusal Conditions

The skill must refuse if:
- **Issue Type Unknown**: Unrecognized issue type not in classification matrix
- **Severity Mismatch**: Issue severity doesn't match expected patterns for issue type
- **Missing Context**: Critical information missing for account or deal-specific issues
- **System Access**: Unable to access required monitoring or diagnostic systems
- **Escalation Blocked**: Specialized skills not available for required escalation
- **Safety Concerns**: Issue scope suggests potential for unauthorized production impact

When refusing, provide specific guidance:
- Available issue types and expected severity levels
- Required context information for specific issue types
- Steps to verify system access and specialized skill availability
- Alternative investigation approaches within current limitations
- Contact information for manual escalation when automated routing fails

**Critical Response Note**: Production troubleshooting prioritizes rapid triage and appropriate escalation over comprehensive investigation. When uncertain about classification or severity, always escalate to human experts in the Zynaptic Overlords team rather than risk delayed response to critical production issues.