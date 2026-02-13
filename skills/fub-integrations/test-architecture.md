# Test Architecture

Test files and testing patterns collectively maintained by the **Zynaptic Overlords/FUB+ Integrations team**, organized by test type and integration system.

## Controller Test Files

### API Controller Tests

#### ZillowAgentsControllerTest.php
**File:** `apps/fub_api/tests/cases/controllers/ZillowAgentsControllerTest.php`
**Database Tables:** `zillow_agents`, `users`, `zillow_auth`
**Test Methods:**
- `testIndex()` - Test listing Zillow agents for account
- `testCreate()` - Test creating new agent mapping
- `testUpdate()` - Test updating agent associations
- `testDelete()` - Test removing agent mapping
- `testShow()` - Test retrieving individual agent details
- `testAccountIsolation()` - Test account scoping enforcement

**Test Patterns:**
- Account isolation validation
- Agent-user association testing
- OAuth authentication status testing
- Error handling verification

#### AgentMapControllerTest.php
**File:** `apps/fub_api/tests/cases/controllers/AgentMapControllerTest.php`
**Database Tables:** `zillow_agents`, `users`, `zillow_auth`
**Test Methods:**
- `testAgentMapping()` - Test agent-to-user mapping
- `testMappingStatistics()` - Test mapping coverage statistics
- `testSyncTrigger()` - Test agent synchronization triggering
- `testMappingValidation()` - Test mapping validation logic

**Integration Points:**
- Tests `AgentSyncService` integration
- Validates mapping coverage calculations
- Tests sync triggering mechanisms

#### AppointmentsControllerTest.php
**File:** `apps/fub_api/tests/cases/controllers/AppointmentsControllerTest.php`
**Database Tables:** `appointments`, `appointment_extensions`, `users`
**Test Methods:**
- `testAppointmentCreation()` - Test appointment creation
- `testAppointmentExtensions()` - Test appointment extensions
- `testIntegrationSync()` - Test integration synchronization
- `testZillowAppointmentSync()` - Test Zillow appointment sync

**Integration Testing:**
- Tests appointment sync with external systems
- Validates extension mechanism
- Tests integration-specific appointment handling

## Service Layer Tests

### OAuth Service Tests

#### ZillowTokenServiceV2Test.php
**File:** `apps/richdesk/tests/integration/libraries/service/zillow/oauth/ZillowTokenServiceV2Test.php`
**Database Tables:** `zillow_auth`, `accounts`
**Test Methods:**
- `testGetTokenForAccount()` - Test account-specific token retrieval
- `testRefreshTokenIfNeeded()` - Test automatic token refresh
- `testTokenValidation()` - Test token validity checking
- `testTokenCaching()` - Test token caching behavior
- `testAccountIsolation()` - Test account-scoped token management

**Mock Patterns:**
- External OAuth API mocking
- Token response simulation
- Cache behavior mocking
- Error condition simulation

#### ZillowClientCredentialTokenServiceTest.php
**File:** `apps/richdesk/tests/integration/libraries/service/zillow/oauth/ZillowClientCredentialTokenServiceTest.php**
**Test Methods:**
- `testClientCredentialFlow()` - Test client credentials OAuth flow
- `testTokenCaching()` - Test client token caching
- `testTokenRefresh()` - Test client token refresh
- `testErrorHandling()` - Test OAuth error handling

### Utility Service Tests

#### TransactionsTest.php
**Files:**
- `apps/richdesk/tests/cases/libraries/service/zillow/util/TransactionsTest.php`
- `apps/richdesk/tests/integration/libraries/service/zillow/util/TransactionsTest.php`
**Database Tables:** `zillow_auth`, `zillow_agents`, `accounts`, `users`
**Test Methods:**
- `testZillowEligibilityCheck()` - Test Zillow sync eligibility
- `testAuthenticationValidation()` - Test authentication status
- `testAccountPermissions()` - Test account permission checking
- `testEligibilityStatusDetails()` - Test detailed eligibility status

**Eligibility Testing:**
- OAuth token validity testing
- Account permission validation
- User access rights verification
- Agent association checking

## Model Tests

### Integration Model Tests

#### ZillowAuthTest.php
**File:** `apps/richdesk/tests/cases/models/ZillowAuthTest.php`
**Database Tables:** `zillow_auth`, `accounts`
**Test Methods:**
- `testAuthCreation()` - Test authentication record creation
- `testTokenValidation()` - Test token validation methods
- `testAccountAssociation()` - Test account relationship
- `testTokenExpiration()` - Test token expiration handling

#### ZillowSyncUserTest.php
**File:** `apps/richdesk/tests/cases/models/ZillowSyncUserTest.php`
**Database Tables:** `zillow_sync_users`, `accounts`, `users`
**Test Methods:**
- `testSyncUserCreation()` - Test sync user record creation
- `testSyncStatusTracking()` - Test sync status updates
- `testLastSyncTracking()` - Test last sync timestamp tracking
- `testUserAssociation()` - Test user relationship management

### Core Model Tests (Integration-Related)

#### ContactTest.php
**Files:**
- `apps/richdesk/tests/cases/models/ContactTest.php`
- `apps/richdesk/tests/unit/models/ContactTest.php`
- `apps/richdesk/tests/data_layer/models/ContactTest.php`
**Database Tables:** `contacts`, `zillow_agents`, `events`
**Integration Test Methods:**
- `testZillowAgentAssociation()` - Test Zillow agent assignment
- `testIntegrationEventLogging()` - Test integration event creation
- `testSyncStatusTracking()` - Test sync status management
- `testExternalIdMapping()` - Test external ID handling

#### UserTest.php
**File:** `apps/richdesk/tests/data_layer/models/UserTest.php`
**Database Tables:** `users`, `accounts`, `zillow_agents`
**Integration Test Methods:**
- `testZillowAgentMapping()` - Test agent-to-user mapping
- `testIntegrationPermissions()` - Test integration access permissions
- `testAccountScopedQueries()` - Test account scoping

## Integration Layer Tests

### Zillow Integration Tests

#### AgentSyncServiceTest.php
**File:** `apps/richdesk/tests/integration/integrations/zillow/AgentSyncServiceTest.php`
**Database Tables:** `zillow_agents`, `zillow_sync_users`, `users`
**Test Methods:**
- `testAgentSync()` - Test individual agent synchronization
- `testTeamSync()` - Test team member synchronization
- `testSyncErrorHandling()` - Test sync error handling
- `testConflictResolution()` - Test agent data conflict resolution

**Mock Integration:**
- Zillow API response mocking
- Agent data simulation
- Sync event simulation
- Error condition testing

#### BishopApiTest.php
**File:** `apps/richdesk/tests/integration/integrations/zillow/bishop/BishopApiTest.php**
**Test Methods:**
- `testAgentMatching()` - Test agent matching via Bishop
- `testOfficeMatching()` - Test office matching
- `testAgentQuery()` - Test agent querying
- `testVerificationProcess()` - Test agent verification

#### ZillowIdentityServiceTest.php
**File:** `apps/richdesk/tests/integration/integrations/zillow/identity/ZillowIdentityServiceTest.php**
**Database Tables:** `zillow_auth`, `zillow_agents`, `users`
**Test Methods:**
- `testIdentityResolution()` - Test ZUID identity resolution
- `testIdentityMapping()` - Test identity mapping creation
- `testMappingValidation()` - Test mapping validation
- `testIdentityRefresh()` - Test identity data refresh

## Command and Worker Tests

### Worker Tests

#### ZillowSyncWorkerTest.php
**File:** `apps/richdesk/tests/integration/extensions/command/ZillowSyncWorkerTest.php`
**Database Tables:** `zillow_sync_users`, `contacts`, `contact_sync_events`
**Test Methods:**
- `testWorkerExecution()` - Test worker execution
- `testAccountProcessing()` - Test account-specific processing
- `testErrorHandling()` - Test worker error handling
- `testRetryLogic()` - Test job retry logic

#### ZhlTransferWorkerTest.php
**File:** `apps/richdesk/tests/integration/extensions/command/ZhlTransferWorkerTest.php`
**Database Tables:** `zhl_loan_officers`, `contacts`, `events`
**Test Methods:**
- `testTransferExecution()` - Test loan officer transfer execution
- `testTransferValidation()` - Test transfer eligibility validation
- `testNotificationSending()` - Test transfer notification sending
- `testTransferFailureHandling()` - Test transfer failure handling

#### ZillowHomeLoansTest.php
**File:** `apps/richdesk/tests/unit/extensions/command/ZillowHomeLoansTest.php`
**Test Methods:**
- `testLoanOfficerSync()` - Test loan officer synchronization
- `testTerritoryMapping()` - Test territory mapping updates
- `testDataIntegrityValidation()` - Test data integrity checking

## Test Infrastructure and Utilities

### Test Base Classes

#### DatabaseTestCase.php
**File:** `apps/richdesk/extensions/test/DatabaseTestCase.php`
**Purpose:** Base class for database integration tests
**Methods:**
- `setUp()` - Database setup for tests
- `tearDown()` - Database cleanup after tests
- `createTestAccount()` - Create test account fixture
- `createTestUser()` - Create test user fixture
- `setupZillowAuth()` - Setup Zillow authentication fixture

#### TestCase.php
**File:** `apps/richdesk/extensions/test/TestCase.php`
**Purpose:** Base test case for FUB tests
**Methods:**
- `mockExternalApi()` - Mock external API responses
- `setupAccountIsolation()` - Setup account isolation testing
- `assertAccountScoped()` - Assert account scoping in queries

### Test Fixtures and Data

#### Fixture Files
**Integration-specific fixtures:**
- `apps/richdesk/tests/cases/models/fixtures/ZillowAuth.client.yml`
- `apps/richdesk/tests/cases/models/fixtures/ZillowAuth.common.yml`
- `apps/richdesk/tests/cases/models/fixtures/ZillowSyncUser.common.yml`
- `apps/richdesk/tests/data_layer/models/fixtures/ZillowAgentTest.client.yml`
- `apps/richdesk/tests/data_layer/models/fixtures/ZillowAgentTest.common.yml`

**Fixture Patterns:**
```yaml
# ZillowAuth.client.yml example structure
zillow_auth_1:
  account_id: 1
  oauth_token: "test_token_123"
  oauth_refresh_token: "refresh_token_123"
  token_expires_at: "2025-12-31 23:59:59"
  zuid: "X1-TEST123"

# ZillowAgent.client.yml example structure
zillow_agent_1:
  account_id: 1
  user_id: 1
  encrypted_zuid: "encrypted_test_123"
  name: "Test Agent"
  email: "test@zillow.com"
```

## Test Patterns and Best Practices

### Account Isolation Testing
```php
// Pattern for testing account isolation
public function testAccountIsolation()
{
    $account1 = $this->createTestAccount();
    $account2 = $this->createTestAccount();

    $agent1 = $this->createZillowAgent(['account_id' => $account1->id]);
    $agent2 = $this->createZillowAgent(['account_id' => $account2->id]);

    // Test that account1 user can only see account1 agents
    $this->loginAsAccountUser($account1);
    $agents = ZillowAgent::find('all', ['conditions' => ['account_id' => $account1->id]]);

    $this->assertCount(1, $agents);
    $this->assertEquals($agent1->id, $agents[0]->id);
}
```

### External API Mock Patterns
```php
// Pattern for mocking external API calls
public function setUp()
{
    parent::setUp();

    // Mock Zillow API responses
    $this->mockZillowApi([
        'oauth/token' => ['access_token' => 'test_token'],
        'agents/profile' => ['zuid' => 'X1-TEST', 'name' => 'Test Agent'],
        'teams/members' => ['members' => []]
    ]);
}

private function mockZillowApi(array $endpoints)
{
    foreach ($endpoints as $endpoint => $response) {
        Http::fake([
            "https://api.zillow.com/{$endpoint}" => Http::response($response, 200)
        ]);
    }
}
```

### Integration Event Testing
```php
// Pattern for testing integration events
public function testIntegrationEventCreation()
{
    $account = $this->createTestAccount();
    $contact = $this->createTestContact(['account_id' => $account->id]);

    // Trigger integration event
    $service = new ZillowSyncService();
    $service->syncContact($contact->id);

    // Assert event was logged
    $events = Event::find('all', [
        'conditions' => [
            'contact_id' => $contact->id,
            'event_type' => 'zillow_sync'
        ]
    ]);

    $this->assertCount(1, $events);
}
```

### Error Condition Testing
```php
// Pattern for testing error conditions
public function testApiErrorHandling()
{
    // Mock API failure
    Http::fake([
        'https://api.zillow.com/*' => Http::response(
            ['error' => 'Rate limit exceeded'],
            429
        )
    ]);

    $service = new ZillowTokenService();

    $this->expectException(RateLimitException::class);
    $service->getAccessToken($this->testAccount->id);
}
```

## Test Data Management

### Database State Management
- Use fixtures for consistent test data
- Implement proper test isolation
- Clean up test data after each test
- Use transactions for test isolation when possible

### Mock Data Consistency
- Maintain realistic test data
- Use consistent identifiers across tests
- Mock external APIs with realistic responses
- Test both success and failure scenarios

### Performance Testing
- Test with realistic data volumes
- Monitor test execution times
- Use appropriate test database configurations
- Implement proper test parallelization

## Continuous Integration Testing

### Test Categories
**Unit Tests:** Fast, isolated tests with mocked dependencies
**Integration Tests:** Tests with real database and external service mocks
**End-to-End Tests:** Full workflow tests with all components

### Test Execution Patterns
- Run unit tests first for fast feedback
- Execute integration tests for component validation
- Run end-to-end tests for full workflow validation
- Use parallel execution for performance

### Coverage Requirements
- Aim for 80% code coverage on new integration features
- Ensure all critical integration paths are tested
- Test error handling and edge cases
- Validate account isolation in all integration features

When working with integration tests:
1. **Use proper fixtures** for consistent test data
2. **Mock external APIs** to ensure test reliability
3. **Test account isolation** in all integration features
4. **Follow established test patterns** for consistency
5. **Test both success and failure scenarios**
6. **Maintain realistic test data** for integration scenarios