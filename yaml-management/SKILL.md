---
name: yaml-management
description: Comprehensive YAML file validation, processing, and manipulation using yamllint, yq, and dyff tools
---

## Overview

Comprehensive YAML file validation, processing, and manipulation using yamllint, yq, and dyff tools. Provides syntax checking, style linting, data extraction, transformation, format conversion, intelligent diffing, merging capabilities, and batch processing for YAML configuration files and data workflows.

## Usage

```bash
/yaml-management --operation=<op_type> --file_path=<path> [--query=<yq_query>] [--output_format=<format>] [--strict=<bool>] [--in_place=<bool>] [--config_file=<config_path>]
```

# YAML Management

## Examples

```bash
# Validate YAML files with comprehensive linting
/yaml-management --operation="validate" --file_path="config.yml" --strict=true

# Extract specific data from YAML file
/yaml-management --operation="query" --file_path="data.yml" --query=".services[].name"

# Transform YAML to JSON with formatting
/yaml-management --operation="transform" --file_path="config.yml" --output_format="json"

# Compare two YAML files with intelligent diffing
/yaml-management --operation="diff" --file_path="old-config.yml,new-config.yml"

# Merge multiple YAML files
/yaml-management --operation="merge" --file_path="base.yml,override.yml" --output_format="yaml"

# Format and fix YAML file in place
/yaml-management --operation="format" --file_path="messy-config.yml" --in_place=true

# Validate directory of YAML files with custom rules
/yaml-management --operation="validate" --file_path="configs/" --config_file=".yamllint.yml"
```

## Core Workflow

### Essential Operations (Most Common - 90% of Usage)

**1. YAML Validation and Linting**
```bash
# Basic YAML syntax and style validation
yaml-management --operation="validate" --file_path="config.yml"

# Strict validation with comprehensive rules
yaml-management --operation="validate" --file_path="config.yml" --strict=true

# Validate multiple files in directory
yaml-management --operation="validate" --file_path="configs/" --strict=true
```

**2. Data Extraction and Querying**
```bash
# Extract specific values from YAML
yaml-management --operation="query" --file_path="data.yml" --query=".app.version"

# Get array of values with filtering
yaml-management --operation="query" --file_path="services.yml" --query=".services[] | select(.active == true) | .name"

# Transform data structure
yaml-management --operation="query" --file_path="config.yml" --query='{name: .app.name, version: .app.version}'
```

**3. Format Conversion and Transformation**
```bash
# Convert YAML to JSON
yaml-management --operation="transform" --file_path="config.yml" --output_format="json"

# Convert and save in place
yaml-management --operation="transform" --file_path="config.yml" --output_format="yaml" --in_place=true

# Merge configuration files
yaml-management --operation="merge" --file_path="base.yml,prod.yml"
```

### Tool Installation

**Install Required Tools via Homebrew:**
```bash
# Install all YAML management tools
brew install yamllint yq homeport/tap/dyff

# Verify installation
yamllint --version && yq --version && dyff version
```

### Preconditions

- **Tools Available**: yamllint, yq, and dyff must be installed via Homebrew
- **File Access**: Must have read access to target YAML files
- **Write Permissions**: Required for in-place modifications (`--in_place=true`)
- **Valid YAML**: Source files should be syntactically valid YAML for processing operations
- **Output Directory**: Must exist for file output operations

## Quick Reference

### Tool Commands Summary

| Tool | Purpose | Key Commands |
|------|---------|--------------|
| **yamllint** | Validation & Linting | `yamllint file.yml`, `yamllint -d strict config/` |
| **yq** | Processing & Querying | `yq '.path' file.yml`, `yq -i '.key = "value"' file.yml` |
| **dyff** | Intelligent Diffing | `dyff between old.yml new.yml`, `dyff yaml file.json` |

### Common yq Patterns

```bash
# Basic data extraction
yq '.app.name' config.yml                        # Get single value
yq '.services[]' docker-compose.yml              # List array items
yq '.users[] | select(.active == true)' users.yml # Filter with conditions

# Data transformation
yq '.services[] | {name: .name, port: .port}' services.yml    # Transform structure
yq 'keys' config.yml                                          # Get all keys
yq -i '.app.version = "2.0.0"' config.yml                    # Update in place

# Format conversion
yq -o json config.yml                            # YAML to JSON
yq -P data.json                                  # JSON to YAML (pretty)
```

### Common Issues and Solutions

| Issue | Solution |
|-------|----------|
| **yamllint not found** | Install: `brew install yamllint` |
| **yq command conflicts** | Use full path: `/opt/homebrew/bin/yq` |
| **Invalid YAML syntax** | Run: `yamllint file.yml` for detailed errors |
| **Permission denied** | Check file permissions: `ls -la file.yml` |
| **Complex query failures** | Test step by step: `yq '.path' | yq '.subpath'` |

### FUB Integration Examples

```bash
# Validate database fixtures
yamllint apps/richdesk/tests/fixtures/*.yml

# Extract database configuration
yq '.development.database' config/database.yml

# Validate docker-compose files
yamllint docker-compose*.yml

# Get service configuration
yq '.services[] | "\(.name): \(.ports[])"' docker-compose.yml
```

## Advanced Patterns

For comprehensive documentation on advanced usage:

- **[Validation Documentation](./validation.md)** - yamllint configuration, rules, and advanced validation workflows
- **[Processing Documentation](./processing.md)** - Complex yq operations, transformations, and automation
- **[Diffing Documentation](./diffing.md)** - dyff usage, comparison workflows, and Git integration
- **[Examples](./examples/)** - Real-world configuration files, fixtures, and workflow examples

<details>
<summary>Click to expand advanced workflow examples and automation patterns</summary>

### Multi-Tool Validation Pipeline
```bash
# Comprehensive YAML validation workflow
validate_yaml_comprehensive() {
    local file_path="$1"
    local strict_mode="${2:-false}"

    # 1. Basic syntax validation
    yq eval '.' "$file_path" > /dev/null || return 1

    # 2. Style and format validation
    if [ "$strict_mode" = "true" ]; then
        yamllint -d strict "$file_path" || return 1
    else
        yamllint "$file_path" || return 1
    fi

    # 3. Structure analysis
    echo "Keys: $(yq eval 'keys | join(", ")' "$file_path")"
    echo "Documents: $(yq eval-all '. | length' "$file_path")"
}
```

### Configuration Management Workflow
```bash
# Generate environment-specific configurations
generate_config() {
    local base_file="$1"
    local env_file="$2"
    local output_file="$3"

    # Merge base with environment overrides
    yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' \
        "$base_file" "$env_file" > "$output_file"

    # Validate merged result
    yamllint "$output_file"
}
```

### Automated Quality Assurance
```bash
# Pre-commit validation for YAML files
yaml_pre_commit_check() {
    local yaml_files=$(git diff --cached --name-only | grep -E '\.(yml|yaml)$')

    for file in $yaml_files; do
        yamllint "$file" || exit 1
        yq eval '.' "$file" > /dev/null || exit 1
    done
}
```

</details>

## Integration Points

### Cross-Skill Workflow Patterns

**Database Operations → YAML Management:**
```bash
# Validate database fixture YAML files
yaml-management --operation="validate" --file_path="apps/richdesk/tests/fixtures/" --strict=true |
  database-operations --operation="validate-fixtures"

# Extract database configuration for environment setup
yaml-management --operation="query" --file_path="config/database.yml" --query=".${environment}"
```

**Backend Test Development → YAML Management:**
```bash
# Validate test fixture structure before test execution
yaml-management --operation="validate" --file_path="apps/richdesk/tests/fixtures/UserTest.common.yml" |
  backend-test-development --target="UserTest" --test_type="database"

# Transform PHPUnit configuration for different environments
yaml-management --operation="query" --file_path="phpunit.yml" --query=".testsuites.${suite}"
```

**Configuration Management Workflows:**
```bash
# Complete configuration validation and deployment
yaml-management --operation="validate" --file_path="config/" --strict=true |
  yaml-management --operation="merge" --file_path="base.yml,${env}.yml" |
  mutagen-management --operation="sync"
```

### Related Skills

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| `json-management` | **Format Conversion** | Convert between YAML/JSON, validate cross-format configs, shared configuration management |
| `xml-management` | **Format Conversion** | Convert between YAML/XML, transform legacy configurations, multi-format data processing |
| `database-operations` | **Configuration Management** | Validate database configs, process fixture YAML files |
| `backend-test-development` | **Test Configuration** | Validate PHPUnit configs, process test fixture YAML |
| `datadog-management` | **Monitoring Configuration** | Validate alert definitions, transform dashboard configs |
| `mutagen-management` | **Sync Configuration** | Validate mutagen.yml, process sync configs |
| `code-development` | **Application Configuration** | Validate app configs, environment-specific transformations |

### Refusal Conditions

The skill must refuse if:
- Required tools (yamllint, yq, dyff) are not installed or accessible
- Target YAML files are not readable due to permission restrictions
- Specified configuration files don't exist or are malformed
- In-place modification requested without write permissions
- Query expressions contain potentially unsafe operations
- File paths contain invalid characters or reference non-existent locations

When refusing, provide specific guidance:
- **Tool Installation**: `brew install yamllint yq homeport/tap/dyff`
- **Permission Issues**: Check with `ls -la file.yml`
- **Configuration**: Validate yamllint config with `yamllint --print-config`
- **Query Syntax**: Test with simple expressions first
- **File Access**: Verify paths exist and are accessible

## Documentation References

- **[Detailed Validation Guide](./validation.md)** - Complete yamllint configuration and validation workflows
- **[Processing Operations Guide](./processing.md)** - Advanced yq operations and data transformation
- **[Diffing and Comparison Guide](./diffing.md)** - dyff usage and intelligent YAML comparison
- **[Example Files](./examples/)** - Real-world YAML files and workflow examples

**External Documentation:**
- yamllint: https://yamllint.readthedocs.io/ - also available via `/documentation-retrieval --library="yamllint" --query="configuration and rules"`
- yq: https://mikefarah.gitbook.io/yq/ - also available via `/documentation-retrieval --library="yq" --query="examples and syntax"`
- dyff: https://github.com/homeport/dyff - also available via `/documentation-retrieval --library="dyff" --query="comparison examples"`