# FUB ActiveRecord Query Examples

Real-world ActiveRecord query patterns and examples from the FUB codebase.

## Basic Query Patterns

### Finding Records

```php
// Single record by ID (account-scoped)
$contact = Contact::find('first', [
    'conditions' => ['id' => $contactId, 'account_id' => $accountId]
]);

// Modern alternative
$contact = Contact::first([
    'conditions' => ['id' => $contactId, 'account_id' => $accountId]
]);

// Multiple records with conditions
$activeContacts = Contact::find('all', [
    'conditions' => ['account_id' => $accountId, 'status' => 'active'],
    'order' => 'created_at DESC',
    'limit' => 50
]);

// Dynamic finder methods
$contact = Contact::find_by_email_and_account_id($email, $accountId);
$users = User::find_all_by_account_id($accountId);
```

### Complex Conditions

```php
// Placeholder syntax for complex queries
$highValueDeals = Deal::find('all', [
    'conditions' => [
        'account_id = ? AND amount > ? AND status IN (?)',
        $accountId,
        50000,
        ['pending', 'accepted', 'closed']
    ],
    'order' => 'amount DESC'
]);

// Date range queries
$recentContacts = Contact::find('all', [
    'conditions' => [
        'account_id = ? AND created_at BETWEEN ? AND ?',
        $accountId,
        $startDate,
        $endDate
    ]
]);

// NULL checks
$contactsWithoutAgent = Contact::find('all', [
    'conditions' => [
        'account_id = ? AND zillow_agent_id IS NULL',
        $accountId
    ]
]);
```

### IN Clause Patterns

```php
// Array of IDs
$contacts = Contact::find('all', [
    'conditions' => [
        'id IN (?) AND account_id = ?',
        $contactIds,
        $accountId
    ]
]);

// Subquery pattern
$contactsWithDeals = Contact::find('all', [
    'conditions' => [
        'account_id = ? AND id IN (SELECT DISTINCT contact_id FROM deals WHERE account_id = ?)',
        $accountId,
        $accountId
    ]
]);
```

## Zillow Integration Queries

### Zillow Authentication Checks

```php
// Check if account has valid Zillow OAuth
$zillowAuth = ZillowAuth::find('first', [
    'conditions' => [
        'account_id = ? AND zuid IS NOT NULL AND oauth_token IS NOT NULL',
        $accountId
    ]
]);

// Get all authenticated Zillow agents for account
$authenticatedAgents = ZillowAgent::find('all', [
    'conditions' => [
        'account_id = ? AND id IN (SELECT zillow_agent_id FROM zillow_auth WHERE oauth_token IS NOT NULL)',
        $accountId
    ]
]);
```

### Zillow Agent Mapping

```php
// Find Zillow agent by email
$zillowAgent = ZillowAgent::find('first', [
    'conditions' => [
        'account_id = ? AND email = ?',
        $accountId,
        $agentEmail
    ]
]);

// Get agents with sync status
$syncedAgents = ZillowAgent::find('all', [
    'conditions' => [
        'account_id = ? AND id IN (SELECT DISTINCT zillow_agent_id FROM zillow_sync_users WHERE last_sync_at > ?)',
        $accountId,
        $cutoffDate
    ]
]);
```

## ZHL Integration Queries

### Loan Officer Lookups

```php
// Find loan officer by NMLS ID
$loanOfficer = ZhlLoanOfficer::find('first', [
    'conditions' => [
        'account_id = ? AND nmls_id = ?',
        $accountId,
        $nmlsId
    ]
]);

// Get active loan officers for account
$activeLoanOfficers = ZhlLoanOfficer::find('all', [
    'conditions' => [
        'account_id = ? AND is_active = ?',
        $accountId,
        true
    ],
    'order' => 'last_name ASC, first_name ASC'
]);
```

## Contact and Lead Queries

### Contact Segmentation

```php
// Get contacts by stage
$stageContacts = Contact::find('all', [
    'conditions' => [
        'account_id = ? AND stage_id = ?',
        $accountId,
        $stageId
    ]
]);

// Get contacts with recent activity
$activeContacts = Contact::find('all', [
    'conditions' => [
        'account_id = ? AND id IN (SELECT DISTINCT contact_id FROM events WHERE account_id = ? AND created_at > ?)',
        $accountId,
        $accountId,
        $activityCutoff
    ]
]);

// Smart list query pattern
$smartListContacts = Contact::find('all', [
    'conditions' => [
        'account_id = ? AND email IS NOT NULL AND status = ? AND created_at > ?',
        $accountId,
        'active',
        $dateRange
    ],
    'order' => 'last_activity_at DESC'
]);
```

### Lead Source Analysis

```php
// Group contacts by lead source
$leadSourceStats = Contact::query([
    'select' => 'lead_source, COUNT(*) as contact_count',
    'conditions' => ['account_id = ?', $accountId],
    'group' => 'lead_source',
    'order' => 'contact_count DESC'
]);

// Contacts from specific integration
$zillowLeads = Contact::find('all', [
    'conditions' => [
        'account_id = ? AND lead_source LIKE ?',
        $accountId,
        'Zillow%'
    ]
]);
```

## Deal and Transaction Queries

### Deal Pipeline Analysis

```php
// Get deals by pipeline stage
$pipelineDeals = Deal::find('all', [
    'conditions' => [
        'account_id = ? AND stage_id = ?',
        $accountId,
        $stageId
    ],
    'include' => ['contact', 'properties']  // Eager loading
]);

// Deal value analysis
$dealMetrics = Deal::query([
    'select' => 'stage_id, COUNT(*) as deal_count, AVG(amount) as avg_amount, SUM(amount) as total_amount',
    'conditions' => [
        'account_id = ? AND status = ?',
        $accountId,
        'active'
    ],
    'group' => 'stage_id'
]);
```

### Property Relationships

```php
// Get deals with properties
$dealsWithProperties = Deal::find('all', [
    'conditions' => [
        'account_id = ? AND id IN (SELECT DISTINCT deal_id FROM deals_properties WHERE account_id = ?)',
        $accountId,
        $accountId
    ]
]);

// Property search
$propertiesNearAddress = Property::find('all', [
    'conditions' => [
        'account_id = ? AND MATCH(address) AGAINST(? IN BOOLEAN MODE)',
        $accountId,
        $searchAddress
    ]
]);
```

## User and Team Queries

### User Management

```php
// Get active users for account
$activeUsers = User::find('all', [
    'conditions' => [
        'account_id = ? AND status = ? AND is_active = ?',
        $accountId,
        'active',
        true
    ],
    'order' => 'last_name ASC, first_name ASC'
]);

// Users with specific permissions
$adminUsers = User::find('all', [
    'conditions' => [
        'account_id = ? AND role IN (?)',
        $accountId,
        ['admin', 'owner']
    ]
]);
```

### Team Relationships

```php
// Get team members
$teamMembers = User::find('all', [
    'conditions' => [
        'account_id = ? AND id IN (SELECT user_id FROM teams_users WHERE team_id = ?)',
        $accountId,
        $teamId
    ]
]);
```

## Event and Activity Queries

### Activity Tracking

```php
// Get recent events for contact
$recentEvents = Event::find('all', [
    'conditions' => [
        'account_id = ? AND contact_id = ?',
        $accountId,
        $contactId
    ],
    'order' => 'created_at DESC',
    'limit' => 20
]);

// Event type analysis
$eventStats = Event::query([
    'select' => 'event_type, COUNT(*) as event_count',
    'conditions' => [
        'account_id = ? AND created_at > ?',
        $accountId,
        $dateRange
    ],
    'group' => 'event_type'
]);
```

## Count and Aggregation Queries

### Efficient Counting

```php
// Count records efficiently
$contactCount = Contact::count([
    'conditions' => ['account_id = ? AND status = ?', $accountId, 'active']
]);

// Modern count syntax
$dealCount = Deal::count([
    'conditions' => ['account_id' => $accountId, 'status' => 'open']
]);

// Conditional counting
$newLeadsThisWeek = Contact::count([
    'conditions' => [
        'account_id = ? AND created_at >= ?',
        $accountId,
        $weekStart
    ]
]);
```

## Record Creation Patterns

### Standard Creation

```php
// Create new contact
$contact = Contact::create([
    'account_id' => $accountId,
    'name' => $name,
    'email' => $email,
    'phone' => $phone,
    'lead_source' => 'Website Form',
    'status' => 'active'
]);

// Create with validation
$deal = new Deal([
    'account_id' => $accountId,
    'contact_id' => $contactId,
    'amount' => $amount,
    'status' => 'open'
]);

if ($deal->save()) {
    // Success - continue with logic
} else {
    // Handle validation errors
    $errors = $deal->errors->full_messages();
}
```

### Bulk Operations

```php
// Batch insert pattern
$contactData = [];
foreach ($importData as $row) {
    $contactData[] = [
        'account_id' => $accountId,
        'name' => $row['name'],
        'email' => $row['email'],
        'created_at' => date('Y-m-d H:i:s')
    ];
}

// Use raw SQL for bulk insert
Contact::connection()->query(
    'INSERT INTO contacts (account_id, name, email, created_at) VALUES ' .
    implode(',', array_fill(0, count($contactData), '(?, ?, ?, ?)')),
    array_merge(...array_map('array_values', $contactData))
);
```

## Transaction Patterns

### Standard Transactions

```php
// Simple transaction
ActiveRecord\Connection::transaction(function() use ($contactId, $dealData, $accountId) {
    $contact = Contact::find($contactId);
    $contact->stage_id = $dealData['stage_id'];
    $contact->save();

    Deal::create([
        'contact_id' => $contactId,
        'account_id' => $accountId,
        'amount' => $dealData['amount']
    ]);
});

// Transaction with error handling
try {
    ActiveRecord\Connection::transaction(function() use ($data) {
        // Multiple operations that must all succeed
        $result1 = Operation1::execute($data);
        $result2 = Operation2::execute($result1);

        if (!$result2) {
            throw new Exception('Operation failed');
        }
    });
} catch (Exception $e) {
    // Handle rollback
    Logger::error('Transaction failed: ' . $e->getMessage());
}
```

## Performance Optimization Examples

### Eager Loading

```php
// Load contacts with related data
$contactsWithDeals = Contact::find('all', [
    'conditions' => ['account_id' => $accountId],
    'include' => ['deals', 'events'],  // Prevents N+1 queries
    'order' => 'created_at DESC'
]);

// Selective loading
$contacts = Contact::find('all', [
    'conditions' => ['account_id' => $accountId],
    'select' => 'id, name, email, phone',  // Only needed columns
    'limit' => 100
]);
```

### Index Hint Usage

```php
// Use specific index when needed
$contacts = Contact::find('all', [
    'conditions' => ['account_id = ?', $accountId],
    'from' => 'contacts USE INDEX(idx_account_created)',
    'order' => 'created_at DESC'
]);
```

When writing ActiveRecord queries:
1. Always include `account_id` filtering for client database queries
2. Use parameterized queries to prevent SQL injection
3. Prefer hash syntax for simple equality conditions
4. Use placeholder syntax for complex conditions
5. Include proper ordering and limits for large result sets
6. Use transactions for multi-table operations
7. Consider eager loading to prevent N+1 queries
8. Test queries with realistic data volumes