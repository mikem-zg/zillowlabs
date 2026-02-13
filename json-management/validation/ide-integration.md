# IDE Integration for JSON Validation

VS Code, Cursor, and PHPStorm configuration for JSON validation and formatting in FUB development.

## VS Code & Cursor Configuration for FUB

### Essential JSON Settings

**Workspace Configuration (Compatible with both VS Code and Cursor):**
```json
{
    "json.validate.enable": true,
    "json.format.enable": true,
    "json.schemas": [
        {
            "fileMatch": ["package.json"],
            "url": "https://json.schemastore.org/package.json"
        },
        {
            "fileMatch": ["tsconfig*.json"],
            "url": "https://json.schemastore.org/tsconfig.json"
        },
        {
            "fileMatch": ["apps/richdesk/config/*.json"],
            "url": "./schemas/config/app-config.json"
        },
        {
            "fileMatch": ["schemas/**/*.json"],
            "url": "http://json-schema.org/draft-07/schema#"
        }
    ],

    "files.associations": {
        "*.json": "json",
        ".jsonlintrc": "json",
        "apps/richdesk/config/*.json": "jsonc",
        "schemas/*.json": "json"
    },

    "[json]": {
        "editor.defaultFormatter": "vscode.json-language-features",
        "editor.formatOnSave": true,
        "editor.insertSpaces": true,
        "editor.tabSize": 2,
        "editor.detectIndentation": false
    },

    "[jsonc]": {
        "editor.defaultFormatter": "vscode.json-language-features",
        "editor.formatOnSave": true
    }
}
```

Save as `.vscode/settings.json` (works in both VS Code and Cursor).

### FUB JSON Validation Tasks

**Validation Tasks Configuration:**
```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Validate FUB JSON Files",
            "type": "shell",
            "command": "jsonlint",
            "args": ["${workspaceFolder}/apps/richdesk/config/*.json"],
            "group": "test",
            "presentation": {
                "echo": true,
                "reveal": "always"
            },
            "problemMatcher": {
                "pattern": {
                    "regexp": "^Error: (.+) on line (\\d+):$",
                    "file": 1,
                    "line": 2,
                    "message": 0
                }
            }
        },
        {
            "label": "Validate Current JSON File",
            "type": "shell",
            "command": "jsonlint",
            "args": ["${file}"],
            "group": "test"
        },
        {
            "label": "Format All Package.json Files",
            "type": "shell",
            "command": "find",
            "args": [
                ".", "-name", "package.json",
                "-not", "-path", "./node_modules/*",
                "-exec", "jsonlint", "--format", "--in-place", "{}", ";"
            ],
            "group": "build"
        },
        {
            "label": "Validate JSON Schema",
            "type": "shell",
            "command": "ajv",
            "args": ["validate", "-s", "${input:schemaFile}", "-d", "${file}"],
            "group": "test"
        }
    ],
    "inputs": [
        {
            "id": "schemaFile",
            "type": "promptString",
            "description": "Path to JSON Schema file"
        }
    ]
}
```

Save as `.vscode/tasks.json`.

### Extensions and Installation

**VS Code Extensions:**
```bash
code --install-extension ms-vscode.vscode-json
code --install-extension tamasfe.even-better-toml  # For config files
```

**Cursor Extensions:**
- Use command palette: Ctrl/Cmd+Shift+P → "Extensions: Install Extensions"
- Search for "JSON" and install official JSON language features
- All VS Code JSON extensions work in Cursor

## PHPStorm Configuration for FUB

### JSON Plugin Setup

1. Go to **Settings** → **Editor** → **File Types** → **JSON**
2. Add patterns for FUB-specific JSON files:
   - `apps/richdesk/config/*.json`
   - `schemas/*.json`
   - `.jsonlintrc`

### External Tool Configuration

**Add jsonlint validation:**
1. Go to **Settings** → **Tools** → **External Tools** → **Add**
2. Configure:
   - **Name:** Validate JSON
   - **Program:** `/opt/homebrew/bin/jsonlint`
   - **Arguments:** `$FilePath$`
   - **Working directory:** `$ProjectFileDir$`

**Add JSON Schema validation:**
1. Create another external tool:
   - **Name:** Validate JSON Schema
   - **Program:** `/opt/homebrew/bin/ajv`
   - **Arguments:** `validate -s $Prompt$ -d $FilePath$`
   - **Working directory:** `$ProjectFileDir$`

**Add JSON formatting:**
1. Create formatting tool:
   - **Name:** Format JSON
   - **Program:** `/opt/homebrew/bin/jsonlint`
   - **Arguments:** `--format --in-place $FilePath$`
   - **Working directory:** `$ProjectFileDir$`

### Code Style Configuration

**JSON Code Style in PHPStorm:**
1. Go to **Settings** → **Editor** → **Code Style** → **JSON**
2. Configure:
   - **Indent:** 2 spaces
   - **Keep indents on empty lines:** false
   - **Wrap long lines:** true at 120 characters

## Quick IDE Validation Workflows

### VS Code & Cursor Workflow

**Keyboard Shortcuts (add to `keybindings.json`):**
```json
[
    {
        "key": "ctrl+shift+j",
        "command": "workbench.action.tasks.runTask",
        "args": "Validate Current JSON File"
    },
    {
        "key": "ctrl+alt+j",
        "command": "workbench.action.tasks.runTask",
        "args": "Validate FUB JSON Files"
    }
]
```

**Command Palette Usage:**
- Ctrl/Cmd+Shift+P → "Tasks: Run Task" → "Validate FUB JSON Files"
- Ctrl/Cmd+Shift+P → "Format Document" (for current JSON file)
- Ctrl/Cmd+Shift+P → "Tasks: Run Task" → "Validate JSON Schema"

### PHPStorm Workflow

**Using external tools:**
- Right-click JSON file → **External Tools** → **Validate JSON**
- Or via menu: **Tools** → **External Tools** → **Format JSON**
- For schema validation: **Tools** → **External Tools** → **Validate JSON Schema**

## Schema Integration

### VS Code & Cursor Schema Configuration

**FUB-specific schema associations:**
```json
{
    "json.schemas": [
        {
            "fileMatch": ["apps/richdesk/config/database.json"],
            "url": "./schemas/config/database-config.json"
        },
        {
            "fileMatch": ["apps/richdesk/config/api.json"],
            "url": "./schemas/config/api-config.json"
        },
        {
            "fileMatch": ["apps/richdesk/tests/data/users.json"],
            "url": "./schemas/test-data/users.json"
        },
        {
            "fileMatch": ["apps/richdesk/tests/data/contacts.json"],
            "url": "./schemas/test-data/contacts.json"
        }
    ]
}
```

### Schema Validation Workflow

**Automated schema validation in IDE:**
1. Create schemas in `schemas/` directory
2. Configure file associations in `.vscode/settings.json`
3. IDE automatically validates JSON files against schemas
4. Get real-time validation errors and autocomplete

## File-Specific Configuration

### Package.json Auto-formatting

**VS Code & Cursor configuration for package.json:**
```json
{
    "files.associations": {
        "package.json": "json"
    },
    "[json]": {
        "editor.formatOnSave": true,
        "editor.codeActionsOnSave": {
            "source.fixAll": true
        }
    },
    "json.schemas": [
        {
            "fileMatch": ["package.json"],
            "url": "https://json.schemastore.org/package.json"
        }
    ]
}
```

### FUB Configuration Files

**Enhanced validation for FUB config files:**
```json
{
    "files.associations": {
        "apps/richdesk/config/*.json": "jsonc"
    },
    "[jsonc]": {
        "editor.quickSuggestions": {
            "strings": true
        },
        "editor.suggest.insertMode": "replace"
    }
}
```

## Troubleshooting

### VS Code & Cursor Issues

**JSON Extension Problems:**
```bash
# Check installed extensions
code --list-extensions | grep json

# Reset JSON language server
# Command palette: "Developer: Reload Window"
```

**Schema Validation Issues:**
- Verify schema file paths are correct
- Check schema syntax with: `ajv compile -s schema.json`
- Ensure file patterns match exactly in settings

### PHPStorm External Tools

**Tool Path Detection:**
```bash
# Find correct paths
which jsonlint ajv jq

# Common paths:
# Homebrew M1: /opt/homebrew/bin/jsonlint
# Homebrew Intel: /usr/local/bin/jsonlint
# NPM global: /usr/local/bin/jsonlint
```

**Update External Tool Paths:**
1. Go to **Settings** → **Tools** → **External Tools**
2. Edit tool and update **Program** field with correct path

## Advanced IDE Integration

### Custom JSON Snippets

**VS Code JSON snippets for FUB patterns:**
```json
{
    "FUB User Object": {
        "prefix": "fub-user",
        "body": [
            "{",
            "  \"id\": ${1:1},",
            "  \"username\": \"${2:username}\",",
            "  \"email\": \"${3:user@example.com}\",",
            "  \"active\": ${4:true},",
            "  \"role\": \"${5|admin,user,viewer|}\"",
            "}"
        ],
        "description": "FUB user object template"
    },
    "FUB API Response": {
        "prefix": "fub-api-response",
        "body": [
            "{",
            "  \"data\": [",
            "    $1",
            "  ],",
            "  \"meta\": {",
            "    \"total\": ${2:0},",
            "    \"page\": ${3:1},",
            "    \"limit\": ${4:20}",
            "  }",
            "}"
        ],
        "description": "FUB API response template"
    }
}
```

### Live Templates in PHPStorm

**Create JSON live templates for FUB:**
1. Go to **Settings** → **Editor** → **Live Templates**
2. Create new template group "FUB JSON"
3. Add templates for common FUB JSON patterns

This configuration provides comprehensive JSON validation and editing capabilities for all major IDEs used in FUB development, with schema integration and automated validation workflows.