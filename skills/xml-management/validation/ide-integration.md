# IDE Integration for XML Support

Basic XML support configuration for VS Code, Cursor, and PHPStorm in FUB development.

## VS Code & Cursor Configuration

### Basic XML Settings

**Workspace settings for XML files:**
```json
{
    "xml.validation.enabled": true,
    "xml.format.enabled": true,
    "files.associations": {
        "*.xml": "xml"
    },
    "[xml]": {
        "editor.defaultFormatter": "redhat.vscode-xml",
        "editor.formatOnSave": true,
        "editor.insertSpaces": true,
        "editor.tabSize": 2
    }
}
```

**Save as `.vscode/settings.json`**

### XML Extension

**Install XML Language Support:**
```bash
# VS Code
code --install-extension redhat.vscode-xml

# Cursor uses same extensions as VS Code
```

### Tasks for Validation

**Add XML validation task:**
```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Validate XML",
            "type": "shell",
            "command": "xmllint",
            "args": ["--noout", "${file}"],
            "group": "test",
            "presentation": {
                "reveal": "always"
            }
        }
    ]
}
```

**Save as `.vscode/tasks.json`**

## PHPStorm Configuration

### XML Support Setup

**Enable XML validation:**
1. Go to **Settings** → **Languages & Frameworks** → **Schemas and DTDs**
2. Enable "XML Schema validation"
3. Set indentation: **Settings** → **Code Style** → **XML** → **Tabs and Indents** → **2 spaces**

### External Tools

**Add xmllint validation:**
1. **Settings** → **Tools** → **External Tools** → **Add**
2. Configure:
   - **Name:** Validate XML
   - **Program:** `/opt/homebrew/bin/xmllint`
   - **Arguments:** `--noout $FilePath$`
   - **Working directory:** `$ProjectFileDir$`

## Quick Validation

### Keyboard Shortcuts

**VS Code/Cursor shortcuts:**
```json
[
    {
        "key": "ctrl+shift+x",
        "command": "workbench.action.tasks.runTask",
        "args": "Validate XML"
    }
]
```

**Add to `keybindings.json`**

### Command Palette

**Quick XML operations:**
- `Ctrl/Cmd+Shift+P` → "Tasks: Run Task" → "Validate XML"
- `Ctrl/Cmd+Shift+P` → "Format Document" (formats current XML file)

## Schema Support

### Basic Schema Configuration

**VS Code/Cursor XML schemas:**
```json
{
    "xml.catalogs": [
        "catalogs/catalog.xml"
    ],
    "xml.fileAssociations": [
        {
            "pattern": "**/*-config.xml",
            "systemId": "config-schema.xsd"
        }
    ]
}
```

## Troubleshooting

### Common Issues

**XML extension not working:**
```bash
# Check xmllint is available
which xmllint

# Install if missing
brew install libxml2

# Verify VS Code/Cursor can find it
code --list-extensions | grep xml
```

**PHPStorm XML validation issues:**
1. Verify **File** → **File Types** → **XML** includes `*.xml`
2. Check **Settings** → **Languages & Frameworks** → **Schemas and DTDs**
3. Ensure external tool path is correct: `/opt/homebrew/bin/xmllint`

This minimal guide provides essential XML IDE support without assuming extensive XML development in FUB workflows.