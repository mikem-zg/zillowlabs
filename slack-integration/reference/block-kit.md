# Slack Block Kit Reference

Block Kit is Slack's framework for building rich, interactive message layouts. Blocks are used in messages, modals, and App Home tabs.

**Block Kit Builder (visual designer):** https://api.slack.com/block-kit-builder

---

## Block Types

### Header

Large, bold text heading. Maximum 150 characters.

```json
{
  "type": "header",
  "text": {
    "type": "plain_text",
    "text": "Deployment Report"
  }
}
```

### Section

The most versatile block. Supports text, fields (2-column layout), and an accessory element.

```json
{
  "type": "section",
  "text": {
    "type": "mrkdwn",
    "text": "*Project:* Alpha\n*Status:* In Progress"
  }
}
```

**With fields (2-column layout):**

```json
{
  "type": "section",
  "fields": [
    { "type": "mrkdwn", "text": "*Environment:*\nProduction" },
    { "type": "mrkdwn", "text": "*Region:*\nus-west-2" },
    { "type": "mrkdwn", "text": "*Version:*\nv2.4.1" },
    { "type": "mrkdwn", "text": "*Deploy Time:*\n3m 42s" }
  ]
}
```

**With accessory (button, image, or other element on the right):**

```json
{
  "type": "section",
  "text": {
    "type": "mrkdwn",
    "text": "Click to view the full report"
  },
  "accessory": {
    "type": "button",
    "text": { "type": "plain_text", "text": "View Report" },
    "action_id": "view_report",
    "url": "https://example.com/report"
  }
}
```

### Actions

A block containing interactive elements (buttons, selects, date pickers). Max 25 elements.

```json
{
  "type": "actions",
  "block_id": "action_block_1",
  "elements": [
    {
      "type": "button",
      "text": { "type": "plain_text", "text": "Approve" },
      "style": "primary",
      "action_id": "approve_action",
      "value": "request_123"
    },
    {
      "type": "button",
      "text": { "type": "plain_text", "text": "Reject" },
      "style": "danger",
      "action_id": "reject_action",
      "value": "request_123"
    }
  ]
}
```

### Input

Collects user input. **Only available in modals**, not in messages or App Home.

```json
{
  "type": "input",
  "block_id": "title_block",
  "label": { "type": "plain_text", "text": "Title" },
  "element": {
    "type": "plain_text_input",
    "action_id": "title_input",
    "placeholder": { "type": "plain_text", "text": "Enter a title" }
  },
  "optional": false,
  "hint": { "type": "plain_text", "text": "Keep it under 80 characters" }
}
```

### Divider

A horizontal line to separate content.

```json
{
  "type": "divider"
}
```

### Image

A full-width image block.

```json
{
  "type": "image",
  "image_url": "https://example.com/chart.png",
  "alt_text": "Monthly performance chart",
  "title": {
    "type": "plain_text",
    "text": "Performance Overview"
  }
}
```

### Context

Small text and images for secondary information (timestamps, metadata, status).

```json
{
  "type": "context",
  "elements": [
    {
      "type": "image",
      "image_url": "https://example.com/avatar.png",
      "alt_text": "User avatar"
    },
    {
      "type": "mrkdwn",
      "text": "Posted by <@U0123456789> on Jan 15, 2025 at 3:45 PM"
    }
  ]
}
```

### Video

Embed a video from a supported provider.

```json
{
  "type": "video",
  "title": { "type": "plain_text", "text": "Product Demo" },
  "video_url": "https://www.youtube.com/embed/dQw4w9WgXcQ",
  "thumbnail_url": "https://example.com/thumb.jpg",
  "alt_text": "Product demo video",
  "author_name": "Engineering Team",
  "provider_name": "YouTube",
  "provider_icon_url": "https://example.com/yt-icon.png"
}
```

### Rich Text

Structured text with formatting options.

```json
{
  "type": "rich_text",
  "elements": [
    {
      "type": "rich_text_section",
      "elements": [
        { "type": "text", "text": "Important: ", "style": { "bold": true } },
        { "type": "text", "text": "Please review the changes before merging." }
      ]
    },
    {
      "type": "rich_text_list",
      "style": "bullet",
      "elements": [
        {
          "type": "rich_text_section",
          "elements": [{ "type": "text", "text": "Update dependencies" }]
        },
        {
          "type": "rich_text_section",
          "elements": [{ "type": "text", "text": "Run test suite" }]
        }
      ]
    }
  ]
}
```

---

## Interactive Elements

### Button

```json
{
  "type": "button",
  "text": { "type": "plain_text", "text": "Click Me" },
  "action_id": "button_clicked",
  "value": "data_payload",
  "style": "primary",
  "url": "https://example.com",
  "confirm": {
    "title": { "type": "plain_text", "text": "Are you sure?" },
    "text": { "type": "mrkdwn", "text": "This action cannot be undone." },
    "confirm": { "type": "plain_text", "text": "Yes" },
    "deny": { "type": "plain_text", "text": "Cancel" }
  }
}
```

| Property | Values |
|----------|--------|
| `style` | `"primary"` (green), `"danger"` (red), or omit for default (gray) |
| `url` | Opens URL in browser when clicked (in addition to sending action) |
| `confirm` | Shows confirmation dialog before triggering action |

### Static Select Menu

Single-select dropdown with predefined options.

```json
{
  "type": "static_select",
  "action_id": "priority_select",
  "placeholder": { "type": "plain_text", "text": "Select priority" },
  "options": [
    {
      "text": { "type": "plain_text", "text": "High" },
      "value": "high"
    },
    {
      "text": { "type": "plain_text", "text": "Medium" },
      "value": "medium"
    },
    {
      "text": { "type": "plain_text", "text": "Low" },
      "value": "low"
    }
  ],
  "initial_option": {
    "text": { "type": "plain_text", "text": "Medium" },
    "value": "medium"
  }
}
```

### Multi-Select (Static)

Multiple selection from predefined options.

```json
{
  "type": "multi_static_select",
  "action_id": "assignees_select",
  "placeholder": { "type": "plain_text", "text": "Select assignees" },
  "options": [
    { "text": { "type": "plain_text", "text": "Alice" }, "value": "U111" },
    { "text": { "type": "plain_text", "text": "Bob" }, "value": "U222" },
    { "text": { "type": "plain_text", "text": "Carol" }, "value": "U333" }
  ],
  "max_selected_items": 3
}
```

### External Select

Dynamically load options from your server.

```json
{
  "type": "external_select",
  "action_id": "customer_select",
  "placeholder": { "type": "plain_text", "text": "Search customers" },
  "min_query_length": 2
}
```

Handle the options request in your app:

```typescript
app.options('customer_select', async ({ options, ack }) => {
  const query = options.value; // User's search text
  const customers = await searchCustomers(query);

  await ack({
    options: customers.map((c) => ({
      text: { type: 'plain_text', text: c.name },
      value: c.id,
    })),
  });
});
```

### Users Select

Built-in user picker (auto-populated from workspace).

```json
{
  "type": "users_select",
  "action_id": "user_select",
  "placeholder": { "type": "plain_text", "text": "Select a user" }
}
```

### Conversations Select

Built-in channel/DM picker.

```json
{
  "type": "conversations_select",
  "action_id": "channel_select",
  "placeholder": { "type": "plain_text", "text": "Select a channel" },
  "default_to_current_conversation": true,
  "filter": {
    "include": ["public", "private"],
    "exclude_bot_users": true
  }
}
```

### Date Picker

```json
{
  "type": "datepicker",
  "action_id": "date_select",
  "placeholder": { "type": "plain_text", "text": "Select a date" },
  "initial_date": "2025-03-15"
}
```

### Date-Time Picker

Combined date and time selection.

```json
{
  "type": "datetimepicker",
  "action_id": "datetime_select",
  "initial_date_time": 1705612345
}
```

### Time Picker

```json
{
  "type": "timepicker",
  "action_id": "time_select",
  "placeholder": { "type": "plain_text", "text": "Select time" },
  "initial_time": "14:30"
}
```

### Checkboxes

Multiple selection with descriptions.

```json
{
  "type": "checkboxes",
  "action_id": "tasks_check",
  "options": [
    {
      "text": { "type": "mrkdwn", "text": "*Update dependencies*" },
      "description": { "type": "plain_text", "text": "Run npm update" },
      "value": "update_deps"
    },
    {
      "text": { "type": "mrkdwn", "text": "*Run tests*" },
      "description": { "type": "plain_text", "text": "Execute full test suite" },
      "value": "run_tests"
    }
  ],
  "initial_options": [
    {
      "text": { "type": "mrkdwn", "text": "*Update dependencies*" },
      "value": "update_deps"
    }
  ]
}
```

### Radio Buttons

Single selection with descriptions.

```json
{
  "type": "radio_buttons",
  "action_id": "severity_radio",
  "options": [
    {
      "text": { "type": "plain_text", "text": "Critical" },
      "description": { "type": "plain_text", "text": "Service is down" },
      "value": "critical"
    },
    {
      "text": { "type": "plain_text", "text": "Warning" },
      "description": { "type": "plain_text", "text": "Degraded performance" },
      "value": "warning"
    },
    {
      "text": { "type": "plain_text", "text": "Info" },
      "description": { "type": "plain_text", "text": "For awareness only" },
      "value": "info"
    }
  ]
}
```

### Overflow Menu

Compact menu for secondary actions (three-dot menu).

```json
{
  "type": "overflow",
  "action_id": "overflow_menu",
  "options": [
    { "text": { "type": "plain_text", "text": "Edit" }, "value": "edit" },
    { "text": { "type": "plain_text", "text": "Delete" }, "value": "delete" },
    { "text": { "type": "plain_text", "text": "Archive" }, "value": "archive" }
  ]
}
```

### Plain Text Input

Single or multi-line text input (for modals only inside `input` blocks).

```json
{
  "type": "plain_text_input",
  "action_id": "description_input",
  "multiline": true,
  "min_length": 10,
  "max_length": 500,
  "placeholder": { "type": "plain_text", "text": "Describe the issue..." }
}
```

### URL Input

```json
{
  "type": "url_text_input",
  "action_id": "url_input",
  "placeholder": { "type": "plain_text", "text": "https://example.com" }
}
```

### Email Input

```json
{
  "type": "email_text_input",
  "action_id": "email_input",
  "placeholder": { "type": "plain_text", "text": "user@example.com" }
}
```

### Number Input

```json
{
  "type": "number_input",
  "action_id": "quantity_input",
  "is_decimal_allowed": false,
  "min_value": "1",
  "max_value": "100",
  "placeholder": { "type": "plain_text", "text": "Enter quantity" }
}
```

---

## Composition Objects

### Text Object

Used throughout Block Kit for text content.

```json
// Plain text (no formatting)
{ "type": "plain_text", "text": "Hello", "emoji": true }

// Markdown text
{ "type": "mrkdwn", "text": "*Bold* and _italic_" }
```

**Rule:** `plain_text` is required for button text, option text, titles, labels, and placeholders. `mrkdwn` can be used in section text, context, and fields.

### Option Object

Used in select menus, checkboxes, and radio buttons.

```json
{
  "text": { "type": "plain_text", "text": "Option Label" },
  "value": "option_value",
  "description": { "type": "plain_text", "text": "Helpful description" }
}
```

### Option Group

Group options under a heading in select menus.

```json
{
  "label": { "type": "plain_text", "text": "Group Name" },
  "options": [
    { "text": { "type": "plain_text", "text": "Option 1" }, "value": "1" },
    { "text": { "type": "plain_text", "text": "Option 2" }, "value": "2" }
  ]
}
```

### Confirmation Dialog

Attach to any interactive element.

```json
{
  "title": { "type": "plain_text", "text": "Confirm Action" },
  "text": { "type": "mrkdwn", "text": "Are you sure you want to delete this item?" },
  "confirm": { "type": "plain_text", "text": "Delete" },
  "deny": { "type": "plain_text", "text": "Cancel" },
  "style": "danger"
}
```

---

## Block Limits

| Constraint | Limit |
|------------|-------|
| Blocks per message | 50 |
| Blocks per modal | 100 |
| Blocks per App Home | 100 |
| Elements per actions block | 25 |
| Fields per section | 10 |
| Characters in text | 3,000 (section), 150 (header) |
| Options per select | 100 |
| Option groups per select | 100 |
| Characters per option text | 75 |
| Characters per `private_metadata` | 3,000 |

---

## Surface Compatibility

| Block Type | Messages | Modals | App Home |
|------------|----------|--------|----------|
| Header | Yes | Yes | Yes |
| Section | Yes | Yes | Yes |
| Actions | Yes | Yes | Yes |
| Input | No | Yes | No |
| Divider | Yes | Yes | Yes |
| Image | Yes | Yes | Yes |
| Context | Yes | Yes | Yes |
| Video | Yes | No | No |
| Rich Text | Yes | Yes | Yes |

---

## Common Patterns

### Notification Card

```json
[
  {
    "type": "header",
    "text": { "type": "plain_text", "text": "New Pull Request" }
  },
  {
    "type": "section",
    "fields": [
      { "type": "mrkdwn", "text": "*Author:*\n<@U0123456789>" },
      { "type": "mrkdwn", "text": "*Repository:*\nmy-app" },
      { "type": "mrkdwn", "text": "*Branch:*\nfeature/login" },
      { "type": "mrkdwn", "text": "*Status:*\nReady for review" }
    ]
  },
  {
    "type": "section",
    "text": {
      "type": "mrkdwn",
      "text": "Add OAuth 2.0 login flow with Google provider"
    }
  },
  {
    "type": "actions",
    "elements": [
      {
        "type": "button",
        "text": { "type": "plain_text", "text": "Review PR" },
        "style": "primary",
        "url": "https://github.com/org/repo/pull/42",
        "action_id": "review_pr"
      },
      {
        "type": "button",
        "text": { "type": "plain_text", "text": "View Diff" },
        "url": "https://github.com/org/repo/pull/42/files",
        "action_id": "view_diff"
      }
    ]
  },
  {
    "type": "context",
    "elements": [
      {
        "type": "mrkdwn",
        "text": "Opened 5 minutes ago | 3 files changed | +142 -28"
      }
    ]
  }
]
```

### Form in a Modal

```json
{
  "type": "modal",
  "callback_id": "bug_report",
  "title": { "type": "plain_text", "text": "Report a Bug" },
  "submit": { "type": "plain_text", "text": "Submit" },
  "close": { "type": "plain_text", "text": "Cancel" },
  "blocks": [
    {
      "type": "input",
      "block_id": "title",
      "label": { "type": "plain_text", "text": "Bug Title" },
      "element": {
        "type": "plain_text_input",
        "action_id": "title_input",
        "placeholder": { "type": "plain_text", "text": "Brief description of the bug" }
      }
    },
    {
      "type": "input",
      "block_id": "severity",
      "label": { "type": "plain_text", "text": "Severity" },
      "element": {
        "type": "static_select",
        "action_id": "severity_select",
        "options": [
          { "text": { "type": "plain_text", "text": "Critical" }, "value": "critical" },
          { "text": { "type": "plain_text", "text": "Major" }, "value": "major" },
          { "text": { "type": "plain_text", "text": "Minor" }, "value": "minor" }
        ]
      }
    },
    {
      "type": "input",
      "block_id": "steps",
      "label": { "type": "plain_text", "text": "Steps to Reproduce" },
      "element": {
        "type": "plain_text_input",
        "action_id": "steps_input",
        "multiline": true
      }
    },
    {
      "type": "input",
      "block_id": "assignee",
      "label": { "type": "plain_text", "text": "Assign to" },
      "element": {
        "type": "users_select",
        "action_id": "assignee_select"
      },
      "optional": true
    }
  ]
}
```

### Status Update Message

```json
[
  {
    "type": "section",
    "text": {
      "type": "mrkdwn",
      "text": ":white_check_mark: *Build #1234 Passed*\nAll 847 tests passed in 3m 12s"
    }
  },
  { "type": "divider" },
  {
    "type": "context",
    "elements": [
      {
        "type": "mrkdwn",
        "text": ":github: <https://github.com/org/repo/commit/abc123|abc123> | Branch: `main` | Triggered by <@U0123>"
      }
    ]
  }
]
```
