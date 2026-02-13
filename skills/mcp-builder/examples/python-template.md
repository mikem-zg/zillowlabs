# Python MCP Server Template

Copy-paste template for building a production-ready MCP server in Python. Replace `example` with your service name throughout.

---

## Project Setup

```bash
mkdir example-mcp && cd example-mcp

# Option A: pip
pip install "mcp[cli]" httpx pydantic

# Option B: uv (recommended)
uv init && uv add "mcp[cli]" httpx
```

---

## File: `pyproject.toml`

```toml
[project]
name = "example-mcp"
version = "1.0.0"
description = "MCP server for the Example API"
requires-python = ">=3.10"
dependencies = [
    "mcp[cli]>=1.0.0",
    "httpx>=0.27.0",
    "pydantic>=2.0.0",
]

[project.scripts]
serve = "server:main"

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"
```

---

## File: `constants.py`

```python
import os

API_BASE_URL: str = os.environ.get("EXAMPLE_API_URL", "https://api.example.com/v1")
CHARACTER_LIMIT: int = 25_000
DEFAULT_LIMIT: int = 20
MAX_LIMIT: int = 100
DEFAULT_TIMEOUT: float = 30.0
```

---

## File: `models.py`

```python
from enum import Enum
from pydantic import BaseModel, Field, field_validator, ConfigDict


class ResponseFormat(str, Enum):
    MARKDOWN = "markdown"
    JSON = "json"


class UserSearchInput(BaseModel):
    model_config = ConfigDict(
        str_strip_whitespace=True,
        validate_assignment=True,
        extra="forbid",
    )

    query: str = Field(
        ...,
        min_length=1,
        max_length=256,
        description="Search query — matches against username, email, and display name",
    )
    role: str | None = Field(
        default=None,
        pattern=r"^(admin|member|viewer)$",
        description="Filter by user role (admin, member, viewer)",
    )
    limit: int = Field(default=20, ge=1, le=100, description="Max results per page (1-100)")
    offset: int = Field(default=0, ge=0, description="Number of results to skip for pagination")
    format: ResponseFormat = Field(
        default=ResponseFormat.MARKDOWN,
        description="Response format: 'markdown' for readable output, 'json' for raw data",
    )

    @field_validator("query")
    @classmethod
    def validate_query(cls, v: str) -> str:
        if not v.strip():
            raise ValueError("Query cannot be empty or whitespace only")
        return v


class ProjectListInput(BaseModel):
    model_config = ConfigDict(
        str_strip_whitespace=True,
        validate_assignment=True,
        extra="forbid",
    )

    status: str | None = Field(
        default=None,
        pattern=r"^(active|archived|draft)$",
        description="Filter by project status (active, archived, draft)",
    )
    owner_id: str | None = Field(
        default=None,
        description="Filter by owner user ID",
    )
    limit: int = Field(default=20, ge=1, le=100, description="Max results per page (1-100)")
    offset: int = Field(default=0, ge=0, description="Number of results to skip for pagination")
    format: ResponseFormat = Field(
        default=ResponseFormat.MARKDOWN,
        description="Response format: 'markdown' for readable output, 'json' for raw data",
    )


class GetByIdInput(BaseModel):
    model_config = ConfigDict(
        str_strip_whitespace=True,
        validate_assignment=True,
        extra="forbid",
    )

    id: str = Field(
        ...,
        min_length=1,
        description="Unique identifier for the resource",
    )
    format: ResponseFormat = Field(
        default=ResponseFormat.MARKDOWN,
        description="Response format: 'markdown' for readable output, 'json' for raw data",
    )
```

---

## File: `client.py`

```python
import os
import httpx
from constants import API_BASE_URL, DEFAULT_TIMEOUT


class ExampleApiClient:
    def __init__(self) -> None:
        self.base_url = API_BASE_URL
        self.timeout = DEFAULT_TIMEOUT
        self.token = os.environ.get("EXAMPLE_API_TOKEN")

    def _get_headers(self) -> dict[str, str]:
        headers = {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "User-Agent": "example-mcp-server",
        }
        if self.token:
            headers["Authorization"] = f"Bearer {self.token}"
        return headers

    async def make_request(
        self,
        method: str,
        endpoint: str,
        params: dict | None = None,
        json_data: dict | None = None,
    ) -> dict | list:
        if not self.token:
            raise ValueError(
                "EXAMPLE_API_TOKEN environment variable is not set. "
                "Set it to your API token before making requests."
            )

        url = f"{self.base_url}{endpoint}"

        async with httpx.AsyncClient(timeout=self.timeout) as client:
            response = await client.request(
                method=method,
                url=url,
                headers=self._get_headers(),
                params=params,
                json=json_data,
            )
            response.raise_for_status()
            return response.json()

    @staticmethod
    def handle_error(e: Exception) -> str:
        if isinstance(e, httpx.HTTPStatusError):
            status = e.response.status_code
            try:
                body = e.response.json()
                message = body.get("message", e.response.text)
            except Exception:
                message = e.response.text

            error_messages: dict[int, str] = {
                400: f"Bad request. Check your input parameters. Details: {message}",
                401: "Authentication failed. Verify your EXAMPLE_API_TOKEN is valid and not expired.",
                403: f"Access forbidden. Check that your API token has the required permissions. Details: {message}",
                404: f"Resource not found. Verify the ID or parameters are correct. Details: {message}",
                422: f"Validation failed. Check your input parameters. Details: {message}",
                429: f"Rate limit exceeded. Retry after {e.response.headers.get('Retry-After', 'a few')} seconds.",
            }

            text = error_messages.get(status, f"API returned status {status}. Details: {message}")
            return f"Error: {text}"

        if isinstance(e, httpx.TimeoutException):
            return "Error: Request timed out. The API server may be slow or unreachable. Try again or reduce the scope of your request."

        if isinstance(e, httpx.ConnectError):
            return "Error: Could not connect to the API server. Check network connectivity and the API base URL."

        return f"Error: Unexpected error occurred: {type(e).__name__}: {str(e)}"


api_client = ExampleApiClient()
```

---

## File: `server.py`

```python
from mcp.server.fastmcp import FastMCP
import json

from models import UserSearchInput, ProjectListInput, GetByIdInput, ResponseFormat
from client import api_client
from constants import CHARACTER_LIMIT

mcp = FastMCP("example_mcp")


def _truncate(text: str, limit: int = CHARACTER_LIMIT) -> str:
    if len(text) <= limit:
        return text
    return text[:limit] + f"\n\n... (truncated, {len(text) - limit} characters omitted)"


def _handle_api_error(e: Exception) -> str:
    return api_client.handle_error(e)


def _build_pagination_footer(
    count: int, total: int, offset: int, limit: int
) -> str:
    has_more = offset + count < total
    next_offset = offset + count if has_more else None
    lines: list[str] = []
    if has_more and next_offset is not None:
        lines.append(f"\n_Showing {count} of {total}. Use offset={next_offset} for more._")
    return "\n".join(lines)


def _build_pagination_json(
    items: list[dict],
    total: int,
    limit: int,
    offset: int,
    key: str,
) -> str:
    count = len(items)
    has_more = offset + count < total
    next_offset = offset + count if has_more else None

    result: dict = {
        "total": total,
        "count": count,
        "has_more": has_more,
        "limit": limit,
        "offset": offset,
    }
    if next_offset is not None:
        result["next_offset"] = next_offset
    result[key] = items

    return json.dumps(result, indent=2)


@mcp.tool(
    name="example_search_users",
    annotations={
        "readOnlyHint": True,
        "destructiveHint": False,
        "idempotentHint": True,
        "openWorldHint": True,
    },
)
async def search_users(input: UserSearchInput) -> str:
    """Search for users in the Example service by query string.

    Searches across usernames, emails, and display names. Supports filtering
    by role and pagination through results.

    Use this to find users matching specific criteria. For retrieving a single
    user by ID, use example_get_user instead.

    Args:
        input.query: Search query — matches username, email, and display name
        input.role: Filter by user role (admin, member, viewer). Optional
        input.limit: Max results per page (1-100). Default: 20
        input.offset: Number of results to skip for pagination. Default: 0
        input.format: Response format — 'markdown' (default) or 'json'

    Returns:
        Paginated list of users matching the query with total count and
        pagination metadata (has_more, next_offset).
    """
    try:
        params: dict = {
            "q": input.query,
            "limit": input.limit,
            "offset": input.offset,
        }
        if input.role:
            params["role"] = input.role

        data = await api_client.make_request("GET", "/users/search", params=params)

        users = data["users"]
        total = data["total"]

        if input.format == ResponseFormat.JSON:
            text = _build_pagination_json(users, total, input.limit, input.offset, "users")
        else:
            lines = [f"# User Search Results ({total} total)\n"]
            for user in users:
                lines.append(f"## {user['display_name']} (@{user['username']})")
                lines.append(f"- **ID:** {user['id']}")
                lines.append(f"- **Email:** {user['email']}")
                lines.append(f"- **Role:** {user['role']}")
                lines.append(f"- **Created:** {user['created_at']}")
                lines.append("")
            lines.append(_build_pagination_footer(len(users), total, input.offset, input.limit))
            text = "\n".join(lines)

        return _truncate(text)
    except Exception as e:
        return _handle_api_error(e)


@mcp.tool(
    name="example_get_user",
    annotations={
        "readOnlyHint": True,
        "destructiveHint": False,
        "idempotentHint": True,
        "openWorldHint": True,
    },
)
async def get_user(input: GetByIdInput) -> str:
    """Retrieve a single user by their unique ID.

    Returns the full user profile including username, email, display name,
    role, and creation date.

    Args:
        input.id: The unique user identifier
        input.format: Response format — 'markdown' (default) or 'json'

    Returns:
        User details as markdown or JSON.

    Error Handling:
        - Returns error if user not found (404)
        - Returns error if API token is invalid (401)
    """
    try:
        user = await api_client.make_request("GET", f"/users/{input.id}")

        if input.format == ResponseFormat.JSON:
            text = json.dumps(user, indent=2)
        else:
            text = "\n".join([
                f"# {user['display_name']} (@{user['username']})",
                "",
                f"- **ID:** {user['id']}",
                f"- **Email:** {user['email']}",
                f"- **Role:** {user['role']}",
                f"- **Created:** {user['created_at']}",
            ])

        return _truncate(text)
    except Exception as e:
        return _handle_api_error(e)


@mcp.tool(
    name="example_list_projects",
    annotations={
        "readOnlyHint": True,
        "destructiveHint": False,
        "idempotentHint": True,
        "openWorldHint": True,
    },
)
async def list_projects(input: ProjectListInput) -> str:
    """List projects in the Example service with pagination and optional filtering.

    Returns a paginated list of projects. Use offset and limit to page through
    results. Response includes has_more and next_offset for subsequent requests.

    Args:
        input.status: Filter by project status (active, archived, draft). Optional
        input.owner_id: Filter by owner user ID. Optional
        input.limit: Max results per page (1-100). Default: 20
        input.offset: Number of results to skip for pagination. Default: 0
        input.format: Response format — 'markdown' (default) or 'json'

    Returns:
        Paginated list of projects with total count and pagination metadata.

    Examples:
        - List all active projects
        - List projects owned by a specific user
        - Paginate through archived projects
    """
    try:
        params: dict = {
            "limit": input.limit,
            "offset": input.offset,
        }
        if input.status:
            params["status"] = input.status
        if input.owner_id:
            params["owner_id"] = input.owner_id

        data = await api_client.make_request("GET", "/projects", params=params)

        projects = data["projects"]
        total = data["total"]

        if input.format == ResponseFormat.JSON:
            text = _build_pagination_json(projects, total, input.limit, input.offset, "projects")
        else:
            lines = [f"# Projects ({total} total)\n"]
            for project in projects:
                lines.append(f"## {project['name']} ({project['id']})")
                lines.append(f"- **Status:** {project['status']}")
                lines.append(f"- **Description:** {project['description']}")
                lines.append(f"- **Owner:** {project['owner_id']}")
                lines.append(f"- **Created:** {project['created_at']}")
                lines.append(f"- **Updated:** {project['updated_at']}")
                lines.append("")
            lines.append(_build_pagination_footer(len(projects), total, input.offset, input.limit))
            text = "\n".join(lines)

        return _truncate(text)
    except Exception as e:
        return _handle_api_error(e)


@mcp.tool(
    name="example_get_project",
    annotations={
        "readOnlyHint": True,
        "destructiveHint": False,
        "idempotentHint": True,
        "openWorldHint": True,
    },
)
async def get_project(input: GetByIdInput) -> str:
    """Retrieve a single project by its unique ID.

    Returns the full project details including name, description, status,
    owner, and timestamps.

    Args:
        input.id: The unique project identifier
        input.format: Response format — 'markdown' (default) or 'json'

    Returns:
        Project details as markdown or JSON.

    Error Handling:
        - Returns error if project not found (404)
        - Returns error if API token is invalid (401)
    """
    try:
        project = await api_client.make_request("GET", f"/projects/{input.id}")

        if input.format == ResponseFormat.JSON:
            text = json.dumps(project, indent=2)
        else:
            text = "\n".join([
                f"# {project['name']} ({project['id']})",
                "",
                f"- **Status:** {project['status']}",
                f"- **Description:** {project['description']}",
                f"- **Owner:** {project['owner_id']}",
                f"- **Created:** {project['created_at']}",
                f"- **Updated:** {project['updated_at']}",
            ])

        return _truncate(text)
    except Exception as e:
        return _handle_api_error(e)


def main():
    mcp.run(transport="stdio")


if __name__ == "__main__":
    main()
```

---

## File: `README.md`

````markdown
# example-mcp

MCP server for the Example API — provides tools for searching users and managing projects.

## Installation

### Option A: pip

```bash
pip install "mcp[cli]" httpx pydantic
```

### Option B: uv (recommended)

```bash
uv init && uv add "mcp[cli]" httpx
```

## Configuration

Set the following environment variables:

| Variable | Required | Description |
|----------|----------|-------------|
| `EXAMPLE_API_TOKEN` | Yes | API authentication token |
| `EXAMPLE_API_URL` | No | API base URL (default: `https://api.example.com/v1`) |

## Usage

### stdio mode (Claude Desktop, VS Code)

```bash
python server.py
```

### Dev mode with MCP Inspector

```bash
mcp dev server.py
```

### Test with Inspector

```bash
npx @modelcontextprotocol/inspector
```

## Available Tools

| Tool | Description |
|------|-------------|
| `example_search_users` | Search users by query with role filtering and pagination |
| `example_get_user` | Get a single user by ID |
| `example_list_projects` | List projects with status/owner filtering and pagination |
| `example_get_project` | Get a single project by ID |

## Claude Desktop Configuration

Add to your Claude Desktop config (`claude_desktop_config.json`):

```json
{
  "mcpServers": {
    "example": {
      "command": "python",
      "args": ["/absolute/path/to/example-mcp/server.py"],
      "env": {
        "EXAMPLE_API_TOKEN": "your-token-here"
      }
    }
  }
}
```

Or with uv:

```json
{
  "mcpServers": {
    "example": {
      "command": "uv",
      "args": ["--directory", "/absolute/path/to/example-mcp", "run", "server.py"],
      "env": {
        "EXAMPLE_API_TOKEN": "your-token-here"
      }
    }
  }
}
```
````

---

## Run Commands

```bash
python server.py                       # stdio mode
mcp dev server.py                      # Dev mode with inspector
npx @modelcontextprotocol/inspector    # Test with inspector
```

---

## Project Structure

```
example-mcp/
├── pyproject.toml         # Project metadata and dependencies
├── README.md              # Documentation
├── server.py              # FastMCP server + tool definitions
├── models.py              # Pydantic v2 input models
├── client.py              # API client with httpx.AsyncClient
└── constants.py           # Configuration values
```

---

## Customization Checklist

When adapting this template for your service:

1. **Replace `example`** with your service name in all files
2. **Update `constants.py`** with your API base URL
3. **Update `models.py`** with your service's input schemas
4. **Update `client.py`** with your authentication method (Bearer, API key, Basic Auth)
5. **Update `server.py`** with your tool implementations and API endpoints
6. **Update `README.md`** with your service-specific documentation
7. **Rename tool functions** to use your service prefix (`yourservice_search_*`, etc.)
