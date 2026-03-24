---
name: migration-name
description: >
  Template for a per-repository migration skill. Before using, fill in every
  placeholder, paste in your actual runbook commands, and delete the instruction
  comments.
---

# Migration Skill Template

Before handing this skill to Claude Code, answer these questions and fill in this file:
1. What are you removing? What are you adding?
2. What is the link to the removal runbook? The installation runbook?
3. What ticket/issue tracks this migration?
4. Are there environment-specific constraints or ordering requirements?

---

**What this migration does**: (one-sentence description of what is being removed and what is being added)

**Reference docs**:
- Removal: (URL to uninstall/removal guide)
- Installation: (URL to install guide)
- Ticket: (URL to issue/ticket)

---

## Instructions

Perform all steps in order. Do not skip any step. Confirm each step is complete before moving to the next.

---

### Step 1: Understand the Repository

Before making any changes, explore the repo structure:
- What type of workload is this? (Kubernetes service, Linux VM, serverless, container image, library, etc.)
- What deployment mechanism is used? (Helm, Terraform, Packer, Dockerfile, CI/CD script, etc.)
- Are there multiple environments (dev/stage/prod)? Do they use separate config files or branches?

Summarize what you found in one short paragraph before proceeding.

---

### Step 2: Find All References to the Old Tool

Search the entire repository (case-insensitive) for the old tool name and any related identifiers:
config file names, process names, Docker image names, environment variable names, package names.

Look in all file types: CI/CD pipelines, IaC files, Dockerfiles, shell scripts, userdata, package manifests.

Present a table of every file and line containing a reference before making any edits.

---

### Step 3: Remove the Old Tool

Paste your actual removal runbook commands here, from your team's removal documentation.
Replace this paragraph before using this skill.

---

### Step 4: Add the New Tool

Paste your actual installation runbook commands here, from your team's installation documentation.
Replace this paragraph before using this skill.

One universal rule: store all secrets as CI/CD variables at the group/org level.
Do NOT hardcode credentials in any file.

---

### Step 5: Commit and Open MR

After making all changes, commit with a descriptive message that references the ticket ID.
Open a Merge Request against the default branch.

---

### Step 6: Verify

Present this checklist after all changes are pushed:

- [ ] Old tool is no longer referenced in any file in this repo.
- [ ] New tool configuration is present and complete.
- [ ] Credentials are sourced from CI/CD variables, not hardcoded.
- [ ] CI/CD pipeline passes on the migration branch.
- [ ] After deployment: confirm the new tool is active using the verification
      command from the install guide.

---

## Notes

(Paste any migration-specific caveats here: environment exceptions, ordering
constraints, repos or file patterns to skip, credential variable names, etc.)
