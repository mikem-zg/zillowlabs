# CI/CD Integration for YAML Validation

YAML validation integration for FUB's GitLab CI/CD pipeline using Amazon Linux 2023-based infrastructure, focused on test fixtures, configuration files, and deployment configurations.

## FUB GitLab Pipeline Integration

### YAML Validation in Existing Pipeline Structure

**Add YAML validation to existing .gitlab-ci.yml stages:**
```yaml
# Add to existing test stage jobs for YAML files
yaml-validation:
  stage: test
  image: [MASKED].dkr.ecr.[MASKED].amazonaws.com/fub-pipeline:latest
  services:
    - name: mysql:8.0
      alias: mysql
    - name: valkey/valkey:7.2-alpine
      alias: valkey
  before_script:
    - yum update -y
    - yum install -y python3 python3-pip
    - pip3 install yamllint yq
  script:
    - |
      # Validate FUB-specific YAML files
      echo "Validating YAML files in FUB project..."

      # FUB database test fixtures
      if [ -d "apps/richdesk/tests/fixtures" ]; then
        echo "Validating FUB database fixtures..."
        find apps/richdesk/tests/fixtures -name "*.yml" -o -name "*.yaml" | while read fixture; do
          echo "Validating fixture: $(basename "$fixture")"
          yamllint -d '{extends: relaxed, rules: {key-duplicates: {}}}' "$fixture" || exit 1
        done
      fi

      # FUB configuration files
      if [ -d "apps/richdesk/config" ]; then
        find apps/richdesk/config -name "*.yml" -o -name "*.yaml" | while read config; do
          echo "Validating config: $(basename "$config")"
          yamllint -d '{extends: default, rules: {line-length: {max: 200}}}' "$config" || exit 1
        done
      fi

      # PHPUnit configuration
      for phpunit_config in phpunit.yml phpunit.yaml apps/richdesk/tests/phpunit.yml; do
        if [ -f "$phpunit_config" ]; then
          echo "Validating PHPUnit config: $(basename "$phpunit_config")"
          yamllint "$phpunit_config" || exit 1
        fi
      done
  rules:
    - changes:
        - "**/*.yml"
        - "**/*.yaml"
        - "apps/richdesk/tests/fixtures/**/*.yml"
        - "apps/richdesk/config/**/*.yml"
  allow_failure: false
```

### FUB Test Fixtures Validation

**Validate database fixtures with existing infrastructure:**
```yaml
yaml-fixtures-validation:
  stage: test
  image: [MASKED].dkr.ecr.[MASKED].amazonaws.com/fub-pipeline:latest
  services:
    - name: mysql:8.0
      alias: mysql
  before_script:
    - yum install -y python3 python3-pip
    - pip3 install yamllint yq
  script:
    - |
      # Validate FUB database fixtures
      if [ -d "apps/richdesk/tests/fixtures" ]; then
        echo "Validating FUB database fixture YAML files..."

        # Common database fixtures
        find apps/richdesk/tests/fixtures -name "*.common.yml" | while read common_fixture; do
          echo "Validating common fixture: $(basename "$common_fixture")"
          yamllint -d relaxed "$common_fixture"

          # Verify YAML structure for database fixtures
          yq eval 'keys' "$common_fixture" >/dev/null || echo "Warning: Complex YAML structure in $common_fixture"
        done

        # Client database fixtures
        find apps/richdesk/tests/fixtures -name "*.client.yml" | while read client_fixture; do
          echo "Validating client fixture: $(basename "$client_fixture")"
          yamllint -d relaxed "$client_fixture"
        done
      else
        echo "No FUB test fixtures directory found"
      fi

      # Validate mutagen synchronization configs
      if [ -f "mutagen.yml" ]; then
        echo "Validating mutagen configuration..."
        yamllint mutagen.yml
        yq eval '.sync | keys' mutagen.yml >/dev/null || echo "Warning: No sync configuration found"
      fi
  rules:
    - changes:
        - "apps/richdesk/tests/fixtures/**/*.yml"
        - "mutagen.yml"
  allow_failure: true  # Fixture validation warnings shouldn't block pipeline
```

## Minimal YAML Pipeline Jobs

### Basic YAML Validation Job

**Lightweight validation for standard YAML files:**
```yaml
yaml-check:
  stage: test
  image: amazonlinux:2023
  before_script:
    - yum update -y
    - yum install -y python3 python3-pip
    - pip3 install yamllint yq
  script:
    - |
      # Only run if YAML files exist
      if [ "$(find . -name "*.yml" -o -name "*.yaml" | grep -v ".git" | wc -l)" -gt 0 ]; then
        echo "Found YAML files, running validation..."

        # Validate all YAML files with basic rules
        find . -name "*.yml" -o -name "*.yaml" | grep -v ".git" | while read yaml_file; do
          echo "Validating: $yaml_file"
          yamllint -d default "$yaml_file" || exit 1
        done

        echo "✓ All YAML files are valid"
      else
        echo "No YAML files found"
        exit 0
      fi
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      changes:
        - "**/*.yml"
        - "**/*.yaml"
    - if: '$CI_COMMIT_BRANCH == "main"'
      changes:
        - "**/*.yml"
        - "**/*.yaml"
  allow_failure: true
```

## Integration with FUB Development Workflow

### Pre-commit Integration with Existing Hooks

**Add to existing pre-commit configurations:**
```bash
# Add to existing .git/hooks/pre-commit or pre-commit config
yaml_validation() {
    # Check staged YAML files
    yaml_files=$(git diff --cached --name-only | grep -E '\.(yml|yaml)$' || true)

    if [ -n "$yaml_files" ]; then
        echo "Validating staged YAML files..."
        for yaml_file in $yaml_files; do
            if ! yamllint -d default "$yaml_file" >/dev/null 2>&1; then
                echo "✗ Invalid YAML: $yaml_file"
                return 1
            fi

            # Extra validation for FUB-specific files
            case "$yaml_file" in
                apps/richdesk/tests/fixtures/*)
                    yamllint -d relaxed "$yaml_file" >/dev/null || {
                        echo "✗ FUB fixture validation failed: $yaml_file"
                        return 1
                    }
                    echo "✓ FUB fixture validated: $yaml_file"
                    ;;
                apps/richdesk/config/*)
                    echo "✓ FUB config validated: $yaml_file"
                    ;;
                mutagen.yml)
                    yq eval '.sync | length' "$yaml_file" >/dev/null || echo "Warning: mutagen.yml may be incomplete"
                    ;;
            esac
        done
        echo "✓ YAML files validated"
    fi
    return 0
}

# Call alongside existing validations (psalm, composer, etc.)
yaml_validation || exit 1
```

### Integration with Existing Test Infrastructure

**Add to existing FUB test setup:**
```yaml
# In existing test jobs with FUB infrastructure
test:yaml-config:
  stage: test
  image: [MASKED].dkr.ecr.[MASKED].amazonaws.com/fub-pipeline:latest
  services:
    - name: mysql:8.0
      alias: mysql
  before_script:
    - yum install -y python3 python3-pip
    - pip3 install yamllint yq
    # Existing Composer and setup commands...
    - composer install --no-dev --optimize-autoloader
  script:
    - |
      # Validate YAML configuration files in FUB structure
      if [ -d "apps/richdesk/config" ]; then
        find apps/richdesk/config -name "*.yml" -o -name "*.yaml" | while read yaml_file; do
          yamllint "$yaml_file" || exit 1
          echo "✓ Validated: $(basename "$yaml_file")"
        done
      fi

      # Validate test fixtures before running tests
      if [ -d "apps/richdesk/tests/fixtures" ]; then
        find apps/richdesk/tests/fixtures -name "*.yml" | while read fixture; do
          yamllint -d relaxed "$fixture" || exit 1
        done
        echo "✓ Test fixtures validated"
      fi

      # Continue with existing test commands...
      ./vendor/bin/phpunit apps/richdesk/tests/cases/
  artifacts:
    reports:
      junit: apps/richdesk/tests/results/junit.xml
```

## Docker Image Enhancement

### Add YAML Tools to Existing Pipeline Image

**Dockerfile enhancement for FUB pipeline image:**
```dockerfile
# Add to existing Dockerfile for fub-pipeline:latest
FROM amazonlinux:2023

# Existing FUB dependencies...
RUN yum update -y && \
    yum install -y php8.4 composer mysql-client redis-tools

# Add YAML validation support
RUN yum install -y python3 python3-pip && \
    pip3 install yamllint yq && \
    yum clean all

# Continue with existing FUB setup...
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
```

### Lightweight YAML Validation Container

**Alternative minimal container for YAML-only jobs:**
```dockerfile
FROM amazonlinux:2023
RUN yum update -y && \
    yum install -y python3 python3-pip && \
    pip3 install yamllint yq && \
    yum clean all
ENTRYPOINT ["yamllint"]
```

## Environment-Specific Considerations

### Production Pipeline Safety

**Safe YAML validation for production deployments:**
```yaml
production-yaml-check:
  stage: deploy
  image: [MASKED].dkr.ecr.[MASKED].amazonaws.com/fub-pipeline:latest
  before_script:
    - yum install -y python3 python3-pip
    - pip3 install yamllint yq
  script:
    - |
      # Only validate, never modify in production pipeline
      echo "Production YAML validation check..."

      # Validate critical configuration files
      if [ -d "apps/richdesk/config" ]; then
        find apps/richdesk/config -name "*.yml" -o -name "*.yaml" | while read config; do
          yamllint "$config" || exit 1
          echo "✓ Production validation passed: $(basename "$config")"
        done
      fi

      # Validate production-specific YAML files
      for prod_yaml in docker-compose.prod.yml .gitlab-ci.yml; do
        if [ -f "$prod_yaml" ]; then
          yamllint "$prod_yaml" || exit 1
          echo "✓ Production YAML validated: $prod_yaml"
        fi
      done
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
  environment:
    name: production
  when: manual
```

### Integration with Existing Monitoring

**YAML validation metrics for Datadog:**
```bash
# Add to existing monitoring scripts
yaml_health_check() {
    local yaml_count
    yaml_count=$(find /app -name "*.yml" -o -name "*.yaml" | grep -v ".git" | wc -l)

    if [ "$yaml_count" -gt 0 ]; then
        local valid_count=0
        find /app -name "*.yml" -o -name "*.yaml" | grep -v ".git" | while read yaml_file; do
            if yamllint "$yaml_file" >/dev/null 2>&1; then
                valid_count=$((valid_count + 1))
            fi
        done

        # Send metrics to existing Datadog integration
        echo "fub.yaml.files.total:$yaml_count|g" | nc -w 1 -u localhost 8125
        echo "fub.yaml.files.valid:$valid_count|g" | nc -w 1 -u localhost 8125
    fi
}
```

## Troubleshooting FUB Pipeline Issues

### Common YAML Pipeline Problems

**Pipeline fails due to missing tools:**
```yaml
# Debug job for YAML issues
debug-yaml:
  stage: test
  image: amazonlinux:2023
  script:
    - echo "Checking YAML tool availability..."
    - yum list available | grep python3
    - yum install -y python3 python3-pip
    - pip3 install yamllint yq
    - python3 --version
    - yamllint --version
    - yq --version
    - echo "YAML tools installed successfully"
  when: manual
  allow_failure: true
```

**YAML validation in resource-constrained jobs:**
```bash
# Lightweight validation for limited pipeline resources
quick_yaml_check() {
    # Skip if too many YAML files to avoid pipeline timeout
    local yaml_count
    yaml_count=$(find . -name "*.yml" -o -name "*.yaml" | grep -v ".git" | wc -l)

    if [ "$yaml_count" -gt 30 ]; then
        echo "Too many YAML files ($yaml_count), running selective validation"
        # Only validate critical FUB files
        yamllint apps/richdesk/config/*.yml 2>/dev/null || true
        yamllint mutagen.yml 2>/dev/null || true
        yamllint .gitlab-ci.yml 2>/dev/null || true
        return 0
    fi

    find . -name "*.yml" -o -name "*.yaml" | grep -v ".git" | xargs yamllint
}
```

## FUB-Specific Validation Patterns

### Database Fixtures Validation

**Enhanced validation for FUB test fixtures:**
```bash
# FUB-specific fixture validation
validate_fub_fixtures() {
    local fixtures_dir="apps/richdesk/tests/fixtures"

    if [ ! -d "$fixtures_dir" ]; then
        echo "No fixtures directory found"
        return 0
    fi

    echo "Validating FUB database fixtures..."

    # Common database fixtures
    find "$fixtures_dir" -name "*.common.yml" | while read fixture; do
        echo "Validating common fixture: $(basename "$fixture")"
        yamllint -d relaxed "$fixture" || return 1

        # Check for required fixture structure
        if ! yq eval 'type == "!!map"' "$fixture" >/dev/null 2>&1; then
            echo "Warning: Fixture should contain key-value pairs: $fixture"
        fi
    done

    # Client database fixtures
    find "$fixtures_dir" -name "*.client.yml" | while read fixture; do
        echo "Validating client fixture: $(basename "$fixture")"
        yamllint -d relaxed "$fixture" || return 1
    done
}
```

### Configuration Management Validation

**Validate FUB configuration files:**
```bash
# Enhanced configuration validation for FUB
validate_fub_configs() {
    local config_dir="apps/richdesk/config"

    if [ ! -d "$config_dir" ]; then
        echo "No configuration directory found"
        return 0
    fi

    echo "Validating FUB configuration files..."

    find "$config_dir" -name "*.yml" -o -name "*.yaml" | while read config; do
        echo "Validating config: $(basename "$config")"
        yamllint "$config" || return 1

        # Check for environment-specific configs
        if [[ "$config" == *"production"* ]] || [[ "$config" == *"staging"* ]]; then
            echo "✓ Environment-specific config validated: $(basename "$config")"
        fi
    done
}
```

This minimal integration approach aligns with FUB's PHP-focused infrastructure using Amazon Linux 2023, providing essential YAML validation for test fixtures and configuration files without adding complexity to the existing GitLab pipeline structure.