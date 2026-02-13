## Quick Reference

| Phase | Key Actions | Files/Locations | Success Criteria |
|-------|-------------|-----------------|------------------|
| **Sample Collection** | Gather and clean emails | `test-lead-emails/emails/` | Multiple samples with PII scrubbed |
| **Parser Implementation** | Create parser class | `apps/richdesk/analysis/email_parser/` | Extends `EmailParser`, implements required methods |
| **Registration** | Add to parser list | `apps/richdesk/models/LeadEmail.php` | Parser in correct precedence order |
| **Testing** | Comprehensive test suite | `apps/richdesk/tests/cases/analysis/` | All tests pass, good coverage |
| **Remote Execution** | SSH test execution | Remote: `fubdev-matttu-dev-01` | Tests pass in remote environment |
| **Coverage Analysis** | Local `xmlstarlet` analysis | Local: coverage analysis | >80% coverage for parser methods |
| **Production Monitoring** | Datadog monitoring | Datadog logs and metrics | No errors, proper success rate |

## Common Command Patterns

### Sample Email Collection
```bash
# Convert .eml file to parsed format
ssh fubdev-matttu-dev-01 'cd /var/www/fub && li3 simulateImap convertRaw /path/to/file.eml true'
```

### PII Scrubbing
```bash
# Standard PII replacement
sed -i 's/original-email@domain.com/test@example.com/g' sample.txt
sed -i 's/John Smith/Test User/g' sample.txt
sed -i 's/123 Main Street/123 Test Street/g' sample.txt
```

### Remote Testing
```bash
# Individual parser test
ssh fubdev-matttu-dev-01 'cd /var/www/fub && li3 leads test /var/www/test-lead-emails/emails/[ParserName]/sample.txt'

# PHPUnit with coverage
ssh fubdev-matttu-dev-01 'cd /var/www/fub && XDEBUG_MODE=coverage ./vendor/bin/phpunit --coverage-clover phpunit-cache/cov-[parser].xml apps/richdesk/tests/cases/analysis/[ParserName]Test.php'
```

### Coverage Analysis
```bash
# Install required tool
brew install xmlstarlet

# Method-level coverage
xmlstarlet sel -t -m "//class[@name=\"richdesk\\analysis\\email_parser\\[ParserName]\"]/methods/method" -v "concat(@name, ': ', @coverage, '% coverage')" -n coverage.xml

# Class-level summary
xmlstarlet sel -t -m "//class[@name=\"richdesk\\analysis\\email_parser\\[ParserName]\"]" -v "concat('Coverage: ', @coverage, '%')" coverage.xml
```

### Static Analysis
```bash
# Psalm validation
vendor/bin/psalm --show-info=true apps/richdesk/analysis/email_parser/[ParserName].php
```

### Production Monitoring
```bash
# Check parser success rate
service:fub-backend source:php @logger_name:richdesk.analysis.LeadEmail | grep "[ParserName] parser" | stats avg(success_rate)
```

## File Structure Template

```
apps/richdesk/analysis/email_parser/
└── [LeadSourceName].php                    # Main parser class

apps/richdesk/tests/cases/analysis/
└── [LeadSourceName]Test.php               # PHPUnit tests

apps/richdesk/models/
└── LeadEmail.php                          # Parser registration

test-lead-emails/emails/
└── [LeadSourceName]/
    ├── standard-sample.txt                # Standard format
    ├── minimal-fields.txt                 # Minimal data
    ├── html-format.txt                    # HTML variant
    └── parsed/
        ├── standard-sample.json           # Expected output
        ├── minimal-fields.json            # Expected output
        └── html-format.json               # Expected output
```

## Essential Parser Methods

### Required Methods
```php
public function recognize(array $email): bool           // Email recognition
protected function _parseEmailBody(array $email): array // Email parsing
```

### Common Helper Methods
```php
$this->html2text2($html)                              // HTML to text
$this->_mergeLeadMetadata($email, $result)            // LeadMetadata.org
$this->_normalizeSpaces($text)                        // Whitespace cleanup
\richdesk\Text::parseName($name)                      // Name parsing
```

### Pattern Constants
```php
self::EMAIL                                           // Email pattern
self::PHONE                                           // Phone pattern
self::PHONE_ONE_LINE                                  // Single line phone
self::PRICE                                           // Price pattern
```

## Validation Checklists

### Pre-Deployment
- [ ] Parser class extends EmailParser
- [ ] Required methods implemented
- [ ] Parser registered in LeadEmail.php
- [ ] All tests pass on remote server
- [ ] Coverage >80% for parser methods
- [ ] No new Psalm baseline entries
- [ ] PII properly scrubbed from samples

### Post-Deployment
- [ ] No errors in Datadog logs
- [ ] Correct lead attribution in FUB UI
- [ ] Success rate >95%
- [ ] Monitoring alerts configured
- [ ] Sample emails in parsed directory
- [ ] Integration tests passing