## Tool Categories and Validation Matrices

### Tool Validation Patterns

| Tool Category | Validation Method | Fallback Strategy | Installation Check |
|---------------|-------------------|-------------------|-------------------|
| **MCP Tools** | Server connectivity + tool query | CLI equivalent → Manual workflow | Server configuration |
| **CLI Tools** | `command -v` + auth test | Alternative CLI → Built-in tools | Package manager guidance |
| **Skills** | Directory + dependency check | Alternative skill → Manual steps | Configuration guidance |
| **Built-in** | Always available | N/A (reliable) | N/A (always present) |

### Common Fallback Chains

**Jira Operations:**
1. `atlassian.getJiraIssue` (MCP) → `acli jira view` (CLI) → Browser navigation (Manual)

**GitLab Operations:**
1. `gitlab-sidekick.gitlab_mrOverview` (MCP) → `glab mr view` (CLI) → GitLab web UI (Manual)

**Confluence Operations:**
1. `atlassian.getConfluencePage` (MCP) → Browser automation (MCP) → Manual page access (Manual)

**Code Analysis:**
1. `serena-mcp` (MCP) → `grep`/`find` (CLI) → Manual code search (Manual)

**Database Operations:**
1. `databricks.execute_sql_query` (MCP) → `mysql`/`psql` clients (CLI) → Database web UI (Manual)

### MCP Tool Validation Matrix

| MCP Server | Primary Tools | Validation Method | Common Fallbacks |
|------------|---------------|-------------------|-------------------|
| **atlassian** | Jira/Confluence operations | Server ping + tool query | acli CLI → Browser |
| **serena** | Semantic code navigation | Directory listing test | grep/find → IDE |
| **databricks** | SQL query execution | Schema listing test | mysql CLI → Web UI |
| **glean** | Documentation search | Search test query | Web search → Manual |
| **gitlab-sidekick** | GitLab operations | MR listing test | glab CLI → GitLab Web |
| **chrome-devtools** | Browser automation | Page listing test | Manual navigation |

### CLI Tool Installation Matrix

| CLI Tool | Installation Command | Authentication | Fallback Strategy |
|----------|---------------------|----------------|-------------------|
| **glab** | `brew install glab` | `glab auth login` | GitLab Web UI |
| **acli** | `brew install atlassian-labs/acli/acli` | `acli auth login` | Atlassian Web UI |
| **datadog** | `pip install datadog` | `datadog configure` | Datadog Web UI |
| **git** | Usually pre-installed | `git config user.*` | GitHub/GitLab Web |
| **mysql** | `brew install mysql-client` | Connection string | Adminer Web UI |

### Skill Dependency Patterns

| Skill Category | Common Dependencies | Validation Pattern | Fallback Approach |
|----------------|--------------------|--------------------|-------------------|
| **MCP-Heavy** | Atlassian, Serena, Databricks | MCP + CLI validation | CLI → Manual |
| **CLI-Heavy** | glab, acli, git | CLI + auth validation | Web UI → Manual |
| **Hybrid** | Mixed MCP + CLI | Full stack validation | Intelligent degradation |
| **System** | Built-in tools only | Directory + config check | Always available |

### Comprehensive Tool Ecosystem Matrix

#### Development Tools
| Tool | Type | Purpose | Validation | Alternatives |
|------|------|---------|-----------|--------------|
| git | CLI | Version control | `git --version` | GitHub Desktop, GitLab Web |
| glab | CLI | GitLab operations | `glab auth status` | GitLab Web UI |
| gh | CLI | GitHub operations | `gh auth status` | GitHub Web UI |
| mutagen | CLI | File sync | `mutagen list sessions` | rsync, manual copy |

#### Database Tools
| Tool | Type | Purpose | Validation | Alternatives |
|------|------|---------|-----------|--------------|
| databricks MCP | MCP | SQL analytics | List schemas | mysql CLI, Web UI |
| mysql | CLI | Database client | Connection test | phpMyAdmin, Adminer |
| psql | CLI | PostgreSQL client | Connection test | pgAdmin, Web UI |

#### Integration Tools
| Tool | Type | Purpose | Validation | Alternatives |
|------|------|---------|-----------|--------------|
| atlassian MCP | MCP | Jira/Confluence | Server ping | acli, Web UI |
| acli | CLI | Atlassian operations | `acli auth status` | Web interfaces |
| datadog MCP | MCP | Monitoring/logs | API test | datadog CLI, Web UI |

#### Code Analysis Tools
| Tool | Type | Purpose | Validation | Alternatives |
|------|------|---------|-----------|--------------|
| serena MCP | MCP | Code navigation | Directory test | grep, find, IDE |
| grep | CLI | Pattern search | Always available | Built-in search |
| find | CLI | File search | Always available | Glob patterns |

### Authentication Matrix

| Tool Category | Auth Methods | Validation Command | Recovery Steps |
|---------------|--------------|-------------------|----------------|
| **GitLab Tools** | Personal Access Token, OAuth | `glab auth status` | `glab auth login` |
| **Atlassian Tools** | API Token, OAuth | `acli auth status` | `acli auth login` |
| **Database Tools** | Connection String, Credentials | Connection test | Credential refresh |
| **Monitoring Tools** | API Key, OAuth | API test call | Key rotation |

### Environment-Specific Tool Availability

#### Local Development Environment
- ✅ All CLI tools available
- ✅ MCP servers configurable
- ✅ Full authentication support
- ✅ Complete fallback chains

#### Remote Development Environment
- ⚠️ Limited CLI tool access
- ✅ MCP servers via tunnel
- ⚠️ Authentication complexity
- 🔄 Reduced fallback options

#### CI/CD Environment
- ✅ Containerized CLI tools
- ⚠️ Limited MCP access
- 🔐 Service account auth
- 📋 Predefined tool sets

#### Docker Environment
- 🐳 Containerized tools
- 🔗 Volume mount dependencies
- ⚠️ Network connectivity limits
- 🔧 Configuration complexity

This comprehensive tool matrix provides complete visibility into tool availability, validation methods, authentication requirements, and fallback strategies across all environments and use cases.