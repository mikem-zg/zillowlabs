# XML Processing and Transformation

Practical XML data processing, querying, and transformation workflows for FUB development using xmlstarlet and XSLT.

## Essential XML Processing Operations

### Basic Data Extraction with XPath

**Extract specific data from XML files:**
```bash
# Extract user information from XML data export
extract_user_data() {
    local xml_file="$1"

    if ! xmllint --noout "$xml_file" 2>/dev/null; then
        echo "Invalid XML file: $xml_file"
        return 1
    fi

    echo "=== User Data Extraction ==="

    # Extract all user names
    echo "User Names:"
    xmlstarlet sel -t -m "//user" -v "name" -n "$xml_file"

    # Extract users with email addresses
    echo "Users with Emails:"
    xmlstarlet sel -t -m "//user[email]" -v "name" -o " - " -v "email" -n "$xml_file"

    # Count users by role
    echo "User Count by Role:"
    xmlstarlet sel -t -m "//user" -v "role" -n "$xml_file" | sort | uniq -c
}

# Extract configuration values
extract_config_values() {
    local config_xml="$1"
    local xpath="${2:-//setting}"

    xmlstarlet sel -t -m "$xpath" \
        -v "@name" -o ": " -v "text()" -n \
        "$config_xml"
}
```

### Data Transformation and Format Conversion

**Convert XML to other formats:**
```bash
# Convert XML to CSV for data analysis
xml_to_csv() {
    local xml_file="$1"
    local output_file="${2:-output.csv}"

    # Basic contact export to CSV
    xmlstarlet sel -t -o "ID,Name,Email,Phone" -n \
        -m "//contact" \
        -v "@id" -o "," \
        -v "name" -o "," \
        -v "email" -o "," \
        -v "phone" -n \
        "$xml_file" > "$output_file"

    echo "✓ Converted to CSV: $output_file"
}

# Convert XML to JSON for API integration
xml_to_json() {
    local xml_file="$1"
    local output_file="${2:-output.json}"

    # Simple XML to JSON conversion
    xmlstarlet sel -t -o "{\"users\":[" \
        -m "//user" \
        -i "position()>1" -o "," -b \
        -o "{\"id\":\"" -v "@id" -o "\"," \
        -o "\"name\":\"" -v "name" -o "\"," \
        -o "\"email\":\"" -v "email" -o "\"}" \
        -b \
        -o "]}" \
        "$xml_file" > "$output_file"

    echo "✓ Converted to JSON: $output_file"
}
```

## Advanced XML Processing Workflows

### XML Data Filtering and Manipulation

**Filter and process XML data:**
```bash
# Filter XML data based on criteria
filter_xml_data() {
    local xml_file="$1"
    local filter_criteria="$2"
    local output_file="${3:-filtered.xml}"

    case "$filter_criteria" in
        "active-users")
            xmlstarlet sel -t -c "//user[@status='active']" "$xml_file" > "$output_file"
            ;;
        "recent-contacts")
            # Filter contacts created in the last 30 days
            xmlstarlet sel -t -c "//contact[created > (current-date() - xs:dayTimeDuration('P30D'))]" \
                "$xml_file" > "$output_file"
            ;;
        "admin-users")
            xmlstarlet sel -t -c "//user[role='admin']" "$xml_file" > "$output_file"
            ;;
        *)
            echo "Unknown filter criteria: $filter_criteria"
            return 1
            ;;
    esac

    echo "✓ Filtered data saved to: $output_file"
}

# Aggregate XML data
aggregate_xml_data() {
    local xml_file="$1"

    echo "=== XML Data Summary ==="

    # Count elements
    echo "Total Users: $(xmlstarlet sel -t -v "count(//user)" "$xml_file")"
    echo "Total Contacts: $(xmlstarlet sel -t -v "count(//contact)" "$xml_file")"

    # Group by categories
    echo "Users by Role:"
    xmlstarlet sel -t -m "//user" -v "role" -n "$xml_file" | \
        sort | uniq -c | while read count role; do
            echo "  $role: $count"
        done

    # Date-based analysis
    if xmlstarlet sel -q -t -v "//created" "$xml_file" >/dev/null 2>&1; then
        echo "Records by Month:"
        xmlstarlet sel -t -m "//*[created]" -v "substring(created, 1, 7)" -n "$xml_file" | \
            sort | uniq -c | while read count month; do
                echo "  $month: $count"
            done
    fi
}
```

### XSLT Transformations

**Transform XML structure using XSLT:**
```bash
# Create XSLT transformation for FUB data format
create_fub_transform() {
    local xslt_file="fub-transform.xsl"

    cat > "$xslt_file" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>

    <!-- Transform legacy user format to FUB standard -->
    <xsl:template match="/legacy-data">
        <fub-users>
            <xsl:for-each select="user-record">
                <user>
                    <xsl:attribute name="id">
                        <xsl:value-of select="user-id"/>
                    </xsl:attribute>
                    <username><xsl:value-of select="login-name"/></username>
                    <email><xsl:value-of select="email-address"/></email>
                    <role><xsl:value-of select="user-type"/></role>
                    <status>
                        <xsl:choose>
                            <xsl:when test="active='1'">active</xsl:when>
                            <xsl:otherwise>inactive</xsl:otherwise>
                        </xsl:choose>
                    </status>
                    <created><xsl:value-of select="create-date"/></created>
                </user>
            </xsl:for-each>
        </fub-users>
    </xsl:template>
</xsl:stylesheet>
EOF

    echo "✓ Created XSLT transformation: $xslt_file"
}

# Apply XSLT transformation
apply_transform() {
    local xml_file="$1"
    local xslt_file="${2:-fub-transform.xsl}"
    local output_file="${3:-transformed.xml}"

    if [ ! -f "$xslt_file" ]; then
        echo "XSLT file not found: $xslt_file"
        return 1
    fi

    xmlstarlet tr "$xslt_file" "$xml_file" > "$output_file"
    echo "✓ Transformation complete: $output_file"
}
```

## XML Processing for FUB Integration

### Database Export Processing

**Process MySQL XML exports:**
```bash
# Process XML exports from FUB database
process_db_export() {
    local export_file="$1"
    local table_name="${2:-contacts}"

    echo "Processing database export: $export_file"

    # Validate XML structure
    xmllint --noout "$export_file" || return 1

    # Extract table statistics
    echo "=== Table: $table_name ==="
    local record_count
    record_count=$(xmlstarlet sel -t -v "count(//$table_name/record)" "$export_file")
    echo "Total Records: $record_count"

    # Analyze data quality
    local empty_fields
    empty_fields=$(xmlstarlet sel -t -v "count(//$table_name/record/*[text()=''])" "$export_file")
    echo "Empty Fields: $empty_fields"

    # Extract sample records
    echo "Sample Records (first 3):"
    xmlstarlet sel -t -m "//$table_name/record[position()<=3]" \
        -o "Record " -v "position()" -o ": " \
        -v "*[1]" -o " | " -v "*[2]" -o " | " -v "*[3]" -n \
        "$export_file"
}

# Generate SQL INSERT statements from XML
xml_to_sql() {
    local xml_file="$1"
    local table_name="${2:-imported_data}"
    local output_file="${3:-insert.sql}"

    echo "-- Generated SQL from XML export" > "$output_file"
    echo "-- Table: $table_name" >> "$output_file"
    echo "" >> "$output_file"

    xmlstarlet sel -t -m "//record" \
        -o "INSERT INTO $table_name (id, name, email, created) VALUES (" \
        -v "@id" -o ", '" \
        -v "name" -o "', '" \
        -v "email" -o "', '" \
        -v "created" -o "');" -n \
        "$xml_file" >> "$output_file"

    echo "✓ SQL statements generated: $output_file"
}
```

### API Response Processing

**Process XML API responses:**
```bash
# Parse and validate FUB API responses
process_api_response() {
    local response_file="$1"

    if ! xmllint --noout "$response_file" 2>/dev/null; then
        echo "Invalid XML response: $response_file"
        return 1
    fi

    # Check response status
    local status
    if xmlstarlet sel -q -t -v "//status" "$response_file" >/dev/null 2>&1; then
        status=$(xmlstarlet sel -t -v "//status" "$response_file")
        echo "API Status: $status"

        case "$status" in
            "success")
                echo "✓ API call successful"
                ;;
            "error")
                local error_msg
                error_msg=$(xmlstarlet sel -t -v "//error-message" "$response_file")
                echo "✗ API Error: $error_msg"
                return 1
                ;;
            *)
                echo "⚠️  Unknown status: $status"
                ;;
        esac
    fi

    # Extract response data
    if xmlstarlet sel -q -t -v "//data" "$response_file" >/dev/null 2>&1; then
        echo "Response Data:"
        xmlstarlet sel -t -m "//data/*" \
            -v "name()" -o ": " -v "text()" -n \
            "$response_file"
    fi
}

# Convert XML API response to PHP array format
xml_to_php_array() {
    local xml_file="$1"
    local output_file="${2:-response.php}"

    echo "<?php" > "$output_file"
    echo "// Generated from XML response" >> "$output_file"
    echo '$response = [' >> "$output_file"

    xmlstarlet sel -t -m "//data/*" \
        -o "    '" -v "name()" -o "' => '" -v "text()" -o "'," -n \
        "$xml_file" >> "$output_file"

    echo '];' >> "$output_file"
    echo "✓ PHP array generated: $output_file"
}
```

## XML Processing Utilities

### Batch Processing Operations

**Process multiple XML files efficiently:**
```bash
# Batch process XML files in directory
batch_process_xml() {
    local input_dir="${1:-.}"
    local operation="${2:-validate}"
    local output_dir="${3:-processed}"

    mkdir -p "$output_dir"

    echo "Batch processing XML files in: $input_dir"
    echo "Operation: $operation"

    local processed=0
    local successful=0

    find "$input_dir" -name "*.xml" -type f | while read xml_file; do
        processed=$((processed + 1))
        filename=$(basename "$xml_file" .xml)

        echo "Processing: $(basename "$xml_file")"

        case "$operation" in
            "validate")
                if xmllint --noout "$xml_file" 2>/dev/null; then
                    echo "✓ Valid: $xml_file"
                    successful=$((successful + 1))
                else
                    echo "✗ Invalid: $xml_file"
                fi
                ;;
            "format")
                xmllint --format "$xml_file" > "$output_dir/${filename}.formatted.xml"
                successful=$((successful + 1))
                ;;
            "extract-data")
                xmlstarlet sel -t -m "//*[@id]" -v "@id" -o "," -v "text()" -n \
                    "$xml_file" > "$output_dir/${filename}.csv"
                successful=$((successful + 1))
                ;;
            *)
                echo "Unknown operation: $operation"
                ;;
        esac
    done

    echo "=== Batch Processing Complete ==="
    echo "Files processed: $processed"
    echo "Successful operations: $successful"
}

# XML performance analysis
analyze_xml_performance() {
    local xml_file="$1"

    echo "=== XML Performance Analysis ==="
    echo "File: $(basename "$xml_file")"
    echo "Size: $(stat -f%z "$xml_file" 2>/dev/null || stat -c%s "$xml_file") bytes"

    # Parsing time
    local start_time
    start_time=$(date +%s%3N)
    xmllint --noout "$xml_file" 2>/dev/null
    local end_time
    end_time=$(date +%s%3N)
    local parse_time=$((end_time - start_time))

    echo "Parse time: ${parse_time}ms"

    # Element count
    local element_count
    element_count=$(xmlstarlet sel -t -v "count(//*))" "$xml_file")
    echo "Total elements: $element_count"

    # Depth analysis
    local max_depth=0
    xmlstarlet sel -t -m "//*" -v "count(ancestor::*)" -n "$xml_file" | \
        while read depth; do
            if [ "$depth" -gt "$max_depth" ]; then
                max_depth="$depth"
            fi
        done
    echo "Maximum depth: $max_depth"
}
```

### Error Handling and Recovery

**Handle XML processing errors gracefully:**
```bash
# Robust XML processing with error recovery
safe_xml_process() {
    local xml_file="$1"
    local operation="$2"

    # Create temporary working file
    local temp_file
    temp_file=$(mktemp -t "xml_process.XXXXXX")
    cp "$xml_file" "$temp_file"

    # Validate before processing
    if ! xmllint --noout "$temp_file" 2>/dev/null; then
        echo "Attempting to repair XML..."

        # Try to fix with tidy
        tidy -xml -i -q --force-output yes "$xml_file" > "$temp_file" 2>/dev/null

        if ! xmllint --noout "$temp_file" 2>/dev/null; then
            echo "✗ Cannot repair XML file: $xml_file"
            rm -f "$temp_file"
            return 1
        fi

        echo "✓ XML repaired successfully"
    fi

    # Perform requested operation
    case "$operation" in
        "format")
            xmllint --format "$temp_file" > "$xml_file"
            echo "✓ XML formatted"
            ;;
        "validate")
            xmllint --noout "$temp_file"
            echo "✓ XML validation complete"
            ;;
        *)
            echo "Unknown operation: $operation"
            rm -f "$temp_file"
            return 1
            ;;
    esac

    rm -f "$temp_file"
    return 0
}
```

## Integration with FUB Data Processing

### Contact Management Processing

**Process FUB contact data in XML format:**
```bash
# FUB-specific contact processing
process_fub_contacts() {
    local contacts_xml="$1"

    echo "=== FUB Contact Processing ==="

    # Validate contact data structure
    xmllint --noout "$contacts_xml" || return 1

    # Extract contact statistics
    local total_contacts
    total_contacts=$(xmlstarlet sel -t -v "count(//contact)" "$contacts_xml")
    echo "Total Contacts: $total_contacts"

    # Active vs inactive breakdown
    local active_contacts
    active_contacts=$(xmlstarlet sel -t -v "count(//contact[@status='active'])" "$contacts_xml")
    echo "Active Contacts: $active_contacts"

    # Export for FUB database import
    xmlstarlet sel -t -o "-- FUB Contact Import SQL" -n \
        -m "//contact[@status='active']" \
        -o "INSERT INTO contacts (external_id, name, email, phone, created_at) VALUES (" \
        -v "@id" -o ", '" \
        -v "name" -o "', '" \
        -v "email" -o "', '" \
        -v "phone" -o "', '" \
        -v "created" -o "');" -n \
        "$contacts_xml" > fub_contact_import.sql

    echo "✓ FUB import SQL generated: fub_contact_import.sql"
}
```

This processing guide provides practical XML manipulation tools focused on FUB's development needs while maintaining simplicity and avoiding over-engineering of XML workflows.