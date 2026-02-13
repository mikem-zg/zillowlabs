#!/bin/bash

# Install Guidance - Installation and setup guidance for all tool types
# Provides comprehensive installation instructions for MCP servers, CLI tools, and skill setup

# Set strict error handling
set -euo pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" && pwd)"
source "$SCRIPT_DIR/tool-utils.sh"

# Detect operating system and package manager
detect_os_and_package_manager() {
    local os_info=""
    local package_manager=""

    # Detect OS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        os_info="macOS"
        if command -v brew >/dev/null 2>&1; then
            package_manager="brew"
        else
            package_manager="manual"
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        os_info="Linux"
        if command -v apt-get >/dev/null 2>&1; then
            package_manager="apt"
        elif command -v yum >/dev/null 2>&1; then
            package_manager="yum"
        elif command -v pacman >/dev/null 2>&1; then
            package_manager="pacman"
        else
            package_manager="manual"
        fi
    else
        os_info="Unknown"
        package_manager="manual"
    fi

    echo "$os_info:$package_manager"
}

# Provide CLI tool installation guidance
provide_cli_install_guidance() {
    local tool_name="$1"
    local os_and_pm
    os_and_pm=$(detect_os_and_package_manager)
    local os_name="${os_and_pm%%:*}"
    local package_manager="${os_and_pm#*:}"

    echo "📦 Installation Guide for CLI Tool: $tool_name"
    echo "Detected OS: $os_name, Package Manager: $package_manager"
    echo ""

    case "$tool_name" in
        "glab")
            echo "🔧 GitLab CLI (glab)"
            echo ""
            case "$package_manager" in
                "brew")
                    echo "**Installation:**"
                    echo "  brew install glab"
                    echo ""
                    ;;
                "apt")
                    echo "**Installation:**"
                    echo "  # Add repository"
                    echo "  curl -fsSL https://gitlab.com/gitlab-org/cli/-/raw/main/scripts/install.sh | bash"
                    echo "  # Or manual download"
                    echo "  wget https://github.com/profclems/glab/releases/latest/download/glab_linux_amd64.deb"
                    echo "  sudo dpkg -i glab_linux_amd64.deb"
                    echo ""
                    ;;
                *)
                    echo "**Manual Installation:**"
                    echo "  # Download from GitHub releases"
                    echo "  wget https://github.com/profclems/glab/releases/latest/download/glab_\$(uname -s)_\$(uname -m).tar.gz"
                    echo "  tar -xzf glab_*.tar.gz"
                    echo "  sudo mv glab /usr/local/bin/"
                    echo ""
                    ;;
            esac
            echo "**Authentication:**"
            echo "  glab auth login"
            echo "  # Follow prompts to authenticate with GitLab"
            echo ""
            echo "**Configuration for FUB:**"
            echo "  glab config set host gitlab.zgtools.net"
            echo "  glab config set api_host https://gitlab.zgtools.net/api/v4/"
            echo ""
            echo "**Verification:**"
            echo "  glab --version"
            echo "  glab mr list --project=fub/fub"
            ;;

        "acli")
            echo "🔧 Atlassian CLI (acli)"
            echo ""
            case "$package_manager" in
                "brew")
                    echo "**Installation:**"
                    echo "  brew install atlassian-labs/acli/acli"
                    echo ""
                    ;;
                *)
                    echo "**Installation (npm required):**"
                    echo "  npm install -g @atlassian/acli"
                    echo ""
                    echo "**Alternative (manual download):**"
                    echo "  # Download appropriate binary from:"
                    echo "  # https://github.com/atlassian-labs/acli/releases"
                    echo ""
                    ;;
            esac
            echo "**Authentication:**"
            echo "  acli auth login"
            echo "  # Configure for: zillowgroup.atlassian.net"
            echo "  # Use your Atlassian email and API token"
            echo ""
            echo "**API Token Setup:**"
            echo "  1. Go to: https://id.atlassian.com/manage-profile/security/api-tokens"
            echo "  2. Create API token with appropriate permissions"
            echo "  3. Use during acli auth login"
            echo ""
            echo "**Verification:**"
            echo "  acli --version"
            echo "  acli jira issue list"
            echo "  acli confluence page list"
            ;;

        "datadog")
            echo "🔧 Datadog CLI"
            echo ""
            echo "**Installation (Python):**"
            echo "  pip install datadog"
            echo "  # or"
            echo "  pip3 install datadog"
            echo ""
            echo "**Alternative (npm):**"
            echo "  npm install -g @datadog/datadog-ci"
            echo ""
            echo "**Configuration:**"
            echo "  datadog configure"
            echo "  # Enter API key and Application key from Datadog"
            echo ""
            echo "**API Keys:**"
            echo "  1. Go to: https://app.datadoghq.com/organization-settings/api-keys"
            echo "  2. Create or copy API key"
            echo "  3. Create Application key in same section"
            echo ""
            echo "**Verification:**"
            echo "  datadog version"
            echo "  datadog monitor list"
            ;;

        "git")
            echo "🔧 Git Version Control"
            echo ""
            case "$package_manager" in
                "brew")
                    echo "**Installation:**"
                    echo "  brew install git"
                    echo ""
                    ;;
                "apt")
                    echo "**Installation:**"
                    echo "  sudo apt-get update"
                    echo "  sudo apt-get install git"
                    echo ""
                    ;;
                *)
                    echo "**Installation:**"
                    echo "  # Usually pre-installed on most systems"
                    echo "  # Check: git --version"
                    echo ""
                    ;;
            esac
            echo "**Configuration:**"
            echo "  git config --global user.name \"Your Name\""
            echo "  git config --global user.email \"your.email@zillowgroup.com\""
            echo "  git config --global init.defaultBranch main"
            echo ""
            echo "**SSH Key Setup (Recommended):**"
            echo "  ssh-keygen -t ed25519 -C \"your.email@zillowgroup.com\""
            echo "  cat ~/.ssh/id_ed25519.pub"
            echo "  # Add to GitLab/GitHub SSH keys"
            echo ""
            echo "**Verification:**"
            echo "  git --version"
            echo "  git config --list"
            ;;

        "mysql")
            echo "🔧 MySQL Client"
            echo ""
            case "$package_manager" in
                "brew")
                    echo "**Installation:**"
                    echo "  brew install mysql-client"
                    echo "  # Add to PATH:"
                    echo "  echo 'export PATH=\"/opt/homebrew/opt/mysql-client/bin:\$PATH\"' >> ~/.zshrc"
                    echo ""
                    ;;
                "apt")
                    echo "**Installation:**"
                    echo "  sudo apt-get install mysql-client"
                    echo ""
                    ;;
                *)
                    echo "**Installation:**"
                    echo "  # Download from: https://dev.mysql.com/downloads/mysql/"
                    echo "  # Or use distribution package manager"
                    echo ""
                    ;;
            esac
            echo "**Connection Test:**"
            echo "  mysql -h [hostname] -u [username] -p [database]"
            echo ""
            echo "**For FUB Databases:**"
            echo "  # Use connection details from environment configuration"
            echo "  # Test with: mysql -h db.example.com -u username -p database_name"
            ;;

        "psql")
            echo "🔧 PostgreSQL Client"
            echo ""
            case "$package_manager" in
                "brew")
                    echo "**Installation:**"
                    echo "  brew install postgresql"
                    echo ""
                    ;;
                "apt")
                    echo "**Installation:**"
                    echo "  sudo apt-get install postgresql-client"
                    echo ""
                    ;;
                *)
                    echo "**Installation:**"
                    echo "  # Download from: https://www.postgresql.org/download/"
                    echo ""
                    ;;
            esac
            echo "**Connection Test:**"
            echo "  psql -h [hostname] -U [username] -d [database]"
            ;;

        *)
            echo "⚠️  Unknown CLI tool: $tool_name"
            echo ""
            echo "**General CLI Installation Steps:**"
            echo "  1. Check if available in package manager:"
            case "$package_manager" in
                "brew") echo "     brew search $tool_name" ;;
                "apt") echo "     apt search $tool_name" ;;
                *) echo "     Search online for installation instructions" ;;
            esac
            echo "  2. Check official documentation or GitHub releases"
            echo "  3. Download appropriate binary for your OS"
            echo "  4. Add to PATH if necessary"
            echo "  5. Configure authentication if required"
            ;;
    esac
}

# Provide MCP server setup guidance
provide_mcp_install_guidance() {
    local server_name="$1"

    echo "🔧 MCP Server Setup Guide: $server_name"
    echo ""

    case "$server_name" in
        "atlassian")
            cat << 'EOF'
**Atlassian MCP Server Setup:**

**Prerequisites:**
  - Active Atlassian account (zillowgroup.atlassian.net)
  - API token with appropriate permissions
  - Claude Code with MCP support enabled

**Configuration Steps:**
  1. Open Claude Code Settings
  2. Navigate to: Features → Model Context Protocol
  3. Find "Atlassian" in available MCP servers list
  4. Click "Add" or "Enable"
  5. Configure connection settings:
     - Server URL: (auto-configured)
     - Authentication: Use Atlassian API token
     - Instance URL: https://zillowgroup.atlassian.net

**API Token Setup:**
  1. Go to: https://id.atlassian.com/manage-profile/security/api-tokens
  2. Click "Create API token"
  3. Label: "Claude Code MCP Access"
  4. Copy the generated token
  5. Enter token in Claude Code MCP configuration

**Verification:**
  /tool-management --operation=validate --tool_name=atlassian --tool_category=mcp

**Troubleshooting:**
  - Restart Claude Code if connection fails
  - Verify API token has correct permissions
  - Check internet connection and firewall
  - Ensure Atlassian instance URL is correct
EOF
            ;;

        "serena")
            cat << 'EOF'
**Serena MCP Server Setup:**

**Prerequisites:**
  - Project workspace with Serena configuration
  - Proper file access permissions
  - Serena MCP server binary available

**Configuration Steps:**
  1. Verify project has .serena configuration files
  2. Check Serena MCP server is installed and accessible
  3. Configure Claude Code MCP settings:
     - Server: Serena
     - Workspace: Current project directory
     - Permissions: File read/write access

**Project Setup:**
  1. Initialize Serena in project (if needed):
     serena init
  2. Configure workspace settings
  3. Test basic operations

**Verification:**
  /tool-management --operation=validate --tool_name=serena --tool_category=mcp

**Troubleshooting:**
  - Ensure project directory has proper Serena configuration
  - Check file permissions for project access
  - Verify Serena MCP server is running
  - Restart MCP connection if needed
EOF
            ;;

        "databricks")
            cat << 'EOF'
**Databricks MCP Server Setup:**

**Prerequisites:**
  - Databricks workspace access
  - Personal access token or OAuth configuration
  - Network access to Databricks workspace

**Configuration Steps:**
  1. Generate Databricks personal access token:
     - Go to Databricks workspace → User Settings → Access Tokens
     - Generate new token with appropriate scope
  2. Configure Claude Code MCP:
     - Server: Databricks
     - Workspace URL: Your Databricks workspace URL
     - Token: Personal access token

**Authentication:**
  - Personal Access Token (recommended for development)
  - OAuth (for production environments)
  - Service Principal (for automated workflows)

**Verification:**
  /tool-management --operation=validate --tool_name=databricks --tool_category=mcp

**Test Connection:**
  - Try listing schemas: databricks.list_schemas
  - Execute simple query: databricks.execute_sql_query "SHOW TABLES"
EOF
            ;;

        "glean-tools")
            cat << 'EOF'
**Glean MCP Server Setup:**

**Prerequisites:**
  - Glean workspace access
  - Authentication credentials
  - Proper permissions for document access

**Configuration Steps:**
  1. Configure Glean authentication in Claude Code
  2. Set workspace URL and credentials
  3. Test connection and permissions

**Verification:**
  /tool-management --operation=validate --tool_name=glean-tools --tool_category=mcp

**Common Issues:**
  - Permission errors: Check Glean access permissions
  - Connection issues: Verify network access to Glean
  - Authentication: Refresh credentials if expired
EOF
            ;;

        "gitlab-sidekick")
            cat << 'EOF'
**GitLab Sidekick MCP Server Setup:**

**Prerequisites:**
  - GitLab access (gitlab.zgtools.net)
  - Personal access token with API scope
  - Project access permissions

**Configuration Steps:**
  1. Generate GitLab personal access token:
     - Go to GitLab → User Settings → Access Tokens
     - Create token with 'api' scope
  2. Configure Claude Code MCP:
     - Server: GitLab Sidekick
     - GitLab URL: https://gitlab.zgtools.net
     - Token: Personal access token

**Token Permissions:**
  - api (required)
  - read_repository (recommended)
  - write_repository (for MR creation)

**Verification:**
  /tool-management --operation=validate --tool_name=gitlab-sidekick --tool_category=mcp
EOF
            ;;

        "chrome-devtools")
            cat << 'EOF'
**Chrome DevTools MCP Server Setup:**

**Prerequisites:**
  - Google Chrome or Chromium browser
  - Browser debugging enabled
  - Network access permissions

**Configuration Steps:**
  1. Enable Chrome debugging:
     - Start Chrome with: --remote-debugging-port=9222
  2. Configure Claude Code MCP:
     - Server: Chrome DevTools
     - Debug port: 9222 (default)
     - Host: localhost

**Browser Setup:**
  # Start Chrome with debugging
  google-chrome --remote-debugging-port=9222 --no-first-run --no-default-browser-check

**Verification:**
  /tool-management --operation=validate --tool_name=chrome-devtools --tool_category=mcp

**Security Note:**
  - Only use on trusted networks
  - Debugging port provides full browser access
EOF
            ;;

        *)
            echo "⚠️  Unknown MCP server: $server_name"
            echo ""
            echo "**General MCP Server Setup:**"
            echo "  1. Check Claude Code MCP settings"
            echo "  2. Verify server is available in MCP server list"
            echo "  3. Configure authentication if required"
            echo "  4. Test connection and basic operations"
            echo "  5. Check server documentation for specific setup steps"
            ;;
    esac
}

# Provide skill setup guidance
provide_skill_install_guidance() {
    local skill_name="$1"

    echo "📚 Skill Setup Guide: $skill_name"
    echo ""

    if [[ -f "$HOME/.claude/skills/$skill_name/SKILL.md" ]]; then
        echo "✅ Skill '$skill_name' is already installed"
        echo ""

        # Check dependencies
        echo "**Dependency Check:**"
        local skill_content
        skill_content=$(cat "$HOME/.claude/skills/$skill_name/SKILL.md")

        # Extract and list dependencies
        if echo "$skill_content" | grep -qi "MCP\|atlassian\|serena\|databricks"; then
            echo "  📡 MCP Dependencies detected:"
            echo "$skill_content" | grep -i "MCP\|atlassian\|serena\|databricks" | head -3 | sed 's/^/    /'
            echo ""
        fi

        if echo "$skill_content" | grep -qi "CLI\|glab\|acli\|git"; then
            echo "  🔧 CLI Dependencies detected:"
            echo "$skill_content" | grep -i "CLI\|glab\|acli\|git" | head -3 | sed 's/^/    /'
            echo ""
        fi

        echo "**Validation:**"
        echo "  /tool-management --operation=validate --tool_name=$skill_name --tool_category=skill"
    else
        echo "❌ Skill '$skill_name' not found"
        echo ""
        echo "**Skill Installation:**"
        echo "  1. Skills are typically installed via Claude Code"
        echo "  2. Check available skills: ls ~/.claude/skills/"
        echo "  3. Download or create skill in: ~/.claude/skills/$skill_name/"
        echo "  4. Ensure SKILL.md file exists with proper format"
        echo ""
        echo "**Manual Skill Creation:**"
        echo "  mkdir -p ~/.claude/skills/$skill_name"
        echo "  # Create SKILL.md with appropriate content"
        echo "  # Add any required scripts or resources"
    fi
}

# Environment setup guidance
provide_environment_setup() {
    echo "🌍 Complete Development Environment Setup"
    echo ""

    local os_and_pm
    os_and_pm=$(detect_os_and_package_manager)
    local os_name="${os_and_pm%%:*}"
    local package_manager="${os_and_pm#*:}"

    echo "**System Information:**"
    echo "  OS: $os_name"
    echo "  Package Manager: $package_manager"
    echo ""

    echo "**Essential Tools Installation Order:**"
    echo ""

    echo "1. **Core Development Tools:**"
    case "$package_manager" in
        "brew")
            echo "   brew install git curl jq"
            ;;
        "apt")
            echo "   sudo apt-get install git curl jq"
            ;;
        *)
            echo "   Install git, curl, jq via your package manager"
            ;;
    esac
    echo ""

    echo "2. **FUB-Specific CLI Tools:**"
    echo "   a. GitLab CLI:"
    echo "      /tool-management --operation=install-guidance --tool_name=glab"
    echo "   b. Atlassian CLI:"
    echo "      /tool-management --operation=install-guidance --tool_name=acli"
    echo ""

    echo "3. **Database Clients:**"
    echo "   a. MySQL Client:"
    echo "      /tool-management --operation=install-guidance --tool_name=mysql"
    echo "   b. PostgreSQL Client:"
    echo "      /tool-management --operation=install-guidance --tool_name=psql"
    echo ""

    echo "4. **MCP Servers Configuration:**"
    echo "   a. Atlassian MCP:"
    echo "      /tool-management --operation=install-guidance --tool_name=atlassian --tool_category=mcp"
    echo "   b. Serena MCP:"
    echo "      /tool-management --operation=install-guidance --tool_name=serena --tool_category=mcp"
    echo ""

    echo "5. **Verification:**"
    echo "   /tool-management --operation=health-check --tool_category=all"
    echo ""

    echo "**Authentication Setup Priority:**"
    echo "  1. Git configuration (name, email, SSH keys)"
    echo "  2. GitLab authentication (glab auth login)"
    echo "  3. Atlassian authentication (acli auth login + API tokens)"
    echo "  4. MCP server authentication (via Claude Code settings)"
}

# Main execution function
main() {
    local tool_category="${1:-}"
    local tool_name="${2:-}"

    if [[ -z "$tool_category" || -z "$tool_name" ]]; then
        echo "Usage: $0 <category> <tool_name>"
        echo "Categories: cli, mcp, skill, environment"
        echo "Examples:"
        echo "  $0 cli glab"
        echo "  $0 mcp atlassian"
        echo "  $0 skill jira-management"
        echo "  $0 environment setup"
        return 1
    fi

    case "$tool_category" in
        "cli")
            provide_cli_install_guidance "$tool_name"
            ;;
        "mcp")
            provide_mcp_install_guidance "$tool_name"
            ;;
        "skill")
            provide_skill_install_guidance "$tool_name"
            ;;
        "environment")
            provide_environment_setup
            ;;
        *)
            log_error "Unknown tool category: $tool_category"
            echo "Supported categories: cli, mcp, skill, environment"
            return 1
            ;;
    esac
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]:-}" == "${0}" ]]; then
    main "$@"
fi