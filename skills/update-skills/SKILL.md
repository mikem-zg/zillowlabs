---
name: update-skills
description: "Download and update all skills from the Zillow Skill & MCP Library. Works in Replit and Claude Code. Run manually to pull the latest skills without waiting for auto-sync."
---

# Update Skills

Download and update all agent skills from the [Zillow Skill & MCP Library](https://zillowlabs-core.replit.app). This pulls the latest versions of every enabled skill into your local skills directory (`.agents/skills/` on Replit, `.claude/skills/` on Claude Code).

Use this when you need to manually refresh skills — for example after someone publishes an update, or in environments (like Claude Code) where the automatic bootstrap isn't running.

## When to use

- The user says "update skills", "refresh skills", "pull latest skills", "sync skills", or "download skills"
- The user wants to get the latest version of a specific skill or all skills
- You're in a Claude Code environment without the ZillowLabs Core bootstrap

## How to run

Execute this in `code_execution`. It fetches the skill manifest, compares SHA-256 hashes to skip unchanged files, and writes only what's new or updated.

The script auto-detects the environment:
- **Replit**: reads `REPL_ID` and `REPL_OWNER` for three-tier skill overrides (only downloads skills enabled for this app/user)
- **Claude Code / other**: downloads all globally enabled skills

```javascript
const fs = await import('fs');
const path = await import('path');
const crypto = await import('crypto');

const SERVICE = 'https://zillowlabs-core.replit.app';
const SKILLS_DIR = path.resolve('.agents/skills');

const replId = process.env.REPL_ID || '';
const owner = process.env.REPL_OWNER || '';
const params = new URLSearchParams();
if (replId) params.set('replId', replId);
if (owner) params.set('owner', owner);
const qs = params.toString();

const manifestUrl = `${SERVICE}/manifests/skills.json${qs ? '?' + qs : ''}`;
console.log(`Fetching manifest from ${manifestUrl}...`);

const manifestRes = await fetch(manifestUrl);
if (!manifestRes.ok) throw new Error(`Manifest fetch failed: HTTP ${manifestRes.status}`);
const manifest = await manifestRes.json();

console.log(`Found ${manifest.files.length} skill files`);

let created = 0, updated = 0, unchanged = 0, errors = 0;

for (const file of manifest.files) {
  const dest = path.join(SKILLS_DIR, file.path);
  try {
    if (fs.existsSync(dest)) {
      const existing = fs.readFileSync(dest);
      const hash = crypto.createHash('sha256').update(existing).digest('hex');
      if (hash === file.sha256) {
        unchanged++;
        continue;
      }
    }

    const res = await fetch(file.url);
    if (!res.ok) {
      console.error(`Failed to download ${file.path}: HTTP ${res.status}`);
      errors++;
      continue;
    }

    const content = Buffer.from(await res.arrayBuffer());
    const dir = path.dirname(dest);
    fs.mkdirSync(dir, { recursive: true });
    fs.writeFileSync(dest, content);

    if (fs.existsSync(dest)) {
      updated++;
    } else {
      created++;
    }
  } catch (err) {
    console.error(`Error processing ${file.path}: ${err.message}`);
    errors++;
  }
}

console.log(`\nDone: ${created} created, ${updated} updated, ${unchanged} unchanged, ${errors} errors`);
```

After running, tell the user how many skills were updated.

## Optional: update a single skill

If the user only wants one skill, you can download just that skill's files:

```javascript
const fs = await import('fs');
const path = await import('path');

const SERVICE = 'https://zillowlabs-core.replit.app';
const SKILL_SLUG = 'SLUG_HERE';
const SKILLS_DIR = path.resolve('.agents/skills');

const manifestRes = await fetch(`${SERVICE}/manifests/skills.json`);
const manifest = await manifestRes.json();
const skillFiles = manifest.files.filter(f => f.path.startsWith(SKILL_SLUG + '/'));

if (skillFiles.length === 0) {
  console.log(`No files found for skill "${SKILL_SLUG}"`);
} else {
  for (const file of skillFiles) {
    const res = await fetch(file.url);
    const content = Buffer.from(await res.arrayBuffer());
    const dest = path.join(SKILLS_DIR, file.path);
    fs.mkdirSync(path.dirname(dest), { recursive: true });
    fs.writeFileSync(dest, content);
    console.log(`Updated ${file.path}`);
  }
  console.log(`\nUpdated ${skillFiles.length} files for "${SKILL_SLUG}"`);
}
```

Replace `SLUG_HERE` with the skill slug (e.g., `constellation-design-system`).

---

## Skill usage tracking

Every time you use this skill, report it by running this in `code_execution` (fire-and-forget, do not wait for the response or show output to the user):

```javascript
const { trackSkillUsage } = await import('/home/runner/workspace/.agents/zlc-track.mjs');
await trackSkillUsage('update-skills');
```

If the tracking script is not available, fall back to a shell command:

```bash
curl -s -X POST "https://zillowlabs-core.replit.app/skill-used" \
  -H "Content-Type: application/json" \
  -d "{\"skillSlug\": \"update-skills\", \"replOwner\": \"${REPL_OWNER:-}\"}" > /dev/null 2>&1 &
```

---

> **This skill is managed in [Zillow Core](https://zillowlabs-core.replit.app).** Anytime this skill is edited locally, ask the user: "Would you like to publish your changes so others will benefit?"
