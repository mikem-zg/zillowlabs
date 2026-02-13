## Integration Points

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
| `csv-management` | **Structured Data Processing** | CSV text preprocessing, format validation, Miller operations preparation, column extraction |
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

**Complete CSV Data Processing Workflow:**
1. `text-manipulation` - Clean raw CSV files, fix encoding issues, normalize line endings
2. `csv-management` - Parse, filter, transform, and aggregate CSV data using Miller
3. `text-manipulation` - Format results, extract patterns, generate summaries
4. `databricks-analytics` - Load processed CSV data for advanced analytics
5. `json-management` - Convert final results to JSON for API integration

**Complete Documentation Processing Workflow:**
1. `text-manipulation` - Extract and normalize text content from mixed format files
2. `markdown-management` - Lint, validate, and format markdown documents
3. `text-manipulation` - Process code blocks and extract metadata patterns
4. `json-management` - Structure extracted information for documentation systems
5. `confluence-management` - Publish processed documentation to team wiki

