---
name: pending-action-items
description: "Read emails and documents where the user is tagged/mentioned and summarize pending action items. Use this skill when the user asks to check pending items, action items, what needs attention, tasks assigned to them, or wants to review their inbox for actionable items. Also trigger when they mention being overwhelmed by notifications or needing to catch up on mentions/tags."
---

# Pending Action Items Tracker

This skill reads through your emails and documents where you're mentioned or tagged, identifies actionable items, and provides a prioritized summary of what needs your attention.

## When to Use

Use this skill when the user:
- Asks to "check pending items" or "what needs my attention"
- Wants to "summarize action items" or "review actionable emails"
- Mentions being "tagged," "mentioned," or "assigned" in emails/documents
- Says they're "overwhelmed by notifications" or need to "catch up"
- Wants to see "what's waiting for me" or "tasks I need to complete"

## Core Workflow

### Step 0: Detect User Identity
First, get the current user's information to personalize mention detection:

```bash
# Get user's email and name from Gmail whoami or git config
gws gmail +whoami
# Fallback: git config user.email and git config user.name
```

Extract:
- Full email address (e.g., user@company.com)
- Username/handle (e.g., @username from email prefix)
- Display name for mention patterns

### Step 1: Gather Email Data
Use the Google Workspace CLI to retrieve recent emails:

```bash
# Get recent emails from inbox
gws gmail +triage

# For each relevant email, get full content
gws gmail +read --id <message_id>
```

Look for emails containing:
- User's name or email address in the body
- Assignment notifications (Jira, project tools)
- @mentions in email threads
- Meeting invites requiring response
- Review requests (GitLab, code review, documents)
- Follow-up items from conversations

### Step 2: Identify Action Items

For each email, extract:
- **Direct assignments** ("assigned to you", "please review", "need your input")
- **Mentions requiring response** (@[username], @[full_email], [display_name])
- **Deadlines and due dates** (explicit dates, "by Friday", "ASAP")
- **Pending decisions** ("waiting for your approval", "please confirm")
- **Meeting responses needed** (calendar invites, scheduling requests)

### Step 3: Categorize and Prioritize

Group items by:
- **Urgent** (explicit deadlines, escalations, blockers)
- **Important** (direct assignments, formal requests)
- **FYI/Review** (mentions in discussions, optional attendance)

### Step 4: Generate Summary

Create a structured report:

```markdown
# Action Items Summary - [Date]

## 🚨 Urgent (Immediate attention needed)
- [Item] - Source: [Email/System] - Due: [Deadline]

## 📋 Important (This week)
- [Item] - Source: [Email/System] - Context: [Brief description]

## 👀 For Review (When time permits)
- [Item] - Source: [Email/System]

## 📊 Summary
- Total items: X
- Urgent: X | Important: X | Review: X
- Oldest unaddressed: [Date]
```

## Parsing Specific Sources

### Jira Notifications
Look for:
- "assigned ED-XXXX to you"
- "mentioned you on ED-XXXX"  
- Ticket status changes requiring action
- Extract ticket number, title, priority

### GitLab Notifications  
Look for:
- Merge request assignments
- Code review requests
- Pipeline failures on your branches
- Extract MR number, project, status

### Calendar Invites
Look for:
- "awaiting response" 
- New meeting invites
- Time changes requiring acknowledgment
- Extract meeting title, date, organizer

### Email Threads
Look for:
- Direct @mentions (using detected username/email patterns)
- "Please review/approve/confirm"
- Questions directed at the user
- Follow-up requests
- CC/mentions of user's display name

## Time Filtering

By default, look at:
- Unread emails first (highest priority)
- Last 3 days of read emails
- Can be adjusted with user preferences

## Output Guidelines

- Lead with urgent items first
- Include enough context to understand the ask
- Provide direct links/IDs where possible
- Keep descriptions concise but actionable
- Highlight items that are blocking others

## Error Handling

If Gmail access fails:
- Inform the user about the issue
- Suggest alternative approaches (checking specific sources manually)
- Provide troubleshooting steps for re-authentication

## User Detection Patterns

After obtaining user identity in Step 0, create search patterns for:

### Email Patterns
- Full email: `user@company.com`
- Username variations: `@user`, `@username`
- Display name variations from email signature/profile

### Common Mention Formats
- Jira: `@First Last`, `@username`
- GitLab: `@username`, `(@username)`
- Email threads: `cc: @First Last`, `@user@company.com`
- Calendar: Attendee lists, organizer mentions

### Assignment Keywords
- "assigned to [user_name]"
- "assigned [ticket] to you"
- "[user] please review"
- "cc: [user_patterns]"
- "mentioned you on [item]"

## Implementation Notes

The skill should dynamically build regex patterns or search terms based on the detected user information rather than using hardcoded values. This ensures the skill works for any user without modification.

## Future Expansion Points

This skill is designed to easily expand to:
- Google Drive documents with @mentions
- Slack messages and threads  
- Confluence pages with mentions
- Other collaboration platforms

The core parsing and categorization logic can be reused across sources, with the user detection making it portable across different users and organizations.