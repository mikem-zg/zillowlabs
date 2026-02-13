# CI/CD Integration for XML Validation

Simple XML validation integration for FUB's GitLab CI/CD pipeline using Amazon Linux 2023-based infrastructure.

## FUB GitLab Pipeline Integration

### XML Validation in Existing Pipeline Structure

**Add XML validation to existing .gitlab-ci.yml stages:**
```yaml
# Add to existing test stage jobs if XML files are present
xml-validation:
  stage: test
  image: [MASKED].dkr.ecr.[MASKED].amazonaws.com/fub-pipeline:latest
  services:
    - name: mysql:8.0
      alias: mysql
    - name: valkey/valkey:7.2-alpine
      alias: valkey
  before_script:
    - yum update -y
    - yum install -y libxml2
  script:
    - |
      # Check if XML files exist before validation
      xml_files=$(find . -name "*.xml" -not -path "./.git/*" | head -5)
      if [ -n "$xml_files" ]; then
        echo "Validating XML files..."
        for xml_file in $xml_files; do
          if ! xmllint --noout "$xml_file" 2>/dev/null; then
            echo "✗ Invalid XML: $xml_file"
            exit 1
          fi
        done
        echo "✓ XML files validated"
      else
        echo "No XML files found, skipping validation"
      fi
  only:
    changes:
      - "**/*.xml"
  allow_failure: false
```

### Integration with Existing Security Scanning

**Add to existing security scan jobs:**
```yaml
# Extend existing trivy/defectdojo scanning to include XML files
security-scan:
  stage: test
  extends: .trivy-template
  script:
    - # Existing trivy scanning...
    - |
      # Basic XML security check for external entity injection
      if find . -name "*.xml" -not -path "./.git/*" | head -1 >/dev/null; then
        echo "Checking XML files for security issues..."
        find . -name "*.xml" -not -path "./.git/*" | while read xml_file; do
          if grep -q "<!ENTITY" "$xml_file" 2>/dev/null; then
            echo "⚠️  XML file contains entities: $xml_file"
          fi
          if grep -q "SYSTEM\|PUBLIC" "$xml_file" 2>/dev/null; then
            echo "⚠️  XML file contains external references: $xml_file"
          fi
        done
      fi
```

## Minimal XML Pipeline Jobs

### Basic XML Validation Job

**Simple validation for occasional XML configuration:**
```yaml
xml-check:
  stage: test
  image: amazonlinux:2023
  before_script:
    - yum update -y
    - yum install -y libxml2
  script:
    - |
      # Only run if XML files exist
      if [ "$(find . -name "*.xml" -not -path "./.git/*" | wc -l)" -gt 0 ]; then
        echo "Found XML files, running validation..."
        find . -name "*.xml" -not -path "./.git/*" -exec xmllint --noout {} \; || exit 1
        echo "✓ All XML files are valid"
      else
        echo "No XML files found"
        exit 0
      fi
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      changes:
        - "**/*.xml"
    - if: '$CI_COMMIT_BRANCH == "main"'
      changes:
        - "**/*.xml"
  allow_failure: true
```

## Integration with FUB Development Workflow

### Pre-commit Integration with Existing Hooks

**Add to existing pre-commit configurations:**
```bash
# Add to existing .git/hooks/pre-commit or pre-commit config
xml_validation() {
    # Check staged XML files (minimal approach)
    xml_files=$(git diff --cached --name-only | grep '\.xml$' || true)

    if [ -n "$xml_files" ]; then
        echo "Validating staged XML files..."
        for xml_file in $xml_files; do
            if ! xmllint --noout "$xml_file" 2>/dev/null; then
                echo "✗ Invalid XML: $xml_file"
                return 1
            fi
        done
        echo "✓ XML files validated"
    fi
    return 0
}

# Call alongside existing validations (psalm, composer, etc.)
xml_validation || exit 1
```

### Integration with Existing Test Infrastructure

**Add to existing test setup if XML configuration used:**
```yaml
# In apps/richdesk/tests/ or similar test infrastructure
test:xml-config:
  stage: test
  image: [MASKED].dkr.ecr.[MASKED].amazonaws.com/fub-pipeline:latest
  services:
    - name: mysql:8.0
      alias: mysql
  before_script:
    - yum install -y libxml2
    # Existing Composer and setup commands...
    - composer install --no-dev --optimize-autoloader
  script:
    - |
      # Validate any XML configuration files in FUB structure
      if [ -d "apps/richdesk/config" ]; then
        find apps/richdesk/config -name "*.xml" | while read xml_file; do
          xmllint --noout "$xml_file" || exit 1
        done
      fi

      # Continue with existing test commands...
      ./vendor/bin/phpunit apps/richdesk/tests/cases/
  artifacts:
    reports:
      junit: apps/richdesk/tests/results/junit.xml
```

## Docker Image Enhancement

### Add XML Tools to Existing Pipeline Image

**Dockerfile enhancement for FUB pipeline image:**
```dockerfile
# Add to existing Dockerfile for fub-pipeline:latest
FROM amazonlinux:2023

# Existing FUB dependencies...
RUN yum update -y && \
    yum install -y php8.4 composer mysql-client redis-tools

# Add minimal XML support
RUN yum install -y libxml2 && \
    yum clean all

# Continue with existing FUB setup...
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
```

### Lightweight XML Validation Container

**Alternative minimal container for XML-only jobs:**
```dockerfile
FROM amazonlinux:2023
RUN yum update -y && \
    yum install -y libxml2 && \
    yum clean all
ENTRYPOINT ["xmllint"]
```

## Environment-Specific Considerations

### Production Pipeline Safety

**Safe XML validation for production deployments:**
```yaml
production-xml-check:
  stage: deploy
  image: [MASKED].dkr.ecr.[MASKED].amazonaws.com/fub-pipeline:latest
  before_script:
    - yum install -y libxml2
  script:
    - |
      # Only validate, never modify in production pipeline
      if find . -name "*.xml" -not -path "./.git/*" | head -1 >/dev/null; then
        echo "Production XML validation check..."
        find . -name "*.xml" -not -path "./.git/*" | while read xml_file; do
          xmllint --noout "$xml_file" || exit 1
        done
        echo "✓ Production XML files validated"
      fi
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
  environment:
    name: production
  when: manual
```

### Integration with Existing Monitoring

**Basic XML validation metrics for Datadog:**
```bash
# Add to existing monitoring scripts
xml_health_check() {
    local xml_count
    xml_count=$(find /app -name "*.xml" 2>/dev/null | wc -l)

    if [ "$xml_count" -gt 0 ]; then
        local valid_count=0
        find /app -name "*.xml" | while read xml_file; do
            if xmllint --noout "$xml_file" 2>/dev/null; then
                valid_count=$((valid_count + 1))
            fi
        done

        # Send metrics to existing Datadog integration
        echo "fub.xml.files.total:$xml_count|g" | nc -w 1 -u localhost 8125
        echo "fub.xml.files.valid:$valid_count|g" | nc -w 1 -u localhost 8125
    fi
}
```

## Troubleshooting FUB Pipeline Issues

### Common XML Pipeline Problems

**Pipeline fails due to missing tools:**
```yaml
# Debug job for XML issues
debug-xml:
  stage: test
  image: amazonlinux:2023
  script:
    - echo "Checking XML tool availability..."
    - yum list available | grep libxml2
    - yum install -y libxml2
    - xmllint --version
    - echo "XML tools installed successfully"
  when: manual
  allow_failure: true
```

**XML validation in resource-constrained jobs:**
```bash
# Lightweight validation for limited pipeline resources
quick_xml_check() {
    # Skip if too many XML files to avoid pipeline timeout
    local xml_count
    xml_count=$(find . -name "*.xml" | wc -l)

    if [ "$xml_count" -gt 20 ]; then
        echo "Too many XML files ($xml_count), skipping validation"
        return 0
    fi

    find . -name "*.xml" -exec xmllint --noout {} \;
}
```

This minimal integration approach aligns with FUB's PHP-focused infrastructure while providing essential XML validation when needed, without adding complexity to the existing Amazon Linux-based pipeline structure.