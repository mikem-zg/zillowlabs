## FUB ActiveRecord Query Patterns

### Preferred Modern ActiveRecord Patterns (New Development)

```php
// PREFERRED: Modern ActiveRecord methods for new FUB development

// Use ::all() instead of ::find('all')
$recentContacts = Contact::all([
    'conditions' => ['account_id' => $accountId, 'status' => 'active'],
    'order' => 'created_at DESC',
    'limit' => 50
]);

// Use ::first() instead of ::find('first')
$user = User::first([
    'conditions' => ['email' => $email, 'account_id' => $accountId]
]);

// Use ::last() instead of ::find('last')
$latestContact = Contact::last([
    'conditions' => ['account_id' => $accountId],
    'order' => 'created_at DESC'
]);

// Complex conditions with modern syntax
$highValueDeals = Deal::all([
    'conditions' => ['account_id = ? AND amount > ? AND status IN (?)',
                    $accountId, $minAmount, ['pending', 'accepted']]
]);

// IN clause with modern syntax
$users = User::all([
    'conditions' => ['id IN (?)', $userIds]
]);

// Count operations
$activeContactCount = Contact::count([
    'conditions' => ['account_id' => $accountId, 'status' => 'active']
]);

// Dynamic finders (still preferred)
$user = User::find_by_email($email);
$contacts = Contact::find_all_by_account_id($accountId);
```

### Legacy ActiveRecord Patterns (Existing Code Understanding)

```php
// LEGACY: Understanding existing FUB codebase patterns

// Hash syntax (found in existing code)
$recentContacts = Contact::find('all', [
    'conditions' => ['account_id' => $accountId, 'status' => 'active'],
    'order' => 'created_at DESC',
    'limit' => 50
]);

// Single record retrieval (existing pattern)
$user = User::find('first', [
    'conditions' => ['email' => $email, 'account_id' => $accountId]
]);

// When updating existing code, prefer modern equivalents:
// ::find('all') → ::all()
// ::find('first') → ::first()
// ::find('last') → ::last()
// ::find('count') → ::count()
```

### ActiveRecord Pattern Migration Guidelines

```php
// MIGRATION STRATEGY: Update patterns when modifying existing code

// Before (legacy pattern in existing code)
$contacts = Contact::find('all', [
    'conditions' => ['account_id' => $accountId]
]);

// After (preferred modern pattern)
$contacts = Contact::all([
    'conditions' => ['account_id' => $accountId]
]);

// Before (legacy single record)
$user = User::find('first', [
    'conditions' => ['id' => $userId]
]);

// After (preferred modern pattern)
$user = User::first([
    'conditions' => ['id' => $userId]
]);
```

### Safe ActiveRecord Construction for FUB's Framework

**FUB ActiveRecord Parameterized Query Requirements:**
```php
// CORRECT: FUB ActiveRecord patterns with proper parameterization
$contacts = Contact::find('all', [
    'conditions' => ['account_id = ? AND email LIKE ? AND status IN (?)',
                    $accountId, "%{$searchTerm}%", ['active', 'pending']],
    'order' => 'created_at DESC'
]);

// Hash syntax for simple equality
$user = User::find('first', [
    'conditions' => ['email' => $email, 'account_id' => $accountId]
]);

// Creating records with mass assignment protection
$contact = Contact::create([
    'name' => $name,
    'email' => $email,
    'account_id' => $accountId
]);
```

### ActiveRecord Transaction Management Patterns

**FUB Transaction Patterns:**
```php
// Basic transaction usage
ActiveRecord\Connection::transaction(function() {
    $user = User::create(['name' => 'John', 'email' => 'john@example.com']);
    $profile = Profile::create(['user_id' => $user->id, 'bio' => 'Developer']);
});

// Error handling in transactions
try {
    ActiveRecord\Connection::transaction(function() use ($contactId, $status) {
        $contact = Contact::find($contactId);
        $contact->status = $status;
        $contact->save();

        if ($errorCondition) {
            throw new Exception('Transaction should rollback');
        }
    });
} catch (Exception $e) {
    Logger::error('Transaction failed: ' . $e->getMessage());
}
```

**Advanced Transaction Patterns:**
```php
// Complex transaction with multiple models
ActiveRecord\Connection::transaction(function() use ($dealId, $userId) {
    $deal = Deal::find($dealId);
    $deal->status = 'closed';
    $deal->closed_at = date('Y-m-d H:i:s');
    $deal->save();

    // Update related contact
    $contact = Contact::find($deal->contact_id);
    $contact->deal_status = 'closed';
    $contact->save();

    // Create history record
    DealHistory::create([
        'deal_id' => $dealId,
        'action' => 'closed',
        'user_id' => $userId,
        'created_at' => date('Y-m-d H:i:s')
    ]);

    // Update account statistics
    $account = Account::find($deal->account_id);
    $account->incrementClosedDealsCount();
});

// Transaction with rollback on condition
ActiveRecord\Connection::transaction(function() use ($contactId, $newData) {
    $contact = Contact::find($contactId);
    $originalEmail = $contact->email;

    $contact->update_attributes($newData);

    // Check for duplicate email after update
    $duplicateCount = Contact::count([
        'conditions' => ['email = ? AND id != ?', $contact->email, $contactId]
    ]);

    if ($duplicateCount > 0) {
        throw new Exception('Duplicate email found, rolling back changes');
    }

    // Log the change
    ContactHistory::create([
        'contact_id' => $contactId,
        'field_changed' => 'email',
        'old_value' => $originalEmail,
        'new_value' => $contact->email
    ]);
});
```

### Performance Optimization Patterns

**Query Optimization:**
```php
// Efficient eager loading to avoid N+1 queries
$contacts = Contact::all([
    'include' => ['account', 'deals'],
    'conditions' => ['status' => 'active'],
    'order' => 'created_at DESC'
]);

// Use specific field selection for large records
$contacts = Contact::all([
    'select' => 'id, name, email, created_at',
    'conditions' => ['account_id' => $accountId],
    'limit' => 100
]);

// Batch processing for large datasets
$batchSize = 1000;
$offset = 0;
do {
    $contacts = Contact::all([
        'conditions' => ['status' => 'needs_processing'],
        'limit' => $batchSize,
        'offset' => $offset
    ]);

    foreach ($contacts as $contact) {
        // Process each contact
        $contact->process();
    }

    $offset += $batchSize;
} while (count($contacts) === $batchSize);
```

**Caching Patterns:**
```php
// Simple query result caching
$cacheKey = "user_contacts_{$userId}";
$contacts = Cache::get($cacheKey);

if (!$contacts) {
    $contacts = Contact::all([
        'conditions' => ['user_id' => $userId, 'status' => 'active'],
        'order' => 'created_at DESC'
    ]);
    Cache::set($cacheKey, $contacts, 3600); // Cache for 1 hour
}

// Cache invalidation on updates
ActiveRecord\Connection::transaction(function() use ($contactId, $newData) {
    $contact = Contact::find($contactId);
    $contact->update_attributes($newData);

    // Invalidate related caches
    Cache::delete("user_contacts_{$contact->user_id}");
    Cache::delete("account_contacts_{$contact->account_id}");
});
```

### Migration Commands (FUB Lithium Framework)

```bash
# Create migration
li3 migration client before <branch-name>    # Client database
li3 migration common before <branch-name>    # Common database

# Deploy locally (includes migrations)
./bin/deploy-dev.sh

# Run migrations only
li3 runMigrations

# Migration files location
/richdesk/resources/sql/updates
```

### SQL Migration Patterns

```sql
-- FUB InnoDB Standards
CREATE TABLE example_table (
    id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    data VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- FUB Index Patterns
CREATE INDEX idx_example_account_created ON example_table(account_id, created_at);

-- Adding columns safely
ALTER TABLE contacts
ADD COLUMN new_field VARCHAR(100) NULL AFTER existing_field,
ADD INDEX idx_contacts_new_field (new_field);

-- Modifying existing columns (with backup consideration)
ALTER TABLE deals
MODIFY COLUMN amount DECIMAL(10,2) NOT NULL DEFAULT 0.00;

-- Dropping columns (requires production approval)
-- Always backup before dropping columns in production
ALTER TABLE old_table DROP COLUMN deprecated_field;
```

### Common Troubleshooting

| **Issue** | **Symptoms** | **Solution** |
|-----------|-------------|--------------|
| **ActiveRecord Connection Failed** | Class not found, connection error | Verify `ArConnections::add()` configuration |
| **Account Model Not Found** | Account::find() fails | Ensure bootstrap.php loaded, verify account ID |
| **Client DB Access Denied** | Authentication error | Check Account model db_* fields populated |
| **Migration Stuck** | li3 runMigrations hangs | Check `common.db_updates` table, clear stale entries |
| **N+1 Query Problem** | Slow query performance | Use 'include' parameter for eager loading |
| **Transaction Deadlock** | Transaction timeout/rollback | Reduce transaction scope, add retry logic |
| **Memory Issues with Large Datasets** | PHP memory limit exceeded | Implement batch processing patterns |

### Data Validation Patterns

```php
// Validate data before database operations
function validateContactData($data) {
    $errors = [];

    if (empty($data['email']) || !filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
        $errors[] = 'Valid email is required';
    }

    if (empty($data['account_id']) || !Account::exists($data['account_id'])) {
        $errors[] = 'Valid account ID is required';
    }

    if (!empty($errors)) {
        throw new ValidationException(implode(', ', $errors));
    }

    return true;
}

// Use validation in database operations
try {
    validateContactData($contactData);

    ActiveRecord\Connection::transaction(function() use ($contactData) {
        $contact = Contact::create($contactData);
        logContactCreation($contact->id);
    });

} catch (ValidationException $e) {
    Logger::error('Contact validation failed: ' . $e->getMessage());
    throw $e;
}
```

### Security Patterns

```php
// Always use parameterized queries
// SECURE: Using placeholders
$contacts = Contact::all([
    'conditions' => ['email LIKE ? AND account_id = ?',
                    "%{$searchTerm}%", $accountId]
]);

// INSECURE: Direct string interpolation (NEVER DO THIS)
// $contacts = Contact::all([
//     'conditions' => "email LIKE '%{$searchTerm}%' AND account_id = {$accountId}"
// ]);

// Mass assignment protection
class Contact extends ActiveRecord\Model {
    static $attr_protected = ['id', 'account_id', 'created_at', 'updated_at'];

    // Only allow these fields to be mass assigned
    static $attr_accessible = ['name', 'email', 'phone', 'status'];
}

// Secure record updates
$contact = Contact::find($contactId);
if ($contact && $contact->account_id === $currentUser->account_id) {
    $contact->update_attributes($safeAttributes);
} else {
    throw new SecurityException('Unauthorized contact access');
}
```