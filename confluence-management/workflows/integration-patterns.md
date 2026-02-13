## Integration Points

### Cross-Skill Workflow Patterns

**Support Investigation → Confluence Documentation Chain:**
```bash
# Extract page ID from URLs and fetch comprehensive content
extracted_page_id=$(echo "$confluence_url" | grep -o 'pages/[0-9]\+' | cut -d'/' -f2)
confluence_data=$(confluence-management --operation=get --page_id="$extracted_page_id" --content_format=markdown)

# Update documentation with investigation findings
investigation_markdown="## Investigation Results\n\n$investigation_summary"
confluence-management --operation=update --page_id="$page_id" --content="$investigation_markdown" --version_message="Added investigation results"
```

**Development Workflow → Documentation Integration Chain:**
```bash
# Create project documentation with proper formatting
project_docs="## Project Overview\n\n**Repository**: [fub/fub](https://gitlab.zgtools.net/fub/fub)\n**Environment**: Development\n\n### Recent Changes\n- Feature A implementation\n- Bug fix for issue B"
confluence-management --operation=create --space_key="ENG" --title="$project_name Documentation" --content="$project_docs" --content_format=markdown

# Add development notes with code snippets
dev_notes="## Implementation Notes\n\nFixed authentication issue:\n\n\`\`\`php\npublic function authenticate() {\n    // Updated logic\n}\n\`\`\`"
confluence-management --operation=update --page_id="$doc_page_id" --content="$dev_notes" --content_format=markdown
```

**Knowledge Management → Team Collaboration Chain:**
```bash
# Search for existing documentation before creating new pages
existing_docs=$(confluence-management --operation=search --space_key="FUB" --query="$topic_keywords")

# Create comprehensive documentation with cross-references
confluence-management --operation=create --space_key="FUB" --template="api_documentation" --title="$api_title" --parent_id="$section_page_id"

# Link to related GitLab MRs and Jira tickets in documentation
confluence-management --operation=update --page_id="$doc_page_id" --content="$content_with_links" --version_message="Added cross-references"
```

### Related Skills

| Related Skill | Integration Point | Common Workflow |
|---------------|------------------|-----------------|
| `support-investigation` | Documentation updates, runbook creation | Investigation → Documentation → Knowledge sharing |
| `jira-management` | Requirement documentation, status linking | Jira ticket → Confluence spec → Implementation tracking |
| `gitlab-collaboration` | MR documentation, code review notes | Code changes → Documentation updates → Team communication |
| `serena-mcp` | Code analysis documentation | Code exploration → Architecture documentation → Team knowledge |

