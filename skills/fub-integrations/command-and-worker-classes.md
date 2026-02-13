# Command and Worker Classes

Background processing and command-line tools collectively owned and maintained by the **Zynaptic Overlords/FUB+ Integrations team**, organized by integration system and functionality.

## Integration Worker Classes

### ZillowSyncWorker.php
**File:** `apps/richdesk/extensions/command/ZillowSyncWorker.php`
**Database Tables:** `zillow_sync_users`, `contacts`, `zillow_agents`, `contact_sync_events`
**Command:** `li3 zillow_sync_worker`
**Methods:**
- `run()` - Execute Zillow sync operations
- `processAccount($accountId)` - Process single account sync
- `syncAgentData($agentId)` - Sync agent profile data
- `syncLeads($accountId)` - Sync lead information
- `handleSyncErrors($errors)` - Process sync failures
- `updateSyncStatus($accountId, $status)` - Update sync tracking

**Queue Integration:**
- Processes queued sync jobs
- Handles retry logic for failed syncs
- Implements exponential backoff
- Manages sync throttling

**StatsD Metrics Generated:**
- `fubweb.zillowSync.worker.started`
- `fubweb.zillowSync.worker.completed`
- `fubweb.zillowSync.worker.failed`
- `fubweb.zillowSync.worker.account_processed`

### ZhlTransferWorker.php
**File:** `apps/richdesk/extensions/command/ZhlTransferWorker.php`
**Database Tables:** `zhl_loan_officers`, `contacts`, `events`, `zhl_dedicated_loan_officer_map`
**Command:** `li3 zhl_transfer_worker`
**Methods:**
- `run()` - Execute ZHL transfer operations
- `processTransfer($transferData)` - Process loan officer transfer
- `validateTransferEligibility($contactId, $nmlsId)` - Validate transfer
- `executeTransfer($contactId, $loanOfficerId)` - Execute transfer
- `notifyTransferComplete($transferId)` - Send transfer notifications
- `handleTransferFailure($transferId, $error)` - Handle failed transfers

**Transfer Workflow:**
- Validates loan officer availability
- Checks territory restrictions
- Updates contact assignments
- Sends notification emails
- Logs transfer events

### BishopWorker.php
**File:** `apps/richdesk/extensions/command/BishopWorker.php`
**Database Tables:** `zillow_agents`, `zillow_sync_users`, `accounts`
**Command:** `li3 bishop_worker`
**Methods:**
- `run()` - Execute Bishop API operations
- `syncAgentProfiles()` - Sync agent profiles via Bishop
- `processAgentUpdates($updates)` - Process agent profile updates
- `handleBishopApiErrors($errors)` - Handle Bishop API errors
- `validateAgentMemberships()` - Validate agent MLS memberships

**Bishop API Integration:**
- Interfaces with Zillow Bishop service
- Manages agent profile synchronization
- Handles MLS membership validation
- Processes agent status updates

## Migration Command Classes

### Migration2024.php
**File:** `apps/richdesk/extensions/command/Migration2024.php`
**Purpose:** Database migrations for 2024 integration changes
**Methods:**
- `run()` - Execute 2024 migrations
- `updateZillowTagName()` - Update Zillow tag naming
- `migrateZhlData()` - Migrate ZHL loan officer data
- `updateIntegrationConfigs()` - Update integration configurations
- `cleanupObsoleteData()` - Remove obsolete integration data

**Migration Operations:**
- ZHL loan officer data migration
- Zillow tag name standardization
- Integration configuration updates
- Data cleanup operations

### Migration2025.php
**File:** `apps/richdesk/extensions/command/Migration2025.php`
**Purpose:** Database migrations for 2025 integration changes
**Methods:**
- `run()` - Execute 2025 migrations
- `replayZillowSyncEvents($configurable = true)` - Replay sync events
- `updateAuthenticationSchemas()` - Update auth table schemas
- `migrateOAuthApplications()` - Migrate OAuth applications
- `consolidateIntegrationTables()` - Consolidate integration tables

**Key Migration Features:**
- Configurable Zillow sync event replay
- OAuth application schema updates
- Authentication table migrations
- Integration table consolidation

## System Management Commands

### ZillowHomeLoans.php
**File:** `apps/richdesk/extensions/command/ZillowHomeLoans.php`
**Database Tables:** `zhl_loan_officers`, `zhl_dedicated_loan_officer_map`, `contacts`
**Command:** `li3 zillow_home_loans`
**Methods:**
- `run()` - Execute ZHL operations
- `syncLoanOfficers()` - Sync loan officer data
- `updateTerritoryMappings()` - Update territory assignments
- `processTransferQueue()` - Process pending transfers
- `validateDataIntegrity()` - Validate ZHL data integrity

**Data Management:**
- Loan officer synchronization
- Territory mapping updates
- Transfer queue processing
- Data integrity validation

### RegisteredSystems.php
**File:** `apps/richdesk/extensions/command/RegisteredSystems.php`
**Database Tables:** `registered_systems`, `oauth_applications`, `accounts`
**Command:** `li3 registered_systems`
**Methods:**
- `run()` - Execute system registration operations
- `registerSystem($systemData)` - Register new system
- `updateSystemConfig($systemId, $config)` - Update system configuration
- `deactivateSystem($systemId)` - Deactivate system registration
- `validateSystemHealth()` - Check system health status

## Utility and Helper Commands

### Accounts.php (Integration-related methods)
**File:** `apps/richdesk/extensions/command/Accounts.php`
**Database Tables:** `accounts`, `zillow_auth`, `oauth_applications`
**Integration Methods:**
- `setupIntegrations($accountId)` - Setup account integrations
- `migrateIntegrationData($fromAccountId, $toAccountId)` - Migrate integration data
- `validateIntegrationHealth($accountId)` - Validate integration health
- `cleanupIntegrationData($accountId)` - Cleanup integration data

### Dev.php (Development utilities)
**File:** `apps/richdesk/extensions/command/Dev.php`
**Integration Testing Methods:**
- `testZillowIntegration($accountId)` - Test Zillow integration
- `testOAuthFlow($integration)` - Test OAuth flows
- `validateWebhooks($integration)` - Validate webhook endpoints
- `generateTestData($integration)` - Generate test integration data

## Queue Command Base Classes

### QueueCommand.php
**File:** `apps/richdesk/extensions/console/QueueCommand.php`
**Purpose:** Base class for queue-based workers
**Methods:**
- `processJob($job)` - Process individual queue job
- `handleJobFailure($job, $error)` - Handle job failures
- `retryJob($job, $delay)` - Retry failed jobs
- `logJobMetrics($job, $status)` - Log job processing metrics

**Queue Integration:**
- Job processing framework
- Retry logic implementation
- Error handling patterns
- Metrics collection

### Command.php (Base class)
**File:** `apps/richdesk/extensions/console/Command.php`
**Purpose:** Base command class for integration commands
**Methods:**
- `validateAccountId($accountId)` - Validate account access
- `logCommandExecution($command, $status)` - Log command execution
- `handleCommandError($error)` - Handle command errors
- `sendCommandNotification($message)` - Send command notifications

## Command Execution Patterns

### Account Scoping in Commands
```php
// Pattern used in integration commands
protected function validateAccountAccess(int $accountId): bool
{
    $account = Account::find($accountId);
    if (!$account) {
        $this->error("Account {$accountId} not found");
        return false;
    }

    // Additional validation for integration commands
    if (!$account->hasIntegrationAccess()) {
        $this->error("Account {$accountId} does not have integration access");
        return false;
    }

    return true;
}
```

### Error Handling in Workers
```php
// Standard error handling pattern
protected function handleWorkerError(Exception $e, array $context = [])
{
    // Log error with context
    Logger::error('Worker error', array_merge([
        'worker' => get_class($this),
        'error' => $e->getMessage(),
        'trace' => $e->getTraceAsString()
    ], $context));

    // Record metrics
    StatsD::increment('worker.error', 1, 1, [
        'worker' => $this->getWorkerName(),
        'error_type' => get_class($e)
    ]);

    // Send alert if critical
    if ($this->isCriticalError($e)) {
        $this->sendErrorAlert($e, $context);
    }
}
```

### Job Processing Pattern
```php
// Queue job processing pattern
public function processJob(array $jobData): bool
{
    $startTime = microtime(true);

    try {
        // Validate job data
        $this->validateJobData($jobData);

        // Process job
        $result = $this->executeJob($jobData);

        // Log success
        $this->logJobSuccess($jobData, $result, $startTime);

        return true;

    } catch (Exception $e) {
        // Log failure
        $this->logJobFailure($jobData, $e, $startTime);

        // Determine retry strategy
        if ($this->shouldRetryJob($e, $jobData)) {
            $this->retryJob($jobData);
        }

        return false;
    }
}
```

## Command Testing Integration

### Worker Test Files
**Test files maintained by team:**
- `apps/richdesk/tests/integration/extensions/command/ZillowSyncWorkerTest.php`
- `apps/richdesk/tests/integration/extensions/command/ZhlTransferWorkerTest.php`
- `apps/richdesk/tests/unit/extensions/command/ZillowHomeLoansTest.php`

### Command Test Patterns
```php
// Worker testing pattern
class ZillowSyncWorkerTest extends CommandTestCase
{
    public function testWorkerProcessesAccount()
    {
        // Arrange
        $accountId = $this->createTestAccount();
        $this->setupZillowAuth($accountId);

        $worker = new ZillowSyncWorker();

        // Act
        $result = $worker->processAccount($accountId);

        // Assert
        $this->assertTrue($result);
        $this->assertSyncEventsCreated($accountId);
    }
}
```

## Command Scheduling and Execution

### Cron Integration
**Commands run via cron:**
- `ZillowSyncWorker` - Every 15 minutes
- `ZhlTransferWorker` - Every 30 minutes
- `BishopWorker` - Hourly
- Migration commands - On deployment

### Queue Integration
**Commands using queue system:**
- Account-specific sync operations
- Bulk data migration commands
- Integration health checks
- Webhook processing commands

### Command Monitoring
**StatsD Metrics for Commands:**
- `command.{command_name}.started`
- `command.{command_name}.completed`
- `command.{command_name}.failed`
- `command.{command_name}.duration`

## Performance Considerations

### Batch Processing
- Process records in configurable batches
- Implement memory management for large datasets
- Use chunked database queries
- Monitor memory usage during execution

### Rate Limiting
- Respect external API rate limits
- Implement backoff strategies
- Queue operations when limits reached
- Monitor rate limit consumption

### Resource Management
- Connection pooling for database operations
- Proper cleanup of temporary resources
- Memory leak prevention
- CPU usage monitoring

## Command Configuration

### Environment-Specific Settings
**Configuration files:**
- Development: Local database connections
- QA: Staging API endpoints
- Production: Production API credentials

### Integration Settings
**Common configuration needs:**
- OAuth client credentials
- API endpoint URLs
- Webhook secret keys
- Rate limit thresholds
- Retry configurations

When working with command and worker classes:
1. **Use account scoping** in all integration commands
2. **Implement proper error handling** with metrics and alerting
3. **Follow queue patterns** for background processing
4. **Test with proper fixtures** and mock external services
5. **Monitor command performance** with appropriate metrics
6. **Handle rate limits** and external API constraints