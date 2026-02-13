## API Integration Points

### Zillow API Endpoints

#### OAuth Endpoints
- `authorization` => 'https://api.bridge.zillow.com/oauth/authorize'
- `token_exchange` => 'https://api.bridge.zillow.com/oauth/token'
- `token_refresh` => 'https://api.bridge.zillow.com/oauth/token'

#### Data Endpoints
- `user_info` => '/v1/userInfo' (User and team data)
- `team_members` => '/v1/teams/{id}/members' (Team members)
- `lead_sync` => '/v1/leads' (Lead synchronization)
- `transactions` => '/v1/transactions' (Transaction sync)

### Bishop API Integration

**Bishop GraphQL endpoint configuration:**
- **Staging**: https://api.stage.zillow.com/graphql
- **Production**: Varies by environment

**HMAC Authentication pattern:**
```php
$signature = hash_hmac('sha256',
    $this->getSignatureString($request, $date),
    $this->config->getSecret()
);
```

### Event Portal Integration

**CloudEvents format for Zillow event streaming**

#### Endpoints
- **Consumer**: https://api.zillow.com/events/consumer
- **ITRC**: https://api.zillow.com/events/itrc

#### SNS Integration
- **Staging**: arn:aws:sns:us-east-1:324733501228:zillow-tech-connect-follow-up-boss-test
- **Production**: arn:aws:sns:us-east-1:324733501228:zillow-tech-connect-follow-up-boss

### Integration Services Architecture

#### Core Integration Services Directory Structure

**Identity Services:**
- `/apps/richdesk/integrations/zillow/identity/ZillowIdentityService.php` - Core identity resolution
- `/apps/richdesk/integrations/zillow/identity/ZillowIdMapperService.php` - ID mapping logic
- `/apps/richdesk/integrations/zillow/identity/dtos/` - Identity DTOs

**API Integration:**
- `/apps/richdesk/integrations/zillow/bishop/` - Bishop API integration
- `/apps/richdesk/integrations/zillow/event_platform/` - Event streaming
- `/apps/richdesk/integrations/zillow/graph/` - Zillow Graph API
- `/apps/richdesk/integrations/zillow/ZillowApiAgentSyncDataSource.php` - API data source

#### OAuth and Token Management

**OAuth Services:**
- `/apps/richdesk/libraries/service/zillow/oauth/ZillowTokenService.php` - Token management
- `/apps/richdesk/libraries/service/zillow/oauth/ZillowTokenServiceV2.php` - V2 token service
- `/apps/richdesk/libraries/service/zillow/oauth/ZillowProviderWrapper.php` - OAuth provider wrapper
- `/apps/richdesk/libraries/service/zillow/oauth/ZillowApi.php` - API client

**Utility Services:**
- `/apps/richdesk/libraries/service/zillow/util/Transactions.php` - Transaction sync (4-path verification)
- `/apps/richdesk/libraries/service/zillow/util/ZillowLeadEventsSync.php` - Lead event processing
- `/apps/richdesk/libraries/service/zillow/util/ZillowTechConnect.php` - Tech Connect integration

#### Communication and Queue Workers

**Communication Services:**
- `/apps/richdesk/communications/ZillowSync.php` - Lead sync operations
- `/apps/richdesk/communications/ZillowConnect.php` - OAuth connection management

**Queue Workers:**
- `/apps/richdesk/extensions/command/ZillowSyncWorker.php` - Resque queue worker
- `/apps/richdesk/extensions/command/ZillowPropertySyncWorker.php` - Property sync worker

### Configuration Management

#### Environment Configuration Locations

**Primary config file:** `/fub/apps/richdesk/config/bootstrap/config.php.example`

#### Bishop API Configuration
```php
'bishop_api_base_url' => 'https://api.stage.zillow.com/graphql',
'bishop_api_username' => 'FollowUpBoss', // stored in 1Password
'bishop_api_secret' => '[SECRET]',       // stored in 1Password
```

#### OAuth Configuration
```php
'zillow_oauth_client_id' => 'FollowUpBoss',
'zillow_oauth_client_secret' => '[SECRET]',      // AWS Secrets Manager
'zillow_oauth_domain' => 'https://authv2.zillow.com',
```

#### Feature Flag Configuration
```php
// Critical feature flags affecting Zillow operations
'zillow-ignore-transaction-creation-events' => false,  // Disable outbound transaction creation
'enhanced_fub_deal_fields' => true,                    // Enable extended deal metadata sync
'zillow-oauth-pkce' => true,                          // Enable OAuth PKCE flow support
```

### Monitoring and Observability

#### Production Metrics Tracking

**StatsD Metrics Patterns (fubweb.* prefix):**

```php
// Bishop API performance tracking
StatsD::timing('fubweb.bishop.request.duration', $duration);
StatsD::increment('fubweb.bishop.request.count');
StatsD::increment('fubweb.bishop.error.count');

// OAuth token management metrics
StatsD::increment('fubweb.zillowSync.accessToken.fromCache');
StatsD::increment('fubweb.zillowSync.accessToken.requested');

// Transaction sync tracking
StatsD::increment('fubweb.create_zillow_transaction.missing_ztid');
StatsD::increment('fubweb.zillowSync.transaction.created');
StatsD::increment('fubweb.zillowSync.transaction.updated');
```

#### Datadog Query Reference

**Common Monitoring Queries:**

```bash
# Account-specific Zillow integration errors
@context.account_id:12345 @message:*Zillow* status:error

# OAuth authentication failure tracking
@service:fub-api @message:*ZillowAuth* @zillow_error_type:authentication_failed

# Background sync worker monitoring
@service:fub-worker @class:ZillowSyncWorker status:error

# Agent resolution method tracking
@correlation_id:zillow-agent-resolution @resolution_method:(CONNECTED OR INFERRED OR UNMATCHED)

# Transaction sync failure investigation
@message:*zillow_transaction* @event:transaction_sync_failed

# Bishop API integration monitoring
@service:fub-api @integration:bishop @method:GraphQL status:error

# Lead sync pipeline health
@service:fub-api @zillow_sync_user_id:* @health:(healthy OR warning OR error)
```

### Error Handling and Exception Management

#### Exception Hierarchy

**BishopException Error Codes:**
```php
// /apps/richdesk/integrations/zillow/bishop/BishopException.php
const CODE_MISSING_CONFIGURATION = 1;        // Missing configuration values
const CODE_REQUEST_FAILED = 2;               // HTTP/network request failures
const CODE_GRAPHQL_VALIDATION_FAILED = 3;    // GraphQL schema validation errors
```

**Transaction Sync Error Categories:**
- **Configuration Errors**: `deal_id_missing`, `sync_system_missing`
- **Integration Errors**: `zillow_transaction_id_missing`, `agent_verification_failed`
- **Data Integrity Errors**: `contact_sync_missing`, `property_missing`

#### Logging and Audit Trail

**Connection Log Tracking:**
- Table: `zillow_connection_logs` (Common Database)
- Purpose: Audit trail for resolution method changes and connection status
- Key fields: `account_id`, `user_id`, `old_resolution`, `new_resolution`, `change_reason`

**Lead Events Log:**
- Table: `zillow_lead_events_log` (Common Database)
- Purpose: Lead synchronization event tracking and debugging
- Key fields: `sync_user_id`, `event_type`, `lead_data`, `sync_status`, `error_message`

### Integration Testing and Validation

#### Health Check Endpoints

**OAuth Token Validation:**
```php
// Check token health across accounts
$healthQuery = "
    SELECT za.account_id,
           COUNT(*) as auth_records,
           COUNT(CASE WHEN za.expires_at > NOW() THEN 1 END) as valid_tokens,
           COUNT(CASE WHEN za.expires_at <= NOW() THEN 1 END) as expired_tokens
    FROM zillow_auth za
    GROUP BY za.account_id
    HAVING COUNT(*) > 0
";
```

**Agent Resolution Health:**
```php
// Monitor resolution method distribution
$resolutionQuery = "
    SELECT resolution_method, COUNT(*) as count,
           (COUNT(*) * 100.0 / SUM(COUNT(*)) OVER()) as percentage
    FROM zillow_agents
    GROUP BY resolution_method
";
```

**Transaction Sync Eligibility:**
```php
// Validate sync eligibility requirements
$eligibilityQuery = "
    SELECT d.id, d.property_id,
           COUNT(DISTINCT da.agent_id) as agent_count,
           COUNT(DISTINCT dc.contact_id) as contact_count
    FROM deals d
    LEFT JOIN deals_agents da ON d.id = da.deal_id
    LEFT JOIN deals_contacts dc ON d.id = dc.deal_id
    WHERE d.account_id = ? AND d.id = ?
    GROUP BY d.id, d.property_id
";
```