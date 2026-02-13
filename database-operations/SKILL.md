---
name: database-operations
description: Execute safe database changes and connections for FUB's MySQL/MariaDB infrastructure with transaction management, connection management, testing, performance validation, and mandatory approval processes
---

## Overview

Execute safe database changes and connections for FUB's MySQL/MariaDB infrastructure with comprehensive safety protocols, transaction management, and mandatory approval processes for production operations. Provides secure access to both common (shared) and client (account-specific) databases across development, QA, and production environments.

📊 **ActiveRecord Patterns**: [patterns/activerecord-patterns.md](patterns/activerecord-patterns.md)
🚀 **Advanced Operations**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
⚡ **Caching System**: [reference/caching-system.md](reference/caching-system.md)
🔗 **Integration Workflows**: [workflows/integration-workflows.md](workflows/integration-workflows.md)

## Usage

```bash
/database-operations --environment=<env> [--database_type=<type>] [--account_id=<id>] [--operation=<op>] [--approve_destructive=<bool>] [--backup_required=<bool>] [--issue=<ref>]
```

## Examples

```bash
# Safe database inspection in development environment
/database-operations --environment="development" --operation="inspection"

# Schema migration with backup in QA environment
/database-operations --environment="qa" --operation="schema-migration" --backup_required=true --issue="PROJ-1234"

# Production data fix with explicit destructive approval
/database-operations --environment="production" --operation="data-fix" --approve_destructive=true --backup_required=true --issue="ZYN-10585"

# Query optimization analysis in development
/database-operations --environment="development" --operation="query-optimization" --issue="Optimize Contact queries"

# Client database connection for specific account
/database-operations --environment="production" --database_type="client" --account_id="12345" --operation="inspection"

# Database maintenance in QA environment
/database-operations --environment="qa" --operation="maintenance" --backup_required=true

# Connection testing across all environments
/database-operations --environment="development" --operation="connection"
```

## Core Workflow

### Essential Operations (Most Common - 90% of Usage)

**1. Environment and Database Type Resolution**
```bash
# Verify environment and database access
Environment: development|qa|production
Database Type: common (shared) | client (account-specific)
Account ID: Required for client database access
```

**2. ActiveRecord Connection Establishment**
```php
// FUB uses ActiveRecord connections via ArConnections
// Development common database connection
ArConnections::add('common', [
    'type' => 'ActiveRecord',
    'adapter' => 'MySql',
    'host' => 'unix(/var/run/proxysql/myproxysql.sock)',
    'login' => 'crm_common',
    'password' => 'Common1pass!',
    'database' => 'common',
]);

// Client database credential lookup via Account model
$account = Account::find($accountId);
echo $account->db_host.'|'.$account->db_database.'|'.$account->db_user;
```

**3. Safe ActiveRecord Operations with FUB Patterns**
```php
// CORRECT: FUB ActiveRecord Patterns
// Hash syntax for simple equality (preferred)
$users = User::find('all', [
    'conditions' => ['email' => $email, 'status' => $status],
    'order' => 'name ASC'
]);

// Placeholder syntax for complex conditions
$contacts = Contact::find('all', [
    'conditions' => ['account_id = ? AND created_at > ?', $accountId, $date]
]);

// Creating records
$contact = Contact::create([
    'name' => $name,
    'email' => $email,
    'account_id' => $accountId
]);
```

→ **Complete ActiveRecord patterns**: [patterns/activerecord-patterns.md](patterns/activerecord-patterns.md)

**4. ActiveRecord Transaction Management**
```php
// FUB Transaction Pattern
ActiveRecord\Connection::transaction(function() use ($contactId, $userId) {
    $contact = Contact::find($contactId);
    $contact->status = 'archived';
    $contact->save();

    ContactHistory::create([
        'contact_id' => $contactId,
        'action' => 'archived',
        'performed_by' => $userId
    ]);
});
```

**5. Operation Type Classification and Safety Checks**
- **SAFE Operations**: `find()`, `count()`, `DESCRIBE`, `SHOW`, `EXPLAIN` (no approval required)
- **DESTRUCTIVE Operations**: `delete()`, `update_all()`, schema changes (require `approve_destructive=true`)
- **Automatic SQL injection prevention via ActiveRecord parameterization**
- **Mandatory backup verification for production operations**

## Quick Reference

### MySQL Connectivity Solution

**Problem Solved:** The integrated `fub-db.sh` script eliminates MySQL connection failures through automated credential management and connection handling.

**Subcommands:**
- **`connect`** - Interactive MySQL session
- **`credentials`** - Show connection details for automation
- **`query`** - Execute SQL and return results
- **`cache`** - Manage query result cache
- **`list-tables`** - List all tables in database (cached, environment defaults to dev)
- **`list-columns`** - List columns for a given table (cached, environment defaults to dev)

**Usage for Claude Code Automation:**
```bash
# Get connection details for automation (Claude Code friendly)
./.claude/skills/database-operations/scripts/fub-db.sh credentials dev common
./.claude/skills/database-operations/scripts/fub-db.sh credentials dev client 12345

# Execute queries directly (perfect for Claude Code workflows)
./.claude/skills/database-operations/scripts/fub-db.sh query dev common "SHOW TABLES"
./.claude/skills/database-operations/scripts/fub-db.sh query dev client 12345 "SELECT COUNT(*) FROM contacts"

# List database tables with caching (new functionality)
./.claude/skills/database-operations/scripts/fub-db.sh list-tables common                    # defaults to dev
./.claude/skills/database-operations/scripts/fub-db.sh list-tables qa common
./.claude/skills/database-operations/scripts/fub-db.sh list-tables client                  # auto-discover client DB

# List table columns with caching (new functionality)
./.claude/skills/database-operations/scripts/fub-db.sh list-columns common accounts        # defaults to dev
./.claude/skills/database-operations/scripts/fub-db.sh list-columns qa client 123 users
./.claude/skills/database-operations/scripts/fub-db.sh list-columns client contacts        # auto-discover client DB
```

### Script Usage
```bash
# Use the database-operations integrated script for all MySQL connections
./.claude/skills/database-operations/scripts/fub-db.sh <subcommand> <environment> <database-type> [account-id] [sql]

# Connect subcommand (interactive MySQL session)
./.claude/skills/database-operations/scripts/fub-db.sh connect dev common
./.claude/skills/database-operations/scripts/fub-db.sh connect qa client 12345

# Credentials subcommand (Claude Code friendly - shows connection details)
./.claude/skills/database-operations/scripts/fub-db.sh credentials dev common
./.claude/skills/database-operations/scripts/fub-db.sh credentials qa client 12345

# Query subcommand (execute SQL and return results)
./.claude/skills/database-operations/scripts/fub-db.sh query dev common "SELECT COUNT(*) FROM accounts"
./.claude/skills/database-operations/scripts/fub-db.sh query dev client 12345 "SELECT COUNT(*) FROM contacts"
```

**Integration with Claude Code Database Operations:**
```plain
# Use integrated script within database-operations skill workflows
/database-operations --environment="dev" --database_type="client" --account_id="12345" --operation="inspection"

# The skill will automatically use the integrated fub-db.sh script for connections
/database-operations --environment="qa" --database_type="common" --operation="query-optimization" --issue="Performance analysis"
```

**Connection Workflow Decision Tree:**
- **Known account ID + client data needed** → Use automated client database connection
- **Common database operations** → Use automated common database connection
- **Complex operations requiring multiple connections** → Use full database-operations skill workflow
- **Production environment** → Follow established production database protocols

**Safety Features:**
- Automatic environment validation (dev/qa/production)
- Account existence verification before connection attempts
- Proper SSH agent forwarding for secure remote connections
- Error handling with clear feedback for failed connections
- SSH authentication error recovery using Remote Connectivity Management Skill

**Enhanced SSH Connection Error Handling:**
If database operations fail with SSH or connectivity errors:
1. **Interactive SSH troubleshooting**: `claude /remote-connectivity-management --operation=troubleshoot --interactive=true`
2. **Quick SSH validation**: `claude /remote-connectivity-management --operation=key-check`
3. **VPN conflict detection**: `claude /remote-connectivity-management --operation=cisco-conflict-detect`
4. **Network diagnostics**: `claude /remote-connectivity-management --operation=vpn-status`

## Caching System

The database-operations skill includes an intelligent caching system to improve performance for schema queries.

### Cached Operations
- `SHOW TABLES` - Results cached per database
- `DESCRIBE table_name` - Results cached per table
- `SHOW COLUMNS FROM table_name` - Results cached per table (same as DESCRIBE)
- Schema queries are cached indefinitely until invalidated

### Cache Management Commands
```bash
# Show cache status
./.claude/skills/database-operations/scripts/fub-db.sh cache dev common status

# Clear all caches for a database
./.claude/skills/database-operations/scripts/fub-db.sh cache dev common clear

# Clear cache for specific table
./.claude/skills/database-operations/scripts/fub-db.sh cache dev common clear-table accounts
```

→ **Complete caching system guide**: [reference/caching-system.md](reference/caching-system.md)

## Migration Commands (FUB Lithium Framework)

```bash
# Create migration
li3 migration client before <branch-name>    # Client database
li3 migration common before <branch-name>    # Common database

# Deploy locally (includes migrations)
./bin/deploy-dev.sh

# Run migrations only
li3 runMigrations

# Migration files location
/richdesk/resources/sql/updates
```

## Common Troubleshooting

| **Issue** | **Symptoms** | **Solution** |
|-----------|-------------|--------------|
| **ActiveRecord Connection Failed** | Class not found, connection error | Verify `ArConnections::add()` configuration |
| **Account Model Not Found** | Account::find() fails | Ensure bootstrap.php loaded, verify account ID |
| **Client DB Access Denied** | Authentication error | Check Account model db_* fields populated |
| **Migration Stuck** | li3 runMigrations hangs | Check `common.db_updates` table, clear stale entries |
| **SSH Connection Failed** | Cannot reach fubdev/QA | Run `claude /remote-connectivity-management --operation=troubleshoot --interactive=true` for comprehensive diagnostics |

## Advanced Patterns

<details>
<summary>Click to expand comprehensive database operations workflow and advanced database management methodologies</summary>

### Comprehensive Database Operations Workflow

**Database Connection Management and Access Resolution:**
Advanced environment-specific connection configuration for development, QA, and production environments with automated credential resolution and safety protocols.

**Operation Type Inference and ActiveRecord Safety Classification:**
Sophisticated analysis and classification of ActiveRecord operations with automatic safety classification, injection vulnerability detection, and transaction management pattern documentation.

**FUB Performance Optimization Analysis:**
Advanced MySQL query execution plan generation, missing index identification, query execution time monitoring, and performance baseline establishment for FUB workloads.

**Migration Development for FUB Schema Changes:**
Comprehensive schema migration best practices with batch processing for large datasets, transaction management with appropriate isolation levels, and rollback scenario planning.

🚀 **Complete advanced patterns**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
📊 **ActiveRecord patterns**: [patterns/activerecord-patterns.md](patterns/activerecord-patterns.md)

</details>

## Integration Points

### Cross-Skill Workflow Patterns

**Database Operations → Support Investigation:**
```bash
# Investigate data inconsistencies found during database operations
database-operations --operation="data-validation" --account_id="12345" |
  support-investigation --issue="Data integrity issue found in account 12345"

# Validate database fixes with production monitoring
database-operations complete_data_fix |
  datadog-management --analysis_type="database" --service="fub-api"
```

**Database Operations → Backend Testing:**
```bash
# Test database changes with comprehensive test suite
database-operations --operation="schema-migration" --environment="development" |
  backend-test-development --target="DatabaseTestCase" --test_type="integration"

# Validate migration rollback procedures
database-operations test_rollback_procedures |
  backend-test-development --test_type="migration"
```

**Database Operations → Performance Monitoring:**
```bash
# Monitor database performance after optimization changes
database-operations --operation="query-optimization" |
  datadog-management --analysis_type="performance" --service="mysql"

# Create alerts for database performance degradation
database-operations document_performance_baselines |
  datadog-management --operation="create_monitor" --alert_type="database_performance"
```

### Related Skills

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| `support-investigation` | **Data Analysis** | Investigate database-related issues, validate data integrity, correlate database changes with system issues |
| `backend-test-development` | **Testing Integration** | Run database tests, validate migrations, test ActiveRecord models and queries |
| `datadog-management` | **Performance Monitoring** | Monitor database performance, track query execution times, alert on database issues |
| `serena-mcp` | **Code Analysis** | Analyze ActiveRecord model changes, review database-related code, find model relationships |
| `development-investigation` | **Architecture Planning** | Schema design, performance planning, migration strategy |

### Multi-Skill Operation Examples

**Complete Database Change Workflow:**
1. `database-operations` - Plan and execute database schema changes with safety validation
2. `backend-test-development` - Run comprehensive tests to validate database changes
3. `datadog-management` - Monitor database performance and application health
4. `support-investigation` - Validate production impact and investigate any issues
5. `serena-mcp` - Review and update related ActiveRecord model code

→ **Complete integration workflows**: [workflows/integration-workflows.md](workflows/integration-workflows.md)

## Refusal Conditions

The skill must refuse if:
- Destructive ActiveRecord operations requested without explicit approval (approve_destructive=false)
- SQL injection vulnerabilities detected in proposed ActiveRecord queries
- FUB database infrastructure not available or properly configured
- Required FUB backup procedures not in place for production operations
- Transaction safety cannot be guaranteed for the operation
- Performance impact analysis shows unacceptable degradation for FUB workload
- Parameterized queries cannot be used with FUB's ActiveRecord framework
- FUB environment verification fails or credentials are insufficient
- Operations would conflict with FUB's ActiveRecord model architecture or data model
- **ActiveRecord Connection Issues**:
  - SSH access to target environment (fubdev, QA via Tailscale) is not available
  - Account ID required for client database access but not provided or invalid
  - ActiveRecord credential lookup fails (account not found, missing configuration)
  - Tailscale connectivity unavailable for QA environment access
  - ArConnections validation fails (host unreachable, authentication error)
  - VPN conflicts prevent stable SSH connections to database servers

When refusing, explain the specific FUB safety requirement preventing execution and provide detailed steps to resolve the issue safely, including:
- How to enable proper approval parameters for FUB operations
- Steps to implement parameterized queries with FUB's ActiveRecord framework
- FUB-specific backup verification procedures
- Performance optimization recommendations for FUB's workload
- FUB security configuration requirements
- **ActiveRecord Connection Management Resolution Steps**:
  - Enhanced SSH troubleshooting: `claude /remote-connectivity-management --operation=troubleshoot --interactive=true`
  - Steps to obtain valid account ID for client database operations
  - VPN conflict resolution: `claude /remote-connectivity-management --operation=cisco-conflict-detect`
  - Network diagnostics: `claude /remote-connectivity-management --operation=vpn-status`
  - ActiveRecord credential lookup troubleshooting and validation
  - Alternative connection methods when primary ArConnections access fails

**Critical Safety Note**: Database operations prioritize FUB's data safety, security, and integrity above all other considerations. When in doubt about safety for FUB's infrastructure, always err on the side of caution and request additional verification or explicit approval before proceeding with any operation.