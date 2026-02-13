# Service Layer Architecture

Service classes and libraries collectively owned and maintained by the **Zynaptic Overlords/FUB+ Integrations team**, organized by integration system and functionality.

## Zillow OAuth Services

### ZillowTokenService.php
**File:** `apps/richdesk/libraries/service/zillow/oauth/ZillowTokenService.php`
**Database Tables:** `zillow_sync_user`, `zillow_auth`
**Methods:**
- `getAccessToken($zillowSyncUser)` - Get valid OAuth access token
- `refreshToken($refreshToken)` - Refresh expired OAuth token
- `validateToken($accessToken)` - Validate token with Zillow API
- `revokeToken($accessToken)` - Revoke OAuth access

**Integration Points:**
- Uses `OauthCache` for token caching
- Integrates with `ZillowProvider` for OAuth flow
- Handles token rotation and expiration

### ZillowTokenServiceV2.php
**File:** `apps/richdesk/libraries/service/zillow/oauth/ZillowTokenServiceV2.php`
**Database Tables:** `zillow_auth`, `accounts`
**Methods:**
- `getTokenForAccount($accountId)` - Get account-specific token
- `refreshTokenIfNeeded($accountId)` - Auto-refresh tokens
- `isTokenValid($accountId)` - Check token validity
- `clearTokenCache($accountId)` - Clear cached tokens

**Enhanced Features:**
- Account-scoped token management
- Automatic token refresh
- Improved error handling
- Better cache management

### ZillowProvider.php
**File:** `apps/richdesk/libraries/service/zillow/oauth/ZillowProvider.php`
**Purpose:** OAuth2 provider implementation for Zillow
**Methods:**
- `getAuthorizationUrl($options)` - Generate OAuth authorization URL
- `getAccessToken($grant, $options)` - Exchange code for access token
- `getResourceOwner($token)` - Get user info from token
- `getResourceOwnerDetailsUrl($token)` - User info endpoint URL

### ZillowApi.php
**File:** `apps/richdesk/libraries/service/zillow/oauth/ZillowApi.php`
**Database Tables:** Reads from `zillow_auth` for authentication
**Methods:**
- `makeRequest($endpoint, $params, $accountId)` - Make authenticated API requests
- `validateResponse($response)` - Validate API response format
- `handleRateLimit($response)` - Handle rate limit responses
- `logApiCall($endpoint, $status, $accountId)` - Log API usage

## Zillow Utility Services

### Transactions.php
**File:** `apps/richdesk/libraries/service/zillow/util/Transactions.php`
**Database Tables:** `zillow_auth`, `zillow_agents`, `accounts`, `users`
**Methods:**
- `isEligibleForZillowSync($accountId)` - Check Zillow sync eligibility
- `getZillowAuthForAccount($accountId)` - Get authentication status
- `validateZillowConnection($accountId)` - Validate Zillow connection
- `getEligibilityStatus($accountId)` - Get detailed eligibility status

**Key Eligibility Checks:**
- OAuth token validity
- Account permissions
- User access rights
- Zillow agent association

### ZillowLeadEventsSync.php
**File:** `apps/richdesk/libraries/service/zillow/util/ZillowLeadEventsSync.php`
**Database Tables:** `contacts`, `events`, `contact_sync_events`
**Methods:**
- `processLeadEvents($payload)` - Process incoming lead events
- `syncLeadData($leadData, $accountId)` - Sync lead information
- `createContactFromLead($leadData, $accountId)` - Create contact records
- `updateExistingContact($contact, $leadData)` - Update contact data
- `logSyncEvent($contactId, $eventType, $status)` - Log sync operations

### ZillowMortgage.php
**File:** `apps/richdesk/libraries/service/zillow/util/ZillowMortgage.php**
**Database Tables:** `zhl_loan_officers`, `contacts`, `events`
**Methods:**
- `processPreApprovalData($data)` - Process pre-approval information
- `assignLoanOfficer($contactId, $nmlsId)` - Assign loan officer
- `updateMortgageStatus($contactId, $status)` - Update mortgage status
- `trackMortgageEvent($contactId, $eventType)` - Track mortgage events

### ZillowTechConnect.php
**File:** `apps/richdesk/libraries/service/zillow/util/ZillowTechConnect.php`
**Database Tables:** `contacts`, `zillow_agents`, `events`
**Methods:**
- `processConnectionRequest($data)` - Process TechConnect requests
- `validateAgentConnection($agentId, $accountId)` - Validate agent connections
- `sendConnectionNotification($contactId, $agentId)` - Send notifications
- `logConnectionEvent($contactId, $agentId, $status)` - Log connection events

## General OAuth and Security Services

### OauthCache.php
**File:** `apps/richdesk/libraries/service/OauthCache.php`
**Purpose:** OAuth token caching layer
**Methods:**
- `get($key)` - Get cached token
- `set($key, $token, $ttl)` - Cache token with expiration
- `delete($key)` - Remove cached token
- `flush($pattern)` - Clear tokens by pattern

**Cache Keys Used:**
- `oauth:zillow:token:{account_id}`
- `oauth:zillow:refresh:{account_id}`
- `oauth:zhl:token:{account_id}`

### ZillowJwksRetrieverService.php
**File:** `apps/richdesk/services/ZillowJwksRetrieverService.php`
**Purpose:** Retrieve and cache Zillow JSON Web Key Sets
**Methods:**
- `getJwks($issuer)` - Get JWKS for issuer
- `refreshJwks($issuer)` - Force JWKS refresh
- `validateJwks($jwks)` - Validate JWKS format
- `cacheJwks($issuer, $jwks, $ttl)` - Cache JWKS data

### ZillowJwtValidatorService.php
**File:** `apps/richdesk/services/ZillowJwtValidatorService.php`
**Purpose:** Validate Zillow JWT tokens
**Methods:**
- `validateToken($jwt, $issuer)` - Validate JWT signature
- `extractClaims($jwt)` - Extract JWT claims
- `verifySignature($jwt, $jwks)` - Verify JWT signature
- `checkExpiration($claims)` - Check token expiration

## Integration Service Classes

### AgentSyncService.php
**File:** `apps/richdesk/integrations/zillow/AgentSyncService.php`
**Database Tables:** `zillow_agents`, `zillow_sync_users`, `users`
**Methods:**
- `syncAgent($agentId)` - Sync individual agent
- `syncTeamAgents($teamId)` - Sync team members
- `processAgentUpdates($updates)` - Process agent updates
- `handleAgentDeactivation($agentId)` - Handle agent removal

**StatsD Metrics Used:**
- `fubweb.zillowSync.agentSync.initiated`
- `fubweb.zillowSync.agentSync.completed`
- `fubweb.zillowSync.agentSync.singleAgentSynced`

### ZillowIdentityService.php
**File:** `apps/richdesk/integrations/zillow/identity/ZillowIdentityService.php`
**Database Tables:** `zillow_auth`, `zillow_agents`, `users`
**Methods:**
- `resolveIdentity($zuid)` - Resolve Zillow user identity
- `mapToFubUser($zuid, $userId)` - Map Zillow user to FUB user
- `getIdentityDetails($zuid)` - Get identity information
- `validateIdentityMapping($zuid, $accountId)` - Validate mapping

### ZillowIdMapperService.php
**File:** `apps/richdesk/integrations/zillow/identity/ZillowIdMapperService.php`
**Database Tables:** `zillow_agents`, `zillow_auth`
**Methods:**
- `mapZuidToAccount($zuid)` - Map ZUID to account
- `getAccountFromZuid($zuid)` - Get account for ZUID
- `validateMapping($zuid, $accountId)` - Validate ZUID mapping
- `updateMapping($zuid, $accountId, $userId)` - Update mapping

## Service Integration Points

### Communication Classes
**ZillowSync Communication:** `apps/richdesk/communications/ZillowSync.php`
- Handles webhook processing
- Integrates with sync services
- Manages sync event routing

### Event Processing
**TransactionSyncEvent:** `apps/richdesk/communications/integrations/helpers/TransactionSyncEvent.php`
- Helper for transaction event processing
- Integration with sync services
- Event data normalization

### Stage Mapping
**StageMappingInput:** `apps/richdesk/dtos/integrations/StageMappingInput.php`
- DTO for stage mapping operations
- Integration with pipeline management
- Stage synchronization support

## Service Architecture Patterns

### Account Scoping in Services
```php
// Pattern used across integration services
public function processForAccount(int $accountId, array $data)
{
    // Validate account access
    $account = Account::find($accountId);
    if (!$account) {
        throw new InvalidAccountException();
    }

    // Use account-scoped queries
    $resources = ResourceModel::find('all', [
        'conditions' => ['account_id' => $accountId]
    ]);
}
```

### Error Handling Pattern
```php
// Consistent error handling across services
try {
    $result = $this->externalApiCall($data);
} catch (ExternalApiException $e) {
    // Log with integration context
    Logger::error('Integration API error', [
        'integration' => 'zillow',
        'account_id' => $accountId,
        'error' => $e->getMessage()
    ]);

    // Record metrics
    StatsD::increment('integration.zillow.api.error');

    throw new IntegrationServiceException('API call failed', 0, $e);
}
```

### Caching Strategy
```php
// Token caching pattern
public function getValidToken(int $accountId): ?string
{
    $cacheKey = "oauth:zillow:token:{$accountId}";
    $token = $this->cache->get($cacheKey);

    if (!$token || $this->isTokenExpiring($token)) {
        $token = $this->refreshToken($accountId);
        $this->cache->set($cacheKey, $token, $this->getTokenTtl($token));
    }

    return $token;
}
```

## Service Configuration and Dependencies

### OAuth Configuration
**Services require configuration for:**
- Client ID and Secret
- Redirect URIs
- Scope definitions
- Token endpoints
- JWKS endpoints

### Database Dependencies
**Common dependencies across services:**
- Account validation
- User authentication
- Integration status tracking
- Event logging
- Sync state management

### External API Dependencies
**Services integrate with:**
- Zillow OAuth API
- Zillow GraphQL API
- Zillow TechConnect API
- ZHL (Zillow Home Loans) API
- Zillow Event Portal

## Testing Service Integration

### Service Test Files
**Key test files maintained by team:**
- `apps/richdesk/tests/integration/libraries/service/zillow/oauth/ZillowTokenServiceV2Test.php`
- `apps/richdesk/tests/integration/libraries/service/zillow/util/TransactionsTest.php`
- `apps/richdesk/tests/cases/libraries/service/zillow/util/TransactionsTest.php`

### Mock Patterns for Services
**Common mocking patterns:**
- External API response mocking
- Database state setup
- Cache behavior simulation
- Token validation mocking

### Test Data Management
**Service tests use:**
- Account fixtures
- OAuth token fixtures
- Agent profile fixtures
- Event data fixtures

## Performance Considerations

### Token Management Performance
- Cache frequently used tokens
- Batch token refresh operations
- Use connection pooling for external APIs
- Monitor token refresh rates

### Database Query Optimization
- Use account-scoped indexes
- Batch database operations
- Implement proper eager loading
- Monitor query performance

### External API Rate Limiting
- Implement backoff strategies
- Use request queuing
- Monitor rate limit headers
- Cache API responses where appropriate

When working with integration services:
1. **Use account scoping** in all service methods
2. **Implement proper error handling** with metrics
3. **Cache tokens and API responses** appropriately
4. **Follow established patterns** for external API integration
5. **Test with proper mocks** for external dependencies
6. **Monitor service performance** with StatsD metrics