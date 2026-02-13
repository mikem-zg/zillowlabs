---
name: text-manipulation
description: Comprehensive text manipulation and processing skill for pattern matching, string operations, log analysis, and format conversion. Bridges structured data tools and plain text operations with advanced regex, normalization, and batch processing capabilities.
argument-hint: [operation] [input] [options]
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

## Overview

Comprehensive text manipulation and processing skill that bridges structured data tools and plain text operations with advanced pattern matching, string manipulation, log analysis, and format conversion capabilities. Provides sophisticated text transformation workflows that seamlessly integrate with existing Claude Code structured data processing skills.

**Core Principle:** Bridge the gap between structured data processing (json-management, yaml-management, xml-management) and plain text operations, enabling sophisticated text transformation workflows that complement rather than replace existing tools.

## Usage

```bash
/text-manipulation [operation] [input] [options]
```

Common invocations:
- `/text-manipulation replace --pattern="old" --replacement="new" --scope="**/*.txt"`
- `/text-manipulation extract --patterns="email,phone" --input="data.txt"`
- `/text-manipulation normalize --input="messy-data.txt" --cleanup="whitespace,encoding"`

📁 **Comprehensive Examples**: [examples/basic-usage-examples.md](examples/basic-usage-examples.md)

## Core Workflow

### Essential Operations (Most Common - 90% of Usage)

**1. Pattern-Based Find and Replace**
```bash
# Advanced regex find-and-replace with validation
text-manipulation --operation="replace" --pattern="regex-pattern" --replacement="new-text" --scope="file-pattern"

# Multi-pattern replacements with transformation rules
text-manipulation --operation="bulk-replace" --rules-file="replacement-rules.json" --scope="**/*.txt"

# Conditional replacements based on context
text-manipulation --operation="conditional-replace" --pattern="target" --replacement="new" --if="surrounding-context" --scope="files"
```

**2. String Operations and Transformations**
```bash
# Case conversions and formatting
text-manipulation --operation="transform" --input="data.txt" --transform="uppercase,trim,pad-left:10"

# Encoding and normalization
text-manipulation --operation="normalize" --input="mixed-encoding.txt" --encoding="UTF-8" --line-endings="unix"

# String extraction and parsing
text-manipulation --operation="extract" --pattern="capture-group-regex" --input="source.txt" --output-format="csv"
```

**3. Log Analysis and Processing**
```bash
# Intelligent log filtering and analysis
text-manipulation --operation="analyze-logs" --input="*.log" --filter="severity>=ERROR" --time-range="last-24h"

# Log aggregation and metrics extraction
text-manipulation --operation="aggregate-logs" --input="app.log" --group-by="error-type" --metrics="count,first-seen,last-seen"

# Multi-log correlation and pattern detection
text-manipulation --operation="correlate-logs" --inputs="app.log,system.log,access.log" --correlation-key="request-id"
```

### Preconditions

- Text input files or streams must be accessible and readable
- For batch operations, file patterns must be valid and target files must exist
- Regex patterns must be syntactically valid (automatically validated before execution)
- Output directories must exist or be creatable with current permissions
- For encoding operations, source encoding should be detectable or specified
- Backup options require write permissions to source directories

## Quick Reference

📊 **Complete Reference**: [reference/quick-reference.md](reference/quick-reference.md)

| Operation | Purpose | Input Types | Output Options |
|-----------|---------|-------------|----------------|
| `replace` | Pattern-based find-and-replace | Files, stdin, patterns | In-place, new file, stdout |
| `extract` | Data extraction with regex/patterns | Text files, logs, mixed formats | CSV, JSON, TSV, plain text |
| `transform` | String manipulation and formatting | Any text input | Transformed text, various formats |
| `normalize` | Text cleanup and standardization | Mixed-encoding files, messy data | Clean, standardized text |
| `analyze-logs` | Log file analysis and filtering | Log files, journal entries | Reports, metrics, filtered logs |
| `validate` | Text validation and verification | Any text, structured patterns | Validation reports, cleaned data |

### Behavior

When invoked, execute this systematic text manipulation workflow:

**1. Input Validation and Preparation**
- Validate file accessibility and permissions
- Detect encoding and format automatically
- Create necessary output directories
- Verify regex pattern syntax

**2. Operation Execution**
- Apply requested text operations with progress tracking
- Implement safeguards for large files (>10MB warnings)
- Maintain operation logs for complex transformations
- Provide real-time progress for batch operations

**3. Output Generation and Validation**
- Generate outputs in requested formats
- Validate output quality and completeness
- Create backups if requested
- Provide operation summaries and metrics

**4. Integration Handoff**
- Prepare outputs for downstream skill integration
- Generate metadata for processed content
- Maintain processing history for debugging
- Ensure compatibility with structured data skills

## Advanced Patterns

🔧 **Advanced Techniques**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)

<details>
<summary>Click to expand advanced text manipulation techniques and optimization strategies</summary>

### Multi-Step Text Processing Pipelines

**Complex transformation pipelines with intermediate validation:**
```bash
# Example: Multi-stage log processing
text-manipulation --pipeline="extract,normalize,filter,aggregate" --config="processing-pipeline.json"
```

**Intelligent content classification and processing:**
```bash
# Auto-detect content type and apply appropriate processing
text-manipulation --operation="smart-process" --input="mixed-content/*" --auto-classify
```

**Performance optimization for large datasets:**
```bash
# Memory-efficient processing of large files
text-manipulation --operation="batch-process" --chunk-size="10MB" --parallel="4"
```

📚 **Complete Advanced Documentation**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)

</details>

## Integration Points

🔗 **Integration Workflows**: [workflows/integration-patterns.md](workflows/integration-patterns.md)

### Cross-Skill Workflow Patterns

**Text Manipulation → Structured Data Skills:**
```bash
# Extract text content and convert to structured format
text-manipulation --operation="extract" --patterns="email,phone" --format="csv" |\
  json-management --operation="csv-to-json" --schema="contacts-schema.json"

# Normalize text then validate against YAML schema
text-manipulation --operation="normalize" --cleanup="whitespace,encoding" --output="clean.txt" |\
  yaml-management --operation="validate" --schema="content-schema.yml"
```

**Structured Data → Text Manipulation:**
```bash
# Process JSON output through text manipulation
json-management --operation="extract" --query=".logs[].message" --output="raw-logs.txt" |\
  text-manipulation --operation="analyze-logs" --filter="ERROR" --format="markdown"

# Convert XML to text for advanced processing
xml-management --operation="extract-text" --xpath="//content" --output="content.txt" |\
  text-manipulation --operation="transform" --transform="lowercase,trim,remove-duplicates"
```

**Text Manipulation → Development Workflows:**
```bash
# Process logs for debugging support
text-manipulation --operation="analyze-logs" --filter="ERROR\|EXCEPTION" --time-range="last-hour" |\
  support-investigation --issue="Application errors" --log-analysis="processed-errors.json"

# Clean configuration files before deployment
text-manipulation --operation="normalize" --cleanup="whitespace,line-endings" --scope="config/*.conf" |\
  code-development --task="Deploy configuration" --validation="text-processed"
```

### Related Skills

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| `csv-management` | **Structured Data Processing** | CSV text preprocessing, format validation, Miller operations preparation |
| `json-management` | **Data Format Bridge** | CSV/text → JSON conversion, JSON text extraction, structured data integration |
| `yaml-management` | **Configuration Processing** | YAML text content processing, configuration normalization, validation preparation |
| `xml-management` | **Legacy Data Integration** | XML text extraction, format conversion, structured-to-unstructured bridges |
| `email-parser-development` | **Content Extraction** | Email content normalization, header extraction, attachment processing |
| `datadog-management` | **Log Analysis** | Error log processing, metrics extraction, alert correlation, performance analysis |
| `gitlab-pipeline-monitoring` | **CI/CD Log Processing** | Build log analysis, failure pattern detection, performance tracking |
| `support-investigation` | **Debug Data Processing** | Error pattern extraction, log correlation, incident data processing |
| `database-operations` | **Query Result Processing** | Database output cleaning, result formatting, error log analysis |
| `code-development` | **Configuration Management** | Config file processing, deployment preparation, validation support |
| `markdown-management` | **Document Processing** | Markdown linting, link validation, code block syntax checking, format conversion |

📋 **Complete Integration Guide**: [workflows/integration-patterns.md](workflows/integration-patterns.md)

### Multi-Skill Operation Examples

**Complete Log Analysis Workflow:**
1. `text-manipulation` - Extract and filter error patterns from application logs
2. `datadog-management` - Correlate with monitoring metrics and alerts
3. `gitlab-pipeline-monitoring` - Check for related CI/CD failures
4. `support-investigation` - Generate comprehensive incident analysis
5. `json-management` - Structure findings for automated reporting

**Complete Configuration Processing Workflow:**
1. `text-manipulation` - Normalize and clean configuration files
2. `yaml-management` - Validate YAML configuration syntax and schema
3. `json-management` - Convert to JSON for API consumption
4. `code-development` - Deploy processed configurations with validation
5. `database-operations` - Update configuration database with processed values

**Complete Data Integration Pipeline:**
1. `xml-management` - Extract text content from legacy XML data sources
2. `text-manipulation` - Normalize, clean, and extract structured patterns
3. `json-management` - Convert extracted data to JSON format with validation
4. `email-parser-development` - Process any email content discovered in data
5. `databricks-analytics` - Load processed data for analysis and reporting