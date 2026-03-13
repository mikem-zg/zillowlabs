---
name: slack-integration
description: Build Slack integrations with Replit apps using the Bolt SDK for Node.js. Send messages, handle slash commands, listen to events, create interactive Block Kit UIs, open modals, manage channels/users, post webhook notifications, build App Home dashboards, and deploy on Replit with HTTP or Socket Mode. Use when building Slack bots, sending Slack messages, handling slash commands, creating Block Kit UIs, or setting up Slack event listeners.
---

## Overview

Build Slack integrations for Replit applications using the official Bolt SDK for Node.js. This skill covers the complete Slack platform — from sending simple messages to building interactive bots with slash commands, Block Kit UIs, modals, App Home dashboards, and Workflow Builder custom steps.

**Recommended approach:** Use Socket Mode as the default. It requires no public URL, no request URL configuration, and works immediately in both development and production. HTTP mode is available when you need to share the Express server with other routes or integrate with external webhooks.

📋 **API Reference**: [reference/api-reference.md](reference/api-reference.md)
🧱 **Block Kit Guide**: [reference/block-kit.md](reference/block-kit.md)
⚡ **Events & Interactivity**: [reference/events-and-interactivity.md](reference/events-and-interactivity.md)
💡 **Examples**: [examples/common-workflows.md](examples/common-workflows.md)

## Prerequisites

Before building a Slack integration, you need:

1. **A Slack App** created at https://api.slack.com/apps with **Socket Mode enabled**
2. **Bot Token** (`xoxb-...`) — from OAuth & Permissions after installing the app
3. **App-Level Token** (`xapp-...`) — from Basic Information → App-Level Tokens (required for Socket Mode; create with `connections:write` scope)
4. **Signing Secret** — from Basic Information → App Credentials (only needed for HTTP mode)

### Required Environment Variables

```bash
SLACK_BOT_TOKEN=xoxb-your-bot-token
SLACK_APP_TOKEN=xapp-your-app-level-token

# Only for HTTP Mode:
SLACK_SIGNING_SECRET=your-signing-secret

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

## Quick Start — Socket Mode (Recommended)

Socket Mode is the default. No public URL or request URL configuration needed — Slack connects to your app over a WebSocket. Requires an App-Level Token (`xapp-...`).

### Enable Socket Mode in Slack App Settings

1. Go to https://api.slack.com/apps → your app → **Socket Mode** → toggle ON
2. Create an **App-Level Token** with `connections:write` scope (Basic Information → App-Level Tokens)
3. Store the token as `SLACK_APP_TOKEN`

```typescript
import { App } from '@slack/bolt';

const app = new App({
  token: process.env.SLACK_BOT_TOKEN!,
  appToken: process.env.SLACK_APP_TOKEN!,
  socketMode: true,
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

app.message('hello', async ({ message, say }) => {
  await say(`Hey there <@${(message as any).user}>!`);
});

(async () => {
  await app.start();
  console.log('Slack bot running in Socket Mode');
})();
```

## Quick Start — HTTP Mode (Alternative)

Use HTTP mode when you need to share the Express server with other routes or integrate with external webhooks. Requires a public URL and request URL configuration in Slack.

```typescript
import { App, ExpressReceiver } from '@slack/bolt';

const receiver = new ExpressReceiver({
  signingSecret: process.env.SLACK_SIGNING_SECRET!,
  endpoints: '/slack/events',
});

const app = new App({
  token: process.env.SLACK_BOT_TOKEN!,
  receiver,
});

app.event('app_mention', async ({ event, say }) => {
  await say({
    text: `Hey <@${event.user}>! How can I help?`,
    thread_ts: event.ts,
  });
});

app.command('/hello', async ({ command, ack, respond }) => {
  await ack();
  await respond({
    response_type: 'ephemeral',
    text: `Hello <@${command.user_id}>! You said: ${command.text}`,
  });
});

receiver.router.get('/health', (_req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

(async () => {
  const port = parseInt(process.env.PORT || '5000', 10);
  await app.start(port);
  console.log(`Slack bot running on port ${port}`);
})();
```

### Configure Slack App for HTTP Mode

After deploying on Replit, configure your Slack app:

1. **Event Subscriptions** → Request URL: `https://your-app.replit.app/slack/events`
2. **Interactivity & Shortcuts** → Request URL: `https://your-app.replit.app/slack/events`
3. **Slash Commands** → Request URL for each command: `https://your-app.replit.app/slack/events`

All three use the same endpoint because Bolt routes internally based on payload type.

## Core Operations

See [references/core-operations.md](references/core-operations.md) for complete code examples covering:
- Sending messages (plain, rich Block Kit, threads, ephemeral, webhooks)
- Updating and deleting messages
- Slash commands with immediate and async responses
- Event listeners (mentions, messages, member joins)
- Modal dialogs with form inputs and submission handling
- App Home tab publishing
- Channel operations (list, create, invite, set topic)
- User operations (info, list, lookup by email)
- File uploads and reactions

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
  socket_mode_enabled: true
```

### Deployment Steps

1. Create your Slack app at https://api.slack.com/apps using the manifest above
2. Enable **Socket Mode** in app settings and create an App-Level Token with `connections:write` scope
3. Install the app to your workspace and copy the Bot Token
4. Add secrets to Replit: `SLACK_BOT_TOKEN`, `SLACK_APP_TOKEN`
5. Deploy via Replit's publish feature (Reserved VM recommended for always-on bots)
6. No request URL configuration needed — Socket Mode connects automatically

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
