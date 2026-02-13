// Corresponding test file
class RealtyMxEmailParserTest extends DatabaseTestCase
{
    public function testParseValidEmail(): void
    {
        // Arrange
        $emailData = $this->getEmailFixture('realty_mx_lead.json');
        $sut = new RealtyMxEmailParser();

        // Act
        $result = $sut->parseLeadData($emailData);

        // Assert
        $this->assertEquals('John', $result['first_name']);
        $this->assertEquals('Doe', $result['last_name']);
    }
}
```

### Controller Development Pattern
```php
namespace richdesk\controllers;

use richdesk\extensions\controller\ControllerTester;

class ContactsController extends ControllerTester
{
    public function export(): array
    {
        // Validate request and permissions
        $this->requirePermission('contacts.export');

        // Use ActiveRecord for data retrieval
        $contacts = Contact::find('all', [
            'conditions' => ['user_id' => $this->currentUser()->id],
            'order' => 'created_at DESC'
        ]);

        // Process and return response
        return [
            'success' => true,
            'data' => $this->formatContactsForExport($contacts)
        ];
    }
}
```

### Lithium Console Operations
```bash
# Interactive console session (for debugging/exploration)
ssh fubdev-matttu-dev-01 "cd /var/www/fub && libraries/lithium/console/li3"

# Within the console:
# Explore models
Contact::find('first', array('conditions' => array('id' => 123)));

# Test relationships
$contact = Contact::find('first', array(
    'conditions' => array('id' => 123),
    'contain' => array('User', 'Activities')
));

# Check configuration
echo Config::read('database.default.host');
```

### Common Testing Helpers
```php
// Database setup in tests
public function setUp(): void
{
    parent::setUp();
    $this->login();  // Authenticate for protected operations

    // Create test data using fixtures
    $this->loadFixtures('Contact', 'User');
}

// Test HTTP endpoints
public function testContactCreation(): void
{
    $contactData = ['name' => 'Test', 'email' => 'test@example.com'];

    $response = $this->post('/contacts/create', $contactData);

    $this->assertSuccessfulResponse($response);
    $this->assertDatabaseHas('contacts', $contactData);
}
```

### Performance Optimization Patterns
```php
// Prevent N+1 queries with batch loading
$userIds = [1, 2, 3, 4, 5];
$users = User::find('all', [
    'conditions' => ['id IN(?)', $userIds]
]);

// Avoid this N+1 pattern:
// foreach ($userIds as $userId) {
//     $user = User::find($userId); // Creates separate query each time
// }

// Optimize with joins for related data
$contacts = Contact::find('all', [
    'joins' => ['User'],
    'conditions' => ['Contact.status' => 'active'],
    'select' => ['Contact.*', 'User.name as user_name']
]);
```

