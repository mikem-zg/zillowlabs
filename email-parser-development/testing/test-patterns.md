## Comprehensive Test Development

### Test Class Following DatabaseTestCase Pattern

```php
<?php
declare(strict_types=1);

namespace richdesk\tests\cases\analysis;

use richdesk\extensions\test\DatabaseTestCase;
use richdesk\analysis\email_parser\[LeadSourceName];

/**
 * Tests for [LeadSourceName] email parser.
 * @group email-parser
 * @group [lead-source-name]
 */
class [LeadSourceName]Test extends DatabaseTestCase
{
    private $parser;
    private $sampleEmailsPath;

    public function setUp(): void
    {
        parent::setUp();
        $this->login();  // Required for DatabaseTestCase
        $this->parser = new [LeadSourceName]();
        $this->sampleEmailsPath = '/var/www/test-lead-emails/emails/[LeadSourceName]';
    }

    public function testRecognizeValidEmail(): void
    {
        // Arrange
        $emailData = $this->loadSampleEmail('standard-sample.txt');

        // Act
        $result = $this->parser->recognize($emailData);

        // Assert
        $this->assertTrue($result, 'Parser should recognize valid [LeadSourceName] email');
    }

    public function testParseCompleteEmail(): void
    {
        // Arrange
        $emailData = $this->loadSampleEmail('standard-sample.txt');

        // Act
        $result = $this->parser->_parseEmailBody($emailData);

        // Assert
        $this->assertNotEmpty($result['email'], 'Email should be extracted');
        $this->assertEquals('[Lead Source Display Name]', $result['source']);
        $this->assertEquals('[system-identifier]', $result['system']);
        $this->assertContains('[Lead Source Tag]', $result['_tags']);
    }

    public function testParseMinimalEmail(): void
    {
        // Arrange - Email with only required fields
        $emailData = $this->loadSampleEmail('minimal-fields.txt');

        // Act
        $result = $this->parser->_parseEmailBody($emailData);

        // Assert - Should handle gracefully
        $this->assertArrayHasKey('source', $result);
        $this->assertArrayHasKey('system', $result);
    }

    /**
     * @dataProvider emailVariationsProvider
     */
    public function testEmailVariations($filename, $expectedFields): void
    {
        // Arrange
        $emailData = $this->loadSampleEmail($filename);

        // Act
        $result = $this->parser->_parseEmailBody($emailData);

        // Assert
        foreach ($expectedFields as $field => $expectedValue) {
            $this->assertEquals($expectedValue, $result[$field], "Field $field mismatch");
        }
    }

    public function emailVariationsProvider(): array
    {
        return [
            ['standard-sample.txt', ['source' => '[Lead Source Display Name]']],
            ['html-format.txt', ['source' => '[Lead Source Display Name]']],
            // Add more test cases
        ];
    }

    private function loadSampleEmail(string $filename): array
    {
        $content = file_get_contents($this->sampleEmailsPath . '/' . $filename);

        // Simulate email array structure
        return [
            'body-html' => $content,
            'body-plain' => strip_tags($content),
            'subject' => 'Test Subject',
            // Add other required email fields
        ];
    }
}
```

## Remote Test Execution and Local Coverage Analysis

### Execute Tests on FUB Remote Environment

```bash
# Individual parser test
ssh fubdev-matttu-dev-01 'cd /var/www/fub && li3 leads test /var/www/test-lead-emails/emails/[LeadSourceName]/sample.txt'

# Test with saved JSON output (updates parsed directory)
ssh fubdev-matttu-dev-01 'cd /var/www/fub && li3 leads testSaveJson /var/www/test-lead-emails/emails/[LeadSourceName]/sample.txt'

# Run all email parser tests (regression testing)
ssh fubdev-matttu-dev-01 'cd /var/www/fub && li3 leads testAllJson /var/www/test-lead-emails'

# PHPUnit test execution with coverage
ssh fubdev-matttu-dev-01 'cd /var/www/fub &&
  XDEBUG_MODE=coverage ./vendor/bin/phpunit \
    --coverage-clover phpunit-cache/cov-[lead-source].xml \
    apps/richdesk/tests/cases/analysis/[LeadSourceName]Test.php \
    --verbose'
```

### Local Coverage Analysis (xmlstarlet required via Homebrew)

```bash
# Install xmlstarlet locally if needed
brew install xmlstarlet

# Retrieve coverage file via Mutagen sync from remote
# Coverage file should be available at: fub/phpunit-cache/cov-[lead-source].xml

# Analyze parser-specific coverage
xmlstarlet sel -t \
  -m "//class[@name=\"richdesk\\analysis\\email_parser\\[LeadSourceName]\"]/methods/method" \
  -v "concat(@name, ': ', @crap, ' complexity, ', @coverage, '% coverage')" \
  -n fub/phpunit-cache/cov-[lead-source].xml

# Overall parser coverage summary
xmlstarlet sel -t \
  -m "//class[@name=\"richdesk\\analysis\\email_parser\\[LeadSourceName]\"]" \
  -v "concat('Coverage: ', @coverage, '%, Lines: ', @lines, ', Methods: ', @methods)" \
  fub/phpunit-cache/cov-[lead-source].xml

# Validate coverage XML file
xmlstarlet val fub/phpunit-cache/cov-[lead-source].xml
```

## Sample Email Collection and PII Scrubbing

### Obtain Sample Emails Using FUB Tools

**With Message ID (Easiest Method):**

1. Log into CSD (https://csd.followupboss.com)
2. Navigate to Tools menu → Download Lead Emails
3. Enter message ID and download the email sample

**Without Message ID (Locate via CSD):**

1. Log into CSD, search for the relevant account
2. Click "Login as FUB" for the target user
3. Navigate to bottom-left CSD tab when FUB loads
4. Click "View Lead Emails" link in expanded tab
5. Use available data points to locate the relevant email
6. Click the small Copy icon to copy the message ID

**Convert .eml Files:**
```bash
# Convert raw .eml file to parsed format
ssh fubdev-matttu-dev-01 'cd /var/www/fub && li3 simulateImap convertRaw /path/to/file.eml true'
```
Output appears as `file.eml-converted.txt` and should be moved to `test-lead-emails` repo.

### Sample Email Organization in test-lead-emails

Directory structure: `test-lead-emails/emails/[ParserName]/`
File naming: Use descriptive names for sample variations
- Examples: `standard-sample.txt`, `minimal-fields.txt`, `html-format.txt`

### PII Scrubbing Workflow (Critical for Privacy)

Must scrub all PII per FUB Data Guide: names, emails, phone numbers, addresses
Replacement strategy: maintain format while ensuring parser tests still pass

```bash
# Example scrubbing command structure
sed -i 's/original-email@domain.com/test@example.com/g' sample.txt
sed -i 's/John Smith/Test User/g' sample.txt
sed -i 's/123 Main Street/123 Test Street/g' sample.txt

# Verify PII removal and test functionality
git diff --word-diff  # Verify only PII was changed
```