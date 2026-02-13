# Controllers and API Architecture

Controllers and API endpoints collectively owned and maintained by the **Zynaptic Overlords/FUB+ Integrations team**, organized by responsibility and integration system.

## API Controllers (apps/fub_api/controllers/)

### ZillowAgentsController.php
**Database Tables:** `zillow_agents`, `users`, `zillow_auth`
**Methods:**
- `index()` - List Zillow agents for account with user associations
- `create()` - Create new Zillow agent mapping
- `update()` - Update agent profile and user associations
- `delete()` - Remove agent mapping
- `show()` - Get individual agent details with authentication status

**StatsD Metrics:**
- `fubapi.zillow_agents.create`
- `fubapi.zillow_agents.update`
- `fubapi.zillow_agents.delete`
- `fubapi.zillow_agents.mapping_error`

### ZillowHomeLoansController.php
**Database Tables:** `zhl_loan_officers`, `zhl_dedicated_loan_officer_map`, `contacts`, `events`
**Methods:**
- `loanOfficers()` - Get available loan officers for account
- `dedicatedMapping()` - Retrieve territory-based officer mappings
- `transferContact()` - Execute contact transfer to loan officer
- `availability()` - Check officer availability for transfers
- `statistics()` - Get ZHL usage metrics for account

**StatsD Metrics:**
- `fubapi.zhl.transfer.success`
- `fubapi.zhl.transfer.failed`
- `fubapi.zhl.officer_lookup`
- `fubapi.zhl.availability_check`

### AgentMapController.php
**Database Tables:** `zillow_agents`, `users`, `zillow_auth`
**Methods:**
- `index()` - Get agent mappings with statistics
- `create()` - Create agent-to-user mapping
- `update()` - Modify mapping associations
- `sync()` - Trigger agent synchronization
- `statistics()` - Get mapping coverage statistics

**StatsD Metrics:**
- `fubapi.agent_map.created`
- `fubapi.agent_map.updated`
- `fubapi.agent_map.sync_triggered`
- `fubapi.agent_map.statistics_requested`

### ZillowAuthenticatedLinksController.php
**Database Tables:** `zillow_auth`, `accounts`, `users`
**Methods:**
- `mapZuidToAccount()` - Map Zillow user IDs to FUB accounts
- `validateAuthentication()` - Check OAuth token validity
- `linkStatus()` - Get authentication link status

**Monitoring Class:** `apps/richdesk/observability/ZillowAuthenticatedLinksMonitoring.php`
**Metric Prefix:** `zillow_authenticated_links`
**StatsD Metrics:**
- `zillow_authenticated_links.mapping_request`
- `zillow_authenticated_links.mapping_success`
- `zillow_authenticated_links.mapping_failed`
- `zillow_authenticated_links.auth_validation`

## Web Controllers (apps/richdesk/controllers/)

### ZillowSyncController.php
**Database Tables:** `zillow_sync_users`, `contact_sync_events`, `contacts`
**Methods:**
- `sync()` - Handle Zillow synchronization webhooks
- `leadEvents()` - Process lead event synchronization
- `agentSync()` - Synchronize agent profile data
- `statusUpdate()` - Update sync status tracking

**StatsD Metrics - Zillow Sync Operations:**
- `fubweb.zillowSync.webhook.failed`
- `fubweb.zillowSync.webhook.signature.usingClientId`
- `fubweb.zillowSync.webhook.teams.multipleIds`
- `fubweb.zillowSync.connection.problem`
- `fubweb.zillowSync.connection.problem.cleared`
- `fubweb.zillowSync.staleSync`
- `fubweb.zillowSync.requeue`
- `fubweb.zillowSync.cron.earlyTermination`

**StatsD Metrics - Agent Sync:**
- `fubweb.zillowSync.agentSync.initiated`
- `fubweb.zillowSync.agentSync.completed`
- `fubweb.zillowSync.agentSync.singleAgentSynced`
- `fubweb.zillowSync.agentSync.teamSynced`
- `fubweb.zillowSync.agentSync.teamMemberSynced`
- `fubweb.zillowSync.agentSync.agentRemovedFromTeam`
- `fubweb.zillowSync.agentSync.agentSoftDeleted`
- `fubweb.zillowSync.agentSync.inferredMatchFound`
- `fubweb.zillowSync.agentSync.getUserInfo.error`
- `fubweb.zillowSync.agentSync.getTeamMembers.error`

**StatsD Metrics - Lead Sync:**
- `fubweb.zillowSync.leadSync.emailSent`
- `fubweb.zillowSync.leadSync.emailFailed`
- `fubweb.zillowSync.leadSync.failed`

**StatsD Metrics - API Requests:**
- `fubweb.zillowSync.apiRequest.success`
- `fubweb.zillowSync.apiRequest.failed`
- `fubweb.zillowSync.apiRequest.fatal`
- `fubweb.zillowSync.accessToken.requested`
- `fubweb.zillowSync.accessToken.fromCache`

**StatsD Metrics - Team Sync:**
- `fubweb.zillowSync.teamSync.agentFoundAndMapped`
- `fubweb.zillowSync.teamSync.agentFoundButNotMapped`
- `fubweb.zillowSync.teamSync.agentStillNotFound`

**StatsD Metrics - Other Operations:**
- `fubweb.zillowSync.fullSync.failed`
- `fubweb.zillowSync.contactInfoSync.failed`
- `fubweb.zillowSync.notes.failed`
- `fubweb.zillowSync.agentResolution.mismatch`
- `fubweb.zillowSync.agentResolution.inferredMatch`

### OauthController.php
**Database Tables:** `zillow_auth`, `oauth_applications`, `security_tokens`, `refresh_tokens`
**Methods:**
- `authorize()` - Initiate OAuth flow for integrations
- `callback()` - Handle OAuth authorization callbacks
- `refresh()` - Refresh expired OAuth tokens
- `disconnect()` - Revoke OAuth authorization

**StatsD Metrics:**
- `fubapi.oauth.error`
- `fubweb.oauth.getEncryptionKey.failed`
- `fubweb.oauthRequest.failed`
- `fub.oauth.google.permissions.missing`
- `fub.signup.oauth.google.permissions.missing`

## Integration-Specific Metrics

### Zillow TechConnect API
**Controllers:** Multiple API controllers using TechConnect
**StatsD Metrics:**
- `fubapi.zillowTechConnect.response`
- `fubapi.zillowTechConnect.error`
- `fubapi.zillowTechConnect.data`
- `fubapi.zillowTechConnect.emailSent`
- `fubapi.zillowTechConnect.emailFailed`

### Zillow Mortgage Integration
**Controllers:** ZillowHomeLoansController and related
**StatsD Metrics:**
- `fubapi.zillowMortgages.data`

### Zillow Property Operations
**StatsD Metrics:**
- `fubweb.zillowPropertyInfoMatch.fetchRequestsSucceeded`
- `fubweb.zillowPropertyInfoMatch.fetchRequestsFailed`

### Zillow Billing and Pro Services
**StatsD Metrics:**
- `fubweb.billing.zillow_pro.*` (dynamic metric name based on operation)

### Zillow Transaction Management
**StatsD Metrics:**
- `fubweb.create_zillow_transaction.missing_ztid`

### Saved Search Integration
**StatsD Metrics:**
- `saved_search.create.zillow_failed`
- `saved_search.update.zillow_failed`
- `saved_search.delete.zillow_failed`

## Monitoring and Observability Classes

### ZillowAuthenticatedLinksMonitoring
**File:** `apps/richdesk/observability/ZillowAuthenticatedLinksMonitoring.php`
**Metric Prefix:** `zillow_authenticated_links`
**Purpose:** Monitors ZUID -> (account_id, user_id) mapping operations for FUB Subgraph integration

### ZillowEventPortalMonitoring
**File:** `apps/richdesk/observability/ZillowEventPortalMonitoring.php`
**Metric Prefix:** `zep`
**Purpose:** Monitors Zillow Event Portal related metrics and logging

## Rate Limiting Implementation

### Rate Limiting Files
**File:** `apps/fub_api/extensions/util/RateLimit.php`
**Related Classes:**
- `apps/fub_api/extensions/util/RateLimit/Identifier.php`
- `apps/fub_api/extensions/util/RateLimit/Limiter.php`
- `apps/fub_api/extensions/util/RateLimit/RegisteredSystemClientLimiter.php`

**Controllers Using Rate Limiting:**
- `ZillowAgentsController` - Zillow API rate limits
- `ZillowHomeLoansController` - ZHL API rate limits
- `AgentMapController` - Agent sync rate limits

## Database Access Patterns by Controller Type

### API Controllers (`apps/fub_api/controllers/`)
**Primary Pattern:** Account-scoped resource management
- All queries include `account_id` filtering
- Resource-based routing with account validation
- JSON API response format

### CSD Controllers (`apps/fub_csd/controllers/`)
**Primary Pattern:** Platform-wide administration
- Cross-account data access for admin operations
- System-level configuration management
- Administrative authentication required

### Web Controllers (`apps/richdesk/controllers/`)
**Primary Pattern:** Integration webhook handling
- Webhook signature validation
- Asynchronous processing integration
- Session-based authentication

## Testing Integration

### Controller Test Files Maintained by Team
- `apps/fub_api/tests/cases/controllers/ZillowAgentsControllerTest.php`
- `apps/fub_api/tests/cases/controllers/AgentMapControllerTest.php`
- `apps/fub_api/tests/cases/controllers/AppointmentsControllerTest.php`

### Rate Limit Test Files
- `apps/fub_api/tests/cases/extensions/util/RateLimitIntegrationTest.php`
- `apps/fub_api/tests/cases/extensions/util/RateLimitLimiterTest.php`
- `apps/fub_api/tests/cases/extensions/util/RateLimitRedisTest.php`
- `apps/fub_api/tests/cases/extensions/util/RateLimitTest.php`

## Integration Health Monitoring

### Key Metrics for Alerting
**High Priority Metrics:**
- `fubweb.zillowSync.connection.problem` - Zillow API connectivity issues
- `fubapi.oauth.error` - OAuth authentication failures
- `fubweb.zillowSync.webhook.failed` - Webhook processing failures
- `fubapi.zillowTechConnect.error` - TechConnect API errors

**Performance Metrics:**
- `fubweb.zillowSync.apiRequest.*` - API request success/failure rates
- `zillow_authenticated_links.mapping_*` - Authentication mapping performance
- `fubapi.zhl.transfer.*` - ZHL transfer success rates

### Monitoring Best Practices
1. **Use structured logging** with integration context
2. **Include account_id** in all metrics for segmentation
3. **Monitor rate limits** before hitting external API limits
4. **Track authentication failures** for security monitoring
5. **Alert on webhook processing failures** for real-time sync issues

When working with integration controllers:
1. **Reference actual file paths** for implementation details
2. **Use established method names** for consistency
3. **Follow account scoping patterns** in all integration controllers
4. **Implement proper StatsD metrics** for monitoring
5. **Use rate limiting** for external API interactions
6. **Test integration flows** with proper mock management