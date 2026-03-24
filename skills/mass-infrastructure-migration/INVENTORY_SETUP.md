# Inventory Setup

## What You Need to Know First

Before processing any CSV, ask the user for:

1. **What are you migrating?** (e.g., "replacing agent X with agent Y", "moving from provider A to provider B")
2. **How is your inventory catalogued?**
   - What tool/spreadsheet tracks the instances? (Jira, Google Sheet, internal portal, CSV export from the new tool's console, etc.)
   - Open or download it and inspect the column headers before writing any code.
3. **Which column identifies team/service ownership?** (Could be a tag, account name, team label, or business unit field — varies by org)
4. **Which column indicates whether migration is needed?** (A status field, a boolean, a missing value, etc.)
5. **Which column maps to the Git repository?** (May not exist yet — the user may need to fill it in manually)
6. **What should be excluded?** (Services owned by other teams, already-migrated instances, deprecated services, etc.)

Do not assume any column names. Read the actual CSV headers first, then adapt.

---

## Processing the Inventory

Once you understand the schema, copy `templates/inventory.py` and fill in the CONFIG block at the top based on what the user told you. The CONFIG block is the only part that changes between migrations — everything else is reusable logic.

Run it and show the user the grouped output. Ask them to review and correct any groupings that look wrong before moving on.

---

## Building the Repo Map

The output of the inventory step is a mapping from each service/instance group to the Git repository that manages it. This is often not in the original inventory — the user may need to fill it in manually.

Create a simple CSV with whatever columns make sense for this migration. At minimum it needs:
- A column identifying the service/workload
- A column for the Git repo path (can be blank, filled in iteratively)
- Any other context needed by the orchestrator or migration skill

The column names do not need to match any standard — just be consistent between the repo map, the orchestrator config, and the dashboard.

---

## Identifying What Is Not Yours

When a company-wide inventory is available, cross-reference it against your own list. Rows that appear to belong to your team (by account name or tag) but are actually owned by another team should be noted separately. Look for a distinguishing field — a team member list, a different owner contact, a different billing tag — that the user can point you to.

---

## Batching

If the migration is large, split the repo map into sequential batches. Process one batch fully (code changes pushed, pipelines green, dashboard updated) before starting the next. This limits blast radius if something goes wrong.
