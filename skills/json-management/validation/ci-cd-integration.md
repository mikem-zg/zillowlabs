# CI/CD Integration for JSON Validation

JSON validation integration for FUB's GitLab CI/CD pipeline using Amazon Linux 2023-based infrastructure, focused on package.json, API configurations, and test data files.

## FUB GitLab Pipeline Integration

### JSON Validation in Existing Pipeline Structure

**Add JSON validation to existing .gitlab-ci.yml stages:**
```yaml
# Add to existing test stage jobs for JSON files
json-validation:
  stage: test
  image: [MASKED].dkr.ecr.[MASKED].amazonaws.com/fub-pipeline:latest
  services:
    - name: mysql:8.0
      alias: mysql
    - name: valkey/valkey:7.2-alpine
      alias: valkey
  before_script:
    - yum update -y
    - yum install -y nodejs npm jq
    - npm install -g jsonlint
  script:
    - |
      # Validate FUB-specific JSON files
      echo "Validating JSON files in FUB project..."

      # Package.json validation
      if [ -f "package.json" ]; then
        echo "Validating root package.json"
        jsonlint package.json
        jq 'has("name") and has("version")' package.json > /dev/null
      fi

      # FUB frontend package.json
      if [ -f "apps/richdesk/frontend/package.json" ]; then
        echo "Validating FUB frontend package.json"
        jsonlint apps/richdesk/frontend/package.json
        jq 'has("dependencies") and has("scripts")' apps/richdesk/frontend/package.json > /dev/null
      fi

      # FUB configuration files
      if [ -d "apps/richdesk/config" ]; then
        find apps/richdesk/config -name "*.json" | while read config; do
          echo "Validating FUB config: $(basename "$config")"
          jsonlint "$config" || exit 1
        done
      fi
  rules:
    - changes:
        - "package.json"
        - "apps/richdesk/frontend/package.json"
        - "apps/richdesk/config/**/*.json"
  allow_failure: false
```

### FUB Test Data Validation

**Validate API test data with existing infrastructure:**
```yaml
json-test-data-validation:
  stage: test
  image: [MASKED].dkr.ecr.[MASKED].amazonaws.com/fub-pipeline:latest
  services:
    - name: mysql:8.0
      alias: mysql
  before_script:
    - yum install -y nodejs npm jq
    - npm install -g jsonlint
  script:
    - |
      # Validate FUB test data JSON files
      if [ -d "apps/richdesk/tests/data" ]; then
        echo "Validating FUB test data JSON files..."
        find apps/richdesk/tests/data -name "*.json" | while read test_data; do
          echo "Validating test data: $(basename "$test_data")"
          jsonlint "$test_data" || echo "Warning: Test data validation failed for $test_data"
        done
      else
        echo "No FUB test data directory found"
      fi

      # Validate API configuration files
      find apps/richdesk/config -name "*api*.json" 2>/dev/null | while read api_config; do
        echo "Validating API config: $(basename "$api_config")"
        jsonlint "$api_config"

        # Check for required API configuration keys
        jq 'has("base_url") or has("endpoints")' "$api_config" > /dev/null || echo "Warning: API config may be incomplete"
      done || echo "No API configuration files found"
  rules:
    - changes:
        - "apps/richdesk/tests/data/**/*.json"
        - "apps/richdesk/config/*api*.json"
  allow_failure: true  # Test data validation warnings shouldn't block pipeline
```

## Minimal JSON Pipeline Jobs

### Basic JSON Validation Job

**Lightweight validation for standard JSON files:**
```yaml
json-check:
  stage: test
  image: amazonlinux:2023
  before_script:
    - yum update -y
    - yum install -y nodejs npm jq
    - npm install -g jsonlint
  script:
    - |
      # Only run if JSON files exist
      if [ "$(find . -name "*.json" -not -path "./node_modules/*" -not -path "./.git/*" | wc -l)" -gt 0 ]; then
        echo "Found JSON files, running validation..."

        # Validate all JSON files except node_modules
        find . -name "*.json" -not -path "./node_modules/*" -not -path "./.git/*" | while read json_file; do
          echo "Validating: $json_file"
          jsonlint "$json_file" || exit 1
        done

        echo "✓ All JSON files are valid"
      else
        echo "No JSON files found"
        exit 0
      fi
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      changes:
        - "**/*.json"
    - if: '$CI_COMMIT_BRANCH == "main"'
      changes:
        - "**/*.json"
  allow_failure: true
```

## Integration with FUB Development Workflow

### Pre-commit Integration with Existing Hooks

**Add to existing pre-commit configurations:**
```bash
# Add to existing .git/hooks/pre-commit or pre-commit config
json_validation() {
    # Check staged JSON files
    json_files=$(git diff --cached --name-only | grep '\.json$' | grep -v node_modules || true)

    if [ -n "$json_files" ]; then
        echo "Validating staged JSON files..."
        for json_file in $json_files; do
            if ! jsonlint "$json_file" >/dev/null 2>&1; then
                echo "✗ Invalid JSON: $json_file"
                return 1
            fi

            # Extra validation for FUB-specific files
            case "$json_file" in
                *package.json)
                    if ! jq 'has("name") and has("version")' "$json_file" >/dev/null; then
                        echo "✗ Incomplete package.json: $json_file"
                        return 1
                    fi
                    ;;
                apps/richdesk/config/*)
                    echo "✓ FUB config validated: $json_file"
                    ;;
            esac
        done
        echo "✓ JSON files validated"
    fi
    return 0
}

# Call alongside existing validations (psalm, composer, etc.)
json_validation || exit 1
```

### Integration with Existing Test Infrastructure

**Add to existing FUB test setup:**
```yaml
# In existing test jobs with FUB infrastructure
test:json-config:
  stage: test
  image: [MASKED].dkr.ecr.[MASKED].amazonaws.com/fub-pipeline:latest
  services:
    - name: mysql:8.0
      alias: mysql
  before_script:
    - yum install -y nodejs npm jq
    - npm install -g jsonlint
    # Existing Composer and setup commands...
    - composer install --no-dev --optimize-autoloader
  script:
    - |
      # Validate JSON configuration files in FUB structure
      if [ -d "apps/richdesk/config" ]; then
        find apps/richdesk/config -name "*.json" | while read json_file; do
          jsonlint "$json_file" || exit 1
          echo "✓ Validated: $(basename "$json_file")"
        done
      fi

      # Validate package.json files
      for pkg in package.json apps/richdesk/frontend/package.json; do
        if [ -f "$pkg" ]; then
          jsonlint "$pkg" || exit 1
          jq 'has("name")' "$pkg" >/dev/null || echo "Warning: $pkg missing name field"
        fi
      done

      # Continue with existing test commands...
      ./vendor/bin/phpunit apps/richdesk/tests/cases/
  artifacts:
    reports:
      junit: apps/richdesk/tests/results/junit.xml
```

## Docker Image Enhancement

### Add JSON Tools to Existing Pipeline Image

**Dockerfile enhancement for FUB pipeline image:**
```dockerfile
# Add to existing Dockerfile for fub-pipeline:latest
FROM amazonlinux:2023

# Existing FUB dependencies...
RUN yum update -y && \
    yum install -y php8.4 composer mysql-client redis-tools

# Add JSON validation support
RUN yum install -y nodejs npm jq && \
    npm install -g jsonlint && \
    yum clean all

# Continue with existing FUB setup...
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
```

### Lightweight JSON Validation Container

**Alternative minimal container for JSON-only jobs:**
```dockerfile
FROM amazonlinux:2023
RUN yum update -y && \
    yum install -y nodejs npm jq && \
    npm install -g jsonlint && \
    yum clean all
ENTRYPOINT ["jsonlint"]
```

## Environment-Specific Considerations

### Production Pipeline Safety

**Safe JSON validation for production deployments:**
```yaml
production-json-check:
  stage: deploy
  image: [MASKED].dkr.ecr.[MASKED].amazonaws.com/fub-pipeline:latest
  before_script:
    - yum install -y nodejs npm jq
    - npm install -g jsonlint
  script:
    - |
      # Only validate, never modify in production pipeline
      echo "Production JSON validation check..."

      # Validate critical FUB files
      for critical_file in package.json apps/richdesk/frontend/package.json; do
        if [ -f "$critical_file" ]; then
          jsonlint "$critical_file" || exit 1
          echo "✓ Production validation passed: $critical_file"
        fi
      done

      # Validate production config files
      if [ -d "apps/richdesk/config" ]; then
        find apps/richdesk/config -name "*.json" | while read config; do
          jsonlint "$config" || exit 1
        done
        echo "✓ Production configuration files validated"
      fi
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
  environment:
    name: production
  when: manual
```

### Integration with Existing Monitoring

**JSON validation metrics for Datadog:**
```bash
# Add to existing monitoring scripts
json_health_check() {
    local json_count
    json_count=$(find /app -name "*.json" -not -path "*/node_modules/*" 2>/dev/null | wc -l)

    if [ "$json_count" -gt 0 ]; then
        local valid_count=0
        find /app -name "*.json" -not -path "*/node_modules/*" | while read json_file; do
            if jsonlint "$json_file" >/dev/null 2>&1; then
                valid_count=$((valid_count + 1))
            fi
        done

        # Send metrics to existing Datadog integration
        echo "fub.json.files.total:$json_count|g" | nc -w 1 -u localhost 8125
        echo "fub.json.files.valid:$valid_count|g" | nc -w 1 -u localhost 8125
    fi
}
```

## Troubleshooting FUB Pipeline Issues

### Common JSON Pipeline Problems

**Pipeline fails due to missing tools:**
```yaml
# Debug job for JSON issues
debug-json:
  stage: test
  image: amazonlinux:2023
  script:
    - echo "Checking JSON tool availability..."
    - yum list available | grep nodejs
    - yum install -y nodejs npm jq
    - npm install -g jsonlint
    - node --version
    - jsonlint --version
    - jq --version
    - echo "JSON tools installed successfully"
  when: manual
  allow_failure: true
```

**JSON validation in resource-constrained jobs:**
```bash
# Lightweight validation for limited pipeline resources
quick_json_check() {
    # Skip if too many JSON files to avoid pipeline timeout
    local json_count
    json_count=$(find . -name "*.json" -not -path "./node_modules/*" | wc -l)

    if [ "$json_count" -gt 50 ]; then
        echo "Too many JSON files ($json_count), running selective validation"
        # Only validate critical FUB files
        jsonlint package.json 2>/dev/null || true
        find apps/richdesk/config -name "*.json" -exec jsonlint {} \; 2>/dev/null || true
        return 0
    fi

    find . -name "*.json" -not -path "./node_modules/*" -exec jsonlint {} \;
}
```

## FUB-Specific Validation Patterns

### Package.json Dependencies Validation

**Validate FUB frontend dependencies in pipeline:**
```bash
# Enhanced package.json validation for FUB
validate_fub_package_json() {
    local pkg_file="$1"

    # Basic JSON validation
    jsonlint "$pkg_file" || return 1

    # FUB-specific validations
    if [[ "$pkg_file" == *"frontend"* ]]; then
        # Frontend package.json requirements
        jq '.dependencies | has("react")' "$pkg_file" >/dev/null || echo "Warning: React not found in frontend dependencies"
        jq '.scripts | has("build") and has("test")' "$pkg_file" >/dev/null || echo "Warning: Missing build/test scripts"
    fi

    # General requirements
    jq 'has("name") and has("version")' "$pkg_file" >/dev/null || {
        echo "Error: Missing required fields in $pkg_file"
        return 1
    }
}
```

This minimal integration approach aligns with FUB's PHP-focused infrastructure using Amazon Linux 2023, providing essential JSON validation without adding complexity to the existing GitLab pipeline structure.