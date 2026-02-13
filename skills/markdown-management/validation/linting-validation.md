## Document Validation and Linting

### Core Validation Tools

**markdownlint-cli Configuration:**
```json
// .markdownlint.json
{
  "MD013": {
    "line_length": 120,
    "code_blocks": false,
    "tables": false
  },
  "MD024": false,
  "MD033": {
    "allowed_elements": ["details", "summary", "div", "span"]
  }
}
```

**markdownlintignore Configuration:**
```
node_modules/
.git/
dist/
coverage/
*.template.md
```

### Link Validation Configuration
```json
// .markdown-link-check.json
{
  "ignorePatterns": [
    {"pattern": "^http://localhost"},
    {"pattern": "^https://private.internal"}
  ],
  "timeout": "10s",
  "retryOn429": true,
  "retryCount": 2
}
```

## Basic Validation Workflow

### Document Linting
```bash
# Basic document linting
markdownlint *.md docs/**/*.md

# Link validation for accessibility
markdown-link-check README.md
markdown-link-check docs/**/*.md

# Code block syntax validation
# Extract and validate code samples in fenced blocks
extract_code_blocks_and_validate document.md
```

### Automatic Fixes
```bash
# Automatic fixes for standard violations
markdownlint --fix README.md docs/**/*.md

# Manual review for content-specific issues
# - Header hierarchy alignment
# - Table structure and content accuracy
# - Code sample completeness
# - Link relevance and accuracy
```

## Batch Processing Examples

```bash
# Validate all markdown files (excluding common directories)
find . -name "*.md" \
  -not -path "./node_modules/*" \
  -not -path "./.git/*" \
  -exec markdownlint {} \;

# Auto-fix all fixable issues
find . -name "*.md" \
  -not -path "./node_modules/*" \
  -exec markdownlint --fix {} \;

# Generate HTML documentation
find docs -name "*.md" \
  -exec pandoc -f gfm -t html5 --css=github.css {} -o {}.html \;
```

## Quality Standards

### Automatic Fixes
Apply these corrections automatically:
- Remove trailing whitespace
- Fix header hierarchy gaps
- Standardize list markers
- Add missing blank lines around headers
- Normalize table formatting

### Manual Review Required
These issues need human judgment:
- Content accuracy in links and references
- Appropriate header hierarchy for content structure
- Code sample correctness and completeness
- Table content alignment and completeness

## Document Structure Standards

### README.md Checklist
- [ ] Single H1 title
- [ ] Brief project description
- [ ] Installation instructions
- [ ] Usage examples with code blocks
- [ ] API reference or links
- [ ] Contributing guidelines
- [ ] License information

### Technical Documentation Checklist
- [ ] Clear header hierarchy (H1 → H2 → H3)
- [ ] Consistent list formatting
- [ ] Code blocks with language specification
- [ ] Working internal and external links
- [ ] Tables with proper alignment
- [ ] No trailing whitespace

## Error Handling

### Linting Errors
- **Parse location**: Extract file path and line number from error output
- **Rule identification**: Map error codes to rule descriptions
- **Severity levels**: Distinguish between errors and warnings
- **Fix suggestions**: Provide specific remediation steps

### Link Check Failures
- **HTTP errors**: 404, 403, timeout, connection refused
- **Internal link errors**: File not found, invalid anchor
- **Configuration issues**: Malformed URLs, encoding problems

### Code Block Syntax Errors
- **Language detection**: Handle missing or invalid language specifications
- **Syntax validation**: Run appropriate parsers/compilers
- **Error reporting**: Map syntax errors to markdown line numbers

## Common Issues and Solutions

### Mixed List Styles
**Problem**: Inconsistent bullet markers (`*`, `-`, `+`)
**Solution**: Standardize on `-` for unordered lists

### Table Alignment
**Problem**: Misaligned table columns
**Solution**: Use consistent spacing and alignment characters

### Link Resolution
**Problem**: Relative links break when documents move
**Solution**: Use consistent directory structure and validate during build

### Code Block Languages
**Problem**: Missing or incorrect language specifications
**Solution**: Always specify language for syntax highlighting