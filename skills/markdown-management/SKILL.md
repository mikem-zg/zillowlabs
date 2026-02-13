---
name: markdown-management
description: Comprehensive Markdown document management including linting, validation, formatting, and conversion. Use for README maintenance, documentation workflows, link checking, code block validation, and CommonMark/GFM compliance.
argument-hint: [file-or-directory] [operation]
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

## Overview

Comprehensive Markdown document lifecycle management with validation, linting, formatting, and conversion capabilities. Handles document quality assurance, format conversion between Markdown flavors, batch processing, and CI integration for maintaining consistent documentation standards.

📁 **Validation Tools**: [validation/linting-validation.md](validation/linting-validation.md)

## Core Workflow

### Essential Markdown Operations (Daily Usage - 90% of Cases)

**1. Document Validation and Linting**
```bash
# Basic document linting
markdownlint *.md docs/**/*.md

# Link validation for accessibility
markdown-link-check README.md

# Auto-fix standard violations
markdownlint --fix README.md docs/**/*.md
```

**2. Format Conversion and Processing**
```bash
# CommonMark to GitHub-Flavored Markdown
pandoc -f commonmark -t gfm input.md -o output.md

# Generate HTML documentation
pandoc -f gfm -t html5 --highlight-style=github README.md -o README.html

# Batch conversion for multiple files
find docs -name "*.md" -exec pandoc -f gfm -t html5 {} -o {}.html \;
```

**3. Batch Processing Workflow**
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

**Preconditions:**
- **Tool Installation**: markdownlint-cli, markdown-link-check, pandoc installed
- **Configuration Files**: .markdownlint.json and .markdownlintignore in project root
- **Document Structure**: Organized docs/ directory with consistent naming

### Behavior

When invoked, execute this systematic documentation management workflow:

**1. Project Structure Initialization**
- Set up standardized document organization with docs/{api,usage,guides} structure
- Create configuration files for consistent linting and validation rules
- Initialize README.md, installation.md, contributing.md templates

**2. Document Validation and Quality Assurance**
- Run markdownlint for style and structure validation against defined rules
- Perform link checking to verify internal and external link accessibility
- Validate code block syntax and language specifications
- Apply automatic fixes for standard formatting violations

**3. Format Conversion and Distribution**
- Convert between Markdown flavors (CommonMark, GitHub-Flavored Markdown)
- Generate HTML, PDF, and other output formats using pandoc
- Batch process multiple files with consistent styling and templates
- Maintain format compliance across different output targets

**4. Continuous Integration and Automation**
- Set up automated validation in CI/CD pipelines
- Generate documentation health reports and quality metrics
- Coordinate multi-repository documentation standards
- Monitor build performance and deployment processes

## Quick Reference

📊 **Complete Reference**: [reference/quick-reference.md](reference/quick-reference.md)

### Tool Installation

```bash
# Core linting and validation
npm install -g markdownlint-cli
npm install -g markdown-link-check

# Document conversion (universal)
# macOS: brew install pandoc
# Ubuntu: apt-get install pandoc
# Windows: choco install pandoc
```

### Essential Configuration

**markdownlint (.markdownlint.json):**
```json
{
  "MD013": {"line_length": 120, "code_blocks": false, "tables": false},
  "MD024": false,
  "MD033": {"allowed_elements": ["details", "summary", "div", "span"]}
}
```

### Document Structure Standards

**README.md Requirements:**
- [ ] Single H1 title
- [ ] Brief project description
- [ ] Installation instructions
- [ ] Usage examples with code blocks
- [ ] API reference or links
- [ ] Contributing guidelines
- [ ] License information

## Advanced Patterns

🔧 **Processing Tools**: [processing/conversion-patterns.md](processing/conversion-patterns.md)

<details>
<summary>Click to expand advanced processing and automation patterns</summary>

### Advanced Format Conversion
- Multi-format batch processing with custom templates
- Content normalization and standardization utilities
- Code block extraction and syntax validation
- Table processing and formatting automation

### CI/CD Integration Patterns
- Automated validation in GitHub Actions workflows
- Multi-repository documentation synchronization
- Documentation deployment and hosting automation
- Quality metrics tracking and reporting

### Enterprise Documentation Management
- Large-scale documentation coordination across repositories
- Automated cross-repository link validation
- Documentation health monitoring and alerting
- Performance optimization for large document sets

📚 **Complete Processing Documentation**: [processing/conversion-patterns.md](processing/conversion-patterns.md)

</details>

## Integration Points

🔗 **CI Integration**: [integration/ci-patterns.md](integration/ci-patterns.md)

### Cross-Skill Workflow Patterns

**Documentation → Development → Quality:**
```bash
# Complete documentation workflow
/markdown-management README.md validate |\
  code-development --task="Update API documentation" --scope="docs" |\
  backend-static-analysis --focus="documentation-coverage"
```

**Multi-Repository Documentation Management:**
```bash
# Synchronize documentation standards
/markdown-management --operation="sync-standards" --repos="api,web,mobile" |\
  gitlab-pipeline-monitoring --focus="docs-validation"
```

### Related Skills

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| `code-development` | **Documentation Integration** | API documentation, code examples, technical guides |
| `confluence-management` | **Content Publishing** | Documentation publishing, content migration, collaborative editing |
| `gitlab-pipeline-monitoring` | **CI Integration** | Automated validation, build monitoring, deployment tracking |
| `text-manipulation` | **Content Processing** | Text normalization, format conversion, batch processing |
| `pdf-processing` | **Multi-Format Output** | Document conversion, report generation, archival formats |

📋 **Complete Integration Guide**: [integration/ci-patterns.md](integration/ci-patterns.md)

### Multi-Skill Operation Examples

**Complete Documentation Lifecycle:**
1. `markdown-management` - Validate and standardize documentation format
2. `code-development` - Integrate documentation updates with code changes
3. `gitlab-pipeline-monitoring` - Monitor automated validation and deployment
4. `confluence-management` - Publish final documentation to collaboration platform
5. `datadog-management` - Monitor documentation site performance and accessibility