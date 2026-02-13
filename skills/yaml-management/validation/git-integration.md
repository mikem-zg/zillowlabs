# Git Integration for YAML Validation

Git hooks and workflow integration for yamllint validation in FUB development.

## Pre-commit Hook for FUB

**Essential YAML Validation Hook:**
```bash
# .git/hooks/pre-commit
#!/bin/bash

echo "🔍 Validating YAML files..."

# Get staged YAML files
yaml_files=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(yml|yaml)$')

if [ -z "$yaml_files" ]; then
    exit 0
fi

errors=0
for file in $yaml_files; do
    echo "Checking $file..."

    # FUB-specific validation rules
    case "$file" in
        apps/richdesk/tests/fixtures/*)
            # Database fixtures - relaxed validation
            yamllint -d '{extends: relaxed, rules: {key-duplicates: {}}}' "$file" || errors=$((errors + 1))
            ;;
        apps/richdesk/config/bootstrap/*)
            # Application config - strict validation
            yamllint -d '{extends: default, rules: {document-start: {present: true}}}' "$file" || errors=$((errors + 1))
            ;;
        docker-compose*.yml)
            # Docker files - allow long lines
            yamllint -d '{extends: default, rules: {line-length: {max: 200}}}' "$file" || errors=$((errors + 1))
            ;;
        *)
            # Default validation
            yamllint "$file" || errors=$((errors + 1))
            ;;
    esac
done

if [ $errors -gt 0 ]; then
    echo "❌ Fix YAML validation errors before committing"
    exit 1
fi

echo "✅ All YAML files validated"
```

**Installation:**
```bash
# Make executable
chmod +x .git/hooks/pre-commit

# Test with FUB fixture
git add apps/richdesk/tests/fixtures/UserTest.common.yml
git commit -m "Test"  # Triggers validation
```

## Branch Validation for FUB

**Validate YAML Changes in Current Branch:**
```bash
# scripts/validate-branch-yaml.sh
#!/bin/bash

base_branch="${1:-main}"
current_branch=$(git branch --show-current)

echo "🔍 Validating YAML changes in $current_branch vs $base_branch"

# Get changed YAML files
changed_files=$(git diff --name-only "$base_branch"..."$current_branch" | grep -E '\.(yml|yaml)$')

if [ -z "$changed_files" ]; then
    echo "No YAML files changed"
    exit 0
fi

errors=0
for file in $changed_files; do
    if [ -f "$file" ]; then
        case "$file" in
            apps/richdesk/tests/fixtures/*)
                yamllint -d relaxed "$file" || errors=$((errors + 1))
                ;;
            *)
                yamllint "$file" || errors=$((errors + 1))
                ;;
        esac
    fi
done

if [ $errors -gt 0 ]; then
    echo "❌ $errors files failed validation"
    exit 1
else
    echo "✅ All changed YAML files validated"
fi
```

## FUB Fixture Validation Workflow

**Post-merge Fixture Check:**
```bash
# .git/hooks/post-merge
#!/bin/bash

# Check if fixture files were updated
fixture_files=$(git diff-tree -r --name-only --no-commit-id ORIG_HEAD HEAD | grep 'tests/fixtures/.*\.yml$')

if [ -n "$fixture_files" ]; then
    echo "🔄 Validating updated fixtures..."

    for file in $fixture_files; do
        if [ -f "$file" ]; then
            yamllint -d '{rules: {key-duplicates: {}}}' "$file" || {
                echo "⚠️  Fixture warning: $file may have duplicate keys"
            }
        fi
    done
fi
```

## Daily FUB Validation Commands

**Quick YAML Health Check:**
```bash
# Validate all FUB test fixtures
yamllint apps/richdesk/tests/fixtures/*.yml

# Check for fixture key duplicates (critical errors)
find apps/richdesk/tests/fixtures -name "*.yml" -exec yamllint -d '{rules: {key-duplicates: {}}}' {} \;

# Validate PHPUnit configuration
yamllint phpunit.yml
```

**Before Push Validation:**
```bash
# scripts/pre-push-yaml-check.sh
#!/bin/bash

echo "🚀 Pre-push YAML validation"

# Validate all staged and modified YAML
git diff --name-only HEAD | grep -E '\.(yml|yaml)$' | while read file; do
    if [ -f "$file" ]; then
        yamllint "$file" || exit 1
    fi
done

echo "✅ Ready to push"
```

## Git Aliases for FUB YAML Workflow

**Useful Git Aliases:**
```bash
# Add to ~/.gitconfig or run these commands
git config alias.yaml-check '!find . -name "*.yml" -o -name "*.yaml" | xargs yamllint'
git config alias.fixture-check '!yamllint apps/richdesk/tests/fixtures/*.yml'
git config alias.yaml-staged '!git diff --cached --name-only | grep -E "\.(yml|yaml)$" | xargs yamllint'

# Usage examples:
git yaml-check        # Validate all YAML files
git fixture-check     # Validate FUB fixtures only
git yaml-staged       # Validate staged YAML files
```

## Integration with FUB Development Workflow

**Combined Validation Script:**
```bash
# scripts/fub-yaml-validate.sh
#!/bin/bash

echo "🔍 FUB YAML Validation Suite"

# 1. Test fixtures
echo "Checking database fixtures..."
find apps/richdesk/tests/fixtures -name "*.yml" | head -10 | while read fixture; do
    yamllint -d relaxed "$fixture" && echo "✓ $(basename "$fixture")"
done

# 2. Application configuration
if [ -d "apps/richdesk/config/bootstrap" ]; then
    echo "Checking app configuration..."
    yamllint apps/richdesk/config/bootstrap/*.yml
fi

# 3. Docker configuration
if ls docker-compose*.yml 1> /dev/null 2>&1; then
    echo "Checking Docker configuration..."
    yamllint docker-compose*.yml
fi

echo "✅ FUB YAML validation complete"
```

This focused Git integration provides practical hooks and workflows specifically for FUB's YAML validation needs without overwhelming complexity.