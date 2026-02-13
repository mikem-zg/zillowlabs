# JSON Comparison and Diffing for FUB Development

JSON comparison workflows for configuration management, API response validation, and development debugging in FUB environments.

## JSON Diff Tools for FUB

### Tool Installation and Setup

**Install JSON comparison tools via Homebrew:**
```bash
# Primary JSON diff tools
brew install dyff jd jq

# Additional tools for comprehensive comparisons
brew install git delta

# Verify installations
dyff version
jd --version
jq --version
```

**Tool capabilities for FUB workflows:**
- **dyff**: Semantic diffs for JSON and YAML, excellent for configuration files
- **jd**: Pure JSON diff tool with multiple output formats
- **jq**: Custom comparison logic for complex FUB data structures
- **git + delta**: Enhanced git diffs for JSON files with better formatting

## Configuration File Comparisons

### FUB Environment Configuration Diffs

**Compare FUB configuration across environments:**
```bash
# Compare production vs staging configurations
dyff between apps/richdesk/config/production.json apps/richdesk/config/staging.json

# Focus on database configuration differences
jd apps/richdesk/config/production.json apps/richdesk/config/staging.json | jq '.database'

# Compare API settings between environments
jq -s '.[0].api as $prod | .[1].api as $stage | {
  production: $prod,
  staging: $stage,
  differences: ($prod | keys) - ($stage | keys) + ($stage | keys) - ($prod | keys)
}' production.json staging.json

# Structural comparison of FUB config files
dyff between --omit-header apps/richdesk/config/development.json apps/richdesk/config/production.json
```

**Package.json dependency comparisons:**
```bash
# Compare frontend dependencies between branches
git diff HEAD~1 apps/richdesk/frontend/package.json

# Compare dependency versions across FUB projects
jd apps/richdesk/frontend/package.json apps/richdesk/backend/package.json --set

# Focus on specific dependency changes
jq -s '.[0].dependencies as $old | .[1].dependencies as $new |
  ($old | keys) as $old_keys | ($new | keys) as $new_keys |
  {
    added: ($new_keys - $old_keys),
    removed: ($old_keys - $new_keys),
    changed: [($old_keys & $new_keys)[] | select($old[.] != $new[.])]
  }' old-package.json new-package.json

# Compare script configurations
dyff between --filter=".scripts" package.json.backup package.json
```

## API Response Validation

### FUB API Response Comparisons

**Compare API responses for consistency:**
```bash
# Compare user API responses between versions
dyff between fub-users-v1.json fub-users-v2.json

# Validate API response structure changes
jd api-response-old.json api-response-new.json --format=json | jq '
  if .type == "add" then "New field: " + .path
  elif .type == "remove" then "Removed field: " + .path
  elif .type == "replace" then "Changed field: " + .path
  else . end
'

# Compare contact data structure
jq -s '
  def structure: walk(if type == "object" then with_entries(.value = (.value | type)) else . end);
  [.[] | .contacts[0] | structure] | unique |
  if length > 1 then "Structure mismatch" else "Structure consistent" end
' contact-response-1.json contact-response-2.json

# Check for missing required fields in FUB responses
jq -s '
  .[0].data[0] as $template |
  .[1].data[] |
  ($template | keys) - (. | keys) |
  if length > 0 then "Missing fields: " + (. | join(", ")) else "Complete" end
' expected-user-response.json actual-user-response.json
```

**FUB API schema validation:**
```bash
# Compare API response against expected schema
jq '
  .data[] |
  {
    has_required_fields: (has("user_id") and has("username") and has("email")),
    missing_fields: (
      ["user_id", "username", "email", "account_id"] - (. | keys)
    ),
    extra_fields: (
      (. | keys) - ["user_id", "username", "email", "account_id", "role", "is_active"]
    )
  }
' actual-api-response.json

# Validate FUB contact response format
dyff between --ignore-order-changes expected-contact-schema.json actual-contact-response.json
```

## Test Data Comparison

### FUB Test Data Validation

**Compare test data across environments:**
```bash
# Compare test user data structure
jd test-data/development-users.json test-data/staging-users.json --format=patch

# Validate test contact consistency
jq -s '
  [.[] | .test_contacts[] | keys | sort] | unique |
  if length == 1 then "Consistent structure"
  else "Inconsistent test data structure" end
' test-contacts-*.json

# Check test data completeness
jq '
  .test_users[] |
  {
    user_id: .user_id,
    complete: (has("username") and has("email") and has("account_id")),
    missing: (["username", "email", "account_id"] - (. | keys))
  } |
  select(.complete == false)
' test-users.json

# Compare expected vs actual test results
dyff between --ignore=".timestamp,.run_id" expected-test-results.json actual-test-results.json
```

## Development Workflow Comparisons

### FUB Configuration Management

**Track configuration changes during development:**
```bash
# Compare current config with git HEAD
git diff HEAD -- apps/richdesk/config/production.json | delta

# Show semantic differences in FUB configuration
dyff between <(git show HEAD:apps/richdesk/config/production.json) apps/richdesk/config/production.json

# Compare multiple configuration files at once
for config in apps/richdesk/config/*.json; do
  echo "=== $(basename $config) ==="
  if git show HEAD:"$config" >/dev/null 2>&1; then
    dyff between <(git show HEAD:"$config") "$config"
  else
    echo "New file: $config"
  fi
done

# Validate configuration changes don't break required structure
jq -s '
  .[0] as $old | .[1] as $new |
  ["database", "api", "cache"] as $required |
  {
    old_has_required: ($required | all($old | has(.))),
    new_has_required: ($required | all($new | has(.))),
    missing_sections: ($required - ($new | keys))
  }
' old-config.json new-config.json
```

### Pre-deployment Validation

**FUB deployment configuration verification:**
```bash
# Compare staging vs production configuration
dyff between --omit-header apps/richdesk/config/staging.json apps/richdesk/config/production.json > config-diff.txt

# Validate production config has no development settings
jq '
  . as $config |
  {
    has_debug: (.debug // false),
    has_test_data: has("test_data"),
    environment: (.environment // "unknown"),
    valid_for_production: (
      (.debug // false) == false and
      (has("test_data") | not) and
      (.environment == "production")
    )
  }
' apps/richdesk/config/production.json

# Check for sensitive data differences
jq -s '
  .[0] as $stage | .[1] as $prod |
  {
    staging_secrets: [$stage | paths | select(.[-1] | test("password|secret|key|token"))],
    production_secrets: [$prod | paths | select(.[-1] | test("password|secret|key|token"))],
    secret_diff: (
      [$stage | paths | select(.[-1] | test("password|secret|key|token"))] -
      [$prod | paths | select(.[-1] | test("password|secret|key|token"))]
    )
  }
' staging.json production.json
```

## Advanced JSON Comparison Workflows

### Custom Comparison Logic for FUB

**Complex FUB data structure comparisons:**
```bash
# Compare user permissions across environments
jq -s '
  def normalize_user: {id: .user_id, username, role, permissions: (.permissions | sort)};
  def compare_users:
    .[0].users | map(normalize_user) as $users1 |
    .[1].users | map(normalize_user) as $users2 |
    {
      only_in_first: ($users1 - $users2),
      only_in_second: ($users2 - $users1),
      common: ($users1 & $users2) | length
    };
  compare_users
' env1-users.json env2-users.json

# Compare FUB contact data with fuzzy matching
jq -s '
  .[0].contacts as $contacts1 |
  .[1].contacts as $contacts2 |
  [
    $contacts1[] as $c1 |
    $contacts2[] as $c2 |
    if ($c1.email == $c2.email) then
      {
        email: $c1.email,
        name_changed: ($c1.name != $c2.name),
        phone_changed: ($c1.phone != $c2.phone),
        status_changed: ($c1.status != $c2.status)
      }
    else empty end
  ] | map(select(.name_changed or .phone_changed or .status_changed))
' contacts-old.json contacts-new.json

# Semantic comparison of FUB API schemas
jq -s '
  def extract_schema(obj):
    obj | walk(if type == "object" then
      with_entries(.value = (.value | type))
    else . end);

  .[0] | extract_schema as $schema1 |
  .[1] | extract_schema as $schema2 |
  {
    schemas_match: ($schema1 == $schema2),
    schema1: $schema1,
    schema2: $schema2
  }
' api-response-1.json api-response-2.json
```

### Batch Comparison Operations

**Compare multiple FUB configuration sets:**
```bash
# Compare all environment configurations
#!/bin/bash
configs=(development staging production)
for i in "${!configs[@]}"; do
  for j in "${!configs[@]}"; do
    if [ $i -lt $j ]; then
      env1="${configs[$i]}"
      env2="${configs[$j]}"
      echo "=== $env1 vs $env2 ==="
      dyff between "apps/richdesk/config/$env1.json" "apps/richdesk/config/$env2.json"
      echo
    fi
  done
done

# Compare package.json files across all FUB projects
find . -name "package.json" -not -path "./node_modules/*" | while read pkg; do
  echo "=== $pkg ==="
  jd package.json "$pkg" --set | head -10
done

# Validate all test data files have consistent structure
test_files=(apps/richdesk/tests/data/*.json)
base_file="${test_files[0]}"
for test_file in "${test_files[@]:1}"; do
  echo "Comparing $base_file with $test_file"
  jq -s 'map(keys | sort) | unique | length == 1' "$base_file" "$test_file"
done
```

## Git Integration for JSON Diffs

### Enhanced Git Workflows for FUB

**Configure git for better JSON diffs:**
```bash
# Add to .gitconfig for better JSON diffs
git config diff.json.textconv 'jq .'
echo "*.json diff=json" >> .gitattributes

# Use delta for enhanced JSON diffs
git config core.pager delta
git config delta.navigate true
git config delta.side-by-side true

# Custom git diff for FUB configuration files
git config alias.config-diff 'diff --word-diff=color apps/richdesk/config/'
```

**FUB-specific git diff workflows:**
```bash
# Compare configuration changes in current branch
git diff main...HEAD -- apps/richdesk/config/*.json

# Show JSON changes with semantic formatting
git diff --name-only main...HEAD | grep '\.json$' | while read file; do
  echo "=== $file ==="
  dyff between <(git show main:"$file") "$file"
done

# Review package.json changes
git diff HEAD~1..HEAD -- "**/package.json" | delta

# Check for accidental configuration commits
git diff --cached --name-only | grep -E "(config|secret|env)" | while read file; do
  echo "Review configuration file: $file"
  git diff --cached "$file"
done
```

## Troubleshooting JSON Comparisons

### Common Issues and Solutions

**Handle malformed JSON during comparisons:**
```bash
# Validate JSON before comparing
validate_and_compare() {
  local file1="$1" file2="$2"

  if ! jq empty "$file1" 2>/dev/null; then
    echo "Invalid JSON: $file1"
    return 1
  fi

  if ! jq empty "$file2" 2>/dev/null; then
    echo "Invalid JSON: $file2"
    return 1
  fi

  dyff between "$file1" "$file2"
}

# Compare with formatting normalization
normalize_and_compare() {
  local file1="$1" file2="$2"
  jq . "$file1" > "/tmp/$(basename "$file1").normalized"
  jq . "$file2" > "/tmp/$(basename "$file2").normalized"
  dyff between "/tmp/$(basename "$file1").normalized" "/tmp/$(basename "$file2").normalized"
}

# Ignore specific fields during comparison
ignore_timestamps() {
  local file1="$1" file2="$2"
  jq 'del(.timestamp, .created_at, .updated_at)' "$file1" > "/tmp/clean1.json"
  jq 'del(.timestamp, .created_at, .updated_at)' "$file2" > "/tmp/clean2.json"
  dyff between "/tmp/clean1.json" "/tmp/clean2.json"
}
```

**Debug complex comparison results:**
```bash
# Identify why two JSON files are different
debug_json_diff() {
  local file1="$1" file2="$2"

  echo "=== File sizes ==="
  wc -l "$file1" "$file2"

  echo "=== Top-level keys ==="
  jq 'keys' "$file1"
  jq 'keys' "$file2"

  echo "=== Detailed diff ==="
  jd "$file1" "$file2" --format=json | jq -r '
    if .type == "add" then "➕ Added: " + .path
    elif .type == "remove" then "➖ Removed: " + .path
    elif .type == "replace" then "🔄 Changed: " + .path
    else . end
  '
}

# Find specific differences in large FUB datasets
find_user_differences() {
  jq -s '
    .[0].users as $users1 | .[1].users as $users2 |
    ($users1 | map(.user_id)) as $ids1 |
    ($users2 | map(.user_id)) as $ids2 |
    {
      missing_in_second: ($ids1 - $ids2),
      missing_in_first: ($ids2 - $ids1),
      common_count: ($ids1 & $ids2) | length
    }
  ' file1.json file2.json
}
```

This comprehensive guide provides FUB developers with practical JSON comparison workflows for configuration management, API validation, and development debugging tasks.