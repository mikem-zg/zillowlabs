#!/usr/bin/env python3
"""
Generic inventory processor for mass infrastructure migrations.

Copy this file into your migration project. Fill in the CONFIG block below
based on your actual CSV column headers — those are the only lines you need to change.

Run:
    python3 inventory.py --input data/inventory.csv --output-dir output/

No external dependencies — uses only Python stdlib.
"""

import argparse
import csv
import fnmatch
import json
import sys
from pathlib import Path

# ── CONFIG — adapt these to match your CSV headers and values ─────────────────

# Columns to check for team ownership. Check the CSV headers and pick whichever
# columns contain the team name, account name, or business unit label.
OWNERSHIP_COLUMNS = ["account", "team", "owner"]

# Values in those columns that identify rows belonging to your team.
# Case-insensitive substring match.
OWNERSHIP_KEYWORDS = ["my-team-name"]

# Column that indicates whether this item still needs migration.
# Leave STATUS_COLUMN empty ("") to include all rows.
STATUS_COLUMN = "migrationStatus"
STATUS_VALUE_NEEDS_WORK = "pending"  # The value that means "needs migration"

# Column used to group rows into logical services (one per repo/workload).
GROUP_BY_COLUMN = "service"

# Column used to sub-group within a service (e.g., cloud account, region).
# Set to "" to group only by GROUP_BY_COLUMN.
GROUP_BY_SECONDARY = "account"

# Service/group name patterns to always exclude (glob syntax, case-insensitive).
EXCLUDE_PATTERNS: list[str] = [
    # "shared-*",
    # "platform-*",
]

# ── END CONFIG ────────────────────────────────────────────────────────────────


def load_csv(path: str) -> list[dict]:
    with open(path, newline="", encoding="utf-8-sig") as f:
        return [{k.strip(): (v.strip() if v else "") for k, v in row.items()}
                for row in csv.DictReader(f)]


def is_owned(row: dict) -> bool:
    for col in OWNERSHIP_COLUMNS:
        val = row.get(col, "").lower()
        if any(kw.lower() in val for kw in OWNERSHIP_KEYWORDS):
            return True
    return False


def needs_migration(row: dict) -> bool:
    if not STATUS_COLUMN:
        return True
    return row.get(STATUS_COLUMN, "").strip().lower() == STATUS_VALUE_NEEDS_WORK.lower()


def is_excluded(row: dict) -> bool:
    group = row.get(GROUP_BY_COLUMN, "").lower()
    return any(fnmatch.fnmatch(group, p.lower()) for p in EXCLUDE_PATTERNS)


def group_key(row: dict) -> str:
    primary = row.get(GROUP_BY_COLUMN) or "unknown"
    secondary = row.get(GROUP_BY_SECONDARY) or "" if GROUP_BY_SECONDARY else ""
    return f"{primary}|{secondary}" if secondary else primary


def build_groups(rows: list[dict]) -> dict:
    groups: dict = {}
    excluded = 0
    for row in rows:
        if is_excluded(row):
            excluded += 1
            continue
        key = group_key(row)
        if key not in groups:
            groups[key] = {
                "group": row.get(GROUP_BY_COLUMN) or "unknown",
                "secondary": row.get(GROUP_BY_SECONDARY) or "" if GROUP_BY_SECONDARY else "",
                "rows": [],
            }
        groups[key]["rows"].append(row)
    if excluded:
        print(f"  Excluded {excluded} rows by pattern filter.")
    for g in groups.values():
        g["count"] = len(g["rows"])
    return groups


def markdown_report(groups: dict, all_columns: list[str]) -> str:
    total = sum(g["count"] for g in groups.values())
    lines = [
        "# Migration Inventory Report", "",
        f"**Groups**: {len(groups)}  |  **Rows**: {total}", "",
        "---", "",
    ]
    for key, g in sorted(groups.items()):
        header = g["group"]
        if g["secondary"]:
            header += f" ({g['secondary']})"
        lines += [f"## {header}", f"", f"**Count**: {g['count']}", ""]
        # Show a sample of columns for the first few rows
        sample_cols = all_columns[:6]  # show first 6 columns as a preview
        lines.append("| " + " | ".join(sample_cols) + " |")
        lines.append("|" + "|".join("---" for _ in sample_cols) + "|")
        for row in g["rows"][:5]:  # cap at 5 rows in markdown for readability
            lines.append("| " + " | ".join(row.get(c, "") for c in sample_cols) + " |")
        if g["count"] > 5:
            lines.append(f"| *(+{g['count'] - 5} more)* |" + "|".join("" for _ in sample_cols[1:]) + "|")
        lines.append("")
    lines += ["---", "", "## Next Steps", "",
              "1. Review the groups above — correct any that look wrong",
              "2. Create `data/repo_map.csv` mapping each group to its Git repository",
              "3. Fill in the repo column manually for any groups where it's not auto-detectable",
              "4. Run the orchestrator: `./orchestrate.sh data/repo_map.csv`"]
    return "\n".join(lines) + "\n"


def main():
    parser = argparse.ArgumentParser(description="Process migration inventory CSV")
    parser.add_argument("--input", default="data/inventory.csv")
    parser.add_argument("--output-dir", default="output")
    parser.add_argument("--all", action="store_true",
                        help="Include all rows regardless of status (ignore STATUS_COLUMN filter)")
    args = parser.parse_args()

    path = Path(args.input)
    if not path.exists():
        print(f"Error: {path} not found. Export your inventory spreadsheet as CSV first.", file=sys.stderr)
        sys.exit(1)

    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    print(f"Loading {path}...")
    rows = load_csv(str(path))
    print(f"  Total rows: {len(rows)}")
    if not rows:
        print("CSV appears empty. Check encoding and headers.")
        sys.exit(1)

    all_columns = list(rows[0].keys())
    print(f"  Columns ({len(all_columns)}): {', '.join(all_columns[:10])}{'...' if len(all_columns) > 10 else ''}")

    filtered = [r for r in rows if is_owned(r) and (args.all or needs_migration(r))]
    print(f"  Owned + needs migration: {len(filtered)}")

    if not filtered:
        print("\nNo matching rows. Check OWNERSHIP_COLUMNS, OWNERSHIP_KEYWORDS, and STATUS settings.")
        sys.exit(0)

    groups = build_groups(filtered)
    total = sum(g["count"] for g in groups.values())
    print(f"  Groups: {len(groups)}, Items: {total}")

    json_path = output_dir / "inventory_groups.json"
    with open(json_path, "w") as f:
        json.dump(groups, f, indent=2)
    print(f"  JSON → {json_path}")

    md_path = output_dir / "inventory_report.md"
    with open(md_path, "w") as f:
        f.write(markdown_report(groups, all_columns))
    print(f"  Report → {md_path}")

    # Skeleton repo map — user fills in the repo column
    skeleton_path = output_dir / "repo_map_skeleton.csv"
    repo_col = "gitRepo"
    with open(skeleton_path, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=[GROUP_BY_COLUMN, GROUP_BY_SECONDARY, repo_col, "notes"])
        w.writeheader()
        for g in sorted(groups.values(), key=lambda x: x["group"]):
            w.writerow({GROUP_BY_COLUMN: g["group"], GROUP_BY_SECONDARY: g.get("secondary", ""),
                        repo_col: "", "notes": ""})
    print(f"  Repo map skeleton → {skeleton_path}  (fill in '{repo_col}' column)")


if __name__ == "__main__":
    main()
