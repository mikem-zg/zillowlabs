---
name: zillow-integration-systems
description: Navigate, troubleshoot, and maintain FUB's existing Zillow integration systems with comprehensive codebase knowledge, production metrics, and operational debugging guidance across 6 production systems handling 677+ million sync events
parameters:
  system:
    type: string
    description: Target Zillow integration system (ZillowAuth, ZillowSyncUser, ZillowAgent, ZillowTeam, ZillowSyncAgent, ZillowSyncTeam, or 'all' for overview)
    required: false
  operation:
    type: string
    description: Operation type (troubleshoot, navigate, debug, monitor, analyze, schema, metrics)
    required: true
  issue:
    type: string
    description: Specific issue description, error message, or investigation target for troubleshooting
    required: false
  account_id:
    type: string
    description: FUB account ID for account-specific debugging and investigation
    required: false
---

## Overview

Navigate, troubleshoot, and maintain FUB's existing Zillow integration systems with comprehensive codebase knowledge, production metrics, and operational debugging guidance across 6 production systems handling 677+ million sync events. Provides systematic approach to Zillow integration system analysis, troubleshooting, and maintenance with production-ready operational guidance.

🏗️ **Production Systems**: [systems/production-systems.md](systems/production-systems.md)
🛠️ **Database & Frontend**: [architecture/database-frontend.md](architecture/database-frontend.md)
🔧 **Debugging Patterns**: [operations/debugging-patterns.md](operations/debugging-patterns.md)
🔍 **Advanced Troubleshooting**: [troubleshooting/advanced-scenarios.md](troubleshooting/advanced-scenarios.md)
📡 **API Integration**: [reference/api-integration.md](reference/api-integration.md)

## Usage

```bash
/zillow-integration-systems --operation=<op_type> [--system=<system_name>] [--issue=<description>] [--account_id=<id>]
```

## Core Workflow

### Essential Integration System Operations (Daily Troubleshooting - 80% of Usage)

**1. System Health Assessment and Issue Identification**
```bash
# Get overview of all integration systems health
/zillow-integration-systems --operation="monitor" --system="all"

# Analyze specific system for performance issues
/zillow-integration-systems --operation="analyze" --system="ZillowAgent" --issue="Slow agent resolution"

# Check transaction sync eligibility status
/zillow-integration-systems --operation="debug" --issue="Deal not syncing to Zillow" --account_id="12345"
```

**2. OAuth Authentication Troubleshooting (ZillowAuth System)**
```bash
# Debug authentication failures
/zillow-integration-systems --operation="troubleshoot" --system="ZillowAuth" --issue="Token refresh failing" --account_id="67890"

# Navigate OAuth token management codebase
/zillow-integration-systems --operation="navigate" --system="ZillowAuth" --issue="Invalid token format errors"

# Analyze OAuth flow for account-specific issues
/zillow-integration-systems --operation="debug" --system="ZillowAuth" --account_id="54321"
```

**3. Agent Resolution and Mapping (ZillowAgent System)**
```bash
# Troubleshoot agent not resolving to user
/zillow-integration-systems --operation="troubleshoot" --system="ZillowAgent" --issue="Agent not resolving to user" --account_id="12345"

# Debug agent profile sync issues
/zillow-integration-systems --operation="debug" --system="ZillowAgent" --issue="Agent profile data outdated"

# Navigate agent resolution logic
/zillow-integration-systems --operation="navigate" --system="ZillowAgent" --issue="Agent mapping inconsistencies"
```

**4. Team Management and Hierarchy (ZillowTeam System)**
```bash
# Debug team lead mapping issues
/zillow-integration-systems --operation="debug" --system="ZillowTeam" --issue="Team lead not mapping correctly" --account_id="78901"

# Troubleshoot team sync failures
/zillow-integration-systems --operation="troubleshoot" --system="ZillowTeam" --issue="Team members not syncing"

# Analyze team hierarchy resolution
/zillow-integration-systems --operation="analyze" --system="ZillowTeam" --issue="Team structure inconsistencies"
```

**5. Production System Investigation and Resolution**
```bash
# Monitor Bishop API integration health
/zillow-integration-systems --operation="monitor" --issue="Bishop notifications not sending"

# Debug transaction sync eligibility verification
/zillow-integration-systems --operation="debug" --issue="Transaction sync failing - agent verification" --account_id="45678"

# Navigate complex multi-system integration flows
/zillow-integration-systems --operation="navigate" --issue="Multi-system sync coordination problems"
```

### System Priority Matrix for Troubleshooting

| System | Critical Issues | Common Problems | Resolution Priority |
|--------|----------------|----------------|-------------------|
| `ZillowAuth` | Token expiration, OAuth failures | Rate limiting, refresh issues | **HIGH** - Affects all other systems |
| `ZillowAgent` | Agent not resolving | Profile sync lag, mapping errors | **HIGH** - Core functionality |
| `ZillowTeam` | Team lead mapping | Hierarchy sync issues | **MEDIUM** - Team features |
| `ZillowSyncUser` | User profile sync | Data consistency issues | **MEDIUM** - User experience |
| `ZillowSyncAgent` | Agent data sync | Performance optimization | **LOW** - Background sync |
| `ZillowSyncTeam` | Team data sync | Sync frequency tuning | **LOW** - Background sync |

### System Architecture Overview

#### Team Context: Zynaptic Overlords
**Primary Owner:** Zynaptic Overlords team (FUB+ Integrations and Authentication Team)
- **Engineering Manager:** CL Nolen
- **Team Members:** Matt Turland, Eric Medina, Christian Newberry, Nick Esquerra, Amisha Patel, Fernando Barraza
- **Support Channel:** #fub-zyno-support
- **Jira Board:** [ZYN Project](https://zillowgroup.atlassian.net/jira/software/c/projects/ZYN/boards/6168)

#### 6 Production Systems Architecture

**Modern Systems (2024-2025):**
1. **ZillowAuth** - OAuth credential management (29,561 records, 3,643 accounts)
2. **ZillowSyncUser** - Lead synchronization pipeline (12,407 records, 5,267 accounts)
3. **ZillowAgent** - Agent identity resolution (85,814 records, 6,864 accounts)
4. **ZillowTeam** - Team hierarchy management (4,414 records, 4,077 accounts)

**Legacy Systems (2022-2023, Still Active):**
5. **ZillowSyncAgent** - Legacy agent identity mapping
6. **ZillowSyncTeam** - Legacy team synchronization

### Quick Reference

#### Essential Operations

**OAuth Token Management:**
- **Key Files**: `ZillowAuth.php`, `ZillowTokenService.php`, `ZillowConnect.php`
- **Token encryption**: `Secrets::get('oauth_token_encryption_key')`
- **Health check**: Query `zillow_auth.expires_at` for expiration status

**Agent Resolution Methods:**
- **CONNECTED (46.72%)** - OAuth authenticated via ZillowAuth
- **INFERRED (15.99%)** - Team-based or heuristic matching
- **UNMATCHED (37.29%)** - No FUB user mapping found
- **Key Files**: `ZillowAgent.php:533`, `ZillowIdentityService.php`

**Transaction Sync Four-Path Verification:**
- **Path 1**: Legacy zillow_profile_id (deprecated)
- **Path 2**: OAuth authentication (zillow_auth table)
- **Path 3**: Modern agent records (zillow_agents with encrypted_zuid)
- **Path 4**: Legacy sync agents (zillow_sync_agents table)
- **Key Location**: `Transactions.php:885`

#### Common Investigation Patterns

**Agent Resolution Analysis:**
```bash
# Check resolution method distribution
serena-mcp --task="Find ZillowAgent resolution method usage" --scope="models"

# Debug specific agent resolution
database-operations --query="SELECT * FROM zillow_agents WHERE user_id = ?" --params="[USER_ID]"
```

**OAuth Token Debugging:**
```bash
# Check token health for account
datadog-management --query="@context.account_id:12345 @service:fub-api @message:*ZillowAuth*"

# Find expired tokens
database-operations --query="SELECT * FROM zillow_auth WHERE expires_at < NOW()"
```

**Transaction Sync Investigation:**
```bash
# Check sync eligibility for deal
serena-mcp --task="Find transaction sync eligibility logic" --scope="Transactions.php"

# Debug four-path verification
datadog-management --query="@message:*agent_verification_failed* @context.account_id:12345"
```

## Advanced Patterns

<details>
<summary>Click to expand comprehensive troubleshooting and multi-system coordination</summary>

### Multi-System Failure Scenarios

**Cascading OAuth Token Failures:**
When OAuth tokens expire, failures cascade across ZillowAuth → ZillowAgent → ZillowSyncUser → Transaction Sync. Advanced investigation requires tracing the complete dependency chain and identifying system-wide impact scope.

**Agent Resolution Method Conflicts:**
Team restructures create conflicts between CONNECTED (OAuth), INFERRED (team-based), and UNMATCHED (no resolution) states. Resolution requires temporary state overrides while systems synchronize.

**Transaction Sync Bottlenecks:**
High-volume accounts (10,000+ agents) require batched resolution queries and queue throttling to prevent timeout failures and system overload.

### Performance Optimization Techniques

**Bulk Agent Resolution:**
Large-scale agent operations use compound queries handling all 4 verification paths simultaneously, with rate limiting for Zillow API compliance and circuit breaker protection.

**Queue Management:**
Advanced queue processing implements dynamic batch sizing based on system load, failure rate monitoring, and automatic circuit breaker activation at 10% failure threshold.

**Caching Strategies:**
Resolution method caching, OAuth token validation caching, and team hierarchy caching reduce database load during high-volume operations.

📊 **Complete Troubleshooting Guide**: [troubleshooting/advanced-scenarios.md](troubleshooting/advanced-scenarios.md)
🏗️ **Detailed System Architecture**: [systems/production-systems.md](systems/production-systems.md)

</details>

## Integration Points

### Cross-Skill Workflow Patterns

**Zillow Systems → Support Investigation:**
```bash
# Investigate OAuth authentication failures
/zillow-integration-systems --operation="troubleshoot" --system="ZillowAuth" --issue="Token refresh failing" |
  /support-investigation --issue="ZYN-10585" --environment="production"

# Debug agent resolution problems with account context
/zillow-integration-systems --operation="debug" --system="ZillowAgent" --account_id="12345" |
  /support-investigation --issue="Agent mapping failures" --account_id="12345"
```

**Zillow Systems → Database Operations:**
```bash
# Validate transaction sync eligibility with database queries
/zillow-integration-systems --operation="debug" --issue="Deal not syncing" --account_id="67890" |
  /database-operations --operation="inspection" --account_id="67890"

# Check OAuth token health across accounts
/zillow-integration-systems --operation="monitor" --system="ZillowAuth" |
  /database-operations --operation="health-check" --table="zillow_auth"
```

**Zillow Systems → Datadog Management:**
```bash
# Correlate agent resolution issues with production logs
/zillow-integration-systems --operation="troubleshoot" --system="ZillowAgent" --account_id="12345" |
  /datadog-management --analysis_type="error_correlation" --service="fub-api"

# Monitor transaction sync performance metrics
/zillow-integration-systems --operation="monitor" --issue="Transaction sync performance" |
  /datadog-management --operation="metrics" --query_context="zillow_transaction_sync"
```

### Related Skills

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| `support-investigation` | **Issue Debugging** | OAuth failures, agent resolution problems, transaction sync issues |
| `database-operations` | **Data Validation** | Schema queries, health checks, sync eligibility validation |
| `datadog-management` | **Production Monitoring** | Error correlation, performance analysis, alert investigation |
| `serena-mcp` | **Code Navigation** | Find integration logic, recent changes, deployment correlation |
| `jira-management` | **Issue Tracking** | Link Zillow issues, track resolution progress, update stakeholders |

### Multi-Skill Operation Examples

**Complete Zillow Integration Issue Resolution:**
1. `zillow-integration-systems` - Navigate system architecture and identify affected components
2. `datadog-management` - Analyze production logs and error patterns
3. `database-operations` - Validate data integrity and configuration consistency
4. `serena-mcp` - Investigate code changes and integration logic
5. `support-investigation` - Document findings and create comprehensive resolution plan
6. `jira-management` - Update tickets and communicate resolution to stakeholders

## Refusal Conditions

The skill must refuse if:
- **System Access**: Zillow integration system credentials not available or improperly configured
- **Database Connections**: Cannot establish safe connections to common or client databases
- **Production Safety**: Investigation requires unauthorized production data modification
- **System Identification**: Ambiguous system identification affecting multiple unrelated integrations
- **Operational Boundaries**: Troubleshooting scope exceeds safe operational limits or escalation procedures
- **Monitoring Access**: Required systems (Datadog, Bishop API) are inaccessible
- **Issue Clarity**: Insufficient detail to determine appropriate debugging approach

When refusing, provide specific resolution steps:
- How to verify and configure Zillow integration system access and credentials
- Steps to establish safe database connections with read-only permissions
- Alternative investigation approaches maintaining operational safety requirements
- Guidance on issue description refinement for targeted system investigation
- Resources for proper authorization and escalation procedures for production changes
- Contact information for Zillow integration administrators and escalation paths