# Advanced Features

## Google Meet Conference Links

### Create Event with Google Meet

```python
import uuid

def create_event_with_meet(service, summary, start, end, time_zone="America/Los_Angeles"):
    """Create an event with an automatically generated Google Meet link."""
    event = {
        "summary": summary,
        "start": {"dateTime": start, "timeZone": time_zone},
        "end": {"dateTime": end, "timeZone": time_zone},
        "conferenceData": {
            "createRequest": {
                "requestId": str(uuid.uuid4()),
                "conferenceSolutionKey": {"type": "hangoutsMeet"}
            }
        }
    }

    result = service.events().insert(
        calendarId="primary",
        body=event,
        conferenceDataVersion=1  # Required for conference data
    ).execute()

    return {
        "id": result["id"],
        "meet_link": result.get("hangoutLink"),
        "conference_id": result.get("conferenceData", {}).get("conferenceId"),
        "entry_points": result.get("conferenceData", {}).get("entryPoints", [])
    }
```

### Conference Data Response Structure

```json
{
  "conferenceData": {
    "conferenceId": "abc-defg-hij",
    "conferenceSolution": {
      "name": "Google Meet",
      "iconUri": "https://...",
      "key": {"type": "hangoutsMeet"}
    },
    "entryPoints": [
      {
        "entryPointType": "video",
        "uri": "https://meet.google.com/abc-defg-hij",
        "label": "meet.google.com/abc-defg-hij"
      },
      {
        "entryPointType": "phone",
        "uri": "tel:+1-234-567-8900",
        "pin": "123456789",
        "regionCode": "US"
      },
      {
        "entryPointType": "more",
        "uri": "https://tel.meet/abc-defg-hij?pin=123456789"
      }
    ],
    "createRequest": {
      "requestId": "your-uuid",
      "conferenceSolutionKey": {"type": "hangoutsMeet"},
      "status": {"statusCode": "success"}
    }
  }
}
```

### Conference Solution Types

| Type | Description |
|------|-------------|
| `hangoutsMeet` | Google Meet (current, recommended) |
| `eventHangout` | Classic Hangouts (deprecated) |
| `eventNamedHangout` | Named Hangouts (deprecated) |
| `addOn` | Third-party conference provider |

### Remove Google Meet from Event

```python
def remove_meet(service, event_id):
    """Remove conference data from an existing event."""
    event = service.events().get(calendarId="primary", eventId=event_id).execute()

    if "conferenceData" in event:
        del event["conferenceData"]

    service.events().update(
        calendarId="primary",
        eventId=event_id,
        body=event,
        conferenceDataVersion=1
    ).execute()
```

## Special Event Types

### Out of Office

```python
def create_out_of_office(service, summary, start_date, end_date,
                         decline_message="I'm out of office."):
    """Create an out-of-office event that auto-declines meeting invitations."""
    event = {
        "summary": summary,
        "start": {"date": start_date},
        "end": {"date": end_date},  # Exclusive end date
        "eventType": "outOfOffice",
        "outOfOfficeProperties": {
            "autoDeclineMode": "declineAllConflictingInvitations",
            # Options: "declineNone", "declineAllConflictingInvitations",
            #          "declineOnlyNewConflictingInvitations"
            "declineMessage": decline_message
        },
        "transparency": "opaque",
        "visibility": "public"
    }

    return service.events().insert(calendarId="primary", body=event).execute()
```

### Focus Time

```python
def create_focus_time(service, summary, start, end, time_zone="America/Los_Angeles",
                      decline_message="I'm in a focus time block."):
    """Create a focus time block that automatically declines new invitations."""
    event = {
        "summary": summary,
        "start": {"dateTime": start, "timeZone": time_zone},
        "end": {"dateTime": end, "timeZone": time_zone},
        "eventType": "focusTime",
        "focusTimeProperties": {
            "autoDeclineMode": "declineOnlyNewConflictingInvitations",
            "declineMessage": decline_message,
            "chatStatus": "doNotDisturb"  # Sets Chat to DND
        },
        "colorId": "8",  # Graphite — subtle
        "transparency": "opaque"
    }

    return service.events().insert(calendarId="primary", body=event).execute()
```

### Working Location

```python
def set_working_location(service, date, location_type, label=None, building_id=None):
    """Set where you're working from for a specific day.

    Args:
        location_type: "homeOffice", "officeLocation", or "customLocation"
        label: Human-readable name (e.g., "Downtown Office", "Client Site")
        building_id: Google Workspace building ID (for officeLocation)
    """
    event = {
        "start": {"date": date},
        "end": {"date": date},
        "eventType": "workingLocation",
        "visibility": "public",
        "transparency": "transparent",  # Doesn't block the time
    }

    wl_props = {"type": location_type}

    if location_type == "homeOffice":
        event["summary"] = "Working from home"
    elif location_type == "officeLocation":
        event["summary"] = f"Working from {label or 'office'}"
        wl_props["officeLocation"] = {}
        if label:
            wl_props["officeLocation"]["label"] = label
        if building_id:
            wl_props["officeLocation"]["buildingId"] = building_id
    elif location_type == "customLocation":
        event["summary"] = f"Working from {label or 'custom location'}"
        if label:
            wl_props["customLocation"] = {"label": label}

    event["workingLocationProperties"] = wl_props

    return service.events().insert(calendarId="primary", body=event).execute()
```

### Filter Events by Type

```python
# List only out-of-office events
ooo_events = service.events().list(
    calendarId="primary",
    eventTypes=["outOfOffice"],
    timeMin="2025-01-01T00:00:00Z",
    timeMax="2025-12-31T23:59:59Z",
    singleEvents=True
).execute()

# List only focus time events
focus_events = service.events().list(
    calendarId="primary",
    eventTypes=["focusTime"],
    singleEvents=True
).execute()
```

## Free/Busy Queries

### Check Multiple Calendars

```python
def find_available_slots(service, calendar_ids, date, start_hour=9, end_hour=17,
                         time_zone="America/Los_Angeles"):
    """Find available time slots across multiple calendars."""
    import pytz
    from datetime import datetime, timedelta

    tz = pytz.timezone(time_zone)
    day_start = tz.localize(datetime.strptime(f"{date} {start_hour:02d}:00:00", "%Y-%m-%d %H:%M:%S"))
    day_end = tz.localize(datetime.strptime(f"{date} {end_hour:02d}:00:00", "%Y-%m-%d %H:%M:%S"))

    body = {
        "timeMin": day_start.isoformat(),
        "timeMax": day_end.isoformat(),
        "timeZone": time_zone,
        "items": [{"id": cal_id} for cal_id in calendar_ids]
    }

    result = service.freebusy().query(body=body).execute()

    # Collect all busy times
    all_busy = []
    for cal_id, data in result.get("calendars", {}).items():
        for slot in data.get("busy", []):
            all_busy.append((slot["start"], slot["end"]))

    # Sort busy times
    all_busy.sort()

    # Find free slots (gaps between busy times)
    free_slots = []
    current = day_start.isoformat()
    for busy_start, busy_end in all_busy:
        if busy_start > current:
            free_slots.append({"start": current, "end": busy_start})
        current = max(current, busy_end)
    if current < day_end.isoformat():
        free_slots.append({"start": current, "end": day_end.isoformat()})

    return free_slots
```

### Suggest Meeting Times

```python
def suggest_meeting_time(service, attendee_emails, duration_minutes,
                         search_days=5, start_hour=9, end_hour=17):
    """Find the next available slot that works for all attendees."""
    from datetime import datetime, timedelta, timezone

    calendar_ids = ["primary"] + attendee_emails

    for day_offset in range(search_days):
        check_date = (datetime.now(timezone.utc) + timedelta(days=day_offset + 1))
        date_str = check_date.strftime("%Y-%m-%d")

        free_slots = find_available_slots(
            service, calendar_ids, date_str, start_hour, end_hour
        )

        for slot in free_slots:
            slot_start = datetime.fromisoformat(slot["start"])
            slot_end = datetime.fromisoformat(slot["end"])
            slot_duration = (slot_end - slot_start).total_seconds() / 60

            if slot_duration >= duration_minutes:
                meeting_end = slot_start + timedelta(minutes=duration_minutes)
                return {
                    "date": date_str,
                    "start": slot_start.isoformat(),
                    "end": meeting_end.isoformat(),
                    "available_for": f"{int(slot_duration)} minutes"
                }

    return None  # No suitable time found
```

## Calendar Management

### Create a Shared Calendar

```python
def create_shared_calendar(service, name, description, share_with):
    """Create a calendar and share it with team members.

    Args:
        share_with: dict of {email: role} pairs, e.g., {"alice@co.com": "writer"}
    """
    # Create the calendar
    calendar = service.calendars().insert(body={
        "summary": name,
        "description": description,
        "timeZone": "America/Los_Angeles"
    }).execute()

    cal_id = calendar["id"]

    # Share with each person
    for email, role in share_with.items():
        service.acl().insert(
            calendarId=cal_id,
            body={
                "scope": {"type": "user", "value": email},
                "role": role  # "reader", "writer", "owner"
            },
            sendNotifications=True
        ).execute()

    return {"id": cal_id, "summary": name}
```

### List All Calendars with Access Roles

```python
def list_all_calendars(service):
    """List all calendars the user has access to."""
    result = service.calendarList().list().execute()

    calendars = []
    for cal in result.get("items", []):
        calendars.append({
            "id": cal["id"],
            "summary": cal.get("summary"),
            "description": cal.get("description"),
            "access_role": cal.get("accessRole"),
            "primary": cal.get("primary", False),
            "color": cal.get("backgroundColor"),
            "time_zone": cal.get("timeZone"),
            "hidden": cal.get("hidden", False)
        })

    return calendars
```

## Event Colors

### Color ID Reference

| ID | Name | Hex (background) |
|----|------|-------------------|
| 1 | Lavender | `#7986CB` |
| 2 | Sage | `#33B679` |
| 3 | Grape | `#8E24AA` |
| 4 | Flamingo | `#E67C73` |
| 5 | Banana | `#F6BF26` |
| 6 | Tangerine | `#F4511E` |
| 7 | Peacock | `#039BE5` |
| 8 | Graphite | `#616161` |
| 9 | Blueberry | `#3F51B5` |
| 10 | Basil | `#0B8043` |
| 11 | Tomato | `#D50000` |

### Set Event Color

```python
# Set color when creating
event = {
    "summary": "Urgent deadline",
    "colorId": "11",  # Tomato (red)
    "start": {"dateTime": "2025-03-15T10:00:00-08:00"},
    "end": {"dateTime": "2025-03-15T11:00:00-08:00"}
}

# Update color on existing event
service.events().patch(
    calendarId="primary",
    eventId="event_id",
    body={"colorId": "7"}  # Peacock (blue)
).execute()
```

## Extended Properties

Store custom key-value data on events:

```python
# Private properties (visible only to the app that set them)
event["extendedProperties"] = {
    "private": {
        "appEventId": "12345",
        "syncedFrom": "salesforce"
    }
}

# Shared properties (visible to all apps with access)
event["extendedProperties"] = {
    "shared": {
        "projectId": "proj-alpha",
        "priority": "high"
    }
}

# Query events by extended property
events = service.events().list(
    calendarId="primary",
    privateExtendedProperty="syncedFrom=salesforce"
).execute()
```

## Push Notifications (Webhooks)

### Set Up Watch Channel

```python
def setup_event_watch(service, calendar_id, webhook_url, channel_id=None):
    """Watch for changes to calendar events."""
    import uuid

    body = {
        "id": channel_id or str(uuid.uuid4()),
        "type": "web_hook",
        "address": webhook_url,
        "token": "optional-verification-token"
    }

    result = service.events().watch(calendarId=calendar_id, body=body).execute()
    return {
        "channel_id": result["id"],
        "resource_id": result["resourceId"],
        "expiration": result.get("expiration")  # Unix timestamp in ms
    }
```

### Stop Watch Channel

```python
def stop_watch(service, channel_id, resource_id):
    """Stop receiving push notifications."""
    service.channels().stop(body={
        "id": channel_id,
        "resourceId": resource_id
    }).execute()
```

### Webhook Payload

When an event changes, Google sends a POST to your webhook URL with headers:

| Header | Description |
|--------|-------------|
| `X-Goog-Channel-ID` | Your channel ID |
| `X-Goog-Resource-ID` | Google's resource identifier |
| `X-Goog-Resource-State` | "sync" (initial) or "exists" (change detected) |
| `X-Goog-Message-Number` | Incrementing message counter |
| `X-Goog-Channel-Token` | Your verification token |

**Note:** The webhook body is empty. You must call `events.list` with a `syncToken` to find what changed.

## Incremental Sync

### Initial Sync

```python
def initial_sync(service, calendar_id="primary"):
    """Perform initial full sync and store the sync token."""
    all_events = []
    page_token = None

    while True:
        result = service.events().list(
            calendarId=calendar_id,
            pageToken=page_token
        ).execute()

        all_events.extend(result.get("items", []))
        page_token = result.get("nextPageToken")

        if not page_token:
            break

    sync_token = result.get("nextSyncToken")
    return all_events, sync_token
```

### Incremental Sync

```python
def incremental_sync(service, sync_token, calendar_id="primary"):
    """Fetch only changes since the last sync."""
    try:
        result = service.events().list(
            calendarId=calendar_id,
            syncToken=sync_token
        ).execute()

        changed_events = result.get("items", [])
        new_sync_token = result.get("nextSyncToken")
        return changed_events, new_sync_token

    except Exception as e:
        if "410" in str(e):
            # Sync token expired — do a full re-sync
            return initial_sync(service, calendar_id)
        raise
```

## Event Attachments

Attach Google Drive files to events:

```python
event = {
    "summary": "Project Review",
    "start": {"dateTime": "2025-03-15T14:00:00-08:00"},
    "end": {"dateTime": "2025-03-15T15:00:00-08:00"},
    "attachments": [
        {
            "fileUrl": "https://drive.google.com/file/d/FILE_ID/view",
            "title": "Project Plan",
            "mimeType": "application/pdf"
        },
        {
            "fileUrl": "https://docs.google.com/document/d/DOC_ID/edit",
            "title": "Meeting Agenda"
        }
    ]
}

service.events().insert(
    calendarId="primary",
    body=event,
    supportsAttachments=True  # Required for attachments
).execute()
```
