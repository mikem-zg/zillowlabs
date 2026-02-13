# JSON Validation Basics

Essential JSON validation using jq, jsonlint, and ajv-cli for comprehensive syntax checking, formatting, and schema validation.

## Overview

JSON validation in FUB development involves:
- **Syntax validity** - Proper JSON structure and formatting
- **Schema compliance** - Adherence to defined JSON Schema specifications
- **Format consistency** - Standardized indentation and structure
- **Data integrity** - Type validation and required field checking

**Key Tools**: jq (syntax), jsonlint (formatting), ajv-cli (schema validation)

## Installation

### Install via Homebrew (Recommended)

```bash
# Install core JSON tools
brew install jq jsonlint

# Install ajv-cli for schema validation (requires Node.js)
npm install -g ajv-cli

# Verify installation
jq --version && jsonlint --version && ajv --version
```

### Alternative Installation Methods

```bash
# Via npm (if Node.js available)
npm install -g jsonlint ajv-cli

# Via package managers
sudo apt-get install jq  # Ubuntu/Debian
yum install jq          # CentOS/RHEL
```

## Basic Usage

### Command-Line Operations

```bash
# Validate single JSON file
jsonlint package.json

# Validate with jq (basic syntax check)
jq '.' config.json > /dev/null

# Format JSON file
jsonlint --format config.json

# Validate multiple files
jsonlint *.json

# Get help and options
jsonlint --help
jq --help
```

### Validation Options

```bash
# Strict validation with detailed output
jsonlint --verbose package.json

# Format and validate in one step
jsonlint --format --in-place messy-config.json

# Validate with custom formatting options
jsonlint --indent 2 --sort-keys config.json

# Check syntax only (no formatting)
jq empty config.json
```

### Schema Validation

```bash
# Validate against JSON Schema
ajv validate -s user-schema.json -d user-data.json

# Validate multiple data files against schema
ajv validate -s schema.json -d "data/*.json"

# Generate schema from JSON data
ajv compile -s schema.json
```

## Exit Codes and Error Handling

### Exit Code Meanings

```bash
# 0 - Valid JSON
# 1 - Invalid JSON or validation errors

# Use in scripts
if jsonlint package.json; then
    echo "✅ JSON is valid"
    exit 0
else
    echo "❌ JSON has issues (exit code: $?)"
    exit 1
fi
```

### Error Output Examples

```bash
# Syntax error output:
$ jsonlint broken.json
Error: Parse error on line 3:
...    "name": "test",
-----------------------^
Expecting 'STRING', 'NUMBER', 'NULL', 'TRUE', 'FALSE', '{', '['

# Schema validation error:
$ ajv validate -s schema.json -d data.json
data.json invalid
data/email should match format "email"
```

## Common Usage Patterns

### Quick Validation

```bash
# Basic validation for most JSON files
jsonlint *.json

# Fast syntax check with jq
find . -name "*.json" -exec jq empty {} \;

# Silent check (exit code only)
jsonlint package.json > /dev/null 2>&1 && echo "Valid" || echo "Invalid"
```

### Directory Validation

```bash
# Validate all JSON in project
find . -name "*.json" | xargs jsonlint

# Validate specific directories
jsonlint config/*.json data/*.json

# Skip certain directories
find . -name "*.json" -not -path "./node_modules/*" | xargs jsonlint
```

### Batch Processing

```bash
# Validate multiple projects
for dir in project1 project2 project3; do
    echo "Validating $dir..."
    jsonlint "$dir"/*.json
done

# Parallel processing for large projects
find . -name "*.json" | parallel jsonlint {}
```

## FUB Integration Examples

### Package.json Validation

```bash
# Validate FUB package.json files
jsonlint package.json
jsonlint apps/richdesk/frontend/package.json

# Check for required fields
jq 'has("name") and has("version") and has("dependencies")' package.json

# Validate dependency structure
jq '.dependencies | type == "object"' package.json
```

### API Response Validation

```bash
# Validate API response JSON files
jsonlint apps/richdesk/tests/data/api-responses/*.json

# Check API response structure
jq 'has("data") and has("meta") and (.data | type == "array")' api-response.json

# Validate user data structure
jq '.data[] | has("id") and has("name") and has("email")' users-response.json
```

### Configuration File Validation

```bash
# Validate FUB configuration files
jsonlint apps/richdesk/config/*.json

# Check required configuration keys
jq 'has("database") and has("api") and has("cache")' config.json

# Validate environment-specific configs
for env in development staging production; do
    jsonlint "config/${env}.json"
done
```

### Test Data Validation

```bash
# Validate test data JSON files
jsonlint apps/richdesk/tests/data/*.json

# Check test user structure
jq '.testUsers[] | has("id") and has("username") and has("email")' test-users.json

# Validate fixture data integrity
jq '.users | map(select(.id == null or .id == "")) | length == 0' test-data.json
```

## Schema Validation for FUB

### API Schema Validation

```bash
# Validate user API responses
ajv validate -s schemas/user-response.json -d test-data/users.json

# Validate configuration schemas
ajv validate -s schemas/config-schema.json -d config/production.json

# Batch validate API responses
ajv validate -s schemas/api-response.json -d "api-tests/*.json"
```

### Creating Schemas for FUB Data

**User data schema example:**
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["id", "username", "email"],
  "properties": {
    "id": {"type": "integer", "minimum": 1},
    "username": {"type": "string", "minLength": 3},
    "email": {"type": "string", "format": "email"},
    "active": {"type": "boolean", "default": true}
  }
}
```

```bash
# Validate FUB user data against schema
ajv validate -s user-schema.json -d apps/richdesk/tests/data/users.json
```

## Troubleshooting Common Issues

### Installation Issues

```bash
# Check if tools are in PATH
which jq jsonlint ajv || echo "Tools not found in PATH"

# Check Homebrew installation
brew list | grep -E "(jq|jsonlint)" || brew install jq jsonlint

# Test with version check
jq --version && jsonlint --version || echo "Installation issue detected"
```

### Permission Issues

```bash
# Check file permissions
ls -la config.json

# Make file readable
chmod 644 config.json

# Check directory permissions
ls -la config/
```

### Performance Issues

```bash
# For large JSON files, use streaming with jq
jq --stream '.' large-data.json > /dev/null

# Skip formatting for speed on large files
jq -c '.' large-config.json | jq empty

# Use file size check
file_size=$(stat -f%z config.json 2>/dev/null || stat -c%s config.json)
if [ "$file_size" -gt 1048576 ]; then  # 1MB
    echo "Large file detected, using basic validation"
    jq empty config.json
else
    jsonlint config.json
fi
```

### Common Syntax Issues

```bash
# Debug malformed JSON step by step
head -20 broken.json | jsonlint  # Check first 20 lines

# Find specific syntax errors
jq . broken.json 2>&1 | grep -E "line|column"

# Validate incrementally
jq '.users[0:10]' large-data.json  # Test subset first
```

## FUB Development Workflow Integration

### Pre-commit JSON Validation

```bash
#!/bin/bash
# Basic pre-commit JSON check

echo "🔍 Validating JSON files..."

# Get staged JSON files
json_files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.json$')

if [ -z "$json_files" ]; then
    exit 0
fi

for file in $json_files; do
    echo "Checking $file..."
    jsonlint "$file" || exit 1
done

echo "✅ All JSON files validated"
```

### Daily FUB JSON Health Check

```bash
# Quick JSON validation for common FUB files
echo "📊 FUB JSON Health Check"

# Package.json files
find . -name "package.json" -not -path "./node_modules/*" | while read pkg; do
    jsonlint "$pkg" && echo "✓ $(dirname "$pkg")/package.json"
done

# Configuration files
find apps/richdesk/config -name "*.json" | while read config; do
    jsonlint "$config" && echo "✓ $(basename "$config")"
done

# Test data files
find apps/richdesk/tests/data -name "*.json" 2>/dev/null | while read test_data; do
    jsonlint "$test_data" && echo "✓ $(basename "$test_data")"
done

echo "✅ FUB JSON validation complete"
```

This basic validation guide provides essential JSON validation tools and workflows specifically tailored for FUB's development patterns and file structures.