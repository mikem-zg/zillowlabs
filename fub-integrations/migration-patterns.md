# FUB Migration Patterns

Common database migration patterns and examples from the FUB codebase.

## Migration File Naming Convention

```
{database}-{date}-before.{description}.sql
```

Examples:
- `client-2024-07-16-before.zhl-loan-officers-migrations.sql`
- `common-2024-08-21-before.ucom-1094-create-account-business-registration-audit-log-attachments-table.sql`

## Client Database Migration Patterns

### Adding Columns to Existing Tables
```sql
-- Add new columns with proper positioning
ALTER TABLE `contacts`
ADD COLUMN `zillow_profile_url` VARCHAR(255) AFTER `email`,
ADD COLUMN `zillow_agent_id` INT(11) AFTER `zillow_profile_url`;

-- Add indexes for new columns
CREATE INDEX idx_contacts_zillow_agent
ON contacts(account_id, zillow_agent_id);
```

### Creating New Tables
```sql
-- Client table with standard structure
CREATE TABLE `zillow_agents` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `account_id` INT(11) NOT NULL,
    `user_id` INT(11) DEFAULT NULL,
    `encrypted_zuid` VARCHAR(255) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `phone` VARCHAR(20) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `account_id` (`account_id`),
    KEY `idx_zillow_agents_account_user` (`account_id`, `user_id`),
    FOREIGN KEY (`account_id`) REFERENCES `accounts`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Adding Indexes for Performance
```sql
-- Composite indexes for common query patterns
ALTER TABLE `contacts`
ADD INDEX `idx_contacts_account_created` (`account_id`, `created_at`),
ADD INDEX `idx_contacts_account_status` (`account_id`, `status`);

-- Index for timeline queries
ALTER TABLE `events`
ADD INDEX `idx_events_account_contact_created` (`account_id`, `contact_id`, `created_at`);
```

## Common Database Migration Patterns

### System Configuration Tables
```sql
-- Common database tables don't need account_id
CREATE TABLE `registered_systems` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `system_type` VARCHAR(50) NOT NULL,
    `api_version` VARCHAR(20) DEFAULT NULL,
    `is_active` TINYINT(1) DEFAULT 1,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_system_name` (`name`),
    KEY `idx_system_type_active` (`system_type`, `is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Authentication and Security Tables
```sql
-- OAuth applications (common database)
CREATE TABLE `oauth_applications` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `client_id` VARCHAR(255) NOT NULL,
    `client_secret` VARCHAR(255) NOT NULL,
    `redirect_uri` TEXT,
    `scopes` TEXT,
    `is_active` TINYINT(1) DEFAULT 1,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_client_id` (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

## Migration Command Usage

### Creating Migration Files
```bash
# Client database migration
li3 migration client before feature-branch-name

# Common database migration
li3 migration common before feature-branch-name
```

### Migration File Locations
- Client migrations: `/richdesk/resources/sql/updates/client-YYYY-MM-DD-before.*.sql`
- Common migrations: `/richdesk/resources/sql/updates/common-YYYY-MM-DD-before.*.sql`

### Running Migrations
```bash
# Deploy with migrations included
./bin/deploy-dev.sh

# Run migrations only
li3 runMigrations
```

## Migration Best Practices

### 1. Always Include Rollback Considerations
```sql
-- Include comments about rollback impact
-- ROLLBACK NOTE: This column can be dropped safely if needed
ALTER TABLE `contacts`
ADD COLUMN `external_system_id` VARCHAR(100) AFTER `email`;
```

### 2. Use Proper Data Types
```sql
-- Use appropriate types and sizes
`account_id` INT(11) NOT NULL,           -- Foreign key
`status` VARCHAR(20) NOT NULL,           -- Status/enum values
`email` VARCHAR(255) NOT NULL,           -- Email addresses
`description` TEXT,                      -- Long text content
`is_active` TINYINT(1) DEFAULT 1,       -- Boolean flags
`created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Timestamps
```

### 3. Foreign Key Constraints
```sql
-- Add foreign key constraints for data integrity
ALTER TABLE `zillow_agents`
ADD CONSTRAINT `fk_zillow_agents_account`
FOREIGN KEY (`account_id`) REFERENCES `accounts`(`id`) ON DELETE CASCADE,
ADD CONSTRAINT `fk_zillow_agents_user`
FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL;
```

### 4. Index Strategy
```sql
-- Primary access patterns
KEY `account_id` (`account_id`),                    -- Account filtering
KEY `idx_created_at` (`created_at`),               -- Time-based queries
KEY `idx_account_status` (`account_id`, `status`), -- Combined filtering
KEY `idx_account_user` (`account_id`, `user_id`);  -- User-scoped queries
```

## Integration-Specific Migration Patterns

### Zillow Integration
```sql
-- Zillow authentication table
CREATE TABLE `zillow_auth` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `account_id` INT(11) NOT NULL,
    `zillow_agent_id` INT(11) DEFAULT NULL,
    `zuid` VARCHAR(100) DEFAULT NULL,
    `oauth_token` TEXT,
    `oauth_refresh_token` TEXT,
    `token_expires_at` TIMESTAMP NULL DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `account_id` (`account_id`),
    KEY `idx_zillow_auth_agent` (`zillow_agent_id`),
    UNIQUE KEY `unique_account_zuid` (`account_id`, `zuid`),
    FOREIGN KEY (`account_id`) REFERENCES `accounts`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`zillow_agent_id`) REFERENCES `zillow_agents`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### ZHL Integration
```sql
-- ZHL loan officer mapping
CREATE TABLE `zhl_loan_officers` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `account_id` INT(11) NOT NULL,
    `user_id` INT(11) DEFAULT NULL,
    `nmls_id` VARCHAR(50) NOT NULL,
    `first_name` VARCHAR(100) NOT NULL,
    `last_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `phone` VARCHAR(20) DEFAULT NULL,
    `is_active` TINYINT(1) DEFAULT 1,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `account_id` (`account_id`),
    KEY `idx_zhl_nmls` (`nmls_id`),
    UNIQUE KEY `unique_account_nmls` (`account_id`, `nmls_id`),
    FOREIGN KEY (`account_id`) REFERENCES `accounts`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

## Data Migration Scripts

### Batch Processing Pattern
```sql
-- Process data in batches for large tables
UPDATE contacts
SET zillow_agent_id = (
    SELECT za.id
    FROM zillow_agents za
    WHERE za.account_id = contacts.account_id
    AND za.email = contacts.agent_email
)
WHERE account_id BETWEEN 1000 AND 2000
AND zillow_agent_id IS NULL
LIMIT 1000;
```

### Validation Queries
```sql
-- Verify migration success
SELECT
    COUNT(*) as total_contacts,
    COUNT(zillow_agent_id) as mapped_contacts,
    (COUNT(zillow_agent_id) * 100.0 / COUNT(*)) as mapping_percentage
FROM contacts
WHERE account_id = ?;
```

## Common Migration Issues

### 1. Character Set Conflicts
```sql
-- Ensure consistent character sets
ALTER TABLE `table_name`
CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 2. Index Length Limits
```sql
-- Handle long varchar indexes
CREATE INDEX idx_long_field ON table_name(long_field(191));  -- Limit to 191 chars for utf8mb4
```

### 3. Foreign Key Constraint Errors
```sql
-- Temporarily disable constraints for data migration
SET FOREIGN_KEY_CHECKS = 0;
-- Perform migration
SET FOREIGN_KEY_CHECKS = 1;
```

### 4. Timeline for Large Migrations
```sql
-- Check table size before migration
SELECT
    table_name,
    table_rows,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) as 'Size (MB)'
FROM information_schema.tables
WHERE table_schema = DATABASE()
AND table_name = 'contacts';
```

When creating new migrations:
1. Follow naming conventions
2. Include proper indexes
3. Use foreign key constraints
4. Test on development data first
5. Consider rollback scenarios
6. Document any special considerations