# Tableau Documentation Output Format

Use this exact markdown structure when generating documentation for a Tableau workbook.

## Template

```markdown
# {Workbook Name}

**File**: `{filename}`
**Type**: Tableau Workbook
**Parsed**: {YYYY-MM-DD HH:MM:SS}

**Repository**:
  - Site: `{site}`
  - Path: `{path}`

## Table of Contents

- [Overview](#overview)
- [Data Sources](#data-sources)
- [Data Lineage Summary](#data-lineage-summary)
- [Dashboard Tabs](#dashboard-tabs)
- [Parameters](#parameters)
- [Calculated Fields](#calculated-fields)

## Overview

This Tableau workbook contains **{N}** data sources and **{N}** dashboard tabs.

## Data Sources

### 1. {Data Source Caption}

**Type:** {Connection Type}

**Connection:**
- Type: {human-readable type}
- Server: `{server}`
- Database/Schema: `{dbname}.{schema}`

**Tables Referenced:**

- `{catalog.schema.table}`
- `{catalog.schema.table2}`

**Custom SQL:**

\```sql
SELECT ...
\```

### 2. {Published Data Source Caption}

**Type:** Tableau Published Data Source

**Source Connection Type:** {underlying connection type}
**Source Server:** `{server}`

**Upstream Tables:**

- `{catalog.schema.table}`

## Data Lineage Summary

This workbook references **{N}** upstream tables across **{N}** data sources.

- `{table_name}` — {Data Source A}, {Data Source B}
- `{table_name2}` — {Data Source C}

## Dashboard Tabs

### {Dashboard Name}

**Worksheets:**

  - **{Worksheet Name}** - Data Source: `{datasource}`, {N} fields
  - **{Worksheet Name 2}** - Data Source: `{datasource}`, {N} fields

## Parameters

- **{Parameter Name}** (`{datatype}`)
  - Default: `{value}`
  - Values: `val1`, `val2`, `val3`

## Calculated Fields

### {Calculated Field Name}

**Data Source:** `{datasource}`

**Formula:**

\```
IF [Field A] > 0 THEN [Field B] / [Field A] ELSE 0 END
\```
```

## Key Formatting Rules

1. Use backticks around table names, field names, server addresses, and database paths
2. Use `**bold**` for section labels within data sources (Type, Connection, Tables, etc.)
3. Format SQL queries in fenced code blocks with `sql` language tag
4. Format calculated field formulas in plain fenced code blocks (no language tag)
5. Resolve internal field references in formulas to their display names
6. Sort tables alphabetically within each data source
7. In the lineage summary, sort tables by number of referencing data sources (most shared first)
8. Only include calculated fields that are actually used in worksheets
9. Use em-dash (—) to separate table names from data source names in the lineage summary

## Connection Type Mapping

| Connection Class | Display Name |
|---|---|
| databricks | Databricks |
| sqlproxy | Tableau Published Data Source |
| federated | Tableau Federated Data Source |
| textscan | Text File |
| excel-direct | Excel |
| google-sheets | Google Sheets |
| postgres | PostgreSQL |
| mysql | MySQL |
| sqlserver | SQL Server |
| snowflake | Snowflake |
| bigquery | Google BigQuery |
| redshift | Amazon Redshift |
| oracle | Oracle |
