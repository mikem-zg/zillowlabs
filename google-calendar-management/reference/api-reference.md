# Google Calendar API v3 Reference

## API Base URL

```
https://www.googleapis.com/calendar/v3
```

## OAuth Scopes

| Scope | Access Level | Sensitive |
|-------|-------------|-----------|
| `https://www.googleapis.com/auth/calendar` | Full read/write to all calendars and events | Yes |
| `https://www.googleapis.com/auth/calendar.events` | Read/write events only (no calendar management) | Yes |
| `https://www.googleapis.com/auth/calendar.events.readonly` | Read-only events | Yes |
| `https://www.googleapis.com/auth/calendar.readonly` | Read-only all calendars | Yes |
| `https://www.googleapis.com/auth/calendar.settings.readonly` | Read calendar settings | No |
| `https://www.googleapis.com/auth/calendar.addons.execute` | Add-on execution | No |

## Events API

### events.insert — Create Event

```
POST /calendar/v3/calendars/{calendarId}/events
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `calendarId` | string (path) | Calendar ID ("primary" for default) |
| `sendUpdates` | string (query) | "all", "externalOnly", "none" |
| `conferenceDataVersion` | integer (query) | 0 or 1 (set to 1 for Google Meet) |
| `maxAttendees` | integer (query) | Max attendees to include in response |
| `supportsAttachments` | boolean (query) | Whether API client supports attachments |

**Request body (Event resource):**

```json
{
  "summary": "Event title",
  "description": "Event description (supports HTML)",
  "location": "123 Main St, City, State",
  "start": {
    "dateTime": "2025-03-15T10:00:00-08:00",
    "timeZone": "America/Los_Angeles"
  },
  "end": {
    "dateTime": "2025-03-15T11:00:00-08:00",
    "timeZone": "America/Los_Angeles"
  },
  "attendees": [
    {"email": "user@example.com", "optional": false},
    {"email": "optional@example.com", "optional": true}
  ],
  "recurrence": ["RRULE:FREQ=WEEKLY;BYDAY=MO;COUNT=10"],
  "reminders": {
    "useDefault": false,
    "overrides": [
      {"method": "popup", "minutes": 10},
      {"method": "email", "minutes": 1440}
    ]
  },
  "colorId": "9",
  "visibility": "default",
  "transparency": "opaque",
  "guestsCanModify": false,
  "guestsCanInviteOthers": true,
  "guestsCanSeeOtherGuests": true,
  "conferenceData": {
    "createRequest": {
      "requestId": "unique-uuid",
      "conferenceSolutionKey": {"type": "hangoutsMeet"}
    }
  },
  "source": {
    "title": "Source App Name",
    "url": "https://your-app.com/event/123"
  },
  "attachments": [
    {
      "fileUrl": "https://drive.google.com/file/d/xxx",
      "title": "Agenda"
    }
  ]
}
```

### events.list — List Events

```
GET /calendar/v3/calendars/{calendarId}/events
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `timeMin` | datetime | Lower bound (inclusive) for event start |
| `timeMax` | datetime | Upper bound (exclusive) for event end |
| `maxResults` | integer | Max events to return (default 250, max 2500) |
| `singleEvents` | boolean | Expand recurring events into instances |
| `orderBy` | string | "startTime" (requires singleEvents=true) or "updated" |
| `q` | string | Free text search across summary, description, location |
| `showDeleted` | boolean | Include cancelled events |
| `showHiddenInvitations` | boolean | Include hidden invitations |
| `updatedMin` | datetime | Only events updated after this time |
| `syncToken` | string | Token for incremental sync |
| `pageToken` | string | Pagination token |
| `eventTypes` | string | Filter by type: "default", "outOfOffice", "focusTime", "workingLocation" |
| `iCalUID` | string | Filter by iCalendar UID |
| `privateExtendedProperty` | string | Filter by private extended property |
| `sharedExtendedProperty` | string | Filter by shared extended property |

### events.get — Get Single Event

```
GET /calendar/v3/calendars/{calendarId}/events/{eventId}
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `alwaysIncludeEmail` | boolean | Include attendee emails even if no Google profile |
| `maxAttendees` | integer | Max attendees to include |

### events.update — Full Update

```
PUT /calendar/v3/calendars/{calendarId}/events/{eventId}
```

Replaces the entire event resource. Fetch the event first, modify fields, then send back.

### events.patch — Partial Update

```
PATCH /calendar/v3/calendars/{calendarId}/events/{eventId}
```

Updates only the specified fields. More efficient than `update` — only send the changed fields.

```python
# Partial update - only change summary and location
service.events().patch(
    calendarId="primary",
    eventId="event_id",
    body={
        "summary": "New title",
        "location": "New location"
    },
    sendUpdates="all"
).execute()
```

### events.delete — Delete Event

```
DELETE /calendar/v3/calendars/{calendarId}/events/{eventId}
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `sendUpdates` | string | "all", "externalOnly", "none" |

### events.quickAdd — Natural Language Create

```
POST /calendar/v3/calendars/{calendarId}/events/quickAdd
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `text` | string (query) | Natural language event description |
| `sendUpdates` | string (query) | Notification setting |

```python
service.events().quickAdd(
    calendarId="primary",
    text="Meeting with Alice at 3pm tomorrow at Coffee Shop"
).execute()
```

### events.move — Move to Another Calendar

```
POST /calendar/v3/calendars/{calendarId}/events/{eventId}/move
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `destination` | string (query) | Target calendar ID |
| `sendUpdates` | string (query) | Notification setting |

### events.instances — List Recurring Event Instances

```
GET /calendar/v3/calendars/{calendarId}/events/{eventId}/instances
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `timeMin` | datetime | Filter instances starting after this time |
| `timeMax` | datetime | Filter instances starting before this time |
| `maxResults` | integer | Max instances to return |

### events.import — Import Event

```
POST /calendar/v3/calendars/{calendarId}/events/import
```

Import an event with a known iCalendar UID. Does not send notifications. Useful for sync scenarios.

### events.watch — Push Notifications

```
POST /calendar/v3/calendars/{calendarId}/events/watch
```

Set up push notifications for event changes.

```python
watch_body = {
    "id": "unique-channel-id",
    "type": "web_hook",
    "address": "https://your-domain.com/webhook/calendar",
    "token": "verification-token",
    "expiration": 1710000000000  # Unix timestamp in ms
}

service.events().watch(calendarId="primary", body=watch_body).execute()
```

**Note:** Webhook channels expire. Max lifetime is about 24 hours. Renew with a cron job.

## Calendars API

### calendars.insert — Create Calendar

```
POST /calendar/v3/calendars
```

```python
calendar = {
    "summary": "Project Alpha",
    "description": "Calendar for Project Alpha team",
    "timeZone": "America/Los_Angeles"
}
service.calendars().insert(body=calendar).execute()
```

### calendars.get — Get Calendar

```
GET /calendar/v3/calendars/{calendarId}
```

### calendars.update / calendars.patch — Update Calendar

```
PUT /calendar/v3/calendars/{calendarId}
PATCH /calendar/v3/calendars/{calendarId}
```

### calendars.delete — Delete Calendar

```
DELETE /calendar/v3/calendars/{calendarId}
```

### calendars.clear — Clear Primary Calendar

```
POST /calendar/v3/calendars/{calendarId}/clear
```

Removes all events from the primary calendar. **Destructive operation.**

## CalendarList API

Manages the user's list of calendars (the sidebar in Google Calendar).

### calendarList.list — List User's Calendars

```
GET /calendar/v3/users/me/calendarList
```

```python
calendar_list = service.calendarList().list().execute()
for cal in calendar_list["items"]:
    print(f"{cal['summary']} ({cal['id']}) — role: {cal['accessRole']}")
```

### calendarList.insert — Subscribe to Calendar

```
POST /calendar/v3/users/me/calendarList
```

### calendarList.delete — Unsubscribe from Calendar

```
DELETE /calendar/v3/users/me/calendarList/{calendarId}
```

## FreeBusy API

### freebusy.query — Check Availability

```
POST /calendar/v3/freeBusy
```

```python
body = {
    "timeMin": "2025-03-15T09:00:00Z",
    "timeMax": "2025-03-15T17:00:00Z",
    "timeZone": "America/Los_Angeles",
    "items": [
        {"id": "primary"},
        {"id": "colleague@example.com"}
    ]
}

result = service.freebusy().query(body=body).execute()

for cal_id, data in result["calendars"].items():
    busy_times = data.get("busy", [])
    if busy_times:
        for slot in busy_times:
            print(f"{cal_id}: busy {slot['start']} to {slot['end']}")
    else:
        print(f"{cal_id}: free all day")
```

## ACL API (Access Control)

### acl.list — List ACL Rules

```
GET /calendar/v3/calendars/{calendarId}/acl
```

### acl.insert — Add ACL Rule

```
POST /calendar/v3/calendars/{calendarId}/acl
```

| Role | Description |
|------|-------------|
| `freeBusyReader` | See free/busy only |
| `reader` | View all event details |
| `writer` | Modify events |
| `owner` | Full control |

| Scope Type | Description |
|------------|-------------|
| `user` | Individual email |
| `group` | Google Group |
| `domain` | Entire domain |
| `default` | Public access |

```python
rule = {
    "scope": {"type": "user", "value": "colleague@example.com"},
    "role": "writer"
}
service.acl().insert(calendarId="calendar_id", body=rule).execute()
```

### acl.update / acl.patch — Update ACL Rule

```
PUT /calendar/v3/calendars/{calendarId}/acl/{ruleId}
PATCH /calendar/v3/calendars/{calendarId}/acl/{ruleId}
```

### acl.delete — Remove ACL Rule

```
DELETE /calendar/v3/calendars/{calendarId}/acl/{ruleId}
```

## Colors API

### colors.get — Get Color Definitions

```
GET /calendar/v3/colors
```

Returns both event and calendar color definitions.

```python
colors = service.colors().get().execute()

# Event colors (IDs 1-11)
for color_id, color_data in colors["event"].items():
    print(f"Event {color_id}: bg={color_data['background']} fg={color_data['foreground']}")

# Calendar colors (IDs 1-24)
for color_id, color_data in colors["calendar"].items():
    print(f"Calendar {color_id}: bg={color_data['background']} fg={color_data['foreground']}")
```

## Event Resource — Full Field Reference

| Field | Type | Read/Write | Description |
|-------|------|-----------|-------------|
| `id` | string | Read | Unique event identifier |
| `summary` | string | R/W | Event title |
| `description` | string | R/W | Description (supports HTML) |
| `location` | string | R/W | Location text |
| `start` | object | R/W | Start time/date |
| `end` | object | R/W | End time/date |
| `attendees` | array | R/W | List of attendee objects |
| `recurrence` | array | R/W | RRULE strings |
| `reminders` | object | R/W | Reminder configuration |
| `colorId` | string | R/W | Event color (1-11) |
| `status` | string | R/W | "confirmed", "tentative", "cancelled" |
| `visibility` | string | R/W | "default", "public", "private", "confidential" |
| `transparency` | string | R/W | "opaque" (busy) or "transparent" (free) |
| `htmlLink` | string | Read | URL to view event in Calendar |
| `hangoutLink` | string | Read | Google Meet URL |
| `conferenceData` | object | R/W | Conference/meeting details |
| `creator` | object | Read | Event creator |
| `organizer` | object | Read | Event organizer |
| `created` | datetime | Read | Creation timestamp |
| `updated` | datetime | Read | Last modification timestamp |
| `iCalUID` | string | Read | iCalendar UID |
| `sequence` | integer | R/W | Revision sequence number |
| `eventType` | string | R/W | "default", "outOfOffice", "focusTime", "workingLocation" |
| `extendedProperties` | object | R/W | Custom key-value pairs (private/shared) |
| `attachments` | array | R/W | File attachments |
| `source` | object | R/W | Source application info |
| `guestsCanModify` | boolean | R/W | Allow guests to edit |
| `guestsCanInviteOthers` | boolean | R/W | Allow guests to invite |
| `guestsCanSeeOtherGuests` | boolean | R/W | Allow guests to see attendee list |

## Attendee Object

| Field | Type | Description |
|-------|------|-------------|
| `email` | string | Attendee email (required) |
| `displayName` | string | Display name |
| `optional` | boolean | Whether attendance is optional |
| `responseStatus` | string | "needsAction", "accepted", "declined", "tentative" |
| `comment` | string | Attendee's response comment |
| `resource` | boolean | Whether this is a resource (room) |
| `self` | boolean | Whether this is the authenticated user |
| `organizer` | boolean | Whether this attendee is the organizer |
| `additionalGuests` | integer | Number of additional guests |

## HTTP Status Codes

| Code | Meaning | Action |
|------|---------|--------|
| 200 | Success | — |
| 201 | Created | Event was created |
| 204 | No Content | Event was deleted |
| 400 | Bad Request | Check request body syntax |
| 401 | Unauthorized | Refresh OAuth token |
| 403 | Forbidden | Check scopes and permissions |
| 404 | Not Found | Check event/calendar ID |
| 409 | Conflict | Event was modified concurrently |
| 410 | Gone | Sync token is invalid; do full re-sync |
| 429 | Too Many Requests | Exponential backoff |
| 500/503 | Server Error | Retry with backoff |
