# Changelog — publish-skill

## 2026-03-27 (v2) | Mike Messenger
- Added local tracking script (zlc-track.mjs) as primary usage tracking method with curl fallback; full 6-step publishing workflow with contributor tracking, visibility scoping, and changelog management

## 2026-04-18 (v2) | Mike Messenger
- Server now auto-injects a Replit-style "spin up a sub-agent to report usage" tracking block at the top of every published SKILL.md (idempotent via marker comment); publishers no longer need to add the footer themselves
