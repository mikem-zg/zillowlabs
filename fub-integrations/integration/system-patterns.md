## Integration System Patterns

### Zillow Integration Architecture
- **ZillowAgent**: Core agent profile and mapping
- **ZillowAuth**: OAuth tokens and authentication state
- **ZillowSyncUser**: User synchronization tracking
- **Transactions**: Eligibility and sync orchestration

#### Key Zillow Models
```php
// ZillowAgent - Core agent profile
class ZillowAgent extends Model {
    public static $table_name = 'zillow_agents';

    public static $belongs_to = [
        ['contact', 'class' => 'Contact'],
        ['account', 'class' => 'Account'],
        ['zillow_auth', 'class' => 'ZillowAuth']
    ];

    public static $has_many = [
        ['zillow_teams', 'class' => 'ZillowTeam'],
        ['zillow_sync_users', 'class' => 'ZillowSyncUser']
    ];
}

// ZillowAuth - OAuth and authentication state
class ZillowAuth extends Model {
    public static $table_name = 'zillow_auth';

    public static $belongs_to = [
        ['account', 'class' => 'Account']
    ];

    public static $has_many = [
        ['zillow_agents', 'class' => 'ZillowAgent']
    ];
}
```

#### Zillow Integration Flow
1. **Authentication**: OAuth flow via ZillowAuth
2. **Profile Mapping**: Link Zillow profiles to FUB contacts via ZillowAgent
3. **Data Synchronization**: Bidirectional sync of leads, contacts, and activity
4. **Transaction Processing**: Handle eligibility, payouts, and compliance

### ZHL Integration Architecture
- **ZhlLoanOfficer**: Loan officer profiles and capabilities
- **ZhlDedicatedLoanOfficerMap**: Territory and assignment mapping
- **ZhlStatusChangelog**: Status change audit trail

#### Key ZHL Models
```php
// ZhlLoanOfficer - Loan officer profile
class ZhlLoanOfficer extends Model {
    public static $table_name = 'zhl_loan_officers';

    public static $has_many = [
        ['dedicated_maps', 'class' => 'ZhlDedicatedLoanOfficerMap'],
        ['status_changes', 'class' => 'ZhlStatusChangelog']
    ];
}

// ZhlDedicatedLoanOfficerMap - Territory assignments
class ZhlDedicatedLoanOfficerMap extends Model {
    public static $table_name = 'zhl_dedicated_loan_officer_maps';

    public static $belongs_to = [
        ['loan_officer', 'class' => 'ZhlLoanOfficer'],
        ['account', 'class' => 'Account']
    ];
}
```

#### ZHL Integration Flow
1. **Loan Officer Management**: Maintain LO profiles and availability
2. **Territory Mapping**: Assign dedicated LOs to specific accounts/territories
3. **Transfer Workflow**: Handle lead transfers to appropriate loan officers
4. **Status Tracking**: Audit trail of all status changes and assignments

## Security Considerations

### Data Isolation
- **Client database separation** prevents cross-account data access
- **Account ID filtering** required for all client queries
- **User permissions** enforce role-based access control

### Authentication Integration
- **Zillow OAuth** handles external authentication securely
- **API keys** provide programmatic access control
- **Security tokens** manage session and temporary access

#### Security Validation Patterns
```php
// Always validate account access
if (!$this->hasAccountAccess($accountId)) {
    throw new UnauthorizedAccessException();
}

// Validate Zillow OAuth token
if (!ZillowAuth::isValidToken($accountId, $oauthToken)) {
    throw new ZillowAuthException('Invalid or expired token');
}

// Sanitize external integration data
$sanitizedData = SecurityHelper::sanitizeIntegrationData($externalData);
```

## Performance Optimization

### Caching Strategies
```php
// Cache frequently accessed integration data
$cacheKey = "zillow_agent_{$accountId}_{$agentId}";
$cachedAgent = Cache::get($cacheKey);

if (!$cachedAgent) {
    $cachedAgent = ZillowAgent::find('first', [
        'conditions' => [
            'account_id' => $accountId,
            'zillow_id' => $agentId
        ],
        'include' => ['contact', 'zillow_auth']
    ]);

    Cache::set($cacheKey, $cachedAgent, 3600); // 1 hour cache
}
```

### Batch Processing
```php
// Process integration data in batches
$batchSize = 100;
$offset = 0;

do {
    $contacts = Contact::find('all', [
        'conditions' => ['account_id' => $accountId, 'needs_zillow_sync' => 1],
        'limit' => $batchSize,
        'offset' => $offset
    ]);

    foreach ($contacts as $contact) {
        ZillowSyncService::syncContact($contact);
    }

    $offset += $batchSize;
} while (count($contacts) === $batchSize);
```

## Error Handling and Monitoring

### Integration Error Patterns
```php
// Zillow API error handling
try {
    $zillowResponse = ZillowApiClient::createLead($leadData);
} catch (ZillowApiException $e) {
    if ($e->getCode() === 'RATE_LIMIT_EXCEEDED') {
        // Queue for retry with backoff
        ZillowSyncQueue::retryLater($leadData, 300); // 5 minutes
    } elseif ($e->getCode() === 'INVALID_AGENT') {
        // Mark agent as inactive
        ZillowAgent::markInactive($leadData['agent_id']);
    } else {
        // Log error for investigation
        Logger::error('Zillow sync failed', ['error' => $e->getMessage()]);
    }
}

// ZHL service error handling
try {
    $zhlResponse = ZhlApiClient::transferLead($transferData);
} catch (ZhlServiceException $e) {
    // Create fallback assignment
    $fallbackOfficer = ZhlLoanOfficer::findFallback($transferData['territory']);
    ZhlTransferService::assignToFallback($transferData, $fallbackOfficer);
}
```

### Monitoring and Alerting
```php
// Track integration metrics
IntegrationMetrics::record('zillow.lead_sync', [
    'account_id' => $accountId,
    'success' => $success,
    'duration_ms' => $duration,
    'error_code' => $errorCode ?? null
]);

// Alert on integration failures
if ($errorRate > 0.05) { // >5% error rate
    AlertService::send('Integration Error Rate High', [
        'integration' => 'zillow',
        'account_id' => $accountId,
        'error_rate' => $errorRate
    ]);
}
```

## Development Workflows

### Integration Development Checklist
1. **Database Schema**: Ensure proper indexing and account scoping
2. **Model Relationships**: Define proper ActiveRecord relationships
3. **Security Validation**: Implement account access controls
4. **Error Handling**: Add comprehensive error handling and logging
5. **Performance**: Implement caching and batch processing where appropriate
6. **Testing**: Create integration tests with account isolation
7. **Monitoring**: Add metrics and alerting for production monitoring

### Code Review Guidelines
- **Account Scoping**: Verify all client database queries include account_id
- **Security**: Check for proper authorization and data sanitization
- **Performance**: Review for potential N+1 queries and caching opportunities
- **Error Handling**: Ensure graceful degradation and proper logging
- **Testing**: Verify comprehensive test coverage including edge cases