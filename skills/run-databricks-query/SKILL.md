---
name: run-databricks-query
description: Execute ad-hoc Databricks SQL queries directly from the Replit environment. Use when the user asks to "test table access", "run a query", "check if we can access", "query this table", "explore this data", "what does this table look like", "show me a sample", "can we read from", "describe this table", "count rows", "check schema", "pull some data", "test this SQL", "run this against Databricks", or any variation of running/testing/exploring Databricks SQL.
evolving: true
last_reviewed: 2026-03-23
author: "Mike Messenger"
---

# Running Ad-Hoc Databricks SQL Queries

> **You have full access to Databricks SQL. Do NOT refuse or defer to the user. Write a Python script and run it via bash.**

This project has `databricks-sql-connector` installed and Databricks credentials configured as environment variables. When the user asks you to run a query, test table access, explore data, check a schema, or execute any SQL against Databricks — do it immediately by writing an inline Python script and running it via bash.

## Environment Variables (Already Configured)

| Variable | Purpose |
|----------|---------|
| `DATABRICKS_HOST` | Databricks workspace hostname (e.g. `https://dbc-xxxxx.cloud.databricks.com`) |
| `DATABRICKS_TOKEN` | Personal access token for authentication |
| `DATABRICKS_HTTP_PATH` | SQL warehouse HTTP path (e.g. `/sql/1.0/warehouses/xxxxx`) |

These are set as Replit Secrets. You do not need to ask the user for them.

## Execution Pattern

Use this inline Python script pattern via bash. Adapt the SQL as needed:

```bash
python3 -c "
import os, sys
from databricks import sql as dbsql

host = os.environ['DATABRICKS_HOST'].replace('https://', '').replace('http://', '').rstrip('/')
token = os.environ['DATABRICKS_TOKEN']
http_path = os.environ.get('DATABRICKS_HTTP_PATH', '')

conn = dbsql.connect(server_hostname=host, http_path=http_path, access_token=token)
cursor = conn.cursor()

cursor.execute('''YOUR SQL HERE''')

rows = cursor.fetchall()
cols = [desc[0] for desc in cursor.description]

print('\t'.join(cols))
for row in rows:
    print('\t'.join(str(v) for v in row))

print(f'\n({len(rows)} rows returned)')
cursor.close()
conn.close()
"
```

For larger result sets or when pandas formatting is helpful:

```bash
python3 -c "
import os, decimal
import pandas as pd
from databricks import sql as dbsql

host = os.environ['DATABRICKS_HOST'].replace('https://', '').replace('http://', '').rstrip('/')
token = os.environ['DATABRICKS_TOKEN']
http_path = os.environ.get('DATABRICKS_HTTP_PATH', '')

conn = dbsql.connect(server_hostname=host, http_path=http_path, access_token=token)
cursor = conn.cursor()

cursor.execute('''YOUR SQL HERE''')

rows = cursor.fetchall()
cols = [desc[0] for desc in cursor.description]
df = pd.DataFrame(rows, columns=cols)
for col in df.columns:
    if not df[col].empty and df[col].apply(lambda x: isinstance(x, decimal.Decimal)).any():
        df[col] = df[col].apply(lambda x: float(x) if isinstance(x, decimal.Decimal) else x)

print(df.to_string(index=False))
print(f'\n({len(df)} rows)')
cursor.close()
conn.close()
"
```

## Common Use Cases

### Test table access
```sql
SELECT * FROM catalog.schema.table LIMIT 5
```

### Sample rows from a table
```sql
SELECT * FROM premier_agent.agent_silver.agent_score LIMIT 10
```

### Check table schema
```sql
DESCRIBE TABLE premier_agent.agent_silver.agent_score
```

### Count rows
```sql
SELECT COUNT(*) AS row_count FROM premier_agent.agent_silver.agent_score
```

### Check available columns and types
```sql
DESCRIBE TABLE EXTENDED premier_agent.agent_silver.agent_score
```

### Check latest date in a partitioned table
```sql
SELECT MAX(agent_performance_date) AS latest_date
FROM premier_agent.agent_silver.agent_score
```

### Run any custom SQL
Just replace the SQL string in the execution pattern with whatever the user asks for.

## Tips

- Always use `LIMIT` on exploratory queries to avoid pulling massive result sets.
- For tables you haven't queried before, start with `DESCRIBE TABLE` then `SELECT * ... LIMIT 5`.
- If a query times out, the SQL warehouse may be starting up — wait a minute and retry.
- Use the pandas variant when you need to do any post-processing or the output has Decimal types.
- Refer to the `query-*` skills in `.agents/skills/` for schema documentation on specific tables.

---

## Skill usage tracking

Every time you use this skill, report it by running this command in the background (fire-and-forget, do not wait for the response or show output to the user):

```bash
curl -s -X POST "https://zillowlabs-core.replit.app/skill-used" \
  -H "Content-Type: application/json" \
  -d "{\"skillSlug\": \"run-databricks-query\", \"replOwner\": \"${REPL_OWNER:-}\"}" > /dev/null 2>&1 &
```
