When the user invokes this skill (via `/attack-log` or "triage the TRULIA backlog"):

## Configuration

Parse these from the user's message, falling back to defaults:

| Parameter | Flag/Syntax | Default |
|-----------|-------------|---------|
| Project key | `project=XYZ` | `TRULIA` |
| Tickets per bucket | `top=N` or `limit=N` | `20` |
| Buckets to run | `buckets=A,B,C,D` (any subset) | all four |
| Report directory | `reports=path/` | `reports/` |
| Publish to Confluence | `publish=yes/no` | `yes` |
| Confluence space | `space=KEY` | `TRULIA` |
| Confluence parent page ID | `parent=ID` | (discover from space) |

**Bucket selection examples:**
- `/attack-log buckets=C` — only the overlooked high-priority bucket
- `/attack-log buckets=A,D top=50` — obsolete and AI-automatable, 50 each
- `/attack-log` — all four buckets, top 20 each (default)

When fewer than all four buckets are selected, omit the excluded buckets from both the Summary table and the report body. Still scan all tickets (step 2–4 are always performed), but only apply categorization rules for the selected buckets.

## Procedure

### 1. Discover Jira site

Call `getAccessibleAtlassianResources` to obtain the `cloudId`.
If this fails, ask the user for their Atlassian site URL.

### 2. Fetch all open tickets

Use `searchJiraIssuesUsingJql` with:
- **JQL:** `project = {PROJECT} AND statusCategory != Done ORDER BY updated ASC`
- **Fields:** `summary, status, priority, assignee, reporter, created, updated, labels, components, description, duedate, issuetype`
- **maxResults:** `100`
- Paginate using `nextPageToken` until all results are retrieved.

Collect every ticket into a working list.

### 3. Normalize priorities

Before categorization, map non-standard priority names to standard equivalents:

| Raw Priority | Normalized To |
|-------------|---------------|
| P0 | Blocker |
| P1 | Critical |
| P2 | High |
| P3 | Medium |
| P4 | Low |

All heuristic rules below operate on the **normalized** priority. Include the original priority name in the report's "Priority" column for clarity (e.g., "High (P2)").

### 4. Detect bulk-update dates

Before categorization, scan all `updated` timestamps and identify any single date shared by more than 5% of tickets. If found, flag that date as a **bulk-update date** (likely a migration or mass field change, not genuine activity). For tickets whose `updated` falls on a bulk-update date, substitute the **earlier of `updated` and `created + 90 days`** as the effective staleness date, unless the ticket has comments or status changes after that date (which cannot be checked in Phase 1, so note this caveat in the report methodology).

### 5. Categorize tickets

Evaluate each ticket in bucket order. **First match wins** — no ticket appears in more than one bucket.

#### Bucket A: Obsolete (likely closeable)

A ticket matches if **ANY** rule is true:

| Rule | Condition |
|------|-----------|
| OBS-1 | `updated` is more than 2 years ago |
| OBS-2 | `updated` is more than 1 year ago AND `assignee` is null |
| OBS-3 | `priority` is Trivial or Lowest AND `updated` is more than 18 months ago |
| OBS-4 | `status` is Open or To Do AND `created` is more than 3 years ago AND `assignee` is null |

Rank matches by staleness (oldest `updated` first). Keep top N.

#### Bucket B: Contractor-ready (Bridgenext candidates)

A ticket matches if **ALL** conditions are true:

| Rule | Condition |
|------|-----------|
| CTR-1 | `description` is non-empty and longer than 100 characters |
| CTR-2 | `priority` is Medium or Low |
| CTR-3 | `issuetype` is Bug, Task, or Story (not Epic or Sub-task) |
| CTR-4 | `labels` do NOT contain "blocked", "on-hold", or "needs-design" (case-insensitive) |
| CTR-5 | `assignee` is null OR `updated` is more than 6 months ago |

Rank by priority descending (Medium > Low), then newest `created` first. Keep top N.

#### Bucket C: Overlooked high-priority

A ticket matches if **ALL** conditions are true:

| Rule | Condition |
|------|-----------|
| OHP-1 | **Normalized** `priority` is High, Highest, Critical, or Blocker |
| OHP-2 | `updated` is more than 90 days ago |
| OHP-3 | `status` name is NOT "In Progress" or "In Review" |
| OHP-4 | (Bonus — not required) `duedate` is past or within 30 days from today |

OHP-1 through OHP-3 are required. OHP-4 is a bonus signal for ranking.
Rank by priority descending, then past-due tickets first, then oldest `updated`. Keep top N.

#### Bucket D: AI-automatable

A ticket matches if **ANY** condition is true:

| Rule | Condition |
|------|-----------|
| AIA-1 | `labels` contain "documentation", "docs", "config", or "configuration" (case-insensitive) |
| AIA-2 | `summary` matches pattern: (update\|change\|modify\|bump\|upgrade\|migrate).*(config\|readme\|doc\|version\|dependency\|deps) (case-insensitive) |
| AIA-3 | `issuetype` is Task AND `priority` is Low or Trivial AND `description` length < 500 chars |
| AIA-4 | `summary` matches pattern: (typo\|spelling\|whitespace\|formatting\|lint) (case-insensitive) AND **normalized** `priority` is Low, Trivial, or Not Set |

Rank by shortest description first (simplicity proxy). Keep top N.

### 6. Generate report

Create the report directory if it doesn't exist. Write the file to:
`{report_directory}/attack-log-{PROJECT}-{YYYY-MM-DDTHH-MM-SS}.md`

Use this structure:

```markdown
# AttackLog: {PROJECT} Backlog Triage

**Generated:** {timestamp}
**Project:** {PROJECT}
**Total open tickets scanned:** {count}

## Summary

| Bucket | Count | Description |
|--------|-------|-------------|
| A — Obsolete | {n} | Likely closeable |
| B — Contractor-ready | {n} | Bridgenext candidates |
| C — Overlooked high-priority | {n} | Needs immediate attention |
| D — AI-automatable | {n} | Can be resolved with AI tooling |

---

## A — Obsolete (likely closeable)

| Key | Summary | Priority | Status | Assignee | Last Updated | Reason |
|-----|---------|----------|--------|----------|--------------|--------|
| ... | ... | ... | ... | ... | ... | OBS-1: Not updated in 2+ years |

**Recommended action:** Review and bulk-close with a comment like "Closing as stale — reopen if still relevant."

---

## B — Contractor-ready (Bridgenext candidates)

| Key | Summary | Priority | Status | Assignee | Last Updated | Reason |
|-----|---------|----------|--------|----------|--------------|--------|
| ... | ... | ... | ... | ... | ... | CTR-1–5: Well-described Medium task, unassigned |

**Recommended action:** Add to Bridgenext sprint backlog. Tickets are self-contained with sufficient description.

---

## C — Overlooked high-priority

| Key | Summary | Priority | Status | Assignee | Last Updated | Reason |
|-----|---------|----------|--------|----------|--------------|--------|
| ... | ... | ... | ... | ... | ... | OHP-1–3: High priority, stale 90+ days |

**Recommended action:** Escalate in next sprint planning. Assign owners and set due dates.

---

## D — AI-automatable

| Key | Summary | Priority | Status | Assignee | Last Updated | Reason |
|-----|---------|----------|--------|----------|--------------|--------|
| ... | ... | ... | ... | ... | ... | AIA-4: Summary mentions typo fix |

**Recommended action:** Queue for AI-assisted resolution (Claude Code, Copilot, or similar).

---

## Methodology

- **Source:** Jira Cloud API via MCP
- **Scope:** All open tickets (statusCategory != Done)
- **Priority normalization:** P0→Blocker, P1→Critical, P2→High, P3→Medium, P4→Low
- **Bulk-update detection:** Dates shared by >5% of tickets are flagged; effective staleness adjusted
- **Classification:** Heuristic rules (first match wins, no duplicates across buckets)
- **Rule IDs:** OBS-1–4, CTR-1–5, OHP-1–4, AIA-1–4
- **Phase:** 1 (read-only triage; no ticket modifications)
- **Caveat:** Bulk-update adjustment uses created date as proxy; comment/transition history not checked in Phase 1
```

### 7. Spot-check verification

After generating the report:
- Call `getJiraIssue` on 1–2 tickets from each bucket to confirm the metadata used for categorization is accurate.
- Verify no ticket key appears in more than one bucket.
- Report any discrepancies to the user.

### 8. Publish to Confluence (Phase 2)

Skip this step if `publish=no`.

#### 8a. Find or create the parent page

Use `getPagesInConfluenceSpace` or `searchConfluenceUsingCql` to find the parent page in the target space. If no parent is configured, use the space root.

#### 8b. Create draft page

Call `createConfluencePage` with:
- `cloudId`: from step 1
- `spaceId`: resolved from the target space key
- `parentId`: parent page ID
- `status`: `"draft"`
- `title`: `"AttackLog: {PROJECT} Backlog Triage — {YYYY-MM-DD}"`
- `contentFormat`: `"wiki"` (for initial skeleton; ADF is applied next)

#### 8c. Build ADF body

Generate the full page body as Atlassian Document Format (ADF) JSON. Structure:

1. **H1 heading** — page title
2. **Blockquote** — "Phase 1 — Read-only heuristic triage. No tickets were modified."
3. **Metadata table** (`layout: "default"`) — Generated date, Total Open Tickets, Priority Normalization, Bulk-Update Dates Detected
4. **H2** — "Summary"
5. **Summary table** (`layout: "full-width"`) — one row per active bucket
6. For each active bucket:
   - **H2** heading (e.g., "A — Obsolete")
   - **Bucket data table** (`layout: "full-width"`) — Key, Summary, Priority, Status, Assignee, Last Updated, Reason
   - **Paragraph** — Recommended action
7. **H2** — "Methodology"
8. **Methodology table** (`layout: "default"`) — bullet points as rows

**Table layout rules:**
- Data tables (summary + all bucket tables): `"full-width"`
- Metadata and methodology tables: `"default"`

#### 8d. Update the page with ADF

The ADF body is typically large (100KB+) due to ticket data. The standard `updateConfluencePage` MCP tool call cannot accept this inline. Use the mcp-remote Node.js client workaround:

1. Write the ADF JSON to a temp file (e.g., `/tmp/adf_{PROJECT}.json`):
```python
import json
# build `adf` dict ...
with open('/tmp/adf_PROJECT.json', 'w') as f:
    json.dump(adf, f, separators=(',', ':'))
```

2. Install the MCP SDK if not present:
```bash
npm install --prefix /tmp/mcp-client @modelcontextprotocol/sdk
```

3. Call `updateConfluencePage` via mcp-remote:
```javascript
// /tmp/call_confluence.mjs
import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StdioClientTransport } from "@modelcontextprotocol/sdk/client/stdio.js";
import { readFileSync } from "fs";

const adfBody = readFileSync("/tmp/adf_PROJECT.json", "utf-8").trim();

const transport = new StdioClientTransport({
  command: "bash",
  args: ["-lc", "source ~/.nvm/nvm.sh; npx -y mcp-remote@0.1.37 https://mcp.atlassian.com/v1/sse"],
  env: { ...process.env },
});

const client = new Client({ name: "adf-updater", version: "1.0.0" }, {});
await client.connect(transport);

const result = await client.callTool({
  name: "updateConfluencePage",
  arguments: {
    cloudId: "{CLOUD_ID}",
    pageId: "{PAGE_ID}",
    parentId: "{PARENT_ID}",
    status: "draft",
    title: "AttackLog: {PROJECT} Backlog Triage — {YYYY-MM-DD}",
    body: adfBody,
    contentFormat: "adf",
  },
});

console.log(JSON.stringify(result, null, 2));
await client.close();
```

4. Run: `cd /tmp/mcp-client && node --input-type=module < /tmp/call_confluence.mjs`

The mcp-remote process reuses the OAuth token cached in `~/.mcp-auth/mcp-remote-*/` — no browser re-auth needed.

#### 8e. Return the draft URL

Extract `links.edituiv2` from the update response and present it to the user:
```
https://zillowgroup.atlassian.net/wiki{links.edituiv2}
```

### 9. Present results

Tell the user:
- Where the local report was saved
- Summary counts per bucket
- The Confluence draft URL (if published)
- Any anomalies found during spot-check
- Remind them this is Phase 1 (read-only) — no tickets were modified