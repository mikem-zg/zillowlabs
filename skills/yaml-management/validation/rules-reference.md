# yamllint Rules Reference for FUB Development

Key yamllint validation rules for FUB's database fixtures, PHPUnit configuration, and testing infrastructure.

## Essential Rules for FUB Database Fixtures

### Indentation Rules

**Rule: `indentation`**
Controls consistent indentation in FUB database test fixtures.

```yaml
rules:
  indentation:
    spaces: 2                    # FUB standard: 2 spaces
    indent-sequences: true       # Consistent list indentation
```

**FUB Database Fixture Examples:**
```yaml
# Good (FUB fixture standard)
users:
  test-admin:
    id: 100
    username: "testadmin"
    email: "admin@testaccount.com"
    role: "admin"

user_sessions:
  admin-session:
    id: 1
    user_id: 100
    token: "test-session-token"

# Bad (inconsistent indentation)
users:
    test-admin:
      id: 100
user_sessions:
- id: 1
  user_id: 100
```

**Common Issues in FUB Fixtures:**
```bash
# Check indentation in FUB test fixtures
yamllint apps/richdesk/tests/fixtures/UserTest.common.yml
yamllint apps/richdesk/tests/fixtures/ContactTest.client.yml
```

### Empty Values Rules

**Rule: `empty-values`**
Handles empty values in FUB database fixtures for optional test data.

```yaml
# FUB database fixtures - allow empty for optional test fields
rules:
  empty-values:
    forbid-in-mappings: false    # Allow empty optional fields
    forbid-in-sequences: true    # Don't allow empty list items
```

**FUB Database Fixture Context:**
```yaml
# FUB test fixture - empty values OK for optional fields
users:
  test-user:
    id: 200
    username: "testuser"
    email: "test@example.com"
    bio:                  # Empty bio OK in test fixtures
    phone:                # Empty phone OK in test fixtures
    last_login_at:        # Empty timestamp OK

contacts:
  test-contact:
    id: 300
    account_id: 1
    name: "Test Contact"
    email: "contact@test.com"
    notes:                # Empty notes OK in test data
```

### Truthy Values Rules

**Rule: `truthy`**
Controls boolean value representation in FUB test fixtures.

```yaml
# FUB database fixtures (flexible for test data)
rules:
  truthy:
    allowed-values: [true, false, 'yes', 'no', 'on', 'off', 1, 0]
```

**FUB Test Fixture Examples:**
```yaml
# FUB database fixture - various truthy formats acceptable
users:
  admin-user:
    id: 100
    active: yes           # OK in test fixtures
    verified: 1           # OK in test fixtures
    admin: true           # OK everywhere
    deleted: false        # Standard boolean

accounts:
  test-account:
    id: 1
    active: on            # OK in test data
    trial: 0              # OK in test data
```

### Line Length Rules

**Rule: `line-length`**
Manages line length in FUB fixture and configuration files.

```yaml
rules:
  line-length:
    max: 150                     # Flexible for test data
    allow-non-breakable-words: true  # Long test strings OK
```

**FUB Usage:**
```yaml
# Acceptable in FUB test fixtures (non-breakable test data)
contacts:
  long-test-contact:
    email: "very.long.test.email.address.for.testing.email.validation@test-domain-name.example.com"

# Should be broken (long descriptions)
users:
  documented-user:
    bio: >
      This is a very long user biography that should be broken
      into multiple lines for better readability in test fixtures
```

## Document Structure Rules for FUB

### Document Start/End Rules

**Rule: `document-start` / `document-end`**
Controls YAML document markers in FUB files.

```yaml
# FUB database fixtures (no markers needed)
rules:
  document-start: disable
  document-end: disable

# FUB PHPUnit configuration (may require markers)
rules:
  document-start:
    present: true
  document-end: disable
```

**FUB File Examples:**
```yaml
# Database fixture - no document markers needed
users:
  test-user:
    id: 100
    username: "testuser"

# PHPUnit configuration - document marker for clarity
---
testsuites:
  unit:
    directory: tests/unit
  integration:
    directory: tests/integration
```

## Content Quality Rules for FUB

### Key Duplicates Rule

**Rule: `key-duplicates`**
Prevents duplicate keys in FUB database fixtures.

```yaml
rules:
  key-duplicates: {}  # Always enabled for FUB
```

**Common FUB Fixture Issues:**
```yaml
# Bad - duplicate keys in database fixture
users:
  test-user:
    id: 100
    name: "First Name"
  test-user:           # Duplicate key - will cause fixture loading issues
    id: 101
    name: "Second Name"

# Good - unique keys in FUB fixtures
users:
  test-user-admin:
    id: 100
    name: "Admin User"
    role: "admin"
  test-user-regular:
    id: 101
    name: "Regular User"
    role: "user"
```

### Comments Rules

**Rule: `comments`**
Manages comment formatting in FUB test fixtures.

```yaml
# FUB standard
rules:
  comments:
    min-spaces-from-content: 1    # At least 1 space before comment
    require-starting-space: true  # Space after # required
```

**FUB Test Fixture Comments:**
```yaml
# Good comments in FUB fixtures
users:
  test-admin:
    id: 100          # Admin user for authentication tests
    username: "admin"
    role: "admin"    # Full administrative privileges

contacts:
  test-contact:
    id: 200          # Contact for lead generation tests
    account_id: 1    # Links to test-account
```

## FUB-Specific Rule Combinations

### Database Test Fixtures Configuration
```yaml
# Optimized for FUB database test fixtures
rules:
  indentation:
    spaces: 2
    indent-sequences: true
  line-length:
    max: 150                     # Allow longer test data
    allow-non-breakable-words: true
  truthy:
    allowed-values: [true, false, 'yes', 'no', 'on', 'off', 1, 0]
  empty-values:
    forbid-in-mappings: false    # Allow empty optional test fields
    forbid-in-sequences: true
  document-start: disable        # No markers in fixtures
  document-end: disable
  key-duplicates: {}             # Prevent fixture loading errors
  trailing-spaces: {}            # Clean formatting
  comments:
    min-spaces-from-content: 1   # Document test data purpose
```

### PHPUnit Configuration Rules
```yaml
# For FUB PHPUnit configuration files
rules:
  indentation:
    spaces: 2
    indent-sequences: true
  line-length:
    max: 120
    allow-non-breakable-words: true
  truthy:
    allowed-values: [true, false]  # Strict boolean values in config
  empty-values:
    forbid-in-mappings: true       # No empty configuration values
    forbid-in-sequences: true
  document-start:
    present: true                  # Clear configuration document
  key-duplicates: {}
  trailing-spaces: {}
```

## FUB File-Specific Validation

### Database Fixture Validation Commands
```bash
# Validate individual FUB test fixtures
yamllint apps/richdesk/tests/fixtures/UserTest.common.yml
yamllint apps/richdesk/tests/fixtures/ContactTest.client.yml

# Validate all FUB test fixtures
yamllint apps/richdesk/tests/fixtures/*.yml

# Relaxed validation for large base fixture
yamllint -d relaxed apps/richdesk/resources/sql/tests/phpunit_database_fixture.yml
```

### Rule-Specific Validation for FUB
```bash
# Check indentation in FUB fixtures (2-space standard)
yamllint -d '{rules: {indentation: {spaces: 2}}}' apps/richdesk/tests/fixtures/

# Check for empty value issues in test fixtures
yamllint -d '{rules: {empty-values: {forbid-in-mappings: false}}}' apps/richdesk/tests/fixtures/

# Validate truthy values in test data
yamllint -d '{rules: {truthy: {allowed-values: [true, false, yes, no, 1, 0]}}}' apps/richdesk/tests/fixtures/UserTest.common.yml
```

### Common FUB Fixture Issues and Fixes

**Issue: Inconsistent Test User IDs**
```yaml
# Problem - ID conflicts between fixtures
users:
  test-user:
    id: 1              # Conflicts with base fixture data

# Solution - Use high IDs for test data
users:
  test-user:
    id: 100            # Safe range for test data
```

**Issue: Invalid Foreign Key References**
```yaml
# Problem - References non-existent records
contacts:
  test-contact:
    account_id: 999    # Account doesn't exist in fixtures

# Solution - Reference existing fixture data
contacts:
  test-contact:
    account_id: 1      # References existing test account
```

**Issue: Trailing Spaces in Test Data**
```bash
# Check for trailing spaces in FUB fixtures
yamllint -d '{rules: {trailing-spaces: {}}}' apps/richdesk/tests/fixtures/

# Fix trailing spaces
sed -i 's/[[:space:]]*$//' apps/richdesk/tests/fixtures/*.yml
```

## Troubleshooting FUB-Specific Issues

### Fixture Loading Problems
```bash
# Validate fixture syntax before running tests
yamllint apps/richdesk/tests/fixtures/UserTest.common.yml && echo "Fixture syntax OK"

# Check for duplicate keys that cause fixture conflicts
yamllint -d '{rules: {key-duplicates: {}}}' apps/richdesk/tests/fixtures/
```

### Large Fixture File Handling
```bash
# Base fixture file is large - use relaxed validation
yamllint -d relaxed apps/richdesk/resources/sql/tests/phpunit_database_fixture.yml

# Skip expensive rules for large files
yamllint -d '{
  extends: relaxed,
  rules: {
    key-ordering: disable,
    comments-indentation: disable
  }
}' apps/richdesk/resources/sql/tests/phpunit_database_fixture.yml
```

This rules reference focuses specifically on yamllint validation rules relevant to FUB's database testing infrastructure and fixture management.