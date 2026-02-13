---
name: xml-management
description: Comprehensive XML validation, processing, and transformation workflows for FUB development environments using xmllint, xmlstarlet, and XML processing tools
---

# XML Management Skill

## Overview

Comprehensive XML validation, processing, and transformation workflows for FUB development environments using xmllint, xmlstarlet, and XML processing tools. Provides syntax validation, XPath querying, XSLT transformations, semantic diffing, schema validation, and formatting capabilities for XML configuration files and data processing workflows.

## Usage

```bash
/xml-management [--operation=<op>] [--file=<path>] [--xpath=<expr>] [--schema=<path>] [--format] [--validate]
```

## Parameters

- `--operation` (optional): XML operation type
  - `validate` (default): Validate XML syntax and schema
  - `query`: Extract data using XPath expressions
  - `transform`: Apply XSLT transformations
  - `diff`: Compare XML files semantically
  - `schema`: Generate or validate XML Schema (XSD)
  - `format`: Format and prettify XML files
- `--file` (optional): Target XML file path
- `--xpath` (optional): XPath expression for queries
- `--schema` (optional): XSD schema file for validation
- `--format` (optional): Apply XML formatting
- `--validate` (optional): Run validation checks only

## Examples

```bash
# Validate XML configuration files
/xml-management --operation=validate --file=apps/richdesk/config/spring-context.xml

# Query XML data with XPath
/xml-management --operation=query --file=data.xml --xpath="//user[@role='admin']"

# Apply XSLT transformation
/xml-management --operation=transform --file=input.xml --schema=transform.xsl

# Compare XML configurations
/xml-management --operation=diff --file=config-prod.xml,config-stage.xml

# Format XML for readability
/xml-management --operation=format --file=messy-config.xml

# Validate against XML Schema
/xml-management --operation=validate --file=data.xml --schema=schema.xsd
```

## Core Workflow

### 1. Tool Installation and Setup

**Install XML processing tools via Homebrew:**
```bash
# Essential XML tools for FUB development
brew install xmlstarlet libxml2 tidy-html5

# Additional tools for comprehensive XML processing
brew install saxon-he  # For XSLT 2.0/3.0 transformations
brew install xmlto     # For XML document conversion

# Verify installations
xmllint --version
xmlstarlet --version
tidy --version
```

### 2. XML Validation Workflows

**Validate FUB XML configurations:**
```bash
# Basic XML syntax validation
xmllint --noout apps/richdesk/config/database.xml

# Validate XML with DTD
xmllint --dtdvalid config.dtd apps/richdesk/config/web.xml --noout

# Validate against XML Schema (XSD)
xmllint --schema schema.xsd data.xml --noout

# Format and validate simultaneously
xmllint --format --output formatted.xml input.xml
```

### 3. XML Data Processing

**Extract data from FUB XML responses:**
```bash
# Query user data with XPath
xmlstarlet sel -t -m "//user" -v "@id" -o "," -v "name" -n users.xml

# Extract configuration values
xmlstarlet sel -t -v "//database/host" -n apps/richdesk/config/db-config.xml

# Count elements
xmlstarlet sel -t -v "count(//contact)" contacts.xml

# Transform XML structure
xmlstarlet tr transform.xsl input.xml > output.xml
```

### 4. XML Transformation and Formatting

**FUB XML processing workflows:**
```bash
# Format XML for readability
xmllint --format --output pretty.xml messy.xml

# Remove whitespace and minimize
xmlstarlet fo --omit-decl --indent-spaces 0 input.xml

# Convert XML to different formats
xmlstarlet pyx input.xml > output.pyx  # Convert to PYX format
tidy -xml -i -q input.xml > clean.xml  # Clean and format
```

## Quick Reference

### Common XML Operations for FUB

| Operation | Command | Use Case |
|-----------|---------|----------|
| **Validate** | `xmllint --noout file.xml` | Check XML syntax |
| **Format** | `xmllint --format file.xml` | Pretty-print XML |
| **Query** | `xmlstarlet sel -t -v "xpath" file.xml` | Extract data |
| **Transform** | `xmlstarlet tr style.xsl file.xml` | Apply XSLT |
| **Count** | `xmlstarlet sel -t -v "count(xpath)" file.xml` | Count elements |
| **Attribute** | `xmlstarlet sel -t -v "//@attr" file.xml` | Get attributes |

### FUB XML File Patterns

**Common XML files in FUB development:**
- `apps/richdesk/config/*.xml` - Application configuration
- `web.xml` - Web application deployment descriptor (if present)
- `*.xsd` - XML Schema definitions
- `data-export.xml` - FUB data exports
- `*.xml` - Occasional configuration or data files

### XPath Expressions for FUB Data

```bash
# User and contact queries
//user[@role='admin']                    # Admin users
//contact[status='active']               # Active contacts
//user[account/@id='123']                # Users by account
/root/users/user[position()<=5]         # First 5 users

# Configuration queries
//database/host                          # Database host
//api[@environment='production']         # Production API config
//feature[@enabled='true']/@name         # Enabled features
//connection-pool/max-connections        # Pool settings
```

## Preconditions

- **Tool Availability**: xmllint, xmlstarlet, and tidy must be installed via Homebrew
- **File Access**: Read permissions for target XML files
- **Schema Files**: XSD or DTD files available for validation (when using schema validation)
- **XSLT Stylesheets**: Available for transformation operations
- **Valid XML**: Source files should be well-formed XML (tool will report errors if not)

## Advanced Patterns

<details>
<summary>Click to expand advanced XML processing techniques and FUB-specific workflows</summary>

### Advanced XML Validation and Schema Management

**FUB XML Schema Validation Workflows:**
```bash
# Validate multiple XML files against schema
find apps/richdesk/config -name "*.xml" -exec xmllint --schema config.xsd {} --noout \;

# Generate XML Schema from sample XML (if needed for validation)
# Note: Schema generation typically requires additional tools
echo "Consider using online tools for XSD generation from XML samples"

# Validate XML with custom catalogs
xmllint --catalogs --schema schema.xsd data.xml --noout

# Batch validate FUB configuration files
for config in apps/richdesk/config/*.xml; do
    echo "Validating $(basename "$config")..."
    if xmllint --noout "$config" 2>/dev/null; then
        echo "✓ Valid XML: $config"
    else
        echo "✗ Invalid XML: $config"
    fi
done
```

### Complex XML Processing for FUB Data

**Advanced XPath and XSLT Operations:**
```bash
# Complex XPath queries for FUB data analysis
xmlstarlet sel -t -m "//user[role='admin']" \
    -v "@id" -o "," -v "username" -o "," -v "email" -n \
    users.xml

# Conditional processing with XPath
xmlstarlet sel -t -m "//contact" \
    -i "@status='active'" -v "name" -o " (Active)" -b \
    -i "@status='inactive'" -v "name" -o " (Inactive)" -b \
    -n contacts.xml

# Transform XML using XSLT 2.0 with Saxon
saxon-xslt -s:input.xml -xsl:transform.xsl -o:output.xml

# Extract nested configuration values
xmlstarlet sel -t -m "//environment[@name='production']" \
    -v "database/host" -o ":" -v "database/port" -n \
    environments.xml

# Generate reports from FUB XML data
xmlstarlet sel -t -o "User Report" -n \
    -m "//user" -o "ID: " -v "@id" -o ", Name: " -v "name" \
    -o ", Role: " -v "role" -n \
    users.xml
```

### XML Processing Pipeline Integration

**Automated XML Processing Workflows:**
```bash
# XML processing pipeline for FUB data
process_fub_xml_pipeline() {
    local input_xml="$1"
    local output_dir="${2:-processed}"

    mkdir -p "$output_dir"

    # 1. Validate XML structure
    echo "Validating $input_xml..."
    xmllint --noout "$input_xml" || return 1

    # 2. Format and clean
    echo "Formatting XML..."
    xmllint --format "$input_xml" > "$output_dir/formatted.xml"

    # 3. Extract key data
    echo "Extracting user data..."
    xmlstarlet sel -t -m "//user" \
        -v "@id" -o "," -v "username" -o "," -v "role" -n \
        "$input_xml" > "$output_dir/users.csv"

    # 4. Generate summary report
    echo "Generating summary..."
    xmlstarlet sel -t -o "Total Users: " -v "count(//user)" -n \
        -o "Admin Users: " -v "count(//user[@role='admin'])" -n \
        "$input_xml" > "$output_dir/summary.txt"

    echo "Pipeline complete. Output in $output_dir/"
}

# Batch process multiple FUB XML files
batch_process_xml() {
    local xml_dir="$1"

    find "$xml_dir" -name "*.xml" | while read xml_file; do
        echo "Processing $(basename "$xml_file")..."
        output_name=$(basename "$xml_file" .xml)
        process_fub_xml_pipeline "$xml_file" "processed/$output_name"
    done
}
```

### XML Transformation and Data Migration

**FUB Data Format Conversions:**
```bash
# Convert FUB XML to CSV format
xml_to_csv() {
    local xml_file="$1"
    local xpath="${2:-//item}"

    xmlstarlet sel -t -m "$xpath" \
        -v "@*" -o "," \
        -v "text()" -n \
        "$xml_file"
}

# Transform FUB legacy XML to modern format
transform_legacy_xml() {
    local legacy_xml="$1"
    local xslt_transform="legacy-to-modern.xsl"

    # Create XSLT transformation if it doesn't exist
    if [ ! -f "$xslt_transform" ]; then
        cat > "$xslt_transform" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/legacy-root">
        <fub-data>
            <users>
                <xsl:for-each select="user-list/user">
                    <user id="{@userid}" role="{@usertype}">
                        <username><xsl:value-of select="login-name"/></username>
                        <email><xsl:value-of select="email-addr"/></email>
                        <active><xsl:value-of select="@active = 'true'"/></active>
                    </user>
                </xsl:for-each>
            </users>
        </fub-data>
    </xsl:template>
</xsl:stylesheet>
EOF
    fi

    xmlstarlet tr "$xslt_transform" "$legacy_xml"
}

# Merge multiple FUB XML files
merge_xml_files() {
    local output_file="$1"
    shift
    local xml_files=("$@")

    {
        echo '<?xml version="1.0" encoding="UTF-8"?>'
        echo '<merged-data>'

        for xml_file in "${xml_files[@]}"; do
            echo "  <source file=\"$(basename "$xml_file")\">"
            xmlstarlet sel -t -c "/*" "$xml_file" | sed 's/^/    /'
            echo "  </source>"
        done

        echo '</merged-data>'
    } > "$output_file"
}
```

</details>

## Integration Points

### Cross-Skill Workflow Patterns

**XML Management → Other Skills:**
```bash
# XML data extraction for database operations
xml-management --operation=query --xpath="//database-config" config.xml |\
  database-operations --operation="update-config" --format="xml"

# XML validation in CI/CD pipelines
xml-management --operation=validate --file=config.xml |\
  gitlab-pipeline-monitoring --check="build-config-validation"

# Transform XML for API integration
xml-management --operation=transform --file=legacy-data.xml |\
  code-development --task="integrate-legacy-data" --format="xml"
```

### Related Skills

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| `json-management` | **Format Conversion** | Convert between XML/JSON, transform API payloads, legacy data processing |
| `yaml-management` | **Format Conversion** | Convert between XML/YAML, configuration transformation, multi-format processing |
| `database-operations` | **Configuration Management** | XML config validation, database connection strings, configuration deployment |
| `code-development` | **Configuration Management** | XML config validation, legacy system integration, configuration processing |
| `gitlab-pipeline-monitoring` | **CI/CD Integration** | Build configuration validation, XML artifact processing, pipeline configuration |
| `email-parser-development` | **Data Processing** | XML email format processing, structured data extraction, format conversion |
| `support-investigation` | **Configuration Debugging** | XML config analysis, malformed data investigation, system configuration issues |

## Refusal Conditions

This skill refuses to execute when:

- **Missing Tools**: xmllint, xmlstarlet, or tidy not installed via Homebrew
- **Invalid File Paths**: Specified XML files don't exist or aren't readable
- **Malformed XML**: Source files contain syntax errors (unless operation is format/repair)
- **Missing Schemas**: Schema validation requested but XSD/DTD files unavailable
- **Permission Issues**: Insufficient permissions to read source files or write output
- **Invalid XPath**: XPath expressions are syntactically incorrect
- **Missing XSLT**: Transformation requested but stylesheet file not found

When refusing, the skill provides:
- Specific error identification and location
- Installation commands for missing tools
- Validation suggestions for XML syntax issues
- Alternative approaches for the requested operation
- Integration guidance with other FUB development workflows

## Documentation References

**External Documentation:**
- xmllint: https://xmlsoft.org/xmllint.html - also available via `/documentation-retrieval --library="libxml2" --query="xmllint validation"`
- xmlstarlet: http://xmlstar.sourceforge.net/doc/UG/xmlstarlet-ug.html - also available via `/documentation-retrieval --library="xmlstarlet" --query="xpath and xslt"`
- XPath: https://www.w3.org/TR/xpath/ - also available via `/documentation-retrieval --library="xpath" --query="syntax and examples"`
- XSLT: https://www.w3.org/TR/xslt/ - also available via `/documentation-retrieval --library="xslt" --query="transformations"`

This skill provides comprehensive XML processing capabilities tailored for FUB development workflows, from configuration management to data transformation and validation tasks.