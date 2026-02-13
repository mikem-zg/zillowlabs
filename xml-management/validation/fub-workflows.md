# FUB Development Workflows with XML

Practical XML handling workflows tailored for FUB's PHP-based development environment with minimal XML usage.

## Common FUB XML Scenarios

### Configuration File Validation

**Validate XML configuration files in FUB structure:**
```bash
# Check apps/richdesk config directory for XML files
validate_fub_xml_config() {
    local config_dir="apps/richdesk/config"

    if [ -d "$config_dir" ]; then
        echo "Checking FUB configuration XML files..."
        find "$config_dir" -name "*.xml" | while read xml_file; do
            if xmllint --noout "$xml_file" 2>/dev/null; then
                echo "✓ Valid: $(basename "$xml_file")"
            else
                echo "✗ Invalid: $(basename "$xml_file")"
                xmllint "$xml_file" 2>&1 | head -3
            fi
        done
    else
        echo "No config directory found at $config_dir"
    fi
}
```

### PHPUnit XML Configuration

**Validate and format PHPUnit configuration:**
```bash
# Check PHPUnit XML configuration files
validate_phpunit_config() {
    local test_dirs=("apps/richdesk/tests" "tests")

    for test_dir in "${test_dirs[@]}"; do
        if [ -f "$test_dir/phpunit.xml" ]; then
            echo "Validating PHPUnit configuration..."
            xmllint --noout "$test_dir/phpunit.xml" || return 1
            echo "✓ PHPUnit XML configuration is valid"

            # Format if needed
            xmllint --format "$test_dir/phpunit.xml" > "$test_dir/phpunit.xml.formatted"
            if ! diff -q "$test_dir/phpunit.xml" "$test_dir/phpunit.xml.formatted" >/dev/null; then
                echo "💡 Consider formatting: xmllint --format $test_dir/phpunit.xml"
            fi
            rm -f "$test_dir/phpunit.xml.formatted"
        fi
    done
}
```

## Integration with FUB Development Tools

### Composer and XML Dependencies

**Check for XML-related PHP packages:**
```bash
# Identify XML-related dependencies in composer.json
check_xml_dependencies() {
    if [ -f "composer.json" ]; then
        echo "Checking for XML-related PHP packages..."

        # Check for XML libraries in composer.json
        jq -r '.require // {}, .["require-dev"] // {} | to_entries[] |
               select(.key | test("xml|dom|xpath|simplexml")) |
               "\(.key): \(.value)"' composer.json

        # Check composer.lock for actually installed XML packages
        if [ -f "composer.lock" ]; then
            jq -r '.packages[]?, .["packages-dev"][]? |
                   select(.name | test("xml|dom|xpath|simplexml")) |
                   "\(.name): \(.version)"' composer.lock
        fi
    fi
}
```

### Database Export/Import Validation

**Validate XML data exports from FUB database:**
```bash
# Validate XML exports from FUB MySQL database
validate_db_export_xml() {
    local export_file="$1"

    if [ ! -f "$export_file" ]; then
        echo "Export file not found: $export_file"
        return 1
    fi

    echo "Validating database export XML..."

    # Basic XML validation
    xmllint --noout "$export_file" || return 1

    # Check for expected FUB data structure
    if xmlstarlet sel -q -t -v "//contact" "$export_file" >/dev/null 2>&1; then
        echo "✓ Contact data structure found"
        contact_count=$(xmlstarlet sel -t -v "count(//contact)" "$export_file")
        echo "  Records: $contact_count contacts"
    fi

    if xmlstarlet sel -q -t -v "//user" "$export_file" >/dev/null 2>&1; then
        echo "✓ User data structure found"
        user_count=$(xmlstarlet sel -t -v "count(//user)" "$export_file")
        echo "  Records: $user_count users"
    fi

    echo "✓ Database export XML validation complete"
}
```

## Development Workflow Integration

### Pre-commit Hooks for FUB

**XML validation in FUB pre-commit workflow:**
```bash
# Add to existing .git/hooks/pre-commit
fub_xml_precommit_check() {
    # Check staged XML files
    local staged_xml=$(git diff --cached --name-only | grep '\.xml$' || true)

    if [ -n "$staged_xml" ]; then
        echo "FUB XML pre-commit validation..."

        for xml_file in $staged_xml; do
            # Basic validation
            if ! xmllint --noout "$xml_file" 2>/dev/null; then
                echo "✗ Invalid XML: $xml_file"
                return 1
            fi

            # FUB-specific checks
            case "$xml_file" in
                */phpunit.xml)
                    echo "✓ PHPUnit config: $xml_file"
                    ;;
                apps/richdesk/config/*)
                    echo "✓ FUB config: $xml_file"
                    ;;
                *)
                    echo "✓ XML file: $xml_file"
                    ;;
            esac
        done
        echo "✓ XML files validated"
    fi

    return 0
}

# Call alongside existing psalm, composer checks
fub_xml_precommit_check || exit 1
```

### Integration with FUB Testing

**XML validation in test suite:**
```php
<?php
// apps/richdesk/tests/cases/XmlValidationTest.php

class XmlValidationTest extends \lithium\test\Unit {

    public function testConfigXmlFiles() {
        $configDir = LITHIUM_APP_PATH . '/config';

        if (is_dir($configDir)) {
            $xmlFiles = glob($configDir . '/*.xml');

            foreach ($xmlFiles as $xmlFile) {
                // Basic XML validation using PHP's DOMDocument
                $dom = new \DOMDocument();
                libxml_use_internal_errors(true);

                $this->assertTrue(
                    $dom->load($xmlFile),
                    "XML file should be valid: " . basename($xmlFile)
                );

                libxml_clear_errors();
            }
        }
    }

    public function testPhpunitXmlConfig() {
        $phpunitConfig = LITHIUM_APP_PATH . '/../tests/phpunit.xml';

        if (file_exists($phpunitConfig)) {
            $dom = new \DOMDocument();
            libxml_use_internal_errors(true);

            $this->assertTrue(
                $dom->load($phpunitConfig),
                'PHPUnit XML configuration should be valid'
            );

            // Verify essential PHPUnit structure
            $xpath = new \DOMXPath($dom);
            $testsuites = $xpath->query('//testsuite');
            $this->assertTrue(
                $testsuites->length > 0,
                'PHPUnit config should contain test suites'
            );

            libxml_clear_errors();
        }
    }
}
```

## FUB-Specific XML Processing

### Contact Data Processing

**Process contact exports in XML format:**
```bash
# Process FUB contact data from XML exports
process_contact_xml() {
    local xml_file="$1"
    local output_format="${2:-csv}"

    if [ ! -f "$xml_file" ]; then
        echo "Contact XML file not found: $xml_file"
        return 1
    fi

    # Validate XML first
    xmllint --noout "$xml_file" || return 1

    case "$output_format" in
        csv)
            echo "Converting contacts to CSV..."
            xmlstarlet sel -t -m "//contact" \
                -v "@id" -o "," \
                -v "name" -o "," \
                -v "email" -o "," \
                -v "phone" -n \
                "$xml_file" > contacts.csv
            echo "✓ Created contacts.csv"
            ;;
        json)
            echo "Converting contacts to JSON..."
            xmlstarlet sel -t -m "//contact" \
                -o '{"id":"' -v "@id" -o '","name":"' -v "name" \
                -o '","email":"' -v "email" -o '","phone":"' -v "phone" -o '"}' -n \
                "$xml_file" > contacts.json
            echo "✓ Created contacts.json"
            ;;
        *)
            echo "Unsupported format: $output_format"
            return 1
            ;;
    esac
}
```

### API Response Validation

**Validate XML API responses in FUB:**
```bash
# Validate XML responses from FUB APIs
validate_api_xml_response() {
    local response_file="$1"
    local expected_root="${2:-response}"

    if [ ! -f "$response_file" ]; then
        echo "Response file not found: $response_file"
        return 1
    fi

    # Basic XML validation
    xmllint --noout "$response_file" || return 1

    # Check response structure
    local root_element
    root_element=$(xmlstarlet sel -t -v "name(/*)" "$response_file")

    if [ "$root_element" = "$expected_root" ]; then
        echo "✓ Expected root element: $root_element"
    else
        echo "⚠️  Unexpected root element: $root_element (expected: $expected_root)"
    fi

    # Check for common FUB API patterns
    if xmlstarlet sel -q -t -v "//status" "$response_file" >/dev/null 2>&1; then
        local status
        status=$(xmlstarlet sel -t -v "//status" "$response_file")
        echo "API Status: $status"
    fi

    if xmlstarlet sel -q -t -v "//error" "$response_file" >/dev/null 2>&1; then
        local error
        error=$(xmlstarlet sel -t -v "//error" "$response_file")
        echo "⚠️  API Error: $error"
    fi

    echo "✓ API response XML validation complete"
}
```

## Datadog Integration for XML Monitoring

### XML Processing Metrics

**Monitor XML processing in FUB with Datadog:**
```bash
# Send XML processing metrics to Datadog
send_xml_metrics() {
    local operation="$1"
    local file_count="$2"
    local success_count="$3"
    local duration="$4"

    # Send metrics to Datadog via StatsD
    echo "fub.xml.$operation.files.total:$file_count|g" | nc -w 1 -u localhost 8125
    echo "fub.xml.$operation.files.success:$success_count|g" | nc -w 1 -u localhost 8125
    echo "fub.xml.$operation.duration:$duration|ms" | nc -w 1 -u localhost 8125

    # Calculate success rate
    if [ "$file_count" -gt 0 ]; then
        local success_rate=$((success_count * 100 / file_count))
        echo "fub.xml.$operation.success_rate:$success_rate|g" | nc -w 1 -u localhost 8125
    fi
}

# Example usage in XML processing scripts
xml_batch_process() {
    local start_time
    start_time=$(date +%s%3N)

    local file_count=0
    local success_count=0

    for xml_file in *.xml; do
        file_count=$((file_count + 1))

        if xmllint --noout "$xml_file" 2>/dev/null; then
            success_count=$((success_count + 1))
        fi
    done

    local end_time
    end_time=$(date +%s%3N)
    local duration=$((end_time - start_time))

    send_xml_metrics "validation" "$file_count" "$success_count" "$duration"
}
```

## Quick FUB XML Workflows

### Daily Operations

**Common XML tasks in FUB development:**
```bash
# Quick XML health check for FUB
fub_xml_health() {
    echo "=== FUB XML Health Check ==="

    # Check for XML files in FUB structure
    local xml_count
    xml_count=$(find apps/richdesk -name "*.xml" 2>/dev/null | wc -l)
    echo "XML files in apps/richdesk: $xml_count"

    if [ "$xml_count" -gt 0 ]; then
        local valid_count=0
        find apps/richdesk -name "*.xml" | while read xml_file; do
            if xmllint --noout "$xml_file" 2>/dev/null; then
                valid_count=$((valid_count + 1))
            fi
        done
        echo "Valid XML files: $valid_count/$xml_count"
    fi

    # Check PHPUnit configuration
    if [ -f "tests/phpunit.xml" ]; then
        if xmllint --noout tests/phpunit.xml 2>/dev/null; then
            echo "✓ PHPUnit configuration valid"
        else
            echo "✗ PHPUnit configuration invalid"
        fi
    fi
}

# Format XML files in FUB project
fub_xml_format() {
    echo "Formatting XML files in FUB project..."

    find . -name "*.xml" -not -path "./.git/*" -not -path "./vendor/*" | while read xml_file; do
        if xmllint --noout "$xml_file" 2>/dev/null; then
            xmllint --format "$xml_file" --output "$xml_file.tmp"
            mv "$xml_file.tmp" "$xml_file"
            echo "✓ Formatted: $(basename "$xml_file")"
        else
            echo "✗ Skipped invalid: $(basename "$xml_file")"
        fi
    done
}
```

This workflow guide focuses on realistic XML usage patterns within FUB's PHP-based development environment, avoiding over-engineering while providing practical tools for the occasional XML processing needs.