# MCP Server Guide

## Overview

`gws mcp` starts a Model Context Protocol server over stdio, exposing Google Workspace APIs as structured tools that any MCP-compatible client can call.

```bash
gws mcp -s drive,gmail,calendar
```

## Flags

| Flag | Description |
|------|-------------|
| `-s, --services <list>` | Comma-separated services to expose, or `all` |
| `-w, --workflows` | Also expose workflow tools (cross-service patterns) |
| `-e, --helpers` | Also expose helper tools (shortcut commands) |

## Service Selection Strategy

Each service adds roughly 10-80 tools. Most MCP clients have a tool limit (typically 50-100 tools). Choose only the services you need.

### Recommended combinations

| Use case | Services | Approx tool count |
|----------|----------|-------------------|
| File management only | `drive` | ~30 |
| Email + files | `drive,gmail` | ~50 |
| Productivity suite | `drive,gmail,calendar,sheets` | ~80 |
| Content creation | `drive,docs,slides,sheets` | ~70 |
| Full Workspace | `all` | 200+ (may exceed client limits) |

### With helpers and workflows

```bash
gws mcp -s drive,gmail -e          # add helper shortcuts (upload, send, triage)
gws mcp -s drive,gmail -w          # add workflow tools (cross-service patterns)
gws mcp -s drive,gmail -e -w       # both helpers and workflows
```

## Client Configuration

### Claude Desktop / Claude Code

Add to your MCP client configuration:

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

### VS Code (Copilot)

In `.vscode/mcp.json`:

```json
{
  "servers": {
    "gws": {
      "command": "gws",
      "args": ["mcp", "-s", "drive,gmail,calendar"]
    }
  }
}
```

### Gemini CLI

Install as an extension instead of configuring as an MCP server:

```bash
gws auth setup
gemini extensions install https://github.com/googleworkspace/cli
```

### Replit

In `.replit` MCP server configuration:

```json
{
  "mcpServers": {
    "gws": {
      "command": "gws",
      "args": ["mcp", "-s", "drive,slides,calendar", "-e"]
    }
  }
}
```

## Authentication for MCP Mode

The MCP server inherits the authentication from the CLI. Set up auth before starting the MCP server:

```bash
gws auth login -s drive,gmail,calendar
```

Or use environment variables for headless environments:

```bash
export GOOGLE_WORKSPACE_CLI_TOKEN="ya29.a0..."
# or
export GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE=/path/to/service-account.json
```

## Multiple Accounts

The MCP server uses the default account. To switch:

```bash
gws auth default work@corp.com
```

Or set via environment variable:

```bash
export GOOGLE_WORKSPACE_CLI_ACCOUNT=work@corp.com
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Too many tools" warning | Reduce the `-s` service list |
| Authentication errors | Run `gws auth login` to refresh credentials |
| Scope errors | Re-login with specific scopes: `gws auth login -s drive,gmail` |
| Token expired | Run `gws auth login` again or refresh the `GOOGLE_WORKSPACE_CLI_TOKEN` env var |
| Method not found | Run `gws schema <method>` to check if the API method exists |
