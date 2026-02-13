---
name: backend-test-development
description: Develop comprehensive PHP backend tests for FUB's application infrastructure with coverage analysis using remote execution
---

## Overview

Develop comprehensive PHP backend tests for FUB's application infrastructure with coverage analysis using remote execution. Create, execute, and analyze PHPUnit tests integrating with ControllerTester, DatabaseTestCase, TestQueue, TestLogAdapter, and mutex testing utilities while targeting 70% coverage through intelligent test expansion.

## Usage

```bash
/backend-test-development --target=<class_or_file> --server=<hostname> [--test_type=<type>] [--coverage_target=<percentage>] [--auth_mode=<mode>] [--coverage_enabled=<bool>] [--test_path=<path>] [--phpunit_options=<options>]
```

📁 **Comprehensive Examples**: [examples/basic-usage-examples.md](examples/basic-usage-examples.md)

## Core Workflow

### Essential Testing Operations (Most Common - 90% of Usage)

**1. Unit Test Development**
```bash
# Create unit tests for specific PHP classes
/backend-test-development --target="UsersController.php" --test_type="unit" --server="fubdev-matttu-dev-01"

# Test specific methods with coverage analysis
/backend-test-development --target="Contact::create" --coverage_target=80 --test_type="unit"

# Fast unit testing without coverage for development
/backend-test-development --target="UserService.php" --coverage_enabled=false --test_type="unit"
```

**2. API and Integration Testing**
```bash
# API endpoint testing with authentication
/backend-test-development --target="api/users" --test_type="api" --auth_mode="fub-spa" --coverage_target=75

# Database integration testing
/backend-test-development --target="UserModel.php" --test_type="database" --coverage_target=85

# Queue processing tests
/backend-test-development --target="EmailQueue" --test_type="queue" --server="fubdev-matttu-dev-01"
```

**3. Comprehensive Test Suites**
```bash
# Full test suite execution with coverage
/backend-test-development --test_path="tests/integration" --coverage_target=70 --coverage_enabled=true

# Mutex testing for concurrent operations
/backend-test-development --target="ConcurrentProcessor" --test_type="mutex" --phpunit_options="--repeat=10"

# Targeted test execution with filters
/backend-test-development --phpunit_options="--filter UserTest --group api" --coverage_target=80
```

### Behavior

When invoked, execute this systematic testing workflow:

**1. Test Environment Setup**
- Establish remote server connection (fubdev-matttu-dev-01 or specified server)
- Configure PHPUnit environment with FUB-specific test utilities
- Initialize coverage analysis tools and reporting frameworks
- Validate target classes/files existence and accessibility

**2. Test Implementation and Execution**
- Generate or execute PHPUnit tests based on target specification
- Integrate with ControllerTester, DatabaseTestCase, TestQueue utilities
- Apply authentication modes for API testing (fub-spa, api, system, oauth)
- Execute tests with mutex support for concurrent operation testing

**3. Coverage Analysis and Reporting**
- Measure code coverage against specified target percentage (default: 70%)
- Generate comprehensive coverage reports with line-by-line analysis
- Identify untested code paths and suggest test expansion areas
- Provide actionable recommendations for coverage improvement

**4. Integration and Quality Assurance**
- Validate test results against acceptance criteria
- Generate test documentation and maintain test suite integrity
- Coordinate with CI/CD pipelines for automated testing
- Provide integration guidance for development workflow handoff

## Quick Reference

📊 **Complete Reference**: [reference/testing-frameworks.md](reference/testing-frameworks.md)

| Test Type | Purpose | Common Targets | Coverage Requirements |
|-----------|---------|----------------|----------------------|
| `unit` | Isolated component testing | Controllers, Services, Models | 80%+ for critical components |
| `api` | HTTP endpoint testing | API routes, authentication | 75%+ for public endpoints |
| `database` | Data layer testing | Models, migrations, queries | 85%+ for data operations |
| `integration` | Multi-component testing | Workflows, service integration | 70%+ for integration points |
| `queue` | Asynchronous processing | Background jobs, email queues | 70%+ for queue handlers |
| `mutex` | Concurrent operation testing | Lock mechanisms, race conditions | 90%+ for critical sections |

### FUB Testing Environment Standards

**Remote Execution:**
- Primary server: `fubdev-matttu-dev-01` for consistent test environment
- SSH-based test execution with proper authentication and permissions
- Isolated test databases and configurations for each developer

**Framework Integration:**
- ControllerTester for HTTP endpoint and authentication testing
- DatabaseTestCase for data layer testing with transaction rollback
- TestQueue for background job and email processing validation
- TestLogAdapter for comprehensive test logging and debugging

## Advanced Patterns

🔧 **Advanced Testing Techniques**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)

<details>
<summary>Click to expand advanced testing patterns and optimization strategies</summary>

### Complex Testing Scenarios

**Multi-layer integration testing with dependency management:**
```bash
# Complex workflow testing with multiple components
/backend-test-development --target="PaymentWorkflow" --test_type="integration" --coverage_target=85
```

**Performance and load testing integration:**
```bash
# Performance-critical component testing with benchmarks
/backend-test-development --target="DataProcessor" --test_type="unit" --phpunit_options="--repeat=100"
```

📚 **Complete Advanced Documentation**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)

</details>

## Integration Points

🔗 **Integration Workflows**: [workflows/integration-patterns.md](workflows/integration-patterns.md)

### Cross-Skill Workflow Patterns

**Development → Testing → Analysis:**
```bash
# Complete development workflow with testing
/code-development --task="Add user authentication" --scope="small-feature" |\
  backend-test-development --target="AuthController" --test_type="api" --coverage_target=80 |\
  backend-static-analysis --focus="security,coverage" --psalm-level="1"

# Bug fix with comprehensive testing
/code-development --task="Fix payment processing bug" --scope="bug-fix" |\
  backend-test-development --target="PaymentProcessor" --test_type="integration" --coverage_target=90
```

### Related Skills

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| `code-development` | **Development Integration** | Feature implementation, bug fixes, refactoring validation |
| `backend-static-analysis` | **Quality Assurance** | Code quality validation, security analysis, type checking |
| `database-operations` | **Data Layer Testing** | Migration testing, query validation, data integrity checks |
| `planning-workflow` | **Project Coordination** | Test planning, coverage requirements, quality gates |
| `gitlab-pipeline-monitoring` | **CI/CD Integration** | Automated testing, pipeline configuration, deployment gates |

📋 **Complete Integration Guide**: [workflows/integration-patterns.md](workflows/integration-patterns.md)

### Testing Framework Specializations

🧪 **Testing Frameworks**: [frameworks/](frameworks/)

**Unit testing patterns, integration testing strategies, performance testing guidelines**

📊 **Coverage Analysis**: [reference/coverage-analysis.md](reference/coverage-analysis.md)

**Coverage requirements, analysis tools, improvement strategies**

### Multi-Skill Operation Examples

**Complete Development Testing Workflow:**
1. `code-development` - Implement feature with proper architecture
2. `backend-test-development` - Create comprehensive test coverage
3. `backend-static-analysis` - Validate code quality and security
4. `database-operations` - Test database changes and migrations
5. `gitlab-pipeline-monitoring` - Monitor CI/CD pipeline and deployment

**Complete Bug Resolution Testing Workflow:**
1. `support-investigation` - Analyze bug and identify root cause
2. `backend-test-development` - Create tests to reproduce and validate fix
3. `code-development` - Implement fix with proper testing
4. `backend-static-analysis` - Ensure fix meets quality standards
5. `database-operations` - Apply data corrections if needed