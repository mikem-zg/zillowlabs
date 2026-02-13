---
name: slack-integration
description: Build Slack integrations with Replit apps using the Bolt SDK for Node.js. Send messages, handle slash commands, listen to events, create interactive Block Kit UIs, open modals, manage channels/users, post webhook notifications, build App Home dashboards, and deploy on Replit with HTTP or Socket Mode.
---

## Overview

Build Slack integrations for Replit applications using the official Bolt SDK for Node.js. This skill covers the complete Slack platform — from sending simple messages to building interactive bots with slash commands, Block Kit UIs, modals, App Home dashboards, and Workflow Builder custom steps.

**Recommended approach for Replit:** Use HTTP mode with `ExpressReceiver` since Replit provides a stable public URL for your deployment. Socket Mode is available for development but HTTP mode is preferred for production.

📋 **API Reference**: [reference/api-reference.md](reference/api-reference.md)
🧱 **Block Kit Guide**: [reference/block-kit.md](reference/block-kit.md)
⚡ **Events & Interactivity**: [reference/events-and-interactivity.md](reference/events-and-interactivity.md)
💡 **Examples**: [examples/common-workflows.md](examples/common-workflows.md)

## Prerequisites

Before building a Slack integration, you need:

1. **A Slack App** created at https://api.slack.com/apps
2. **Bot Token** (`xoxb-...`) — from OAuth & Permissions after installing the app
3. **Signing Secret** — from Basic Information → App Credentials
4. **App-Level Token** (`xapp-...`) — only needed for Socket Mode (Basic Information → App-Level Tokens)

### Required Environment Variables

```bash
SLACK_BOT_TOKEN=xoxb-your-bot-token
SLACK_SIGNING_SECRET=your-signing-secret

# Only for Socket Mode:
SLACK_APP_TOKEN=xapp-your-app-level-token

# Only for Incoming Webhooks:
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/T.../B.../xxx
```

### Required npm Packages

```bash
npm install @slack/bolt
```

### Bot Token Scopes (OAuth & Permissions)

Add these scopes based on your needs:

| Scope | Purpose |
|-------|---------|
| `chat:write` | Send messages |
| `chat:write.public` | Send to channels bot isn't in |
| `channels:read` | List public channels |
| `channels:history` | Read messages in public channels |
| `groups:read` | List private channels |
| `groups:history` | Read private channel messages |
| `im:read` | View DM info |
| `im:history` | Read DM messages |
| `users:read` | View user info |
| `users:read.email` | View user emails |
| `app_mentions:read` | Listen for @mentions |
| `commands` | Handle slash commands |
| `reactions:read` | Read emoji reactions |
| `reactions:write` | Add emoji reactions |
| `files:write` | Upload files |
| `channels:manage` | Create/archive channels |
| `groups:write` | Manage private channels |

## Quick Start — Replit with HTTP Mode (Recommended)

This is the recommended setup for Replit apps. It uses `ExpressReceiver` to share the Express server between your app and Slack event handling.

```typescript
import { App, ExpressReceiver } from '@slack/bolt';
import express from 'express';

const receiver = new ExpressReceiver({
  signingSecret: process.env.SLACK_SIGNING_SECRET!,
  endpoints: '/slack/events',
});

const app = new App({
  token: process.env.SLACK_BOT_TOKEN!,
  receiver,
});

// Respond to @mentions
app.event('app_mention', async ({ event, say }) => {
  await say({
    text: `Hey <@${event.user}>! How can I help?`,
    thread_ts: event.ts,
  });
});

// Slash command
app.command('/hello', async ({ command, ack, respond }) => {
  await ack();
  await respond({
    response_type: 'ephemeral',
    text: `Hello <@${command.user_id}>! You said: ${command.text}`,
  });
});

// Interactive button handler
app.action('approve_button', async ({ ack, say, body }) => {
  await ack();
  await say(`<@${body.user.id}> approved the request.`);
});

// Add custom Express routes alongside Slack
receiver.router.get('/health', (_req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

(async () => {
  const port = parseInt(process.env.PORT || '5000', 10);
  await app.start(port);
  console.log(`Slack bot running on port ${port}`);
})();
```

### Configure Slack App Settings

After deploying on Replit, configure your Slack app:

1. **Event Subscriptions** → Request URL: `https://your-app.replit.app/slack/events`
2. **Interactivity & Shortcuts** → Request URL: `https://your-app.replit.app/slack/events`
3. **Slash Commands** → Request URL for each command: `https://your-app.replit.app/slack/events`

All three use the same endpoint because Bolt routes internally based on payload type.

## Quick Start — Socket Mode (Development)

Use Socket Mode when you need to develop locally or your app runs behind a firewall. No public URL required.

```typescript
import { App } from '@slack/bolt';

const app = new App({
  token: process.env.SLACK_BOT_TOKEN!,
  appToken: process.env.SLACK_APP_TOKEN!,
  socketMode: true,
});

app.message('hello', async ({ message, say }) => {
  await say(`Hey there <@${message.user}>!`);
});

(async () => {
  await app.start();
  console.log('Slack bot running in Socket Mode');
})();
```

## Core Operations

### Send a Message

```typescript
await app.client.chat.postMessage({
  token: process.env.SLACK_BOT_TOKEN,
  channel: 'C0123456789',
  text: 'Hello from the bot!',
});
```

### Send a Rich Message with Block Kit

```typescript
await app.client.chat.postMessage({
  token: process.env.SLACK_BOT_TOKEN,
  channel: 'C0123456789',
  text: 'New deployment completed',
  blocks: [
    {
      type: 'header',
      text: { type: 'plain_text', text: 'Deployment Status' },
    },
    {
      type: 'section',
      fields: [
        { type: 'mrkdwn', text: '*Environment:*\nProduction' },
        { type: 'mrkdwn', text: '*Status:*\nSuccess' },
      ],
    },
    {
      type: 'actions',
      elements: [
        {
          type: 'button',
          text: { type: 'plain_text', text: 'View Logs' },
          url: 'https://your-app.replit.app/logs',
          action_id: 'view_logs',
        },
      ],
    },
  ],
});
```

### Reply in a Thread

```typescript
await app.client.chat.postMessage({
  token: process.env.SLACK_BOT_TOKEN,
  channel: 'C0123456789',
  text: 'This is a threaded reply',
  thread_ts: '1705612345.123456',
});
```

### Send an Ephemeral Message (Visible to One User)

```typescript
await app.client.chat.postEphemeral({
  token: process.env.SLACK_BOT_TOKEN,
  channel: 'C0123456789',
  user: 'U0123456789',
  text: 'Only you can see this message.',
});
```

### Update an Existing Message

```typescript
await app.client.chat.update({
  token: process.env.SLACK_BOT_TOKEN,
  channel: 'C0123456789',
  ts: '1705612345.123456',
  text: 'Updated message content',
});
```

### Send via Incoming Webhook

```typescript
import axios from 'axios';

await axios.post(process.env.SLACK_WEBHOOK_URL!, {
  text: 'Alert: Server CPU above 90%',
  blocks: [
    {
      type: 'section',
      text: {
        type: 'mrkdwn',
        text: '*Alert:* Server CPU usage is above 90%',
      },
    },
  ],
});
```

### Handle Slash Commands

```typescript
app.command('/status', async ({ command, ack, respond }) => {
  await ack(); // Must acknowledge within 3 seconds

  // For quick responses, respond immediately
  await respond({
    response_type: 'in_channel',
    text: `System status: All services operational`,
  });
});

// For slow operations, acknowledge first, then use response_url
app.command('/report', async ({ command, ack, respond }) => {
  await ack(); // Acknowledge immediately

  // Do expensive work asynchronously
  const report = await generateReport(command.text);

  await respond({
    response_type: 'ephemeral',
    text: report,
  });
});
```

### Listen to Events

```typescript
// When bot is mentioned
app.event('app_mention', async ({ event, say }) => {
  await say(`Thanks for mentioning me, <@${event.user}>!`);
});

// When a new message is posted
app.event('message', async ({ event, say }) => {
  if (event.subtype) return; // Ignore message edits, deletes, etc.
  if (event.bot_id) return;  // Ignore bot messages to prevent loops

  if (event.text?.toLowerCase().includes('help')) {
    await say({
      text: 'Here are some things I can help with...',
      thread_ts: event.ts,
    });
  }
});

// When someone joins a channel
app.event('member_joined_channel', async ({ event, client }) => {
  await client.chat.postMessage({
    channel: event.channel,
    text: `Welcome to the channel, <@${event.user}>!`,
  });
});
```

### Open a Modal

```typescript
app.command('/feedback', async ({ ack, body, client }) => {
  await ack();

  await client.views.open({
    trigger_id: body.trigger_id,
    view: {
      type: 'modal',
      callback_id: 'feedback_modal',
      title: { type: 'plain_text', text: 'Submit Feedback' },
      submit: { type: 'plain_text', text: 'Submit' },
      close: { type: 'plain_text', text: 'Cancel' },
      blocks: [
        {
          type: 'input',
          block_id: 'feedback_input',
          label: { type: 'plain_text', text: 'Your feedback' },
          element: {
            type: 'plain_text_input',
            action_id: 'feedback_text',
            multiline: true,
            placeholder: { type: 'plain_text', text: 'Tell us what you think...' },
          },
        },
        {
          type: 'input',
          block_id: 'rating_input',
          label: { type: 'plain_text', text: 'Rating' },
          element: {
            type: 'static_select',
            action_id: 'rating_select',
            options: [
              { text: { type: 'plain_text', text: 'Excellent' }, value: '5' },
              { text: { type: 'plain_text', text: 'Good' }, value: '4' },
              { text: { type: 'plain_text', text: 'Average' }, value: '3' },
              { text: { type: 'plain_text', text: 'Poor' }, value: '2' },
              { text: { type: 'plain_text', text: 'Terrible' }, value: '1' },
            ],
          },
        },
      ],
    },
  });
});

// Handle modal submission
app.view('feedback_modal', async ({ ack, body, view, client }) => {
  await ack();

  const feedback = view.state.values.feedback_input.feedback_text.value;
  const rating = view.state.values.rating_input.rating_select.selected_option?.value;
  const userId = body.user.id;

  await client.chat.postMessage({
    channel: 'C_FEEDBACK_CHANNEL',
    text: `New feedback from <@${userId}>:\nRating: ${rating}/5\n${feedback}`,
  });
});
```

### Publish App Home Tab

```typescript
app.event('app_home_opened', async ({ event, client }) => {
  await client.views.publish({
    user_id: event.user,
    view: {
      type: 'home',
      blocks: [
        {
          type: 'header',
          text: { type: 'plain_text', text: 'Welcome to My App' },
        },
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: 'Here is your personalized dashboard.',
          },
        },
        { type: 'divider' },
        {
          type: 'section',
          text: { type: 'mrkdwn', text: '*Quick Actions*' },
        },
        {
          type: 'actions',
          elements: [
            {
              type: 'button',
              text: { type: 'plain_text', text: 'Create Report' },
              action_id: 'create_report',
              style: 'primary',
            },
            {
              type: 'button',
              text: { type: 'plain_text', text: 'View Settings' },
              action_id: 'view_settings',
            },
          ],
        },
      ],
    },
  });
});
```

### Channel Operations

```typescript
// List channels
const result = await app.client.conversations.list({
  token: process.env.SLACK_BOT_TOKEN,
  types: 'public_channel,private_channel',
  limit: 100,
});

// Create a channel
const channel = await app.client.conversations.create({
  token: process.env.SLACK_BOT_TOKEN,
  name: 'project-updates',
  is_private: false,
});

// Invite users to a channel
await app.client.conversations.invite({
  token: process.env.SLACK_BOT_TOKEN,
  channel: 'C0123456789',
  users: 'U0123456789,U9876543210',
});

// Set channel topic
await app.client.conversations.setTopic({
  token: process.env.SLACK_BOT_TOKEN,
  channel: 'C0123456789',
  topic: 'Daily standups and project updates',
});
```

### User Operations

```typescript
// Get user info
const userInfo = await app.client.users.info({
  token: process.env.SLACK_BOT_TOKEN,
  user: 'U0123456789',
});

// List all users
const users = await app.client.users.list({
  token: process.env.SLACK_BOT_TOKEN,
});

// Look up user by email
const user = await app.client.users.lookupByEmail({
  token: process.env.SLACK_BOT_TOKEN,
  email: 'alice@example.com',
});
```

### File Upload

```typescript
const result = await app.client.filesUploadV2({
  token: process.env.SLACK_BOT_TOKEN,
  channel_id: 'C0123456789',
  file: './report.pdf',
  filename: 'monthly-report.pdf',
  title: 'Monthly Report - January 2025',
  initial_comment: 'Here is the monthly report.',
});
```

### Reactions

```typescript
// Add a reaction
await app.client.reactions.add({
  token: process.env.SLACK_BOT_TOKEN,
  channel: 'C0123456789',
  timestamp: '1705612345.123456',
  name: 'white_check_mark',
});
```

## Replit Deployment

### App Manifest for Quick Setup

Use this manifest to create a Slack app pre-configured for Replit:

```yaml
_metadata:
  major_version: 2
  minor_version: 1

display_information:
  name: My Replit Bot
  description: A Slack bot powered by Replit

features:
  bot_user:
    display_name: ReplitBot
    always_online: true
  app_home:
    home_tab_enabled: true
    messages_tab_enabled: true
  slash_commands:
    - command: /hello
      url: https://your-app.replit.app/slack/events
      description: Say hello
      should_escape: false

oauth_config:
  scopes:
    bot:
      - app_mentions:read
      - chat:write
      - chat:write.public
      - commands
      - channels:read
      - users:read
      - reactions:write

settings:
  event_subscriptions:
    request_url: https://your-app.replit.app/slack/events
    bot_events:
      - app_mention
      - app_home_opened
      - message.channels
  interactivity:
    is_enabled: true
    request_url: https://your-app.replit.app/slack/events
  org_deploy_enabled: false
  socket_mode_enabled: false
```

### Deployment Steps

1. Create your Slack app at https://api.slack.com/apps using the manifest above
2. Replace `your-app.replit.app` with your actual Replit deployment URL
3. Install the app to your workspace and copy the Bot Token
4. Add secrets to Replit: `SLACK_BOT_TOKEN`, `SLACK_SIGNING_SECRET`
5. Deploy via Replit's publish feature (Reserved VM recommended for always-on bots)
6. Update the Request URLs in Slack app settings to match your deployed URL

### Important Replit Considerations

- **Port**: Bind your server to `0.0.0.0:5000` — this is the only port exposed by Replit
- **URL**: Your deployed URL is `https://your-app.replit.app` — use this for all Slack Request URLs
- **Always On**: Use Reserved VM deployment for bots that need 24/7 availability
- **Secrets**: Store all tokens as Replit Secrets, never hardcode them
- **Health Check**: Add a `/health` endpoint for monitoring uptime

## Error Handling

```typescript
app.error(async (error) => {
  console.error('Slack app error:', error);
});

// Handle rate limiting
try {
  await app.client.chat.postMessage({ channel, text });
} catch (error: any) {
  if (error.code === 'slack_webapi_rate_limited') {
    const retryAfter = error.headers?.['retry-after'] || 1;
    console.log(`Rate limited. Retrying after ${retryAfter}s`);
    await new Promise((r) => setTimeout(r, retryAfter * 1000));
    // Retry the request
  }
}
```

## Token Types Reference

| Token | Prefix | Purpose | Expiry |
|-------|--------|---------|--------|
| Bot Token | `xoxb-` | App identity, messaging, events | Never |
| User Token | `xoxp-` | Act on behalf of a user | Never |
| App-Level Token | `xapp-` | Socket Mode connections | Never |
| Webhook URL | `https://hooks.slack.com/...` | One-way message posting | Never |

## Common Scopes Quick Reference

| Task | Required Scopes |
|------|----------------|
| Send messages | `chat:write` |
| Send to any channel | `chat:write.public` |
| Read channel messages | `channels:history` |
| Listen for mentions | `app_mentions:read` |
| Slash commands | `commands` |
| List channels | `channels:read` |
| User info | `users:read` |
| Upload files | `files:write` |
| Add reactions | `reactions:write` |
| Manage channels | `channels:manage` |
| DMs | `im:read`, `im:history`, `im:write` |
