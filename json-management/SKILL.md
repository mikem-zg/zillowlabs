---
name: json-management
description: Comprehensive JSON file validation, processing, and manipulation using jq, jsonlint, and JSON Schema tools
---

## Overview

Comprehensive JSON file validation, processing, and manipulation using jq, jsonlint, and JSON Schema tools. Provides syntax checking, data extraction, transformation, format conversion, intelligent diffing, and schema validation using industry-standard tools for robust JSON operations across development and data processing workflows.

## Usage

```bash
/json-management --operation=<op_type> --file_path=<path> [--query=<jq_query>] [--output_format=<format>] [--schema_file=<schema_path>] [--strict=<bool>] [--in_place=<bool>]
```

# JSON Management

## Examples

```bash
# Validate JSON files with syntax and schema checking
/json-management --operation="validate" --file_path="package.json" --strict=true

# Extract specific data from API response JSON
/json-management --operation="query" --file_path="api-response.json" --query=".data[].name"

# Transform JSON to YAML format
/json-management --operation="transform" --file_path="config.json" --output_format="yaml"

# Compare two JSON configuration files
/json-management --operation="diff" --file_path="old-config.json,new-config.json"

# Validate JSON against schema
/json-management --operation="schema" --file_path="data.json" --schema_file="schema.json"

# Format and prettify JSON file in place
/json-management --operation="format" --file_path="messy-data.json" --in_place=true

# Process API test data with jq filtering
/json-management --operation="query" --file_path="test-data.json" --query='.users[] | select(.active == true)'
```

## Core Workflow

### Essential Operations (Most Common - 90% of Usage)

**1. JSON Validation and Formatting**
```bash
# Basic JSON syntax validation
json-management --operation="validate" --file_path="package.json"

# Strict validation with formatting checks
json-management --operation="validate" --file_path="config.json" --strict=true

# Schema validation for API data
json-management --operation="schema" --file_path="api-response.json" --schema_file="response-schema.json"
```

**2. Data Extraction and Querying**
```bash
# Extract specific values from JSON
json-management --operation="query" --file_path="api-data.json" --query=".results[].id"

# Filter and transform API responses
json-management --operation="query" --file_path="users.json" --query='.[] | select(.role == "admin") | .email'

# Extract configuration values
json-management --operation="query" --file_path="package.json" --query='.dependencies | keys[]'
```

**3. Format Conversion and Transformation**
```bash
# Convert JSON to YAML
json-management --operation="transform" --file_path="config.json" --output_format="yaml"

# Pretty format JSON files
json-management --operation="format" --file_path="minified.json" --in_place=true

# Convert API response to CSV
json-management --operation="transform" --file_path="users.json" --output_format="csv"
```

### Tool Installation

**Install Required Tools via Homebrew:**
```bash
# Install all JSON management tools
brew install jq jsonlint ajv-cli homeport/tap/dyff

# Verify installation
jq --version && jsonlint --version && ajv --version && dyff version
```

### Preconditions

- **Tools Available**: jq, jsonlint, and ajv-cli must be installed via Homebrew/npm
- **File Access**: Must have read access to target JSON files
- **Write Permissions**: Required for in-place modifications (`--in_place=true`)
- **Valid JSON**: Source files should be syntactically valid JSON for processing operations
- **Schema Files**: JSON Schema files must be valid for schema validation operations
- **Output Directory**: Must exist for file output operations

## Quick Reference

### Tool Commands Summary

| Tool | Purpose | Key Commands |
|------|---------| -------------|
| **jq** | Processing & Querying | `jq '.path' file.json`, `jq -r '.[] | .name'`, `jq 'select(.active)'` |
| **jsonlint** | Validation & Formatting | `jsonlint file.json`, `jsonlint --format file.json` |
| **ajv-cli** | Schema Validation | `ajv validate -s schema.json -d data.json` |
| **dyff** | Intelligent Diffing | `dyff between old.json new.json`, `dyff yaml file.json` |

### Common jq Patterns

```bash
# Basic data extraction
jq '.name' config.json                           # Get single value
jq '.users[]' users.json                         # List array items
jq '.users[] | select(.active == true)' users.json # Filter with conditions

# Data transformation
jq '.users[] | {name: .name, email: .email}' users.json    # Transform structure
jq 'keys' config.json                                       # Get all keys
jq '.users |= map(select(.active))' users.json             # Update arrays

# Format conversion
jq -r '.users[] | [.name, .email] | @csv' users.json      # JSON to CSV
jq -Y . config.json                                        # JSON to YAML (if supported)
```

### Common Issues and Solutions

| Issue | Solution |
|-------|----------|
| **jq not found** | Install: `brew install jq` |
| **Invalid JSON syntax** | Run: `jsonlint file.json` for detailed errors |
| **Schema validation fails** | Use: `ajv validate -s schema.json -d data.json` |
| **Permission denied** | Check file permissions: `ls -la file.json` |
| **Complex query failures** | Test step by step: `jq '.path'` then `jq '.path | .subpath'` |

### FUB Integration Examples

```bash
# Validate package.json files
jsonlint package.json

# Extract API endpoint configurations
jq '.api.endpoints[]' apps/richdesk/config/api.json

# Process test data for API tests
jq '.testUsers[] | select(.role == "admin")' apps/richdesk/tests/data/users.json

# Compare configuration between environments
dyff between config/development.json config/production.json
```

## Advanced Patterns

For comprehensive documentation on advanced usage:

- **[Validation Documentation](./validation/)** - jsonlint configuration, schema validation, and advanced validation workflows
- **[Processing Documentation](./processing.md)** - Complex jq operations, transformations, and automation
- **[Diffing Documentation](./diffing.md)** - JSON comparison workflows and Git integration

<details>
<summary>Click to expand advanced workflow examples and automation patterns</summary>

### Multi-Tool Validation Pipeline
```bash
# Comprehensive JSON validation workflow
validate_json_comprehensive() {
    local file_path="$1"
    local schema_file="${2:-}"
    local strict_mode="${3:-false}"

    # 1. Basic syntax validation
    jsonlint "$file_path" > /dev/null || return 1

    # 2. Schema validation if schema provided
    if [ -n "$schema_file" ] && [ -f "$schema_file" ]; then
        ajv validate -s "$schema_file" -d "$file_path" || return 1
    fi

    # 3. Structure analysis
    echo "Keys: $(jq -r 'keys | join(", ")' "$file_path")"
    echo "Type: $(jq -r 'type' "$file_path")"
}
```

### API Response Processing Workflow
```bash
# Process API responses for testing
process_api_response() {
    local response_file="$1"
    local output_dir="$2"

    # Extract user data
    jq '.data.users[] | {id: .id, name: .name, email: .email}' \
        "$response_file" > "$output_dir/users.json"

    # Extract metadata
    jq '{total: .meta.total, page: .meta.page, timestamp: .meta.timestamp}' \
        "$response_file" > "$output_dir/metadata.json"

    # Validate extracted data
    jsonlint "$output_dir/users.json" && jsonlint "$output_dir/metadata.json"
}
```

### Configuration Management Workflow
```bash
# Merge and validate configuration files
merge_json_configs() {
    local base_file="$1"
    local override_file="$2"
    local output_file="$3"

    # Merge configurations using jq
    jq -s '.[0] * .[1]' "$base_file" "$override_file" > "$output_file"

    # Validate merged result
    jsonlint "$output_file"
}
```

</details>

## Integration Points

### Cross-Skill Workflow Patterns

**API Development → JSON Management:**
```bash
# Validate API response schemas
json-management --operation="schema" --file_path="api-response.json" --schema_file="user-schema.json" |
  api-development --operation="test-validation"

# Process API test data for development
json-management --operation="query" --file_path="test-users.json" --query=".[] | select(.role == \"admin\")"
```

**Database Operations → JSON Management:**
```bash
# Process database export JSON files
json-management --operation="validate" --file_path="db-export.json" --strict=true |
  database-operations --operation="import-validation"

# Transform database query results
json-management --operation="query" --file_path="query-results.json" --query=".rows[] | {id: .id, name: .name}"
```

**Configuration Management Workflows:**
```bash
# Validate and merge JSON configurations
json-management --operation="validate" --file_path="config/" --strict=true |
  json-management --operation="transform" --file_path="base.json,override.json" |
  deployment-management --operation="deploy-config"
```

**Multi-Format Conversion Workflows:**
```bash
# Complete format conversion pipeline: XML → JSON → YAML
xml-management --operation="query" --file="legacy-config.xml" --xpath="//config" |
  json-management --operation="transform" --output_format="json" |
  yaml-management --operation="transform" --output_format="yaml" |
  code-development --task="update-modern-config"

# Cross-format configuration validation
json-management --operation="validate" --file_path="config.json" --strict=true |
  yaml-management --operation="transform" --file_path="config.json" --output_format="yaml" |
  yaml-management --operation="validate" --strict=true

# Data migration with format conversion
xml-management --operation="query" --file="export.xml" --xpath="//record" |
  json-management --operation="transform" --output_format="json" |
  database-operations --operation="import-validation" --format="json"
```

### Related Skills

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| `yaml-management` | **Format Conversion** | Convert between JSON/YAML, validate cross-format configs, shared configuration management |
| `xml-management` | **Format Conversion** | Convert between JSON/XML, process legacy data formats, API payload transformation |
| `api-development` | **Response Processing** | Validate API schemas, process response data, test JSON payloads |
| `database-operations` | **Data Processing** | Process JSON exports, validate data imports, transform query results |
| `datadog-management` | **Log Processing** | Parse JSON logs, extract metrics data, validate monitoring configs |
| `code-development` | **Configuration Management** | Validate package.json, process build configs, manage dependencies |

### Refusal Conditions

The skill must refuse if:
- Required tools (jq, jsonlint, ajv-cli) are not installed or accessible
- Target JSON files are not readable due to permission restrictions
- Schema files don't exist or are malformed (for schema validation)
- In-place modification requested without write permissions
- Query expressions contain potentially unsafe operations
- File paths contain invalid characters or reference non-existent locations

When refusing, provide specific guidance:
- **Tool Installation**: `brew install jq jsonlint` or `npm install -g jsonlint ajv-cli`
- **Permission Issues**: Check with `ls -la file.json`
- **Schema Validation**: Verify schema file exists and is valid JSON Schema
- **Query Syntax**: Test with simple expressions first
- **File Access**: Verify paths exist and are accessible

## Documentation References

- **[Detailed Validation Guide](./validation/)** - Complete JSON validation workflows and schema management
- **[Processing Operations Guide](./processing.md)** - Advanced jq operations and data transformation
- **[Diffing and Comparison Guide](./diffing.md)** - JSON comparison and change detection workflows

**External Documentation:**
- jq: https://stedolan.github.io/jq/manual/ - also available via `/documentation-retrieval --library="jq" --query="manual and examples"`
- JSONLint: https://github.com/zaach/jsonlint
- AJV CLI: https://github.com/ajv-validator/ajv-cli - also available via `/documentation-retrieval --library="ajv" --query="CLI usage"`
- JSON Schema: https://json-schema.org/ - also available via `/documentation-retrieval --library="json-schema" --query="specification"`