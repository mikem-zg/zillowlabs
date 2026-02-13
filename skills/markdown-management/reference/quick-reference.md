## Quick Reference

### Essential Commands

**Basic Validation:**
```bash
# Lint markdown files
markdownlint *.md docs/**/*.md

# Check links
markdown-link-check README.md

# Auto-fix issues
markdownlint --fix *.md
```

**Batch Processing:**
```bash
# Process all markdown files (excluding common directories)
find . -name "*.md" \
  -not -path "./node_modules/*" \
  -not -path "./.git/*" \
  -exec markdownlint {} \;

# Auto-fix all fixable issues
find . -name "*.md" \
  -not -path "./node_modules/*" \
  -exec markdownlint --fix {} \;
```

**Format Conversion:**
```bash
# CommonMark to GitHub-Flavored Markdown
pandoc -f commonmark -t gfm input.md -o output.md

# Generate HTML documentation
pandoc -f gfm -t html5 --highlight-style=github README.md -o README.html

# Generate PDF
pandoc -f gfm -t pdf README.md -o README.pdf
```

### Configuration Files

**markdownlint Configuration (.markdownlint.json):**
```json
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

**Link Check Configuration (.markdown-link-check.json):**
```json
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

### Tool Installation

```bash
# Core linting and validation
npm install -g markdownlint-cli
npm install -g markdown-link-check

# Document conversion
# macOS: brew install pandoc
# Ubuntu: apt-get install pandoc
# Windows: choco install pandoc

# Advanced processing (optional)
npm install -g remark-cli remark-preset-lint-recommended
```

### Document Structure Templates

**README.md Structure:**
```markdown
# Project Name

Brief project description.

## Installation
## Usage
## API Reference
## Contributing
## License
```

**Documentation Directory:**
```
docs/
├── README.md           # Overview and navigation
├── installation.md     # Setup instructions
├── usage/
│   ├── quick-start.md
│   └── advanced.md
├── api/
│   ├── README.md
│   └── endpoints.md
└── contributing.md
```

### Quality Checklist

**README.md Requirements:**
- [ ] Single H1 title
- [ ] Brief project description
- [ ] Installation instructions
- [ ] Usage examples with code blocks
- [ ] API reference or links
- [ ] Contributing guidelines
- [ ] License information

**Technical Documentation:**
- [ ] Clear header hierarchy (H1 → H2 → H3)
- [ ] Consistent list formatting
- [ ] Code blocks with language specification
- [ ] Working internal and external links
- [ ] Tables with proper alignment
- [ ] No trailing whitespace

### Common Issues and Solutions

**Mixed List Styles:**
- Problem: Inconsistent bullet markers (`*`, `-`, `+`)
- Solution: Standardize on `-` for unordered lists

**Table Alignment:**
- Problem: Misaligned table columns
- Solution: Use consistent spacing and alignment characters

**Link Resolution:**
- Problem: Relative links break when documents move
- Solution: Use consistent directory structure and validate during build

**Code Block Languages:**
- Problem: Missing or incorrect language specifications
- Solution: Always specify language for syntax highlighting

### CI Integration

**Package.json Scripts:**
```json
{
  "scripts": {
    "lint:md": "markdownlint '**/*.md' --ignore node_modules",
    "lint:md:fix": "markdownlint '**/*.md' --ignore node_modules --fix",
    "test:links": "markdown-link-check README.md docs/**/*.md",
    "docs:html": "find docs -name '*.md' -exec pandoc -f gfm -t html5 {} -o {}.html \\;",
    "docs:validate": "npm run lint:md && npm run test:links"
  }
}
```

**GitHub Actions Basic Setup:**
```yaml
# .github/workflows/docs.yml
name: Documentation
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '16'
      - run: npm install -g markdownlint-cli markdown-link-check
      - run: markdownlint '**/*.md'
      - run: markdown-link-check README.md
```

### Error Handling

**Linting Error Types:**
- Parse location: File path and line number from error output
- Rule identification: Error codes to rule descriptions
- Severity levels: Distinguish errors from warnings
- Fix suggestions: Specific remediation steps

**Link Check Failures:**
- HTTP errors: 404, 403, timeout, connection refused
- Internal link errors: File not found, invalid anchor
- Configuration issues: Malformed URLs, encoding problems