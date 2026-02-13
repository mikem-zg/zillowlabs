# Agent Skills Specification

Reference for the Agent Skills open standard. Based on the official spec at https://agentskills.io/specification (maintained by Anthropic, adopted by OpenAI, Microsoft, Google, and others).

## Contents
- Directory structure
- SKILL.md format
- Frontmatter fields (complete reference)
- Body content guidelines
- Optional directories
- Progressive disclosure
- File references
- Validation rules

## Directory Structure

A skill is a directory containing at minimum a SKILL.md file:

```
skill-name/
├── SKILL.md              # Required
├── scripts/              # Optional: executable code
├── references/           # Optional: documentation for context
└── assets/               # Optional: files used in output
```

## SKILL.md Format

The file must contain YAML frontmatter (between `---` markers) followed by Markdown content.

```yaml
---
name: skill-name
description: A description of what this skill does and when to use it.
---

# Instructions here
```

## Frontmatter Fields

### name (required)

| Rule | Constraint |
|------|-----------|
| Length | 1-64 characters |
| Characters | Lowercase letters (a-z), numbers (0-9), hyphens (-) |
| Start/end | Cannot start or end with hyphen |
| Consecutive | No consecutive hyphens (--) |
| Match | Must match parent directory name |
| Reserved | Cannot contain "anthropic" or "claude" |

Valid: `pdf-processing`, `data-analysis`, `code-review`
Invalid: `PDF-Processing` (uppercase), `-pdf` (leading hyphen), `pdf--processing` (consecutive)

### description (required)

| Rule | Constraint |
|------|-----------|
| Length | 1-1024 characters |
| Content | Must describe WHAT and WHEN |
| Voice | Third person ("Processes X" not "I help with X") |
| Forbidden | No XML tags |

The description is the primary triggering mechanism. Claude uses it to decide which skill to load from potentially 100+ available skills.

Good:
```yaml
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

Bad:
```yaml
description: Helps with PDFs.
```

### license (optional)

Short string or reference to bundled license file.

```yaml
license: Apache-2.0
license: Complete terms in LICENSE.txt
```

### compatibility (optional)

Environment requirements. Max 500 characters.

```yaml
compatibility: Designed for Claude Code. Requires git and docker.
compatibility: Requires Python 3.10+ and pdfplumber library.
```

### metadata (optional)

Arbitrary key-value map (string keys to string values) for client-specific use.

```yaml
metadata:
  author: example-org
  version: "1.0"
  category: data-processing
```

### allowed-tools (optional, experimental)

Space-delimited list of pre-approved tools.

```yaml
allowed-tools: Bash(git:*) Bash(jq:*) Read Write
```

### INVALID fields (will cause validation errors)

The following fields are NOT part of the spec and must never be used:

| Invalid Field | Alternative |
|--------------|-------------|
| `parameters` | Document parameters in the body text |
| `argument-hint` | Document usage in the body text |
| `version` | Use `metadata.version` |
| `author` | Use `metadata.author` |
| `tags` | Use `metadata.tags` |
| `category` | Use `metadata.category` |

## Body Content

The Markdown body after frontmatter contains skill instructions. There are no format restrictions — write whatever helps agents perform the task effectively.

Recommended sections:
- Step-by-step instructions
- Examples of inputs and outputs
- Common edge cases
- Links to reference files

The agent loads the entire SKILL.md once it decides to activate the skill. Keep it under 500 lines and split longer content into referenced files.

## Optional Directories

### scripts/

Executable code (Python, Bash, JavaScript, etc.) that agents can run directly.

Guidelines:
- Self-contained or clearly document dependencies
- Include helpful error messages
- Handle edge cases gracefully
- May be executed without loading into context (token efficient)

### references/

Documentation loaded into context on demand:
- API documentation
- Database schemas
- Domain-specific guides
- Company policies
- Detailed workflow instructions

Keep individual files focused. Agents load these on demand, so smaller files = less context used.

### assets/

Static resources used in output (not loaded into context):
- Templates (.pptx, .docx, HTML boilerplate)
- Images (.png, .svg)
- Fonts (.ttf, .woff2)
- Sample data files

## Progressive Disclosure

Three-level loading system:

| Level | What | When | Size |
|-------|------|------|------|
| 1. Metadata | name + description | Always in context | ~100 tokens |
| 2. SKILL.md body | Full instructions | When skill triggers | <5000 tokens |
| 3. Resources | Scripts, references, assets | As needed by Claude | Unlimited |

### Key rules
- SKILL.md body under 500 lines
- References one level deep from SKILL.md (no nested chains)
- Files >100 lines should have table of contents
- Don't duplicate between SKILL.md and references

## File References

Use relative paths from the skill root:

```markdown
See [the reference guide](references/guide.md) for details.
Run: scripts/extract.py
```

## Validation

A valid skill must:
1. Have a SKILL.md file at the directory root
2. Have valid YAML frontmatter with `name` and `description`
3. Have `name` matching the directory name
4. Have `name` following naming conventions (lowercase, hyphens, 1-64 chars)
5. Have non-empty `description` under 1024 chars
6. Have no invalid frontmatter fields
7. Have no XML tags in name or description

## Platform Support

The Agent Skills format is supported by:
- Anthropic: Claude Code, Claude API, Claude Desktop
- OpenAI: ChatGPT, Codex CLI
- Microsoft: VS Code, GitHub Copilot
- Google: Gemini CLI
- Editors: Cursor, Amp, Roo Code
- Frameworks: Goose, Letta, Manus
