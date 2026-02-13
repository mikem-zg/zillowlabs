# YAML Processing with yq for FUB Development

Practical yq operations for processing YAML files in FUB development workflows, including data extraction, transformation, and format conversion.

## Installation and Setup

### Install yq via Homebrew

```bash
# Install yq (YAML processor)
brew install yq

# Verify installation
yq --version
```

**Note:** Ensure you have the mikefarah/yq version (not the kislyuk/yq Python version).

## FUB Database Fixture Processing

### Extract Data from Test Fixtures

**Query specific fixture data:**
```bash
# Get user data from common fixture
yq '.users.test-admin' apps/richdesk/tests/fixtures/UserTest.common.yml

# Extract all user IDs
yq '.users[].id' apps/richdesk/tests/fixtures/UserTest.common.yml

# Get contact information from client fixture
yq '.contacts[] | select(.active == true) | .name' apps/richdesk/tests/fixtures/ContactTest.client.yml
```

### Fixture Data Analysis

**Analyze fixture structure:**
```bash
# List all top-level keys in fixture
yq 'keys' apps/richdesk/tests/fixtures/UserTest.common.yml

# Count records in each table
yq '.users | length' apps/richdesk/tests/fixtures/UserTest.common.yml
yq '.accounts | length' apps/richdesk/tests/fixtures/UserTest.common.yml

# Find fixture dependencies (foreign key relationships)
yq '.contacts[] | select(.account_id) | {name: .name, account_id: .account_id}' apps/richdesk/tests/fixtures/ContactTest.client.yml
```

### Fixture Validation and Cleanup

**Check for data consistency:**
```bash
# Find duplicate IDs in fixtures
yq '.users[].id' apps/richdesk/tests/fixtures/UserTest.common.yml | sort | uniq -d

# Check for empty required fields
yq '.users[] | select(.username == "" or .email == "") | .id' apps/richdesk/tests/fixtures/UserTest.common.yml

# Validate foreign key references
yq '.contacts[] | select(.account_id != null) | .account_id' apps/richdesk/tests/fixtures/ContactTest.client.yml
```

## PHPUnit Configuration Processing

### Extract PHPUnit Settings

**Process PHPUnit configuration:**
```bash
# Get test suite configuration
yq '.testsuites' phpunit.yml

# Extract specific test suite paths
yq '.testsuites.unit.directory' phpunit.yml
yq '.testsuites.integration.directory' phpunit.yml

# Get coverage settings
yq '.coverage.include' phpunit.yml
```

### Modify PHPUnit Configuration

**Update configuration programmatically:**
```bash
# Add new test suite
yq '.testsuites.api = {"directory": "tests/api"}' phpunit.yml

# Update coverage paths
yq '.coverage.include += ["apps/richdesk/lib/new_module"]' phpunit.yml

# Modify bootstrap file
yq '.bootstrap = "tests/bootstrap.php"' phpunit.yml
```

## Docker Compose Processing

### Extract Service Information

**Analyze Docker Compose configuration:**
```bash
# List all services
yq '.services | keys' docker-compose.yml

# Get service ports
yq '.services[] | select(.ports) | {name: .name, ports: .ports}' docker-compose.yml

# Extract environment variables for FUB services
yq '.services.fub-web.environment' docker-compose.yml
yq '.services.fub-db.environment' docker-compose.yml
```

### Service Configuration Management

**Modify Docker services:**
```bash
# Add environment variable to service
yq '.services.fub-web.environment.DEBUG = "true"' docker-compose.yml

# Update service image
yq '.services.fub-web.image = "fub:latest"' docker-compose.yml

# Add volume mount
yq '.services.fub-web.volumes += ["./logs:/app/logs"]' docker-compose.yml
```

## FUB Configuration File Processing

### Application Configuration

**Process FUB application configs:**
```bash
# Extract database configuration
yq '.database.default' apps/richdesk/config/bootstrap/database.yml

# Get cache settings
yq '.cache.redis' apps/richdesk/config/bootstrap/cache.yml

# Extract email configuration
yq '.email.smtp' apps/richdesk/config/bootstrap/email.yml
```

### Environment-Specific Configuration

**Handle environment configurations:**
```bash
# Extract development settings
yq '.development' apps/richdesk/config/bootstrap/environments.yml

# Get production database settings
yq '.production.database' apps/richdesk/config/bootstrap/environments.yml

# Compare staging vs production settings
yq '.staging.cache, .production.cache' apps/richdesk/config/bootstrap/environments.yml
```

## Data Transformation for FUB

### Fixture Format Conversion

**Convert between formats:**
```bash
# Convert fixture to JSON for API testing
yq -o json '.users' apps/richdesk/tests/fixtures/UserTest.common.yml > users.json

# Extract fixture data as CSV
yq -r '.users[] | [.id, .username, .email] | @csv' apps/richdesk/tests/fixtures/UserTest.common.yml

# Create compact fixture summary
yq '.users[] | {id, username, active}' apps/richdesk/tests/fixtures/UserTest.common.yml
```

### Configuration Merging

**Merge FUB configuration files:**
```bash
# Merge base config with environment overrides
yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' \
  apps/richdesk/config/bootstrap/base.yml \
  apps/richdesk/config/bootstrap/development.yml

# Combine multiple fixture files
yq eval-all '. as $item ireduce ({}; . * $item)' \
  apps/richdesk/tests/fixtures/BaseTest.common.yml \
  apps/richdesk/tests/fixtures/UserTest.common.yml
```

## Advanced FUB Processing Patterns

### Fixture Relationship Analysis

**Analyze data relationships in fixtures:**
```bash
# Find all users associated with accounts
yq '.users[] | select(.account_id) | {username: .username, account_id: .account_id}' \
  apps/richdesk/tests/fixtures/UserTest.common.yml

# Map contacts to their accounts
yq '.contacts[] | {name: .name, account: (.account_id as $aid | $root.accounts[] | select(.id == $aid) | .name)}' \
  apps/richdesk/tests/fixtures/ContactTest.client.yml
```

### Configuration Validation

**Validate configuration completeness:**
```bash
# Check required configuration keys
yq 'has("database") and has("cache") and has("email")' apps/richdesk/config/bootstrap/app.yml

# Validate database configuration structure
yq '.database | has("host") and has("database") and has("username")' apps/richdesk/config/bootstrap/database.yml

# Check for missing environment variables
yq '.services.fub-web.environment | to_entries[] | select(.value | startswith("$")) | .key' docker-compose.yml
```

### Automated Processing Scripts

**FUB fixture processing automation:**
```bash
#!/bin/bash
# scripts/process-fixtures.sh

echo "🔄 Processing FUB test fixtures"

# Extract user count by role
echo "Users by role:"
yq '.users | group_by(.role) | map({role: .[0].role, count: length})' \
  apps/richdesk/tests/fixtures/UserTest.common.yml

# Generate fixture summary
echo "Fixture summary:"
for fixture in apps/richdesk/tests/fixtures/*.yml; do
    name=$(basename "$fixture" .yml)
    tables=$(yq 'keys | length' "$fixture")
    echo "  $name: $tables tables"
done

# Check fixture data integrity
echo "Checking data integrity..."
yq '.users[] | select(.account_id) | .account_id' apps/richdesk/tests/fixtures/UserTest.common.yml | \
while read account_id; do
    if ! yq ".accounts[] | select(.id == $account_id)" apps/richdesk/tests/fixtures/UserTest.common.yml > /dev/null; then
        echo "⚠️  Orphaned user with account_id: $account_id"
    fi
done
```

## Format Conversion for FUB Workflows

### Common Format Conversions

**Convert between YAML, JSON, and other formats:**
```bash
# YAML to JSON (for API testing)
yq -o json apps/richdesk/tests/fixtures/UserTest.common.yml > UserTest.json

# JSON to YAML (from API responses)
yq -P api_response.json > api_response.yml

# YAML to CSV (for data analysis)
yq -r '.users[] | [.id, .username, .email, .role] | @csv' \
  apps/richdesk/tests/fixtures/UserTest.common.yml > users.csv

# Create properties file from YAML config
yq -o props '.database' apps/richdesk/config/bootstrap/database.yml > database.properties
```

### FUB-Specific Transformations

**Transform data for FUB tools:**
```bash
# Convert fixture to SQL INSERT statements (conceptual)
yq -r '.users[] | "INSERT INTO users (id, username, email) VALUES (\(.id), \"\(.username)\", \"\(.email)\");"' \
  apps/richdesk/tests/fixtures/UserTest.common.yml

# Generate test data summaries
yq '.users | map({id, username}) | sort_by(.username)' \
  apps/richdesk/tests/fixtures/UserTest.common.yml

# Extract configuration for environment setup
yq '{database: .database, cache: .cache}' apps/richdesk/config/bootstrap/app.yml > deployment-config.yml
```

## Troubleshooting yq Operations

### Common Issues and Solutions

**Debugging yq queries:**
```bash
# Debug complex queries step by step
yq '.users' apps/richdesk/tests/fixtures/UserTest.common.yml  # First, get users
yq '.users[]' apps/richdesk/tests/fixtures/UserTest.common.yml  # Then iterate
yq '.users[] | select(.active)' apps/richdesk/tests/fixtures/UserTest.common.yml  # Add filter

# Check yq syntax
yq --help | grep "output format"  # Verify output format options
yq eval --help  # Get detailed help for eval command
```

**Performance optimization:**
```bash
# For large fixture files, use specific paths
yq '.users.test-admin' apps/richdesk/resources/sql/tests/phpunit_database_fixture.yml

# Use streaming for very large files
yq --stream '.users[]' large-fixture.yml
```

This processing guide focuses on practical yq operations that enhance FUB development workflows, from fixture analysis to configuration management.