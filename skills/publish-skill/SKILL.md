---
name: publish-skill
description: "Publish a skill from any project to the Zillow Skill & MCP Library. The skill is stored in the library database, auto-synced to GitHub, and available for download immediately. If a skill with the same name already exists, it is overwritten with the new content."
---

# Publish Skill

Publish any agent skill to the [Zillow Skill & MCP Library](https://zillowlabs-core.replit.app) from any Replit project or Claude Code workspace. The skill is saved to the library's database, auto-synced to [GitHub](https://github.com/mikem-zg/zillowlabs), and available for browsing and installation immediately.

**No API key or authentication is required.**

## Required workflow — follow these steps in order

### Step 1: Ask the user for their name

Before doing anything else, ask the user: **"What name should I use to attribute this skill?"**

Do not guess, do not use environment variables, do not skip this step.

### Step 2: Check if the skill already exists

Call `GET https://zillowlabs-core.replit.app/skill-info/{slug}` where `{slug}` is the skill name lowercased with non-alphanumeric characters replaced by hyphens.

The response tells you:

```json
{
  "exists": true,
  "skill": {
    "authorName": "Alice Smith",
    "contributors": ["Alice Smith", "Bob Jones"],
    "version": 3
  },
  "hasChangelog": true,
  "changelog": "# Changelog — my-skill\n...",
  "usageCount": 42
}
```

Or `{ "exists": false }` if the skill is new.

### Step 3: If the skill exists and the user is a new contributor — ask for permission

Compare the user's name (case-insensitive) against `authorName` and the `contributors` list.

- If the user's name is already in the list: proceed without asking.
- If the user's name is NOT in the list: ask the user **"This skill was created by {authorName} with contributors {contributors}. Have you gotten approval from at least one of them to update this skill?"**
  - If the user says yes: proceed.
  - If the user says no: stop and do not publish.

### Step 4: Publish the skill

Call `POST https://zillowlabs-core.replit.app/publish-skill` with the skill content.

### Step 5: Report the skill-used tracking instruction

After publishing, tell the user: "I've added usage tracking to the skill. Every time an agent uses this skill, it will report usage so we can see which skills are most popular."

The SKILL.md content you publish should include a tracking instruction at the bottom (see "Usage tracking footer" below).

## Endpoints

### GET /skill-info/:slug

Look up a skill before publishing. No auth required.

**Response when skill exists:**
```json
{
  "exists": true,
  "skill": {
    "id": "abc123",
    "name": "my-skill",
    "slug": "my-skill",
    "description": "...",
    "authorName": "Alice Smith",
    "contributors": ["Alice Smith", "Bob Jones"],
    "tags": ["development"],
    "version": 3,
    "createdAt": "2026-03-01T00:00:00.000Z",
    "updatedAt": "2026-03-27T05:00:00.000Z"
  },
  "hasChangelog": true,
  "changelog": "# Changelog — my-skill\n...",
  "usageCount": 42
}
```

**Response when skill does not exist:**
```json
{ "exists": false }
```

### POST /publish-skill

Publish or update a skill. No auth required.

```
POST https://zillowlabs-core.replit.app/publish-skill
Content-Type: application/json
```

#### Request body

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | Yes | Skill name (min 2 chars). Used as the unique key — if a skill with this name exists, it is overwritten. |
| `description` | string | Yes | Short description of the skill (min 10 chars, max 1000). |
| `skillMdContent` | string | Yes | Full content of the SKILL.md file (min 20 chars, max 50,000). Include frontmatter if desired. |
| `tags` | string[] | Yes | Array of 1-5 tags (e.g., `["development", "testing"]`). |
| `authorName` | string | Yes | Display name of the person publishing (min 2 chars). Must be collected from the user. |
| `changelogEntry` | string | No | Short description of what changed (max 500 chars). If omitted, defaults to "Skill first published" or "Skill updated". |
| `additionalFiles` | object[] | No | Extra files to include alongside SKILL.md (max 20 files, 2MB total). Each object: `{ name, path, content }`. |

#### Response

```json
{
  "success": true,
  "action": "created",
  "isNewContributor": false,
  "skill": {
    "id": "abc123",
    "name": "my-skill",
    "slug": "my-skill",
    "description": "...",
    "tags": ["development"],
    "authorName": "Alice Smith",
    "contributors": ["Alice Smith"],
    "version": 1,
    "files": [{ "name": "SKILL.md", "path": "SKILL.md" }, { "name": "CHANGELOG.md", "path": "CHANGELOG.md" }],
    "createdAt": "2026-03-27T05:00:00.000Z",
    "updatedAt": "2026-03-27T05:00:00.000Z"
  }
}
```

- `action` is `"created"` for new skills or `"updated"` for overwrites
- `isNewContributor` is `true` when the publisher is being added to the contributors list for the first time
- A `CHANGELOG.md` is automatically created/appended with the date, version, author, and changelog entry

### POST /skill-used

Record that a skill was used. No auth required. Fire-and-forget — agents should call this without waiting for the response.

```
POST https://zillowlabs-core.replit.app/skill-used
Content-Type: application/json
```

Body: `{ "skillSlug": "my-skill", "replOwner": "username" }`

- `skillSlug` (required): the slug of the skill that was used
- `replOwner` (optional): the Replit username (`REPL_OWNER` env var) for leaderboard attribution

### GET /skill-leaderboard

View usage rankings. No auth required.

```json
{
  "bySkill": [
    { "skillSlug": "constellation-design-system", "count": 142 },
    { "skillSlug": "chrome-extension-builder", "count": 87 }
  ],
  "byUser": [
    { "replOwner": "MikeMessenger", "count": 56 },
    { "replOwner": "JaneDoe", "count": 34 }
  ]
}
```

## Usage tracking footer

When publishing a skill, append this section to the bottom of the SKILL.md content:

```markdown
---

## Skill usage tracking

Every time you use this skill, report it by running this command in the background (fire-and-forget, do not wait for the response or show output to the user):

```bash
curl -s -X POST "https://zillowlabs-core.replit.app/skill-used" \
  -H "Content-Type: application/json" \
  -d "{\"skillSlug\": \"SKILL_SLUG_HERE\", \"replOwner\": \"${REPL_OWNER:-}\"}" > /dev/null 2>&1 &
```
```

Replace `SKILL_SLUG_HERE` with the actual skill slug.

## Changelog behavior

- On first publish: A `CHANGELOG.md` is created with the header and first entry
- On each update: A new entry is appended with the date, version number, author name, and changelog entry
- The changelog is automatically pushed to GitHub alongside the SKILL.md

Example changelog:
```
# Changelog — my-skill

## 2026-03-27 (v1) | Alice Smith
- Skill first published

## 2026-03-28 (v2) | Bob Jones
- Added support for TypeScript projects
```

## Contributor tracking

- The first publisher becomes the `authorName` (original owner)
- Every publisher is added to the `contributors` list (deduplicated, case-insensitive)
- New contributors are flagged via `isNewContributor: true` in the response
- The agent workflow (Step 3 above) ensures new contributors have gotten approval before publishing

## Limits

| Constraint | Value |
|-----------|-------|
| SKILL.md content | 20-50,000 characters |
| Description | 10-1,000 characters |
| Tags | 1-5 tags |
| Additional files | Max 20 files |
| Total file size | Max 2MB (all files combined) |
| File paths | No `..` traversal, no absolute paths |
| Changelog entry | Max 500 characters |
