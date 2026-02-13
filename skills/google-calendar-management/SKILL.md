---
name: google-calendar-management
description: Create, manage, update, and delete Google Calendar events. Supports recurring events, attendees, reminders, Google Meet links, free/busy queries, calendar management, access control, and special event types (out-of-office, focus time, working location) via the Google Calendar API v3.
---

## Overview

Create, manage, update, and delete Google Calendar events with full support for recurring events, attendees, reminders, Google Meet video conferencing, free/busy scheduling, calendar management, access control, and special event types. This skill provides comprehensive coverage of the Google Calendar API v3.

📋 **API Reference**: [reference/api-reference.md](reference/api-reference.md)
🔁 **Recurring Events**: [reference/recurring-events.md](reference/recurring-events.md)
🔧 **Advanced Features**: [reference/advanced-features.md](reference/advanced-features.md)
💡 **Examples**: [examples/common-workflows.md](examples/common-workflows.md)

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

### 1. Create an Event

```bash
google-calendar-management --action="create-event" \
  --summary="Team standup" \
  --start="2025-03-15T10:00:00-08:00" \
  --end="2025-03-15T10:30:00-08:00" \
  --time_zone="America/Los_Angeles" \
  --attendees='["alice@example.com", "bob@example.com"]' \
  --add_google_meet=true \
  --send_updates="all"
```

```python
def create_event(service, summary, start, end, time_zone="America/Los_Angeles",
                 description=None, location=None, attendees=None,
                 recurrence=None, reminders=None, color_id=None,
                 add_google_meet=False, send_updates="none"):
    """Create a calendar event with optional attendees, reminders, and Google Meet."""
    event = {
        "summary": summary,
        "start": {"dateTime": start, "timeZone": time_zone},
        "end": {"dateTime": end, "timeZone": time_zone},
    }

    if description:
        event["description"] = description
    if location:
        event["location"] = location
    if attendees:
        event["attendees"] = [{"email": email} for email in attendees]
    if recurrence:
        event["recurrence"] = recurrence
    if color_id:
        event["colorId"] = color_id

    if reminders:
        event["reminders"] = reminders
    else:
        event["reminders"] = {"useDefault": True}

    conference_data_version = 0
    if add_google_meet:
        import uuid
        event["conferenceData"] = {
            "createRequest": {
                "requestId": str(uuid.uuid4()),
                "conferenceSolutionKey": {"type": "hangoutsMeet"}
            }
        }
        conference_data_version = 1

    result = service.events().insert(
        calendarId="primary",
        body=event,
        sendUpdates=send_updates,
        conferenceDataVersion=conference_data_version
    ).execute()

    return {
        "id": result["id"],
        "url": result.get("htmlLink"),
        "meet_link": result.get("hangoutLink"),
        "status": result.get("status")
    }
```

### 2. Create an All-Day Event

```bash
google-calendar-management --action="create-event" \
  --summary="Company holiday" \
  --start="2025-07-04" \
  --end="2025-07-05"
```

```python
def create_all_day_event(service, summary, start_date, end_date, description=None):
    """Create an all-day event. End date is exclusive (2025-07-05 means through July 4)."""
    event = {
        "summary": summary,
        "start": {"date": start_date},
        "end": {"date": end_date},
    }
    if description:
        event["description"] = description

    result = service.events().insert(calendarId="primary", body=event).execute()
    return {"id": result["id"], "url": result.get("htmlLink")}
```

### 3. Quick Add (Natural Language)

```bash
google-calendar-management --action="quick-add" \
  --quick_add_text="Lunch with Sarah tomorrow at noon for 1 hour"
```

```python
def quick_add(service, text, calendar_id="primary"):
    """Create an event using natural language text."""
    result = service.events().quickAdd(
        calendarId=calendar_id,
        text=text
    ).execute()
    return {"id": result["id"], "url": result.get("htmlLink"), "summary": result.get("summary")}
```

### 4. List Events

```bash
google-calendar-management --action="list-events" \
  --time_min="2025-03-01T00:00:00Z" \
  --time_max="2025-03-31T23:59:59Z" \
  --max_results=25
```

```python
def list_events(service, time_min=None, time_max=None, max_results=10,
                calendar_id="primary", query=None):
    """List upcoming events with optional filters."""
    from datetime import datetime, timezone

    if not time_min:
        time_min = datetime.now(timezone.utc).isoformat()

    params = {
        "calendarId": calendar_id,
        "timeMin": time_min,
        "maxResults": max_results,
        "singleEvents": True,
        "orderBy": "startTime",
    }
    if time_max:
        params["timeMax"] = time_max
    if query:
        params["q"] = query

    result = service.events().list(**params).execute()
    events = result.get("items", [])

    return [
        {
            "id": e["id"],
            "summary": e.get("summary", "(No title)"),
            "start": e["start"].get("dateTime", e["start"].get("date")),
            "end": e["end"].get("dateTime", e["end"].get("date")),
            "location": e.get("location"),
            "attendees": len(e.get("attendees", [])),
            "meet_link": e.get("hangoutLink"),
            "status": e.get("status"),
        }
        for e in events
    ]
```

### 5. Get Event Details

```bash
google-calendar-management --action="get-event" --event_id="abc123"
```

```python
def get_event(service, event_id, calendar_id="primary"):
    """Get full details of a specific event."""
    event = service.events().get(calendarId=calendar_id, eventId=event_id).execute()
    return event
```

### 6. Update an Event

```bash
google-calendar-management --action="update-event" \
  --event_id="abc123" \
  --summary="Updated meeting title" \
  --location="Conference room B" \
  --send_updates="all"
```

```python
def update_event(service, event_id, updates, calendar_id="primary", send_updates="none"):
    """Update specific fields on an existing event."""
    event = service.events().get(calendarId=calendar_id, eventId=event_id).execute()

    for key, value in updates.items():
        if key in ("start", "end") and isinstance(value, str):
            if "T" in value:
                event[key] = {"dateTime": value, "timeZone": event[key].get("timeZone", "UTC")}
            else:
                event[key] = {"date": value}
        elif key == "attendees":
            event["attendees"] = [{"email": email} for email in value]
        else:
            event[key] = value

    result = service.events().update(
        calendarId=calendar_id,
        eventId=event_id,
        body=event,
        sendUpdates=send_updates
    ).execute()
    return {"id": result["id"], "url": result.get("htmlLink"), "updated": result.get("updated")}
```

### 7. Delete an Event

```bash
google-calendar-management --action="delete-event" \
  --event_id="abc123" \
  --send_updates="all"
```

```python
def delete_event(service, event_id, calendar_id="primary", send_updates="none"):
    """Delete an event. Optionally notify attendees."""
    service.events().delete(
        calendarId=calendar_id,
        eventId=event_id,
        sendUpdates=send_updates
    ).execute()
    return {"deleted": True, "event_id": event_id}
```

### 8. Create a Recurring Event

```bash
google-calendar-management --action="create-event" \
  --summary="Weekly standup" \
  --start="2025-03-17T09:00:00-08:00" \
  --end="2025-03-17T09:30:00-08:00" \
  --recurrence='["RRULE:FREQ=WEEKLY;BYDAY=MO;COUNT=12"]' \
  --attendees='["team@example.com"]'
```

→ **Full RRULE reference**: [reference/recurring-events.md](reference/recurring-events.md)

### 9. Create Event with Google Meet

```bash
google-calendar-management --action="create-event" \
  --summary="Design review" \
  --start="2025-03-20T14:00:00-08:00" \
  --end="2025-03-20T15:00:00-08:00" \
  --add_google_meet=true
```

The response will include a `meet_link` field with the generated Google Meet URL.

### 10. Create Out-of-Office Event

```bash
google-calendar-management --action="create-event" \
  --summary="Vacation" \
  --start="2025-06-01" \
  --end="2025-06-08" \
  --event_type="outOfOffice"
```

```python
def create_out_of_office(service, summary, start_date, end_date, decline_message=None):
    """Create an out-of-office event that auto-declines invitations."""
    event = {
        "summary": summary,
        "start": {"date": start_date},
        "end": {"date": end_date},
        "eventType": "outOfOffice",
        "outOfOfficeProperties": {
            "autoDeclineMode": "declineAllConflictingInvitations",
            "declineMessage": decline_message or f"I'm out of office: {summary}"
        }
    }
    result = service.events().insert(calendarId="primary", body=event).execute()
    return {"id": result["id"], "url": result.get("htmlLink")}
```

### 11. Create Focus Time Event

```python
def create_focus_time(service, summary, start, end, time_zone="America/Los_Angeles"):
    """Create a focus time block that auto-declines new meetings."""
    event = {
        "summary": summary,
        "start": {"dateTime": start, "timeZone": time_zone},
        "end": {"dateTime": end, "timeZone": time_zone},
        "eventType": "focusTime",
        "focusTimeProperties": {
            "autoDeclineMode": "declineOnlyNewConflictingInvitations",
            "declineMessage": "I'm in a focus time block."
        }
    }
    result = service.events().insert(calendarId="primary", body=event).execute()
    return {"id": result["id"], "url": result.get("htmlLink")}
```

### 12. Create Working Location Event

```python
def create_working_location(service, date, location_type="homeOffice",
                            office_name=None):
    """Set working location for a day (home, office, or custom)."""
    event = {
        "summary": f"Working from {'home' if location_type == 'homeOffice' else 'office'}",
        "start": {"date": date},
        "end": {"date": date},
        "eventType": "workingLocation",
        "workingLocationProperties": {
            "type": location_type  # "homeOffice", "officeLocation", "customLocation"
        }
    }
    if location_type == "officeLocation" and office_name:
        event["workingLocationProperties"]["officeLocation"] = {"label": office_name}
    elif location_type == "customLocation" and office_name:
        event["workingLocationProperties"]["customLocation"] = {"label": office_name}

    result = service.events().insert(calendarId="primary", body=event).execute()
    return {"id": result["id"], "url": result.get("htmlLink")}
```

### 13. Free/Busy Query

```bash
google-calendar-management --action="free-busy" \
  --time_min="2025-03-15T09:00:00Z" \
  --time_max="2025-03-15T17:00:00Z"
```

```python
def query_free_busy(service, time_min, time_max, calendar_ids=None):
    """Check availability for one or more calendars."""
    if not calendar_ids:
        calendar_ids = ["primary"]

    body = {
        "timeMin": time_min,
        "timeMax": time_max,
        "items": [{"id": cid} for cid in calendar_ids]
    }

    result = service.freebusy().query(body=body).execute()
    return result.get("calendars", {})
```

### 14. Move Event to Another Calendar

```python
def move_event(service, event_id, source_calendar, destination_calendar,
               send_updates="none"):
    """Move an event from one calendar to another."""
    result = service.events().move(
        calendarId=source_calendar,
        eventId=event_id,
        destination=destination_calendar,
        sendUpdates=send_updates
    ).execute()
    return {"id": result["id"], "url": result.get("htmlLink")}
```

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
