## Quick Reference

### Essential Database Patterns

**Account-Scoped Queries:**
```php
// ALWAYS include account_id for client database queries
$contacts = Contact::find('all', [
    'conditions' => ['account_id' => $accountId, 'status' => 'active']
]);
```

**Model Creation:**
```php
// Standard creation pattern with account scoping
$contact = Contact::create([
    'name' => $contactData['name'],
    'account_id' => $accountId  // Required for client DB
]);
```

**Transactions:**
```php
// Multi-table operations
ActiveRecord\Connection::transaction(function() use ($data, $accountId) {
    $contact = Contact::find($contactId);
    $contact->save();
    Deal::create(['contact_id' => $contactId, 'account_id' => $accountId]);
});
```

### Key Integration Models

**Zillow Integration:**
- `ZillowAgent` - Agent profiles and mapping
- `ZillowAuth` - OAuth tokens and authentication
- `ZillowSyncUser` - User synchronization tracking

**ZHL Integration:**
- `ZhlLoanOfficer` - Loan officer profiles
- `ZhlDedicatedLoanOfficerMap` - Territory assignments
- `ZhlStatusChangelog` - Status change audit trail

### Frontend Components (fub-spa)

**Zillow Components:**
- `src/features/zillow-auth/link-zillow-profile-modal.jsx`
- `src/features/zillow-auth/hooks/use-zillow-auth.js`
- `src/features/zillow-stage-mappings/`

**ZHL Components:**
- `src/features/zhl-transfer-modals/zhl-modal-container.jsx`
- `src/types/zhl-loan-officers.js`

### Security Checklist

- [ ] All client queries include `account_id` filtering
- [ ] External data is properly sanitized
- [ ] OAuth tokens are validated before use
- [ ] User permissions are enforced
- [ ] API keys are properly secured

### Performance Best Practices

- [ ] Use composite indexes: `(account_id, created_at)`, `(account_id, status)`
- [ ] Batch operations to prevent N+1 queries
- [ ] Cache frequently accessed integration data
- [ ] Process large datasets in batches
- [ ] Use eager loading for related models

### Testing Patterns

**Backend Testing:**
```php
// Account isolation test
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
}
```

**Frontend Testing:**
```javascript
// Component test with mocked API
describe('ZillowAuthModal', () => {
    it('should connect to zillow', async () => {
        mockApi('/api/zillow/auth', { success: true });
        render(<ZillowAuthModal />);
        fireEvent.click(screen.getByText('Connect'));
        await waitFor(() => {
            expect(screen.getByText('Connected')).toBeInTheDocument();
        });
    });
});
```

### Common Pitfalls to Avoid

❌ **Missing Account Scoping:**
```php
// WRONG - Security vulnerability
$contacts = Contact::find('all', ['conditions' => ['status' => 'active']]);
```

✅ **Correct Account Scoping:**
```php
// RIGHT - Secure and isolated
$contacts = Contact::find('all', [
    'conditions' => ['account_id' => $accountId, 'status' => 'active']
]);
```

❌ **N+1 Query Problem:**
```php
// WRONG - Generates multiple queries
foreach ($contactIds as $contactId) {
    $contact = Contact::find($contactId);
}
```

✅ **Batch Loading:**
```php
// RIGHT - Single optimized query
$contacts = Contact::find('all', [
    'conditions' => ['id IN (?) AND account_id = ?', $contactIds, $accountId]
]);
```

### Development Workflow Checklist

**Pre-Development:**
- [ ] Review integration requirements and external API documentation
- [ ] Understand data flow and account scoping requirements
- [ ] Plan database schema changes with proper indexing

**Development:**
- [ ] Implement account scoping in all client database operations
- [ ] Add proper model relationships and validations
- [ ] Implement comprehensive error handling
- [ ] Add caching for frequently accessed data

**Testing:**
- [ ] Create unit tests with account isolation
- [ ] Add integration tests with mocked external APIs
- [ ] Test error conditions and edge cases
- [ ] Validate performance with realistic data volumes

**Deployment:**
- [ ] Review code for security vulnerabilities
- [ ] Verify database indexes are in place
- [ ] Test integration in staging environment
- [ ] Set up monitoring and alerting for production