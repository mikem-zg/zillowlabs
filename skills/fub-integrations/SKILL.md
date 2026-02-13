---
name: fub-integrations
description: Comprehensive codebase knowledge for Zynaptic Overlords/FUB+ Integrations team including database schema, controllers, services, models, frontend components, and integration patterns for Zillow, ZHL, and external systems
user-invocable: false
---

## Overview

Comprehensive codebase knowledge for Zynaptic Overlords/FUB+ Integrations team including database schema, controllers, services, models, frontend components, and integration patterns for Zillow, ZHL, and external systems. Covers dual-database architecture, ActiveRecord patterns, React/TypeScript components, and testing infrastructure for 6 production systems handling 677+ million sync events.

**Note**: This is a reference skill (`user-invocable: false`) that provides codebase knowledge to other skills. It is automatically referenced by integration-related operations and development tasks but cannot be invoked directly by users.

📁 **Database Patterns**: [database/activerecord-patterns.md](database/activerecord-patterns.md)

## Core Workflow

### Essential Integration Development Patterns (Daily Operations - 80% Usage)

**1. ActiveRecord Database Operations (FUB Dual-Database Architecture)**
```php
// Client-specific database queries (account-scoped)
$contacts = Contact::find('all', [
    'conditions' => ['account_id' => $accountId, 'status' => 'active'],
    'order' => 'created_at DESC'
]);

// Zillow integration queries
$zillow_agents = ZillowAgent::find('all', [
    'conditions' => ['account_id' => $accountId]
]);
```

**2. Model Creation with Account Scoping**
```php
// Always include account_id for client database records
$contact = Contact::create([
    'name' => $contactData['name'],
    'email' => $contactData['email'],
    'account_id' => $accountId
]);
```

**3. Transaction Management for Multi-Table Operations**
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

**4. Testing with Account Isolation (PHPUnit)**
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

### Behavior

This reference skill provides comprehensive codebase knowledge for integration development:

**1. Database Architecture Knowledge**
- Dual-database structure (client-specific and common databases)
- ActiveRecord patterns with proper account scoping
- Model relationships and transaction management patterns
- Performance optimization through indexing and batch operations

**2. Frontend Integration Patterns**
- React/TypeScript component structures for Zillow and ZHL integrations
- State management hooks and API communication patterns
- Error handling and user experience optimization
- Component testing and integration validation

**3. Integration System Architecture**
- Zillow integration patterns (agents, auth, sync, transactions)
- ZHL integration workflows (loan officers, territory mapping, status tracking)
- Security considerations and authentication patterns
- Performance monitoring and error handling strategies

**4. Testing and Quality Assurance**
- PHPUnit testing with account isolation patterns
- Frontend component testing with mocked APIs
- Integration testing and performance validation
- Test data management and cleanup procedures

## Quick Reference

📊 **Complete Reference**: [reference/quick-reference.md](reference/quick-reference.md)

### Key Integration Models

**Zillow Integration:**
- `ZillowAgent` - Agent profiles and mapping to FUB contacts
- `ZillowAuth` - OAuth tokens and authentication state management
- `ZillowSyncUser` - User synchronization tracking and status

**ZHL Integration:**
- `ZhlLoanOfficer` - Loan officer profiles and capabilities
- `ZhlDedicatedLoanOfficerMap` - Territory and assignment mapping
- `ZhlStatusChangelog` - Status change audit trail and history

### Security Patterns

**Account Isolation (Critical):**
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

### Performance Optimization

**Indexing Strategy:**
- Always index `account_id` in client tables
- Composite indexes: `(account_id, created_at)`, `(account_id, status)`
- Batch operations to prevent N+1 queries

**Caching Patterns:**
```php
$cacheKey = "zillow_agent_{$accountId}_{$agentId}";
$cachedAgent = Cache::get($cacheKey) ?: ZillowAgent::find($agentId);
```

## Advanced Patterns

🔧 **Frontend Components**: [frontend/react-components.md](frontend/react-components.md)

<details>
<summary>Click to expand advanced integration patterns and system architecture</summary>

### Frontend Integration Architecture
- React/TypeScript components for Zillow and ZHL integrations
- State management hooks and data preloading patterns
- API communication and error handling strategies
- Component testing with mocked external services

### Integration System Patterns
- OAuth authentication flows for external services
- Data synchronization and conflict resolution strategies
- Error handling and monitoring for production systems
- Performance optimization and caching strategies

### Database Architecture Details
- Dual-database design patterns and cross-database relationships
- Migration strategies for client and common databases
- Transaction management and rollback procedures
- Performance monitoring and query optimization

📚 **Complete Architecture Documentation**: [integration/system-patterns.md](integration/system-patterns.md)

</details>

## Integration Points

🔗 **System Architecture**: [integration/system-patterns.md](integration/system-patterns.md)

### Development Guidelines

**Model Development:**
1. Always extend appropriate base classes (`Model`, `ContactBase`)
2. Define `$table_name` explicitly for clarity
3. Use account scoping in all client database queries
4. Implement proper relationships with `belongs_to`, `has_many`
5. Add validation rules for data integrity

**Query Development:**
1. Use parameterized queries to prevent SQL injection
2. Include account_id filtering in client database queries
3. Batch operations to prevent N+1 problems
4. Use transactions for multi-table operations
5. Add proper indexes for query performance

### Testing Patterns

🧪 **Testing Framework**: [testing/test-patterns.md](testing/test-patterns.md)

**Backend Testing Requirements:**
- Account isolation in all test scenarios
- Mock external API responses for integration tests
- Transaction rollback testing for error conditions
- Performance testing with realistic data volumes

**Frontend Testing Requirements:**
- Component testing with mocked backend APIs
- Hook testing for state management validation
- Integration testing for complete user workflows
- Error boundary testing for resilient user experience

### Multi-System Integration Examples

**Complete Integration Development Workflow:**
1. Database schema design with proper account scoping
2. ActiveRecord model implementation with relationships
3. Frontend component development with state management
4. Comprehensive testing with account isolation
5. Performance optimization and monitoring setup