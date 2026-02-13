## Integration Points

### Cross-Skill Workflow Integration

| Related Skill | Integration Type | Common Workflow Patterns |
|---------------|------------------|---------------------------|
| **`text-manipulation`** | **Data Processing Bridge** | CSV extraction → Text normalization → CSV reformatting → Analysis |
| **`database-operations`** | **Data Exchange** | CSV export → Database import → Query results → CSV analysis |
| **`pdf-processing`** | **Document Data Extraction** | PDF tables → CSV extraction → Data validation → Business intelligence |
| **`databricks-analytics`** | **Big Data Analytics** | CSV preparation → Databricks ingestion → SQL analysis → Results export |
| **`datadog-management`** | **Metrics and Monitoring** | CSV log analysis → Metric extraction → Dashboard generation → Alert setup |
| **`planning-workflow`** | **Project Data Management** | Planning data → CSV export → Analysis → Progress reporting |

### Multi-Skill Operation Examples

**Complete Data Processing Pipeline:**
```bash
# PDF → CSV → Database → Analytics workflow
claude /pdf-processing --operation="extract-tables" --input="report.pdf" --output="raw_data.csv" |\
claude /csv-management raw_data.csv validate_and_clean |\
claude /text-manipulation --operation="normalize" --patterns="phone,email,currency" |\
claude /database-operations --operation="bulk_insert" --table="processed_data" --source="cleaned_data.csv"
```

**Business Intelligence Data Pipeline:**
```bash
# Database → CSV → Analytics → Visualization workflow
claude /database-operations --operation="export_query" --query="sales_summary" --format="csv" |\
claude /csv-management sales_export.csv aggregate_by_period |\
claude /databricks-analytics --query_type="trend_analysis" --input="aggregated_sales.csv" |\
claude /datadog-management --task_type="dashboard" --metrics_source="sales_trends.csv"
```

**Document Processing and Analysis:**
```bash
# Multi-format document processing workflow
claude /pdf-processing --operation="extract-structured" --input="financial_report.pdf" |\
claude /text-manipulation --operation="csv_conversion" --cleanup="whitespace,currency" |\
claude /csv-management financial_data.csv validate_financial_format |\
claude /planning-workflow --project="Financial Analysis" --data_source="validated_financial_data.csv"
```

**Log Analysis and Monitoring Integration:**
```bash
# Log processing → CSV analysis → Monitoring setup
claude /text-manipulation --operation="log_analysis" --pattern="csv_structured_logs" --output="system_metrics.csv" |\
claude /csv-management system_metrics.csv time_series_analysis |\
claude /datadog-management --task_type="metric_ingestion" --source="analyzed_metrics.csv" |\
claude /datadog-management --task_type="setup_alerts" --threshold_source="metric_baselines.csv"
```

### Workflow Handoff Patterns

**To csv-management ← From Other Skills:**
- **`pdf-processing`**: Provides extracted tabular data requiring CSV formatting and validation
- **`text-manipulation`**: Supplies processed text data needing structured CSV organization
- **`database-operations`**: Delivers query results requiring CSV analysis and transformation
- **`databricks-analytics`**: Provides large-scale data exports needing CSV processing and formatting

**From csv-management → To Other Skills:**
- **`database-operations`**: Supplies cleaned and validated CSV data for database import operations
- **`text-manipulation`**: Provides structured CSV data requiring complex text processing and normalization
- **`pdf-processing`**: Delivers formatted data for PDF report generation and document creation
- **`datadog-management`**: Supplies processed metrics data for monitoring dashboard creation

### Integration Architecture

**Data Processing Pipeline Framework:**
1. **Data Ingestion**: Multi-format input processing (PDF tables, database exports, text files)
2. **Data Validation**: Quality assessment, type validation, and constraint checking
3. **Data Transformation**: Cleaning, normalization, aggregation, and enrichment
4. **Data Distribution**: Format conversion and export to target systems

**Analytics Integration Points:**
- **Databricks Analytics**: Large-scale data preparation and statistical analysis handoff
- **Database Operations**: Bi-directional data exchange with transactional systems
- **Monitoring Systems**: Metrics extraction and dashboard data preparation
- **Reporting Tools**: Formatted data export for business intelligence systems

**Business Process Integration:**
- **Planning Workflows**: Project data analysis and progress tracking integration
- **Document Management**: Structured data extraction from business documents
- **Quality Assurance**: Data validation and integrity checking across workflows
- **Compliance Reporting**: Automated report generation and data audit trails

**Technical Integration Patterns:**
```bash
# Stream processing integration
named_pipe="/tmp/csv_stream"
mkfifo "$named_pipe"

# Producer: Database operations streaming results
/database-operations --operation="stream_query" --output="$named_pipe" &

# Consumer: CSV processing with real-time analysis
/csv-management --input="$named_pipe" --mode="stream" --analysis="real_time"

# Chain to monitoring
/csv-management output.csv extract_metrics | /datadog-management --task_type="real_time_metrics"
```

**Error Handling and Recovery Integration:**
- **Data Quality Failures**: Integration with text-manipulation for data repair
- **Format Conversion Issues**: Fallback to manual processing workflows
- **Performance Bottlenecks**: Automatic switching to database-operations for large datasets
- **Memory Limitations**: Streaming mode integration with external processing systems

**Cross-Skill Data Standards:**
- **Common CSV Format**: UTF-8 encoding, comma-delimited, quoted strings
- **Metadata Headers**: Standardized column naming and type annotations
- **Error Reporting**: Consistent error format across skill boundaries
- **Quality Metrics**: Standardized data quality indicators and validation results

This skill serves as a central data processing hub that enables seamless data flow between document processing, database operations, analytics platforms, and monitoring systems while maintaining data quality and format consistency throughout the integration pipeline.

