# Tableau Dashboard Documentation

Parse the Tableau workbook at `$ARGUMENTS` and produce structured markdown documentation.

## File Handling

- `.twb` files are XML — read directly
- `.twbx` files are ZIP archives containing a `.twb` file — extract first:
  ```
  unzip -o "$ARGUMENTS" -d /tmp/twbx_extract && find /tmp/twbx_extract -name "*.twb"
  ```

## Parsing Steps

Read the `.twb` XML and extract the following sections in order.

### 1. Workbook Metadata

- **Name**: from filename or `<repository-location id="...">` attribute
- **Repository location**: `<repository-location>` — `site`, `path`, `revision` attributes

### 2. Data Sources

Find all `<datasource>` elements (skip the one named `Parameters`). Multiple datasource elements can share the same `caption` — merge these by caption.

For each data source extract:

- **Caption**: `datasource[@caption]` — the display name
- **Connection type**: from `<connection class="...">`. Map to human-readable names:
  - `databricks` → Databricks, `sqlproxy` → Tableau Published Data Source, `snowflake` → Snowflake, `postgres` → PostgreSQL, `textscan` → Text File, `excel-direct` → Excel, `google-sheets` → Google Sheets
- **Published data source detection**: if `<repository-location>` exists inside the datasource AND connection class is `sqlproxy` or `federated`, it's a published Tableau data source. Record the `repository-location[@id]`.
- **Underlying connection**: for `sqlproxy`/`federated` connections, the real database connection is inside `<named-connection><connection>`. Extract `class`, `server`, `dbname`, `schema` from there.
- **Custom SQL**: look for `<relation type="text">` inside the connection — the text content is the SQL query
- **Table references**: if no custom SQL, look for `<relation table="...">` elements. Clean bracket notation: `[schema].[table]` → `schema.table`
- **Tables from SQL**: extract fully-qualified table names (`catalog.schema.table`) from FROM/JOIN clauses. Filter out CTE names (from WITH clauses).

### 3. Worksheets

Find all `<worksheet>` elements. Deduplicate by name. For each:

- **Name**: `worksheet[@name]`
- **Data source**: from `<datasource-dependencies datasource="...">` — resolve internal name to caption using the datasource name map built in step 2. Skip entries referencing `Parameters`.
- **Fields used**: all `<column>` elements inside `<datasource-dependencies>` — use `caption` attribute if present, otherwise clean the `name` (strip brackets)

### 4. Dashboard Tabs

Find all `<dashboard>` elements. For each:

- **Name**: `dashboard[@name]`
- **Worksheets**: all `<zone name="...">` elements — the `name` attribute references worksheet names. Deduplicate.

### 5. Parameters

Find `<datasource name="Parameters">`. For each `<column>`:

- **Name/Caption**: `column[@caption]` or `column[@name]`
- **Data type**: `column[@datatype]`
- **Default value**: `column[@value]`
- **Allowed values**: `<members><member value="...">` elements

### 6. Calculated Fields

For each datasource (skip `Parameters`), find `<column>` elements that contain a `<calculation>` child. Only include fields that are actually used in worksheets (match against the fields collected in step 3).

- **Name**: `column[@caption]` or `column[@name]`
- **Data source**: resolved datasource caption
- **Formula**: `calculation[@formula]`. Resolve internal field references: replace `[internal_name]` patterns with display names using the field name map built from all `<column>` elements across all datasources.

### 7. Data Lineage Summary

After processing all data sources, build a consolidated reverse mapping: for each table referenced across all data sources, list which data sources reference it. Sort by most-shared tables first.

## Output Format

Generate documentation following this structure. See [references/output-format.md](references/output-format.md) for the complete template.

```markdown
# {Workbook Name}

**File**: `{filename}`
**Type**: Tableau Workbook
**Parsed**: {timestamp}

## Table of Contents
- Overview, Data Sources, Data Lineage Summary, Dashboard Tabs, Parameters, Calculated Fields

## Data Sources
### 1. {Data Source Name}
- Connection type, server, tables, custom SQL

## Data Lineage Summary
- `table.name` — Data Source A, Data Source B

## Dashboard Tabs
### {Tab Name}
- Worksheets with data source and field count

## Parameters
## Calculated Fields
```