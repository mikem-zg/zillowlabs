# XML Validation Fundamentals for FUB Development

Essential XML validation tools and techniques for any XML processing needs in FUB development workflows.

## Tool Installation and Setup

### Install XML Processing Tools

**Install via Homebrew:**
```bash
# Core XML tools
brew install libxml2 xmlstarlet tidy-html5

# Verify installations
xmllint --version        # Part of libxml2
xmlstarlet --version
tidy --version

# Add xmllint to PATH if needed (M1 Macs)
echo 'export PATH="/opt/homebrew/opt/libxml2/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**Test basic functionality:**
```bash
# Test XML validation
echo '<test><item>Hello</item></test>' | xmllint --format -

# Test XML querying
echo '<users><user id="1">John</user></users>' | xmlstarlet sel -t -v "//user"

# Test XML formatting
echo '<root><item>test</item></root>' | tidy -xml -i -q
```

## Basic XML Validation

### Syntax Validation with xmllint

**Essential XML validation commands:**
```bash
# Validate XML syntax
xmllint --noout file.xml

# Validate with detailed output
xmllint file.xml

# Validate multiple files
xmllint --noout *.xml

# Show validation errors with line numbers
xmllint --debug file.xml | head -10
```

**Batch validation workflow:**
```bash
# Check multiple XML files
validate_xml_files() {
    local total=0
    local valid=0

    for xml_file in "$@"; do
        if [ -f "$xml_file" ]; then
            total=$((total + 1))
            echo "Checking $(basename "$xml_file")..."

            if xmllint --noout "$xml_file" 2>/dev/null; then
                echo "✓ Valid: $xml_file"
                valid=$((valid + 1))
            else
                echo "✗ Invalid: $xml_file"
                xmllint "$xml_file" 2>&1 | head -3
            fi
        fi
    done

    echo "Validation Summary: $valid/$total files are valid"
}

# Usage: validate_xml_files *.xml
```

## XML Schema and DTD Validation

### Schema-based Validation

**Validate against XML Schema (XSD):**
```bash
# Validate against schema file
xmllint --schema schema.xsd data.xml --noout

# Show validation errors
xmllint --schema schema.xsd data.xml

# Validate multiple files against same schema
for xml_file in data/*.xml; do
    echo "Validating $(basename "$xml_file")..."
    xmllint --schema schema.xsd "$xml_file" --noout
done
```

**Basic XML Schema example:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xs:element name="data">
        <xs:complexType>
            <xs:sequence>
                <xs:element name="item" maxOccurs="unbounded">
                    <xs:complexType>
                        <xs:sequence>
                            <xs:element name="name" type="xs:string"/>
                            <xs:element name="value" type="xs:string"/>
                        </xs:sequence>
                        <xs:attribute name="id" type="xs:positiveInteger" use="required"/>
                    </xs:complexType>
                </xs:element>
            </xs:sequence>
        </xs:complexType>
    </xs:element>
</xs:schema>
```

### DTD Validation

**Document Type Definition validation:**
```bash
# Validate against DTD
xmllint --dtdvalid config.dtd file.xml --noout

# Validate with internal DTD
xmllint --valid file-with-dtd.xml --noout
```

## XML Formatting and Cleanup

### Standardize XML Format

**Format and prettify XML:**
```bash
# Format with consistent indentation
xmllint --format messy.xml > formatted.xml

# Format in-place (with backup)
cp config.xml config.xml.backup
xmllint --format config.xml --output config.xml

# Custom indentation with xmlstarlet
xmlstarlet fo --indent-spaces 4 input.xml > formatted.xml

# Minimize XML (remove whitespace)
xmlstarlet fo --omit-decl --indent-spaces 0 input.xml > minimized.xml
```

**Clean problematic XML:**
```bash
# Fix common issues with tidy
tidy -xml -i -q --force-output yes problematic.xml > cleaned.xml

# Remove null bytes and control characters
tr -d '\000-\010\013\014\016-\037' < dirty.xml > clean.xml

# Verify the cleaned file is valid
xmllint --noout clean.xml && echo "✓ Cleaned XML is valid"
```

## XML Configuration Validation

### FUB Configuration File Validation

**Validate XML configuration files in FUB:**
```bash
# Basic XML configuration validation
find apps/richdesk/config -name "*.xml" -exec xmllint --noout {} \;

# Extract configuration information
extract_config_info() {
    local config_file="$1"

    if [ -f "$config_file" ] && xmllint --noout "$config_file" 2>/dev/null; then
        echo "=== XML Configuration Info ==="
        echo "File: $(basename "$config_file")"
        echo "Root element: $(xmlstarlet sel -t -v "name(/*)" "$config_file" 2>/dev/null)"
        echo "Total elements: $(xmlstarlet sel -t -v "count(//*)" "$config_file")"
        echo "Attributes: $(xmlstarlet sel -t -v "count(//@*)" "$config_file")"
    else
        echo "Invalid XML configuration: $config_file"
    fi
}

# Check for environment-specific configurations
check_config_environments() {
    local config_file="$1"
    local env_configs=$(xmlstarlet sel -t -v "count(//*[@environment])" "$config_file" 2>/dev/null || echo "0")

    if [ "$env_configs" -gt 0 ]; then
        echo "✓ Found $env_configs environment-specific configurations"
        xmlstarlet sel -t -m "//*[@environment]" \
            -v "name()" -o " [" -v "@environment" -o "]" -n "$config_file"
    else
        echo "ℹ️ No environment-specific configurations found"
    fi
}
```

## Error Handling and Debugging

### XML Validation Troubleshooting

**Debug XML validation errors:**
```bash
# Comprehensive XML health check
xml_health_check() {
    local xml_file="$1"

    echo "=== XML Health Check: $(basename "$xml_file") ==="

    # Check if file exists and is readable
    if [ ! -f "$xml_file" ]; then
        echo "✗ File not found: $xml_file"
        return 1
    fi

    if [ ! -r "$xml_file" ]; then
        echo "✗ File not readable: $xml_file"
        return 1
    fi

    # Check XML validity
    if xmllint --noout "$xml_file" 2>/dev/null; then
        echo "✓ Valid XML structure"

        # Extract basic information
        root_element=$(xmlstarlet sel -t -v "name(/*)" "$xml_file" 2>/dev/null)
        element_count=$(xmlstarlet sel -t -v "count(//*)" "$xml_file" 2>/dev/null)

        echo "Root element: $root_element"
        echo "Total elements: $element_count"

        # Check encoding
        if head -1 "$xml_file" | grep -q "encoding="; then
            encoding=$(head -1 "$xml_file" | sed -n 's/.*encoding="\([^"]*\)".*/\1/p')
            echo "Encoding: $encoding"
        fi

        return 0
    else
        echo "✗ Invalid XML structure"
        echo "Errors:"
        xmllint "$xml_file" 2>&1 | head -5
        return 1
    fi
}

# Fix common XML issues
attempt_xml_fix() {
    local xml_file="$1"
    local fixed_file="${xml_file%.xml}.fixed.xml"

    echo "Attempting to fix XML issues in $xml_file..."

    # Try tidy first
    if tidy -xml -i -q --force-output yes "$xml_file" > "$fixed_file" 2>/dev/null; then
        if xmllint --noout "$fixed_file" 2>/dev/null; then
            echo "✓ Successfully fixed XML. Output: $fixed_file"
            return 0
        fi
    fi

    # Try removing problematic characters
    tr -d '\000-\010\013\014\016-\037' < "$xml_file" > "$fixed_file"
    if xmllint --noout "$fixed_file" 2>/dev/null; then
        echo "✓ Fixed by removing control characters. Output: $fixed_file"
        return 0
    fi

    echo "✗ Unable to automatically fix XML"
    rm -f "$fixed_file"
    return 1
}
```

## Data Processing Validation

### Generic XML Data Validation

**Validate XML data exports/imports:**
```bash
# Generic data structure validation
validate_data_xml() {
    local data_file="$1"
    local expected_root="${2:-data}"

    echo "=== Data XML Validation ==="

    # Basic validation
    xmllint --noout "$data_file" || return 1

    # Check expected root element
    root=$(xmlstarlet sel -t -v "name(/*)" "$data_file")
    if [ "$root" = "$expected_root" ]; then
        echo "✓ Expected root element: $root"
    else
        echo "⚠️  Unexpected root element: $root (expected: $expected_root)"
    fi

    # Count top-level data items
    item_count=$(xmlstarlet sel -t -v "count(/*/*)" "$data_file")
    echo "Data items: $item_count"

    return 0
}

# Check for required attributes/elements
check_required_elements() {
    local xml_file="$1"
    shift
    local required_elements=("$@")

    echo "Checking required elements..."
    for element in "${required_elements[@]}"; do
        if xmlstarlet sel -q -t -v "//$element" "$xml_file" >/dev/null 2>&1; then
            echo "✓ Found: $element"
        else
            echo "✗ Missing: $element"
        fi
    done
}

# Usage examples:
# validate_data_xml "export.xml" "contacts"
# check_required_elements "users.xml" "user" "name" "email"
```

## Common Validation Workflows

### Quick Validation Commands

**Essential daily XML operations:**
```bash
# Quick syntax check
xml_check() {
    xmllint --noout "$1" && echo "✓ Valid XML" || echo "✗ Invalid XML"
}

# Format and validate
xml_format() {
    local input="$1"
    local output="${2:-${input%.xml}.formatted.xml}"

    if xmllint --noout "$input" 2>/dev/null; then
        xmllint --format "$input" > "$output"
        echo "✓ Formatted XML saved as $output"
    else
        echo "✗ Cannot format invalid XML"
        return 1
    fi
}

# Extract basic information
xml_info() {
    local xml_file="$1"

    if xmllint --noout "$xml_file" 2>/dev/null; then
        echo "File: $(basename "$xml_file")"
        echo "Size: $(stat -f%z "$xml_file" 2>/dev/null || stat -c%s "$xml_file") bytes"
        echo "Root: $(xmlstarlet sel -t -v "name(/*)" "$xml_file")"
        echo "Elements: $(xmlstarlet sel -t -v "count(//*)" "$xml_file")"
    else
        echo "Invalid XML file: $xml_file"
    fi
}

# Batch operations
xml_batch_check() {
    echo "=== Batch XML Validation ==="
    for file in "$@"; do
        printf "%-30s " "$(basename "$file"):"
        if xmllint --noout "$file" 2>/dev/null; then
            echo "✓ Valid"
        else
            echo "✗ Invalid"
        fi
    done
}
```

This guide provides essential XML validation tools and techniques that can be applied to any XML processing needs in FUB development, without making assumptions about specific XML usage patterns.