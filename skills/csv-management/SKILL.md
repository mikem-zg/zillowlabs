---
name: csv-management
description: CSV data manipulation and analysis using Miller and text processing tools. Use for CSV parsing, filtering, transforming, joining, aggregating, and format conversion tasks.
argument-hint: [csv-file] [operation]
allowed-tools: Bash, Read, Write, Glob, Grep
---

## Overview

Comprehensive CSV data handling using Miller (mlr) and text processing tools for data analysis, transformation, and manipulation tasks. Provides efficient CSV operations with powerful command-line data processing capabilities for filtering, aggregation, transformation, and format conversion.

**Core Tools:**
- **Miller (mlr)**: Powerful command-line data processor for CSV, JSON, TSV
- **Text manipulation tools**: awk, sed, cut, sort for basic operations
- **File operations**: Reading, writing, and format conversion

## Usage

```bash
/csv-management [csv-file] [operation]
```

Common invocations:
- `/csv-management data.csv filter` - Filter rows by criteria
- `/csv-management sales.csv aggregate` - Aggregate data by groups
- `/csv-management input.csv transform` - Transform columns and values
- `/csv-management dataset.csv join other.csv` - Join multiple CSV files

📁 **Comprehensive Examples**: [examples/basic-usage-examples.md](examples/basic-usage-examples.md)

## Core Workflow

### Essential CSV Operations (Most Common - 90% of Usage)

**1. Data Filtering and Selection**
```bash
# Filter rows based on column values
mlr --csv filter '$amount > 1000' input.csv

# Select specific columns
mlr --csv cut -f name,email,amount input.csv

# Sort data by multiple columns
mlr --csv sort -f amount -nr date input.csv
```

**2. Data Aggregation and Grouping**
```bash
# Group by category and sum amounts
mlr --csv stats1 -a sum -f amount -g category input.csv

# Count occurrences by group
mlr --csv count-distinct -f category input.csv

# Multiple aggregations
mlr --csv stats1 -a sum,mean,count -f amount -g category,region input.csv
```

**3. Data Transformation and Format Conversion**
```bash
# Transform column values
mlr --csv put '$total = $quantity * $price' input.csv

# Convert between formats
mlr --icsv --ojson cat input.csv > output.json
mlr --icsv --otsv cat input.csv > output.tsv

# Clean and normalize data
mlr --csv put '$name = gsub($name, "[^a-zA-Z0-9 ]", "")' input.csv
```

**4. Data Joining and Merging**
```bash
# Join CSV files on common field
mlr --csv join -f id -l input1.csv -r input2.csv

# Left join with different field names
mlr --csv join --lp left_ --rp right_ -f user_id input1.csv input2.csv

# Union multiple CSV files
mlr --csv cat file1.csv file2.csv file3.csv
```

### Behavior

When invoked, execute this systematic CSV processing workflow:

**1. File Validation and Analysis**
- Validate CSV file structure and detect delimiter/encoding issues
- Analyze data types and column structures for processing optimization
- Check file size and recommend appropriate processing strategies
- Identify potential data quality issues (missing values, inconsistent formats)

**2. Operation Execution**
- Apply Miller operations with appropriate flags and parameters
- Handle large files with streaming processing for memory efficiency
- Implement error handling for malformed CSV data
- Provide progress indicators for long-running operations

**3. Output Generation and Validation**
- Generate output in requested format (CSV, JSON, TSV, etc.)
- Validate output data integrity and completeness
- Apply consistent formatting and encoding standards
- Provide operation summaries and data statistics

**4. Integration and Handoff**
- Prepare data for downstream processing or analysis tools
- Generate metadata about transformations applied
- Maintain data lineage and processing history
- Enable integration with text-manipulation and databricks-analytics skills

## Quick Reference

📊 **Complete Reference**: [reference/common-operations.md](reference/common-operations.md)

| Operation | Miller Command | Purpose | Common Use Cases |
|-----------|---------------|---------|------------------|
| **Filter** | `mlr filter '$condition'` | Row selection | Data subsetting, quality filtering |
| **Select** | `mlr cut -f fields` | Column selection | Data projection, privacy compliance |
| **Transform** | `mlr put '$new = expression'` | Value transformation | Data cleanup, computed columns |
| **Aggregate** | `mlr stats1 -a func -f field -g group` | Data aggregation | Summary statistics, reporting |
| **Sort** | `mlr sort -f field` | Data ordering | Ranking, preparation for joins |
| **Join** | `mlr join -f key file1 file2` | Data joining | Data enrichment, normalization |

### Miller Performance Optimization

**Memory Efficient Processing:**
- Use streaming operations for large files (>100MB)
- Apply filters early in pipeline to reduce data volume
- Use appropriate data types to minimize memory usage
- Process files in chunks for very large datasets

**Performance Best Practices:**
- Index-based operations for frequent lookups
- Batch multiple transformations in single pass
- Use native Miller functions over external commands
- Cache intermediate results for repeated operations

## Advanced Patterns

🔧 **Advanced Techniques**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)

<details>
<summary>Click to expand advanced CSV processing techniques and optimization strategies</summary>

### Complex Data Processing Pipelines

**Multi-stage data transformation with validation:**
```bash
# Complex pipeline with intermediate validation
mlr --csv filter '$amount > 0' then put '$category = gsub($category, "[^a-zA-Z]", "")' \
  then stats1 -a sum,count -f amount -g category then sort -f category
```

**Statistical analysis and data profiling:**
```bash
# Data profiling with statistical measures
mlr --csv stats1 -a count,sum,mean,stddev,min,max -f amount,quantity
```

📚 **Complete Advanced Documentation**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)

</details>

## Integration Points

🔗 **Integration Workflows**: [workflows/integration-patterns.md](workflows/integration-patterns.md)

### Cross-Skill Workflow Patterns

**CSV Processing → Text Manipulation:**
```bash
# Process CSV data and extract patterns
/csv-management input.csv transform |\
  text-manipulation --operation="extract" --patterns="email,phone" --format="json"

# Clean CSV data using text processing
/text-manipulation --operation="normalize" --cleanup="whitespace,encoding" input.csv |\
  csv-management cleaned.csv aggregate
```

**CSV Processing → Database Operations:**
```bash
# Prepare CSV for database import
/csv-management raw-data.csv transform --format="database" |\
  database-operations --task="Import processed data" --table="staging_table"

# Export query results and process
/database-operations --task="Export sales data" --format="csv" |\
  csv-management exported-data.csv aggregate --group="region"
```

**CSV Processing → Analytics:**
```bash
# Process CSV for analytics platform
/csv-management transaction-data.csv transform --format="parquet" |\
  databricks-analytics --task="Load transaction data" --table="analytics.transactions"
```

### Related Skills

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| `text-manipulation` | **Data Processing** | Text cleaning, pattern extraction, format normalization |
| `databricks-analytics` | **Advanced Analytics** | Data loading, statistical analysis, machine learning preparation |
| `database-operations` | **Data Storage** | Data import/export, ETL processes, data validation |
| `json-management` | **Format Conversion** | CSV to JSON conversion, API data preparation |
| `xml-management` | **Legacy Integration** | Data format bridging, legacy system integration |
| `datadog-management` | **Monitoring** | Data pipeline monitoring, quality metrics tracking |

📋 **Complete Integration Guide**: [workflows/integration-patterns.md](workflows/integration-patterns.md)

### Multi-Skill Operation Examples

**Complete Data Processing Pipeline:**
1. `csv-management` - Clean and validate raw CSV data
2. `text-manipulation` - Extract and normalize text patterns
3. `csv-management` - Transform and aggregate cleaned data
4. `databricks-analytics` - Load processed data for advanced analytics
5. `datadog-management` - Monitor data quality and pipeline performance

**Complete ETL Workflow:**
1. `database-operations` - Export data from source systems
2. `csv-management` - Transform and clean exported data
3. `text-manipulation` - Process text fields and extract insights
4. `csv-management` - Aggregate and format for target system
5. `database-operations` - Load transformed data to data warehouse