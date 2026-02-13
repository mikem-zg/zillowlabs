# IDE Integration for YAML Validation

VS Code, Cursor, and PHPStorm configuration for yamllint validation in FUB development.

## VS Code & Cursor Configuration for FUB

### Essential YAML Settings

**Workspace Configuration (Compatible with both VS Code and Cursor):**
```json
{
    "yaml.validate": true,
    "yaml.format.enable": true,
    "yaml.completion": true,

    "files.associations": {
        "*Test.common.yml": "yaml",
        "*Test.client.yml": "yaml",
        "phpunit_database_fixture.yml": "yaml",
        "docker-compose*.yml": "yaml",
        "phpunit*.yml": "yaml"
    },

    "yaml.schemas": {
        "https://json.schemastore.org/phpunit.json": "phpunit*.yml",
        "https://json.schemastore.org/docker-compose.json": "docker-compose*.yml"
    }
}
```

Save as `.vscode/settings.json` (works in both VS Code and Cursor).

### FUB YAML Validation Tasks

**Validation Tasks Configuration:**
```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Validate FUB Fixtures",
            "type": "shell",
            "command": "yamllint",
            "args": ["-d", "relaxed", "apps/richdesk/tests/fixtures/"],
            "group": "test",
            "presentation": {
                "echo": true,
                "reveal": "always"
            },
            "problemMatcher": {
                "pattern": {
                    "regexp": "^(.+):(\\d+):(\\d+)\\s+(warning|error)\\s+(.+)$",
                    "file": 1,
                    "line": 2,
                    "column": 3,
                    "severity": 4,
                    "message": 5
                }
            }
        },
        {
            "label": "Check Current YAML File",
            "type": "shell",
            "command": "yamllint",
            "args": ["${file}"],
            "group": "test"
        }
    ]
}
```

Save as `.vscode/tasks.json` (compatible with both VS Code and Cursor).

### Extensions Installation

**VS Code:**
```bash
code --install-extension redhat.vscode-yaml
code --install-extension ms-vscode.vscode-json
```

**Cursor:**
- Use command palette: Ctrl/Cmd+Shift+P → "Extensions: Install Extensions"
- Search for "YAML" and install "YAML" by Red Hat
- All VS Code YAML extensions work in Cursor

## PHPStorm Configuration for FUB

### YAML Plugin Setup

1. Go to **Settings** → **Editor** → **File Types** → **YAML**
2. Add these patterns:
   - `*Test.common.yml`
   - `*Test.client.yml`
   - `phpunit_database_fixture.yml`
   - `docker-compose*.yml`

### External Tool Configuration

**Add yamllint validation:**
1. Go to **Settings** → **Tools** → **External Tools** → **Add**
2. Configure:
   - **Name:** Validate YAML
   - **Program:** `/opt/homebrew/bin/yamllint`
   - **Arguments:** `$FilePath$`
   - **Working directory:** `$ProjectFileDir$`

**Add FUB fixture validation:**
1. Create another external tool with:
   - **Name:** Validate FUB Fixtures
   - **Program:** `/opt/homebrew/bin/yamllint`
   - **Arguments:** `-d relaxed apps/richdesk/tests/fixtures/`
   - **Working directory:** `$ProjectFileDir$`

## Quick IDE Validation Workflows

### VS Code & Cursor

**Keyboard shortcuts** (add to `keybindings.json`):
```json
{
    "key": "ctrl+shift+y",
    "command": "workbench.action.tasks.runTask",
    "args": "Validate FUB Fixtures"
}
```

**Command palette usage:**
- Ctrl/Cmd+Shift+P → "Tasks: Run Task" → "Validate FUB Fixtures"
- Ctrl/Cmd+Shift+P → "Tasks: Run Task" → "Check Current YAML File"

### PHPStorm

**Using external tools:**
- Right-click file/directory → **External Tools** → **Validate YAML**
- Or via menu: **Tools** → **External Tools** → **Validate FUB Fixtures**

## File-Specific Configuration

### Database Fixture Auto-formatting

**VS Code & Cursor configuration:**
```json
{
    "[yaml]": {
        "editor.formatOnSave": true,
        "editor.defaultFormatter": "redhat.vscode-yaml"
    },
    "files.associations": {
        "apps/richdesk/tests/fixtures/*.yml": "yaml"
    }
}
```

### PHPUnit Schema Validation

**Enhanced schema support:**
```json
{
    "yaml.schemas": {
        "https://json.schemastore.org/phpunit.json": [
            "phpunit.yml",
            "phpunit.*.yml",
            "apps/richdesk/tests/phpunit.yml"
        ]
    }
}
```

## Troubleshooting

### VS Code & Cursor Issues

**Check extension status:**
```bash
code --list-extensions | grep yaml
```

**Reset language server:**
- Command palette: Ctrl/Cmd+Shift+P → "Developer: Reload Window"

### PHPStorm External Tools

**Find yamllint path:**
```bash
which yamllint
```

Common paths:
- Homebrew M1 Mac: `/opt/homebrew/bin/yamllint`
- Homebrew Intel Mac: `/usr/local/bin/yamllint`

Update the external tool **Program** field with the correct path.

This configuration provides YAML validation for all major IDEs used in FUB development, with VS Code and Cursor sharing the same setup approach.