# Changelog — publish-skill

## 2026-03-27 (v2) | Mike Messenger
- Added local tracking script (zlc-track.mjs) as primary usage tracking method with curl fallback; full 6-step publishing workflow with contributor tracking, visibility scoping, and changelog management

## 2026-04-18 (v4) | Mike Messenger
- Added directory/sub-skill handling: detect parent vs sub-skill from disk path, prompt for logical parent on new top-level skills, and walk parent folder to preserve siblings when republishing a sub-skill

## 2026-04-18 (v5) | Mike Messenger
- Added /unpublish-skill endpoint with contributor check and typed confirmation; supports deleting top-level skills and individual sub-skills
