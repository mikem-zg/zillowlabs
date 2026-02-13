## Cross-Skill Workflow Patterns

### Database Operations → Support Investigation

```bash
# Investigate data inconsistencies found during database operations
database-operations --operation="data-validation" --account_id="12345" |
  support-investigation --issue="Data integrity issue found in account 12345"

# Validate database fixes with production monitoring
database-operations complete_data_fix |
  datadog-management --analysis_type="database" --service="fub-api"
```

**Use Cases:**
- Data corruption investigation requiring cross-system analysis
- Performance degradation requiring database and application correlation
- Migration failures needing comprehensive impact analysis
- Schema changes causing application-level issues

### Database Operations → Backend Testing

```bash
# Test database changes with comprehensive test suite
database-operations --operation="schema-migration" --environment="development" |
  backend-test-development --target="DatabaseTestCase" --test_type="integration"

# Validate migration rollback procedures
database-operations test_rollback_procedures |
  backend-test-development --test_type="migration"
```

**Integration Patterns:**
- **Pre-Migration Testing**: Validate schema changes with comprehensive test coverage
- **ActiveRecord Model Testing**: Ensure model changes work with database modifications
- **Performance Testing**: Validate query performance after optimization changes
- **Rollback Testing**: Ensure safe rollback procedures for failed migrations

### Database Operations → Performance Monitoring

```bash
# Monitor database performance after optimization changes
database-operations --operation="query-optimization" |
  datadog-management --analysis_type="performance" --service="mysql"

# Create alerts for database performance degradation
database-operations document_performance_baselines |
  datadog-management --operation="create_monitor" --alert_type="database_performance"
```

**Monitoring Integration:**
- **Query Performance Tracking**: Monitor execution times before and after changes
- **Connection Pool Monitoring**: Track database connection health and usage
- **Index Usage Analysis**: Monitor index effectiveness and query plan changes
- **Transaction Monitoring**: Track transaction duration and deadlock occurrences

### Database Operations → Development Investigation

```bash
# Investigate database-related architecture issues
database-operations --operation="schema-analysis" --environment="development" |
  development-investigation --task="Database architecture optimization" --scope="performance"

# Analyze database patterns for refactoring decisions
database-operations --operation="pattern-analysis" |
  development-investigation --task="ActiveRecord pattern modernization" --scope="refactoring"
```

**Development Integration:**
- **Schema Evolution Planning**: Inform architecture decisions with database analysis
- **Performance Investigation**: Database-level analysis for development optimization
- **Migration Strategy**: Database analysis informing refactoring approaches
- **Pattern Analysis**: ActiveRecord usage patterns for development optimization

### Complete Multi-Skill Workflows

**Complete Database Change Workflow:**
```bash
# 1. Plan and validate database changes
/development-investigation --task="Plan schema migration for contact enhancement" --scope="architecture"

# 2. Execute database changes with safety protocols
/database-operations --environment="development" --operation="schema-migration" --backup_required=true

# 3. Run comprehensive tests to validate changes
/backend-test-development --target="ContactModel" --test_type="integration"

# 4. Monitor performance impact
/datadog-management --analysis_type="performance" --service="mysql" --timeframe="post-deployment"

# 5. Validate production impact
/support-investigation --issue="Contact schema migration validation" --environment="production"

# 6. Update related code patterns
/serena-mcp --task="Update ActiveRecord model patterns" --scope="schema-migration"
```

**Database Performance Optimization Workflow:**
```bash
# 1. Identify performance bottlenecks
/database-operations --operation="query-optimization" --environment="development"

# 2. Investigate architectural implications
/development-investigation --task="Database performance architecture" --scope="performance"

# 3. Test optimization changes
/backend-test-development --target="PerformanceTest" --test_type="performance"

# 4. Monitor optimization impact
/datadog-management --operation="performance-baseline" --service="database"

# 5. Validate production performance
/support-investigation --issue="Database optimization validation" --environment="production"
```

**Data Migration and Integrity Workflow:**
```bash
# 1. Plan data migration strategy
/development-investigation --task="Large data migration planning" --scope="architecture"

# 2. Execute migration with safety checks
/database-operations --environment="qa" --operation="data-migration" --backup_required=true

# 3. Validate data integrity
/backend-test-development --target="DataIntegrityTest" --test_type="integration"

# 4. Monitor migration performance
/datadog-management --analysis_type="migration-monitoring" --service="mysql"

# 5. Investigate any data issues
/support-investigation --issue="Data migration validation" --environment="qa"
```

### Specialized Integration Scenarios

**Emergency Database Recovery:**
```bash
# 1. Assess database corruption or failure
/database-operations --environment="production" --operation="emergency-assessment" --approve_destructive=false

# 2. Investigate root cause and impact
/support-investigation --issue="Database emergency recovery" --environment="production"

# 3. Execute recovery procedures
/database-operations --environment="production" --operation="emergency-recovery" --approve_destructive=true

# 4. Monitor system recovery
/datadog-management --analysis_type="recovery-monitoring" --service="mysql"

# 5. Validate application functionality
/backend-test-development --target="CriticalPathTest" --test_type="smoke"
```

**Schema Change Impact Analysis:**
```bash
# 1. Analyze proposed schema changes
/development-investigation --task="Schema change impact analysis" --scope="architecture"

# 2. Test schema changes in development
/database-operations --environment="development" --operation="schema-migration" --backup_required=false

# 3. Run comprehensive impact tests
/backend-test-development --target="SchemaChangeTest" --test_type="comprehensive"

# 4. Validate with production-like data
/database-operations --environment="qa" --operation="schema-migration" --backup_required=true

# 5. Monitor for unexpected impacts
/datadog-management --analysis_type="schema-change-monitoring" --service="fub-api"
```

**Database Security Audit:**
```bash
# 1. Security assessment of database operations
/database-operations --operation="security-audit" --environment="production"

# 2. Investigate security findings
/support-investigation --issue="Database security audit findings" --environment="production"

# 3. Test security improvements
/backend-test-development --target="SecurityTest" --test_type="security"

# 4. Monitor security metrics
/datadog-management --operation="security-monitoring" --service="database"
```

### Related Skills Integration Matrix

| Skill | Relationship | Common Workflows | Integration Points |
|-------|--------------|------------------|-------------------|
| `support-investigation` | **Data Analysis** | Data integrity issues, performance correlation, migration failures | Database errors → support analysis |
| `backend-test-development` | **Testing Integration** | Schema validation, model testing, performance testing | Migration → comprehensive testing |
| `datadog-management` | **Performance Monitoring** | Query monitoring, connection tracking, alert creation | Database changes → monitoring setup |
| `serena-mcp` | **Code Analysis** | ActiveRecord patterns, model relationships, code updates | Schema changes → code analysis |
| `development-investigation` | **Architecture Planning** | Schema design, performance planning, migration strategy | Database needs → architecture analysis |
| `planning-workflow` | **Change Management** | Migration planning, rollback procedures, approval processes | Database changes → structured planning |

### Integration Best Practices

**Safety Protocols:**
- Always use development environment for experimental operations
- Require explicit approval for production destructive operations
- Implement comprehensive backup verification procedures
- Monitor performance impact during and after changes
- Validate data integrity after any modifications

**Quality Assurance:**
- Test all database changes in development and QA environments
- Use comprehensive test suites to validate schema changes
- Monitor application performance after database modifications
- Implement rollback procedures for all production changes
- Maintain detailed audit logs for all database operations

**Communication Patterns:**
- Coordinate database changes with application development teams
- Notify monitoring teams of planned database modifications
- Document all database changes for future reference
- Communicate performance impacts to relevant stakeholders
- Establish clear escalation procedures for database emergencies

### Workflow Automation Examples

**Automated Migration Testing:**
```bash
#!/bin/bash
# Automated database migration testing workflow

migrate_and_test() {
    local environment="$1"
    local migration_script="$2"

    # Execute migration
    /database-operations --environment="$environment" --operation="schema-migration" --backup_required=true --issue="Automated migration test"

    # Run comprehensive tests
    /backend-test-development --target="DatabaseTestCase" --test_type="integration"

    # Monitor performance
    /datadog-management --analysis_type="migration-performance" --service="mysql"

    # Validate with support checks
    /support-investigation --issue="Migration validation: $migration_script" --environment="$environment"
}

# Execute for development and QA
migrate_and_test "development" "contact_enhancement_migration"
migrate_and_test "qa" "contact_enhancement_migration"
```

**Performance Monitoring Automation:**
```bash
#!/bin/bash
# Automated database performance monitoring

monitor_database_performance() {
    local timeframe="${1:-1hour}"

    # Analyze database performance
    /database-operations --operation="performance-analysis" --environment="production"

    # Monitor with Datadog
    /datadog-management --analysis_type="database-performance" --timeframe="$timeframe"

    # Investigate any issues
    /support-investigation --issue="Automated database performance check" --environment="production"
}

# Schedule regular performance monitoring
monitor_database_performance "1hour"
```