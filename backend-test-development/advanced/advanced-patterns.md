## Advanced Patterns

<details>
<summary>Click to expand detailed implementation and configuration options</summary>

### Comprehensive Testing Workflow

When invoked, execute this comprehensive testing workflow in FUB's remote environment:

### 1. Test Analysis and Setup

**Pre-Test Sync Verification:**
- Execute `mutagen-management --operation="status"` to verify Mutagen sync health
- Ensure coverage report paths are synchronized (`fub/phpunit-cache/`)
- Use `mutagen-management --operation="flush"` to sync any pending local changes before remote test execution
- If sync issues detected, use `mutagen-management --operation="troubleshoot"` to resolve before proceeding

**Determine Test Requirements:**
- Analyze target code to classify test type (API, database, queue, unit, integration, mutex)
- Select appropriate base class: `DatabaseTestCase` for API/database tests, standard `TestCase` for unit tests
- Configure authentication mode for API tests using `ControllerTester` static methods
- Set up feature-based test grouping with kebab-case naming (e.g., `@group user-management`)

### 2. Test Implementation Patterns

**Create Tests Following FUB Patterns:**
- **API Tests**: Use `ControllerTester::get/post/putAs` with proper authentication modes
- **Database Tests**: Configure YML fixtures with `$commonFixture` and `$clientFixture`
- **Queue Tests**: Use `TestQueue` assertions (`assertJobsInQueueCount`, `assertQueued`)
- **Log Tests**: Configure `TestLogAdapter` with `assertMessageWasLogged`
- **Mutex Tests**: Use `Mutex::$mutexesToBlock` for alternate path testing

### 3. Coverage Analysis Infrastructure

**Execute Pre-Test Coverage Analysis on Remote:**
- SSH to specified server and generate clover XML coverage
- Remote command: `XDEBUG_MODE=coverage ./vendor/bin/phpunit --coverage-clover phpunit-cache/cov.xml`
- Analyze method coverage using XmlStarlet queries on remote server
- Identify uncovered code paths and branch conditions

### 4. Remote Test Execution Infrastructure

**Advanced Remote Execution Patterns:**
- **Environment Configuration**: Use environment variables for flexible server and path configuration
- **Coverage Control**: Dynamic coverage enablement with XDEBUG_MODE management
- **SSH Security**: Proper SSH connection handling with error recovery and timeout management
- **Mutagen Coordination**: Ensure synchronization for coverage files and test result retrieval

**Command Construction and Options Handling:**
```bash
# Base remote execution pattern with environment variables
REMOTE_HOST="${server:-${FUB_DEV_HOST:-fubdev-matttu-dev-01}}"
REMOTE_PATH="${FUB_PROJECT_PATH:-/var/www/fub}"
ENABLE_COVERAGE=${coverage_enabled:-true}

# Build execution command with coverage and options
if [ "$ENABLE_COVERAGE" = true ]; then
    XDEBUG_CMD="XDEBUG_MODE=coverage"
fi
PHPUNIT_CMD="vendor/bin/phpunit $test_path $phpunit_options"
REMOTE_CMD="cd $REMOTE_PATH && $XDEBUG_CMD $PHPUNIT_CMD"
```

**Error Handling and Progress Reporting:**
- Colored output with ANSI codes (green success, red failure, blue info)
- Progress indicators with start/completion markers
- Exit code handling and propagation
- Timeout management for long-running tests

**SSH Execution Patterns:**
```bash
# Execute with comprehensive error handling
echo "Running: $REMOTE_CMD"
if ssh "$REMOTE_HOST" "$REMOTE_CMD"; then
    echo "✓ Tests passed"
    if [ "$ENABLE_COVERAGE" = true ]; then
        echo "Coverage report: apps/richdesk/tests/coverage/index.html"
    fi
else
    echo "✗ Tests failed with exit code $?"
    exit $?
fi
```

### 5. Test Execution and Results Processing

**Execute Tests in FUB Remote Environment:**
- SSH to specified server with proper authentication and connection validation
- Execute PHPUnit in configured remote directory with coverage and output settings
- Capture test results, execution time, and coverage metrics
- Generate coverage reports on remote server with clover XML output
- Coordinate Mutagen sync to retrieve coverage files and test results locally

### 6. Coverage Validation and Reporting

**Post-Test Coverage Synchronization:**
- Use `mutagen-management --operation="flush"` to ensure coverage files sync from remote to local
- Verify coverage file availability: `fub/phpunit-cache/cov.xml`
- If coverage sync issues, use `mutagen-management --operation="troubleshoot"` to resolve

**Post-Test Analysis:**
- Retrieve coverage data via Mutagen sync from remote environment
- Compare before/after coverage using XmlStarlet locally
- Verify coverage meets 70% target for modified methods
- Generate test execution report with coverage improvements

### 7. FUB Testing Infrastructure Patterns

**API Controller Tests:**
- Inherit from `DatabaseTestCase` for database integration
- Use `ControllerTester::getAs/postAs/putAs` for HTTP requests
- Configure fixtures with `$commonFixture` and `$clientFixture`
- Group tests with `@group` annotations (kebab-case)

**Database Test Cases:**
- Use `DatabaseTestCase` base class for data layer testing
- Configure YML fixtures for test data setup
- Test model methods and data validation
- Verify database constraints and relationships

### 8. Database Fixture System Architecture

**FUB Dual Database Structure:**
FUB uses separate `common` and `client` databases, each with their own fixture systems:

```
Common Database          Client Database
      ↓                        ↓
Base Fixture: apps/richdesk/resources/sql/tests/phpunit_database_fixture.yml
      ↓                        ↓
$commonFixture              $clientFixture
(test-specific)             (test-specific)
```

**Base Fixture System (`phpunit_database_fixture.yml`):**
- **Location**: `apps/richdesk/resources/sql/tests/phpunit_database_fixture.yml`
- **Purpose**: Provides default data for tables in **both** common and client databases
- **Scope**: Tables not overridden by individual test fixture files inherit data from this base file
- **Coverage**: Defines baseline data that supports most testing scenarios across both databases

**Individual Test Fixtures (Separate Systems):**

**Common Database Fixtures (`$commonFixture`):**
- **Purpose**: Override specific tables in the **common database** with test-specific data
- **Location**: `apps/richdesk/tests/fixtures/`
- **Naming**: `{TestClassName}.common.yml`
- **Scope**: Only affects common database tables
- **Inheritance**: Tables not defined here use data from `phpunit_database_fixture.yml`

**Client Database Fixtures (`$clientFixture`):**
- **Purpose**: Override specific tables in the **client database** with test-specific data
- **Location**: `apps/richdesk/tests/fixtures/`
- **Naming**: `{TestClassName}.client.yml`
- **Scope**: Only affects client database tables
- **Inheritance**: Tables not defined here use data from `phpunit_database_fixture.yml`
- **Independence**: Does NOT inherit from `$commonFixture` - completely separate system

**Fixture Configuration in Test Classes:**
```php
class UsersControllerTest extends DatabaseTestCase
{
    // Overrides common database tables only
    protected $commonFixture = 'UsersController.common.yml';

    // Overrides client database tables only (independent of commonFixture)
    protected $clientFixture = 'UsersController.client.yml';

    // All other tables in both databases inherit from phpunit_database_fixture.yml
}
```

**Database-Specific Override Examples:**

**Common Database Override (`UsersController.common.yml`):**
```yaml
# Overrides tables in COMMON database only
users:
  test-admin:
    id: 100
    username: "testadmin"
    email: "admin@test.com"

user_sessions:
  admin-session:
    id: 1
    user_id: 100
    token: "test-token"

# Other common database tables inherit from phpunit_database_fixture.yml
```

**Client Database Override (`UsersController.client.yml`):**
```yaml
# Overrides tables in CLIENT database only (separate from common)
contacts:
  test-contact:
    id: 200
    account_id: 1
    name: "Test Contact"
    email: "contact@test.com"

leads:
  test-lead:
    id: 1
    contact_id: 200
    source: "test"

# Other client database tables inherit from phpunit_database_fixture.yml
```

**Fixture Resolution Logic:**
1. **Common Database Tables**: Use `$commonFixture` if defined, otherwise `phpunit_database_fixture.yml`
2. **Client Database Tables**: Use `$clientFixture` if defined, otherwise `phpunit_database_fixture.yml`
3. **No Cross-Database Inheritance**: Common and client fixtures are completely independent
4. **Per-Table Override**: Each table is resolved independently - mixed override sources possible

**Best Practices for FUB Fixture Management:**
1. **Database Awareness**: Understand which database each table belongs to
2. **Targeted Overrides**: Only override tables that need test-specific data
3. **Consistent Test IDs**: Use 100+ for common DB test data, 200+ for client DB test data
4. **Foreign Key Management**: Maintain referential integrity across database boundaries
5. **Base Fixture Reliance**: Leverage `phpunit_database_fixture.yml` for stable foundation data
6. **Independent Design**: Design common and client fixtures independently

**Troubleshooting Fixture Issues:**
```bash
# Verify fixture files exist with correct naming
ls -la apps/richdesk/tests/fixtures/YourTest.common.yml
ls -la apps/richdesk/tests/fixtures/YourTest.client.yml

# Check base fixture accessibility
ls -la apps/richdesk/resources/sql/tests/phpunit_database_fixture.yml

# Validate YAML syntax using Symfony YAML (FUB standard)
php -r "
require 'vendor/autoload.php';
use Symfony\Component\Yaml\Yaml;
try {
    Yaml::parseFile('apps/richdesk/tests/fixtures/YourTest.common.yml');
    echo 'Common fixture YAML is valid\n';
} catch (Exception \$e) {
    echo 'Common fixture YAML error: ' . \$e->getMessage() . '\n';
}
"

# Check which database a table belongs to by examining model connections
grep -r "protected.*connection" apps/richdesk/models/ | grep "table_name"
```

**Queue Testing with TestQueue:**
- Use `TestQueue::assertJobsInQueueCount()` for job verification
- Test background job processing and queue interactions
- Verify job data and processing logic

**Log Testing with TestLogAdapter:**
- Configure `TestLogAdapter` for log verification
- Use `assertMessageWasLogged()` for log assertions
- Test application logging and error handling

**Mutex Testing:**
- Use `Mutex::$mutexesToBlock` for lock simulation
- Test alternate execution paths with blocked mutexes
- Verify resource locking and concurrency handling

### 9. Coverage Analysis Integration

**Remote Coverage Analysis:**
- Execute coverage analysis on remote development servers
- Generate clover XML reports with `XDEBUG_MODE=coverage`
- Sync coverage data via Mutagen for local analysis
- Use XmlStarlet for coverage data parsing and analysis

**Post-Test Coverage Verification:**
- Compare before/after coverage metrics
- Target 70% coverage for new/modified methods
- Identify uncovered code paths for additional testing
- Generate comprehensive coverage reports

### 10. Enhanced Remote Execution and Best Practices

**Command-Line Integration:**
- Environment variable configuration (`FUB_DEV_HOST`, `FUB_PROJECT_PATH`)
- Flexible PHPUnit options and filtering
- SSH connection management and error handling
- Proper exit code propagation

**Test Organization:**
- Feature-based test grouping with kebab-case naming
- Group management commands for remote execution
- Performance monitoring and optimization
- Integration with FUB infrastructure requirements

**Debugging and Troubleshooting:**
- Database state issue resolution on remote servers
- Coverage analysis troubleshooting
- SSH connectivity and Mutagen sync issues
- Fixture loading and authentication problems

</details>

