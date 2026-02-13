# Recurring Events Reference

## RRULE Syntax

Google Calendar uses the iCalendar RFC 5545 RRULE format for recurring events. Rules are passed as strings in the `recurrence` array field.

## Basic Format

```
RRULE:FREQ=<frequency>;[KEY=VALUE;...]
```

## Frequency Options

| Frequency | Description | Example |
|-----------|-------------|---------|
| `DAILY` | Every day | `RRULE:FREQ=DAILY` |
| `WEEKLY` | Every week | `RRULE:FREQ=WEEKLY` |
| `MONTHLY` | Every month | `RRULE:FREQ=MONTHLY` |
| `YEARLY` | Every year | `RRULE:FREQ=YEARLY` |

## Rule Components

| Component | Description | Example |
|-----------|-------------|---------|
| `FREQ` | Frequency (required) | `FREQ=WEEKLY` |
| `COUNT` | Number of occurrences | `COUNT=10` (10 total events) |
| `UNTIL` | End date (UTC format) | `UNTIL=20251231T235959Z` |
| `INTERVAL` | Repeat every N periods | `INTERVAL=2` (every 2 weeks) |
| `BYDAY` | Days of the week | `BYDAY=MO,WE,FR` |
| `BYMONTHDAY` | Days of the month | `BYMONTHDAY=1,15` |
| `BYMONTH` | Months of the year | `BYMONTH=1,6,12` |
| `BYSETPOS` | Position within set | `BYSETPOS=-1` (last occurrence) |
| `WKST` | Week start day | `WKST=MO` (default) |

## Day Abbreviations

| Day | Abbreviation |
|-----|-------------|
| Monday | `MO` |
| Tuesday | `TU` |
| Wednesday | `WE` |
| Thursday | `TH` |
| Friday | `FR` |
| Saturday | `SA` |
| Sunday | `SU` |

## Common Patterns

### Daily Patterns

```python
# Every day for 30 days
recurrence = ["RRULE:FREQ=DAILY;COUNT=30"]

# Every day until end of year
recurrence = ["RRULE:FREQ=DAILY;UNTIL=20251231T235959Z"]

# Every other day
recurrence = ["RRULE:FREQ=DAILY;INTERVAL=2;COUNT=15"]

# Every 3 days
recurrence = ["RRULE:FREQ=DAILY;INTERVAL=3"]
```

### Weekly Patterns

```python
# Every Monday
recurrence = ["RRULE:FREQ=WEEKLY;BYDAY=MO"]

# Every Monday and Wednesday
recurrence = ["RRULE:FREQ=WEEKLY;BYDAY=MO,WE"]

# Every Monday for 12 weeks
recurrence = ["RRULE:FREQ=WEEKLY;BYDAY=MO;COUNT=12"]

# Every weekday (Mon-Fri)
recurrence = ["RRULE:FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR"]

# Every other Friday
recurrence = ["RRULE:FREQ=WEEKLY;INTERVAL=2;BYDAY=FR"]

# Every other week on Tuesday and Thursday
recurrence = ["RRULE:FREQ=WEEKLY;INTERVAL=2;BYDAY=TU,TH"]

# Tuesdays and Thursdays until June
recurrence = ["RRULE:FREQ=WEEKLY;BYDAY=TU,TH;UNTIL=20250601T000000Z"]
```

### Monthly Patterns

```python
# First of every month
recurrence = ["RRULE:FREQ=MONTHLY;BYMONTHDAY=1"]

# 15th of every month
recurrence = ["RRULE:FREQ=MONTHLY;BYMONTHDAY=15"]

# First Monday of every month
recurrence = ["RRULE:FREQ=MONTHLY;BYDAY=1MO"]

# Second Tuesday of every month
recurrence = ["RRULE:FREQ=MONTHLY;BYDAY=2TU"]

# Last Friday of every month
recurrence = ["RRULE:FREQ=MONTHLY;BYDAY=-1FR"]

# Last day of every month
recurrence = ["RRULE:FREQ=MONTHLY;BYMONTHDAY=-1"]

# Every other month on the 1st
recurrence = ["RRULE:FREQ=MONTHLY;INTERVAL=2;BYMONTHDAY=1"]

# First and third Monday of each month
recurrence = ["RRULE:FREQ=MONTHLY;BYDAY=1MO,3MO"]
```

### Yearly Patterns

```python
# Every year on March 15
recurrence = ["RRULE:FREQ=YEARLY;BYMONTH=3;BYMONTHDAY=15"]

# Every year, same date as start
recurrence = ["RRULE:FREQ=YEARLY"]

# First Monday of January every year
recurrence = ["RRULE:FREQ=YEARLY;BYMONTH=1;BYDAY=1MO"]

# Last Friday of December every year
recurrence = ["RRULE:FREQ=YEARLY;BYMONTH=12;BYDAY=-1FR"]

# Every 2 years
recurrence = ["RRULE:FREQ=YEARLY;INTERVAL=2"]
```

## Exception Dates (EXDATE)

Exclude specific dates from a recurring series:

```python
recurrence = [
    "RRULE:FREQ=WEEKLY;BYDAY=MO;COUNT=12",
    "EXDATE;TZID=America/Los_Angeles:20250324T090000",  # Skip March 24
    "EXDATE;TZID=America/Los_Angeles:20250331T090000"   # Skip March 31
]
```

For all-day events:
```python
recurrence = [
    "RRULE:FREQ=WEEKLY;BYDAY=MO",
    "EXDATE;VALUE=DATE:20250324"
]
```

## Additional Dates (RDATE)

Add extra dates to a recurring series:

```python
recurrence = [
    "RRULE:FREQ=WEEKLY;BYDAY=MO;COUNT=4",
    "RDATE;TZID=America/Los_Angeles:20250326T090000"  # Also on Wednesday March 26
]
```

## Managing Recurring Event Instances

### List All Instances

```python
instances = service.events().instances(
    calendarId="primary",
    eventId="recurring_event_id",
    timeMin="2025-03-01T00:00:00Z",
    timeMax="2025-04-01T00:00:00Z"
).execute()

for instance in instances.get("items", []):
    start = instance["start"].get("dateTime", instance["start"].get("date"))
    print(f"{start} — {instance['summary']} (ID: {instance['id']})")
```

### Modify a Single Instance

```python
# Get the specific instance
instance = service.events().get(
    calendarId="primary",
    eventId="recurring_event_id_20250317T170000Z"  # Instance ID includes timestamp
).execute()

# Change this instance's time
instance["start"]["dateTime"] = "2025-03-17T11:00:00-08:00"
instance["end"]["dateTime"] = "2025-03-17T12:00:00-08:00"
instance["summary"] = "Rescheduled standup"

service.events().update(
    calendarId="primary",
    eventId=instance["id"],
    body=instance
).execute()
```

### Cancel a Single Instance

```python
instance = service.events().get(
    calendarId="primary",
    eventId="instance_id"
).execute()

instance["status"] = "cancelled"

service.events().update(
    calendarId="primary",
    eventId=instance["id"],
    body=instance
).execute()
```

### Modify All Future Instances ("This and Following")

Not directly supported via API. Workaround:

1. Update the original recurring event's `UNTIL` to end before the change point
2. Create a new recurring event starting from the change point with updated properties

```python
def modify_this_and_following(service, event_id, change_from_date, new_properties):
    """Modify a recurring event from a specific date forward."""
    # Get the original event
    original = service.events().get(calendarId="primary", eventId=event_id).execute()

    # End the original series before the change date
    original_recurrence = original.get("recurrence", [])
    updated_recurrence = []
    for rule in original_recurrence:
        if rule.startswith("RRULE:"):
            # Add UNTIL clause
            if "UNTIL=" not in rule and "COUNT=" not in rule:
                rule += f";UNTIL={change_from_date}T000000Z"
            elif "COUNT=" in rule:
                # Remove COUNT and add UNTIL
                import re
                rule = re.sub(r";?COUNT=\d+", "", rule)
                rule += f";UNTIL={change_from_date}T000000Z"
        updated_recurrence.append(rule)

    original["recurrence"] = updated_recurrence
    service.events().update(calendarId="primary", eventId=event_id, body=original).execute()

    # Create new recurring event with updated properties
    new_event = {**original, **new_properties}
    del new_event["id"]
    del new_event["iCalUID"]
    new_event["start"]["dateTime"] = f"{change_from_date}T{original['start']['dateTime'].split('T')[1]}"

    service.events().insert(calendarId="primary", body=new_event).execute()
```

## Important Notes

1. **COUNT vs UNTIL**: Use one or the other, never both
2. **UNTIL format**: Must be in UTC (ending with Z) — e.g., `20251231T235959Z`
3. **BYDAY with numbers**: `1MO` = first Monday, `-1FR` = last Friday, `2TU` = second Tuesday
4. **Instance IDs**: Individual instances have IDs like `{base_event_id}_{timestamp}` (e.g., `abc123_20250317T170000Z`)
5. **Timezone**: When using EXDATE/RDATE with times, include `TZID=` parameter
6. **Max occurrences**: Google Calendar typically limits display to 730 instances (about 2 years of daily events)
7. **singleEvents parameter**: When listing, set `singleEvents=True` to expand recurring events into individual instances; otherwise, only the parent recurring event is returned
