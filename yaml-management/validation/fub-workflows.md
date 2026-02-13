# FUB Development Workflows with YAML Validation

Practical YAML validation workflows integrated with FUB development patterns, testing, and deployment processes.

## Database Fixture Validation Workflows

### Daily Fixture Development

**Validate fixtures during test development:**
```bash
# Quick fixture validation while developing tests
yamllint apps/richdesk/tests/fixtures/UserTest.common.yml
yamllint apps/richdesk/tests/fixtures/ContactTest.client.yml

# Check for duplicate keys (critical for fixture loading)
yamllint -d '{rules: {key-duplicates: {}}}' apps/richdesk/tests/fixtures/UserTest.common.yml
```

**Batch validation of test fixtures:**
```bash
# Validate all fixtures for a test class
yamllint apps/richdesk/tests/fixtures/UserTest.*.yml

# Validate all fixtures in the directory (relaxed rules)
yamllint -d relaxed apps/richdesk/tests/fixtures/
```

### Fixture Creation Workflow

**Steps for creating new test fixtures:**

1. **Create fixture file** following FUB naming conventions:
   - `TestClassName.common.yml` for common database fixtures
   - `TestClassName.client.yml` for client database fixtures

2. **Validate structure immediately:**
   ```bash
   yamllint -d relaxed apps/richdesk/tests/fixtures/NewTest.common.yml
   ```

3. **Check for key duplicates** (prevents fixture loading errors):
   ```bash
   yamllint -d '{rules: {key-duplicates: {}}}' apps/richdesk/tests/fixtures/NewTest.common.yml
   ```

4. **Test fixture loading** in DatabaseTestCase:
   ```bash
   cd apps/richdesk && ./console test --filter="NewTest"
   ```

## PHPUnit Configuration Validation

### PHPUnit Workflow Integration

**Validate PHPUnit configuration before testing:**
```bash
# Validate main PHPUnit configuration
yamllint phpunit.yml

# Validate test-specific configurations
yamllint apps/richdesk/tests/phpunit.yml
```

**Common PHPUnit YAML issues in FUB:**
- Document start markers required: `---`
- Strict boolean values: `true`/`false` (not `yes`/`no`)
- No empty configuration values

## Testing Workflow with YAML Validation

### Pre-test Validation Script

**Complete testing preparation:**
```bash
#!/bin/bash
# scripts/prepare-tests.sh

echo "🧪 Preparing FUB tests with YAML validation"

# 1. Validate test fixtures
echo "Validating test fixtures..."
find apps/richdesk/tests/fixtures -name "*.yml" | while read fixture; do
    yamllint -d relaxed "$fixture" || {
        echo "❌ Fixture validation failed: $fixture"
        exit 1
    }
done

# 2. Validate PHPUnit configuration
echo "Validating PHPUnit configuration..."
yamllint phpunit.yml || {
    echo "❌ PHPUnit configuration invalid"
    exit 1
}

# 3. Check for fixture key duplicates
echo "Checking for duplicate keys in fixtures..."
find apps/richdesk/tests/fixtures -name "*.yml" -exec yamllint -d '{rules: {key-duplicates: {}}}' {} \; || {
    echo "❌ Duplicate keys found in fixtures"
    exit 1
}

echo "✅ Tests ready to run"
```

### Test Class Development Workflow

**Workflow for developing tests with fixtures:**

1. **Create test class** extending `DatabaseTestCase`

2. **Define fixture properties:**
   ```php
   protected $commonFixture = 'UserTest.common.yml';
   protected $clientFixture = 'UserTest.client.yml';
   ```

3. **Create and validate fixtures:**
   ```bash
   # Create fixture files
   touch apps/richdesk/tests/fixtures/UserTest.common.yml
   touch apps/richdesk/tests/fixtures/UserTest.client.yml

   # Validate immediately
   yamllint apps/richdesk/tests/fixtures/UserTest.*.yml
   ```

4. **Test fixture loading:**
   ```bash
   cd apps/richdesk && ./console test --filter="UserTest::testSetUp"
   ```

## Development Environment Integration

### Mutagen Synchronization with YAML Validation

**Validate YAML before sync:**
```bash
# scripts/mutagen-sync-with-validation.sh
#!/bin/bash

echo "🔄 Mutagen sync with YAML validation"

# Pre-sync validation
echo "Validating local YAML files..."
yamllint apps/richdesk/tests/fixtures/ || {
    echo "❌ Fix YAML validation errors before sync"
    exit 1
}

# Perform sync
echo "Starting Mutagen sync..."
mutagen sync flush fub-main || {
    echo "❌ Mutagen sync failed"
    exit 1
}

echo "✅ Sync completed with validated YAML"
```

### Local Development Setup

**YAML validation in development environment:**

1. **Install validation tools:**
   ```bash
   brew install yamllint yq
   ```

2. **Set up Git hooks** (see git-integration.md)

3. **Configure IDE** (see ide-integration.md)

4. **Create development aliases:**
   ```bash
   # Add to ~/.bashrc or ~/.zshrc
   alias fub-yaml-check='yamllint apps/richdesk/tests/fixtures/'
   alias fub-fixture-check='find apps/richdesk/tests/fixtures -name "*.yml" -exec yamllint -d relaxed {} \;'
   alias fub-phpunit-check='yamllint phpunit.yml'
   ```

## Debugging YAML Issues in FUB

### Common FUB YAML Problems

**Fixture loading failures:**
```bash
# Debug fixture syntax issues
yamllint -f parsable apps/richdesk/tests/fixtures/ProblemTest.common.yml

# Check for duplicate keys specifically
yamllint -d '{rules: {key-duplicates: {}}}' apps/richdesk/tests/fixtures/ProblemTest.common.yml
```

**PHPUnit configuration errors:**
```bash
# Validate PHPUnit config structure
yamllint -d '{extends: default, rules: {document-start: {present: true}}}' phpunit.yml
```

### YAML Validation Error Resolution

**Step-by-step debugging process:**

1. **Identify the error:**
   ```bash
   yamllint apps/richdesk/tests/fixtures/BrokenTest.common.yml
   ```

2. **Common fixes for FUB patterns:**
   - **Indentation**: Use 2 spaces consistently
   - **Duplicate keys**: Rename duplicate fixture entries
   - **Empty values**: Allowed in fixtures, use `null` for explicit empty
   - **Long lines**: Break long test data strings

3. **Verify the fix:**
   ```bash
   yamllint apps/richdesk/tests/fixtures/BrokenTest.common.yml
   ```

4. **Test fixture loading:**
   ```bash
   cd apps/richdesk && ./console test --filter="BrokenTest"
   ```

## Automated FUB Workflow Scripts

### Daily Development Validation

**Complete daily YAML health check:**
```bash
#!/bin/bash
# scripts/daily-yaml-check.sh

echo "📊 Daily FUB YAML Health Check"

total_fixtures=$(find apps/richdesk/tests/fixtures -name "*.yml" | wc -l)
echo "Total test fixtures: $total_fixtures"

failed_fixtures=0
echo "Validating fixtures..."
find apps/richdesk/tests/fixtures -name "*.yml" | while read fixture; do
    if ! yamllint -d relaxed "$fixture" >/dev/null 2>&1; then
        echo "❌ Failed: $(basename "$fixture")"
        failed_fixtures=$((failed_fixtures + 1))
    fi
done

if [ $failed_fixtures -eq 0 ]; then
    echo "✅ All fixtures valid"
else
    echo "⚠️  $failed_fixtures fixtures need attention"
fi

# Check PHPUnit config
if yamllint phpunit.yml >/dev/null 2>&1; then
    echo "✅ PHPUnit configuration valid"
else
    echo "❌ PHPUnit configuration needs fixes"
fi
```

### Branch Merge Preparation

**Validate YAML before merge requests:**
```bash
#!/bin/bash
# scripts/pre-merge-yaml-check.sh

echo "🔍 Pre-merge YAML validation"

# Get YAML files changed in current branch
changed_files=$(git diff main...HEAD --name-only | grep -E '\.(yml|yaml)$')

if [ -z "$changed_files" ]; then
    echo "No YAML files changed"
    exit 0
fi

echo "Changed YAML files:"
echo "$changed_files" | sed 's/^/  /'

# Validate each changed file
for file in $changed_files; do
    if [ -f "$file" ]; then
        echo "Validating $file..."
        case "$file" in
            apps/richdesk/tests/fixtures/*)
                yamllint -d relaxed "$file" || exit 1
                ;;
            *)
                yamllint "$file" || exit 1
                ;;
        esac
    fi
done

echo "✅ All changed YAML files validated"
```

## Performance and Monitoring

### YAML Quality Monitoring

**Track YAML quality over time:**
```bash
#!/bin/bash
# scripts/yaml-quality-report.sh

echo "📈 FUB YAML Quality Report"

# Count fixtures by type
common_fixtures=$(find apps/richdesk/tests/fixtures -name "*common.yml" | wc -l)
client_fixtures=$(find apps/richdesk/tests/fixtures -name "*client.yml" | wc -l)

echo "Fixture counts:"
echo "  Common fixtures: $common_fixtures"
echo "  Client fixtures: $client_fixtures"

# Validate and report issues
fixture_issues=$(find apps/richdesk/tests/fixtures -name "*.yml" -exec yamllint -f parsable {} \; 2>&1 | wc -l)
echo "  Validation issues: $fixture_issues"

# Quality score
total_fixtures=$((common_fixtures + client_fixtures))
if [ $total_fixtures -gt 0 ]; then
    quality_score=$(( (total_fixtures - fixture_issues) * 100 / total_fixtures ))
    echo "  Quality score: ${quality_score}%"
fi
```

This workflow integration ensures YAML validation is seamlessly embedded in FUB's daily development processes, from fixture creation to testing and deployment.