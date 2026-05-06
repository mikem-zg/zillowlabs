# CLAUDE.md File Generator (Data Engineering Repositories)

You will be creating a CLAUDE.md file for a data engineering repository. A CLAUDE.md file serves as documentation that helps AI assistants (like Claude) understand the repository structure, purpose, conventions, and how to effectively assist with tasks in that repository.

## Inputs Required from the User

Before running the workflow, collect:

1. **`<repository_url>`** — the GitLab/GitHub URL of the target repository to document.
2. **`<example_claude_files>`** — one or more URLs to existing well-written CLAUDE.md files to use as reference. The following set are the canonical examples and should always be considered:
   - https://gitlab.zgtools.net/analytics/data-engineering/big-data/pade/tdw_find_alan/-/blob/main/claude.md?ref_type=heads
   - https://gitlab.zgtools.net/analytics/data-engineering/big-data/pade/touring-dbx/-/blob/main/touring_workflows/CLAUDE.md?ref_type=heads
   - https://gitlab.zgtools.net/analytics/airflow/dags/mede/cea/company_metrics_databricks/-/blob/main/CLAUDE.md?ref_type=heads
   - https://gitlab.zgtools.net/analytics/airflow/dags/mede/egdw-standards/-/blob/main/EGDW_STANDARDS.md
   - https://gitlab.zgtools.net/analytics/airflow/dags/mede/cea/company_metrics_databricks/-/blob/main/REFERENCE.md
   - Platform guidance (always linked in the output): https://gitlab.zgtools.net/analytics/data-engineering/databricks/tooling/databricks-claude-marketplace/-/blob/main/plugins/databricks-asset-bundles/CLAUDE.md


---

## Your Task

Analyze the repository at the provided URL and create a comprehensive, specific CLAUDE.md file tailored to that repository.

Before writing the CLAUDE.md file, use the scratchpad to thoroughly analyze the repository. In your scratchpad:

- Examine the repository structure (folders, files, organization)
- Identify the primary purpose and what the repository does
- Note the technology stack (Databricks, dbt, Airflow, Spark, etc.)
- Identify any configuration files that reveal conventions or standards
- Look for README files, documentation, or comments that provide context
- Note any specific patterns in naming conventions, file organization, or code structure
- Identify the data flow and medallion architecture layers if applicable
- List out key models, workflows, or scripts and their purposes
- Consider what information would be most helpful for someone (or an AI) working with this codebase
- Look for README files, documentation, or comments that provide context
- If a README file exists in the repo with relevant details, use that to extract information
- Check for dual write related jobs — only include information about dual write if the job is **unpaused**; do **not** add dual write information if the job is paused

Write your analysis in `<scratchpad>` tags.

---

## Required Sections in the Generated CLAUDE.md

After your analysis, write a complete CLAUDE.md file that includes the following sections:

1. **Repository Overview** — A clear, specific description of what this repository does, its purpose, and its role in the broader data engineering ecosystem. Be concrete about what data it processes or what metrics it generates.

2. **Repository Structure** — A detailed explanation of the directory structure with actual folder/file names from the repository. Include:
   - Key directories and their purposes
   - Where configuration files are located
   - Where models, workflows, or scripts are organized
   - Data flow through the repository
   - Medallion architecture layers (bronze, silver, gold) if applicable

3. **Key Models / Workflows** — For each significant dbt model, workflow, or script, provide a brief 1–2 line description of what it does and what data it produces.

4. **Key Technologies & Frameworks** — List the specific technologies, frameworks, and tools used in this repository (e.g., Databricks, Airflow, Spark, dbt, Python version, etc.). Be specific about versions if visible.

5. **Development Guidelines** — Document any coding standards, naming conventions, and best practices specific to this repository. Include:
   - Naming conventions for models, tables, columns
   - Code organization patterns
   - Documentation requirements
   - Any style guides referenced

6. **Common Tasks** — Provide instructions for common operations such as:
   - Running tests locally
   - Deploying code
   - Adding new models or workflows
   - Running specific workflows
   - Debugging common issues

7. **Dependencies & Setup** — Explain how to set up the development environment:
   - Required dependencies and how to install them
   - Configuration files that need to be set up
   - Access requirements (databases, services, etc.)
   - Environment variables needed

8. **Important Patterns** — Document any specific design patterns, architectural decisions, or conventions that are important to understand when working with this codebase.

9. **Testing & Validation** — Create a section with checkboxes and space for developers to document:
   - [ ] Data validation documents/notebooks tested
   - [ ] Stage workflow links that have been tested
   - [ ] Test results and validation outcomes
   - [ ] Any data quality checks performed

10. **Context for AI Assistance** — Provide specific guidance on how an AI assistant should approach helping with this codebase. Include:
    - What to prioritize when making suggestions
    - Common pitfalls to avoid
    - How to maintain consistency with existing patterns
    - Reference to platform guidance: https://gitlab.zgtools.net/analytics/data-engineering/databricks/tooling/databricks-claude-marketplace/-/blob/main/plugins/databricks-asset-bundles/CLAUDE.md
    - A note that this CLAUDE.md file should be updated whenever any incremental change is made to the repository

---

## Quality Standards

Your CLAUDE.md file should be:

- Specific and concrete (not generic)
- Comprehensive yet concise
- Well-organized and easy to navigate
- Actionable (someone should be able to use it to get started immediately)
- Accurate (all information should match the actual repository)
- Professional in tone

---

## Formatting Requirements

- Use proper markdown syntax with clear headings (`#`, `##`, `###`)
- Use bullet points, numbered lists, and tables where appropriate
- Include code blocks with proper syntax highlighting for configuration examples or commands
- Make it specific to the actual repository — avoid generic statements
- Include concrete details about actual file paths, naming conventions, and specific technologies used
- Ensure all file paths and directory names match what actually exists in the repository
- Use tables for structured information like model descriptions or configuration parameters
- Include links to relevant documentation or related repositories where applicable

---

## Output Format

1. First, output your analysis inside `<scratchpad>` tags.
2. Then, output the final CLAUDE.md file content inside `<claude_md_file>` tags.
3. Remind the user to link the MR to: https://zillowgroup.atlassian.net/browse/TDW-9924

---

## Workflow Checklist

Copy this checklist and track progress while running the skill:

```
- [ ] Step 1: Collect <repository_url> and any extra example CLAUDE.md links
- [ ] Step 2: Clone or browse the repo; map the directory tree
- [ ] Step 3: Read README.md and any in-repo docs/comments
- [ ] Step 4: Identify tech stack (Databricks, dbt, Airflow, Spark, Python ver.)
- [ ] Step 5: Catalog dbt models, notebooks, workflows, zdad/asset-bundle configs
- [ ] Step 6: Identify medallion layers (bronze/silver/gold) if present
- [ ] Step 7: Check dual-write jobs — include ONLY if unpaused
- [ ] Step 8: Cross-reference example CLAUDE.md files for tone & structure
- [ ] Step 9: Draft scratchpad analysis in <scratchpad> tags
- [ ] Step 10: Write final CLAUDE.md inside <claude_md_file> tags
- [ ] Step 11: Verify all 10 required sections are present
- [ ] Step 12: Confirm platform-guidance link is included in section 10
- [ ] Step 13: Confirm note that CLAUDE.md must be updated on every incremental change
- [ ] Step 14: Remind user to link MR to https://zillowgroup.atlassian.net/browse/TDW-9924
```

---

## Anti-Patterns to Avoid

- Generic boilerplate that could apply to any repo
- File paths or directory names that don't actually exist in the target repo
- Including dual-write documentation for paused jobs
- Omitting the platform-guidance link in section 10
- Omitting the "update CLAUDE.md on every incremental change" reminder
- Paraphrasing repository specifics instead of quoting actual model/file names