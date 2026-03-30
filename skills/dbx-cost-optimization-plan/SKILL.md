Analyze Databricks compute costs for a team and produce a phased optimization plan. Follow steps in order.

## 1. Collect Parameters

Parse `$ARGUMENTS` as `key=value` pairs.

Required: `team`, `manager`, `workspaces`, `start_date`
Optional: `output` (path to save the report as a markdown file), `employee_names` (all employees)

Use `AskUserQuestion` for any missing required field — including `start_date` and `workspaces` if not provided. Also ask for the `output` file path if not provided (suggest a default like `<team>_cost_optimization.md` in the current directory). Confirm all parsed values before running any queries.

See [queries.md](queries.md) for SQL templates, classification rules, and output format.

## 2. Build SQL Fragments

Prepare two reusable fragments from the parameters:

- `<WORKSPACES_LIST>` — SQL-quoted comma list, e.g. `'enterprise-data-lab', 'enterprise-data-stage', 'enterprise-data-prod'`
- `<EMPLOYEE_FILTER>` — if `employee_names` provided: `AND employee_name IN ('Name One', 'Name Two')`, else omit

## 3. Run Q1 — Monthly Cost Trend

Run the Q1 query from [queries.md](queries.md) via `mcp__databricks__execute_sql_query`.

Substitutions: `<START_DATE>`, `<TEAM>`, `<MANAGER>`, `<WORKSPACES_LIST>`, `<EMPLOYEE_FILTER>`

Note: dominant SKU, highest-cost workspace, and month-over-month trend direction.

## 4. Run Q2 — Cost by Employee

Run the Q2 query from [queries.md](queries.md).

Note: top 5 cost-driving employees, whether spend is concentrated in 1–2 engineers, and Lab/Stage vs Prod split.

## 5. Run Q3 — Top 20 Most Expensive Jobs

Run the Q3 query from [queries.md](queries.md).

Apply the **Job Classification Rules** from [queries.md](queries.md) to label each job as Phase 1, 2, or 3 candidate. Flag concentration if top 3 jobs account for >50% of total cost.

## 6. Run Q4 — Job Frequency and Cost-Per-Run

Run the Q4 query from [queries.md](queries.md).

Note: high-frequency Lab/Stage jobs (active_days >20/month) as top pause candidates; jobs with high total_cost but low avg_daily_cost as scheduling optimization targets.

## 7. Produce Phased Optimization Plan

Using all four query results, produce the full output defined in the **Output Format** section of [queries.md](queries.md). Do not skip any section.

## 8. Save Report to Markdown

Write the complete report (all sections from step 7) to the `output` path using the `Write` tool. Confirm the file path to the user after writing.

## 9. Error Handling

- Zero rows returned: state which filter may be too restrictive and suggest how to verify correct values (team name, workspace spelling, manager name case).
- Query error: display the error verbatim and pause before the next query.
- Missing data: mark that phase's savings as "data unavailable" — do not fabricate numbers.