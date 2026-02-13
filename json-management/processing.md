# JSON Processing with jq for FUB Development

Practical jq operations for daily JSON processing tasks in FUB development workflows.

## Essential jq Operations for FUB

### Basic jq Syntax and Patterns

**Core jq operations for FUB development:**
```bash
# Extract values from FUB API responses
jq '.data[].username' api-response.json
jq '.users[] | select(.role == "admin")' users.json
jq '.database.host' apps/richdesk/config/production.json

# Transform object structure for FUB data
jq '{id: .user_id, name: .username, email: .email}' users.json
jq '.contacts[] | {name: .full_name, email: .email_address}' contacts.json

# Filter and count for FUB metrics
jq '[.users[] | select(.is_active == true)] | length' users.json
jq '.contacts[] | select(.account_id == "123")' contacts.json
```

**FUB-specific data extraction patterns:**
```bash
# Extract FUB user information
jq '.data[] | {id, username, email, account_id, role}' fub-users.json

# Process FUB contact data
jq '.contacts[] | select(.status == "active") | {name, email, phone, account_id}' contacts.json

# Extract configuration by environment
jq --arg env "production" '.environments[$env].database' config.json

# Get array lengths for FUB data validation
jq '{user_count: (.users | length), contact_count: (.contacts | length)}' data.json
```

## Package.json Processing

### FUB Frontend Dependencies

**Analyze package.json for FUB projects:**
```bash
# List all dependencies
jq '.dependencies | keys[]' apps/richdesk/frontend/package.json

# Check for specific FUB requirements
jq '.dependencies | has("react") and has("typescript")' package.json

# Extract React-related packages
jq '.dependencies | with_entries(select(.key | contains("react")))' package.json

# Validate required scripts exist
jq '.scripts | has("build") and has("test") and has("dev")' package.json
```

**Package.json transformations for FUB:**
```bash
# Update dependency version
jq '.dependencies.react = "^18.0.0"' package.json > updated-package.json

# Add FUB-specific scripts
jq '.scripts["fub:test"] = "jest --config=fub.config.js"' package.json

# Extract essential package info
jq '{name, version, dependencies: .dependencies}' package.json

# Merge dependency lists for analysis
jq -s 'map(.dependencies) | add' */package.json
```

### Script and Configuration Analysis

**FUB project script management:**
```bash
# Find all test scripts
jq '.scripts | to_entries[] | select(.key | contains("test"))' package.json

# Extract build configurations
jq '.scripts | with_entries(select(.key | startswith("build")))' package.json

# Check for required FUB scripts
jq 'if (.scripts | has("test") and has("build")) then "valid" else "missing scripts" end' package.json

# Extract linting and formatting config
jq '{eslintConfig, prettier, jest}' package.json
```

## FUB API Response Processing

### User and Contact Data

**Process FUB API responses:**
```bash
# Extract user data from FUB API
jq '.data[] | {
  id: .user_id,
  username,
  email,
  account: .account_id,
  active: .is_active
}' users-api.json

# Filter active users by role
jq '.data[] | select(.is_active == true and .role == "admin")' users.json

# Process contact information
jq '.contacts[] | {
  id: .contact_id,
  name: .full_name,
  email: .email_address,
  phone: .phone_number,
  account_id
}' contacts-api.json

# Extract contact tags and status
jq '.contacts[] | select(.status == "active") | {name: .full_name, tags}' contacts.json
```

### Configuration and Settings

**FUB configuration processing:**
```bash
# Extract database settings
jq '.database | {host, database: .name, port}' apps/richdesk/config/production.json

# Process API configuration
jq '.api | {base_url, timeout, version}' config.json

# Extract cache settings
jq '.cache | {driver, host: .redis.host, ttl}' config.json

# Get feature flags
jq '.features | to_entries[] | select(.value == true) | .key' features.json
```

## Data Transformation and Aggregation

### Basic FUB Data Processing

**Common FUB data transformations:**
```bash
# Group users by account
jq 'group_by(.account_id) | map({account: .[0].account_id, users: length})' users.json

# Calculate contact conversion rates
jq 'group_by(.source) | map({
  source: .[0].source,
  total: length,
  converted: [.[] | select(.status == "customer")] | length
})' contacts.json

# Process FUB metrics by date
jq --arg date "2024-01" '
  map(select(.created_at | startswith($date))) |
  {count: length, accounts: [.[].account_id] | unique | length}
' data.json

# Extract active accounts
jq '[.users[] | .account_id] | unique' users.json
```

### Test Data Processing

**FUB test data operations:**
```bash
# Validate test user structure
jq '.test_users[] | select(has("user_id") and has("username") and has("email"))' test-data.json

# Generate test contact data
jq -n '{
  contacts: [
    range(1; 6) | {
      contact_id: .,
      name: ("Test Contact " + (. | tostring)),
      email: ("contact" + (. | tostring) + "@test.fub.com"),
      account_id: "test-account"
    }
  ]
}'

# Check FUB API response format
jq 'if (has("data") and has("meta")) then "valid" else "invalid format" end' api-response.json

# Extract test data by type
jq '.test_data | {users: .users, contacts: .contacts} | map_values(length)' test-file.json
```

## Common FUB Workflows

### Multi-file Processing

**Combine FUB data sources:**
```bash
# Merge user and contact data by account
jq -s '
  .[0].users[] as $user |
  .[1].contacts[] as $contact |
  if $user.account_id == $contact.account_id then
    {account: $user.account_id, user: $user.username, contact: $contact.name}
  else empty end
' users.json contacts.json

# Process multiple configuration files
jq -s 'map(keys[]) | unique' config/*.json

# Aggregate data from multiple sources
jq -s '{
  total_users: (.[0].users | length),
  total_contacts: (.[1].contacts | length),
  accounts: ([.[0].users[].account_id] + [.[1].contacts[].account_id] | unique | length)
}' users.json contacts.json
```

### Reporting and Analysis

**Generate FUB reports:**
```bash
# Account activity summary
jq 'group_by(.account_id) | map({
  account: .[0].account_id,
  user_count: length,
  last_active: [.[].last_login] | max
})' activity.json

# Email campaign performance
jq '.campaigns[] | {
  name: .campaign_name,
  sent: .stats.sent,
  opened: .stats.opened,
  open_rate: (.stats.opened / .stats.sent * 100 | floor)
}' campaigns.json

# User access audit
jq '.access_logs[] | select(.timestamp > (now - 7*24*3600)) | {username, action, timestamp}' logs.json
```

## Troubleshooting and Best Practices

### Handle Missing Data

**Safe jq operations for FUB data:**
```bash
# Provide default values for missing fields
jq '.users[] | {
  id: .user_id // "unknown",
  name: .username // "no-name",
  email: .email // "no-email@fub.com"
}' users.json

# Filter out null or empty values
jq '.contacts[] | select(.email != null and .email != "")' contacts.json

# Handle optional fields safely
jq '.[] | {
  required: {id, name},
  optional: {phone: (.phone // null), tags: (.tags // [])}
}' data.json
```

### Debug jq Expressions

**Step-by-step debugging for FUB data:**
```bash
# Test expressions step by step
jq '.users[]' data.json | head -3                                    # Step 1: extract
jq '.users[] | select(.account_id == "123")' data.json | head -3     # Step 2: filter
jq '.users[] | select(.account_id == "123") | {id, name}' data.json  # Step 3: transform

# Check data types
jq '.users[0] | to_entries[] | {key, type: (.value | type)}' data.json

# Validate JSON structure
jq 'if type == "object" then "object" else "invalid" end' data.json
```

### Performance Tips

**Efficient jq for large FUB datasets:**
```bash
# Use streaming for large files
jq -c '.users[]' large-file.json | head -10

# Filter early to reduce processing
jq '.users[] | select(.account_id == "123") | {id, name}' data.json

# Use specific field access instead of selecting all
jq '.users[] | {id: .user_id, name: .username}' data.json  # Good
jq '.users[] | .' data.json                                # Less efficient for large data
```

This guide focuses on the essential jq operations that FUB developers use regularly for processing API responses, configuration files, package.json management, and basic data analysis tasks.