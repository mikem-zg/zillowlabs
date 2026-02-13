# Python MCP Server Guide

Build MCP servers in Python using the official `mcp` package with FastMCP.

---

## Quick Reference

```python
from mcp.server.fastmcp import FastMCP
from pydantic import BaseModel, Field, field_validator, ConfigDict
from enum import Enum
import httpx
import json
import os

mcp = FastMCP("service_mcp")

@mcp.tool(name="service_action", annotations={"readOnlyHint": True})
async def action(query: str) -> str:
    """One-line description of what this tool does."""
    result = await _make_api_request("/endpoint", params={"q": query})
    return json.dumps(result, indent=2)

if __name__ == "__main__":
    mcp.run(transport="stdio")
```

---

## SDK Overview

| Detail | Value |
|--------|-------|
| **Package** | `mcp` on PyPI (v1.x stable, includes FastMCP) |
| **Python** | 3.10+ required |
| **Descriptions** | Auto-generated from docstrings |
| **Validation** | Pydantic v2 integration |
| **Install** | `pip install "mcp[cli]" httpx` or `uv add "mcp[cli]" httpx` |

FastMCP is a high-level wrapper included in the `mcp` package. It handles protocol details, serialization, and transport — you focus on tool logic.

---

## Server Naming Convention

Format: `{service}_mcp` (lowercase with underscores)

```python
mcp = FastMCP("github_mcp")
mcp = FastMCP("slack_mcp")
mcp = FastMCP("stripe_mcp")
mcp = FastMCP("jira_mcp")
```

---

## Tool Implementation with FastMCP

### Basic Tool with Inline Parameters

```python
@mcp.tool(name="github_get_issue", annotations={"readOnlyHint": True, "idempotentHint": True})
async def get_issue(owner: str, repo: str, issue_number: int) -> str:
    """Get details of a specific GitHub issue.

    Retrieves the full issue including title, body, labels, assignees, and comments.
    Use this when you need complete information about a single issue.

    Args:
        owner: Repository owner (user or organization)
        repo: Repository name
        issue_number: Issue number (not the issue ID)

    Returns:
        Issue details formatted as markdown
    """
    data = await _make_api_request(f"/repos/{owner}/{repo}/issues/{issue_number}")
    return _format_issue(data)
```

### Tool with Pydantic Input Validation

```python
from pydantic import BaseModel, Field, field_validator, ConfigDict

class SearchIssuesInput(BaseModel):
    model_config = ConfigDict(
        str_strip_whitespace=True,
        validate_assignment=True,
        extra="forbid",
    )

    query: str = Field(
        ...,
        min_length=1,
        max_length=256,
        description="Search query string",
    )
    owner: str = Field(
        ...,
        min_length=1,
        max_length=100,
        pattern=r"^[a-zA-Z0-9\-]+$",
        description="Repository owner",
    )
    state: str = Field(
        default="open",
        pattern=r"^(open|closed|all)$",
        description="Filter by issue state",
    )
    limit: int = Field(default=20, ge=1, le=100, description="Max results to return")
    offset: int = Field(default=0, ge=0, description="Number of results to skip")

    @field_validator("query")
    @classmethod
    def validate_query(cls, v: str) -> str:
        if not v.strip():
            raise ValueError("Query cannot be empty or whitespace only")
        return v


@mcp.tool(name="github_search_issues", annotations={"readOnlyHint": True})
async def search_issues(input: SearchIssuesInput) -> str:
    """Search GitHub issues by query, labels, assignee, or state.

    Searches across issue titles, bodies, and comments. Supports GitHub's
    search qualifiers like `label:bug`, `assignee:username`, `is:open`.

    Use this to find issues matching specific criteria. For browsing all
    issues in a repo, use github_list_issues instead.
    """
    data = await _make_api_request(
        f"/search/issues",
        params={
            "q": f"repo:{input.owner}/{input.owner} {input.query}",
            "state": input.state,
            "per_page": input.limit,
            "page": (input.offset // input.limit) + 1,
        },
    )
    return _format_search_results(data, input.limit, input.offset)
```

### Tool with Annotations

```python
@mcp.tool(
    name="github_create_issue",
    annotations={
        "readOnlyHint": False,
        "destructiveHint": False,
        "idempotentHint": False,
        "openWorldHint": True,
    },
)
async def create_issue(owner: str, repo: str, title: str, body: str = "") -> str:
    """Create a new issue in a GitHub repository.

    Creates an issue with the given title and optional body. The authenticated
    user must have write access to the repository.
    """
    data = await _make_api_request(
        f"/repos/{owner}/{repo}/issues",
        method="POST",
        json_data={"title": title, "body": body},
    )
    return f"Created issue #{data['number']}: {data['html_url']}"
```

---

## Pydantic v2 Key Features

### model_config (replaces nested Config class)

```python
class ToolInput(BaseModel):
    model_config = ConfigDict(
        str_strip_whitespace=True,
        validate_assignment=True,
        extra="forbid",
    )

    name: str = Field(..., min_length=1)
```

### field_validator (replaces deprecated validator)

```python
from pydantic import field_validator

class DateRangeInput(BaseModel):
    model_config = ConfigDict(extra="forbid")

    start_date: str = Field(..., description="Start date in YYYY-MM-DD format")
    end_date: str = Field(..., description="End date in YYYY-MM-DD format")

    @field_validator("start_date", "end_date")
    @classmethod
    def validate_date_format(cls, v: str) -> str:
        from datetime import datetime
        try:
            datetime.strptime(v, "%Y-%m-%d")
        except ValueError:
            raise ValueError(f"Date must be in YYYY-MM-DD format, got: {v}")
        return v
```

### model_dump (replaces deprecated dict)

```python
input_data = my_input.model_dump()
input_data = my_input.model_dump(exclude_none=True)
input_data = my_input.model_dump(exclude={"internal_field"})
```

### Field with Constraints

```python
class ConstrainedInput(BaseModel):
    model_config = ConfigDict(extra="forbid")

    name: str = Field(..., min_length=1, max_length=100, description="Resource name")
    count: int = Field(default=10, ge=1, le=1000, description="Number of items")
    ratio: float = Field(default=0.5, ge=0.0, le=1.0, description="Ratio value")
    slug: str = Field(..., pattern=r"^[a-z0-9\-]+$", description="URL-safe identifier")
    tags: list[str] = Field(default_factory=list, max_length=10, description="Optional tags")
```

---

## Response Format Options

### ResponseFormat Enum

```python
from enum import Enum

class ResponseFormat(str, Enum):
    MARKDOWN = "markdown"
    JSON = "json"
```

### Markdown Formatting

```python
def _format_issues_markdown(issues: list[dict], total: int) -> str:
    lines = [f"# Issues ({total} total)\n"]
    for issue in issues:
        lines.append(f"## #{issue['number']}: {issue['title']}")
        lines.append(f"**State:** {issue['state']} | **Author:** {issue['user']['login']}")
        if issue.get("labels"):
            label_names = ", ".join(f"`{l['name']}`" for l in issue["labels"])
            lines.append(f"**Labels:** {label_names}")
        lines.append(f"\n{issue.get('body', 'No description.')}\n")
        lines.append("---\n")
    return "\n".join(lines)
```

### JSON Formatting

```python
def _format_issues_json(issues: list[dict], total: int) -> str:
    return json.dumps(
        {
            "total": total,
            "count": len(issues),
            "issues": [
                {
                    "number": i["number"],
                    "title": i["title"],
                    "state": i["state"],
                    "author": i["user"]["login"],
                    "labels": [l["name"] for l in i.get("labels", [])],
                    "url": i["html_url"],
                }
                for i in issues
            ],
        },
        indent=2,
    )
```

### Structured Output with Tuples

Return a tuple of `(content_list, structured_data)` to provide both text content and typed structured data (spec 2025-11-25):

```python
@mcp.tool(name="github_get_repo_stats")
async def get_repo_stats(owner: str, repo: str) -> tuple[list[dict], dict]:
    """Get repository statistics including stars, forks, and language breakdown."""
    data = await _make_api_request(f"/repos/{owner}/{repo}")

    structured = {
        "name": data["full_name"],
        "stars": data["stargazers_count"],
        "forks": data["forks_count"],
        "language": data["language"],
        "open_issues": data["open_issues_count"],
    }

    content = [
        {
            "type": "text",
            "text": (
                f"# {data['full_name']}\n\n"
                f"⭐ {data['stargazers_count']} stars | "
                f"🍴 {data['forks_count']} forks | "
                f"📋 {data['open_issues_count']} open issues\n\n"
                f"**Language:** {data['language']}"
            ),
        }
    ]

    return content, structured
```

### Format Selection in Tools

```python
@mcp.tool(name="github_list_repos", annotations={"readOnlyHint": True})
async def list_repos(
    owner: str,
    format: str = "markdown",
) -> str:
    """List repositories for a user or organization.

    Args:
        owner: GitHub username or organization name
        format: Response format — 'markdown' (default) or 'json'
    """
    data = await _make_api_request(f"/users/{owner}/repos")

    if format == "json":
        return _format_repos_json(data)
    return _format_repos_markdown(data)
```

---

## Pagination Implementation

### Paginated List Input

```python
class ListInput(BaseModel):
    model_config = ConfigDict(extra="forbid")

    limit: int = Field(default=20, ge=1, le=100, description="Max results per page")
    offset: int = Field(default=0, ge=0, description="Number of results to skip")
```

### Paginated Response Helper

```python
def _build_paginated_response(
    items: list[dict],
    total: int,
    limit: int,
    offset: int,
    format_fn,
) -> str:
    has_more = offset + len(items) < total
    next_offset = offset + len(items) if has_more else None

    formatted_items = format_fn(items)

    result = {
        "total": total,
        "count": len(items),
        "has_more": has_more,
        "limit": limit,
        "offset": offset,
    }
    if next_offset is not None:
        result["next_offset"] = next_offset
    result["items"] = formatted_items

    return json.dumps(result, indent=2)
```

### Usage in a Tool

```python
class ListIssuesInput(ListInput):
    owner: str = Field(..., min_length=1, description="Repository owner")
    repo: str = Field(..., min_length=1, description="Repository name")
    state: str = Field(default="open", pattern=r"^(open|closed|all)$")

@mcp.tool(name="github_list_issues", annotations={"readOnlyHint": True})
async def list_issues(input: ListIssuesInput) -> str:
    """List issues in a GitHub repository with pagination.

    Returns a paginated list of issues. Use `offset` and `limit` to page
    through results. Response includes `has_more` and `next_offset` for
    subsequent requests.
    """
    page = (input.offset // input.limit) + 1
    data = await _make_api_request(
        f"/repos/{input.owner}/{input.repo}/issues",
        params={"state": input.state, "per_page": input.limit, "page": page},
    )

    return _build_paginated_response(
        items=data,
        total=len(data),
        limit=input.limit,
        offset=input.offset,
        format_fn=lambda items: [
            {"number": i["number"], "title": i["title"], "state": i["state"]}
            for i in items
        ],
    )
```

---

## Error Handling

### API Error Handler

```python
import httpx

def _handle_api_error(e: Exception) -> str:
    if isinstance(e, httpx.HTTPStatusError):
        status = e.response.status_code
        try:
            body = e.response.json()
            message = body.get("message", e.response.text)
        except Exception:
            message = e.response.text

        if status == 404:
            return f"Error: Resource not found. Verify the owner, repo, and resource ID are correct. Details: {message}"
        elif status == 403:
            return f"Error: Access forbidden. Check that your API token has the required permissions. Details: {message}"
        elif status == 429:
            retry_after = e.response.headers.get("Retry-After", "unknown")
            return f"Error: Rate limit exceeded. Retry after {retry_after} seconds."
        elif status == 422:
            return f"Error: Validation failed. Check your input parameters. Details: {message}"
        elif status == 401:
            return f"Error: Authentication failed. Verify your API token is valid and not expired."
        else:
            return f"Error: API returned status {status}. Details: {message}"

    elif isinstance(e, httpx.TimeoutException):
        return "Error: Request timed out. The API server may be slow or unreachable. Try again or reduce the scope of your request."

    elif isinstance(e, httpx.ConnectError):
        return "Error: Could not connect to the API server. Check network connectivity and the API base URL."

    return f"Error: Unexpected error occurred: {type(e).__name__}: {str(e)}"
```

### Using Error Handler in Tools

```python
@mcp.tool(name="github_get_issue", annotations={"readOnlyHint": True})
async def get_issue(owner: str, repo: str, issue_number: int) -> str:
    """Get details of a specific GitHub issue."""
    try:
        data = await _make_api_request(f"/repos/{owner}/{repo}/issues/{issue_number}")
        return _format_issue(data)
    except Exception as e:
        return _handle_api_error(e)
```

---

## Shared Utilities

### API Client

```python
import httpx
import os

API_BASE_URL = "https://api.github.com"
DEFAULT_TIMEOUT = 30.0
CHARACTER_LIMIT = 25_000


async def _make_api_request(
    endpoint: str,
    method: str = "GET",
    params: dict | None = None,
    json_data: dict | None = None,
    timeout: float = DEFAULT_TIMEOUT,
) -> dict | list:
    token = os.environ.get("GITHUB_TOKEN")
    if not token:
        raise ValueError("GITHUB_TOKEN environment variable is not set")

    headers = {
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.github.v3+json",
        "User-Agent": "github-mcp-server",
    }

    url = f"{API_BASE_URL}{endpoint}"

    async with httpx.AsyncClient(timeout=timeout) as client:
        response = await client.request(
            method=method,
            url=url,
            headers=headers,
            params=params,
            json=json_data,
        )
        response.raise_for_status()
        return response.json()
```

### Character Limit Enforcement

```python
def _truncate_response(text: str, limit: int = CHARACTER_LIMIT) -> str:
    if len(text) <= limit:
        return text
    truncated = text[:limit]
    return truncated + f"\n\n... (truncated, {len(text) - limit} characters omitted)"
```

### Authentication Patterns

**Bearer Token (most common):**

```python
headers = {"Authorization": f"Bearer {os.environ['API_TOKEN']}"}
```

**API Key in header:**

```python
headers = {"X-API-Key": os.environ["API_KEY"]}
```

**API Key in query parameter:**

```python
params = {"api_key": os.environ["API_KEY"], **other_params}
```

**Basic Auth:**

```python
auth = httpx.BasicAuth(os.environ["USERNAME"], os.environ["PASSWORD"])
async with httpx.AsyncClient(auth=auth) as client:
    response = await client.get(url)
```

---

## Async/Await Best Practices

### Always Use async/await for I/O

Every tool function that makes network calls, reads files, or accesses a database must be `async`:

```python
@mcp.tool(name="service_fetch_data")
async def fetch_data(resource_id: str) -> str:
    """Fetch data from the service API."""
    data = await _make_api_request(f"/resources/{resource_id}")
    return json.dumps(data, indent=2)
```

### httpx.AsyncClient (never use sync requests)

```python
async with httpx.AsyncClient(timeout=30.0) as client:
    response = await client.get("https://api.example.com/data")
    data = response.json()
```

Never use `requests` or `httpx.Client` (synchronous). MCP servers run in an async event loop — blocking calls will freeze all tool execution.

### Context Manager Pattern for Reusable Clients

For servers making many API calls, create a shared client:

```python
from contextlib import asynccontextmanager
from collections.abc import AsyncIterator

_http_client: httpx.AsyncClient | None = None


@asynccontextmanager
async def get_http_client() -> AsyncIterator[httpx.AsyncClient]:
    global _http_client
    if _http_client is None or _http_client.is_closed:
        _http_client = httpx.AsyncClient(
            base_url=API_BASE_URL,
            headers={"Authorization": f"Bearer {os.environ.get('API_TOKEN', '')}"},
            timeout=DEFAULT_TIMEOUT,
        )
    try:
        yield _http_client
    except Exception:
        await _http_client.aclose()
        _http_client = None
        raise
```

### Parallel Async Calls

```python
import asyncio

async def fetch_multiple(ids: list[str]) -> list[dict]:
    tasks = [_make_api_request(f"/items/{id}") for id in ids]
    return await asyncio.gather(*tasks, return_exceptions=True)
```

---

## Transport Setup

### stdio (Local — Claude Desktop, VS Code)

```python
if __name__ == "__main__":
    mcp.run(transport="stdio")
```

### HTTP with Starlette/ASGI (Remote Servers)

```python
from starlette.applications import Starlette
from starlette.routing import Mount
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("service_mcp")

app = Starlette(
    routes=[
        Mount("/", app=mcp.http_app()),
    ],
)
```

Run with uvicorn:

```bash
uvicorn server:app --host 0.0.0.0 --port 8000
```

### Environment-Based Transport Selection

```python
import os

if __name__ == "__main__":
    transport = os.environ.get("MCP_TRANSPORT", "stdio")

    if transport == "stdio":
        mcp.run(transport="stdio")
    elif transport == "http":
        import uvicorn
        from starlette.applications import Starlette
        from starlette.routing import Mount

        app = Starlette(routes=[Mount("/", app=mcp.http_app())])
        uvicorn.run(app, host="0.0.0.0", port=int(os.environ.get("PORT", "8000")))
    else:
        raise ValueError(f"Unknown transport: {transport}")
```

---

## Complete Working Example

### server.py

```python
from mcp.server.fastmcp import FastMCP
from pydantic import BaseModel, Field, field_validator, ConfigDict
from enum import Enum
import httpx
import json
import os

API_BASE_URL = "https://api.github.com"
DEFAULT_TIMEOUT = 30.0
CHARACTER_LIMIT = 25_000

mcp = FastMCP("github_mcp")


class ResponseFormat(str, Enum):
    MARKDOWN = "markdown"
    JSON = "json"


class SearchIssuesInput(BaseModel):
    model_config = ConfigDict(
        str_strip_whitespace=True,
        validate_assignment=True,
        extra="forbid",
    )

    owner: str = Field(..., min_length=1, max_length=100, description="Repository owner")
    repo: str = Field(..., min_length=1, max_length=100, description="Repository name")
    query: str = Field(..., min_length=1, max_length=256, description="Search query")
    state: str = Field(default="open", pattern=r"^(open|closed|all)$", description="Issue state filter")
    limit: int = Field(default=20, ge=1, le=100, description="Max results")
    offset: int = Field(default=0, ge=0, description="Results to skip")
    format: ResponseFormat = Field(default=ResponseFormat.MARKDOWN, description="Response format")

    @field_validator("query")
    @classmethod
    def validate_query(cls, v: str) -> str:
        if not v.strip():
            raise ValueError("Query cannot be empty or whitespace")
        return v


class GetIssueInput(BaseModel):
    model_config = ConfigDict(extra="forbid")

    owner: str = Field(..., min_length=1, description="Repository owner")
    repo: str = Field(..., min_length=1, description="Repository name")
    issue_number: int = Field(..., ge=1, description="Issue number")
    format: ResponseFormat = Field(default=ResponseFormat.MARKDOWN, description="Response format")


class CreateIssueInput(BaseModel):
    model_config = ConfigDict(str_strip_whitespace=True, extra="forbid")

    owner: str = Field(..., min_length=1, description="Repository owner")
    repo: str = Field(..., min_length=1, description="Repository name")
    title: str = Field(..., min_length=1, max_length=256, description="Issue title")
    body: str = Field(default="", max_length=65536, description="Issue body (markdown)")
    labels: list[str] = Field(default_factory=list, description="Labels to apply")


async def _make_api_request(
    endpoint: str,
    method: str = "GET",
    params: dict | None = None,
    json_data: dict | None = None,
) -> dict | list:
    token = os.environ.get("GITHUB_TOKEN")
    if not token:
        raise ValueError("GITHUB_TOKEN environment variable is not set")

    headers = {
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.github.v3+json",
        "User-Agent": "github-mcp-server",
    }

    async with httpx.AsyncClient(timeout=DEFAULT_TIMEOUT) as client:
        response = await client.request(
            method=method,
            url=f"{API_BASE_URL}{endpoint}",
            headers=headers,
            params=params,
            json=json_data,
        )
        response.raise_for_status()
        return response.json()


def _handle_api_error(e: Exception) -> str:
    if isinstance(e, httpx.HTTPStatusError):
        status = e.response.status_code
        try:
            body = e.response.json()
            message = body.get("message", e.response.text)
        except Exception:
            message = e.response.text

        error_map = {
            401: "Authentication failed. Verify your GITHUB_TOKEN is valid.",
            403: "Access forbidden. Check token permissions.",
            404: "Resource not found. Verify owner, repo, and resource ID.",
            422: f"Validation failed. Check input parameters. Details: {message}",
            429: f"Rate limit exceeded. Retry after {e.response.headers.get('Retry-After', 'unknown')} seconds.",
        }
        return f"Error: {error_map.get(status, f'API returned status {status}. Details: {message}')}"

    if isinstance(e, httpx.TimeoutException):
        return "Error: Request timed out. Try again or reduce request scope."

    return f"Error: {type(e).__name__}: {str(e)}"


def _truncate(text: str, limit: int = CHARACTER_LIMIT) -> str:
    if len(text) <= limit:
        return text
    return text[:limit] + f"\n\n... (truncated, {len(text) - limit} chars omitted)"


def _format_issue_markdown(issue: dict) -> str:
    labels = ", ".join(f"`{l['name']}`" for l in issue.get("labels", []))
    return (
        f"## #{issue['number']}: {issue['title']}\n\n"
        f"**State:** {issue['state']} | **Author:** {issue['user']['login']}\n"
        + (f"**Labels:** {labels}\n" if labels else "")
        + f"\n{issue.get('body', 'No description.')}\n"
    )


def _format_issue_json(issue: dict) -> str:
    return json.dumps(
        {
            "number": issue["number"],
            "title": issue["title"],
            "state": issue["state"],
            "author": issue["user"]["login"],
            "labels": [l["name"] for l in issue.get("labels", [])],
            "body": issue.get("body", ""),
            "url": issue["html_url"],
        },
        indent=2,
    )


@mcp.tool(
    name="github_search_issues",
    annotations={"readOnlyHint": True, "openWorldHint": True},
)
async def search_issues(input: SearchIssuesInput) -> str:
    """Search GitHub issues by query, labels, assignee, or state.

    Searches across issue titles, bodies, and comments. Supports GitHub search
    qualifiers like `label:bug`, `assignee:username`, `is:open`.

    Returns paginated results with `has_more` and `next_offset` for subsequent pages.
    """
    try:
        page = (input.offset // input.limit) + 1
        data = await _make_api_request(
            "/search/issues",
            params={
                "q": f"repo:{input.owner}/{input.repo} {input.query}",
                "per_page": input.limit,
                "page": page,
            },
        )

        total = data.get("total_count", 0)
        items = data.get("items", [])
        has_more = input.offset + len(items) < total

        if input.format == ResponseFormat.JSON:
            result = {
                "total": total,
                "count": len(items),
                "has_more": has_more,
                "offset": input.offset,
                "limit": input.limit,
            }
            if has_more:
                result["next_offset"] = input.offset + len(items)
            result["issues"] = [
                {
                    "number": i["number"],
                    "title": i["title"],
                    "state": i["state"],
                    "author": i["user"]["login"],
                    "url": i["html_url"],
                }
                for i in items
            ]
            return _truncate(json.dumps(result, indent=2))

        lines = [f"# Search Results ({total} total)\n"]
        for issue in items:
            lines.append(_format_issue_markdown(issue))
            lines.append("---\n")
        if has_more:
            lines.append(f"\n*More results available. Use offset={input.offset + len(items)} to see next page.*")
        return _truncate("\n".join(lines))

    except Exception as e:
        return _handle_api_error(e)


@mcp.tool(
    name="github_get_issue",
    annotations={"readOnlyHint": True, "idempotentHint": True},
)
async def get_issue(input: GetIssueInput) -> str:
    """Get complete details of a specific GitHub issue.

    Retrieves full issue data including title, body, labels, assignees,
    and metadata. Use this when you need detailed information about a
    single known issue.
    """
    try:
        data = await _make_api_request(
            f"/repos/{input.owner}/{input.repo}/issues/{input.issue_number}"
        )
        if input.format == ResponseFormat.JSON:
            return _truncate(_format_issue_json(data))
        return _truncate(_format_issue_markdown(data))
    except Exception as e:
        return _handle_api_error(e)


@mcp.tool(
    name="github_create_issue",
    annotations={
        "readOnlyHint": False,
        "destructiveHint": False,
        "idempotentHint": False,
        "openWorldHint": True,
    },
)
async def create_issue(input: CreateIssueInput) -> str:
    """Create a new issue in a GitHub repository.

    Creates an issue with the specified title, body, and labels. Requires
    write access to the repository. Returns the created issue URL and number.
    """
    try:
        payload = {"title": input.title, "body": input.body}
        if input.labels:
            payload["labels"] = input.labels

        data = await _make_api_request(
            f"/repos/{input.owner}/{input.repo}/issues",
            method="POST",
            json_data=payload,
        )
        return f"Created issue #{data['number']}: {data['html_url']}"
    except Exception as e:
        return _handle_api_error(e)


if __name__ == "__main__":
    transport = os.environ.get("MCP_TRANSPORT", "stdio")
    mcp.run(transport=transport)
```

### pyproject.toml

```toml
[project]
name = "github-mcp-server"
version = "1.0.0"
description = "MCP server for GitHub API integration"
requires-python = ">=3.10"
dependencies = [
    "mcp[cli]>=1.0.0",
    "httpx>=0.27.0",
    "pydantic>=2.0.0",
]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[project.scripts]
github-mcp = "server:main"
```

### Run Commands

```bash
# Install dependencies
pip install "mcp[cli]" httpx
# or
uv add "mcp[cli]" httpx

# Run with stdio (local)
GITHUB_TOKEN=ghp_xxx python server.py

# Run with HTTP (remote)
MCP_TRANSPORT=http GITHUB_TOKEN=ghp_xxx python server.py

# Test with MCP Inspector
npx @modelcontextprotocol/inspector python server.py
```

---

## Quality Checklist

- [ ] All `field_validator` methods use `@classmethod` decorator
- [ ] Using Pydantic v2 patterns: `model_config`, `field_validator`, `model_dump()`
- [ ] No Pydantic v1 patterns: no nested `Config` class, no `@validator`, no `.dict()`
- [ ] All tool functions are `async def`
- [ ] Using `httpx.AsyncClient` (never `requests` or sync `httpx.Client`)
- [ ] Type hints on all function parameters and return types
- [ ] Comprehensive docstrings on all `@mcp.tool` functions (auto-become descriptions)
- [ ] `model_config = ConfigDict(extra="forbid")` on all input models
- [ ] Tool names prefixed with service name: `github_search_issues`, not `search_issues`
- [ ] Tool annotations set: `readOnlyHint`, `destructiveHint`, `idempotentHint`
- [ ] Pagination with `limit`, `offset`, `has_more`, `next_offset` on list operations
- [ ] Character limit enforcement on large responses
- [ ] Error handling with `_handle_api_error` returning actionable messages
- [ ] Environment variables for secrets (never hardcoded)
- [ ] Logging to stderr only (stdout reserved for stdio transport)
