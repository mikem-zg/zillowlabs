## Core Operations and Debugging Patterns

### Agent Resolution Troubleshooting

Agent resolution method distribution:
- **CONNECTED (46.72%)** - OAuth authenticated via ZillowAuth
- **INFERRED (15.99%)** - Team-based or heuristic matching
- **UNMATCHED (37.29%)** - No FUB user mapping found

**Key files for agent resolution debugging:**
- `/apps/richdesk/models/ZillowAgent.php:533` - getResolutionMethodByUserId()
- `/apps/richdesk/models/ZillowAgentResolutionMethod.php` - Resolution enum logic
- `/apps/richdesk/integrations/zillow/identity/ZillowIdentityService.php` - Core resolution service

#### Agent Resolution Issues Debug Code
```php
// Check agent resolution method transitions
// File: /apps/richdesk/models/ZillowAgent.php:146
public function canTransition(int $resolutionMethod): bool
{
    // All transitions allowed for operational flexibility
    return true;
}

// Debug resolution priority:
// CONNECTED (priority 3) > INFERRED (priority 2) > UNMATCHED (priority 1)
```

#### Resolution Method Transitions

All resolution method transitions are allowed for operational flexibility:
- **UNMATCHED → CONNECTED**: User authenticates via OAuth
- **UNMATCHED → INFERRED**: System finds team-based match
- **INFERRED → CONNECTED**: User authenticates, upgrading to verified
- **CONNECTED → UNMATCHED**: OAuth disconnection or user removal

### OAuth Token Management

ZillowAuth system manages OAuth credentials in common database.

**Key files:**
- `/apps/richdesk/models/ZillowAuth.php` - Core OAuth model
- `/apps/richdesk/libraries/service/zillow/oauth/ZillowTokenService.php` - Token management
- `/apps/richdesk/communications/ZillowConnect.php` - OAuth flow

**Token encryption key location:** `Secrets::get('oauth_token_encryption_key')`

#### OAuth Token Troubleshooting Code
```php
// Token refresh flow debugging
// File: /apps/richdesk/libraries/service/zillow/oauth/ZillowTokenService.php

// Check token expiration
if ($zillowAuth->isExpired()) {
    // Token refresh required
}

// Encryption key validation
$key = Secrets::get('oauth_token_encryption_key', [])['key'] ?? null;
if ($key === null) {
    throw new ContextualException('token_encryption_key_missing');
}
```

### Transaction Sync Four-Path Verification

Transaction sync requires agent verification via 4 paths (Transactions.php:885-1017):
- **Path 1**: Legacy zillow_profile_id (deprecated)
- **Path 2**: OAuth authentication (zillow_auth table)
- **Path 3**: Modern agent records (zillow_agents with encrypted_zuid)
- **Path 4**: Legacy sync agents (zillow_sync_agents table)

**Key debugging location:** `/apps/richdesk/libraries/service/zillow/util/Transactions.php:885`

#### Transaction Sync Eligibility Debug Code
```php
// Four-path agent verification
// File: /apps/richdesk/libraries/service/zillow/util/Transactions.php:885

// Path 1: Legacy zillow_profile_id (deprecated)
$profile = $agent->getZillowProfile();

// Path 2: OAuth authentication
$auth = ZillowAuth::findByUser($agent);

// Path 3: Modern agent records
$zillowAgent = ZillowAgent::findByUser($agent);

// Path 4: Legacy sync agents
$syncAgent = ZillowSyncAgent::findByUser($agent);
```

### Sync Eligibility Requirements

For a Deal to sync to Zillow, it must have:
1. **Property**: Associated property record with address
2. **Agent**: At least one agent linked via any of the 4 verification paths
3. **Contact**: At least one contact with active ZillowSyncUser connection
4. **Sync System**: Valid DataSyncSystem record for the account

**Mutex Protection** (prevents concurrent operations):
- Key format: `zillow-transaction-sync:{syncUserId}`
- Expire time: 60 seconds

### Health Monitoring Patterns

ZillowSyncUser connection health tracking methods:
- `$syncUser->hasHealthyConnection()` - Overall health status
- Status values: `'healthy'`, `'warning'`, `'error'`

### Common Error Patterns

#### Transaction Sync Error Scenarios
Common error scenarios from `Transactions.php`:
- `deal_id_missing` - Deal ID not provided in sync request
- `sync_system_missing` - DataSyncSystem record not found
- `zillow_transaction_id_missing` - Zillow response missing transaction ID
- `agent_verification_failed` - No valid agent found via 4-path verification
- `contact_sync_missing` - No Zillow-synced contacts on deal
- `property_missing` - Deal missing required property information

#### BishopException Codes
```php
// File: /apps/richdesk/integrations/zillow/bishop/BishopException.php

const CODE_MISSING_CONFIGURATION = 1;        // Missing config values
const CODE_REQUEST_FAILED = 2;               // HTTP/network failures
const CODE_GRAPHQL_VALIDATION_FAILED = 3;    // GraphQL schema validation
```

### Production Monitoring and Metrics

#### StatsD Metrics Reference

Key production metrics with `fubweb.*` prefix:

**Bishop API Metrics:**
- `fubweb.bishop.request.duration` - Request timing
- `fubweb.bishop.request.count` - Total requests
- `fubweb.bishop.error.count` - Errors by type

**OAuth Token Metrics:**
- `fubweb.zillowSync.accessToken.fromCache` - Cache hit rate
- `fubweb.zillowSync.accessToken.requested` - New token requests

**Transaction Sync Metrics:**
- `fubweb.create_zillow_transaction.missing_ztid` - Missing transaction ID
- `fubweb.zillowSync.transaction.created` - Successful creation
- `fubweb.zillowSync.transaction.updated` - Transaction updates

#### Datadog Query Patterns

**Account-specific Zillow errors:**
```
@context.account_id:12345 @message:*Zillow* status:error
```

**OAuth authentication failures:**
```
@service:fub-api @message:*ZillowAuth* @zillow_error_type:authentication_failed
```

**Sync worker failures:**
```
@service:fub-worker @class:ZillowSyncWorker status:error
```

**Agent resolution tracking:**
```
@correlation_id:zillow-agent-resolution @resolution_method:(CONNECTED OR INFERRED OR UNMATCHED)
```

**Transaction sync failures:**
```
@message:*zillow_transaction* @event:transaction_sync_failed
```

### Feature Flags and Configuration

#### Critical Feature Flags

Feature flags affecting Zillow operations:
- `zillow-ignore-transaction-creation-events` - Disable outbound transaction creation
- `enhanced_fub_deal_fields` - Enable extended deal metadata sync
- `zillow-oauth-pkce` - Enable OAuth PKCE flow support

#### Environment Configuration

Configuration locations: `/fub/apps/richdesk/config/bootstrap/config.php.example`

**Bishop API Configuration:**
- `bishop_api_base_url` => 'https://api.stage.zillow.com/graphql'
- `bishop_api_username` => 'FollowUpBoss' (stored in 1Password)
- `bishop_api_secret` => '[SECRET]' (stored in 1Password)

**OAuth Configuration:**
- `zillow_oauth_client_id` => 'FollowUpBoss'
- `zillow_oauth_client_secret` => '[SECRET]' (AWS Secrets Manager)
- `zillow_oauth_domain` => 'https://authv2.zillow.com'