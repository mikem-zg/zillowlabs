---
name: zillow-oauth-diagnosis
description: Specialized troubleshooting for Zillow OAuth authentication failures, token validation, and connection status issues in FUB's integration with detailed analysis of FUB-specific OAuth patterns, ZillowTokenService validation, and production incident resolution
---

## Overview

Specialized troubleshooting for Zillow OAuth authentication failures, token validation, and connection status issues in FUB's integration. Provides detailed analysis with FUB-specific OAuth patterns, ZillowTokenService validation, token caching mechanisms, and production incident resolution across ZillowAuth and ZillowSyncUser storage systems.

## Usage

```bash
/zillow-oauth-diagnosis [--account_id=<id>] [--user_id=<id>] [--operation=<op>] [--environment=<env>] [--debug=<bool>] [--compare_sources=<bool>]
```

# Zillow OAuth Diagnosis

## Examples

```bash
# Detailed OAuth token analysis for specific user
/zillow-oauth-diagnosis --account_id="148261" --user_id="571" --operation="token_analysis"

# FUB OAuth token service validation (ZillowTokenService vs ZillowTokenServiceV2)
/zillow-oauth-diagnosis --operation="token_service_validation" --environment="production"

# Token refresh failure investigation with FUB caching
/zillow-oauth-diagnosis --account_id="14009" --operation="refresh_failure" --debug=true

# Connection status inconsistency (zillow_auth vs zillow_sync_users)
/zillow-oauth-diagnosis --account_id="157965" --operation="connection_status" --compare_sources=true
```

## FUB OAuth Architecture Overview

### Key Components
- **ZillowTokenService**: Legacy token management service ([fub/apps/richdesk/libraries/service/zillow/oauth/ZillowTokenService.php](https://gitlab.zgtools.net/fub/fub/-/blob/main/apps/richdesk/libraries/service/zillow/oauth/ZillowTokenService.php))
- **ZillowTokenServiceV2**: Modern service supporting both ZillowAuth and ZillowSyncUser ([ZillowTokenServiceV2.php](https://gitlab.zgtools.net/fub/fub/-/blob/main/apps/richdesk/libraries/service/zillow/oauth/ZillowTokenServiceV2.php))
- **ZillowAuth Model**: Primary OAuth storage in `common.zillow_auth` ([ZillowAuth.php](https://zillowgroup.atlassian.net/wiki/spaces/FUB/pages/2327380001/Zillow+Integration+Systems+-+Architecture+Guide))
- **ZillowSyncUser Model**: Legacy OAuth storage in `common.zillow_sync_users` ([ZillowSyncUser.php](https://gitlab.zgtools.net/fub/fub/-/blob/main/apps/richdesk/models/ZillowSyncUser.php))
- **OauthCache**: Token caching layer with TTL management

### Cache Key Patterns
```php
// FUB OAuth cache keys
"zillow-token-{account_id}-{user_id}-{zillow_sync_user_id}"        // Legacy
"zillow-auth-token-{account_id}-{user_id}-{zillow_auth_id}"       // Modern
```

### Token Refresh Buffer
- 30-second buffer before token expiration ([ZillowTokenServiceV2 implementation](https://gitlab.zgtools.net/fub/fub/-/blob/main/apps/richdesk/libraries/service/zillow/oauth/ZillowTokenServiceV2.php))
- Race condition prevention via `shouldRefreshToken()` validation
- Automatic cache invalidation on refresh failure

## Core Workflow

### Essential OAuth Diagnosis Steps (Most Common - 90% of Usage)

**1. Basic OAuth Status Check**
```bash
# Quick token analysis for specific user
/zillow-oauth-diagnosis --account_id="148261" --user_id="571" --operation="token_analysis"

# Production OAuth status validation
/zillow-oauth-diagnosis --operation="token_service_validation" --environment="production"
```

**2. Token Refresh Failure Investigation**
```bash
# Debug token refresh issues with detailed logging
/zillow-oauth-diagnosis --account_id="14009" --operation="refresh_failure" --debug=true

# Compare OAuth data sources for consistency
/zillow-oauth-diagnosis --account_id="157965" --operation="connection_status" --compare_sources=true
```

**3. Cross-System Validation**
```bash
# Run OAuth analysis script for comprehensive check
./scripts/fub-oauth-token-analysis.sh ACCOUNT_ID USER_ID

# Validate both token services
./scripts/fub-token-service-validation.sh ACCOUNT_ID USER_ID --force-refresh
```

### Preconditions
- **FUB Database Access**: Connection to common.zillow_auth and common.zillow_sync_users tables
- **Environment Context**: Clear understanding of production vs staging OAuth flows
- **Account/User IDs**: Valid FUB account and user identifiers for targeted analysis

## Available Scripts

### 1. OAuth Token Analysis Script
**Location:** `scripts/fub-oauth-token-analysis.sh`
**Purpose:** Comprehensive analysis of OAuth token status across both FUB storage systems

**Usage:**
```bash
./scripts/fub-oauth-token-analysis.sh ACCOUNT_ID USER_ID

# Example
./scripts/fub-oauth-token-analysis.sh 148261 571
```

**Output:**
- ZillowAuth record status and token freshness
- ZillowSyncUser legacy OAuth analysis
- Token service compatibility recommendations
- Recent OAuth activity correlation

### 2. Token Service Validation Script
**Location:** `scripts/fub-token-service-validation.sh`
**Purpose:** Test both ZillowTokenService and ZillowTokenServiceV2 functionality

**Usage:**
```bash
./scripts/fub-token-service-validation.sh ACCOUNT_ID USER_ID [--force-refresh]

# Example
./scripts/fub-token-service-validation.sh 14009 571 --force-refresh
```

**Features:**
- Tests both legacy and modern token services
- Cache inspection and validation
- Service recommendation based on available records
- Optional force refresh testing

### 3. OAuth Consistency Check Script
**Location:** `scripts/fub-oauth-consistency-check.sh`
**Purpose:** Cross-validate zillow_auth and zillow_sync_users table consistency

**Usage:**
```bash
# Single user analysis
./scripts/fub-oauth-consistency-check.sh ACCOUNT_ID USER_ID

# Account-wide analysis
./scripts/fub-oauth-consistency-check.sh ACCOUNT_ID
```

**Analysis:**
- Record pattern identification (Both Records, Auth Only, Sync Only)
- ZUID consistency validation
- Migration priority recommendations
- Token health distribution

### 4. Databricks OAuth Analytics Script
**Location:** `scripts/fub-databricks-oauth-analysis.sh`
**Purpose:** Production data correlation and historical OAuth analysis via Databricks

**Usage:**
```bash
# Production OAuth correlation analysis
./scripts/fub-databricks-oauth-analysis.sh --account_id="148261" --operation="correlation"

# Account-wide OAuth health metrics
./scripts/fub-databricks-oauth-analysis.sh --account_id="148261" --operation="health_metrics"

# Historical OAuth activity analysis
./scripts/fub-databricks-oauth-analysis.sh --account_id="148261" --operation="activity_history" --days=30

# Cross-environment validation (staging vs production)
./scripts/fub-databricks-oauth-analysis.sh --account_id="148261" --operation="environment_validation"
```

**Features:**
- Production data correlation with local OAuth analysis
- Account-wide OAuth health and adoption metrics
- Historical OAuth activity and problem tracking
- Cross-catalog validation (fub vs fub_zg vs stage_fub)
- Integration health monitoring via Zillow-specific Databricks tables

## Quick Reference

### Common OAuth Error Messages (FUB Context)

| Error Message | FUB Context | Resolution | Reference |
|---------------|-------------|------------|-----------|
| `"Zillow OAuth Refresh token invalid"` | `ZillowSyncUser.problem_msg` field | User re-authentication required | [Zillow sync FAQ](https://zillowgroup.atlassian.net/wiki/spaces/FUB/pages/1863421945/Zillow+sync+FAQ+Troubleshooting) |
| `"OAuth credentials valid, but integration disabled"` | Token refresh works, API calls fail | Enable integration in Premier Agent | [ZYN-10277 case](https://zillowgroup.atlassian.net/browse/ZYN-10277) |
| `"CANNOT_RETRIEVE_ACCCESS_TOKEN"` | `ZillowConnectException` from TokenServiceV2 | Check for rate limiting or network issues | [ZillowTokenServiceV2 error handling](https://gitlab.zgtools.net/fub/fub/-/blob/main/apps/richdesk/libraries/service/zillow/oauth/ZillowTokenServiceV2.php) |

### Token Service Selection Guide

**ZillowTokenServiceV2 (Recommended):**
- ✅ Supports both ZillowAuth and ZillowSyncUser ([Tech debt note in source](https://gitlab.zgtools.net/fub/fub/-/blob/main/apps/richdesk/libraries/service/zillow/oauth/ZillowTokenServiceV2.php))
- ✅ Enhanced error handling with ZillowConnectException
- ✅ 30-second refresh buffer prevents race conditions

**ZillowTokenService (Legacy):**
- ⚠️ ZillowSyncUser support only
- ⚠️ Will be deprecated in favor of V2

### Environment Configuration

```php
// Development
'zillow_oauth_domain' => 'https://authv2.tes500.zillow.net'

// QA ([VPN required](https://zillowgroup.atlassian.net/wiki/spaces/FUB/pages/998539332/Connecting+Zillow+Premier+Agent+Integration+in+QA+Environment))
'zillow_oauth_domain' => 'https://authv2.qa.zillow.net'

// Production
'zillow_oauth_domain' => 'https://authv2.zillow.com'
```

## Real Production Cases

### Case 1: Account 148261 - Integration Disabled ([ZYN-10277](https://zillowgroup.atlassian.net/browse/ZYN-10277))
- **Diagnosis**: ZillowAuth present, tokens refreshing successfully
- **Issue**: Zillow Premier Agent integration disabled
- **Script**: `fub-oauth-token-analysis.sh 148261 [user_id]`
- **Resolution**: Manual re-enable in [Premier Agent settings](https://premieragent.zillow.com/settings/app-integrations)

### Case 2: Nov 17, 2025 Rate Limiting Incident ([ZYN-10630](https://zillowgroup.atlassian.net/browse/ZYN-10630))
- **Impact**: ZillowTokenService refresh failures during HTTP 429 responses
- **FUB Behavior**: Enhanced error handling in ZillowTokenServiceV2
- **Recovery**: Manual token refresh after rate limiting ended
- **Prevention**: [Re-enabled retry mechanisms](https://zillowgroup.atlassian.net/browse/ZYN-10630)

### Case 3: Agent Resolution Inconsistency ([Root Cause Report](https://zillowgroup.atlassian.net/wiki/spaces/~7120204c31365177164c70a31213cb148f959c/pages/2124054609))
- **Pattern**: User showing "Inferred" instead of "Connected" status
- **Root Cause**: Stale zillow_agents table vs current OAuth status
- **Tool**: `fub-oauth-consistency-check.sh` for validation
- **Solution**: Use [agent_identity_mapping](https://zillowgroup.atlassian.net/wiki/spaces/~7120204c31365177164c70a31213cb148f959c/pages/2124054609) as ground truth

## Monitoring Queries

### Databricks Analytics Queries for OAuth Health

Based on [Claude Code usage patterns](/.claude/projects/*/history.jsonl) and production Databricks tables, common OAuth analysis queries:

**Production OAuth Status Correlation:**
```sql
-- Validate OAuth connections across systems
SELECT
    za.account_id,
    za.user_id,
    za.zuid,
    CASE WHEN za.encrypted_refresh_token IS NOT NULL THEN 'ACTIVE' ELSE 'INACTIVE' END as token_status,
    zsu.zillow_email,
    zsu.problem_msg,
    zsu.last_verified_at
FROM fub.agents_silver.zillow_auth za
LEFT JOIN fub.agents_silver.zillow_sync_users zsu ON za.account_id = zsu.account_id AND za.user_id = zsu.user_id
WHERE za.account_id = {ACCOUNT_ID}
ORDER BY za.updated_at DESC;
```

**Account-Wide OAuth Health Metrics:**
```sql
-- OAuth adoption and health assessment
SELECT
    account_id,
    COUNT(*) as total_users,
    COUNT(CASE WHEN encrypted_refresh_token IS NOT NULL THEN 1 END) as active_oauth_users,
    COUNT(CASE WHEN problem_at IS NOT NULL THEN 1 END) as users_with_problems,
    ROUND(100.0 * COUNT(CASE WHEN encrypted_refresh_token IS NOT NULL THEN 1 END) / COUNT(*), 2) as oauth_adoption_rate
FROM fub.agents_silver.zillow_auth za
LEFT JOIN fub.agents_silver.zillow_sync_users zsu ON za.account_id = zsu.account_id AND za.user_id = zsu.user_id
WHERE account_id = {ACCOUNT_ID}
GROUP BY account_id;
```

**Historical OAuth Activity Analysis:**
```sql
-- OAuth problem trends and resolution patterns
SELECT
    DATE_TRUNC('day', problem_at) as problem_date,
    COUNT(*) as problems_reported,
    COUNT(CASE WHEN last_verified_at > problem_at THEN 1 END) as problems_resolved,
    AVG(TIMESTAMPDIFF(HOUR, problem_at, last_verified_at)) as avg_resolution_hours
FROM fub.agents_silver.zillow_sync_users
WHERE account_id = {ACCOUNT_ID}
    AND problem_at >= CURRENT_DATE - INTERVAL 30 DAYS
GROUP BY DATE_TRUNC('day', problem_at)
ORDER BY problem_date DESC;
```

**Zillow Lead Events Correlation:**
```sql
-- OAuth issues correlation with lead event failures
SELECT
    lle.owner_agent_id,
    COUNT(*) as lead_events,
    COUNT(CASE WHEN za.encrypted_refresh_token IS NULL THEN 1 END) as events_without_oauth,
    MAX(lle.created_at) as last_lead_event
FROM fub.contacts_bronze.zillow_lead_events_logs lle
LEFT JOIN fub.agents_silver.zillow_auth za ON lle.owner_agent_id = za.zuid
WHERE lle.created_at >= CURRENT_DATE - INTERVAL 7 DAYS
GROUP BY lle.owner_agent_id
HAVING events_without_oauth > 0
ORDER BY events_without_oauth DESC;
```

**Cross-Environment OAuth Validation:**
```sql
-- Production vs Staging OAuth consistency
SELECT
    'production' as environment,
    COUNT(*) as oauth_records,
    COUNT(CASE WHEN encrypted_refresh_token IS NOT NULL THEN 1 END) as active_tokens
FROM fub.agents_silver.zillow_auth
WHERE account_id = {ACCOUNT_ID}

UNION ALL

SELECT
    'staging' as environment,
    COUNT(*) as oauth_records,
    COUNT(CASE WHEN encrypted_refresh_token IS NOT NULL THEN 1 END) as active_tokens
FROM stage_fub.agents_silver.zillow_auth
WHERE account_id = {ACCOUNT_ID};
```

### Datadog Patterns for FUB OAuth
```javascript
// Token service usage
"service:fub @context.class:(ZillowTokenService OR ZillowTokenServiceV2)"

// Cache operations ([OAuth cache implementation](https://gitlab.zgtools.net/fub/fub/-/blob/main/apps/richdesk/libraries/service/OauthCache.php))
"service:fub @context.cache_key:*zillow*token* @context.cache_operation:*"

// OAuth errors
"service:fub status:error @context.exception:ZillowConnectException"

// Refresh buffer operations (30-second buffer)
"service:fub @context.method:shouldRefreshToken @context.buffer_seconds:30"
```

### StatsD Metrics ([Existing metrics](https://zillowgroup.atlassian.net/wiki/spaces/FUB/pages/1588626095/Zillow+Sync+-+Existing+Datadog+Metrics))
```javascript
'fubweb.zillowSync.accessToken.fromCache'      // Cache hit rate
'fubweb.zillowSync.accessToken.requested'      // New token requests
'fubweb.zillowSync.accessToken.refreshFailed'  // Refresh failures
```

## Advanced Patterns

### Enterprise-Scale OAuth Management

**Multi-Tenant OAuth Analysis:**
Complex enterprise environments with thousands of users require advanced OAuth pattern analysis including bulk token validation, cross-account OAuth health assessment, and automated renewal strategies with minimal service disruption.

**High-Frequency Token Refresh Optimization:**
High-volume applications require sophisticated token refresh patterns with predictive renewal, connection pooling, and rate limit management to minimize API overhead and prevent OAuth throttling.

**Cross-Environment OAuth Synchronization:**
Advanced patterns for maintaining OAuth consistency across development, staging, and production environments with automated validation and conflict resolution strategies.

### Advanced Token Service Architecture

**Hybrid Token Service Implementation:**
Complex scenarios requiring both ZillowTokenService and ZillowTokenServiceV2 with intelligent service selection, fallback mechanisms, and gradual migration patterns without service interruption.

**Distributed Token Caching Strategies:**
Enterprise caching patterns with distributed cache invalidation, token lifecycle management across multiple application servers, and cache coherence validation.

**Token Security Hardening:**
Advanced security patterns including token encryption key rotation, secure token storage validation, and OAuth flow security auditing for compliance requirements.

### Complex OAuth Flow Diagnostics

**Multi-Step OAuth Failure Analysis:**
Sophisticated diagnostic patterns for complex OAuth failures involving multiple system interactions, cascading failures, and cross-service dependency analysis.

**Performance Impact Assessment:**
Advanced analysis techniques for OAuth performance impact including latency analysis, throughput optimization, and resource utilization assessment across the entire authentication chain.

**Historical OAuth Pattern Analysis:**
Complex data analysis patterns using Databricks for OAuth trend identification, failure prediction, and proactive maintenance scheduling based on historical patterns.

### Integration Architecture Optimization

**Event-Driven OAuth Management:**
Advanced patterns for OAuth event processing including real-time token status monitoring, automated failure recovery, and integration with enterprise event streaming platforms.

**OAuth Health Monitoring Systems:**
Sophisticated monitoring patterns with predictive alerting, automated diagnostics, and integration with observability platforms for proactive OAuth maintenance.

**Cross-System OAuth Coordination:**
Advanced patterns for OAuth coordination across multiple integrated systems including dependency management, cascading update handling, and system-wide OAuth health validation.

### Production Incident Response Patterns

**Automated OAuth Incident Detection:**
Advanced incident detection patterns with machine learning-based anomaly detection, automated escalation procedures, and integration with incident management systems.

**Emergency OAuth Recovery Procedures:**
Complex recovery patterns for catastrophic OAuth failures including bulk token regeneration, service failover procedures, and business continuity maintenance.

**Post-Incident OAuth Analysis:**
Comprehensive post-incident analysis patterns including root cause investigation, system resilience assessment, and preventive measure implementation.

## Integration Points

### Databricks Analytics Integration
```bash
# Production data correlation with OAuth diagnosis
zillow-oauth-diagnosis --account_id="148261" --operation="token_analysis" | \
    databricks-analytics --operation="query" --catalog="fub" --query="OAuth correlation analysis"

# Historical OAuth trend analysis
zillow-oauth-diagnosis --account_id="148261" --operation="databricks_correlation" | \
    databricks-analytics --operation="analyze" --catalog="fub" --schema="agents_silver" --timeframe="past_month"

# Cross-environment OAuth validation
databricks-analytics --operation="query" --catalog="fub,stage_fub" --query="OAuth environment consistency" | \
    zillow-oauth-diagnosis --operation="consistency_check" --validation="databricks"
```

### Database Operations Integration
```bash
# Safe OAuth analysis with production database access
zillow-oauth-diagnosis --account_id="12345" --operation="token_analysis" | \
    database-operations --environment="production" --operation="inspection"
```

### Support Investigation Integration
```bash
# Document OAuth findings for incident tracking
zillow-oauth-diagnosis --operation="token_service_validation" --account_id="148261" | \
    support-investigation --issue="FUB OAuth Service Failure" --priority="P2"
```

### Zillow Integration Systems Integration
```bash
# OAuth diagnosis as part of broader integration troubleshooting
zillow-oauth-diagnosis --account_id="148261" --operation="connection_status" | \
    zillow-integration-systems --operation="system_health_check" --focus="oauth"
```

## Related Documentation

### Zynaptic Overlords Team Resources
- [Zynaptic Overlords Team](https://zillowgroup.atlassian.net/wiki/spaces/FUB/pages/771653669) - Primary team responsible for Zillow integrations
- **Support Channel:** #fub-zyno-support
- **Team Members:** Matt Turland, Eric Medina, Christian Newberry, Nick Esquerra, Amisha Patel, Fernando Barraza

### Technical Implementation Guides
- [Zillow Integration: OAuth Authentication and Agent Linking](https://zillowgroup.atlassian.net/wiki/spaces/FUB/pages/1504051597) - Technical OAuth implementation guide including `useZillowAuth` hook
- [Zillow Integration Systems - Architecture Guide](https://zillowgroup.atlassian.net/wiki/spaces/FUB/pages/2327380001) - Comprehensive 6-system architecture overview
- [Zillow Two-Way Sync Demo and Testing Guide](https://zillowgroup.atlassian.net/wiki/spaces/~7120204c31365177164c70a31213cb148f959c/pages/1685258635) - OAuth flow testing procedures
- [FUB GraphQL Proxy](https://zillowgroup.atlassian.net/wiki/spaces/FUB/pages/1458438298) - Token management for GraphQL endpoints
- [Working with OAuth Tokens](https://gitlab.zgtools.net/devex/docs/zgtools-net/-/blob/main/docs/building-blocks/ciam/references/platform-offerings/legacy/zillow-oauth/working-with-oauth-tokens.md) - Zillow OAuth token lifecycle

### Frontend Implementation References
- **useZillowAuth Hook:** `fub-spa/src/features/zillow-auth/hooks/use-zillow-auth`
- **ZillowAgentCard Component:** `fub-spa/src/features/zillow-auth/components/zillow-agent-card.jsx`
- **Settings Integration:** `fub-spa/src/pages/settings/default/zillow-settings.jsx`

### System Domain Mapping
- [FUB/Zillow System & Domain Guide](https://zillowgroup.atlassian.net/wiki/spaces/FUB/pages/1764819098) - Team responsibility matrix

## Refusal Conditions

This skill refuses if:
- **Missing FUB Context**: Cannot analyze without understanding FUB's OAuth architecture
- **Database Unavailable**: Cannot access zillow_auth or zillow_sync_users via [fub-db.sh](/.claude/skills/database-operations/scripts/fub-db.sh)
- **Token Service Risk**: Operations that could break FUB's token caching mechanisms
- **Production Safety**: Operations that could invalidate live OAuth tokens

When refusing, provide:
- **Safe Analysis Methods**: Read-only approaches using fub-db.sh
- **FUB OAuth Architecture**: Reference to [token service differences](https://gitlab.zgtools.net/fub/fub/-/blob/main/apps/richdesk/libraries/service/zillow/oauth/)
- **Production Safety**: Explanation of token risks and alternatives
- **Required Scripts**: Which diagnostic scripts can be used safely

**Critical Safety Note**: FUB's OAuth implementation uses encrypted refresh tokens and sophisticated caching. Always validate operations in development before applying to production. [ZillowTokenServiceV2 is preferred](https://gitlab.zgtools.net/fub/fub/-/blob/main/apps/richdesk/libraries/service/zillow/oauth/ZillowTokenServiceV2.php) for new implementations while maintaining backward compatibility.