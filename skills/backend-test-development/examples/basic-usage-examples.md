## Examples

```bash
# Test specific controller with API authentication
/backend-test-development --target="UsersController" --server="fubdev-matttu-dev-01" --test_type="api" --auth_mode="fub-spa"

# Run database tests with high coverage target
/backend-test-development --target="Contact::save" --server="fubdev-matttu-dev-01" --test_type="database" --coverage_target=85

# Execute queue tests for background job processing
/backend-test-development --target="EmailSendJob" --server="fubdev-matttu-dev-01" --test_type="queue"

# Run unit tests for service class without coverage (faster)
/backend-test-development --target="ValidationService" --server="fubdev-matttu-dev-01" --test_type="unit" --coverage_enabled=false

# Test with specific PHPUnit options and filters
/backend-test-development --target="UserTest" --server="fubdev-matttu-dev-01" --phpunit_options="--filter testCreateUser --stop-on-failure"

# Integration test with custom test path
/backend-test-development --target="PaymentIntegration" --server="fubdev-matttu-dev-01" --test_type="integration" --test_path="tests/integration/PaymentTest.php"
```

