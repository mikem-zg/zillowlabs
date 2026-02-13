# XML Configuration and Standards for FUB Development

Basic XML validation and formatting for occasional XML files encountered in FUB development.

## Basic XML Standards

### Standard Formatting

**Apply consistent XML formatting:**
```bash
# Format XML file with standard indentation
xmllint --format file.xml > formatted.xml

# Format in-place (with backup)
cp config.xml config.xml.backup
xmllint --format config.xml --output config.xml

# Validate and format simultaneously
xmllint --format --noout config.xml && echo "Valid and formatted"
```

### Quick Validation

**Essential validation commands:**
```bash
# Basic validation
xmllint --noout file.xml

# Validation with error details
xmllint file.xml | head -10

# Batch validate XML files
for xml in *.xml; do
    if xmllint --noout "$xml" 2>/dev/null; then
        echo "✓ $xml"
    else
        echo "✗ $xml"
    fi
done
```

## XML Configuration Analysis

### Configuration File Validation

**Validate XML configuration files:**
```bash
# Check if XML configs are valid
find apps/richdesk/config -name "*.xml" | while read config_file; do
    if xmllint --noout "$config_file" 2>/dev/null; then
        echo "✓ Valid: $(basename "$config_file")"
    else
        echo "✗ Invalid: $(basename "$config_file")"
    fi
done

# Extract basic configuration info
analyze_xml_config() {
    local config_file="$1"
    if xmllint --noout "$config_file" 2>/dev/null; then
        echo "File: $(basename "$config_file")"
        echo "Root: $(xmlstarlet sel -t -v "name(/*)" "$config_file")"
        echo "Elements: $(xmlstarlet sel -t -v "count(//*)" "$config_file")"
    fi
}
```

## Schema Validation (When Needed)

### Basic Schema Usage

**Validate against XSD (if schema available):**
```bash
# Validate against schema
xmllint --schema schema.xsd data.xml --noout

# Show schema validation errors
xmllint --schema schema.xsd data.xml 2>&1 | head -5
```

## Data Processing

### XML Data Validation

**Validate XML data files:**
```bash
# Check XML data structure
validate_xml_data() {
    local xml_file="$1"

    if xmllint --noout "$xml_file" 2>/dev/null; then
        echo "✓ Valid XML: $(basename "$xml_file")"
        echo "  Root: $(xmlstarlet sel -t -v "name(/*)" "$xml_file")"
        echo "  Records: $(xmlstarlet sel -t -v "count(/*/*)" "$xml_file")"
    else
        echo "✗ Invalid XML: $(basename "$xml_file")"
    fi
}

# Check for required elements
check_xml_elements() {
    local xml_file="$1"
    shift
    local required=("$@")

    for element in "${required[@]}"; do
        if xmlstarlet sel -q -t -v "//$element" "$xml_file" >/dev/null 2>&1; then
            echo "✓ Has: $element"
        else
            echo "✗ Missing: $element"
        fi
    done
}

# Usage: check_xml_elements data.xml "user" "email" "name"
```

## Simple Maintenance

### Basic XML Maintenance

**Minimal XML maintenance workflow:**
```bash
# Format all XML files in directory
format_xml_directory() {
    local dir="${1:-.}"

    find "$dir" -name "*.xml" -type f | while read xml_file; do
        if xmllint --noout "$xml_file" 2>/dev/null; then
            xmllint --format "$xml_file" --output "${xml_file}.tmp"
            mv "${xml_file}.tmp" "$xml_file"
            echo "✓ Formatted: $(basename "$xml_file")"
        else
            echo "✗ Skipped invalid: $(basename "$xml_file")"
        fi
    done
}

# Simple XML health check
xml_health() {
    echo "=== XML Files Health Check ==="

    xml_count=$(find . -name "*.xml" | wc -l)
    echo "XML files found: $xml_count"

    if [ "$xml_count" -gt 0 ]; then
        valid=0
        for xml in $(find . -name "*.xml"); do
            if xmllint --noout "$xml" 2>/dev/null; then
                valid=$((valid + 1))
            fi
        done
        echo "Valid files: $valid/$xml_count"
    fi
}
```

This minimal guide covers the essential XML validation and formatting tools needed for occasional XML file handling in FUB development.