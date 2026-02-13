# Slack Events API & Interactivity Reference

Complete reference for handling Slack events, slash commands, interactive components, modals, App Home, and Workflow Builder custom steps.

---

## Connection Modes

### HTTP Mode (Recommended for Replit)

Slack sends HTTP POST requests to your server. Best for production deployments on Replit.

```typescript
import { App, ExpressReceiver } from '@slack/bolt';

const receiver = new ExpressReceiver({
  signingSecret: process.env.SLACK_SIGNING_SECRET!,
  endpoints: '/slack/events', // All Slack events route here
});

const app = new App({
  token: process.env.SLACK_BOT_TOKEN!,
  receiver,
});

await app.start(5000); // Bind to port 5000 for Replit
```

**Slack App Configuration:**
- Event Subscriptions → Request URL: `https://your-app.replit.app/slack/events`
- Interactivity → Request URL: `https://your-app.replit.app/slack/events`
- Slash Commands → Request URL: `https://your-app.replit.app/slack/events`

### Socket Mode (Development)

Uses WebSocket connection. No public URL required.

```typescript
import { App } from '@slack/bolt';

const app = new App({
  token: process.env.SLACK_BOT_TOKEN!,
  appToken: process.env.SLACK_APP_TOKEN!,  // xapp- token
  socketMode: true,
});

await app.start();
```

**Setup:**
1. Enable Socket Mode in App Settings → Socket Mode
2. Generate App-Level Token with `connections:write` scope
3. Store as `SLACK_APP_TOKEN`

### When to Use Each

| Factor | HTTP Mode | Socket Mode |
|--------|-----------|-------------|
| Replit production | Recommended | Not recommended |
| Local development | Needs tunnel (ngrok) | Works directly |
| Behind firewall | Requires public URL | Works behind firewall |
| Reliability | Higher (stateless) | Lower (persistent connection) |
| Marketplace apps | Required | Not allowed |

---

## Request Signature Verification

Bolt handles signature verification automatically. If implementing manually:

```typescript
import crypto from 'crypto';

function verifySlackRequest(
  signingSecret: string,
  requestTimestamp: string,
  rawBody: string,
  slackSignature: string
): boolean {
  // Reject requests older than 5 minutes
  const fiveMinutesAgo = Math.floor(Date.now() / 1000) - 300;
  if (parseInt(requestTimestamp) < fiveMinutesAgo) {
    return false;
  }

  // Compute signature
  const sigBaseString = `v0:${requestTimestamp}:${rawBody}`;
  const mySignature =
    'v0=' +
    crypto
      .createHmac('sha256', signingSecret)
      .update(sigBaseString, 'utf8')
      .digest('hex');

  // Timing-safe comparison
  return crypto.timingSafeEqual(
    Buffer.from(mySignature, 'utf8'),
    Buffer.from(slackSignature, 'utf8')
  );
}
```

---

## Events API

### Subscribing to Events

In your Slack App settings → Event Subscriptions → Subscribe to bot events:

| Event | Description | Required Scope |
|-------|-------------|----------------|
| `app_mention` | Bot is mentioned | `app_mentions:read` |
| `message.channels` | Message in public channel | `channels:history` |
| `message.groups` | Message in private channel | `groups:history` |
| `message.im` | Direct message to bot | `im:history` |
| `message.mpim` | Group DM message | `mpim:history` |
| `member_joined_channel` | User joins channel | `channels:read` |
| `member_left_channel` | User leaves channel | `channels:read` |
| `app_home_opened` | User opens App Home | (none) |
| `reaction_added` | Emoji reaction added | `reactions:read` |
| `reaction_removed` | Emoji reaction removed | `reactions:read` |
| `channel_created` | New channel created | `channels:read` |
| `team_join` | New user joins workspace | `users:read` |
| `file_shared` | File shared in channel | `files:read` |

### Event Handlers in Bolt

```typescript
// App mention
app.event('app_mention', async ({ event, say, client }) => {
  const text = event.text; // Full message text including the mention
  const user = event.user; // User ID who mentioned the bot
  const channel = event.channel;
  const ts = event.ts;    // Message timestamp

  await say({
    text: `Hey <@${user}>!`,
    thread_ts: ts, // Reply in thread
  });
});

// Message event (all messages in channels bot is in)
app.event('message', async ({ event, say }) => {
  // Filter out bot messages, edits, and deletes
  if ('subtype' in event) return;
  if ('bot_id' in event) return;

  const text = event.text || '';

  if (text.toLowerCase().includes('help')) {
    await say({
      text: 'Here are the commands I support...',
      thread_ts: event.ts,
    });
  }
});

// Member joined channel
app.event('member_joined_channel', async ({ event, client }) => {
  await client.chat.postMessage({
    channel: event.channel,
    text: `Welcome <@${event.user}>! Check the pinned messages for guidelines.`,
  });
});

// Reaction added
app.event('reaction_added', async ({ event, client }) => {
  if (event.reaction === 'eyes') {
    // Someone added 👀 to a message
    await client.chat.postMessage({
      channel: event.item.channel,
      thread_ts: event.item.ts,
      text: `<@${event.user}> is looking into this.`,
    });
  }
});

// App Home opened
app.event('app_home_opened', async ({ event, client }) => {
  // Publish personalized home tab
  await client.views.publish({
    user_id: event.user,
    view: {
      type: 'home',
      blocks: [
        {
          type: 'header',
          text: { type: 'plain_text', text: 'Dashboard' },
        },
        // ... more blocks
      ],
    },
  });
});
```

### Event Payload Structure

```typescript
interface EventPayload {
  token: string;
  team_id: string;
  api_app_id: string;
  event: {
    type: string;        // Event type
    user: string;        // User ID
    text?: string;       // Message text
    ts: string;          // Timestamp
    channel: string;     // Channel ID
    event_ts: string;    // Event timestamp
    channel_type?: string; // 'channel', 'group', 'im', 'mpim'
  };
  type: 'event_callback';
  event_id: string;
  event_time: number;
}
```

### URL Verification Challenge

When you first set up your Request URL, Slack sends a challenge:

```typescript
// Bolt handles this automatically. Manual handling:
app.post('/slack/events', (req, res) => {
  if (req.body.type === 'url_verification') {
    return res.json({ challenge: req.body.challenge });
  }
  // ... handle events
});
```

---

## Slash Commands

### Registration

Register commands in Slack App Settings → Slash Commands:

| Field | Value |
|-------|-------|
| Command | `/your-command` |
| Request URL | `https://your-app.replit.app/slack/events` |
| Short Description | What the command does |
| Usage Hint | `[argument] [options]` |

### Handling Commands

```typescript
app.command('/status', async ({ command, ack, respond, client }) => {
  // MUST acknowledge within 3 seconds
  await ack();

  // command object properties:
  // command.text — everything after the command
  // command.user_id — who invoked the command
  // command.user_name — username
  // command.channel_id — where the command was invoked
  // command.channel_name — channel name
  // command.trigger_id — for opening modals (valid 3 seconds)
  // command.response_url — for delayed responses

  await respond({
    response_type: 'ephemeral', // or 'in_channel'
    text: `Status for: ${command.text}`,
  });
});
```

### Response Types

| Type | Visibility | Use Case |
|------|-----------|----------|
| `ephemeral` | Only the invoking user sees it | Default. User-specific info, errors, confirmations |
| `in_channel` | Everyone in the channel sees it | Shared information, results others should see |

### Delayed Responses

For operations that take more than 3 seconds:

```typescript
app.command('/report', async ({ command, ack, respond }) => {
  await ack(); // Acknowledge immediately

  // Perform slow operation
  const data = await generateLargeReport(command.text);

  // Respond using respond() — works up to 30 minutes after
  await respond({
    response_type: 'in_channel',
    text: `Report generated:\n${data}`,
  });
});
```

### Opening a Modal from a Command

```typescript
app.command('/create', async ({ ack, body, client }) => {
  await ack();

  await client.views.open({
    trigger_id: body.trigger_id, // Valid for 3 seconds
    view: {
      type: 'modal',
      callback_id: 'create_modal',
      title: { type: 'plain_text', text: 'Create Item' },
      submit: { type: 'plain_text', text: 'Create' },
      blocks: [
        // ... input blocks
      ],
    },
  });
});
```

---

## Interactive Components (Actions)

### Button Clicks

```typescript
app.action('approve_button', async ({ ack, body, client, say, action }) => {
  await ack(); // Must acknowledge within 3 seconds

  // action.value — the value set on the button
  // body.user.id — who clicked
  // body.channel?.id — where the button was (if in a message)
  // body.message?.ts — timestamp of the message containing the button
  // body.trigger_id — for opening modals

  await say(`<@${body.user.id}> approved the request.`);

  // Update the original message to remove/change buttons
  if (body.channel && body.message) {
    await client.chat.update({
      channel: body.channel.id,
      ts: body.message.ts,
      text: 'Request approved',
      blocks: [
        {
          type: 'section',
          text: { type: 'mrkdwn', text: ':white_check_mark: *Approved* by <@' + body.user.id + '>' },
        },
      ],
    });
  }
});
```

### Select Menu Changes

```typescript
app.action('priority_select', async ({ ack, body, action }) => {
  await ack();

  const selectedValue = action.selected_option?.value;
  console.log(`Priority changed to: ${selectedValue}`);
});
```

### Multi-Select Changes

```typescript
app.action('assignees_select', async ({ ack, action }) => {
  await ack();

  const selectedUsers = action.selected_options?.map((o: any) => o.value);
  console.log(`Assigned to: ${selectedUsers?.join(', ')}`);
});
```

### Overflow Menu

```typescript
app.action('overflow_menu', async ({ ack, action, body, client }) => {
  await ack();

  const selectedAction = action.selected_option?.value;

  switch (selectedAction) {
    case 'edit':
      // Open edit modal
      await client.views.open({
        trigger_id: body.trigger_id!,
        view: { /* edit modal view */ },
      });
      break;
    case 'delete':
      // Handle delete
      break;
  }
});
```

### Regex Action Matching

```typescript
// Match multiple action IDs with a pattern
app.action(/^(approve|reject)_request$/, async ({ ack, action, body }) => {
  await ack();
  const actionType = action.action_id; // 'approve_request' or 'reject_request'
  // Handle both actions
});
```

---

## Modals (Views)

### Opening a Modal

Requires a `trigger_id` from a user interaction (button click, slash command, shortcut). Valid for 3 seconds.

```typescript
app.action('open_form', async ({ ack, body, client }) => {
  await ack();

  await client.views.open({
    trigger_id: body.trigger_id!,
    view: {
      type: 'modal',
      callback_id: 'my_form',
      title: { type: 'plain_text', text: 'My Form' },
      submit: { type: 'plain_text', text: 'Submit' },
      close: { type: 'plain_text', text: 'Cancel' },
      private_metadata: JSON.stringify({ channel: body.channel?.id }), // Pass state
      blocks: [
        {
          type: 'input',
          block_id: 'name_block',
          label: { type: 'plain_text', text: 'Name' },
          element: {
            type: 'plain_text_input',
            action_id: 'name_input',
          },
        },
      ],
    },
  });
});
```

### Handling Modal Submissions

```typescript
app.view('my_form', async ({ ack, body, view, client }) => {
  // Extract submitted values
  const name = view.state.values.name_block.name_input.value;
  const metadata = JSON.parse(view.private_metadata || '{}');

  // Validate input
  const errors: Record<string, string> = {};
  if (!name || name.length < 2) {
    errors['name_block'] = 'Name must be at least 2 characters';
  }

  if (Object.keys(errors).length > 0) {
    // Return validation errors — modal stays open with error messages
    await ack({
      response_action: 'errors',
      errors,
    });
    return;
  }

  // Success — close the modal
  await ack();

  // Post result to a channel
  await client.chat.postMessage({
    channel: metadata.channel,
    text: `<@${body.user.id}> submitted: ${name}`,
  });
});
```

### Updating a Modal

Update the currently visible view in response to user interactions within the modal.

```typescript
app.action('category_select', async ({ ack, body, client }) => {
  await ack();

  // Update the modal with new content based on selection
  await client.views.update({
    view_id: body.view!.id,
    hash: body.view!.hash, // Prevents race conditions
    view: {
      type: 'modal',
      callback_id: 'my_form',
      title: { type: 'plain_text', text: 'Updated Form' },
      submit: { type: 'plain_text', text: 'Submit' },
      blocks: [
        // Updated blocks based on selection
      ],
    },
  });
});
```

### Pushing a New View

Push a detail view onto the modal stack (max 3 views total).

```typescript
app.action('view_details', async ({ ack, body, client }) => {
  await ack();

  await client.views.push({
    trigger_id: body.trigger_id!,
    view: {
      type: 'modal',
      callback_id: 'detail_view',
      title: { type: 'plain_text', text: 'Details' },
      close: { type: 'plain_text', text: 'Back' }, // Returns to previous view
      blocks: [
        // Detail content
      ],
    },
  });
});
```

### Response Actions (Without API Call)

When handling `view_submission`, you can return a response action instead of making an API call:

```typescript
app.view('step1_form', async ({ ack }) => {
  // Push a new view (no API call needed)
  await ack({
    response_action: 'push',
    view: {
      type: 'modal',
      callback_id: 'step2_form',
      title: { type: 'plain_text', text: 'Step 2' },
      submit: { type: 'plain_text', text: 'Finish' },
      blocks: [/* step 2 blocks */],
    },
  });
});

// Other response actions:
await ack({ response_action: 'update', view: { /* updated view */ } });
await ack({ response_action: 'clear' }); // Close all views
await ack({ response_action: 'errors', errors: { block_id: 'Error message' } });
```

### Extracting View State Values

Modal input values follow this structure:

```typescript
// view.state.values[block_id][action_id]

// Plain text input
view.state.values.name_block.name_input.value; // string

// Select menu
view.state.values.priority_block.priority_select.selected_option?.value; // string

// Multi-select
view.state.values.tags_block.tags_select.selected_options?.map(o => o.value); // string[]

// Date picker
view.state.values.date_block.date_input.selected_date; // "2025-03-15"

// Checkboxes
view.state.values.options_block.options_check.selected_options?.map(o => o.value); // string[]

// Radio buttons
view.state.values.severity_block.severity_radio.selected_option?.value; // string

// Users select
view.state.values.assignee_block.assignee_select.selected_user; // user ID

// Conversations select
view.state.values.channel_block.channel_select.selected_conversation; // channel ID
```

---

## App Home Tab

### Setup

1. Enable Home Tab in App Settings → App Home
2. Subscribe to `app_home_opened` event
3. Publish views with `views.publish`

### Building the Home Tab

```typescript
app.event('app_home_opened', async ({ event, client }) => {
  // Only update on first visit or when tab is 'home'
  if (event.tab !== 'home') return;

  // Fetch personalized data
  const tasks = await getUserTasks(event.user);

  await client.views.publish({
    user_id: event.user,
    view: {
      type: 'home',
      blocks: [
        {
          type: 'header',
          text: { type: 'plain_text', text: 'Your Dashboard' },
        },
        { type: 'divider' },
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: `*Open Tasks:* ${tasks.length}`,
          },
        },
        // Dynamic task list
        ...tasks.map((task) => ({
          type: 'section' as const,
          text: {
            type: 'mrkdwn' as const,
            text: `${task.completed ? ':white_check_mark:' : ':black_square_button:'} ${task.title}`,
          },
          accessory: {
            type: 'button' as const,
            text: { type: 'plain_text' as const, text: task.completed ? 'Undo' : 'Complete' },
            action_id: `toggle_task_${task.id}`,
            value: task.id,
          },
        })),
        { type: 'divider' },
        {
          type: 'actions',
          elements: [
            {
              type: 'button',
              text: { type: 'plain_text', text: 'Add New Task' },
              style: 'primary',
              action_id: 'add_task',
            },
          ],
        },
      ],
    },
  });
});

// Handle task toggle from Home tab
app.action(/^toggle_task_/, async ({ ack, action, body, client }) => {
  await ack();

  const taskId = action.value;
  await toggleTask(taskId);

  // Republish the home tab with updated data
  const tasks = await getUserTasks(body.user.id);
  await client.views.publish({
    user_id: body.user.id,
    view: {
      type: 'home',
      blocks: [/* updated blocks */],
    },
  });
});
```

---

## Shortcuts

### Global Shortcuts

Triggered from the lightning bolt menu or search bar. Accessible from anywhere in Slack.

**Setup:** App Settings → Interactivity & Shortcuts → Create New Shortcut → Global

```typescript
app.shortcut('create_ticket', async ({ ack, shortcut, client }) => {
  await ack();

  await client.views.open({
    trigger_id: shortcut.trigger_id,
    view: {
      type: 'modal',
      callback_id: 'ticket_form',
      title: { type: 'plain_text', text: 'Create Ticket' },
      submit: { type: 'plain_text', text: 'Create' },
      blocks: [/* form blocks */],
    },
  });
});
```

### Message Shortcuts

Triggered from the context menu of a specific message. Provides the message content.

**Setup:** App Settings → Interactivity & Shortcuts → Create New Shortcut → On messages

```typescript
app.shortcut('save_message', async ({ ack, shortcut, client }) => {
  await ack();

  const messageText = shortcut.message?.text;
  const messageTs = shortcut.message?.ts;
  const channel = shortcut.channel?.id;

  // Save the message or process it
  await saveMessage(shortcut.user.id, messageText, channel, messageTs);

  // Notify the user
  await client.chat.postEphemeral({
    channel: channel!,
    user: shortcut.user.id,
    text: 'Message saved!',
  });
});
```

---

## Workflow Builder Custom Steps

Create custom steps that appear in Slack's Workflow Builder.

### Manifest Configuration

```json
{
  "functions": {
    "send_approval": {
      "title": "Send Approval Request",
      "description": "Sends an approval request to a specified user",
      "input_parameters": {
        "approver": {
          "type": "slack#/types/user_id",
          "title": "Approver",
          "is_required": true
        },
        "request_text": {
          "type": "string",
          "title": "Request Details",
          "is_required": true
        }
      },
      "output_parameters": {
        "approved": {
          "type": "boolean",
          "title": "Was Approved"
        }
      }
    }
  },
  "settings": {
    "event_subscriptions": {
      "bot_events": ["function_executed"]
    },
    "org_deploy_enabled": true
  }
}
```

### Function Handler

```typescript
app.function('send_approval', async ({ client, inputs, fail }) => {
  try {
    const { approver, request_text } = inputs;

    await client.chat.postMessage({
      channel: approver,
      text: `Approval needed: ${request_text}`,
      blocks: [
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: `*Approval Request:*\n${request_text}`,
          },
        },
        {
          type: 'actions',
          elements: [
            {
              type: 'button',
              text: { type: 'plain_text', text: 'Approve' },
              style: 'primary',
              action_id: 'wf_approve',
              value: 'approved',
            },
            {
              type: 'button',
              text: { type: 'plain_text', text: 'Deny' },
              style: 'danger',
              action_id: 'wf_deny',
              value: 'denied',
            },
          ],
        },
      ],
    });
  } catch (error: any) {
    await fail({ error: error.message });
  }
});

// Complete the workflow step when button is clicked
app.action(/^wf_(approve|deny)$/, async ({ ack, action, complete, fail }) => {
  await ack();

  try {
    await complete({
      outputs: {
        approved: action.value === 'approved',
      },
    });
  } catch (error: any) {
    await fail({ error: error.message });
  }
});
```

---

## Incoming Webhooks

One-way message posting. No event handling needed.

### Setup

1. App Settings → Incoming Webhooks → Activate
2. Add New Webhook to Workspace → Select channel → Copy URL

### Usage

```typescript
import axios from 'axios';

const webhookUrl = process.env.SLACK_WEBHOOK_URL!;

// Simple text
await axios.post(webhookUrl, { text: 'Server restarted successfully' });

// Rich message with blocks
await axios.post(webhookUrl, {
  text: 'Deployment notification',
  blocks: [
    {
      type: 'section',
      text: {
        type: 'mrkdwn',
        text: ':rocket: *Deployment to production complete*',
      },
    },
  ],
});
```

### Limitations

- Cannot post to channels other than the one configured
- Cannot read messages or events
- Cannot use interactive elements (buttons will not send actions)
- Cannot delete or update sent messages

---

## Message Acknowledgment Rules

**Critical:** All interactive payloads must be acknowledged within 3 seconds.

| Payload Type | Acknowledgment | Handler |
|-------------|----------------|---------|
| Slash commands | `await ack()` | `app.command()` |
| Button clicks | `await ack()` | `app.action()` |
| Select menus | `await ack()` | `app.action()` |
| Modal submissions | `await ack()` | `app.view()` |
| Shortcuts | `await ack()` | `app.shortcut()` |
| Options loading | `await ack({ options })` | `app.options()` |

**If your processing takes longer than 3 seconds:**
1. Call `ack()` immediately
2. Do your processing asynchronously
3. Use `respond()` or `client.chat.postMessage()` for the result

```typescript
app.command('/slow-command', async ({ ack, respond }) => {
  await ack(); // Respond to Slack immediately

  // This can take as long as needed
  const result = await longRunningTask();

  // respond() works up to 30 minutes after the original interaction
  await respond({
    text: `Result: ${result}`,
    response_type: 'ephemeral',
  });
});
```
