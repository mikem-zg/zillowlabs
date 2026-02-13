# Git Integration for XML Validation

Simple Git integration for occasional XML file validation in FUB development.

## Basic Pre-commit Validation

### Simple XML Check

**Add XML validation to existing pre-commit hook:**
```bash
# Add to existing .git/hooks/pre-commit

# Check staged XML files (if any)
xml_files=$(git diff --cached --name-only | grep '\.xml$' || true)

if [ -n "$xml_files" ]; then
    echo "Validating XML files..."
    for xml_file in $xml_files; do
        if ! xmllint --noout "$xml_file" 2>/dev/null; then
            echo "✗ Invalid XML: $xml_file"
            exit 1
        fi
    done
    echo "✓ XML files validated"
fi
```

## Git Configuration

### Better XML Diffs

**Improve XML file diffs in git:**
```bash
# Configure git to format XML in diffs
git config diff.xml.textconv 'xmllint --format'

# Add to .gitattributes
echo "*.xml diff=xml" >> .gitattributes
```

## Quick Commands

### Useful Git Aliases

**Simple XML validation aliases:**
```bash
# Check all XML files in repo
git config alias.xml-check '!find . -name "*.xml" -not -path "./.git/*" -exec xmllint --noout {} \;'

# Check staged XML files
git config alias.xml-staged '!git diff --cached --name-only | grep "\.xml$" | xargs -r xmllint --noout'

# Usage (if XML files exist)
git xml-check        # Validate all XML
git xml-staged       # Validate staged XML
```

## XML Configuration Files

### Configuration Validation

**Simple XML configuration validation:**
```bash
# Check XML config files before commit
git diff --cached --name-only | grep -E "\.xml$" | while read xml_file; do
    if [ -f "$xml_file" ]; then
        xmllint --noout "$xml_file" || exit 1
        echo "✓ $(basename "$xml_file") is valid"
    fi
done
```

This minimal guide covers basic XML validation integration for the occasional XML file in FUB Git workflows.