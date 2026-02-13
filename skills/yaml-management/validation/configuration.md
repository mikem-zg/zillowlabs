# yamllint Configuration for FUB Development

yamllint configuration guide focused on FUB's PHP backend development, database fixtures, and testing infrastructure.

## Configuration File Structure

### Basic Configuration Format
```yaml
# .yamllint.yml
extends: default
locale: en_US.UTF-8

rules:
  rule-name:
    option1: value1
    option2: value2
  another-rule: disable
  third-rule: {}  # Use default settings

ignore: |
  pattern1
  pattern2
```

### Configuration Locations
yamllint searches for configuration in this order:
1. `-c` command line option
2. `$YAMLLINT_CONFIG_FILE` environment variable
3. `.yamllint`, `.yamllint.yml`, or `.yamllint.yaml` in current directory
4. Same files in user's home directory
5. `/etc/yamllint/config`

## FUB-Specific Configuration Examples

### Standard FUB Development Configuration
```yaml
# .yamllint.yml - Optimized for FUB PHP backend development
extends: default
locale: en_US.UTF-8

rules:
  # Accommodate longer configuration lines common in PHP configs
  line-length:
    max: 120
    allow-non-breakable-words: true

  # Standard 2-space indentation matching FUB PHP standards
  indentation:
    spaces: 2
    indent-sequences: true

  # Database fixtures and config files don't need document markers
  document-start: disable
  document-end: disable

  # Allow truthy values common in FUB application configs
  truthy:
    allowed-values: [true, false, 'yes', 'no', 'on', 'off']

  # Reasonable comment formatting for configuration documentation
  comments:
    min-spaces-from-content: 1
    require-starting-space: true

  # Allow empty values in database fixtures and environment configs
  empty-values:
    forbid-in-mappings: false
    forbid-in-sequences: true

  # Controlled empty lines for readability
  empty-lines:
    max: 2
    max-start: 0
    max-end: 1

# Ignore FUB-specific non-configuration files
ignore: |
  # PHP dependencies and caches
  vendor/
  phpunit-cache/

  # Development tools
  .mutagen/

  # Generated or temporary files
  *.min.yml
  *-generated.yml

  # IDE and OS files
  .vscode/
  .DS_Store
```

### Database Fixtures Configuration
```yaml
# .yamllint-fixtures.yml - Specific for FUB database test fixtures
extends: default

rules:
  # Test fixtures may have longer lines for test data
  line-length:
    max: 150
    allow-non-breakable-words: true

  # Standard indentation for fixture files
  indentation:
    spaces: 2
    indent-sequences: true

  # Fixtures don't need document markers
  document-start: disable
  document-end: disable

  # Allow various truthy formats in test data
  truthy:
    allowed-values: [true, false, 'yes', 'no', 'on', 'off', 1, 0]

  # Allow empty values in test fixtures (common for optional fields)
  empty-values:
    forbid-in-mappings: false
    forbid-in-sequences: false

  # Don't enforce key ordering in test data for readability
  key-ordering: disable

# Apply to FUB fixture directories
ignore: |
  # Only validate actual fixture files, not generated ones
  *phpunit_database_fixture.yml  # Base fixture (can be large)
```

**Usage for FUB fixtures:**
```bash
# Validate individual test fixtures
yamllint -c .yamllint-fixtures.yml apps/richdesk/tests/fixtures/UserTest.common.yml

# Validate all test fixtures
yamllint -c .yamllint-fixtures.yml apps/richdesk/tests/fixtures/

# Quick validation of base fixture
yamllint -d relaxed apps/richdesk/resources/sql/tests/phpunit_database_fixture.yml
```

### FUB Application Configuration
```yaml
# .yamllint-config.yml - For FUB application configuration files
extends: default

rules:
  # Configuration files may have longer lines
  line-length:
    max: 120
    allow-non-breakable-words: true

  # Consistent with FUB PHP code style
  indentation:
    spaces: 2
    indent-sequences: true

  # Require document start for configuration clarity
  document-start:
    present: true
  document-end: disable

  # Standard truthy values for application configs
  truthy:
    allowed-values: [true, false]

  # Strict comment formatting for configuration documentation
  comments:
    min-spaces-from-content: 2
    require-starting-space: true

  # No empty values in production configuration
  empty-values:
    forbid-in-mappings: true
    forbid-in-sequences: true

  # Clean formatting for configuration files
  trailing-spaces: {}
  empty-lines:
    max: 1
    max-start: 0
    max-end: 0

ignore: ""  # Validate all configuration files strictly
```

**Usage for FUB configs:**
```bash
# Validate application configuration files
yamllint -c .yamllint-config.yml apps/richdesk/config/bootstrap/

# Validate specific environment configs
yamllint -c .yamllint-config.yml config/database.yml
```

### Docker Compose Configuration for FUB
```yaml
# .yamllint-docker.yml - For FUB Docker development
extends: default

rules:
  # Docker commands often require longer lines
  line-length:
    max: 200
    allow-non-breakable-words: true
    allow-non-breakable-inline-mappings: true

  # Standard Docker Compose indentation
  indentation:
    spaces: 2
    indent-sequences: true

  # Docker Compose files don't use document markers
  document-start: disable
  document-end: disable

  # Allow various truthy representations in Docker configs
  truthy:
    allowed-values: [true, false, 'yes', 'no', 'on', 'off', '1', '0']

  # Allow empty values for environment variables
  empty-values:
    forbid-in-mappings: false
    forbid-in-sequences: false

# Ignore Docker override files
ignore: |
  docker-compose.override.yml
  docker-compose.local.yml
```

**Usage:**
```bash
# Validate Docker Compose files
yamllint -c .yamllint-docker.yml docker-compose*.yml
```

## Rule Configuration for FUB Context

### Indentation Rules for FUB
```yaml
rules:
  indentation:
    spaces: 2                    # Match FUB PHP code standards
    indent-sequences: true       # Consistent list indentation
```

### Line Length for FUB Files
```yaml
rules:
  line-length:
    max: 120                     # Reasonable for configuration files
    allow-non-breakable-words: true  # Database connection strings, URLs
```

### Truthy Values for FUB Configuration
```yaml
rules:
  truthy:
    # Database fixtures and configs
    allowed-values: [true, false, 'yes', 'no', 'on', 'off']

    # Strict application configs (production)
    allowed-values: [true, false]

    # Test fixtures (flexible)
    allowed-values: [true, false, 'yes', 'no', 'on', 'off', 1, 0]
```

### Empty Values for FUB Context
```yaml
rules:
  empty-values:
    # Database fixtures - allow empty for optional test data
    forbid-in-mappings: false
    forbid-in-sequences: true

    # Application configs - no empty values in production
    forbid-in-mappings: true
    forbid-in-sequences: true
```

## FUB Workflow Integration

### Pre-commit Hook for FUB
```bash
#!/bin/bash
# .git/hooks/pre-commit - FUB YAML validation

echo "🔍 Validating YAML files..."

# Get staged YAML files
yaml_files=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(yml|yaml)$')

if [ -z "$yaml_files" ]; then
    echo "No YAML files to validate"
    exit 0
fi

errors=0

for file in $yaml_files; do
    echo "Checking $file..."

    # Choose configuration based on file location
    case "$file" in
        apps/richdesk/tests/fixtures/*)
            yamllint -c .yamllint-fixtures.yml "$file" || errors=$((errors + 1))
            ;;
        apps/richdesk/config/bootstrap/*)
            yamllint -c .yamllint-config.yml "$file" || errors=$((errors + 1))
            ;;
        docker-compose*.yml)
            yamllint -c .yamllint-docker.yml "$file" || errors=$((errors + 1))
            ;;
        *)
            yamllint "$file" || errors=$((errors + 1))
            ;;
    esac
done

if [ $errors -gt 0 ]; then
    echo "❌ $errors YAML files failed validation"
    exit 1
fi

echo "✅ All YAML files passed validation"
```

### FUB Development Validation Script
```bash
#!/bin/bash
# scripts/validate-yaml.sh - Comprehensive FUB YAML validation

echo "🔍 FUB YAML Validation"

# Database fixtures
echo "Validating database test fixtures..."
find apps/richdesk/tests/fixtures -name "*.yml" | while read -r file; do
    yamllint -c .yamllint-fixtures.yml "$file" || echo "❌ $file"
done

# Application configuration
echo "Validating application configuration..."
find apps/richdesk/config/bootstrap -name "*.yml" | while read -r file; do
    yamllint -c .yamllint-config.yml "$file" || echo "❌ $file"
done

# Base fixture (relaxed validation due to size)
echo "Validating base database fixture..."
yamllint -d relaxed apps/richdesk/resources/sql/tests/phpunit_database_fixture.yml || echo "❌ Base fixture issues"

# Docker files
if ls docker-compose*.yml 1> /dev/null 2>&1; then
    echo "Validating Docker Compose files..."
    yamllint -c .yamllint-docker.yml docker-compose*.yml || echo "❌ Docker compose issues"
fi

# PHPUnit configuration
if [ -f phpunit.yml ]; then
    echo "Validating PHPUnit configuration..."
    yamllint phpunit.yml || echo "❌ PHPUnit config issues"
fi

echo "✅ FUB YAML validation complete"
```

### Configuration Testing for FUB
```bash
# Test configurations on sample FUB files
yamllint -c .yamllint.yml --print-config > /tmp/fub-config

# Validate configuration syntax
yamllint .yamllint.yml && echo "✅ Main config valid"
yamllint .yamllint-fixtures.yml && echo "✅ Fixtures config valid"
yamllint .yamllint-config.yml && echo "✅ App config valid"

# Test on actual FUB files (if they exist)
if [ -f apps/richdesk/tests/fixtures/UserTest.common.yml ]; then
    yamllint -c .yamllint-fixtures.yml apps/richdesk/tests/fixtures/UserTest.common.yml
    echo "✅ Sample fixture validation passed"
fi
```

## Configuration Maintenance

### Update Configuration for FUB Changes
```bash
# When FUB standards change, update configurations:

# 1. Test new rules on existing files
yamllint -c .yamllint-new.yml apps/richdesk/tests/fixtures/ --format parsable | head -20

# 2. Compare configurations
diff <(yamllint -c .yamllint.yml --print-config) <(yamllint -c .yamllint-new.yml --print-config)

# 3. Validate with sample files before deployment
yamllint -c .yamllint-new.yml apps/richdesk/tests/fixtures/UserTest.common.yml
```

This configuration guide is tailored specifically for FUB's PHP backend development, database fixtures, and testing infrastructure.