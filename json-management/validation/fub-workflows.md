# FUB Development Workflows with JSON Validation

Practical JSON validation workflows integrated with FUB development patterns, frontend development, and API testing.

## Frontend Package.json Validation Workflows

### Daily Frontend Development

**Validate package.json during frontend development:**
```bash
# Quick validation of FUB frontend dependencies
jsonlint apps/richdesk/frontend/package.json

# Check for required frontend dependencies
jq 'has("dependencies") and has("devDependencies") and has("scripts")' apps/richdesk/frontend/package.json

# Validate build scripts are present
jq '.scripts | has("build") and has("test") and has("dev")' apps/richdesk/frontend/package.json
```

**Frontend dependency management workflow:**
```bash
# Validate after adding new dependencies
npm install --prefix apps/richdesk/frontend <package-name>
jsonlint apps/richdesk/frontend/package.json

# Check for dependency conflicts
jq '.dependencies | to_entries[] | select(.value | contains("^") | not)' apps/richdesk/frontend/package.json
```

### FUB Frontend Build Validation

**Pre-build JSON validation:**
```bash
#!/bin/bash
# scripts/validate-frontend-build.sh

echo "🔧 FUB Frontend Build Preparation"

# 1. Validate package.json structure
if [ -f "apps/richdesk/frontend/package.json" ]; then
    echo "Validating frontend package.json..."
    jsonlint apps/richdesk/frontend/package.json || {
        echo "❌ Frontend package.json validation failed"
        exit 1
    }

    # Check for required build scripts
    jq '.scripts | has("build")' apps/richdesk/frontend/package.json > /dev/null || {
        echo "❌ Missing build script in frontend package.json"
        exit 1
    }
else
    echo "❌ Frontend package.json not found"
    exit 1
fi

# 2. Validate TypeScript config if present
if [ -f "apps/richdesk/frontend/tsconfig.json" ]; then
    jsonlint apps/richdesk/frontend/tsconfig.json
fi

echo "✅ Frontend build validation complete"
```

## API Configuration Validation Workflows

### API Configuration Management

**Validate FUB API configuration files:**
```bash
# Validate API endpoint configurations
find apps/richdesk/config -name "*api*.json" | while read api_config; do
    echo "Validating API config: $(basename "$api_config")"
    jsonlint "$api_config"

    # Check for required API configuration
    jq 'has("base_url") or has("endpoints") or has("timeout")' "$api_config" > /dev/null || {
        echo "⚠️  API config may be incomplete: $api_config"
    }
done
```

### Environment-Specific API Configuration

**Validate environment configurations:**
```bash
#!/bin/bash
# scripts/validate-api-environments.sh

echo "🌍 FUB API Environment Configuration Validation"

environments=("development" "staging" "production")

for env in "${environments[@]}"; do
    config_file="apps/richdesk/config/${env}.json"
    api_config="apps/richdesk/config/api-${env}.json"

    # Check main environment config
    if [ -f "$config_file" ]; then
        echo "Validating $env environment config..."
        jsonlint "$config_file"

        # Check for required environment keys
        jq 'has("database") or has("api") or has("cache")' "$config_file" > /dev/null || {
            echo "⚠️  Incomplete $env configuration"
        }
    fi

    # Check API-specific config
    if [ -f "$api_config" ]; then
        echo "Validating $env API config..."
        jsonlint "$api_config"
    fi
done

echo "✅ Environment configuration validation complete"
```

## Test Data Validation Workflows

### API Test Data Management

**Validate API test data files:**
```bash
# Validate FUB API test data
find apps/richdesk/tests/data -name "*.json" | while read test_file; do
    echo "Validating test data: $(basename "$test_file")"
    jsonlint "$test_file"

    # Basic structure check for API response format
    if jq -e 'has("data") and has("meta")' "$test_file" > /dev/null 2>&1; then
        echo "✓ API response format detected"
    elif jq -e 'type == "array"' "$test_file" > /dev/null 2>&1; then
        echo "✓ Array format detected"
    elif jq -e 'type == "object"' "$test_file" > /dev/null 2>&1; then
        echo "✓ Object format detected"
    fi
done
```

### Test Data Creation Workflow

**Steps for creating FUB test data:**

1. **Create test data file** following FUB API response patterns
2. **Validate structure immediately:**
   ```bash
   jsonlint apps/richdesk/tests/data/new-test-data.json
   ```
3. **Check API response format** (if applicable):
   ```bash
   jq 'has("data") and has("meta")' apps/richdesk/tests/data/api-response.json
   ```
4. **Test data loading** in test environment:
   ```bash
   cd apps/richdesk && ./console test --filter="ApiTest"
   ```

## Development Environment Integration

### Mutagen Synchronization with JSON Validation

**Validate JSON before sync:**
```bash
#!/bin/bash
# scripts/mutagen-sync-with-json-validation.sh

echo "🔄 Mutagen sync with JSON validation"

# Pre-sync validation of critical JSON files
echo "Validating critical JSON files before sync..."

# Check package.json files
find . -name "package.json" -not -path "./node_modules/*" | while read pkg; do
    jsonlint "$pkg" || {
        echo "❌ Fix JSON errors before sync: $pkg"
        exit 1
    }
done

# Check FUB configuration files
if [ -d "apps/richdesk/config" ]; then
    find apps/richdesk/config -name "*.json" | while read config; do
        jsonlint "$config" || {
            echo "❌ Fix configuration JSON before sync: $config"
            exit 1
        }
    done
fi

# Perform sync
echo "Starting Mutagen sync..."
mutagen sync flush fub-main || {
    echo "❌ Mutagen sync failed"
    exit 1
}

echo "✅ Sync completed with validated JSON"
```

### Local Development Setup

**JSON validation in FUB development environment:**

1. **Install validation tools:**
   ```bash
   brew install jq jsonlint
   npm install -g jsonlint  # Alternative installation
   ```

2. **Create development aliases:**
   ```bash
   # Add to ~/.bashrc or ~/.zshrc
   alias fub-json-check='find . -name "*.json" -not -path "./node_modules/*" | xargs jsonlint'
   alias fub-package-check='find . -name "package.json" -not -path "./node_modules/*" | xargs jsonlint'
   alias fub-config-check='find apps/richdesk/config -name "*.json" -exec jsonlint {} \;'
   ```

## Debugging JSON Issues in FUB

### Common FUB JSON Problems

**Package.json dependency issues:**
```bash
# Debug package.json syntax issues
jsonlint --format apps/richdesk/frontend/package.json

# Check for dependency format issues
jq '.dependencies | to_entries[] | select(.value | test("^[^0-9]") | not)' apps/richdesk/frontend/package.json
```

**API configuration errors:**
```bash
# Debug API config structure
jsonlint -f parsable apps/richdesk/config/api.json

# Check for missing required fields
jq 'has("base_url") and has("timeout")' apps/richdesk/config/api.json
```

### JSON Validation Error Resolution

**Step-by-step debugging process for FUB:**

1. **Identify the error:**
   ```bash
   jsonlint apps/richdesk/config/broken-config.json
   ```

2. **Common fixes for FUB patterns:**
   - **Trailing commas**: Remove trailing commas in JSON objects/arrays
   - **Unquoted keys**: Ensure all object keys are quoted
   - **Invalid escape sequences**: Fix backslash escapes in strings

3. **Verify the fix:**
   ```bash
   jsonlint apps/richdesk/config/broken-config.json
   ```

4. **Test configuration loading:**
   ```bash
   # Test if the application can load the config
   cd apps/richdesk && ./console config:validate
   ```

## Automated FUB JSON Workflow Scripts

### Daily Development Validation

**Complete daily JSON health check:**
```bash
#!/bin/bash
# scripts/daily-json-check.sh

echo "📊 Daily FUB JSON Health Check"

# Count and validate package.json files
package_count=$(find . -name "package.json" -not -path "./node_modules/*" | wc -l)
echo "Package.json files found: $package_count"

failed_packages=0
find . -name "package.json" -not -path "./node_modules/*" | while read pkg; do
    if ! jsonlint "$pkg" >/dev/null 2>&1; then
        echo "❌ Failed: $pkg"
        failed_packages=$((failed_packages + 1))
    fi
done

# Check FUB configuration files
config_count=$(find apps/richdesk/config -name "*.json" 2>/dev/null | wc -l || echo "0")
echo "FUB configuration files: $config_count"

if [ "$config_count" -gt 0 ]; then
    find apps/richdesk/config -name "*.json" | while read config; do
        if jsonlint "$config" >/dev/null 2>&1; then
            echo "✓ $(basename "$config")"
        else
            echo "❌ $(basename "$config")"
        fi
    done
fi

# Check test data files
test_data_count=$(find apps/richdesk/tests/data -name "*.json" 2>/dev/null | wc -l || echo "0")
echo "Test data files: $test_data_count"

echo "✅ FUB JSON health check complete"
```

### Pre-deployment JSON Validation

**Validate JSON before FUB deployment:**
```bash
#!/bin/bash
# scripts/pre-deploy-json-check.sh

echo "🚀 Pre-deployment FUB JSON validation"

errors=0

# Critical files that must be valid for deployment
critical_files=(
    "package.json"
    "apps/richdesk/frontend/package.json"
)

for file in "${critical_files[@]}"; do
    if [ -f "$file" ]; then
        echo "Validating critical file: $file"
        jsonlint "$file" || errors=$((errors + 1))
    else
        echo "⚠️  Critical file not found: $file"
    fi
done

# Configuration files
if [ -d "apps/richdesk/config" ]; then
    find apps/richdesk/config -name "*.json" | while read config; do
        jsonlint "$config" || errors=$((errors + 1))
    done
fi

if [ $errors -eq 0 ]; then
    echo "✅ All JSON files ready for deployment"
else
    echo "❌ $errors JSON files failed validation"
    exit 1
fi
```

## Performance and Quality Monitoring

### JSON Quality Monitoring for FUB

**Track JSON quality metrics:**
```bash
#!/bin/bash
# scripts/json-quality-report.sh

echo "📈 FUB JSON Quality Report"

# Package.json metrics
package_files=$(find . -name "package.json" -not -path "./node_modules/*" | wc -l)
echo "Package files: $package_files"

# Configuration file metrics
config_files=$(find apps/richdesk/config -name "*.json" 2>/dev/null | wc -l || echo "0")
echo "Configuration files: $config_files"

# Test data metrics
test_files=$(find apps/richdesk/tests/data -name "*.json" 2>/dev/null | wc -l || echo "0")
echo "Test data files: $test_files"

# Validation success rate
total_files=$((package_files + config_files + test_files))
failed_validations=0

find . -name "*.json" -not -path "./node_modules/*" | while read json_file; do
    jsonlint "$json_file" >/dev/null 2>&1 || failed_validations=$((failed_validations + 1))
done

if [ $total_files -gt 0 ]; then
    success_rate=$(( (total_files - failed_validations) * 100 / total_files ))
    echo "Validation success rate: ${success_rate}%"
fi
```

This workflow integration ensures JSON validation is seamlessly embedded in FUB's daily development processes, from frontend development to API configuration and deployment preparation.