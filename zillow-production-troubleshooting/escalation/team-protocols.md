## Team Escalation and Communication Protocols

### Team Ownership - Zynaptic Overlords

**Primary Owner:** Zynaptic Overlords team (FUB+ Integrations and Authentication Team)
- **Engineering Manager:** CL Nolen
- **Team Members:** Matt Turland, Eric Medina, Christian Newberry, Nick Esquerra, Amisha Patel, Fernando Barraza
- **Support Channel:** #fub-zyno-support (Slack)
- **Team Scope:** Zillow integration systems, OAuth authentication, agent resolution

### Critical Issue Escalation Protocol

#### Immediate Escalation Criteria
```bash
# Critical issue escalation protocol
if [[ "$severity" == "critical" || "$severity" == "incident" ]]; then
    notify_zynaptic_overlords_team
    create_incident_tracking
    # Primary Contact: Engineering Manager CL Nolen
    # Support Channel: #fub-zyno-support (Slack)
fi
```

#### Escalation Notification Process
1. **Immediate Notification** (< 5 minutes for critical issues)
   - Slack alert in #fub-zyno-support channel
   - Direct notification to Engineering Manager CL Nolen
   - Include issue classification, affected accounts, and immediate impact

2. **Incident Tracking Creation**
   - Create Jira incident ticket in ZYN project
   - Link to relevant system logs and diagnostic data
   - Document initial response actions taken

3. **Team Assembly** (for incidents)
   - Assemble response team based on issue type
   - Coordinate with adjacent teams if cross-system impact
   - Establish communication cadence for updates

### Specialized Skills Routing

Based on the progressive disclosure framework, route issues to focused troubleshooting skills:

#### OAuth Issues → zillow-oauth-diagnosis
- **When to Use:** oauth_failure issues, token validation problems
- **Purpose:** Detailed token validation and refresh procedures
- **Capabilities:**
  - OAuth app status verification
  - Authentication flow debugging
  - Token lifecycle analysis

#### Sync Issues → zillow-sync-diagnosis
- **When to Use:** transaction_sync, agent_resolution issues
- **Purpose:** Transaction sync and agent verification troubleshooting
- **Capabilities:**
  - Four-path agent verification system
  - Transaction eligibility validation
  - Deal sync pipeline analysis

#### Rate Limiting → zillow-incident-recovery
- **When to Use:** rate_limiting incidents, batch recovery scenarios
- **Purpose:** Rate limiting incident response and recovery
- **Capabilities:**
  - Batch retry procedures for stuck events
  - Rate limiting response protocols
  - Post-incident monitoring setup

#### Health Issues → zillow-system-monitoring
- **When to Use:** connection_health, baseline analysis needs
- **Purpose:** Proactive health monitoring and system assessment
- **Capabilities:**
  - Connection health assessment
  - Proactive monitoring configuration
  - Performance baseline analysis

### Multi-Account Impact Assessment

#### Large-Scale Incident Response
```bash
# Large-scale incident impact analysis
assess_multi_account_impact() {
    local issue_type="$1"
    local affected_timeframe="$2"

    # Query across all accounts for similar symptoms
    affected_accounts=$(query_affected_accounts "$issue_type" "$affected_timeframe")
    total_impact_score=0

    for account_id in $affected_accounts; do
        account_size=$(get_account_metrics "$account_id")
        impact_multiplier=$(calculate_impact_multiplier "$account_size")
        total_impact_score=$((total_impact_score + impact_multiplier))
    done

    # Escalate to incident command if impact threshold exceeded
    if [[ $total_impact_score -gt 1000 ]]; then
        escalate_to_incident_command "$issue_type" "$total_impact_score"
    fi
}
```

#### Cross-System Dependency Analysis
```bash
# Cross-system dependency failure analysis
analyze_dependency_cascade() {
    local primary_failure="$1"

    # Map downstream system impacts
    dependent_systems=$(map_zillow_dependencies "$primary_failure")
    for system in $dependent_systems; do
        system_health=$(check_system_health "$system")
        if [[ "$system_health" == "degraded" ]]; then
            add_to_incident_scope "$system"
        fi
    done
}
```

### Communication Templates

#### Critical Issue Notification Template
```
🚨 CRITICAL ZILLOW INTEGRATION ISSUE

**Issue Type:** [oauth_failure | transaction_sync | rate_limiting]
**Severity:** [critical | incident]
**Affected Accounts:** [count] accounts ([list specific high-impact accounts])
**Estimated Impact:** [description of business impact]

**Immediate Actions Taken:**
- [x] Issue classification completed
- [x] Initial diagnostics performed
- [ ] Specialized skill escalation in progress

**Next Steps:**
- Escalating to [specific skill name]
- ETA for initial resolution: [estimate if available]

**Monitoring:**
- Datadog Query: [specific query for tracking]
- Health Dashboard: [link to relevant dashboard]

**Point of Contact:** @[engineer handling escalation]
```

#### Incident Update Template
```
📊 ZILLOW INCIDENT UPDATE - [Timestamp]

**Status:** [Investigating | In Progress | Resolved | Monitoring]
**Duration:** [time since initial report]
**Affected Systems:** [list of impacted systems]

**Progress Update:**
- [Brief description of current investigation status]
- [Any new findings or root cause insights]
- [Remediation actions currently in progress]

**Impact Assessment:**
- Accounts Still Affected: [number]
- Data Loss Risk: [Low | Medium | High]
- Service Degradation: [percentage if measurable]

**Next Update:** [timestamp for next scheduled update]
```

### Post-Incident Procedures

#### Post-Response Monitoring Setup
```bash
# Set up post-incident monitoring
setup_datadog_alerts_for_issue_type "$issue_type"
schedule_follow_up_health_checks
document_resolution_for_pattern_analysis
```

#### Incident Documentation Requirements
1. **Root Cause Analysis**
   - Technical root cause identification
   - Contributing factors analysis
   - Timeline of events and response actions

2. **Impact Assessment**
   - Quantified business impact
   - Affected user count and duration
   - Data loss or inconsistency assessment

3. **Resolution Documentation**
   - Specific steps taken to resolve
   - Verification of resolution effectiveness
   - Monitoring adjustments implemented

4. **Prevention Measures**
   - Process improvements identified
   - Technical safeguards implemented
   - Monitoring enhancements added

### Team Coordination Patterns

#### Incident Command Structure
- **Incident Commander:** Engineering Manager or designated senior engineer
- **Technical Lead:** Subject matter expert for the affected system
- **Communications Lead:** Team member handling stakeholder updates
- **Documentation Lead:** Team member maintaining incident timeline

#### Cross-Team Coordination
When incidents affect multiple systems:
- **Infrastructure Team:** For underlying system impacts
- **Product Team:** For user experience implications
- **Customer Success:** For account-specific communications
- **Security Team:** If security implications identified

### Real Production Example References

#### Historical Incident Patterns
- **Nov 17, 2025 Rate Limiting:** 212,631 webhook events, 2 permanent losses
  - Response: Implemented batch retry procedures
  - Prevention: Enhanced rate limiting monitoring
  - Follow-up: Adjusted webhook processing thresholds

- **Agent Resolution Inconsistency:** Account 14009, "Inferred" despite OAuth
  - Response: Manual resolution method correction
  - Prevention: Enhanced resolution validation logic
  - Follow-up: Improved resolution monitoring alerts

- **ZIM Installation Race:** Account 75172, timing-related failures
  - Response: Implemented retry logic with exponential backoff
  - Prevention: Enhanced asynchronous processing coordination
  - Follow-up: Added race condition detection alerts