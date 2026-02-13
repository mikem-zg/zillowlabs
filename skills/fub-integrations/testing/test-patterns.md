## Testing with Account Isolation (PHPUnit)

### Backend Testing Patterns

**Test Pattern Ensuring Account Separation:**
```php
// Test pattern ensuring account separation
public function testContactQuery()
{
    $account1 = $this->createTestAccount();
    $account2 = $this->createTestAccount();

    $contact1 = Contact::create(['account_id' => $account1->id]);
    $contact2 = Contact::create(['account_id' => $account2->id]);

    $results = Contact::find('all', [
        'conditions' => ['account_id' => $account1->id]
    ]);

    $this->assertCount(1, $results);
    $this->assertEquals($contact1->id, $results[0]->id);
}
```

**Integration Testing with External APIs:**
```php
// Mock external Zillow API calls
public function testZillowAgentSync()
{
    // Mock Zillow API response
    $mockZillowData = [
        'id' => 12345,
        'name' => 'Test Agent',
        'email' => 'test@zillow.com'
    ];

    // Mock API client
    $this->mockZillowApi($mockZillowData);

    // Test integration
    $account = $this->createTestAccount();
    $result = ZillowSyncService::syncAgent($account->id, $mockZillowData);

    $this->assertTrue($result->success);
    $this->assertEquals($mockZillowData['id'], $result->zillow_id);
}
```

**Database Transaction Testing:**
```php
// Test rollback behavior on errors
public function testTransactionRollback()
{
    $account = $this->createTestAccount();
    $initialContactCount = Contact::count(['account_id' => $account->id]);

    try {
        ActiveRecord\Connection::transaction(function() use ($account) {
            Contact::create(['account_id' => $account->id, 'name' => 'Test']);
            // Simulate error
            throw new Exception('Test error');
        });
    } catch (Exception $e) {
        // Expected
    }

    $finalContactCount = Contact::count(['account_id' => $account->id]);
    $this->assertEquals($initialContactCount, $finalContactCount);
}
```

## Frontend Testing Patterns

### Component Testing
```javascript
// Example from __tests__/link-zillow-profile-modal.test.js
describe('LinkZillowProfileModal', () => {
    it('should handle zillow agent connection', () => {
        const mockZillowAgent = {
            id: 123,
            name: 'John Agent',
            email: 'john@zillow.com'
        };

        render(<LinkZillowProfileModal agent={mockZillowAgent} />);

        // Test modal opens
        expect(screen.getByText('Connect to Zillow')).toBeInTheDocument();

        // Test connection flow
        fireEvent.click(screen.getByText('Connect'));
        expect(mockConnectFunction).toHaveBeenCalledWith(mockZillowAgent.id);
    });
});
```

### Hook Testing
```javascript
// Example from __tests__/use-zillow-auth.test.js
describe('useZillowAuth', () => {
    it('should return authentication status from backend', async () => {
        // Mock backend API response
        const mockAuthResponse = {
            isAuthenticated: true,
            authStatus: 'connected',
            connectUrl: 'https://zillow.com/oauth/connect'
        };

        // Mock fetch
        global.fetch = jest.fn(() =>
            Promise.resolve({
                json: () => Promise.resolve(mockAuthResponse)
            })
        );

        // Test hook
        const { result, waitForNextUpdate } = renderHook(() => useZillowAuth());

        await waitForNextUpdate();

        expect(result.current.isAuthenticated).toBe(true);
        expect(result.current.authStatus).toBe('connected');
    });
});
```

### Integration Testing
```javascript
// Full integration test with backend simulation
describe('ZillowIntegrationFlow', () => {
    it('should complete full zillow connection workflow', async () => {
        // Setup test environment
        const mockAccount = createMockAccount();
        const mockZillowAgent = createMockZillowAgent();

        // Mock backend API calls
        mockApiCalls({
            '/api/zillow/auth/connect': { success: true, authUrl: 'test-url' },
            '/api/zillow/agents': { agents: [mockZillowAgent] }
        });

        // Render component
        render(<ConnectZillow account={mockAccount} />);

        // Simulate user interaction
        fireEvent.click(screen.getByText('Connect to Zillow'));

        // Verify integration state changes
        await waitFor(() => {
            expect(screen.getByText('Connected')).toBeInTheDocument();
        });

        // Verify backend calls were made
        expect(global.fetch).toHaveBeenCalledWith('/api/zillow/auth/connect');
    });
});
```

## Test Data Management

### Test Account Creation
```php
// Helper method for creating test accounts
protected function createTestAccount($overrides = [])
{
    $defaultData = [
        'name' => 'Test Account ' . uniqid(),
        'email' => 'test' . uniqid() . '@example.com',
        'status' => 'active'
    ];

    $accountData = array_merge($defaultData, $overrides);
    return Account::create($accountData);
}
```

### Test Data Cleanup
```php
// Ensure test data cleanup
protected function tearDown(): void
{
    // Clean up test accounts and related data
    $testAccounts = Account::find('all', [
        'conditions' => ['name LIKE ?', 'Test Account%']
    ]);

    foreach ($testAccounts as $account) {
        // Clean up related data
        Contact::delete('all', ['account_id' => $account->id]);
        ZillowAgent::delete('all', ['account_id' => $account->id]);
        $account->delete();
    }

    parent::tearDown();
}
```

### Mock API Responses
```php
// Mock external API responses for testing
protected function mockZillowApi($responseData)
{
    $mockClient = $this->createMock(ZillowApiClient::class);
    $mockClient->method('makeRequest')
               ->willReturn($responseData);

    // Inject mock into service
    ZillowSyncService::setApiClient($mockClient);
}
```

## Performance Testing

### Load Testing Patterns
```php
// Test performance with large datasets
public function testLargeDatasetPerformance()
{
    $account = $this->createTestAccount();

    // Create large dataset
    $contacts = [];
    for ($i = 0; $i < 1000; $i++) {
        $contacts[] = [
            'name' => "Contact $i",
            'email' => "contact$i@example.com",
            'account_id' => $account->id
        ];
    }

    // Measure batch insert performance
    $startTime = microtime(true);
    Contact::create($contacts);
    $duration = microtime(true) - $startTime;

    // Assert reasonable performance
    $this->assertLessThan(5.0, $duration); // Less than 5 seconds
}
```

### Memory Usage Testing
```php
// Test memory usage for large operations
public function testMemoryUsage()
{
    $account = $this->createTestAccount();
    $initialMemory = memory_get_usage();

    // Perform memory-intensive operation
    $contacts = Contact::find('all', [
        'conditions' => ['account_id' => $account->id],
        'limit' => 10000
    ]);

    $peakMemory = memory_get_peak_usage();
    $memoryIncrease = $peakMemory - $initialMemory;

    // Assert reasonable memory usage (less than 50MB increase)
    $this->assertLessThan(50 * 1024 * 1024, $memoryIncrease);
}
```

## Test Environment Setup

### Database Configuration
```php
// Test database configuration
class DatabaseTestCase extends PHPUnit\Framework\TestCase
{
    protected function setUp(): void
    {
        // Use separate test database
        ActiveRecord\Config::initialize(function($cfg) {
            $cfg->set_model_directory('app/models');
            $cfg->set_connections([
                'development' => 'mysql://test:test@localhost/fub_test'
            ]);
        });

        // Clear database state
        $this->clearTestData();
    }

    protected function clearTestData()
    {
        // Remove test data from previous runs
        ActiveRecord\Connection::$default_connection->query(
            "DELETE FROM contacts WHERE email LIKE '%@example.com'"
        );
    }
}
```

### Frontend Test Environment
```javascript
// Jest setup for frontend tests
import { setupServer } from 'msw/node';
import { rest } from 'msw';

// Mock service worker for API calls
const server = setupServer(
    rest.get('/api/zillow/auth', (req, res, ctx) => {
        return res(ctx.json({ isAuthenticated: false }));
    }),

    rest.post('/api/zillow/auth/connect', (req, res, ctx) => {
        return res(ctx.json({ success: true }));
    })
);

// Setup and cleanup
beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());
```