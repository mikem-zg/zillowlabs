# Pipeline Monitoring & Iteration

## Polling Pipeline Status (GitLab)

```bash
# Get latest pipeline status for a project's MR
PROJECT_ID="itx%2Ftrulia%2Fapplications%2Fmy-service"  # URL-encoded path
MR_IID=42

curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  "https://gitlab.example.com/api/v4/projects/${PROJECT_ID}/merge_requests/${MR_IID}/pipelines" \
  | jq -r '.[0] | {id, status, web_url}'
```

```bash
# List jobs in a pipeline and their statuses
PIPELINE_ID=12345
curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  "https://gitlab.example.com/api/v4/projects/${PROJECT_ID}/pipelines/${PIPELINE_ID}/jobs" \
  | jq -r '.[] | [.name, .status, .id] | @tsv'
```

```bash
# Read the log of a failed job
JOB_ID=67890
curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  "https://gitlab.example.com/api/v4/projects/${PROJECT_ID}/jobs/${JOB_ID}/trace" \
  | tail -100
```

## Iteration Loop

For each failing pipeline, the pattern is:

```
1. Identify failing job name and stage
2. Fetch job log (last 200 lines — errors are usually near the bottom)
3. Find the FIRST non-trivial error line
4. Identify root cause (see table below)
5. Edit the relevant file in workspaces/<repo>/
6. git add && git commit -m "[TICKET]: fix: <cause>"
7. git push → pipeline auto-triggers
8. Go to 1
```

## Root Cause Lookup Table

| Error pattern | Likely cause | Fix |
|---|---|---|
| `command not found: curl/wget/aws/packer` | CI Docker image missing the tool | Upgrade base image or add install step |
| `AccessDenied` / `is not authorized to perform` | Wrong IAM role, wrong runner tag | Check runner tags (`trulia-build` vs `itx-build`), check role trust policy |
| `openpgp: signature made by unknown entity` | Outdated tool version with stale PGP key | Upgrade to latest stable (e.g., Terraform 0.11.15) |
| `Incompatible API version with plugin` | Provider version too new for tool version | Pin provider to older compatible version |
| `Plugin host rate limited the plugin getter` | Missing API token for plugin registry | Set `PACKER_GITHUB_API_TOKEN` or equivalent |
| `No AMI was found matching filters` | AMI not shared to target account, or wrong owner | Use explicit AMI ID, or build in the account that will use it |
| `Timeout waiting for SSH` | Instance not reachable via SSH from runner | Switch to SSM Session Manager communicator |
| `VPCIdNotSpecified` | No default VPC in the target account | Provide explicit `vpc_id` + `subnet_id` |
| `can't be shared` (encrypted snapshot) | Account-level EBS encryption prevents cross-account sharing | Build AMI directly in the target account |
| `lookup <hostname>: no such host` | Internal DNS not resolvable from CI runner | Add `-refresh=false` or `-target` to skip unreachable data sources |
| `Volume of size NGB is smaller than snapshot` | Launch config root volume < AMI snapshot | Increase `root_volume_size` in Terraform variables |
| `Need at least N healthy instances in ELB` | App slow to start, Terraform health-check timeout | Increase `asg_wait_for_capacity_timeout` (e.g., `"25m"`) or set to `"0"` for stage |
| Python 2 `SyntaxError` in `.deb` maintainer scripts | Legacy Debian package built for Python 2, running on Ubuntu 20.04+ | Patch with `python3 -m lib2to3 -w` after stripping Windows line endings with `awk` |
| `start-stop-daemon` exits immediately | SysV init script incompatible with Ubuntu 20.04 systemd | Replace with a systemd unit file and bash wrapper |
| `exec: "session-manager-plugin" not found` | SSM Session Manager communicator missing binary | Install `session-manager-plugin` before Packer runs |

## Squashing Fix Commits Before Merge

After iterating on fixes, the branch may have many small commits. Before merging, squash them into logical groups:

```bash
# Strategy: cherry-pick groups onto a clean base, then force-push
git branch backup/before-squash HEAD
git reset --hard origin/master

# For each logical group (oldest to newest):
git cherry-pick --no-commit <sha1> <sha2> <sha3>
git commit -m "[TICKET]: <group description>"

# Verify final state matches backup
git diff backup/before-squash HEAD  # Should be empty

git push --force-with-lease
```

Logical groupings to aim for:
1. Core migration change (the actual removal + addition)
2. CI/CD toolchain upgrades (runner tags, image versions)
3. Build environment setup (plugins, source AMI, networking)
4. OS/runtime compatibility fixes
5. IaC pipeline fixes (Terraform version, provider pins, data source workarounds)
6. Deployment fixes (volume size, health check timeouts)

## Automating Iteration Temporarily

When a job needs many back-to-back fix attempts, temporarily change `when: manual` to `when: on_success` in the CI file to auto-trigger on each push. Revert once the job passes:

```yaml
# Temporarily for faster iteration:
build_ami_stage:
  when: on_success   # was: manual
  allow_failure: true
```

Remember to revert before merging to main.

## Safe Production Deployment (Terraform + ASG)

Before deploying to production with Terraform-managed Auto Scaling Groups:
- Keep `asg_wait_for_capacity_timeout` at a non-zero value (e.g., `"25m"`) — this is the rollback window. With `create_before_destroy = true` (standard for launch configurations), Terraform creates the new ASG/launch config first, waits for ELB health, then deletes the old one. If Terraform times out, old resources still exist and the deploy can be reverted.
- Record the current launch config name before deploying as a manual rollback reference.
- Set `when: manual` for prod deploy jobs; only auto-trigger during active iteration on non-prod environments.
