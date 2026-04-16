# Databricks Dashboard Documentation Output Format

Use this exact markdown structure when generating documentation for a Databricks Lakeview dashboard.

## Template

```markdown
# {Dashboard Name}

**File**: `{filename}`
**Type**: Databricks Lakeview Dashboard
**Parsed**: {YYYY-MM-DD HH:MM:SS}

## Table of Contents

- [Overview](#overview)
- [Datasets](#datasets)
- [Data Lineage Summary](#data-lineage-summary)
- [Dashboard Pages](#dashboard-pages)
- [Parameters](#parameters)

## Overview

This Databricks dashboard contains **{N}** datasets and **{N}** pages.

## Datasets

### 1. {Dataset Display Name}

**Tables Referenced:**
  - `{catalog.schema.table}`
  - `{catalog.schema.table2}`

**SQL Query:**

\```sql
SELECT
  col_a,
  col_b,
  SUM(amount) AS total
FROM catalog.schema.table
WHERE date >= :start_date
GROUP BY col_a, col_b
\```

**Parameters:**
  - **{param_name}** (`{type}`)
    - Default: `{default_value}`

**Calculated Fields:** ({N} total)

- **{field_name}**
  \```
  {expression}
  \```

**Selected Fields:** `field_a`, `field_b`, `field_c`

## Data Lineage Summary

This dashboard references **{N}** tables across **{N}** datasets.

- `{table_name}` — {Dataset A}, {Dataset B}
- `{table_name2}` — {Dataset C}

### Upstream Lineage

Tables traced upstream through Unity Catalog lineage (max 3 hops):

**`{catalog.gold.table_name}`**
  <- `{catalog.silver.source_table}`
      <- `{catalog.bronze.raw_table}`

## Dashboard Pages

### {Page Display Name}

**Widgets**: {N} total

**Widget Summary**:

- {N} Line Charts
- {N} Bar Charts
- {N} Counters
- {N} Single-Select Filters

**Titled Widgets**:

- **{Widget Title}** ({Widget Type})
  - Dataset: `{dataset_name}`
- **{Widget Title 2}** ({Widget Type})
  - Dataset: `{dataset_name}`

## Parameters

### {Parameter Name}

  - **Type**: `{type}`
  - **Default**: `{default_value}`
  - **Dataset**: `{source_dataset}`
```

## Key Formatting Rules

1. Use backticks around table names, field names, dataset names, and parameter defaults
2. Format SQL queries in fenced code blocks with `sql` language tag
3. Format calculated field expressions in plain fenced code blocks (no language tag)
4. Sort tables alphabetically within each dataset
5. In the lineage summary, sort tables by number of referencing datasets (most shared first)
6. Use em-dash (—) to separate table names from dataset names in the lineage summary
7. Group widgets by type in the summary, then list titled widgets individually
8. For upstream lineage, use `<-` arrows with indentation to show depth

## Widget Type Mapping

| Raw Type | Display Name |
|---|---|
| line | Line Chart |
| bar | Bar Chart |
| counter | Counter |
| pivot | Pivot Table |
| scatter | Scatter Plot |
| combo | Combo Chart |
| table | Table |
| area | Area Chart |
| histogram | Histogram |
| boxplot | Box Plot |
| filter-single-select | Single-Select Filter |
| filter-multi-select | Multi-Select Filter |
| filter-date-range-picker | Date Range Filter |
