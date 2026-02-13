# Skill Authoring Best Practices

Detailed guidance for writing effective skills. Based on official Anthropic documentation and community patterns.

## Contents
- Conciseness
- Description writing
- Naming conventions
- Progressive disclosure patterns
- Workflows and feedback loops
- Testing across models
- Common anti-patterns

## Conciseness

### The golden rule
Claude is already very smart. Only add what it doesn't already know. Every token competes with conversation history and other context.

### Good vs bad

Good (~50 tokens):
```python
## Extract PDF text
import pdfplumber
with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

Bad (~150 tokens):
```
PDF (Portable Document Format) files are a common file format that contains
text, images, and other content. To extract text from a PDF, you'll need to
use a library. There are many libraries available...
```

The concise version assumes Claude knows what PDFs are and how pip works.

### Token budget guidelines

| Content | Target |
|---------|--------|
| Description | <200 tokens |
| SKILL.md body | <5000 tokens |
| Reference file | <10000 tokens |
| Total skill (all files) | Minimize — every token has a cost |

## Description Writing

The description is the most critical field. It determines skill discovery and selection.

### Rules
1. **Third person always** — "Processes X" not "I help with X" or "You can use this"
2. **Include WHAT** — specific capabilities
3. **Include WHEN** — trigger conditions, keywords
4. **Be specific** — distinguish from other skills
5. **Max 1024 chars** — but aim for under 200

### Template
```
[What it does — 1-2 sentences]. Use when [trigger conditions]. Covers [specific features/domains].
```

### Examples by skill type

**Integration skill:**
```yaml
description: Build production-ready dotloop applications for real estate transaction management. Covers the complete dotloop Public API v2 — OAuth 2.0, Loops, Loop-It, Participants, Documents, Contacts, and Webhooks. Use when building dotloop integrations or real estate transaction apps.
```

**Tool skill:**
```yaml
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

**Domain skill:**
```yaml
description: Query and analyze BigQuery datasets across finance, sales, product, and marketing domains. Use when the user needs data analysis, metrics, or reports from BigQuery.
```

## Naming Conventions

### Format
- Lowercase letters, numbers, hyphens
- Max 64 characters
- No leading/trailing or consecutive hyphens

### Recommended patterns

| Pattern | Examples |
|---------|----------|
| Gerund (preferred) | `processing-pdfs`, `analyzing-data`, `managing-databases` |
| Noun phrase | `pdf-processing`, `data-analysis`, `database-management` |
| Action | `process-pdfs`, `analyze-data` |

### Avoid
- Vague: `helper`, `utils`, `tools`
- Generic: `documents`, `data`, `files`
- Reserved: names containing `anthropic` or `claude`

## Progressive Disclosure Patterns

### Pattern 1: High-level guide with references
Best for skills with distinct advanced features.

```markdown
# SKILL.md
## Quick start
[Essential workflow]

## Advanced
- **Feature A**: See [references/feature-a.md](references/feature-a.md)
- **Feature B**: See [references/feature-b.md](references/feature-b.md)
```

### Pattern 2: Domain-specific organization
Best for skills spanning multiple knowledge domains.

```
skill/
├── SKILL.md (overview + navigation)
└── references/
    ├── domain-a.md
    ├── domain-b.md
    └── domain-c.md
```

### Pattern 3: Framework/variant organization
Best for skills supporting multiple implementations.

```
skill/
├── SKILL.md (selection guidance)
└── references/
    ├── typescript.md
    ├── python.md
    └── go.md
```

### Anti-patterns
- Deeply nested references (A links to B links to C) — keep one level deep
- Duplicating content between SKILL.md and references
- Loading everything into SKILL.md (>500 lines)
- Reference files without clear "when to read" guidance in SKILL.md

## Workflows and Feedback Loops

### Use workflows for complex tasks
Break complex operations into clear sequential steps. For particularly complex workflows, provide a checklist Claude can track:

```markdown
## Workflow
1. Generate output
2. Validate: `bash scripts/validate.sh output/`
3. If validation fails, fix and re-validate
4. Only proceed when validation passes
5. Finalize
```

### Validation loop pattern
When deterministic validation is possible, always include a validation step:

```markdown
## Required validation
After generating output, always run:
bash scripts/validate.sh <output-file>

Fix all errors before proceeding. Do not skip validation.
```

### Self-correcting patterns
Include explicit error handling guidance:

```markdown
## Common errors
| Error | Cause | Fix |
|-------|-------|-----|
| "Invalid format" | Missing header | Add required header row |
| "Schema mismatch" | Wrong field types | Check references/schema.md |
```

## Testing Across Models

Skills act as additions to models. Test with all models you plan to use:

| Model | Consideration |
|-------|--------------|
| Haiku | Does the skill provide enough guidance? May need more detail. |
| Sonnet | Is it clear and efficient? Good baseline target. |
| Opus | Does it avoid over-explaining? Opus needs less hand-holding. |

If targeting multiple models, aim for instructions that work well with all of them.

## Evaluation-Driven Development

Build evaluations BEFORE writing extensive documentation:

1. **Identify gaps** — Run Claude on tasks WITHOUT skill, document failures
2. **Create evaluations** — 3+ scenarios testing specific gaps
3. **Establish baseline** — Measure Claude's performance without skill
4. **Write minimal instructions** — Just enough to pass evaluations
5. **Iterate** — Run evaluations, compare, refine

This prevents over-engineering and ensures skills solve real problems.

## Common Anti-Patterns

| Anti-Pattern | Better Approach |
|-------------|----------------|
| Explaining concepts Claude knows | Jump to the specific, non-obvious details |
| Listing every possible option | Show the recommended path, link to alternatives |
| Verbose prose where a table suffices | Use tables for structured information |
| Instructions spread across many files | Keep core workflow in SKILL.md, details in references |
| No examples, just descriptions | Always include at least one concrete example |
| Outdated information | Remove or update — wrong info is worse than no info |
| Copy-pasting from docs | Distill to what Claude needs, not what humans read |
