# Mass Infrastructure Migration

A four-phase framework for migrating many services simultaneously using AI agents, CI/CD pipeline monitoring, and a live dashboard. Proven on a 90-instance agent migration across Trulia Engineering's fleet.

## Prerequisites

- Claude Code available (`claude` CLI)
- `aws-vault` or equivalent credential helper if touching cloud resources
- Git + SSH access to target repositories
- A GitLab/GitHub token for pipeline API calls
- Python 3.9+, `bash`, `jq`

## Quick Start

When the user invokes this skill, ask them to provide:

1. **Inventory CSV** — export of the spreadsheet tracking what needs migrating
2. **Migration spec** — what to remove, what to add, and any official docs/URLs
3. **Repo column name** — which CSV column holds the Git repo identifier
4. **Ownership filter** — which column/value identifies rows that belong to this team
5. **Dashboard type** — Replit, Confluence, GitHub Pages, or local HTML

Then follow the four phases below.

---

## Phase 1: Inventory → Repo Map

**Goal**: Turn the raw spreadsheet into a structured `repo_map.csv` that lists one row per unique Git repository to migrate.

Steps:
1. Copy `templates/inventory.py` into the migration project directory and adapt the constants at the top (filter columns, target keywords, exclude patterns).
2. Place the CSV export at `data/inventory.csv`.
3. Run: `python3 inventory.py --input data/inventory.csv --output-dir output/`
4. Review `output/migration_report.md` — verify the service groupings make sense.
5. Create `data/repo_map.csv` with columns: `serviceTag, cloudAccountName, gitlabRepo`
   - Fill in `gitlabRepo` for each row (e.g., `itx/trulia/applications/my-service`)
   - Rows without a `gitlabRepo` are non-repo workloads (bastions, bare VMs) — handle separately via direct SSH/SSM
6. Split into batches if needed: `repo_map_batch1.csv`, `repo_map_batch2.csv`, etc.

See [INVENTORY_SETUP.md](INVENTORY_SETUP.md) for CSV schema details and filtering logic.

---

## Phase 2: Per-Repo Migration (Parallel)

**Goal**: Run Claude Code in each repo simultaneously to make the actual code changes.

### 2a. Write a Migration Skill

Create a `skill/SKILL.md` (use `templates/migration-skill.md` as the starting point) that tells the agent:
- What to search for (patterns, file types)
- What to remove
- What to add
- How to verify the change

Credentials/secrets that the migration adds to repos should be stored as **CI/CD variables at the group level** (not per-repo), so they're inherited automatically.

### 2b. Run the Orchestrator

Copy `templates/orchestrate.sh`, adapt the variables at the top, then:

```bash
# Dry run first
./orchestrate.sh data/repo_map_batch1.csv --dry-run

# Run for real (3 repos in parallel)
./orchestrate.sh data/repo_map_batch1.csv --jobs 3

# Retry only failed repos
./orchestrate.sh data/repo_map_batch1.csv --resume
```

The orchestrator:
- Clones each repo into `workspaces/<repo-slug>/`
- Creates a migration branch
- Runs Claude Code with the migration skill
- Logs output to `logs/<repo-slug>.log`
- Writes `logs/<repo-slug>.status` (success/failed)

After each batch, review logs: `grep -l failed logs/*.status`

### 2c. Open MRs/PRs

After Claude Code finishes in each repo, open MRs via the GitLab/GitHub API or by pushing and following the remote URL printed by `git push`.

---

## Phase 3: Pipeline Monitoring & Iteration

**Goal**: Get every MR's CI/CD pipeline to green without manual intervention.

See [PIPELINE_MONITOR.md](PIPELINE_MONITOR.md) for the full monitoring workflow.

### Key Pattern

```bash
# Poll the latest pipeline for a specific MR
GITLAB_TOKEN=<token> ./scripts/check_pipeline.sh <project_path> <mr_iid>
```

When a job fails:
1. Read the job log (GitLab API: `GET /projects/:id/jobs/:job_id/trace`)
2. Identify the root cause (look for the first non-trivial error line)
3. Fix the underlying file in the workspace
4. Commit and push — the pipeline re-triggers automatically

**Common failure categories and fixes:**

| Symptom | Root cause | Fix |
|---|---|---|
| `command not found` in CI | Wrong Docker image / missing tool | Upgrade base image or install dependency |
| `AccessDenied` for cloud operations | Wrong IAM role or runner credentials | Update runner tags or IAM policy |
| Plugin/provider version conflicts | Pinned version incompatible with tool | Pin explicitly to compatible version |
| DNS lookup failure in CI | Internal DNS unreachable from runner network | Use `-refresh=false` or `-target` to skip data sources |
| ELB health check timeout | App slow to start in new environment | Increase or disable Terraform capacity wait |
| Volume size too small | AMI snapshot larger than launch config | Increase `root_volume_size` in Terraform variables |

Commit fixes with a consistent prefix so they're traceable: `[TICKET-ID]: fix: <description>`

When iteration is complete, **squash** the fix commits into logical groups before merging. See the squash pattern in [PIPELINE_MONITOR.md](PIPELINE_MONITOR.md).

---

## Phase 4: Dashboard

**Goal**: Maintain a live, shareable view of migration progress for management and partner teams.

See [DASHBOARD_SETUP.md](DASHBOARD_SETUP.md) for setup.

### Structure

The dashboard tracks each service with:
- Status pill (Planned / MR Opened / Completed / Legacy-Decommission / Not Ours)
- Cloud account, instance count
- MR link
- A progress bar that counts only team-owned instances (excludes "not ours")

### Update Pattern

After any status change:
1. Edit `output/progress-report.html` directly (status pills, counts, progress bar)
2. Run `./sync-dashboard.sh` to push to the hosted view

---

## Non-Repo Workloads (Bastions, Bare VMs)

For instances not managed by a Git repo:
- Use `templates/migrate_bastions.sh` for SSH-based direct migration
- Use AWS SSM (`aws ssm send-command`) for instances with SSM agent
- Use EC2 Instance Connect Endpoints for private instances without bastion access
- For OS upgrades needed before the migration tool can run: `do-release-upgrade` (Ubuntu in-place) or AMI replacement

---

## Handling Exceptions

| Situation | Action |
|---|---|
| Kernel/OS too old for new agent | Mark as "Legacy / Decommission — Incompatible". Count in progress bar but note separately. |
| No working deploy pipeline | Assess risk of manual install via SSH/SSM. Document in dashboard. |
| Repo managed by another team | Move to "Not Ours / Excluded" with team contact. Exclude from progress percentage. |
| Instance already decommissioned | Mark as "Completed — Instance Stopped". |
| Cross-account AMI sharing blocked by encryption policy | Build AMI directly in the target account instead of sharing. |