## Advanced Patterns

### Complex Email Parser Implementation
```php
namespace richdesk\analysis;

/**
 * Advanced email parser with error handling and logging
 * @group email-parser
 */
class AdvancedLeadSourceParser extends EmailParser
{
    use StatsD; // For metrics collection

    protected array $requiredFields = ['first_name', 'email'];
    protected array $optionalFields = ['last_name', 'phone', 'message'];

    public function parseEmail(array $emailData): ParsedResult
    {
        $this->statsD()->increment('email_parser.parse_attempt', [
            'parser' => static::class
        ]);

        try {
            $leadData = $this->extractLeadData($emailData);
            $validatedData = $this->validateRequiredFields($leadData);

            $this->statsD()->increment('email_parser.parse_success');
            return new ParsedResult($validatedData);

        } catch (ValidationException $e) {
            $this->statsD()->increment('email_parser.validation_error');
            throw new EmailParseException("Validation failed: {$e->getMessage()}", 0, $e);

        } catch (Exception $e) {
            $this->statsD()->increment('email_parser.parse_error');
            $this->logError("Email parsing failed", [
                'parser' => static::class,
                'error' => $e->getMessage(),
                'email_subject' => $emailData['subject'] ?? 'unknown'
            ]);
            throw $e;
        }
    }

    protected function extractLeadData(array $emailData): array
    {
        $patterns = $this->getExtractionPatterns();
        $leadData = [];

        foreach ($patterns as $field => $pattern) {
            if (preg_match($pattern, $emailData['body'], $matches)) {
                $leadData[$field] = trim($matches[1]);
            }
        }

        return $leadData;
    }

    protected function validateRequiredFields(array $leadData): array
    {
        foreach ($this->requiredFields as $field) {
            if (empty($leadData[$field])) {
                throw new ValidationException("Required field missing: {$field}");
            }
        }

        return $leadData;
    }
}
```

### Advanced Testing with Fixtures and Mocking
```php
namespace richdesk\tests\cases\analysis;

class AdvancedEmailParserTest extends DatabaseTestCase
{
    protected array $fixtures = ['Contact', 'User', 'LeadEmail'];

    public function setUp(): void
    {
        parent::setUp();
        $this->login();

        // Set up test configuration
        Config::set('lead_email_domains', ['test.example.com']);
    }

    /**
     * @group email-parser
     * @dataProvider emailDataProvider
     */
    public function testParseEmailWithVariousFormats(
        array $emailData,
        array $expectedResult
    ): void {
        // Arrange
        $sut = new AdvancedLeadSourceParser();
        $sut->setTestMode(true); // Disable external API calls

        // Act
        $result = $sut->parseEmail($emailData);

        // Assert
        $this->assertEquals($expectedResult['first_name'], $result->getFirstName());
        $this->assertEquals($expectedResult['email'], $result->getEmail());

        // Verify database persistence
        $this->assertDatabaseHas('contacts', [
            'email' => $expectedResult['email'],
            'first_name' => $expectedResult['first_name']
        ]);
    }

    public function emailDataProvider(): array
    {
        return [
            'standard_format' => [
                [
                    'subject' => 'New Lead from Website',
                    'body' => 'Name: John Doe\nEmail: john@example.com\nPhone: 555-1234'
                ],
                ['first_name' => 'John', 'email' => 'john@example.com']
            ],
            'json_format' => [
                [
                    'subject' => 'Lead Data',
                    'body' => json_encode([
                        'contact' => ['name' => 'Jane Smith', 'email' => 'jane@example.com']
                    ])
                ],
                ['first_name' => 'Jane', 'email' => 'jane@example.com']
            ]
        ];
    }

    public function testParseEmailHandlesValidationErrors(): void
    {
        // Arrange
        $invalidEmailData = ['subject' => 'Test', 'body' => 'No valid data'];
        $sut = new AdvancedLeadSourceParser();

        // Act & Assert
        $this->expectException(EmailParseException::class);
        $this->expectExceptionMessage('Validation failed: Required field missing: email');

        $sut->parseEmail($invalidEmailData);
    }

    public function testParseEmailLogsMetrics(): void
    {
        // Arrange
        $emailData = $this->getValidEmailFixture();
        $mockStatsD = $this->createMock(StatsD::class);

        // Expect metrics to be logged
        $mockStatsD->expects($this->exactly(2))
            ->method('increment')
            ->withConsecutive(
                ['email_parser.parse_attempt'],
                ['email_parser.parse_success']
            );

        $sut = new AdvancedLeadSourceParser();
        $sut->setStatsD($mockStatsD);

        // Act
        $sut->parseEmail($emailData);
    }
}
```

### Database Optimization Strategies
```php
// Batch operations to prevent N+1 queries
class ContactBatchProcessor
{
    public function processContactUpdates(array $contactIds): void
    {
        // Load all contacts in single query
        $contacts = Contact::find('all', [
            'conditions' => ['id IN(?)', $contactIds],
            'joins' => ['User'] // Include related data
        ]);

        // Batch process without additional queries
        foreach ($contacts as $contact) {
            $this->processContact($contact);
        }

        // Bulk update operation
        Contact::update(
            ['last_processed' => date('Y-m-d H:i:s')],
            ['conditions' => ['id IN(?)', $contactIds]]
        );
    }

    public function getContactsWithActivities(array $contactIds): array
    {
        // Complex query with proper joins to avoid N+1
        return Contact::find('all', [
            'conditions' => ['Contact.id IN(?)', $contactIds],
            'joins' => [
                'User',
                'Activities' => [
                    'type' => 'LEFT',
                    'conditions' => ['Activities.status' => 'active']
                ]
            ],
            'select' => [
                'Contact.*',
                'User.name as user_name',
                'COUNT(Activities.id) as activity_count'
            ],
            'group' => 'Contact.id',
            'order' => 'Contact.created_at DESC'
        ]);
    }
}
```

### Error Handling and Logging Patterns
```php
namespace richdesk\services;

use richdesk\extensions\core\Logger;
use richdesk\exceptions\ServiceException;

class ContactService
{
    public function createContact(array $contactData): Contact
    {
        try {
            // Validate input data
            $this->validateContactData($contactData);

            // Create contact using ActiveRecord transaction
            $contact = Contact::create($contactData);

            if (!$contact) {
                throw new ServiceException('Failed to create contact');
            }

            // Log successful creation
            Logger::info('Contact created successfully', [
                'contact_id' => $contact->id,
                'user_id' => $contactData['user_id'] ?? null,
                'source' => 'api'
            ]);

            return $contact;

        } catch (ValidationException $e) {
            Logger::warning('Contact creation validation error', [
                'errors' => $e->getErrors(),
                'input' => $this->sanitizeForLog($contactData)
            ]);
            throw $e;

        } catch (Exception $e) {
            Logger::error('Contact creation system error', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
                'input' => $this->sanitizeForLog($contactData)
            ]);
            throw new ServiceException('Contact creation failed', 0, $e);
        }
    }

    protected function sanitizeForLog(array $data): array
    {
        // Remove sensitive information from logs
        $sensitiveFields = ['password', 'ssn', 'credit_card', 'api_key'];
        return array_diff_key($data, array_flip($sensitiveFields));
    }
}
```

### Lithium Framework Integration Patterns
```php
// Custom model with Lithium framework features
namespace richdesk\models;

use lithium\data\Model;
use richdesk\extensions\data\Behavior\Timestampable;

class Contact extends Model
{
    public $belongsTo = [
        'User' => [
            'class' => 'richdesk\models\User',
            'key' => 'user_id'
        ]
    ];

    public $hasMany = [
        'Activities' => [
            'class' => 'richdesk\models\Activity',
            'key' => 'contact_id'
        ],
        'LeadEmails' => [
            'class' => 'richdesk\models\LeadEmail',
            'key' => 'contact_id'
        ]
    ];

    // Lithium validation rules
    public $validates = [
        'email' => [
            ['notEmpty', 'message' => 'Email is required'],
            ['email', 'message' => 'Must be valid email'],
            ['uniqueEmail', 'message' => 'Email already exists']
        ],
        'first_name' => [
            ['notEmpty', 'message' => 'First name is required'],
            ['lengthBetween', 'min' => 2, 'max' => 50]
        ]
    ];

    // Custom validation method
    public function uniqueEmail($value, $format, array $options = []): bool
    {
        $conditions = ['email' => $value];

        if (!empty($options['values']['id'])) {
            $conditions['id'] = ['!=' => $options['values']['id']];
        }

        return !static::find('count', compact('conditions'));
    }

    // Model behavior integration
    public $actsAs = ['Timestampable'];

    // Custom finder methods
    public static function findByUserWithRecentActivity($userId, $days = 30): array
    {
        $sinceDate = date('Y-m-d', strtotime("-{$days} days"));

        return static::find('all', [
            'conditions' => [
                'user_id' => $userId,
                'last_activity >= ?' => $sinceDate
            ],
            'order' => 'last_activity DESC',
            'limit' => 50
        ]);
    }
}
```

