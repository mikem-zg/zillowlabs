# YAML Diffing with dyff for FUB Development

Intelligent YAML and JSON comparison using dyff for FUB development workflows, including configuration drift detection and fixture analysis.

## Installation and Setup

### Install dyff via Homebrew

```bash
# Install dyff (YAML/JSON differ)
brew install homeport/tap/dyff

# Verify installation
dyff version
```

## FUB Database Fixture Comparison

### Compare Fixture Versions

**Analyze changes between fixture versions:**
```bash
# Compare fixture files between branches
dyff between \
  apps/richdesk/tests/fixtures/UserTest.common.yml \
  apps/richdesk/tests/fixtures/UserTest.common.yml.backup

# Compare common vs client fixtures structure
dyff between \
  apps/richdesk/tests/fixtures/UserTest.common.yml \
  apps/richdesk/tests/fixtures/UserTest.client.yml
```

### Git Integration for Fixture Changes

**Track fixture changes in Git:**
```bash
# Compare fixture against previous commit
git show HEAD~1:apps/richdesk/tests/fixtures/UserTest.common.yml > /tmp/old-fixture.yml
dyff between /tmp/old-fixture.yml apps/richdesk/tests/fixtures/UserTest.common.yml

# Compare fixtures between branches
git show main:apps/richdesk/tests/fixtures/UserTest.common.yml > /tmp/main-fixture.yml
dyff between /tmp/main-fixture.yml apps/richdesk/tests/fixtures/UserTest.common.yml
```

### Fixture Data Analysis

**Understand fixture differences:**
```bash
# Show only additions and deletions
dyff between --output=brief \
  old-fixtures/UserTest.common.yml \
  apps/richdesk/tests/fixtures/UserTest.common.yml

# Focus on specific table changes
dyff between --filter=".users" \
  old-fixtures/UserTest.common.yml \
  apps/richdesk/tests/fixtures/UserTest.common.yml

# Generate detailed change report
dyff between --output=human \
  old-fixtures/UserTest.common.yml \
  apps/richdesk/tests/fixtures/UserTest.common.yml > fixture-changes.txt
```

## Configuration Drift Detection

### Environment Configuration Comparison

**Compare FUB environment configurations:**
```bash
# Compare development vs staging configs
dyff between \
  apps/richdesk/config/bootstrap/development.yml \
  apps/richdesk/config/bootstrap/staging.yml

# Compare production vs development database settings
dyff between --filter=".database" \
  apps/richdesk/config/bootstrap/development.yml \
  apps/richdesk/config/bootstrap/production.yml

# Check cache configuration differences
dyff between --filter=".cache" \
  apps/richdesk/config/bootstrap/development.yml \
  apps/richdesk/config/bootstrap/production.yml
```

### Docker Compose Configuration

**Analyze Docker configuration changes:**
```bash
# Compare Docker Compose files
dyff between docker-compose.yml docker-compose.production.yml

# Focus on service-specific changes
dyff between --filter=".services.fub-web" \
  docker-compose.yml docker-compose.production.yml

# Compare environment variables
dyff between --filter=".services[].environment" \
  docker-compose.yml docker-compose.production.yml
```

## PHPUnit Configuration Analysis

### Test Configuration Comparison

**Compare PHPUnit configurations:**
```bash
# Compare PHPUnit configs between environments
dyff between phpunit.yml phpunit.production.yml

# Check test suite differences
dyff between --filter=".testsuites" \
  phpunit.yml phpunit.production.yml

# Compare coverage settings
dyff between --filter=".coverage" \
  phpunit.yml phpunit.production.yml
```

## Advanced FUB Diffing Workflows

### Multi-file Configuration Analysis

**Compare configuration sets:**
```bash
#!/bin/bash
# scripts/compare-environments.sh

echo "🔍 Comparing FUB environment configurations"

environments=("development" "staging" "production")

for env1 in "${environments[@]}"; do
    for env2 in "${environments[@]}"; do
        if [ "$env1" != "$env2" ]; then
            echo "Comparing $env1 vs $env2:"
            dyff between --output=brief \
                "apps/richdesk/config/bootstrap/$env1.yml" \
                "apps/richdesk/config/bootstrap/$env2.yml"
            echo "---"
        fi
    done
done
```

### Fixture Relationship Changes

**Analyze fixture relationship changes:**
```bash
# Compare foreign key relationships
dyff between --filter=".users[].account_id" \
  old-fixtures/UserTest.common.yml \
  apps/richdesk/tests/fixtures/UserTest.common.yml

# Check for new or removed test data
dyff between --filter=".contacts" \
  old-fixtures/ContactTest.client.yml \
  apps/richdesk/tests/fixtures/ContactTest.client.yml
```

## Git Integration for FUB

### Custom Git Diff Tool

**Configure dyff as Git diff tool:**
```bash
# Configure dyff for YAML files in Git
git config diff.yaml.textconv "dyff yaml --color off"

# Add to .gitattributes
echo "*.yml diff=yaml" >> .gitattributes
echo "*.yaml diff=yaml" >> .gitattributes

# Use dyff for specific file comparisons
git difftool --tool=dyff HEAD~1 apps/richdesk/tests/fixtures/UserTest.common.yml
```

### Pre-commit Comparison

**Compare changes before committing:**
```bash
#!/bin/bash
# scripts/pre-commit-yaml-diff.sh

echo "🔍 Reviewing YAML changes before commit"

# Get staged YAML files
staged_files=$(git diff --cached --name-only | grep -E '\.(yml|yaml)$')

for file in $staged_files; do
    if [ -f "$file" ]; then
        echo "Changes in $file:"
        git show :0:"$file" > /tmp/staged-"$(basename "$file")"
        git show HEAD:"$file" > /tmp/head-"$(basename "$file")" 2>/dev/null || echo "new file"

        if [ -f "/tmp/head-$(basename "$file")" ]; then
            dyff between --output=brief \
                "/tmp/head-$(basename "$file")" \
                "/tmp/staged-$(basename "$file")"
        else
            echo "New file: $file"
        fi
        echo "---"
    fi
done
```

## Configuration Validation with Diffing

### Deployment Configuration Verification

**Verify deployment configurations:**
```bash
#!/bin/bash
# scripts/verify-deployment-config.sh

echo "🔧 Verifying deployment configuration consistency"

# Compare current configs against known good versions
config_files=(
    "apps/richdesk/config/bootstrap/database.yml"
    "apps/richdesk/config/bootstrap/cache.yml"
    "docker-compose.production.yml"
)

for config in "${config_files[@]}"; do
    if [ -f "$config" ] && [ -f "known-good/$config" ]; then
        echo "Checking $config..."
        differences=$(dyff between --output=brief "known-good/$config" "$config" | wc -l)

        if [ $differences -eq 0 ]; then
            echo "✅ No differences in $config"
        else
            echo "⚠️  Differences found in $config"
            dyff between "known-good/$config" "$config"
        fi
    fi
done
```

### Automated Change Detection

**Monitor configuration drift:**
```bash
#!/bin/bash
# scripts/monitor-config-drift.sh

echo "📊 FUB Configuration Drift Monitoring"

# Define baseline configurations
baselines_dir="config-baselines"
current_configs=(
    "apps/richdesk/config/bootstrap/production.yml"
    "docker-compose.production.yml"
    "phpunit.yml"
)

drift_detected=0

for config in "${current_configs[@]}"; do
    baseline="$baselines_dir/$(basename "$config")"

    if [ -f "$baseline" ] && [ -f "$config" ]; then
        echo "Checking drift in $config..."

        if ! dyff between --output=brief "$baseline" "$config" > /dev/null; then
            echo "🚨 Drift detected in $config"
            dyff between "$baseline" "$config"
            drift_detected=1
        else
            echo "✅ No drift in $config"
        fi
    fi
done

if [ $drift_detected -eq 1 ]; then
    echo "⚠️  Configuration drift detected - review changes"
    exit 1
else
    echo "✅ All configurations match baselines"
fi
```

## Format Conversion and Comparison

### Cross-format Comparison

**Compare YAML and JSON versions:**
```bash
# Convert and compare YAML fixture with JSON API response
yq -o json apps/richdesk/tests/fixtures/UserTest.common.yml > /tmp/fixture.json
dyff between /tmp/fixture.json api-response.json

# Compare YAML config with JSON config
dyff between config.yml config.json

# Convert between formats for comparison
dyff yaml config.json > /tmp/config-from-json.yml
dyff between config.yml /tmp/config-from-json.yml
```

## Reporting and Integration

### Generate Change Reports

**Create detailed change documentation:**
```bash
#!/bin/bash
# scripts/generate-change-report.sh

report_file="yaml-changes-$(date +%Y%m%d).md"

{
    echo "# YAML Configuration Changes Report"
    echo "Generated on $(date)"
    echo ""

    echo "## Database Fixture Changes"
    dyff between --output=human \
        backup/fixtures/ \
        apps/richdesk/tests/fixtures/ || echo "No fixture changes"

    echo ""
    echo "## Configuration Changes"
    dyff between --output=human \
        backup/config/ \
        apps/richdesk/config/bootstrap/ || echo "No config changes"

    echo ""
    echo "## Docker Configuration Changes"
    dyff between --output=human \
        backup/docker-compose.yml \
        docker-compose.yml || echo "No Docker changes"

} > "$report_file"

echo "📄 Change report generated: $report_file"
```

### Integration with FUB Monitoring

**Send diff alerts to monitoring systems:**
```bash
# Example integration with FUB monitoring
if dyff between baseline-config.yml current-config.yml > /dev/null; then
    echo "Configuration stable"
else
    # Send alert to Datadog or other monitoring
    echo "Configuration drift detected" | logger -t fub-config-monitor
fi
```

This diffing guide provides practical workflows for comparing YAML configurations, fixtures, and deployment files in FUB development environments, helping maintain consistency and track changes effectively.