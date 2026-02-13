## Continuous Integration Setup

### Automated validation in development workflow
```bash
# Add to package.json scripts
{
  "scripts": {
    "lint:md": "markdownlint '**/*.md' --ignore node_modules",
    "lint:md:fix": "markdownlint '**/*.md' --ignore node_modules --fix",
    "test:links": "markdown-link-check README.md docs/**/*.md",
    "docs:html": "find docs -name '*.md' -exec pandoc -f gfm -t html5 {} -o {}.html \\;",
    "docs:validate": "npm run lint:md && npm run test:links"
  }
}

# GitHub Actions workflow (.github/workflows/docs.yml)
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

## Multi-Repository Documentation Coordination

### Advanced Patterns for Large-Scale Documentation Management

#### Multi-Repository Documentation Coordination
```bash
# Sync documentation standards across multiple repositories
create_docs_standards_template() {
    local template_repo="docs-standards"
    local target_repos=("api-server" "web-client" "mobile-app")

    for repo in "${target_repos[@]}"; do
        rsync -av "${template_repo}/.markdownlint.json" "${repo}/"
        rsync -av "${template_repo}/docs/templates/" "${repo}/docs/templates/"
    done
}

# Automated cross-repository link validation
validate_cross_repo_links --repos="api,web,docs" --base-url="https://github.com/company"
```

#### Automated Documentation Deployment
```bash
# Build and deploy documentation site
deploy_docs() {
    local docs_dir="docs"
    local output_dir="dist"

    # Convert all markdown to HTML
    find "$docs_dir" -name "*.md" -exec bash -c '
        file="$1"
        output="${file%.md}.html"
        pandoc -f gfm -t html5 \
          --css="/assets/github-markdown.css" \
          --template="/templates/page.html" \
          "$file" -o "$output_dir/$output"
    ' _ {} \;

    # Generate index
    create_documentation_index "$docs_dir" > "$output_dir/index.html"

    # Deploy to hosting
    rsync -av "$output_dir/" "user@docs.example.com:/var/www/docs/"
}
```

#### Documentation Metrics and Monitoring
```bash
# Generate documentation health report
generate_docs_report() {
    local report_file="docs-health-report.md"

    {
        echo "# Documentation Health Report"
        echo "Generated: $(date)"
        echo ""

        echo "## Linting Results"
        markdownlint '**/*.md' --output docs-lint.json
        echo "- Total files checked: $(find . -name '*.md' | wc -l)"
        echo "- Files with issues: $(jq '.length' docs-lint.json)"

        echo ""
        echo "## Link Check Results"
        markdown-link-check README.md docs/**/*.md --quiet --summary

        echo ""
        echo "## Coverage Metrics"
        echo "- Total documentation files: $(find docs -name '*.md' | wc -l)"
        echo "- API endpoints documented: $(grep -r "## Endpoint:" docs/api/ | wc -l)"
        echo "- Code examples: $(grep -r '```' docs/ | wc -l)"

    } > "$report_file"
}
```

## Integration with Development Workflow

### Pre-commit Hooks
```bash
# .git/hooks/pre-commit
#!/bin/bash
set -e

echo "Running documentation validation..."

# Lint markdown files in staged changes
git diff --cached --name-only --diff-filter=AM | \
grep -E '\.(md|markdown)$' | \
xargs -r markdownlint

# Check links in modified files
git diff --cached --name-only --diff-filter=AM | \
grep -E '\.(md|markdown)$' | \
xargs -r markdown-link-check --quiet

echo "Documentation validation passed!"
```

### Automated README Generation
```bash
# Generate README from template and project metadata
generate_readme() {
    local project_name=$(jq -r '.name' package.json)
    local project_description=$(jq -r '.description' package.json)
    local project_version=$(jq -r '.version' package.json)

    cat > README.md << EOF
# ${project_name}

${project_description}

## Version

Current version: ${project_version}

## Installation

\`\`\`bash
npm install ${project_name}
\`\`\`

## Usage

Basic usage example:

\`\`\`javascript
const ${project_name} = require('${project_name}');
\`\`\`

## API Documentation

See [API.md](./docs/API.md) for detailed documentation.

## Contributing

Please read [CONTRIBUTING.md](./CONTRIBUTING.md) for contribution guidelines.

## License

This project is licensed under the $(jq -r '.license' package.json) License.
EOF
}
```

### Documentation Sync Automation
```bash
# Sync documentation across environments
sync_documentation() {
    local environments=("staging" "production")
    local docs_branch="docs"

    # Update documentation branch
    git checkout "$docs_branch"
    git pull origin main --rebase

    # Build documentation
    npm run docs:build

    # Deploy to each environment
    for env in "${environments[@]}"; do
        echo "Deploying to $env..."
        rsync -av dist/ "deploy@$env.example.com:/var/www/docs/"
    done

    git checkout main
}
```

## Quality Assurance Integration

### Automated Quality Checks
```bash
# Comprehensive documentation quality assessment
assess_docs_quality() {
    local quality_score=0
    local total_checks=0

    # Check for README existence
    if [[ -f README.md ]]; then
        ((quality_score++))
    fi
    ((total_checks++))

    # Check for CONTRIBUTING guide
    if [[ -f CONTRIBUTING.md ]]; then
        ((quality_score++))
    fi
    ((total_checks++))

    # Check for API documentation
    if [[ -d docs/api ]]; then
        ((quality_score++))
    fi
    ((total_checks++))

    # Check linting compliance
    if markdownlint '**/*.md' --quiet; then
        ((quality_score++))
    fi
    ((total_checks++))

    # Check link validity
    if markdown-link-check README.md --quiet; then
        ((quality_score++))
    fi
    ((total_checks++))

    local percentage=$((quality_score * 100 / total_checks))
    echo "Documentation quality score: $percentage% ($quality_score/$total_checks)"

    if [[ $percentage -lt 80 ]]; then
        echo "Warning: Documentation quality below 80%"
        exit 1
    fi
}
```

### Performance Monitoring
```bash
# Monitor documentation build performance
monitor_build_performance() {
    local start_time=$(date +%s)

    # Run documentation build
    npm run docs:build

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))

    # Log metrics
    echo "Documentation build completed in ${duration}s" | \
    tee -a docs-build-metrics.log

    # Alert if build takes too long
    if [[ $duration -gt 300 ]]; then
        echo "Warning: Documentation build exceeded 5 minutes"
        # Send alert to monitoring system
    fi
}
```