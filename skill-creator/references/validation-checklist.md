# Skill Validation Checklist

Use this checklist before publishing or uploading a skill. Each item maps to a common validation error.

## Frontmatter Validation

### Required fields
- [ ] `name` field is present
- [ ] `description` field is present and non-empty

### Name field rules
- [ ] Max 64 characters
- [ ] Lowercase letters, numbers, and hyphens only (regex: `^[a-z0-9]([a-z0-9-]*[a-z0-9])?$`)
- [ ] Does not start or end with a hyphen
- [ ] No consecutive hyphens (`--`)
- [ ] Matches the parent directory name exactly
- [ ] Does not contain reserved words: "anthropic", "claude"
- [ ] Does not contain XML tags

### Description field rules
- [ ] Max 1024 characters
- [ ] Non-empty string
- [ ] Does not contain XML tags
- [ ] Written in third person ("Processes X" not "I help with X" or "You can use this")
- [ ] Includes WHAT the skill does
- [ ] Includes WHEN to use it (trigger conditions)

### Invalid fields (cause "issue with SKILL.md" error)
These fields are NOT part of the Agent Skills spec and must be removed:
- [ ] No `parameters` field
- [ ] No `argument-hint` field
- [ ] No `version` field (use `metadata.version` instead)
- [ ] No `tags` field
- [ ] No `category` field
- [ ] No `author` field (use `metadata.author` instead)

### Optional fields (valid but check format)
- [ ] `license` — short string or reference to LICENSE.txt
- [ ] `compatibility` — max 500 characters, environment requirements
- [ ] `metadata` — key-value map (string keys to string values only)
- [ ] `allowed-tools` — space-delimited tool names (experimental)

## Structure Validation

### Directory structure
- [ ] Skill lives in its own directory
- [ ] Directory name matches `name` field in frontmatter
- [ ] SKILL.md is at the root of the skill directory
- [ ] No extraneous files: README.md, CHANGELOG.md, INSTALLATION_GUIDE.md, etc.

### File organization
- [ ] SKILL.md body is under 500 lines
- [ ] Reference files are in `references/` directory
- [ ] Scripts are in `scripts/` directory
- [ ] Assets are in `assets/` directory
- [ ] All references are one level deep from SKILL.md (no nested chains)

## Content Quality

### SKILL.md body
- [ ] Starts with a brief overview (2-3 sentences)
- [ ] Contains actionable instructions (not just descriptions)
- [ ] Links to reference files with clear "when to read" guidance
- [ ] No information Claude already knows (don't explain what PDFs are, etc.)
- [ ] No setup/testing procedures
- [ ] No user-facing documentation

### Reference files
- [ ] Files over 100 lines have a table of contents at the top
- [ ] No content duplicated between SKILL.md and references
- [ ] Each file is focused on a single topic/domain
- [ ] Large files (>10k words) include grep search patterns in SKILL.md

### Description quality
- [ ] Specific enough to distinguish from other skills
- [ ] Includes relevant keywords users might mention
- [ ] Works as a standalone summary (not dependent on body content)
- [ ] Would help Claude choose this skill from 100+ options

## Common Errors and Fixes

| Error | Cause | Fix |
|-------|-------|-----|
| "There's an issue with SKILL.md" | Invalid frontmatter field | Remove `parameters`, `argument-hint`, or other non-spec fields |
| Skill not triggering | Vague description | Add specific keywords and "Use when..." triggers |
| Skill loads wrong content | Too much in SKILL.md | Split into reference files, keep SKILL.md as overview |
| Context window bloat | Large SKILL.md (>500 lines) | Move detailed content to references/ |
| Name validation error | Uppercase, spaces, or special chars | Use lowercase letters, numbers, hyphens only |
| Inconsistent behavior | Missing instructions | Add concrete examples and specific constraints |

## Quick Validation Command

```bash
# Check frontmatter has only valid fields
head -20 .agents/skills/<name>/SKILL.md

# Verify name matches directory
basename $(dirname .agents/skills/<name>/SKILL.md)

# Check line count (should be under 500)
wc -l .agents/skills/<name>/SKILL.md

# Find invalid fields in frontmatter
grep -E "^(parameters|argument-hint|version|tags|category|author):" .agents/skills/<name>/SKILL.md
```
