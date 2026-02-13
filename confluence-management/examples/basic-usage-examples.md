## Examples

```bash
# Search for recent FUB documentation
/confluence-management --operation="search" --query="space=FUB AND updated >= -7d"

# Get specific page content as markdown
/confluence-management --operation="get" --page_id="123456789" --content_format="markdown"

# Create new API documentation page
/confluence-management --operation="create" --space_key="FUB" --title="User Service API" --content_format="markdown"

# Update existing page with new content
/confluence-management --operation="update" --page_id="987654321" --content_format="markdown"

# Find meeting notes from this week
/confluence-management --operation="search" --query="meeting notes this week"

# Create page in personal space (may require manual space creation first)
/confluence-management --operation="create" --space_type="personal" --title="PA CRM Sunset Plan" --content_format="markdown"
```

