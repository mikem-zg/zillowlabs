# JSON Validation Configuration for FUB Development

Configuration setup for JSON validation tools, formatting standards, and schema management in FUB development workflows.

## FUB JSON Formatting Standards

### Standard JSON Configuration

**Project-wide JSON formatting rules:**
```json
{
  "indent": 2,
  "sort_keys": false,
  "trailing_comma": false,
  "quote_style": "double",
  "line_ending": "unix"
}
```

**Apply consistent formatting:**
```bash
# Format all JSON files to FUB standards
find . -name "*.json" -not -path "./node_modules/*" -exec jsonlint --format --indent 2 {} \;

# Format specific file types
jsonlint --format --indent 2 --in-place package.json
jsonlint --format --indent 2 --in-place apps/richdesk/config/*.json
```

### Package.json Standards for FUB

**FUB package.json formatting:**
```bash
# Standard package.json validation and formatting
jsonlint --format --indent 2 --sort-keys package.json

# Validate required fields for FUB projects
jq 'has("name") and has("version") and has("scripts") and has("dependencies")' package.json
```

**FUB package.json structure validation:**
```bash
#!/bin/bash
# scripts/validate-package-json.sh

validate_fub_package() {
    local package_file="$1"

    echo "Validating FUB package.json: $package_file"

    # Basic syntax
    jsonlint "$package_file" || return 1

    # Required fields for FUB projects
    jq -e 'has("name") and has("version") and has("scripts")' "$package_file" || {
        echo "Missing required fields in $package_file"
        return 1
    }

    # FUB-specific script requirements
    jq -e '.scripts | has("test") and has("build")' "$package_file" || {
        echo "Missing required scripts in $package_file"
        return 1
    }

    echo "✅ $package_file is valid"
}

# Validate all FUB package.json files
find . -name "package.json" -not -path "./node_modules/*" | while read pkg; do
    validate_fub_package "$pkg"
done
```

## JSON Schema Configuration for FUB

### FUB API Response Schemas

**User API response schema:**
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://fub.com/schemas/user-response.json",
  "title": "FUB User API Response",
  "type": "object",
  "required": ["data", "meta"],
  "properties": {
    "data": {
      "type": "array",
      "items": {
        "$ref": "#/definitions/user"
      }
    },
    "meta": {
      "type": "object",
      "required": ["total", "page", "limit"],
      "properties": {
        "total": {"type": "integer", "minimum": 0},
        "page": {"type": "integer", "minimum": 1},
        "limit": {"type": "integer", "minimum": 1}
      }
    }
  },
  "definitions": {
    "user": {
      "type": "object",
      "required": ["id", "username", "email"],
      "properties": {
        "id": {"type": "integer", "minimum": 1},
        "username": {"type": "string", "minLength": 3, "maxLength": 50},
        "email": {"type": "string", "format": "email"},
        "active": {"type": "boolean", "default": true},
        "role": {"type": "string", "enum": ["admin", "user", "viewer"]},
        "created_at": {"type": "string", "format": "date-time"}
      }
    }
  }
}
```

**Contact API response schema:**
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://fub.com/schemas/contact-response.json",
  "title": "FUB Contact API Response",
  "type": "object",
  "required": ["data", "meta"],
  "properties": {
    "data": {
      "type": "array",
      "items": {
        "$ref": "#/definitions/contact"
      }
    },
    "meta": {"$ref": "user-response.json#/properties/meta"}
  },
  "definitions": {
    "contact": {
      "type": "object",
      "required": ["id", "name", "email", "account_id"],
      "properties": {
        "id": {"type": "integer", "minimum": 1},
        "name": {"type": "string", "minLength": 1, "maxLength": 100},
        "email": {"type": "string", "format": "email"},
        "phone": {"type": ["string", "null"], "pattern": "^\\+?[1-9]\\d{1,14}$"},
        "account_id": {"type": "integer", "minimum": 1},
        "status": {"type": "string", "enum": ["active", "inactive", "pending"]},
        "tags": {
          "type": "array",
          "items": {"type": "string"},
          "uniqueItems": true
        }
      }
    }
  }
}
```

### FUB Configuration Schemas

**Application configuration schema:**
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://fub.com/schemas/app-config.json",
  "title": "FUB Application Configuration",
  "type": "object",
  "required": ["database", "api", "cache"],
  "properties": {
    "database": {
      "type": "object",
      "required": ["host", "database", "username"],
      "properties": {
        "host": {"type": "string", "minLength": 1},
        "port": {"type": "integer", "minimum": 1, "maximum": 65535, "default": 3306},
        "database": {"type": "string", "minLength": 1},
        "username": {"type": "string", "minLength": 1},
        "password": {"type": "string"},
        "charset": {"type": "string", "default": "utf8mb4"},
        "ssl": {"type": "boolean", "default": false}
      }
    },
    "api": {
      "type": "object",
      "required": ["base_url", "timeout"],
      "properties": {
        "base_url": {"type": "string", "format": "uri"},
        "timeout": {"type": "integer", "minimum": 1, "maximum": 300},
        "rate_limit": {"type": "integer", "minimum": 1, "default": 1000},
        "version": {"type": "string", "pattern": "^v[0-9]+$", "default": "v1"}
      }
    },
    "cache": {
      "type": "object",
      "required": ["driver", "ttl"],
      "properties": {
        "driver": {"type": "string", "enum": ["redis", "memcached", "file"]},
        "ttl": {"type": "integer", "minimum": 60, "default": 3600},
        "prefix": {"type": "string", "default": "fub:"}
      }
    }
  }
}
```

## Schema Validation Setup

### Project Schema Organization

**Directory structure for FUB schemas:**
```bash
# Create schema directory structure
mkdir -p schemas/{api,config,test-data}

# Organize schemas by purpose
schemas/
├── api/
│   ├── user-response.json
│   ├── contact-response.json
│   └── error-response.json
├── config/
│   ├── app-config.json
│   ├── database-config.json
│   └── cache-config.json
└── test-data/
    ├── test-users.json
    └── test-contacts.json
```

### Automated Schema Validation

**FUB schema validation script:**
```bash
#!/bin/bash
# scripts/validate-schemas.sh

echo "🔍 FUB Schema Validation"

schema_dir="schemas"
data_dir="apps/richdesk"

# Validate API responses against schemas
echo "Validating API response data..."
if [ -f "$schema_dir/api/user-response.json" ] && [ -f "$data_dir/tests/data/api/users.json" ]; then
    ajv validate -s "$schema_dir/api/user-response.json" -d "$data_dir/tests/data/api/users.json"
fi

if [ -f "$schema_dir/api/contact-response.json" ] && [ -f "$data_dir/tests/data/api/contacts.json" ]; then
    ajv validate -s "$schema_dir/api/contact-response.json" -d "$data_dir/tests/data/api/contacts.json"
fi

# Validate configuration files
echo "Validating configuration files..."
find "$data_dir/config" -name "*.json" | while read config_file; do
    config_name=$(basename "$config_file" .json)
    schema_file="$schema_dir/config/$config_name-config.json"

    if [ -f "$schema_file" ]; then
        echo "Validating $config_file against $schema_file"
        ajv validate -s "$schema_file" -d "$config_file"
    fi
done

echo "✅ Schema validation complete"
```

## Tool Configuration Files

### JSONLint Configuration

**Project .jsonlintrc:**
```json
{
  "indent": 2,
  "sort-keys": false,
  "trailing-comma": false,
  "allow-comments": false,
  "strict": true
}
```

**FUB-specific jsonlint wrapper:**
```bash
#!/bin/bash
# scripts/fub-jsonlint.sh

# FUB JSON validation with consistent formatting
validate_fub_json() {
    local file="$1"

    # Basic validation
    jsonlint "$file" || return 1

    # FUB formatting standards
    case "$file" in
        package.json)
            jsonlint --format --indent 2 --sort-keys "$file"
            ;;
        */config/*.json)
            jsonlint --format --indent 2 "$file"
            ;;
        */tests/data/*.json)
            jsonlint --format --indent 2 "$file"
            ;;
        *)
            jsonlint --format --indent 2 "$file"
            ;;
    esac
}

# Validate file or directory
if [ -f "$1" ]; then
    validate_fub_json "$1"
elif [ -d "$1" ]; then
    find "$1" -name "*.json" | while read json_file; do
        validate_fub_json "$json_file"
    done
else
    echo "Usage: $0 <file.json|directory>"
    exit 1
fi
```

### AJV CLI Configuration

**AJV configuration for FUB:**
```json
{
  "strict": true,
  "allErrors": true,
  "verbose": true,
  "format": "full",
  "coerceTypes": false,
  "removeAdditional": false
}
```

**Automated AJV validation:**
```bash
#!/bin/bash
# scripts/ajv-validate-fub.sh

ajv_config="schemas/ajv-config.json"

# Validate with FUB-specific AJV settings
validate_with_schema() {
    local schema="$1"
    local data="$2"

    ajv validate \
        --strict=true \
        --all-errors \
        --verbose \
        -s "$schema" \
        -d "$data"
}

# Validate common FUB data types
validate_with_schema "schemas/api/user-response.json" "apps/richdesk/tests/data/api/users.json"
validate_with_schema "schemas/config/app-config.json" "apps/richdesk/config/production.json"
```

## Environment-Specific Configuration

### Development Environment

**Development JSON validation:**
```bash
# Relaxed validation for development
jsonlint --format --indent 2 config/development.json

# Allow additional properties in development schemas
ajv validate --strict=false -s schema.json -d development-data.json
```

### Production Environment

**Production JSON validation:**
```bash
# Strict validation for production
jsonlint --strict config/production.json

# Enforce strict schema compliance
ajv validate --strict=true --all-errors -s schema.json -d production-data.json

# Validate configuration completeness
jq 'has("database") and has("api") and has("cache") and has("logging")' config/production.json
```

### Testing Environment

**Test data validation:**
```bash
# Validate test data structure
ajv validate -s schemas/test-data/test-users.json -d apps/richdesk/tests/data/users.json

# Ensure test data consistency
jq '.testUsers | map(select(.id == null or .email == null)) | length == 0' test-data.json
```

## FUB Validation Workflows

### Pre-deployment Validation

**Complete pre-deployment JSON check:**
```bash
#!/bin/bash
# scripts/pre-deploy-json-validation.sh

echo "🚀 Pre-deployment JSON validation"

errors=0

# Validate all configuration files
echo "Validating configuration files..."
find apps/richdesk/config -name "*.json" | while read config; do
    jsonlint --strict "$config" || errors=$((errors + 1))
done

# Validate package.json files
echo "Validating package.json files..."
find . -name "package.json" -not -path "./node_modules/*" | while read pkg; do
    jsonlint "$pkg" || errors=$((errors + 1))
done

# Schema validation for critical data
echo "Validating against schemas..."
if [ -d "schemas" ]; then
    ajv validate -s schemas/config/app-config.json -d apps/richdesk/config/production.json || errors=$((errors + 1))
fi

if [ $errors -eq 0 ]; then
    echo "✅ All JSON validation passed"
else
    echo "❌ $errors JSON files failed validation"
    exit 1
fi
```

This configuration guide provides comprehensive JSON validation setup specifically tailored for FUB's development patterns, API standards, and deployment requirements.