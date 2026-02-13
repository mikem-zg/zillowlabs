## Format Conversion and Processing

### Tool Dependencies

Install required tools for full functionality:

```bash
# Core linting and validation
npm install -g markdownlint-cli
npm install -g markdown-link-check

# Document conversion (universal)
# macOS: brew install pandoc
# Ubuntu: apt-get install pandoc
# Windows: choco install pandoc

# Advanced processing (optional)
npm install -g remark-cli remark-preset-lint-recommended
```

## Format Conversion Patterns

### Basic Conversion Operations
```bash
# CommonMark to GitHub-Flavored Markdown
pandoc -f commonmark -t gfm input.md -o output.md

# Generate HTML documentation
pandoc -f gfm -t html5 --highlight-style=github README.md -o README.html

# Batch conversion for multiple files
find docs -name "*.md" -exec pandoc -f gfm -t html5 {} -o {}.html \;
```

### Advanced Conversion Options
```bash
# HTML with custom CSS
pandoc -f gfm -t html5 --css=custom.css --self-contained README.md -o README.html

# PDF generation
pandoc -f gfm -t pdf README.md -o README.pdf

# Word document conversion
pandoc -f gfm -t docx README.md -o README.docx

# LaTeX output
pandoc -f gfm -t latex README.md -o README.tex
```

## Batch Processing Workflow

When processing multiple files:

1. **Discovery**: Use `find` or `glob` to locate Markdown files
2. **Filtering**: Exclude generated files, node_modules, .git
3. **Validation**: Run linting and link checking
4. **Reporting**: Aggregate results with file paths and line numbers
5. **Auto-fixing**: Apply safe corrections where possible

```bash
# Process all markdown files
find . -name "*.md" \
  -not -path "./node_modules/*" \
  -not -path "./.git/*" \
  -exec markdownlint {} \;
```

## Template Generation

### README Template
```markdown
# Project Name

Brief project description.

## Installation

Step-by-step installation instructions.

## Usage

Basic usage examples with code samples.

## API Reference

Link to detailed API documentation.

## Contributing

Guidelines for contributors.

## License

License information.
```

### Documentation Structure
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

### Template Quick Start
```bash
# Copy common templates
cp ~/.claude/skills/markdown-management/templates/README.template.md ./README.md
cp ~/.claude/skills/markdown-management/templates/CONTRIBUTING.template.md ./CONTRIBUTING.md

# Initialize documentation structure
mkdir -p docs/{api,guides,tutorials}
touch docs/{README.md,installation.md,troubleshooting.md}
```

## Content Processing Utilities

### Code Block Extraction
```bash
# Extract code blocks for syntax validation
extract_code_blocks() {
    local markdown_file="$1"
    local temp_dir=$(mktemp -d)

    # Extract fenced code blocks
    awk '/^```/{flag=!flag; if(flag) lang=$0; next} flag{print > temp_dir"/"lang".tmp"}' "$markdown_file"

    # Validate extracted code
    for code_file in "$temp_dir"/*.tmp; do
        validate_syntax "$code_file"
    done

    rm -rf "$temp_dir"
}
```

### Link Processing
```bash
# Extract and validate links
extract_links() {
    local markdown_file="$1"

    # Extract markdown links
    grep -oE '\[([^\]]+)\]\(([^)]+)\)' "$markdown_file" | \
    sed -E 's/\[([^\]]+)\]\(([^)]+)\)/\2/' | \
    while read -r link; do
        validate_link "$link" "$markdown_file"
    done
}
```

### Table Processing
```bash
# Format and validate tables
format_tables() {
    local markdown_file="$1"

    # Extract table content
    awk '/^\|.*\|$/{print}' "$markdown_file" | \
    while IFS= read -r line; do
        # Validate table structure
        validate_table_row "$line"
    done
}
```

## Output Formatting Options

### HTML Generation
```bash
# Basic HTML with syntax highlighting
pandoc -f gfm -t html5 \
  --highlight-style=github \
  --css=github-markdown.css \
  input.md -o output.html

# Standalone HTML document
pandoc -f gfm -t html5 \
  --standalone \
  --highlight-style=github \
  --css=custom.css \
  --title="Documentation" \
  input.md -o output.html
```

### Multi-format Batch Processing
```bash
# Generate multiple output formats
batch_convert() {
    local input_file="$1"
    local base_name=$(basename "$input_file" .md)

    # HTML
    pandoc -f gfm -t html5 --css=github.css "$input_file" -o "${base_name}.html"

    # PDF (requires LaTeX)
    pandoc -f gfm -t pdf "$input_file" -o "${base_name}.pdf"

    # Word document
    pandoc -f gfm -t docx "$input_file" -o "${base_name}.docx"

    # Plain text
    pandoc -f gfm -t plain "$input_file" -o "${base_name}.txt"
}
```

## Content Normalization

### Standardization Patterns
```bash
# Normalize list formatting
normalize_lists() {
    local file="$1"

    # Convert * and + to - for consistency
    sed -i 's/^[[:space:]]*\* /- /' "$file"
    sed -i 's/^[[:space:]]*+ /- /' "$file"
}

# Fix header spacing
fix_header_spacing() {
    local file="$1"

    # Ensure blank line before headers
    sed -i '/^#/i\\' "$file"

    # Remove multiple blank lines
    sed -i '/^$/N;/^\n$/d' "$file"
}

# Standardize code block language tags
normalize_code_blocks() {
    local file="$1"

    # Common language normalizations
    sed -i 's/```js$/```javascript/' "$file"
    sed -i 's/```sh$/```bash/' "$file"
    sed -i 's/```shell$/```bash/' "$file"
}
```