## Critical Issue Response Actions

### OAuth Authentication Failures (CRITICAL)

**Symptoms:** "OAuth credentials valid, but integration disabled", connection failures
**Impact:** Complete sync loss for affected accounts
**First Response:** Check token status, validate OAuth app, escalate to oauth-diagnosis

#### Immediate OAuth Token Status Check
```bash
echo "=== IMMEDIATE OAUTH DIAGNOSTICS ==="
echo "Account: $account_id, User: $user_id"

# Quick token status check
FUB_DB_SCRIPT="./.claude/skills/database-operations/scripts/fub-db.sh"
token_status=$($FUB_DB_SCRIPT query dev common "
    SELECT
        CASE WHEN encrypted_refresh_token IS NOT NULL THEN 'PRESENT' ELSE 'MISSING' END
    FROM zillow_auth
    WHERE account_id = $account_id AND user_id = $user_id;
")

echo "Token Status: $token_status"
if [[ "$token_status" == "MISSING" ]]; then
    echo "🚨 ACTION REQUIRED: User must re-authenticate via OAuth flow"
    echo "Frontend OAuth Hook: useZillowAuth (apps/fub-spa/src/hooks/zillow/useZillowAuth.ts)"
else
    echo "→ Token present - escalating to detailed diagnosis"
fi

# Check for frontend OAuth state inconsistencies
echo "Frontend State Check: Verify useZillowAuth hook state matches backend token status"
```

### Transaction Sync Failures (CRITICAL)

**Symptoms:** Deals not appearing in Zillow Premier Agent, synced_at IS NULL
**Impact:** Agents lose pipeline visibility
**First Response:** Verify four-path agent resolution, escalate to sync-diagnosis

#### Immediate Sync Eligibility Check
```bash
echo "=== IMMEDIATE SYNC ELIGIBILITY CHECK ==="
echo "Deal ID: $deal_id"

# Quick agent verification
agent_count=$($FUB_DB_SCRIPT query dev client "$account_id" "
    SELECT COUNT(DISTINCT da.user_id)
    FROM deals d
    JOIN deal_agents da ON da.deal_id = d.id
    WHERE d.id = $deal_id;
")

echo "Agents on Deal: $agent_count"
if [[ $agent_count -eq 0 ]]; then
    echo "🚨 CRITICAL: No agents found on deal - sync impossible"
else
    echo "→ Agents present - checking Zillow verification paths"
    echo "Expected Resolution Distribution: CONNECTED 46.72%, INFERRED 15.99%, UNMATCHED 37.29%"
    echo "Check if current resolution matches baseline distribution"
fi
```

### Rate Limiting Events (INCIDENT)

**Symptoms:** HTTP 429 responses, webhook event backlog
**Impact:** Temporary sync suspension, potential permanent data loss
**First Response:** Implement rate limiting response, escalate to incident-recovery

#### Immediate Rate Limiting Assessment
```bash
echo "=== RATE LIMITING INCIDENT RESPONSE ==="

# Check webhook event backlog
backlog_count=$(query_webhook_backlog_count "past_1h")
echo "Webhook Events Backlog (1h): $backlog_count"

# Assess data loss risk
if [[ $backlog_count -gt 10000 ]]; then
    echo "🚨 HIGH RISK: Large webhook backlog - potential permanent data loss"
    echo "Historical Reference: Nov 17, 2025 - 212,631 events, 2 permanent losses"
else
    echo "ℹ️  MANAGEABLE: Backlog within acceptable limits"
fi

# Implement immediate rate limiting response
echo "→ Implementing batch retry procedures"
echo "→ Escalating to zillow-incident-recovery"
```

### Connection Health Issues

**Symptoms:** problem_at timestamps, connection_health_status warnings
**Impact:** Gradual degradation before failure
**Response:** Proactive monitoring, health assessment

#### Connection Health Assessment
```bash
echo "=== CONNECTION HEALTH ASSESSMENT ==="

# Check against baseline metrics
baseline_health="98.80%"
current_health=$(calculate_current_health_percentage)

echo "Baseline Health: $baseline_health"
echo "Current Health: $current_health%"

# Compare agent resolution distribution
echo "Expected Agent Resolution Distribution:"
echo "  - CONNECTED: 46.72% (OAuth authenticated)"
echo "  - INFERRED: 15.99% (Team-based matching)"
echo "  - UNMATCHED: 37.29% (No resolution available)"

current_distribution=$(get_current_resolution_distribution)
echo "Current Distribution: $current_distribution"

# Check for degradation patterns
degradation_trend=$(analyze_degradation_trend "past_24h")
if [[ "$degradation_trend" == "declining" ]]; then
    echo "⚠️  WARNING: Health trend declining - proactive monitoring recommended"
else
    echo "✅ STABLE: Health trend within normal parameters"
fi
```

### Issue Classification and Routing

#### Quick Issue Classification
```bash
classify_issue() {
    local issue_type=$1
    local severity=${2:-"normal"}

    case "$issue_type" in
        "oauth_failure")
            if [[ "$severity" == "critical" ]]; then
                echo "🚨 CRITICAL: OAuth authentication failure - immediate response required"
                echo "→ Escalating to zillow-oauth-diagnosis skill"
                return 1
            fi
            ;;
        "transaction_sync")
            echo "⚠️  HIGH: Transaction sync failure detected"
            echo "→ Escalating to zillow-sync-diagnosis skill"
            return 2
            ;;
        "rate_limiting")
            if [[ "$severity" == "incident" ]]; then
                echo "🚨 INCIDENT: Rate limiting event - potential data loss"
                echo "→ Escalating to zillow-incident-recovery skill"
                return 3
            fi
            ;;
        "connection_health")
            echo "ℹ️  MONITORING: Connection health assessment needed"
            echo "→ Running health check diagnostics"
            return 4
            ;;
        *)
            echo "❓ UNKNOWN: Issue type not recognized"
            echo "Available types: oauth_failure, transaction_sync, rate_limiting, connection_health"
            return 255
            ;;
    esac
}
```

### Quick Response Checklists

#### Critical OAuth Failures
- [ ] Check token status in zillow_auth table
- [ ] Verify OAuth app configuration
- [ ] Check frontend useZillowAuth hook state
- [ ] Escalate to zillow-oauth-diagnosis

#### Transaction Sync Failures
- [ ] Verify deal has agents assigned
- [ ] Check agent resolution distribution
- [ ] Validate four-path agent verification
- [ ] Escalate to zillow-sync-diagnosis

#### Rate Limiting Incidents
- [ ] Identify affected webhook events
- [ ] Assess potential data loss
- [ ] Implement rate limiting response
- [ ] Escalate to zillow-incident-recovery

#### Connection Health Issues
- [ ] Compare against baseline metrics
- [ ] Check problem_at timestamps
- [ ] Assess degradation patterns
- [ ] Set up proactive monitoring