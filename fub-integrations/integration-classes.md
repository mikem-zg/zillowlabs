# Integration Classes

Integration layer classes collectively owned and maintained by the **Zynaptic Overlords/FUB+ Integrations team**, organized by external system and functionality.

## Zillow Integration Layer

### AgentSyncService.php
**File:** `apps/richdesk/integrations/zillow/AgentSyncService.php`
**Database Tables:** `zillow_agents`, `zillow_sync_users`, `users`, `accounts`
**Purpose:** Orchestrates agent profile synchronization between Zillow and FUB
**Methods:**
- `syncAgent($agentId)` - Sync individual agent profile
- `syncTeamAgents($teamId)` - Sync all agents in a team
- `processAgentUpdate($updateData)` - Process agent profile updates
- `handleAgentDeactivation($agentId)` - Handle agent removal from Zillow
- `resolveAgentConflicts($conflicts)` - Resolve agent data conflicts

**Integration Points:**
- Uses `ZillowApi` for external API calls
- Integrates with `AgentSyncDataSource` for data retrieval
- Coordinates with `BishopApi` for MLS verification

### AgentSync.php
**File:** `apps/richdesk/integrations/zillow/AgentSync.php`
**Database Tables:** `zillow_agents`, `zillow_sync_users`
**Purpose:** Core agent synchronization logic
**Methods:**
- `execute($accountId)` - Execute sync for account
- `validateAgentData($agentData)` - Validate agent profile data
- `updateAgentProfile($agentId, $profileData)` - Update agent profile
- `createAgentMapping($zillowData, $fubData)` - Create agent mappings

### AgentSyncDataSource.php
**File:** `apps/richdesk/integrations/zillow/AgentSyncDataSource.php`
**Purpose:** Data source interface for agent synchronization
**Methods:**
- `getAgentData($agentId)` - Retrieve agent data from Zillow
- `getTeamMembers($teamId)` - Get team member list
- `getUserInfo($userId)` - Get user information from Zillow
- `validateDataSource()` - Validate data source connectivity

## Zillow Identity Management

### ZillowIdentityService.php
**File:** `apps/richdesk/integrations/zillow/identity/ZillowIdentityService.php`
**Database Tables:** `zillow_auth`, `zillow_agents`, `users`
**Purpose:** Manages Zillow user identity resolution and mapping
**Methods:**
- `resolveIdentity($zuid)` - Resolve Zillow user identity
- `createIdentityMapping($zuid, $accountId, $userId)` - Create identity mapping
- `validateIdentity($zuid, $accountId)` - Validate identity mapping
- `getIdentityDetails($zuid)` - Get detailed identity information
- `refreshIdentityData($zuid)` - Refresh cached identity data

### ZillowIdMapperService.php
**File:** `apps/richdesk/integrations/zillow/identity/ZillowIdMapperService.php`
**Database Tables:** `zillow_agents`, `zillow_auth`
**Purpose:** Maps Zillow user IDs to FUB entities
**Methods:**
- `mapZuidToAccount($zuid)` - Map ZUID to FUB account
- `mapZuidToUser($zuid, $userId)` - Map ZUID to FUB user
- `getAccountFromZuid($zuid)` - Get account for ZUID
- `updateMapping($zuid, $accountId, $userId)` - Update existing mapping
- `validateMapping($zuid, $accountId)` - Validate mapping integrity

### HasZillowIdentityService.php
**File:** `apps/richdesk/integrations/zillow/identity/HasZillowIdentityService.php`
**Purpose:** Service trait for Zillow identity functionality
**Methods:**
- `hasZillowIdentity($accountId)` - Check if account has Zillow identity
- `getZillowIdentityService()` - Get identity service instance
- `resolveZillowIdentity($identifier)` - Resolve identity by identifier

## Zillow Graph API Integration

### ZgGraphApi.php
**File:** `apps/richdesk/integrations/zillow/graph/ZgGraphApi.php`
**Purpose:** Zillow GraphQL API client implementation
**Methods:**
- `query($query, $variables, $accountId)` - Execute GraphQL query
- `mutation($mutation, $variables, $accountId)` - Execute GraphQL mutation
- `batchQuery($queries, $accountId)` - Execute batch GraphQL queries
- `validateQuery($query)` - Validate GraphQL query syntax
- `handleGraphQLErrors($errors)` - Handle GraphQL error responses

### FubZgGraphProxy.php
**File:** `apps/richdesk/integrations/zillow/graph/FubZgGraphProxy.php`
**Purpose:** Proxy for FUB-specific GraphQL operations
**Methods:**
- `proxyQuery($query, $context)` - Proxy GraphQL query with FUB context
- `addFubContext($query, $accountId)` - Add FUB-specific context to queries
- `transformResponse($response)` - Transform GraphQL response for FUB
- `handleProxyErrors($errors)` - Handle proxy-specific errors

### PublicGraphApi.php
**File:** `apps/richdesk/integrations/zillow/graph/PublicGraphApi.php`
**Purpose:** Public Zillow GraphQL API client
**Methods:**
- `publicQuery($query, $variables)` - Execute public GraphQL query
- `getPublicSchema()` - Get public GraphQL schema
- `validatePublicAccess($query)` - Validate public access to query

## Zillow Bishop Integration

### BishopApi.php
**File:** `apps/richdesk/integrations/zillow/bishop/BishopApi.php`
**Database Tables:** `zillow_agents`, `zillow_teams`
**Purpose:** Integration with Zillow Bishop service for agent verification
**Methods:**
- `matchAgent($agentInput)` - Match agent against Bishop database
- `matchOffice($officeInput)` - Match office information
- `queryAgents($queryInput)` - Query agents in Bishop
- `processVerifiedLink($linkInput)` - Process verified agent links
- `notifyBishop($notificationInput)` - Send notifications to Bishop
- `disconnectLink($disconnectInput)` - Disconnect agent links

### BishopApiClientFactory.php
**File:** `apps/richdesk/integrations/zillow/bishop/BishopApiClientFactory.php`
**Purpose:** Factory for creating Bishop API clients
**Methods:**
- `createClient($configuration)` - Create Bishop API client
- `createTestClient($mockConfig)` - Create test client with mocks
- `validateConfiguration($config)` - Validate client configuration
- `getDefaultConfiguration()` - Get default client configuration

### MatchAgentResponse.php
**File:** `apps/richdesk/integrations/zillow/bishop/MatchAgentResponse.php`
**Purpose:** Response object for agent matching operations
**Properties:**
- `$agentId` - Matched agent identifier
- `$confidence` - Match confidence score
- `$matchType` - Type of match (exact, fuzzy, etc.)
- `$agentData` - Matched agent profile data

## Zillow Event Platform Integration

### EventFactory.php
**File:** `apps/richdesk/integrations/zillow/event_platform/EventFactory.php`
**Purpose:** Factory for creating Zillow event objects
**Methods:**
- `createEvent($eventType, $eventData)` - Create event instance
- `createMortgageEvent($mortgageData)` - Create mortgage-specific event
- `validateEventData($eventData)` - Validate event data structure
- `serializeEvent($event)` - Serialize event for transmission

### PreApprovalLetterEvent.php
**File:** `apps/richdesk/integrations/zillow/event_platform/events/mortgage/PreApprovalLetterEvent.php`
**Database Tables:** `contacts`, `events`, `zhl_loan_officers`
**Purpose:** Handles pre-approval letter events from ZHL
**Methods:**
- `processPreApprovalEvent($eventData)` - Process pre-approval event
- `updateContactMortgageStatus($contactId, $status)` - Update contact mortgage status
- `notifyAgentOfPreApproval($contactId, $agentId)` - Notify agent of pre-approval
- `logPreApprovalEvent($contactId, $eventData)` - Log pre-approval event

## People Mapping Integration

### PeopleMapper.php
**File:** `apps/richdesk/integrations/PeopleMapper.php`
**Database Tables:** `zillow_agents`, `users`, `contacts`
**Purpose:** Maps people entities between systems
**Methods:**
- `mapPerson($personData, $targetSystem)` - Map person to target system
- `validatePersonMapping($mapping)` - Validate person mapping
- `updatePersonMapping($personId, $mappingData)` - Update existing mapping
- `getPersonMappings($personId)` - Get all mappings for person

### ZillowMapper.php
**File:** `apps/richdesk/integrations/peopleMapper/ZillowMapper.php`
**Database Tables:** `zillow_agents`, `users`
**Purpose:** Zillow-specific person mapping logic
**Methods:**
- `mapZillowAgent($agentData)` - Map Zillow agent to FUB user
- `mapFubUser($userData)` - Map FUB user to Zillow agent
- `validateZillowMapping($mapping)` - Validate Zillow mapping
- `resolveZillowConflicts($conflicts)` - Resolve mapping conflicts

## Integration Support Classes

### TeamMember.php / TeamMembers.php
**Files:** `apps/richdesk/integrations/zillow/TeamMember.php`, `TeamMembers.php`
**Purpose:** Representation of Zillow team member data
**Properties:**
- `$memberId` - Team member identifier
- `$teamId` - Parent team identifier
- `$role` - Team member role
- `$permissions` - Team member permissions
- `$agentData` - Associated agent data

### UserInfo.php / UserInfoTeam.php
**Files:** `apps/richdesk/integrations/zillow/UserInfo.php`, `UserInfoTeam.php`
**Purpose:** Zillow user information containers
**Properties:**
- `$userId` - Zillow user identifier
- `$profile` - User profile information
- `$teamMemberships` - Team membership data
- `$permissions` - User permissions
- `$preferences` - User preferences

## Integration Configuration Classes

### BishopApiClientConfiguration.php
**File:** `apps/richdesk/integrations/zillow/bishop/BishopApiClientConfiguration.php`
**Purpose:** Configuration for Bishop API client
**Properties:**
- `$apiEndpoint` - Bishop API endpoint URL
- `$clientId` - OAuth client ID
- `$clientSecret` - OAuth client secret
- `$timeout` - Request timeout settings
- `$retryConfig` - Retry configuration

### ZillowApiAgentSyncDataSource.php
**File:** `apps/richdesk/integrations/zillow/ZillowApiAgentSyncDataSource.php**
**Purpose:** Zillow API data source for agent synchronization
**Methods:**
- `getAgentData($agentId)` - Fetch agent data from Zillow API
- `getTeamData($teamId)` - Fetch team data from Zillow API
- `validateApiResponse($response)` - Validate API response format
- `handleApiErrors($error)` - Handle Zillow API errors

## Integration Exception Classes

### BishopException.php
**File:** `apps/richdesk/integrations/zillow/bishop/BishopException.php`
**Purpose:** Exception handling for Bishop API operations
**Methods:**
- `getBishopErrorCode()` - Get Bishop-specific error code
- `getBishopErrorMessage()` - Get Bishop error message
- `isRetryable()` - Check if error is retryable

### ZgGraphException.php
**File:** `apps/richdesk/integrations/zillow/graph/ZgGraphException.php`
**Purpose:** Exception handling for Zillow GraphQL operations
**Methods:**
- `getGraphQLErrors()` - Get GraphQL error details
- `getErrorPath()` - Get error path in GraphQL query
- `isAuthenticationError()` - Check if error is auth-related

## Integration Testing Support

### Integration Test Files
**Test files maintained by team:**
- `apps/richdesk/tests/integration/integrations/zillow/AgentSyncServiceTest.php`
- `apps/richdesk/tests/integration/integrations/zillow/bishop/BishopApiTest.php`
- `apps/richdesk/tests/integration/integrations/zillow/graph/ZgGraphApiTest.php`
- `apps/richdesk/tests/integration/integrations/zillow/identity/ZillowIdentityServiceTest.php`

### Mock Patterns
**Common mock patterns used:**
- External API response mocking
- Authentication token mocking
- Event data simulation
- Error condition simulation

## Integration Monitoring

### Bishop Integration Monitoring
**Metrics tracked:**
- `bishop.api.match_agent.success`
- `bishop.api.match_agent.failed`
- `bishop.api.query_agents.duration`
- `bishop.api.connection.health`

### Graph API Monitoring
**Metrics tracked:**
- `zillow.graph.query.success`
- `zillow.graph.query.failed`
- `zillow.graph.query.duration`
- `zillow.graph.auth.failed`

### Event Platform Monitoring
**Monitoring class:** `apps/richdesk/observability/ZillowEventPortalMonitoring.php`
**Metric prefix:** `zep`
**Metrics tracked:**
- Event processing success/failure rates
- Event delivery latency
- Event validation errors

## Integration Architecture Patterns

### Service Composition Pattern
```php
// Pattern for combining multiple integration services
class IntegrationOrchestrator
{
    public function orchestrateAgentSync($accountId)
    {
        // Use multiple services in sequence
        $identityService = new ZillowIdentityService();
        $agentSyncService = new AgentSyncService();
        $bishopApi = new BishopApi();

        // Coordinate between services
        $identity = $identityService->resolveIdentity($zuid);
        $agentData = $agentSyncService->syncAgent($identity->getAgentId());
        $verification = $bishopApi->matchAgent($agentData);

        return $this->consolidateResults($identity, $agentData, $verification);
    }
}
```

### Error Propagation Pattern
```php
// Consistent error handling across integration layers
public function handleIntegrationError(IntegrationException $e)
{
    // Log with integration context
    Logger::error('Integration error', [
        'integration' => $this->getIntegrationName(),
        'service' => get_class($this),
        'error' => $e->getMessage(),
        'account_id' => $this->getAccountId()
    ]);

    // Record metrics
    StatsD::increment("integration.{$this->getIntegrationName()}.error");

    // Re-throw with additional context
    throw new IntegrationServiceException(
        "Integration service error: " . $e->getMessage(),
        0,
        $e
    );
}
```

### Data Transformation Pattern
```php
// Standardized data transformation between systems
public function transformZillowDataToFub(array $zillowData): array
{
    return [
        'name' => $zillowData['displayName'] ?? '',
        'email' => $zillowData['email'] ?? '',
        'phone' => $this->normalizePhoneNumber($zillowData['phone'] ?? ''),
        'external_id' => $zillowData['zuid'],
        'integration_data' => json_encode($zillowData)
    ];
}
```

## People Mapping & Identity Services

Cross-system identity resolution and people mapping services maintained by the integration team.

### PeopleMapper.php
**File:** `apps/richdesk/integrations/PeopleMapper.php`
**Database Tables:** Cross-system identity mapping
**Purpose:** Central service for mapping people identities across integrated systems
**Methods:**
- `mapPerson($sourceSystem, $targetSystem, $personData)` - Map person between systems
- `resolveIdentity($identifier, $system)` - Resolve person identity across systems
- `findExistingMapping($sourceId, $sourceSystem)` - Find existing identity mappings
- `validatePersonMapping($mapping)` - Validate person mapping integrity

### ZillowMapper.php
**File:** `apps/richdesk/integrations/peopleMapper/ZillowMapper.php`
**Database Tables:** `zillow_agents`, `contacts`, `users`
**Purpose:** Specialized mapper for Zillow person identity resolution
**Methods:**
- `mapZillowAgentToUser($zillowAgent, $accountId)` - Map Zillow agent to FUB user
- `mapZillowContactToFubContact($zillowContact)` - Map Zillow contact data
- `resolveZillowIdentity($zuid, $accountId)` - Resolve Zillow identity in FUB
- `updateAgentMapping($agentId, $mappingData)` - Update agent identity mapping
- `findUserByZillowData($zillowData, $accountId)` - Find FUB user by Zillow info

### Mapper.php (Base Class)
**File:** `apps/richdesk/integrations/peopleMapper/Mapper.php`
**Purpose:** Base class for all person identity mappers
**Methods:**
- `map($sourceData, $targetContext)` - Abstract mapping method
- `validateMapping($mappingData)` - Base validation logic
- `normalizePersonData($personData)` - Standardize person data format
- `handleMappingConflict($conflict)` - Resolve mapping conflicts
- `logMappingActivity($activity)` - Log mapping operations

### Identity Resolution Patterns

**Multi-System Identity Resolution:**
```php
// Resolve person identity across multiple systems
$peopleMapper = new PeopleMapper();

// Try to find existing mapping
$existingMapping = $peopleMapper->findExistingMapping($zillowId, 'zillow');

if (!$existingMapping) {
    // Create new mapping using Zillow-specific mapper
    $zillowMapper = new ZillowMapper();
    $fubUser = $zillowMapper->mapZillowAgentToUser($zillowAgent, $accountId);

    // Record the cross-system mapping
    $peopleMapper->mapPerson('zillow', 'fub', [
        'source_id' => $zillowId,
        'target_id' => $fubUser->id,
        'account_id' => $accountId
    ]);
}
```

**Identity Conflict Resolution:**
```php
// Handle cases where multiple identities might match
public function resolveIdentityConflict($candidates, $sourceData)
{
    // Prioritize by confidence score
    $scored = array_map(function($candidate) use ($sourceData) {
        return [
            'candidate' => $candidate,
            'score' => $this->calculateMatchScore($candidate, $sourceData)
        ];
    }, $candidates);

    // Sort by highest confidence
    usort($scored, fn($a, $b) => $b['score'] <=> $a['score']);

    // Return best match if confidence is high enough
    if ($scored[0]['score'] > 0.8) {
        return $scored[0]['candidate'];
    }

    // Otherwise, create new identity
    return null;
}
```

**Cross-System Data Synchronization:**
```php
// Keep person data synchronized across systems
public function synchronizePersonData($personId, $systems = ['zillow', 'fub'])
{
    $canonicalData = $this->getCanonicalPersonData($personId);

    foreach ($systems as $system) {
        $mapper = $this->getMapperForSystem($system);
        $systemData = $mapper->transformToSystemFormat($canonicalData);
        $mapper->updatePersonInSystem($personId, $systemData);
    }
}
```

When working with integration classes:
1. **Use proper error handling** with integration-specific exceptions
2. **Implement monitoring** for all external service calls
3. **Follow data transformation patterns** between systems
4. **Use service composition** for complex integration workflows
5. **Test with external service mocks** to ensure reliability
6. **Document integration dependencies** and API contracts