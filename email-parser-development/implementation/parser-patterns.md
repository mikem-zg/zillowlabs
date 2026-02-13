## Email Parser Implementation Following FUB Patterns

### Parser Class Structure (Must Follow FUB Conventions)

```php
<?php
/**
 * Email parser for [LeadSourceName] leads.
 * Recognizes and processes emails from [description].
 */
declare(strict_types=1);

namespace richdesk\analysis\email_parser;

use richdesk\analysis\EmailParser;

class [LeadSourceName] extends EmailParser
{
    /**
     * Recognize [LeadSourceName] emails.
     * Use subject/body content for recognition per FUB best practices.
     *
     * @param array $email
     * @return bool
     */
    public function recognize(array $email): bool
    {
        $bodyHtml = $email['body-html'] ?? '';
        $bodyPlain = $email['body-plain'] ?? '';
        $subject = $email['subject'] ?? '';

        // Recognition logic using distinctive email elements
        $hasSourceIndicator = stripos($bodyHtml, '[distinctive-text]') !== false;
        $hasSenderDomain = stripos($bodyHtml, '[sender-domain]') !== false;
        $hasSubjectPattern = stripos($subject, '[subject-pattern]') !== false;

        return $hasSourceIndicator || $hasSenderDomain || $hasSubjectPattern;
    }

    /**
     * Parse email and extract lead information.
     * Use EmailParser helper methods for efficiency and consistency.
     *
     * @param array $email
     * @return array
     */
    protected function _parseEmailBody(array $email): array
    {
        $result = [];

        // Use _mergeLeadMetadata() helper for LeadMetadata.org standard emails
        if ($this->_hasLeadMetadata($email)) {
            $result = $this->_mergeLeadMetadata($email, $result);
        } else {
            // Manual parsing for non-standard emails
            $result = $this->_parseCustomFormat($email);
        }

        // Set required FUB lead attribution fields
        $result['source'] = '[Lead Source Display Name]';  // Shows in UI
        $result['system'] = '[system-identifier]';         // Internal system name
        $result['event_type'] = 'Inquiry';                 // Standard event type

        // Add lead source tag
        $result['_tags'][] = '[Lead Source Tag]';

        // Add property information to extra_info if available
        if (!empty($result['property']['street'])) {
            $result['extra_info'] = 'Property address: ' . $result['property']['street'];
        }

        return $result;
    }

    /**
     * Parse custom email format using EmailParser helper methods.
     */
    private function _parseCustomFormat(array $email): array
    {
        $result = [];
        $bodyHtml = $email['body-html'] ?? '';
        $bodyPlain = $email['body-plain'] ?? '';

        // Use html2text2() for consistent text conversion
        $text = $this->html2text2($bodyHtml ?: $bodyPlain);

        // Use inherited parsing patterns and constants
        // EmailParser::EMAIL, EmailParser::PHONE, etc.

        // Extract contact information using _parseField() helper
        if (preg_match('/Email:\s*(' . self::EMAIL . ')/', $text, $matches)) {
            $result['email'] = trim($matches[1]);
        }

        if (preg_match('/Phone:\s*(' . self::PHONE . ')/', $text, $matches)) {
            $result['phone'] = trim($matches[1]);
        }

        // Use Text::parseName() for name extraction
        if (preg_match('/Name:\s*(.+)$/m', $text, $matches)) {
            $result += \richdesk\Text::parseName(trim($matches[1]));
        }

        return $result;
    }
}
```

### Common EmailParser Helper Methods to Use

- `html2text2()` - Convert HTML to clean text
- `_parseMeta()` - Extract HTML meta tags
- `_mergeLeadMetadata()` - Process LeadMetadata.org standard format
- `_normalizeSpaces()` - Standardize whitespace
- `_parseField()` - Extract specific fields
- `_normalizeExtraInfo()` - Process `extra_info` arrays

### Available Constants for Pattern Matching

- `EmailParser::EMAIL` - Email address pattern
- `EmailParser::PHONE` - Phone number pattern
- `EmailParser::PHONE_ONE_LINE` - Single-line phone pattern
- `EmailParser::PHONE_US_NARROW` - US phone narrow matching
- `EmailParser::PRICE` - Price pattern

## Parser Registration in FUB System

### Add Parser to LeadEmail Model

```php
// File: apps/richdesk/models/LeadEmail.php
// Add to static $parsers array in correct precedence order

protected static $parsers = [
    // ... existing parsers
    '[LeadSourceName]',  // Add before 'LeadMetadata' fallback parser
    'LeadMetadata',
    // ... remaining parsers
];
```

### Parser Precedence Considerations

- More specific parsers should come before generic ones
- Place before `'LeadMetadata'` which serves as fallback
- Consider overlap with existing parsers for same lead sources

## Lead Source Attribution Patterns

```php
// Standard attribution for most parsers
$result['source'] = 'Display Name';      // What users see
$result['system'] = 'internal-id';       // Internal identifier
$result['event_type'] = 'Inquiry';       // Standard event type
$result['_tags'][] = 'Source Tag';       // For lead tagging

// Property information handling
if (!empty($result['property']['street'])) {
    $result['extra_info'] = 'Property address: ' . $result['property']['street'];
}
```

## Recognition Pattern Best Practices

```php
public function recognize(array $email): bool
{
    $bodyHtml = $email['body-html'] ?? '';
    $bodyPlain = $email['body-plain'] ?? '';
    $subject = $email['subject'] ?? '';

    // Multiple recognition criteria for robustness
    $criteria = [
        stripos($bodyHtml, 'distinctive-text') !== false,
        stripos($bodyPlain, 'sender-domain.com') !== false,
        preg_match('/subject-pattern/i', $subject),
    ];

    return array_reduce($criteria, function($carry, $item) {
        return $carry || $item;
    }, false);
}
```