# Dashboard Setup & Sync

## Dashboard Structure

The progress dashboard is a self-contained HTML file (`output/progress-report.html`) that includes:

- **Header**: Project name, ticket number, last-updated timestamp (Pacific time), deadline
- **Stat cards**: Completed count, In-progress count, Legacy/Decommission count, Not Ours count
- **Progress bar**: Percentage complete over team-owned instances only (excludes "Not Ours")
- **Sections** (one table each):
  - Completed — Validated
  - MR Opened — In Progress
  - Legacy / Decommission — Incompatible / Slated for Removal
  - Not Ours / Excluded
- **Columns in each table**: Service, Cloud Account, Instances, Repo/Method, MR link, Status pill

## Status Pills (CSS classes)

```html
<span class="status-pill complete">New agent active + validated</span>
<span class="status-pill mr-open">Opened; CI pending</span>
<span class="status-pill legacy">Legacy — OS incompatible, slated for decommission</span>
<span class="status-pill planned">Planned</span>
```

## Updating Progress

After any change (MR opened, pipeline passes, instance validated, status changes):

1. Edit `output/progress-report.html` directly:
   - Move the row to the correct table section
   - Update the status pill
   - Update counts in stat cards and progress bar percentages
2. Run `./sync-dashboard.sh` to publish

## Progress Bar Math

```
owned = completed + in_progress + legacy_decommission
completed_pct  = round(completed / owned * 100)
legacy_pct     = round(legacy / owned * 100)
in_progress_pct = 100 - completed_pct - legacy_pct
```

"Not Ours / Excluded" instances are shown separately below the bar with a muted note, not counted in the percentages.

## Hosting Options

### Option A: Replit (recommended for sharing)

1. Create a Replit account and a new "HTML, CSS, JS" repl
2. Create a GitHub repo (`gh repo create <name> --public`) in a subfolder: `replit-dashboard/`
3. Set up GitHub SSH deploy key in Replit's GitHub integration
4. Configure Replit to auto-deploy from the GitHub repo on push
5. Run `sync-dashboard.sh` after any update — it pushes to GitHub; Replit deploys automatically

### Option B: GitHub Pages

```bash
# In the replit-dashboard folder (or any folder), enable GitHub Pages
gh repo create my-migration-dashboard --public
cd replit-dashboard
git init && git add . && git commit -m "Initial dashboard"
git push -u origin main
# Enable GitHub Pages in repo Settings > Pages > Source: main / root
```

### Option C: Confluence

Paste the HTML into a Confluence page using the HTML macro. Update manually or use the Confluence API:

```bash
curl -X PUT \
  "https://zillowgroup.atlassian.net/wiki/rest/api/content/<PAGE_ID>" \
  -H "Authorization: Bearer $CONFLUENCE_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"version\":{\"number\":<next_version>},\"title\":\"Migration Progress\",\"type\":\"page\",\"body\":{\"storage\":{\"value\":\"$(cat output/progress-report.html | python3 -c 'import sys,json; print(json.dumps(sys.stdin.read()))')\",\"representation\":\"storage\"}}}"
```

### Option D: Local Only

Just open `output/progress-report.html` in a browser and share the file or screenshot as needed.

## Timestamp

The sync script automatically updates the "Last updated" timestamp to Pacific time on each push.

```bash
TIMESTAMP=$(TZ='America/Los_Angeles' date '+%B %-d, %Y at %-I:%M %p %Z')
sed "s|Last updated [^<]*|Last updated ${TIMESTAMP}|" "$SRC" > "$DST"
```

## Cross-Reference IDs

If the new tool or the inventory spreadsheet has internal IDs per instance (e.g., a security console asset ID), you can add an optional cross-reference column to the dashboard tables. Use `<br>` to separate multiple IDs per service row, and widen the column via CSS to prevent text wrapping:

```css
.xref-id { min-width: 340px; font-size: 0.72rem; word-break: break-all; }
```
