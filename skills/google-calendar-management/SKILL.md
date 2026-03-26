---
name: google-calendar-management
description: Create, manage, update, and delete Google Calendar events. Supports recurring events, attendees, reminders, Google Meet links, free/busy queries, calendar management, access control, and special event types (out-of-office, focus time, working location) via the Google Calendar API v3. Use when creating calendar events, managing meeting schedules, setting up recurring events, querying free/busy times, or adding Google Meet links.
---

## Overview

Create, manage, update, and delete Google Calendar events with full support for recurring events, attendees, reminders, Google Meet video conferencing, free/busy scheduling, calendar management, access control, and special event types. This skill provides comprehensive coverage of the Google Calendar API v3.

📋 **API Reference**: [reference/api-reference.md](reference/api-reference.md)
🔁 **Recurring Events**: [reference/recurring-events.md](reference/recurring-events.md)
🔧 **Advanced Features**: [reference/advanced-features.md](reference/advanced-features.md)
💡 **Examples**: [examples/common-workflows.md](examples/common-workflows.md)

> **CLI alternative:** For command-line or MCP-based Calendar access, see the `google-workspace-cli` skill which provides `gws calendar` commands and an MCP server mode.

## Prerequisites

1. **Google OAuth 2.0 credentials** with the appropriate scope:
   - `https://www.googleapis.com/auth/calendar` — full read/write access (recommended)
   - `https://www.googleapis.com/auth/calendar.events` — events only (no calendar management)
   - `https://www.googleapis.com/auth/calendar.readonly` — read-only access
2. **Google Calendar API** enabled in your Google Cloud project
3. All scopes are classified as **sensitive** by Google and require OAuth consent screen verification for production use

## Authentication Setup

### OAuth 2.0 (Interactive / User-facing)

```python
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build

SCOPES = ["https://www.googleapis.com/auth/calendar"]

def get_calendar_service():
    flow = InstalledAppFlow.from_client_secrets_file("credentials.json", SCOPES)
    creds = flow.run_local_server(port=0)
    return build("calendar", "v3", credentials=creds)
```

### Service Account (Server-to-Server)

```python
from google.oauth2 import service_account
from googleapiclient.discovery import build

SCOPES = ["https://www.googleapis.com/auth/calendar"]

creds = service_account.Credentials.from_service_account_file(
    "service-account.json", scopes=SCOPES
)

# For domain-wide delegation (Google Workspace):
creds = creds.with_subject("user@yourdomain.com")

service = build("calendar", "v3", credentials=creds)
```

### Node.js

```javascript
const { google } = require("googleapis");

const auth = new google.auth.OAuth2(
    process.env.GOOGLE_CLIENT_ID,
    process.env.GOOGLE_CLIENT_SECRET,
    "YOUR_REDIRECT_URI"
);

auth.setCredentials({
    access_token: "YOUR_ACCESS_TOKEN",
    refresh_token: "YOUR_REFRESH_TOKEN"
});

const calendar = google.calendar({ version: "v3", auth });
```

## Core Workflow

See [references/core-workflow.md](references/core-workflow.md) for complete code examples covering:
- Creating events (with attendees, Google Meet, recurrence, reminders, colors)
- Listing and searching events (date ranges, queries, pagination)
- Updating events (full and partial updates)
- Deleting events and managing cancellations
- Recurring event management (RRULE patterns, exceptions)
- Free/busy queries and availability checks
- Calendar management (create, list, update, delete calendars)
- Access control and calendar sharing
- Special event types (out-of-office, focus time, working location)

```python
def create_event(service, summary, start, end, time_zone="America/Los_Angeles",
## Event Color Reference

| ID | Name | Use For |
|----|------|---------|
| 1 | Lavender | Low priority, personal |
| 2 | Sage | Green/nature themes |
| 3 | Grape | Creative, brainstorming |
| 4 | Flamingo | Social, fun events |
| 5 | Banana | Heads-up, warnings |
| 6 | Tangerine | Urgent, deadlines |
| 7 | Peacock | Team events |
| 8 | Graphite | Neutral, routine |
| 9 | Blueberry | Meetings, professional |
| 10 | Basil | Finance, budgets |
| 11 | Tomato | Critical, blocked time |

## Reminder Configuration

```python
# Use calendar default reminders
reminders = {"useDefault": True}

# Custom reminders
reminders = {
    "useDefault": False,
    "overrides": [
        {"method": "email", "minutes": 1440},   # 24 hours before
        {"method": "popup", "minutes": 30},      # 30 minutes before
        {"method": "popup", "minutes": 10},      # 10 minutes before
    ]
}
```

Supported methods: `email`, `popup`

Maximum 5 reminder overrides per event.

## Error Handling

```python
from googleapiclient.errors import HttpError

try:
    result = create_event(service, "Meeting", start, end)
except HttpError as error:
    status = error.resp.status
    if status == 401:
        print("Authentication expired. Refresh your OAuth token.")
    elif status == 403:
        print("Insufficient permissions. Check API scopes and calendar access.")
    elif status == 404:
        print("Event or calendar not found. Verify the ID.")
    elif status == 409:
        print("Conflict. The event may have been modified by another client.")
    elif status == 429:
        print("Rate limit exceeded. Implement exponential backoff.")
    else:
        print(f"API error {status}: {error}")
```

## Rate Limits and Quotas

| Quota | Limit |
|-------|-------|
| Queries per day | 1,000,000 |
| Queries per minute per user | 600 (approximately) |
| Calendar push notification channels | 10,000 per project |

**Best practices:**
- Batch multiple read operations where possible
- Use `singleEvents=True` with `orderBy=startTime` for listing recurring event instances
- Implement exponential backoff for 429 and 5xx errors
- Use `syncToken` for incremental sync instead of re-fetching all events
- Cache event data locally and use `updatedMin` for change detection
