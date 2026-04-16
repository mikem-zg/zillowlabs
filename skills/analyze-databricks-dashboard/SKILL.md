# Databricks Lakeview Dashboard Documentation

Parse the Databricks Lakeview dashboard at `$ARGUMENTS` and produce structured markdown documentation.

The file is a JSON document — read it directly.

## Parsing Steps

### 1. Dashboard Metadata

- **Name**: `displayName` field, fallback to `name`, fallback to filename stem

### 2. Datasets

Each entry in the `datasets` array represents a SQL query powering one or more widgets.

For each dataset extract:

- **Name**: `name` field (internal ID)
- **Display name**: `displayName` field, fallback to `name`
- **SQL query**: join `queryLines` array into a single string, or use `query` field directly
- **Tables referenced**: extract fully-qualified table names (`catalog.schema.table`) from FROM/JOIN clauses in the SQL. Filter out CTE names from WITH clauses.
- **Selected fields**: extract field names/aliases from the SELECT clause
- **Calculated fields**: from the `columns` array — each entry has `displayName` and `expression`. These are dataset-level computed columns.
- **Parameters**: from the `parameters` array — each has `name`, `type`, `defaultValue`

### 3. Pages and Widgets

Each entry in the `pages` array is a dashboard tab.

For each page:

- **Name/Display name**: `displayName` or `name`
- **Widgets**: iterate `layout` array → `widget` objects. For each widget:
  - **Type**: from `spec.widgetType` or `widget.name`. Map to readable names:
    - `line` → Line Chart, `bar` → Bar Chart, `counter` → Counter, `pivot` → Pivot Table, `scatter` → Scatter Plot, `combo` → Combo Chart, `table` → Table, `area` → Area Chart, `filter-single-select` → Single-Select Filter, `filter-multi-select` → Multi-Select Filter, `filter-date-range-picker` → Date Range Filter
  - **Title**: from `spec.frame.title` or `textbox_spec.content`
  - **Dataset reference**: from `widget.queries[0].name`

### 4. Global Parameters

Collect parameters from all datasets. For each:

- **Name**, **Type**, **Default value**, **Source dataset**

### 5. Data Lineage Summary

Build a consolidated reverse mapping: for each table referenced across all datasets, list which datasets reference it. Sort by most-shared tables first.

If a Databricks workspace URL is available, construct Unity Catalog links for each table in `catalog.schema.table` format:
`{workspace_url}/explore/data/{catalog}/{schema}/{table}`

### 6. Upstream Lineage (when available)

If the user has Databricks credentials and a SQL warehouse, upstream lineage can be traced via `system.access.table_lineage`. This is NOT available from the JSON file alone — it requires querying Unity Catalog.

When upstream lineage data is provided, render it as an indented tree:

```
**`analytics.gold.daily_revenue`**
  <- `analytics.silver.orders_enriched`
      <- `analytics.bronze.raw_orders`
```

## Output Format

Generate documentation following this structure. See [references/output-format.md](references/output-format.md) for the complete template.

```markdown
# {Dashboard Name}

**File**: `{filename}`
**Type**: Databricks Lakeview Dashboard
**Parsed**: {timestamp}

## Table of Contents
- Overview, Datasets, Data Lineage Summary, Dashboard Pages, Parameters

## Datasets
### 1. {Dataset Display Name}
- Tables, SQL query, calculated fields, parameters

## Data Lineage Summary
- `table.name` — Dataset A, Dataset B

## Dashboard Pages
### {Page Name}
- Widget summary and titled widgets

## Parameters
```