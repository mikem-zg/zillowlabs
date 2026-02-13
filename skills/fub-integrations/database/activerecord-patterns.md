## ActiveRecord Database Operations (FUB Dual-Database Architecture)

### Essential Database Patterns

**Client-Specific Database Queries (Account-Scoped):**
```php
// Contact queries with account isolation
$contacts = Contact::find('all', [
    'conditions' => ['account_id' => $accountId, 'status' => 'active'],
    'order' => 'created_at DESC'
]);

// Zillow integration queries
$zillow_agents = ZillowAgent::find('all', [
    'conditions' => ['account_id' => $accountId]
]);

// Common database queries (shared resources)
$mls_areas = ZillowMlsArea::find('all', [
    'conditions' => ['state' => 'CA', 'active' => 1]
]);
```

**Model Creation with Account Scoping:**
```php
// Always include account_id for client database records
$contact = Contact::create([
    'name' => $contactData['name'],
    'email' => $contactData['email'],
    'account_id' => $accountId
]);

// Zillow agent profile creation
$zillow_agent = ZillowAgent::create([
    'contact_id' => $contact->id,
    'zillow_id' => $zillowData['id'],
    'profile_data' => json_encode($zillowData),
    'account_id' => $accountId
]);
```

**Transaction Management for Multi-Table Operations:**
```php
// FUB transaction pattern
ActiveRecord\Connection::transaction(function() use ($contactId, $dealData, $accountId) {
    $contact = Contact::find($contactId);
    $contact->stage_id = $dealData['stage_id'];
    $contact->save();

    Deal::create([
        'contact_id' => $contactId,
        'amount' => $dealData['amount'],
        'account_id' => $accountId
    ]);
});
```

## Account-Scoped Query Patterns

### Security-First Querying
Always filter by `account_id` in client database queries:

```php
// CORRECT: Account-scoped query
$contacts = Contact::find('all', [
    'conditions' => ['account_id' => $accountId, 'status' => 'active']
]);

// INCORRECT: Missing account scope - Security vulnerability!
$contacts = Contact::find('all', [
    'conditions' => ['status' => 'active']
]);
```

### Cross-Database Relationships
```php
// Common → Client relationship via account_id
$account = Account::find($accountId);  // Common DB
$users = User::find('all', [          // Client DB
    'conditions' => ['account_id' => $account->id]
]);
```

### Zillow Integration Queries
```php
// Check Zillow eligibility
$zillowAuth = ZillowAuth::find('first', [
    'conditions' => [
        'account_id' => $accountId,
        'zuid IS NOT NULL',
        'oauth_token IS NOT NULL'
    ]
]);

// Get Zillow agents for account
$agents = ZillowAgent::find('all', [
    'conditions' => ['account_id' => $accountId],
    'include' => ['zillow_auth']  // Eager loading
]);
```

## Model Relationships

### Integration Model Relationships
```php
// ZillowAgent model relationships
class ZillowAgent extends Model {
    public static $belongs_to = [
        ['contact', 'class' => 'Contact'],
        ['account', 'class' => 'Account']
    ];

    public static $has_many = [
        ['zillow_teams', 'class' => 'ZillowTeam']
    ];
}

// Usage with relationships
$zillow_agent = ZillowAgent::find($agentId);
$contact = $zillow_agent->contact;
$teams = $zillow_agent->zillow_teams;
```

## Performance Optimization Patterns

### Indexing Patterns
- **Always index `account_id`** in client tables
- **Composite indexes** for common query patterns:
  - `(account_id, created_at)` for timeline queries
  - `(account_id, status)` for status filtering
  - `(account_id, user_id)` for user-scoped data

### N+1 Query Prevention
```php
// GOOD: Batch loading
$contactIds = [1, 2, 3, 4, 5];
$contacts = Contact::find('all', [
    'conditions' => ['id IN (?) AND account_id = ?', $contactIds, $accountId]
]);

// BAD: N+1 problem
foreach ($contactIds as $contactId) {
    $contact = Contact::find($contactId);  // Separate query each time
}
```

### Standard ActiveRecord Operations

**Finding Records:**
```php
// Single record
$contact = Contact::find($contactId);

// Multiple conditions
$contacts = Contact::find('all', [
    'conditions' => [
        'account_id' => $accountId,
        'status' => 'active',
        'created_at > ?' => '2024-01-01'
    ],
    'order' => 'created_at DESC',
    'limit' => 10
]);

// Using SQL fragments for complex queries
$agentIds = [1, 2, 3, 4, 5];
$agents = ZillowAgent::find('all', [
    'conditions' => ['id IN (?)', $agentIds]
]);
```

**Creating Records:**
```php
// Standard create pattern
$contact = Contact::create([
    'name' => $name,
    'email' => $email,
    'account_id' => $accountId
]);

// With validation
$deal = new Deal([
    'contact_id' => $contactId,
    'amount' => $amount,
    'account_id' => $accountId
]);
if ($deal->save()) {
    // Success
}
```

**Transaction Patterns:**
```php
// FUB transaction management
ActiveRecord\Connection::transaction(function() use ($contactId, $dealData) {
    $contact = Contact::find($contactId);
    $contact->stage_id = $dealData['stage_id'];
    $contact->save();

    Deal::create([
        'contact_id' => $contactId,
        'amount' => $dealData['amount'],
        'account_id' => $contact->account_id
    ]);
});
```

## Migration Patterns

### Client Database Migrations
```sql
-- Client table pattern
ALTER TABLE `contacts`
ADD COLUMN `zillow_profile_url` VARCHAR(255) AFTER `email`;

-- Always include account_id in indexes
CREATE INDEX idx_contacts_account_zillow
ON contacts(account_id, zillow_profile_url);
```

### Common Database Migrations
```sql
-- Common table pattern (no account_id needed)
ALTER TABLE `registered_systems`
ADD COLUMN `api_version` VARCHAR(20) AFTER `system_type`;

CREATE INDEX idx_systems_type_version
ON registered_systems(system_type, api_version);
```

## Model Development Guidelines

1. **Always extend appropriate base classes** (`Model`, `ContactBase`)
2. **Define `$table_name` explicitly** for clarity
3. **Use account scoping** in all client database queries
4. **Implement proper relationships** with `belongs_to`, `has_many`
5. **Add validation rules** for data integrity

### Query Development Best Practices

1. **Use parameterized queries** to prevent SQL injection
2. **Include account_id filtering** in client database queries
3. **Batch operations** to prevent N+1 problems
4. **Use transactions** for multi-table operations
5. **Add proper indexes** for query performance