# YAML Validation Basics

Essential yamllint usage for YAML file validation and linting.

## Overview

yamllint validates YAML files for:
- **Syntax validity** - Proper YAML structure
- **Style consistency** - Indentation, spacing, line length
- **Quality issues** - Duplicate keys, trailing spaces
- **Best practices** - Comments, document structure

**Documentation**: https://yamllint.readthedocs.io/

## Installation

### Install via Homebrew (Recommended)
```bash
# Install yamllint
brew install yamllint

# Verify installation
yamllint --version
```

### Alternative Installation Methods
```bash
# Via pip (Python package manager)
pip install yamllint

# Via pipx (isolated Python environment)
pipx install yamllint

# Via conda
conda install -c conda-forge yamllint
```

## Basic Usage

### Command-Line Operations
```bash
# Validate single file
yamllint config.yml

# Validate multiple files
yamllint file1.yml file2.yaml config/*.yml

# Validate directory recursively
yamllint configs/

# Get help and options
yamllint --help
```

### Configuration Options
```bash
# Use predefined relaxed configuration
yamllint -d relaxed config.yml

# Use predefined strict configuration
yamllint -d strict config.yml

# Use custom configuration file
yamllint -c .yamllint.yml config.yml

# Define configuration inline
yamllint -d '{extends: default, rules: {line-length: {max: 200}}}' config.yml
```

### Output Formats
```bash
# Default colored output
yamllint config.yml

# Machine-readable format
yamllint -f parsable config.yml

# GitHub Actions format
yamllint -f github config.yml

# Colored format (explicit)
yamllint -f colored config.yml
```

## Exit Codes and Error Handling

### Exit Code Meanings
```bash
# 0 - No problems found
# 1 - One or more warnings found
# 2 - One or more errors found

# Use in scripts
if yamllint config.yml; then
    echo "✅ YAML is valid"
    exit 0
else
    echo "❌ YAML has issues (exit code: $?)"
    exit 1
fi
```

### Error Output Examples
```bash
# Syntax error output:
$ yamllint bad-syntax.yml
bad-syntax.yml
  3:1       error    syntax error: expected <block end>, but found '<scalar>' (syntax)

# Style warning output:
$ yamllint style-issues.yml
style-issues.yml
  1:1       warning  missing document start "---"  (document-start)
  2:121     error    line too long (121 > 120 characters)  (line-length)
  5:10      warning  trailing spaces  (trailing-spaces)
```

## Common Usage Patterns

### Quick Validation
```bash
# Basic validation for most files
yamllint *.yml

# Relaxed validation for legacy files
yamllint -d relaxed legacy-config.yml

# Silent check (exit code only)
yamllint config.yml > /dev/null 2>&1 && echo "Valid" || echo "Invalid"
```

### Directory Validation
```bash
# Validate all YAML in project
find . -name "*.yml" -o -name "*.yaml" | xargs yamllint

# Validate specific directories
yamllint config/ docker/ k8s/

# Skip certain directories
yamllint . --ignore "node_modules/" --ignore "vendor/"
```

### Batch Processing
```bash
# Validate multiple projects
for dir in project1 project2 project3; do
    echo "Validating $dir..."
    yamllint "$dir/"
done

# GNU parallel for large projects
find . -name "*.yml" | parallel yamllint {}
```

## Predefined Configurations

### Default Configuration
```bash
# Balanced rules suitable for most projects
yamllint -d default config.yml

# Equivalent to:
yamllint config.yml  # default is implicit
```

**Default rules include:**
- 2-space indentation
- 120 character line length
- Consistent spacing around colons, commas
- No trailing spaces
- Document start optional

### Relaxed Configuration
```bash
# Lenient rules for legacy or external files
yamllint -d relaxed config.yml
```

**Relaxed differences from default:**
- Allows trailing spaces
- Allows empty lines at document end
- More flexible comment formatting
- Longer line length tolerance

### Custom Quick Configurations
```bash
# Extra strict validation
yamllint -d '{extends: default, rules: {line-length: {max: 100}, key-ordering: {}}}' config.yml

# Minimal validation (syntax only)
yamllint -d '{rules: {}}' config.yml

# Docker-compose friendly
yamllint -d '{extends: default, rules: {line-length: {max: 200}, document-start: disable}}' docker-compose.yml
```

## Integration with FUB Development

### Database Fixtures Validation
```bash
# Validate FUB test fixtures
yamllint apps/richdesk/tests/fixtures/*.yml

# Relaxed validation for generated fixtures
yamllint -d relaxed apps/richdesk/resources/sql/tests/phpunit_database_fixture.yml

# Validate specific test fixtures
yamllint apps/richdesk/tests/fixtures/UserTest.{common,client}.yml
```

### Configuration Files Validation
```bash
# Validate application configuration
yamllint apps/richdesk/config/bootstrap/*.yml

# Validate Docker configurations
yamllint docker-compose*.yml

# Validate CI/CD configurations
yamllint .github/workflows/*.yml .gitlab-ci.yml
```

### Quick FUB Project Check
```bash
# Comprehensive FUB YAML validation
echo "Validating FUB YAML files..."

# Test fixtures
echo "- Test fixtures..."
yamllint -d relaxed apps/richdesk/tests/fixtures/

# Application configs
echo "- Application configs..."
yamllint apps/richdesk/config/bootstrap/

# Docker files
echo "- Docker configurations..."
yamllint docker-compose*.yml 2>/dev/null || echo "No Docker files found"

# CI/CD files
echo "- CI/CD configurations..."
yamllint .github/workflows/ .gitlab-ci.yml 2>/dev/null || echo "No CI/CD files found"

echo "✅ FUB YAML validation complete"
```

## Troubleshooting Common Issues

### Installation Issues
```bash
# Check if yamllint is in PATH
which yamllint || echo "yamllint not found in PATH"

# Check Homebrew installation
brew list | grep yamllint || brew install yamllint

# Test with version check
yamllint --version || echo "Installation issue detected"
```

### Permission Issues
```bash
# Check file permissions
ls -la config.yml

# Make file readable
chmod 644 config.yml

# Check directory permissions
ls -la configs/
```

### Performance Issues
```bash
# For large files, use limited validation
yamllint --no-warnings large-config.yml

# Skip non-essential rules for speed
yamllint -d '{extends: relaxed, rules: {comments-indentation: disable}}' large-file.yml

# Use file size check
file_size=$(stat -f%z config.yml 2>/dev/null || stat -c%s config.yml)
if [ "$file_size" -gt 1048576 ]; then  # 1MB
    echo "Large file detected, using relaxed validation"
    yamllint -d relaxed config.yml
else
    yamllint config.yml
fi
```

### Configuration Not Loading
```bash
# Debug configuration loading
yamllint --print-config config.yml

# Check configuration file syntax
yamllint .yamllint.yml

# Use explicit configuration path
yamllint -c "$(pwd)/.yamllint.yml" config.yml
```

## Next Steps

For detailed configuration and advanced usage:
- **[Configuration Guide](./configuration.md)** - Detailed configuration options and examples
- **[Rules Reference](./rules-reference.md)** - Complete documentation of all validation rules
- **[Integration Guide](./integrations.md)** - Git hooks, CI/CD, and editor integration