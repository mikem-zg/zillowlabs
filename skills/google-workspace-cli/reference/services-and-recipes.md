# Services, Helpers & Recipes

## Services

Core Google Workspace API skills. Each service maps to a `gws <service>` command group.

| Service | Skill | Description |
|---------|-------|-------------|
| `drive` | gws-drive | Manage files, folders, and shared drives |
| `sheets` | gws-sheets | Read and write spreadsheets |
| `gmail` | gws-gmail | Send, read, and manage email |
| `calendar` | gws-calendar | Manage calendars and events |
| `docs` | gws-docs | Read and write Google Docs |
| `slides` | gws-slides | Read and write presentations |
| `tasks` | gws-tasks | Manage task lists and tasks |
| `people` | gws-people | Manage contacts and profiles |
| `chat` | gws-chat | Manage Chat spaces and messages |
| `forms` | gws-forms | Read and write Google Forms |
| `keep` | gws-keep | Manage Google Keep notes |
| `meet` | gws-meet | Manage Google Meet conferences |
| `admin` | gws-admin | Manage users, groups, and devices (Admin SDK) |
| `admin-reports` | gws-admin-reports | Audit logs and usage reports (Admin SDK) |
| `vault` | gws-vault | Manage eDiscovery holds and exports |
| `groupssettings` | gws-groupssettings | Manage Google Groups settings |
| `reseller` | gws-reseller | Manage Workspace subscriptions (Reseller API) |
| `licensing` | gws-licensing | Manage product licenses (Enterprise License Manager) |
| `apps-script` | gws-apps-script | Manage and execute Apps Script projects |
| `classroom` | gws-classroom | Manage classes, rosters, and coursework |
| `cloudidentity` | gws-cloudidentity | Manage identity groups and memberships |
| `alertcenter` | gws-alertcenter | Manage Workspace security alerts |
| `events` | gws-events | Subscribe to Google Workspace events |
| `modelarmor` | gws-modelarmor | Filter user-generated content for safety |
| `workflow` | gws-workflow | Cross-service productivity workflows |

The `gws-shared` skill covers authentication, global flags, and output formatting patterns shared across all services.

## Helpers

Shortcut commands for common single-step operations.

| Helper | Description | Example |
|--------|-------------|---------|
| `gws drive upload` | Upload a file with automatic metadata | `gws drive upload /path/to/file.pdf` |
| `gws sheets append` | Append a row to a spreadsheet | `gws sheets append --spreadsheet-id ID --range 'Sheet1' --values '["A","B"]'` |
| `gws sheets read` | Read values from a spreadsheet | `gws sheets read --spreadsheet-id ID --range 'Sheet1!A1:C10'` |
| `gws gmail send` | Send an email | `gws gmail send --to user@example.com --subject "Hi" --body "Hello"` |
| `gws gmail triage` | Show unread inbox summary | `gws gmail triage` |
| `gws gmail watch` | Watch for new emails (NDJSON stream) | `gws gmail watch` |
| `gws calendar insert` | Create a new event | `gws calendar insert --summary "Meeting" --start "2025-03-10T10:00:00"` |
| `gws calendar agenda` | Show upcoming events across all calendars | `gws calendar agenda` |
| `gws docs write` | Append text to a document | `gws docs write --document-id ID --text "New content"` |

## Recipes

Curated multi-step workflows that combine multiple services. Each recipe is a SKILL.md with step-by-step instructions.

### Drive & Files

| Recipe | Description |
|--------|-------------|
| `recipe-batch-rename-files` | Rename multiple Drive files matching a pattern |
| `recipe-watch-drive-changes` | Subscribe to change notifications on a Drive file or folder |

### Gmail

| Recipe | Description |
|--------|-------------|
| `recipe-save-email-attachments` | Find messages with attachments and save them to Drive |
| `recipe-save-email-to-doc` | Save a Gmail message body into a Google Doc |
| `recipe-batch-reply-to-emails` | Find messages matching a query and send a standard reply |
| `recipe-forward-labeled-emails` | Find messages with a specific label and forward them |
| `recipe-create-vacation-responder` | Enable a Gmail out-of-office auto-reply |

### Calendar

| Recipe | Description |
|--------|-------------|
| `recipe-plan-weekly-schedule` | Review your week, identify gaps, and add events |
| `recipe-batch-invite-to-event` | Add a list of attendees to an existing event |
| `recipe-create-events-from-sheet` | Read event data from Sheets and create Calendar entries |
| `recipe-share-event-materials` | Share Drive files with all attendees of an event |

### Sheets

| Recipe | Description |
|--------|-------------|
| `recipe-backup-sheet-as-csv` | Export a spreadsheet as CSV for local backup |
| `recipe-compare-sheet-tabs` | Read data from two tabs to compare and identify differences |
| `recipe-generate-report-from-sheet` | Read Sheet data and create a formatted Docs report |
| `recipe-sync-contacts-to-sheet` | Export Google Contacts directory to a spreadsheet |

### Slides & Docs

| Recipe | Description |
|--------|-------------|
| `recipe-create-presentation` | Create a new Slides presentation and add initial slides |
| `recipe-share-doc-and-notify` | Share a Doc with edit access and email collaborators |

### Cross-Service

| Recipe | Description |
|--------|-------------|
| `recipe-send-team-announcement` | Send an announcement via both Gmail and Google Chat |
| `recipe-create-feedback-form` | Create a Google Form for feedback and share it via Gmail |
| `recipe-deploy-apps-script` | Push local files to a Google Apps Script project |

### Tasks & Admin

| Recipe | Description |
|--------|-------------|
| `recipe-review-overdue-tasks` | Find Google Tasks that are past due |
| `recipe-triage-security-alerts` | List and review Workspace security alerts |

### Meet & Classroom

| Recipe | Description |
|--------|-------------|
| `recipe-create-meet-space` | Create a Meet meeting space and share the join link |
| `recipe-review-meet-participants` | Review who attended a Meet conference and for how long |
| `recipe-create-classroom-course` | Create a Classroom course and invite students |

## Advanced Usage

### Introspecting API schemas

```bash
gws schema drive.files.list           # see request/response schema for any method
gws schema calendar.events.insert     # works for every API method
```

### Pagination

| Flag | Description |
|------|-------------|
| `--page-all` | Stream all pages as NDJSON |
| `--page-limit N` | Fetch only the first N pages |
| `--page-delay MS` | Wait MS milliseconds between page requests |

```bash
gws drive files list --params '{"pageSize": 100}' --page-all | jq -r '.files[].name'
```

### Multipart uploads

```bash
gws drive files create \
  --json '{"name": "report.pdf", "parents": ["folder-id"]}' \
  --upload /path/to/report.pdf
```

### Dry run

Preview the HTTP request without executing it:

```bash
gws drive files list --params '{"pageSize": 5}' --dry-run
```

### Model Armor (response sanitization)

```bash
gws gmail messages list --sanitize
```

Or configure globally:

```bash
export GOOGLE_WORKSPACE_CLI_SANITIZE_TEMPLATE="projects/my-project/locations/us-central1/templates/my-template"
export GOOGLE_WORKSPACE_CLI_SANITIZE_MODE="harm_only"
```
