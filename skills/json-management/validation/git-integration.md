# Git Integration for JSON Validation

Git hooks and workflow integration for JSON validation in FUB development.

## Pre-commit Hook for FUB

**Essential JSON Validation Hook:**
```bash
# .git/hooks/pre-commit
#!/bin/bash

echo "🔍 Validating JSON files..."

# Get staged JSON files
json_files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.json$')

if [ -z "$json_files" ]; then
    exit 0
fi

errors=0
for file in $json_files; do
    echo "Checking $file..."

    # FUB-specific validation rules
    case "$file" in
        package.json)
            # Package.json - validate structure and format
            jsonlint "$file" && jq 'has("name") and has("version") and has("scripts")' "$file" > /dev/null || errors=$((errors + 1))
            ;;
        apps/richdesk/config/*.json)
            # Configuration files - strict validation
            jsonlint --strict "$file" || errors=$((errors + 1))
            ;;
        apps/richdesk/tests/data/*.json)
            # Test data - validate syntax only
            jq empty "$file" || errors=$((errors + 1))
            ;;
        schemas/*.json)
            # Schema files - validate as JSON Schema
            ajv compile -s "$file" || errors=$((errors + 1))
            ;;
        *)
            # Default validation
            jsonlint "$file" || errors=$((errors + 1))
            ;;
    esac
done

if [ $errors -gt 0 ]; then
    echo "❌ Fix JSON validation errors before committing"
    exit 1
fi

echo "✅ All JSON files validated"
```

**Installation:**
```bash
# Make executable
chmod +x .git/hooks/pre-commit

# Test with FUB JSON file
git add package.json
git commit -m "Test"  # Triggers validation
```

## Branch Validation for FUB

**Validate JSON Changes in Current Branch:**
```bash
# scripts/validate-branch-json.sh
#!/bin/bash

base_branch="${1:-main}"
current_branch=$(git branch --show-current)

echo "🔍 Validating JSON changes in $current_branch vs $base_branch"

# Get changed JSON files
changed_files=$(git diff --name-only "$base_branch"..."$current_branch" | grep '\.json$')

if [ -z "$changed_files" ]; then
    echo "No JSON files changed"
    exit 0
fi

errors=0
for file in $changed_files; do
    if [ -f "$file" ]; then
        echo "Validating $file..."
        case "$file" in
            package.json)
                jsonlint "$file" && jq 'has("name") and has("version")' "$file" > /dev/null || errors=$((errors + 1))
                ;;
            apps/richdesk/config/*.json)
                jsonlint --strict "$file" || errors=$((errors + 1))
                ;;
            *)
                jsonlint "$file" || errors=$((errors + 1))
                ;;
        esac
    fi
done

if [ $errors -gt 0 ]; then
    echo "❌ $errors files failed validation"
    exit 1
else
    echo "✅ All changed JSON files validated"
fi
```

## FUB Configuration Validation Workflow

**Post-merge Configuration Check:**
```bash
# .git/hooks/post-merge
#!/bin/bash

# Check if configuration files were updated
config_files=$(git diff-tree -r --name-only --no-commit-id ORIG_HEAD HEAD | grep 'config/.*\.json$')

if [ -n "$config_files" ]; then
    echo "🔄 Validating updated JSON configuration files..."

    for file in $config_files; do
        if [ -f "$file" ]; then
            echo "Validating $file..."
            jsonlint "$file" || {
                echo "⚠️  Configuration warning: $file has JSON syntax issues"
            }

            # Check for required configuration keys
            case "$file" in
                *database*.json)
                    jq 'has("host") and has("database") and has("username")' "$file" > /dev/null || {
                        echo "⚠️  Missing required database configuration keys in $file"
                    }
                    ;;
                *api*.json)
                    jq 'has("base_url") and has("timeout")' "$file" > /dev/null || {
                        echo "⚠️  Missing required API configuration keys in $file"
                    }
                    ;;
            esac
        fi
    done
fi
```

## Daily FUB JSON Validation Commands

**Quick JSON Health Check:**
```bash
# Validate all FUB JSON files
find . -name "*.json" -not -path "./node_modules/*" | xargs jsonlint

# Check package.json files specifically
find . -name "package.json" -not -path "./node_modules/*" -exec jsonlint {} \;

# Validate configuration files
find apps/richdesk/config -name "*.json" -exec jsonlint --strict {} \;

# Check test data files
find apps/richdesk/tests/data -name "*.json" -exec jq empty {} \;
```

**Before Push Validation:**
```bash
# scripts/pre-push-json-check.sh
#!/bin/bash

echo "🚀 Pre-push JSON validation"

# Validate all staged and modified JSON
git diff --name-only HEAD | grep '\.json$' | while read file; do
    if [ -f "$file" ]; then
        echo "Validating $file..."
        jsonlint "$file" || exit 1

        # Additional checks for specific file types
        case "$file" in
            package.json)
                jq 'has("name") and has("version") and has("dependencies")' "$file" > /dev/null || {
                    echo "❌ Invalid package.json structure in $file"
                    exit 1
                }
                ;;
            schemas/*.json)
                ajv compile -s "$file" || {
                    echo "❌ Invalid JSON Schema in $file"
                    exit 1
                }
                ;;
        esac
    fi
done

echo "✅ Ready to push"
```

## Git Aliases for FUB JSON Workflow

**Useful Git Aliases:**
```bash
# Add to ~/.gitconfig or run these commands
git config alias.json-check '!find . -name "*.json" -not -path "./node_modules/*" | xargs jsonlint'
git config alias.package-check '!find . -name "package.json" -not -path "./node_modules/*" | xargs jsonlint'
git config alias.config-check '!find apps/richdesk/config -name "*.json" -exec jsonlint --strict {} \;'
git config alias.json-staged '!git diff --cached --name-only | grep "\.json$" | xargs jsonlint'

# Usage examples:
git json-check        # Validate all JSON files
git package-check     # Validate package.json files only
git config-check      # Validate FUB configuration files
git json-staged       # Validate staged JSON files
```

## Integration with FUB Development Workflow

**Combined JSON Validation Script:**
```bash
# scripts/fub-json-validate.sh
#!/bin/bash

echo "🔍 FUB JSON Validation Suite"

# 1. Package.json files
echo "Checking package.json files..."
find . -name "package.json" -not -path "./node_modules/*" | while read pkg; do
    jsonlint "$pkg" && echo "✓ $(dirname "$pkg")/package.json"
done

# 2. Configuration files
echo "Checking configuration files..."
if [ -d "apps/richdesk/config" ]; then
    find apps/richdesk/config -name "*.json" -exec jsonlint --strict {} \; | head -10
fi

# 3. Test data files
echo "Checking test data files..."
if [ -d "apps/richdesk/tests/data" ]; then
    find apps/richdesk/tests/data -name "*.json" -exec jq empty {} \; 2>/dev/null | head -5
fi

# 4. Schema files
echo "Checking schema files..."
if [ -d "schemas" ]; then
    find schemas -name "*.json" -exec ajv compile -s {} \; 2>/dev/null
fi

echo "✅ FUB JSON validation complete"
```

**Schema Validation Integration:**
```bash
# scripts/validate-json-schemas.sh
#!/bin/bash

echo "📋 FUB JSON Schema Validation"

# Validate API response data against schemas
if [ -f "schemas/api/user-response.json" ] && [ -f "apps/richdesk/tests/data/users.json" ]; then
    ajv validate -s schemas/api/user-response.json -d apps/richdesk/tests/data/users.json
fi

# Validate configuration files against schemas
find apps/richdesk/config -name "*.json" | while read config; do
    config_name=$(basename "$config" .json)
    schema_file="schemas/config/${config_name}-schema.json"

    if [ -f "$schema_file" ]; then
        echo "Validating $config against schema..."
        ajv validate -s "$schema_file" -d "$config"
    fi
done
```

This Git integration provides practical hooks and workflows specifically for JSON validation in FUB development, ensuring code quality and preventing broken configurations from being committed.