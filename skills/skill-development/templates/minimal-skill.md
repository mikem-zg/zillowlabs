# Minimal Skill Template

Use this template for simple skills with basic instructions and no external dependencies.

```yaml
---
name: skill-name
description: Clear description with usage trigger (max 1024 chars). Include what it does and when to use it.
argument-hint: [expected-arguments]
allowed-tools: Read, Write, Bash
---

## Overview

[2-3 sentences explaining what this skill does and when to use it. Focus on the problem it solves and clear usage triggers.]

## Usage

```bash
/skill-name [arguments]
```

## Core Workflow

### Essential Operations

1. **Step 1**: [Clear action step]
   ```bash
   # Example command or code
   ```

2. **Step 2**: [Next action step]
   ```bash
   # Example command or code
   ```

3. **Step 3**: [Final action step]
   ```bash
   # Example command or code
   ```

## Quick Reference

### Common Patterns

**Pattern 1**: [Brief description]
```bash
# Example command
```

**Pattern 2**: [Brief description]
```bash
# Example command
```

### Troubleshooting

- **Issue**: [Common problem]
  **Solution**: [How to fix it]

- **Issue**: [Another common problem]
  **Solution**: [How to fix it]

## Advanced Patterns

### Complex Scenarios

[Detailed information for advanced usage, edge cases, or complex scenarios that don't fit in Core Workflow]

## Integration Points

### Cross-Skill Workflow Coordination

#### Primary Integration Relationships

| Related Skill | Integration Type | Common Workflows |
|---------------|------------------|------------------|
| `related-skill-1` | **Integration Type** | Workflow description |
| `related-skill-2` | **Integration Type** | Workflow description |

#### Multi-Skill Operation Examples

**Example Workflow:**
```bash
# Multi-skill operation example
/skill-name [args] |\
  /related-skill [args]
```

#### Workflow Handoff Patterns

**From skill-name → Other Skills:**
- Provides: [What this skill provides to other skills]
- Output format: [Expected output format/structure]

**To skill-name ← Other Skills:**
- Receives: [What this skill expects from other skills]
- Input format: [Expected input format/structure]
```

## Usage Notes

### When to Use This Template

- **Simple operations**: Skills that perform straightforward tasks
- **No external dependencies**: Skills that only need basic tools
- **Clear scope**: Well-defined problems with obvious solutions
- **Minimal complexity**: No need for supporting files or complex architecture

### Customization Guidelines

1. **Replace placeholders**: Update all `[bracketed]` content with actual information
2. **Adjust sections**: Remove sections that don't apply to your specific skill
3. **Add specificity**: Include FUB-specific paths, classes, and patterns where relevant
4. **Validate examples**: Ensure all code examples are functional and tested

### Examples of Minimal Skills

- Simple file operations (copy, move, rename)
- Basic text transformations
- Simple API calls with standard patterns
- Basic validation or formatting tasks