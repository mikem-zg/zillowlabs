---
name: skill-creator
description: Create and validate Agent Skills that extend Claude's capabilities with specialized knowledge, workflows, and tool integrations. Use when building new skills, updating existing skills, or troubleshooting SKILL.md validation errors.
---

# Skill Creator

Create effective Agent Skills — modular packages that extend Claude with specialized knowledge, workflows, and tools. Skills transform Claude from a general-purpose agent into a specialized one equipped with procedural knowledge no model fully possesses.

## Core Principles

### 1. Concise is key

The context window is a public good. Claude is already very smart — only add what it doesn't know. Challenge every sentence: "Does this justify its token cost?"

Prefer concise examples over verbose explanations.

### 2. Set appropriate degrees of freedom

Match specificity to task fragility:

| Freedom | When | Format |
|---------|------|--------|
| **High** | Multiple valid approaches, context-dependent | Text instructions |
| **Medium** | Preferred pattern exists, some variation OK | Pseudocode/parameterized scripts |
| **Low** | Fragile operations, consistency critical | Specific scripts, few parameters |

### 3. Progressive disclosure

Skills use three-level loading to manage context efficiently:

1. **Metadata** (~100 tokens) — `name` + `description`, always in context
2. **SKILL.md body** (<5k tokens) — loaded when skill triggers
3. **Bundled resources** (unlimited) — loaded only as needed

Keep SKILL.md under 500 lines. Split detailed content into reference files.

## Anatomy of a Skill

```
skill-name/
├── SKILL.md              # Required — frontmatter + instructions
├── scripts/              # Optional — executable code (Python/Bash)
├── references/           # Optional — docs loaded into context on demand
└── assets/               # Optional — files used in output (templates, images)
```

### SKILL.md structure

```yaml
---
name: my-skill              # Required: lowercase, hyphens, max 64 chars
description: Does X. Use when Y.  # Required: max 1024 chars, third person
---

# Instructions follow here
```

### Frontmatter fields

| Field | Required | Purpose |
|-------|----------|---------|
| `name` | Yes | Lowercase letters, numbers, hyphens. Max 64 chars. Must match directory name. |
| `description` | Yes | What it does + when to use it. Max 1024 chars. Third person. |
| `license` | No | License name or reference to LICENSE.txt |
| `compatibility` | No | Environment requirements (max 500 chars) |
| `metadata` | No | Arbitrary key-value pairs for client use |
| `allowed-tools` | No | Space-delimited pre-approved tools (experimental) |

**Invalid fields that cause errors:** `parameters`, `argument-hint`, `version`, or any field not listed above.

### Bundled resources

**scripts/** — Executable code for deterministic, repetitive tasks. Token-efficient because scripts run without loading into context. Example: `scripts/validate.py`

**references/** — Documentation loaded on demand. Keep SKILL.md lean by moving detailed content here. Example: `references/api-docs.md` for API specs, `references/schemas.md` for database schemas.

**assets/** — Files used in output, never loaded into context. Example: `assets/template.pptx`, `assets/logo.png`

### What NOT to include

- README.md, CHANGELOG.md, INSTALLATION_GUIDE.md
- Setup/testing procedures
- User-facing documentation
- Information Claude already knows

Only include what an AI agent needs to do the job.

## Creation Process

### Step 1: Understand with concrete examples

Before writing anything, understand HOW the skill will be used:

- What specific tasks should it handle?
- What would a user say that triggers it?
- What does Claude get wrong without this skill?

### Step 2: Plan reusable contents

For each example, identify:

1. What code gets rewritten each time → put in `scripts/`
2. What documentation Claude needs to reference → put in `references/`
3. What files the output needs → put in `assets/`

### Step 3: Initialize the skill

```bash
# Run the init script to scaffold the directory
bash .agents/skills/skill-creator/scripts/init-skill.sh <skill-name>
```

This creates the skill directory with a template SKILL.md and example resource directories.

### Step 4: Write the SKILL.md

**Description (critical for discovery):**
- Write in third person ("Processes X" not "I help you with X")
- Include WHAT it does AND WHEN to use it
- Include keywords users might mention
- Max 1024 characters

**Body instructions:**
- Start with a quick overview (2-3 sentences)
- Add core workflow or quick start
- Link to reference files for details
- Keep under 500 lines total

### Step 5: Validate before publishing

Run the automated validation script:

```bash
bash .agents/skills/skill-creator/scripts/validate-skill.sh <skill-name>

# Or validate all skills at once
bash .agents/skills/skill-creator/scripts/validate-skill.sh all
```

The script checks: valid frontmatter fields, name conventions, description length, line count, directory match, and flags known-invalid fields (`parameters`, `argument-hint`, etc.).

For a full manual checklist: See [references/validation-checklist.md](references/validation-checklist.md)

### Step 6: Iterate based on usage

Test with real tasks. Refine description if triggering is inconsistent. Clarify instructions if outputs vary. Build skills only when you've done a task 5+ times and will do it 10+ more.

## Progressive Disclosure Patterns

### Pattern 1: High-level guide with references

```markdown
# PDF Processing

## Quick start
[code example]

## Advanced features
- **Form filling**: See [references/forms.md](references/forms.md)
- **API reference**: See [references/api.md](references/api.md)
```

### Pattern 2: Domain-specific organization

```
bigquery-skill/
├── SKILL.md (overview + navigation)
└── references/
    ├── finance.md
    ├── sales.md
    └── product.md
```

Claude only loads the relevant domain file.

### Pattern 3: Framework variants

```
cloud-deploy/
├── SKILL.md (workflow + selection)
└── references/
    ├── aws.md
    ├── gcp.md
    └── azure.md
```

### Important rules

- Keep references ONE level deep from SKILL.md (no nested chains)
- For files >100 lines, add a table of contents at the top
- Don't duplicate content between SKILL.md and references

## Writing Effective Descriptions

The description is the MOST important field — it determines when Claude selects your skill from potentially 100+ options.

**Good examples:**
```yaml
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

```yaml
description: Build production-ready Follow Up Boss applications. Covers the complete FUB REST API, OAuth 2.0, webhooks, and embedded apps. Use when building FUB integrations or real estate CRM apps.
```

**Bad examples:**
```yaml
description: Helps with PDFs.
description: Does stuff with files.
description: You can use this to process data.  # Don't use second person
```

## Naming Conventions

Use gerund form (verb + -ing) or noun phrases. Lowercase, hyphens only.

**Good:** `processing-pdfs`, `pdf-processing`, `analyzing-spreadsheets`
**Bad:** `PDF-Processing` (uppercase), `helper` (vague), `utils` (generic)

## Skill Templates

| Type | Best For | Structure |
|------|----------|-----------|
| **Workflow** | Sequential processes | Overview → Decision Tree → Steps |
| **Task** | Tool collections | Overview → Quick Start → Task Categories |
| **Reference** | Standards/specs | Overview → Guidelines → Specifications |
| **Integration** | External APIs | Overview → Auth → Endpoints → Webhooks |

## Reference Documents

- **Specification**: See [references/specification.md](references/specification.md) — Complete Agent Skills spec with all frontmatter fields, validation rules, and naming conventions
- **Best practices**: See [references/best-practices.md](references/best-practices.md) — Detailed authoring guidance including conciseness, workflows, feedback loops, and testing
- **Validation checklist**: See [references/validation-checklist.md](references/validation-checklist.md) — Pre-publish validation covering all common "issue with SKILL.md" errors

## Quick Reference

```yaml
# Minimal valid SKILL.md
---
name: my-skill
description: Does X when Y happens. Use when user mentions Z.
---

# My Skill

## Overview
2-3 sentences explaining what this enables.

## Core Workflow
Essential steps only. Link to references for details.

## Resources
- **Detailed guide**: See [references/guide.md](references/guide.md)
```