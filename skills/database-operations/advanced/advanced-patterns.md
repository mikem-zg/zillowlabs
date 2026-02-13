## Comprehensive Database Operations Workflow

### Database Connection Management and Access Resolution

**Database Type and Environment Resolution:**
- Determine database type from parameters or infer from operation context:
  - **common**: Shared FUB database (common) for general application data
  - **client**: Account-specific databases for client-isolated data
- Validate environment parameter (development, qa, production)
- Ensure account_id is provided for client database operations
- Verify appropriate access credentials and permissions for target environment

**Environment-Specific Connection Configuration:**

**Development Environment (fubdev-matttu-dev-01):**
- **Common Database**: Direct connection via ArConnections to localhost
- **Client Database**: ActiveRecord-based credential lookup via Account model
- **Connection Pattern**: SSH tunnel to fubdev-matttu-dev-01 with ArConnections

**QA Environment (fub-control-qa-01 via Tailscale):**
- **Common Database**: Extract credentials from FUB configuration files
- **Client Database**: Query accounts table in common database for client credentials
- **Connection Pattern**: SSH with agent forwarding via Tailscale IP resolution

**Production Environment:**
- **Database Access**: Use existing production database tools and established connections
- **Safety Protocols**: Enhanced backup verification and approval requirements
- **Connection Pattern**: Follow FUB production database access protocols

**Account-Specific Database Credential Resolution:**

**For Development Environment:**
```php
// ActiveRecord-based credential lookup
require 'apps/richdesk/config/bootstrap.php';
$account = Account::find($accountId);
if (!$account) {
    throw new Exception('Account not found');
}
echo $account->db_host . '|' . $account->db_database . '|' . $account->db_user;
```

**For QA Environment:**
```sql
-- Query accounts table for client database credentials
SELECT db_host, db_user, db_pass, db_database
FROM accounts
WHERE id = ? AND db_host IS NOT NULL
LIMIT 1;
```

### Operation Type Inference and ActiveRecord Safety Classification

**Analyze and Classify ActiveRecord Operations:**
- Automatically infer operation type from provided ActiveRecord statements:
  - **schema-migration**: CREATE TABLE, ALTER TABLE, DROP TABLE, ADD/DROP INDEX
  - **data-fix**: `update_all()`, `delete_all()`, `create()` statements for data correction
  - **query-optimization**: CREATE INDEX, ANALYZE TABLE, OPTIMIZE TABLE
  - **inspection**: `find()`, `count()`, DESCRIBE, SHOW, EXPLAIN statements
  - **maintenance**: VACUUM, ANALYZE, CHECK TABLE operations
- Analyze all ActiveRecord operations for injection vulnerabilities
- Verify use of parameterized queries with FUB's ActiveRecord framework
- Document transaction management patterns for rollback safety

**Safety Classification System:**
- **SAFE operations** (no additional approval required):
  - `find()`, `count()`, `first()`, `all()` methods with proper conditions
  - DESCRIBE, SHOW, EXPLAIN statements
  - Read-only operations and inspection queries
  - Performance analysis and monitoring queries

- **DESTRUCTIVE operations** (require explicit approval via approve_destructive=true):
  - `delete()`, `delete_all()`, `update_all()` methods
  - DROP, TRUNCATE, ALTER statements
  - `create()` operations in production environment
  - Schema modifications and data migrations

### FUB Performance Optimization Analysis

- Generate and analyze MySQL query execution plans via ActiveRecord
- Identify missing indexes affecting FUB's application queries
- Monitor query execution time and resource usage patterns
- Consider query caching strategies for FUB's application layer
- Document performance baselines and improvement targets for FUB workloads

### Migration Development for FUB Schema Changes

**FUB Schema Migration Best Practices:**
```bash
# FUB Migration Commands
li3 migration client before feature-branch-name
li3 migration common before feature-branch-name

# Migration files stored in
/richdesk/resources/sql/updates

# Deploy with migrations
./bin/deploy-dev.sh
```

**FUB Data Migration Safety Protocols:**
- Implement batch processing for large FUB data sets using ActiveRecord
- Use ActiveRecord transactions with appropriate isolation levels
- Plan for rollback scenarios and data recovery procedures
- Validate data integrity after each migration step
- Monitor system performance during migration execution on FUB infrastructure

### FUB Environment-Specific Safety Protocols

**Development Environment:**
- Allow experimental operations with proper ActiveRecord testing
- Use FUB development-specific test data and fixtures
- Enable detailed query logging and debugging for FUB applications
- Test rollback procedures with FUB's data model

**QA Environment:**
- Mirror FUB production configuration and constraints
- Use production-like data volumes for FUB performance testing
- Validate migration procedures before FUB production deployment
- Test backup and recovery procedures with FUB's infrastructure

**Production Environment:**
- Require explicit approval for ALL destructive operations
- Mandate backup verification before any FUB schema changes
- Implement maintenance windows for major FUB operations
- Monitor FUB system performance during and after operations
- Maintain detailed audit logs of all FUB database changes

### Advanced ActiveRecord Patterns

**Complex Query Optimization:**
```php
// Multi-table join optimization
$results = Contact::find_by_sql("
    SELECT c.*, a.name as account_name, u.email as user_email
    FROM contacts c
    INNER JOIN accounts a ON c.account_id = a.id
    LEFT JOIN users u ON c.user_id = u.id
    WHERE c.status = ? AND a.active = 1
    ORDER BY c.created_at DESC
    LIMIT ?
", [$status, $limit]);

// Subquery optimization
$highValueContacts = Contact::all([
    'conditions' => [
        'account_id IN (SELECT id FROM accounts WHERE premium = 1)',
        'status' => 'active'
    ],
    'order' => 'last_contact_date DESC'
]);

// Union queries for complex data aggregation
$allActivity = Contact::find_by_sql("
    (SELECT 'contact' as type, id, name, created_at FROM contacts WHERE account_id = ?)
    UNION ALL
    (SELECT 'deal' as type, id, title as name, created_at FROM deals WHERE account_id = ?)
    ORDER BY created_at DESC
    LIMIT 50
", [$accountId, $accountId]);
```

**Bulk Operations Optimization:**
```php
// Efficient bulk updates
ActiveRecord\Connection::transaction(function() use ($contactIds, $newStatus) {
    // Use update_all for bulk updates instead of individual saves
    Contact::connection()->update("
        UPDATE contacts
        SET status = ?, updated_at = NOW()
        WHERE id IN (" . str_repeat('?,', count($contactIds) - 1) . "?)
    ", array_merge([$newStatus], $contactIds));

    // Log bulk operation
    ContactHistory::create([
        'action' => 'bulk_status_update',
        'details' => json_encode(['count' => count($contactIds), 'new_status' => $newStatus]),
        'created_at' => date('Y-m-d H:i:s')
    ]);
});

// Batch processing with memory management
function processBulkContactUpdate($conditions, $updates) {
    $batchSize = 1000;
    $processed = 0;

    do {
        $contacts = Contact::all([
            'conditions' => $conditions,
            'limit' => $batchSize,
            'offset' => $processed
        ]);

        if (!empty($contacts)) {
            ActiveRecord\Connection::transaction(function() use ($contacts, $updates) {
                foreach ($contacts as $contact) {
                    $contact->update_attributes($updates);
                }
            });

            $processed += count($contacts);
            echo "Processed {$processed} contacts...\n";

            // Memory cleanup
            unset($contacts);
            gc_collect_cycles();
        }

    } while (count($contacts) === $batchSize);

    return $processed;
}
```

### Database Performance Monitoring

**Query Performance Analysis:**
```php
// Enable query logging for performance analysis
ActiveRecord\Connection::$logging = true;

// Measure query execution time
$startTime = microtime(true);
$contacts = Contact::all([
    'conditions' => ['status' => 'active'],
    'include' => ['account', 'deals'],
    'order' => 'created_at DESC',
    'limit' => 100
]);
$executionTime = microtime(true) - $startTime;

Logger::info("Query executed in {$executionTime} seconds");

// Analyze slow queries
function analyzeSlowQuery($sql, $executionTime) {
    if ($executionTime > 1.0) { // Queries taking more than 1 second
        $explainResult = ActiveRecord\Connection::connection()->query("EXPLAIN {$sql}");
        Logger::warning("Slow query detected", [
            'sql' => $sql,
            'execution_time' => $executionTime,
            'explain' => $explainResult->fetch_all(MYSQLI_ASSOC)
        ]);
    }
}
```

**Database Health Monitoring:**
```php
// Database connection pool monitoring
function checkDatabaseHealth() {
    $health = [
        'connection_status' => 'unknown',
        'query_response_time' => null,
        'active_connections' => null,
        'table_locks' => null
    ];

    try {
        // Test connection
        $startTime = microtime(true);
        $result = ActiveRecord\Connection::connection()->query("SELECT 1");
        $health['query_response_time'] = microtime(true) - $startTime;
        $health['connection_status'] = 'healthy';

        // Check active connections
        $processListResult = ActiveRecord\Connection::connection()->query("SHOW PROCESSLIST");
        $health['active_connections'] = $processListResult->num_rows;

        // Check for table locks
        $locksResult = ActiveRecord\Connection::connection()->query("SHOW OPEN TABLES WHERE In_use > 0");
        $health['table_locks'] = $locksResult->num_rows;

    } catch (Exception $e) {
        $health['connection_status'] = 'failed';
        $health['error'] = $e->getMessage();
    }

    return $health;
}

// Schedule regular health checks
function scheduleHealthCheck() {
    $healthData = checkDatabaseHealth();

    if ($healthData['connection_status'] !== 'healthy') {
        Logger::error('Database health check failed', $healthData);
        // Alert monitoring systems
        triggerDatabaseAlert($healthData);
    } elseif ($healthData['query_response_time'] > 0.5) {
        Logger::warning('Database response time degraded', $healthData);
    }

    // Store health metrics for trending
    DatabaseHealthMetric::create([
        'response_time' => $healthData['query_response_time'],
        'active_connections' => $healthData['active_connections'],
        'table_locks' => $healthData['table_locks'],
        'status' => $healthData['connection_status'],
        'created_at' => date('Y-m-d H:i:s')
    ]);
}
```

### Advanced Data Migration Patterns

**Zero-Downtime Migration Strategies:**
```php
// Online schema changes with minimal downtime
function performOnlineSchemaChange($tableName, $alterStatement) {
    // Create shadow table
    $shadowTable = $tableName . '_new';

    ActiveRecord\Connection::transaction(function() use ($tableName, $shadowTable, $alterStatement) {
        // Create new table with desired schema
        ActiveRecord\Connection::connection()->query("
            CREATE TABLE {$shadowTable} LIKE {$tableName}
        ");

        // Apply schema changes to shadow table
        ActiveRecord\Connection::connection()->query("
            ALTER TABLE {$shadowTable} {$alterStatement}
        ");

        // Copy data in batches
        copyDataInBatches($tableName, $shadowTable);

        // Atomic table swap
        ActiveRecord\Connection::connection()->query("
            RENAME TABLE
                {$tableName} TO {$tableName}_old,
                {$shadowTable} TO {$tableName}
        ");

        // Cleanup old table after verification
        // (should be done after thorough testing)
        // ActiveRecord\Connection::connection()->query("DROP TABLE {$tableName}_old");
    });
}

function copyDataInBatches($sourceTable, $targetTable, $batchSize = 10000) {
    $offset = 0;
    $totalCopied = 0;

    do {
        $copied = ActiveRecord\Connection::connection()->query("
            INSERT INTO {$targetTable}
            SELECT * FROM {$sourceTable}
            LIMIT {$batchSize} OFFSET {$offset}
        ")->affected_rows;

        $totalCopied += $copied;
        $offset += $batchSize;

        echo "Copied {$totalCopied} records...\n";
        usleep(100000); // 100ms pause between batches

    } while ($copied === $batchSize);

    return $totalCopied;
}
```

**Data Consistency Validation:**
```php
// Validate data consistency after migration
function validateDataConsistency($originalTable, $migratedTable) {
    $validationResults = [];

    // Row count validation
    $originalCount = ActiveRecord\Connection::connection()->query("SELECT COUNT(*) as count FROM {$originalTable}")->fetch_assoc()['count'];
    $migratedCount = ActiveRecord\Connection::connection()->query("SELECT COUNT(*) as count FROM {$migratedTable}")->fetch_assoc()['count'];

    $validationResults['row_count_match'] = ($originalCount === $migratedCount);
    $validationResults['original_count'] = $originalCount;
    $validationResults['migrated_count'] = $migratedCount;

    // Sample data validation
    $sampleValidation = ActiveRecord\Connection::connection()->query("
        SELECT
            (SELECT MD5(GROUP_CONCAT(CONCAT_WS('|', id, name, email) ORDER BY id))
             FROM {$originalTable} LIMIT 1000) as original_hash,
            (SELECT MD5(GROUP_CONCAT(CONCAT_WS('|', id, name, email) ORDER BY id))
             FROM {$migratedTable} LIMIT 1000) as migrated_hash
    ")->fetch_assoc();

    $validationResults['sample_data_match'] = ($sampleValidation['original_hash'] === $sampleValidation['migrated_hash']);

    // Foreign key consistency
    $fkValidation = ActiveRecord\Connection::connection()->query("
        SELECT COUNT(*) as orphaned_records
        FROM {$migratedTable} m
        LEFT JOIN accounts a ON m.account_id = a.id
        WHERE m.account_id IS NOT NULL AND a.id IS NULL
    ")->fetch_assoc();

    $validationResults['foreign_key_consistency'] = ($fkValidation['orphaned_records'] === 0);

    return $validationResults;
}
```

### Production Safety Protocols

**Backup and Recovery Procedures:**
```bash
# Pre-migration backup verification
verify_backup_before_migration() {
    local table_name="$1"
    local backup_file="backup_${table_name}_$(date +%Y%m%d_%H%M%S).sql"

    echo "Creating backup for table: $table_name"
    mysqldump --single-transaction --routines --triggers \
              --host="$DB_HOST" --user="$DB_USER" --password="$DB_PASS" \
              "$DB_NAME" "$table_name" > "$backup_file"

    # Verify backup file
    if [[ -f "$backup_file" && -s "$backup_file" ]]; then
        echo "Backup created successfully: $backup_file"
        # Test backup by attempting to parse it
        mysql --host="$DB_HOST" --user="$DB_USER" --password="$DB_PASS" \
              --execute="SET sql_mode=''; SOURCE $backup_file;" "$DB_NAME" --dry-run 2>/dev/null
        if [[ $? -eq 0 ]]; then
            echo "Backup validation successful"
            return 0
        else
            echo "Backup validation failed"
            return 1
        fi
    else
        echo "Backup creation failed"
        return 1
    fi
}

# Production deployment with rollback capability
deploy_with_rollback() {
    local migration_script="$1"
    local rollback_script="$2"

    echo "Starting production deployment..."

    # Create system backup
    if ! create_system_backup; then
        echo "System backup failed. Deployment aborted."
        return 1
    fi

    # Execute migration with monitoring
    if execute_monitored_migration "$migration_script"; then
        echo "Migration completed successfully"

        # Validation checks
        if validate_post_migration; then
            echo "Deployment successful"
            cleanup_old_backups
            return 0
        else
            echo "Post-migration validation failed. Initiating rollback..."
            execute_rollback "$rollback_script"
            return 1
        fi
    else
        echo "Migration failed. Initiating rollback..."
        execute_rollback "$rollback_script"
        return 1
    fi
}
```