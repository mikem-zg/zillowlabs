# Common Workflows

## Workflow 1: Schedule a Team Meeting with Google Meet

End-to-end: create a meeting, add attendees, generate a Google Meet link, and send invitations.

```python
import uuid
from googleapiclient.discovery import build

def schedule_team_meeting(service, title, start, end, attendee_emails,
                          description=None, time_zone="America/Los_Angeles"):
    """Schedule a meeting with Google Meet for the whole team."""
    event = {
        "summary": title,
        "description": description or f"Team meeting: {title}",
        "start": {"dateTime": start, "timeZone": time_zone},
        "end": {"dateTime": end, "timeZone": time_zone},
        "attendees": [{"email": email} for email in attendee_emails],
        "conferenceData": {
            "createRequest": {
                "requestId": str(uuid.uuid4()),
                "conferenceSolutionKey": {"type": "hangoutsMeet"}
            }
        },
        "reminders": {
            "useDefault": False,
            "overrides": [
                {"method": "popup", "minutes": 10},
                {"method": "email", "minutes": 60}
            ]
        },
        "guestsCanInviteOthers": True,
        "guestsCanSeeOtherGuests": True,
    }

    result = service.events().insert(
        calendarId="primary",
        body=event,
        conferenceDataVersion=1,
        sendUpdates="all"
    ).execute()

    print(f"Meeting created: {result.get('htmlLink')}")
    print(f"Google Meet link: {result.get('hangoutLink')}")

    return result

# Usage
schedule_team_meeting(
    service,
    title="Sprint Planning",
    start="2025-03-17T10:00:00-08:00",
    end="2025-03-17T11:00:00-08:00",
    attendee_emails=["alice@example.com", "bob@example.com", "carol@example.com"],
    description="Q2 sprint planning session. Please review the backlog before the meeting."
)
```

## Workflow 2: Set Up a Recurring 1:1

```python
def create_recurring_one_on_one(service, manager_email, report_email,
                                 day_of_week="TH", start_time="14:00",
                                 duration_minutes=30, weeks=12):
    """Create a recurring weekly 1:1 meeting."""
    import uuid

    start = f"2025-03-20T{start_time}:00-08:00"  # First occurrence
    hour, minute = map(int, start_time.split(":"))
    end_minute = minute + duration_minutes
    end_hour = hour + end_minute // 60
    end_minute = end_minute % 60
    end = f"2025-03-20T{end_hour:02d}:{end_minute:02d}:00-08:00"

    event = {
        "summary": f"1:1 — {manager_email.split('@')[0]} / {report_email.split('@')[0]}",
        "start": {"dateTime": start, "timeZone": "America/Los_Angeles"},
        "end": {"dateTime": end, "timeZone": "America/Los_Angeles"},
        "recurrence": [f"RRULE:FREQ=WEEKLY;BYDAY={day_of_week};COUNT={weeks}"],
        "attendees": [
            {"email": manager_email},
            {"email": report_email}
        ],
        "conferenceData": {
            "createRequest": {
                "requestId": str(uuid.uuid4()),
                "conferenceSolutionKey": {"type": "hangoutsMeet"}
            }
        },
        "reminders": {
            "useDefault": False,
            "overrides": [{"method": "popup", "minutes": 5}]
        }
    }

    result = service.events().insert(
        calendarId="primary",
        body=event,
        conferenceDataVersion=1,
        sendUpdates="all"
    ).execute()

    return result

# Usage
create_recurring_one_on_one(
    service,
    manager_email="manager@example.com",
    report_email="report@example.com",
    day_of_week="TH",
    start_time="14:00",
    duration_minutes=30,
    weeks=12
)
```

## Workflow 3: Daily Agenda Report

```python
from datetime import datetime, timedelta, timezone

def get_daily_agenda(service, date=None, calendar_id="primary"):
    """Get today's agenda with all event details."""
    if not date:
        date = datetime.now(timezone.utc).strftime("%Y-%m-%d")

    time_min = f"{date}T00:00:00Z"
    time_max = f"{date}T23:59:59Z"

    result = service.events().list(
        calendarId=calendar_id,
        timeMin=time_min,
        timeMax=time_max,
        singleEvents=True,
        orderBy="startTime"
    ).execute()

    events = result.get("items", [])
    agenda = []

    for event in events:
        start = event["start"].get("dateTime", event["start"].get("date"))
        end = event["end"].get("dateTime", event["end"].get("date"))

        entry = {
            "time": start,
            "end": end,
            "title": event.get("summary", "(No title)"),
            "location": event.get("location", ""),
            "meet_link": event.get("hangoutLink", ""),
            "attendees": [
                a.get("email") for a in event.get("attendees", [])
                if not a.get("self")
            ],
            "status": event.get("status"),
            "is_all_day": "date" in event["start"],
        }
        agenda.append(entry)

    return agenda

# Usage
agenda = get_daily_agenda(service, "2025-03-15")
for item in agenda:
    if item["is_all_day"]:
        print(f"ALL DAY: {item['title']}")
    else:
        print(f"{item['time']} — {item['title']}")
    if item["meet_link"]:
        print(f"  Meet: {item['meet_link']}")
    if item["attendees"]:
        print(f"  With: {', '.join(item['attendees'])}")
```

## Workflow 4: Vacation Planning

Set up out-of-office, block focus time before/after, and update working location.

```python
def plan_vacation(service, start_date, end_date, prep_day=True, catchup_day=True):
    """Set up a complete vacation plan: OOO, prep day, and catch-up day."""
    results = []

    # Out-of-office block
    ooo = service.events().insert(
        calendarId="primary",
        body={
            "summary": "Vacation",
            "start": {"date": start_date},
            "end": {"date": end_date},
            "eventType": "outOfOffice",
            "outOfOfficeProperties": {
                "autoDeclineMode": "declineAllConflictingInvitations",
                "declineMessage": f"I'm on vacation from {start_date} to {end_date}. I'll respond when I return."
            }
        }
    ).execute()
    results.append({"type": "out_of_office", "id": ooo["id"]})

    # Prep day focus time (day before vacation)
    if prep_day:
        from datetime import datetime, timedelta
        prep_date = (datetime.strptime(start_date, "%Y-%m-%d") - timedelta(days=1)).strftime("%Y-%m-%d")
        focus = service.events().insert(
            calendarId="primary",
            body={
                "summary": "Vacation prep — focus time",
                "start": {"dateTime": f"{prep_date}T09:00:00-08:00", "timeZone": "America/Los_Angeles"},
                "end": {"dateTime": f"{prep_date}T17:00:00-08:00", "timeZone": "America/Los_Angeles"},
                "eventType": "focusTime",
                "focusTimeProperties": {
                    "autoDeclineMode": "declineOnlyNewConflictingInvitations",
                    "declineMessage": "I'm preparing for time off. Please reach out if urgent."
                },
                "colorId": "8"
            }
        ).execute()
        results.append({"type": "prep_focus", "id": focus["id"]})

    # Catch-up day focus time (day after vacation)
    if catchup_day:
        from datetime import datetime, timedelta
        catchup_date = (datetime.strptime(end_date, "%Y-%m-%d")).strftime("%Y-%m-%d")
        focus = service.events().insert(
            calendarId="primary",
            body={
                "summary": "Post-vacation catch-up — focus time",
                "start": {"dateTime": f"{catchup_date}T09:00:00-08:00", "timeZone": "America/Los_Angeles"},
                "end": {"dateTime": f"{catchup_date}T17:00:00-08:00", "timeZone": "America/Los_Angeles"},
                "eventType": "focusTime",
                "focusTimeProperties": {
                    "autoDeclineMode": "declineOnlyNewConflictingInvitations",
                    "declineMessage": "I'm catching up after time off. I'll be available tomorrow."
                },
                "colorId": "8"
            }
        ).execute()
        results.append({"type": "catchup_focus", "id": focus["id"]})

    return results

# Usage
plan_vacation(service, "2025-06-02", "2025-06-09")
```

## Workflow 5: Find a Meeting Time for Multiple People

```python
from datetime import datetime, timedelta, timezone

def find_meeting_slot(service, attendee_emails, duration_minutes=60,
                      search_days=5, business_hours=(9, 17),
                      time_zone="America/Los_Angeles"):
    """Find the first available slot that works for all attendees."""
    calendar_ids = ["primary"] + attendee_emails

    for day_offset in range(1, search_days + 1):
        check_date = datetime.now(timezone.utc) + timedelta(days=day_offset)

        # Skip weekends
        if check_date.weekday() >= 5:
            continue

        date_str = check_date.strftime("%Y-%m-%d")
        start_hour, end_hour = business_hours

        time_min = f"{date_str}T{start_hour:02d}:00:00-08:00"
        time_max = f"{date_str}T{end_hour:02d}:00:00-08:00"

        body = {
            "timeMin": time_min,
            "timeMax": time_max,
            "timeZone": time_zone,
            "items": [{"id": cid} for cid in calendar_ids]
        }

        result = service.freebusy().query(body=body).execute()

        # Merge all busy times
        all_busy = []
        for cal_id, data in result.get("calendars", {}).items():
            for slot in data.get("busy", []):
                all_busy.append((slot["start"], slot["end"]))

        all_busy.sort()

        # Find free slots
        current = time_min
        for busy_start, busy_end in all_busy:
            if busy_start > current:
                gap_start = datetime.fromisoformat(current)
                gap_end = datetime.fromisoformat(busy_start)
                gap_minutes = (gap_end - gap_start).total_seconds() / 60

                if gap_minutes >= duration_minutes:
                    meeting_end = gap_start + timedelta(minutes=duration_minutes)
                    return {
                        "date": date_str,
                        "start": gap_start.isoformat(),
                        "end": meeting_end.isoformat(),
                        "day": check_date.strftime("%A")
                    }
            current = max(current, busy_end)

        # Check time after last meeting
        if current < time_max:
            gap_start = datetime.fromisoformat(current)
            gap_end = datetime.fromisoformat(time_max)
            gap_minutes = (gap_end - gap_start).total_seconds() / 60

            if gap_minutes >= duration_minutes:
                meeting_end = gap_start + timedelta(minutes=duration_minutes)
                return {
                    "date": date_str,
                    "start": gap_start.isoformat(),
                    "end": meeting_end.isoformat(),
                    "day": check_date.strftime("%A")
                }

    return None

# Usage
slot = find_meeting_slot(
    service,
    attendee_emails=["alice@example.com", "bob@example.com"],
    duration_minutes=45
)

if slot:
    print(f"Available: {slot['day']} {slot['start']} to {slot['end']}")
else:
    print("No available slots found in the next 5 business days")
```

## Workflow 6: Weekly Calendar Summary

```python
def weekly_summary(service, calendar_id="primary"):
    """Generate a summary of this week's events."""
    from datetime import datetime, timedelta, timezone

    today = datetime.now(timezone.utc)
    monday = today - timedelta(days=today.weekday())
    friday = monday + timedelta(days=5)

    result = service.events().list(
        calendarId=calendar_id,
        timeMin=monday.isoformat(),
        timeMax=friday.isoformat(),
        singleEvents=True,
        orderBy="startTime"
    ).execute()

    events = result.get("items", [])

    # Group by day
    days = {}
    for event in events:
        start = event["start"].get("dateTime", event["start"].get("date"))
        day = start[:10]
        if day not in days:
            days[day] = []
        days[day].append({
            "title": event.get("summary", "(No title)"),
            "start": start,
            "end": event["end"].get("dateTime", event["end"].get("date")),
            "has_meet": bool(event.get("hangoutLink")),
            "attendee_count": len(event.get("attendees", [])),
        })

    summary = {
        "total_events": len(events),
        "total_meetings": sum(1 for e in events if e.get("attendees")),
        "total_hours": 0,
        "days": days
    }

    # Calculate total meeting hours
    for event in events:
        start = event["start"].get("dateTime")
        end = event["end"].get("dateTime")
        if start and end:
            s = datetime.fromisoformat(start)
            e = datetime.fromisoformat(end)
            summary["total_hours"] += (e - s).total_seconds() / 3600

    summary["total_hours"] = round(summary["total_hours"], 1)

    return summary

# Usage
report = weekly_summary(service)
print(f"This week: {report['total_events']} events, {report['total_meetings']} meetings, {report['total_hours']}h total")
```

## Workflow 7: Bulk Create Events from Data

```python
import time

def bulk_create_events(service, events_data, calendar_id="primary"):
    """Create multiple events from a list of event data dicts.

    events_data format:
    [
        {"summary": "...", "start": "...", "end": "...", "attendees": [...]},
        ...
    ]
    """
    results = []

    for event_data in events_data:
        try:
            event = {
                "summary": event_data["summary"],
                "start": {"dateTime": event_data["start"]},
                "end": {"dateTime": event_data["end"]},
            }
            if "time_zone" in event_data:
                event["start"]["timeZone"] = event_data["time_zone"]
                event["end"]["timeZone"] = event_data["time_zone"]
            if "description" in event_data:
                event["description"] = event_data["description"]
            if "location" in event_data:
                event["location"] = event_data["location"]
            if "attendees" in event_data:
                event["attendees"] = [{"email": e} for e in event_data["attendees"]]
            if "color_id" in event_data:
                event["colorId"] = event_data["color_id"]

            result = service.events().insert(
                calendarId=calendar_id,
                body=event,
                sendUpdates="none"
            ).execute()

            results.append({
                "summary": event_data["summary"],
                "status": "created",
                "id": result["id"],
                "url": result.get("htmlLink")
            })

        except Exception as e:
            results.append({
                "summary": event_data["summary"],
                "status": "error",
                "error": str(e)
            })

        # Respect rate limits
        time.sleep(0.5)

    created = sum(1 for r in results if r["status"] == "created")
    failed = sum(1 for r in results if r["status"] == "error")
    print(f"Created {created} events, {failed} failed")

    return results
```

## Workflow 8: Clean Up Old Events

```python
def cleanup_cancelled_events(service, calendar_id="primary", before_date=None):
    """List and optionally delete cancelled events."""
    from datetime import datetime, timedelta, timezone

    if not before_date:
        before_date = (datetime.now(timezone.utc) - timedelta(days=90)).isoformat()

    result = service.events().list(
        calendarId=calendar_id,
        timeMax=before_date,
        showDeleted=True,
        singleEvents=True,
        maxResults=100
    ).execute()

    cancelled = [
        e for e in result.get("items", [])
        if e.get("status") == "cancelled"
    ]

    print(f"Found {len(cancelled)} cancelled events before {before_date}")
    return cancelled
```

## Workflow 9: Set Working Location for the Week

```python
def set_weekly_work_schedule(service, schedule):
    """Set working locations for an entire week.

    schedule format:
    {
        "2025-03-17": "homeOffice",
        "2025-03-18": "officeLocation",
        "2025-03-19": "homeOffice",
        "2025-03-20": "officeLocation",
        "2025-03-21": "homeOffice"
    }
    """
    results = []

    for date, location_type in schedule.items():
        label = "Home" if location_type == "homeOffice" else "Office"

        event = {
            "start": {"date": date},
            "end": {"date": date},
            "eventType": "workingLocation",
            "visibility": "public",
            "transparency": "transparent",
            "summary": f"Working from {label.lower()}",
            "workingLocationProperties": {
                "type": location_type
            }
        }

        if location_type == "officeLocation":
            event["workingLocationProperties"]["officeLocation"] = {"label": "Main Office"}

        result = service.events().insert(calendarId="primary", body=event).execute()
        results.append({"date": date, "location": label, "id": result["id"]})

    return results

# Usage
set_weekly_work_schedule(service, {
    "2025-03-17": "homeOffice",
    "2025-03-18": "officeLocation",
    "2025-03-19": "homeOffice",
    "2025-03-20": "officeLocation",
    "2025-03-21": "homeOffice"
})
```
