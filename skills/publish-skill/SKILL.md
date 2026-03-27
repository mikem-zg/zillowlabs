---
name: publish-skill
description: "Publish a skill from any project to the Zillow Skill & MCP Library. The skill is stored in the library database, auto-synced to GitHub, and available for download immediately. If a skill with the same name already exists, it is overwritten with the new content."
---

# Publish Skill

Publish any agent skill to the [Zillow Skill & MCP Library](https://zillowlabs-core.replit.app) from any Replit project or Claude Code workspace. The skill is saved to the library's database, auto-synced to [GitHub](https://github.com/mikem-zg/zillowlabs), and available for browsing and installation immediately.

## How it works

1. You call `POST https://zillowlabs-core.replit.app/publish-skill` with the skill content
2. The library saves it to the database (or updates the existing entry if the name matches)
3. The skill is automatically pushed to GitHub under `skills/{slug}/`
4. Downstream consumers (Claude Code marketplace, Replit auto-sync) are notified

**No API key or authentication is required.**

## Endpoint

```
POST https://zillowlabs-core.replit.app/publish-skill
Content-Type: application/json
```

## Request body

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | Yes | Skill name (min 2 chars). Used as the unique key — if a skill with this name exists, it is overwritten. |
| `description` | string | Yes | Short description of the skill (min 10 chars, max 1000). |
| `skillMdContent` | string | Yes | Full content of the SKILL.md file (min 20 chars, max 50,000). Include frontmatter if desired. |
| `tags` | string[] | Yes | Array of 1–5 tags (e.g., `["development", "testing"]`). |
| `authorName` | string | Yes | Display name of the author (min 2 chars). The agent should ask the user for their name if not already known. |
| `additionalFiles` | object[] | No | Extra files to include alongside SKILL.md (max 20 files, 2MB total). Each object: `{ name, path, content }`. |

## Response

### Success (201 Created or 200 Updated)

```json
{
  "success": true,
  "action": "created",
  "skill": {
    "id": "abc123-...",
    "name": "my-skill",
    "slug": "my-skill",
    "description": "...",
    "tags": ["development"],
    "authorName": "Jane Doe",
    "version": 1,
    "files": [{ "name": "SKILL.md", "path": "SKILL.md" }],
    "createdAt": "2026-03-27T05:00:00.000Z",
    "updatedAt": "2026-03-27T05:00:00.000Z"
  }
}
```

The `action` field is `"created"` for new skills or `"updated"` for overwrites.

### Error (400 / 500)

```json
{ "error": "description is required (min 10 characters)" }
```

## Usage

### Publish from the current project

Read the local SKILL.md and auto-populate Replit context:

```bash
SKILL_DIR=".agents/skills/my-skill"
SKILL_CONTENT=$(cat "$SKILL_DIR/SKILL.md")

curl -s -X POST "https://zillowlabs-core.replit.app/publish-skill" \
  -H "Content-Type: application/json" \
  -d "$(jq -n \
    --arg name "my-skill" \
    --arg desc "A skill that does something useful" \
    --arg content "$SKILL_CONTENT" \
    --arg owner "${REPL_OWNER:-}" \
    '{
      name: $name,
      description: $desc,
      skillMdContent: $content,
      tags: ["development", "tooling"],
      replOwner: $owner
    }'
  )"
```

### Publish with additional files

If your skill has reference files (e.g., `references/api-guide.md`, `scripts/validate.sh`):

```bash
curl -s -X POST "https://zillowlabs-core.replit.app/publish-skill" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "my-skill",
    "description": "A skill with reference files",
    "skillMdContent": "# My Skill\n\nSee references/api-guide.md for details.",
    "tags": ["development"],
    "authorName": "Your Name",
    "additionalFiles": [
      {
        "name": "api-guide.md",
        "path": "references/api-guide.md",
        "content": "# API Guide\n\nDetailed API documentation..."
      },
      {
        "name": "validate.sh",
        "path": "scripts/validate.sh",
        "content": "#!/bin/bash\necho \"Running validation...\""
      }
    ]
  }'
```

### Publish from JavaScript/TypeScript (agent code)

```typescript
const SKILL_DIR = ".agents/skills/my-skill";
const skillContent = fs.readFileSync(path.join(SKILL_DIR, "SKILL.md"), "utf-8");

const res = await fetch("https://zillowlabs-core.replit.app/publish-skill", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({
    name: "my-skill",
    description: "A skill that does something useful",
    skillMdContent: skillContent,
    tags: ["development", "tooling"],
    replOwner: process.env.REPL_OWNER,
  }),
});

const result = await res.json();
console.log(result.action); // "created" or "updated"
```

## Overwrite behavior

The skill name is the unique key. If you publish a skill with a name that already exists in the library:

- The existing skill's description, content, tags, and files are **replaced** with the new values
- The version number is incremented
- A new GitHub commit is created
- The `action` field in the response is `"updated"`

This makes it safe to re-publish after every change — the library always reflects the latest version.

## After publishing

Once published, your skill is:

1. **In the registry** at `https://zillowlabs-core.replit.app` — an admin can enable it for distribution
2. **On GitHub** at `https://github.com/mikem-zg/zillowlabs/tree/main/skills/{slug}/`
3. **Auto-synced** to all connected apps that have the skill enabled (on their next bootstrap)
4. **Accessible** via the public files API at `https://zillowlabs-core.replit.app/files/skills/{slug}/SKILL.md`

## Limits

| Constraint | Value |
|-----------|-------|
| SKILL.md content | 20–50,000 characters |
| Description | 10–1,000 characters |
| Tags | 1–5 tags |
| Additional files | Max 20 files |
| Total file size | Max 2MB (all files combined) |
| File paths | No `..` traversal, no absolute paths |
