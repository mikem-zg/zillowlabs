## Integration Points

### Cross-Skill Workflow Patterns

**Support Investigation → Backend Testing:**
```bash
# Create tests to reproduce reported issues
support-investigation identify_issue_pattern |
  backend-test-development --target="ReportedBugController" --test_type="api" --auth_mode="fub-spa"

# Test database state during investigation
backend-test-development --target="DataConsistencyTest" --test_type="database" --server="fubdev-dev-01"
```

**Database Operations → Backend Testing:**
```bash
# Test schema changes with database tests
database-operations apply_migration |
  backend-test-development --target="MigrationTest" --test_type="database" --coverage_target=90

# Verify database performance with load tests
backend-test-development --target="PerformanceTest" --test_type="integration" --coverage_enabled=false
```

**Serena MCP → Backend Testing:**
```bash
# Analyze code and create targeted tests
serena-mcp --task="Find authentication methods" |
  backend-test-development --target="AuthController" --test_type="api" --auth_mode="system"
```

**YAML Management → Backend Testing (Fixture Analysis):**
```bash
# Analyze existing fixture files to understand table structure
yaml-management --operation="query" --file="apps/richdesk/tests/fixtures/UserTest.common.yml" --xpath=".users[0] | keys" |
  backend-test-development --target="NewUserFeatureTest" --test_type="database" --use_fixtures=true

# Validate fixture file structure before test creation
yaml-management --operation="validate" --file="apps/richdesk/tests/fixtures/ContactTest.client.yml" |
  backend-test-development --target="ContactApiTest" --test_type="api" --coverage_enabled=true

# Query fixture data patterns for complex test scenarios
yaml-management --operation="query" --file="*.yml" --xpath=".accounts[] | select(.status == 'active')" |
  backend-test-development --target="AccountStatusTest" --test_type="integration"
```

**Backend Testing → YAML Management (Fixture Creation):**
```bash
# Create new fixture files with proper YAML structure
backend-test-development --target="PaymentTest" --test_type="database" --generate_fixtures=true |
  yaml-management --operation="format" --file="apps/richdesk/tests/fixtures/PaymentTest.common.yml"

# Validate generated fixture files meet YAML standards
backend-test-development --action="validate_fixtures" --fixture_path="PaymentTest.*.yml" |
  yaml-management --operation="validate" --strict_mode=true
```

### Related Skills

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| `text-manipulation` | **Pattern Analysis** | Model property extraction, test fixture analysis, codebase pattern matching |
|-------|--------------|------------------|
| `support-investigation` | **Issue Reproduction** | Create tests to reproduce reported bugs, verify fixes |
| `database-operations` | **Data Layer Testing** | Test schema changes, data migrations, performance |
| `serena-mcp` | **Code Analysis** | Find untested methods, analyze coverage gaps |
| `mutagen-management` | **File Synchronization** | Sync coverage reports, manage remote/local coordination |
| `datadog-management` | **Performance Monitoring** | Monitor test execution performance, identify bottlenecks |
| `frontend-test-development` | **Full-Stack Testing** | Coordinate API and frontend test coverage |
| `yaml-management` | **Fixture Analysis** | Analyze existing fixture files for table structure, validate YAML format, query test data patterns |

### Multi-Skill Operation Examples

**Complete Bug Fix Workflow:**
1. `support-investigation` - Identify and analyze the reported issue
2. `backend-test-development` - Create failing test to reproduce the bug
3. `serena-mcp` - Analyze related code to understand root cause
4. `database-operations` - Check data consistency if data-related
5. `backend-test-development` - Verify fix with passing tests and coverage
6. `datadog-management` - Monitor production deployment for performance impact

### Refusal Conditions

The skill must refuse if:
- SSH access to remote development server is not available or properly configured
- Mutagen sync is not functioning (prevents coverage report synchronization)
- PHPUnit or required testing infrastructure is not available on remote environment
- Target code cannot be analyzed or does not exist in the expected location
- Database fixtures are missing or malformed for database tests
- Authentication configuration is invalid for API tests
- XmlStarlet is not installed locally via Homebrew for coverage analysis

When refusing, provide specific guidance on:
- **SSH Setup**: Use `claude /remote-connectivity-management --operation=troubleshoot --interactive=true` for comprehensive SSH and VPN configuration
- **Connectivity Issues**: Run `claude /remote-connectivity-management --operation=vpn-status` to diagnose network and VPN problems
- **Mutagen Issues**: Use `mutagen-management --operation="troubleshoot"` to resolve sync problems
- **Environment Verification**: Ensure PHPUnit is available on remote server
- **Local Tools**: Install XmlStarlet locally with `brew install xmlstarlet` for coverage analysis
- **Fixture Problems**: Verify fixture files exist and follow FUB naming conventions
- **Authentication Configuration**: Check available auth modes (`fub-spa`, `api`, `system`, `oauth`)
