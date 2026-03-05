---
name: google-workspace-cli
description: Use the Google Workspace CLI (`gws`) to manage Drive, Gmail, Calendar, Slides, Sheets, and every Workspace API from the command line or as an MCP server. Covers installation, authentication (OAuth, service account, token), CLI usage, MCP server setup, 100+ agent skills, and 50 curated recipes. Activate when working with Google Workspace APIs, automating Google services, or setting up MCP-based Google integrations.
---

# Google Workspace CLI (`gws`)

One CLI for all of Google Workspace — built for humans and AI agents. Drive, Gmail, Calendar, Slides, Sheets, and every Workspace API. Zero boilerplate. Structured JSON output. 100+ agent skills included.

**Services & recipes**: [reference/services-and-recipes.md](reference/services-and-recipes.md)
**MCP server guide**: [reference/mcp-server-guide.md](reference/mcp-server-guide.md)

**Source**: [github.com/googleworkspace/cli](https://github.com/googleworkspace/cli)

> This is **not** an officially supported Google product. The project is under active development.

## Key Features

| Feature | Description |
|---------|-------------|
| Dynamic API surface | Reads Google's Discovery Service at runtime — new endpoints appear automatically |
| Structured JSON output | Every response is machine-readable JSON |
| MCP server mode | `gws mcp` exposes Workspace APIs as MCP tools for any compatible client |
| 100+ agent skills | Ships SKILL.md files for every supported API plus higher-level helpers |
| 50 curated recipes | Multi-step workflow patterns (triage email, create reports, batch operations) |
| Auto-pagination | `--page-all` streams all pages as NDJSON |
| Model Armor | Built-in response sanitization via `--sanitize` flag |

## Related Skills

| Skill | Relationship |
|-------|-------------|
| `google-calendar-management` | Deeper Calendar API v3 coverage with Python/TypeScript examples; `gws` provides CLI-first alternative |
| `google-slides-generator` | Zillow-branded Slides workflows using Replit Drive connector; `gws` provides generic Slides CLI access |
| `google-maps` | Google Maps for React UI; unrelated to `gws` (Maps is not a Workspace API) |

## Installation

```bash
# npm (recommended — bundles pre-built native binaries)
npm install -g @googleworkspace/cli

# Nix flake
nix run github:googleworkspace/cli

# Or build from source (requires Rust toolchain)
cargo install --git https://github.com/googleworkspace/cli --locked
```

Pre-built binaries are also available on [GitHub Releases](https://github.com/googleworkspace/cli/releases).

## Authentication

### Which method to use

| Scenario | Method |
|----------|--------|
| Local development with `gcloud` installed | `gws auth setup` (fastest) |
| GCP project but no `gcloud` | Manual OAuth setup |
| Browser available (human or agent) | `gws auth login --browser` |
| Headless / CI environment | `gws auth login --export` |
| Server-to-server (no user context) | Service account via env var |
| Already have an access token | `GOOGLE_WORKSPACE_CLI_TOKEN` env var |

### Interactive setup (recommended for local dev)

```bash
gws auth setup       # one-time: creates Cloud project, enables APIs, logs in
gws auth login       # subsequent logins with scope selection
```

Credentials are encrypted at rest (AES-256-GCM) with the key stored in the OS keyring.

**Scope limits in testing mode:** If your OAuth app is unverified (testing mode), Google limits consent to ~25 scopes. The `recommended` scope preset includes 85+ scopes and will fail for unverified apps. Choose individual services instead:

```bash
gws auth login -s drive,gmail,sheets
```

### Manual OAuth setup (Google Cloud Console)

1. Go to [Google Cloud Console](https://console.cloud.google.com/) > APIs & Services > Credentials
2. Create an OAuth 2.0 Client ID (Desktop application type)
3. Download the credentials JSON file
4. Run:

```bash
gws auth login --credentials-file /path/to/credentials.json
```

### Browser-assisted login

```bash
gws auth login --browser          # opens system browser for OAuth
gws auth login --browser --port 9876  # custom callback port
```

### Headless / CI

```bash
gws auth login --export           # prints access token to stdout
# Or pipe credentials:
echo "$CREDENTIALS_JSON" | gws auth login --credentials-file /dev/stdin --export
```

### Service account (server-to-server)

```bash
export GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE=/path/to/service-account.json
gws drive files list
```

For domain-wide delegation, add `--params '{"subject": "user@domain.com"}'` to impersonate a user.

### Pre-obtained access token

```bash
export GOOGLE_WORKSPACE_CLI_TOKEN="ya29.a0..."
gws drive files list
```

This is useful when another system (e.g., Replit Google Drive connector) already handles OAuth and provides a token.

### Multiple accounts

```bash
gws auth login --account work@corp.com
gws auth login --account personal@gmail.com
gws auth list                           # list registered accounts
gws auth default work@corp.com          # set default
gws --account personal@gmail.com drive files list  # one-off override
```

## Quick Start

```bash
# List recent files
gws drive files list --params '{"pageSize": 10}'

# Create a spreadsheet
gws sheets spreadsheets create --json '{"properties": {"title": "Q1 Budget"}}'

# Get upcoming calendar events
gws calendar events list --params '{"calendarId": "primary", "maxResults": 5, "orderBy": "startTime", "singleEvents": true}'

# Send an email
gws gmail send --to user@example.com --subject "Hello" --body "Message body"

# Introspect any method's request/response schema
gws schema drive.files.list

# Stream all paginated results as NDJSON
gws drive files list --params '{"pageSize": 100}' --page-all | jq -r '.files[].name'

# Dry run (preview the request without executing)
gws drive files list --params '{"pageSize": 5}' --dry-run
```

## MCP Server

`gws mcp` starts a Model Context Protocol server over stdio, exposing Google Workspace APIs as structured tools.

```bash
gws mcp -s drive                  # expose Drive tools only
gws mcp -s drive,gmail,calendar   # expose multiple services
gws mcp -s all                    # expose all services (many tools)
```

| Flag | Description |
|------|-------------|
| `-s, --services <list>` | Comma-separated services to expose, or `all` |
| `-w, --workflows` | Also expose workflow tools |
| `-e, --helpers` | Also expose helper tools |

### Client configuration

```json
{
  "mcpServers": {
    "gws": {
      "command": "gws",
      "args": ["mcp", "-s", "drive,gmail,calendar"]
    }
  }
}
```

> Each service adds roughly 10-80 tools. Keep the list to what you actually need to stay under your client's tool limit (typically 50-100 tools).

See [reference/mcp-server-guide.md](reference/mcp-server-guide.md) for detailed configuration by client and recommended service combinations.

## Advanced Usage

### Pagination

```bash
gws drive files list --page-all                    # all pages as NDJSON
gws drive files list --page-limit 3                # first 3 pages
gws drive files list --page-all --page-delay 500   # 500ms delay between pages
```

### Multipart uploads

```bash
gws drive files create \
  --json '{"name": "report.pdf", "parents": ["folder-id"]}' \
  --upload /path/to/report.pdf
```

### Model Armor (response sanitization)

```bash
gws gmail messages list --sanitize                 # sanitize responses
```

Or configure globally:

```bash
export GOOGLE_WORKSPACE_CLI_SANITIZE_TEMPLATE="projects/my-project/locations/us-central1/templates/my-template"
export GOOGLE_WORKSPACE_CLI_SANITIZE_MODE="harm_only"  # or "all"
```

### Google Sheets shell escaping

Wrap cell values in single quotes to avoid shell interpretation:

```bash
gws sheets append --spreadsheet-id ID --range 'Sheet1!A1' --values '["=SUM(A1:A10)"]'
```

## Gemini CLI Extension

```bash
gws auth setup
gemini extensions install https://github.com/googleworkspace/cli
```

This gives the Gemini CLI agent direct access to all `gws` commands. Authentication is inherited from your terminal session.

## Decision Tree: When to Use `gws` vs Existing Skills

```
Need to interact with Google Workspace APIs?
├── Working in a Replit project with Google Drive connector?
│   ├── Need Zillow-branded Slides? → Use `google-slides-generator` skill
│   └── Need Drive file access? → Use Replit connector (already configured)
├── Need Calendar API with Python/TypeScript examples? → Use `google-calendar-management` skill
├── Need CLI-first access to any Workspace API? → Use `gws`
├── Need MCP server for agent workflows? → Use `gws mcp`
├── Need batch operations across services? → Use `gws` recipes
└── Need Google Maps in React UI? → Use `google-maps` skill (not a Workspace API)
```
