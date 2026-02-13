# Slack Web API Reference

Complete reference for the most commonly used Slack Web API methods. All methods use `POST` requests to `https://slack.com/api/{method}` with a Bearer token in the Authorization header.

## Authentication

All API calls require authentication via the `Authorization` header:

```
Authorization: Bearer xoxb-your-bot-token
Content-Type: application/json
```

In Bolt SDK, the token is automatically included. For direct HTTP calls:

```typescript
const response = await fetch('https://slack.com/api/chat.postMessage', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${process.env.SLACK_BOT_TOKEN}`,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    channel: 'C0123456789',
    text: 'Hello!',
  }),
});
```

## Token Types

| Token | Prefix | Use | Scopes |
|-------|--------|-----|--------|
| **Bot Token** | `xoxb-` | Default for apps. Posts as the app, listens to events, manages channels. | Bot token scopes |
| **User Token** | `xoxp-` | Acts on behalf of a specific user. Needed for user-specific actions (e.g., setting status). | User token scopes |
| **App-Level Token** | `xapp-` | Socket Mode WebSocket connections. Generated from Basic Information. | `connections:write` |

**Best practice:** Use bot tokens for everything unless you specifically need user-level actions.

---

## Messaging Methods

### chat.postMessage

Send a message to a channel, DM, or group.

```typescript
const result = await client.chat.postMessage({
  channel: 'C0123456789',       // Channel ID (preferred) or name
  text: 'Hello world',          // Fallback text (required even with blocks)
  blocks: [],                   // Block Kit blocks (optional)
  thread_ts: '1234567890.12345', // Reply in thread (optional)
  unfurl_links: true,           // Expand URL previews (optional)
  unfurl_media: true,           // Expand media URLs (optional)
  mrkdwn: true,                 // Enable markdown (default: true)
});

// Response
result.ts       // Message timestamp (use as message ID)
result.channel  // Channel where message was posted
```

**Required scopes:** `chat:write` (own channels), `chat:write.public` (any public channel)

### chat.postEphemeral

Send a message visible only to one user.

```typescript
await client.chat.postEphemeral({
  channel: 'C0123456789',
  user: 'U0123456789',     // Only this user will see it
  text: 'Only you can see this',
  blocks: [],
});
```

### chat.update

Update a previously sent message.

```typescript
await client.chat.update({
  channel: 'C0123456789',
  ts: '1705612345.123456', // Timestamp of message to update
  text: 'Updated message',
  blocks: [],              // New blocks (replaces existing)
});
```

### chat.delete

Delete a message.

```typescript
await client.chat.delete({
  channel: 'C0123456789',
  ts: '1705612345.123456',
});
```

**Required scope:** `chat:write` (can only delete bot's own messages)

### chat.scheduleMessage

Schedule a message for future delivery.

```typescript
await client.chat.scheduleMessage({
  channel: 'C0123456789',
  text: 'Reminder: standup in 5 minutes',
  post_at: Math.floor(Date.now() / 1000) + 3600, // Unix timestamp, 1 hour from now
});
```

---

## Conversations Methods

The Conversations API is the unified interface for channels, DMs, group DMs, and private channels.

### conversations.list

List all channels accessible to the token.

```typescript
const result = await client.conversations.list({
  types: 'public_channel,private_channel', // Options: public_channel, private_channel, mpim, im
  limit: 200,                               // Max 1000
  exclude_archived: true,
  cursor: '',                               // Pagination cursor
});

// Paginate through all channels
let cursor;
const allChannels = [];
do {
  const page = await client.conversations.list({
    types: 'public_channel',
    limit: 200,
    cursor,
  });
  allChannels.push(...page.channels);
  cursor = page.response_metadata?.next_cursor;
} while (cursor);
```

### conversations.info

Get details about a specific channel.

```typescript
const result = await client.conversations.info({
  channel: 'C0123456789',
  include_num_members: true,
});

// result.channel.name, .topic.value, .purpose.value, .num_members
```

### conversations.history

Fetch message history from a channel.

```typescript
const result = await client.conversations.history({
  channel: 'C0123456789',
  limit: 100,           // Max 1000
  oldest: '1705000000', // Unix timestamp
  newest: '1706000000', // Unix timestamp
  inclusive: true,
});

// result.messages[] — array of message objects
```

### conversations.replies

Fetch all replies in a thread.

```typescript
const result = await client.conversations.replies({
  channel: 'C0123456789',
  ts: '1705612345.123456', // Parent message timestamp
  limit: 200,
});
```

### conversations.members

List members of a channel.

```typescript
const result = await client.conversations.members({
  channel: 'C0123456789',
  limit: 200,
});
// result.members[] — array of user IDs
```

### conversations.create

Create a new channel.

```typescript
const result = await client.conversations.create({
  name: 'project-alpha',   // Must be lowercase, no spaces (use hyphens)
  is_private: false,        // true for private channels
});
// result.channel.id — new channel ID
```

### conversations.invite

Invite users to a channel.

```typescript
await client.conversations.invite({
  channel: 'C0123456789',
  users: 'U111,U222,U333', // Comma-separated user IDs (max 1000)
});
```

### conversations.join

Join a public channel.

```typescript
await client.conversations.join({
  channel: 'C0123456789',
});
```

### conversations.open

Open a DM or multi-person DM.

```typescript
// Open DM with one user
const result = await client.conversations.open({
  users: 'U0123456789',
});

// Open group DM
const result = await client.conversations.open({
  users: 'U111,U222,U333',
});

// result.channel.id — DM channel ID for sending messages
```

### conversations.setTopic

Set a channel's topic.

```typescript
await client.conversations.setTopic({
  channel: 'C0123456789',
  topic: 'Daily standups and sprint updates',
});
```

### conversations.setPurpose

Set a channel's purpose.

```typescript
await client.conversations.setPurpose({
  channel: 'C0123456789',
  purpose: 'Coordination for Project Alpha',
});
```

### conversations.archive

Archive a channel.

```typescript
await client.conversations.archive({
  channel: 'C0123456789',
});
```

### conversations.kick

Remove a user from a channel.

```typescript
await client.conversations.kick({
  channel: 'C0123456789',
  user: 'U0123456789',
});
```

---

## Users Methods

### users.list

List all users in the workspace.

```typescript
const result = await client.users.list({
  limit: 200,
});

// Filter out bots and deleted users
const activeUsers = result.members.filter(
  (u) => !u.is_bot && !u.deleted
);
```

### users.info

Get detailed information about a user.

```typescript
const result = await client.users.info({
  user: 'U0123456789',
});

// result.user.real_name, .profile.email, .profile.display_name, .tz
```

### users.lookupByEmail

Find a user by their email address.

```typescript
const result = await client.users.lookupByEmail({
  email: 'alice@example.com',
});
// result.user.id — Slack user ID
```

**Required scope:** `users:read.email`

### users.conversations

List channels a user is a member of.

```typescript
const result = await client.users.conversations({
  user: 'U0123456789',
  types: 'public_channel,private_channel',
  limit: 200,
});
```

---

## Files Methods

### filesUploadV2

Upload a file to Slack. This is the current recommended method (replaces deprecated `files.upload`).

```typescript
import fs from 'fs';

const result = await client.filesUploadV2({
  channel_id: 'C0123456789',
  file: fs.createReadStream('./report.csv'),
  filename: 'report.csv',
  title: 'Monthly Report',
  initial_comment: 'Here is the latest report.',
});

// Upload content directly (no file on disk)
const result = await client.filesUploadV2({
  channel_id: 'C0123456789',
  content: 'File content as a string',
  filename: 'notes.txt',
  title: 'Meeting Notes',
});
```

### files.info

Get information about a file.

```typescript
const result = await client.files.info({
  file: 'F0123456789',
});
```

### files.list

List files in the workspace.

```typescript
const result = await client.files.list({
  channel: 'C0123456789', // Optional: filter by channel
  types: 'images,pdfs',   // Optional: filter by type
  count: 20,
});
```

---

## Views Methods

### views.open

Open a modal. Requires a `trigger_id` from a user interaction (valid for 3 seconds).

```typescript
await client.views.open({
  trigger_id: body.trigger_id,
  view: {
    type: 'modal',
    callback_id: 'my_modal',
    title: { type: 'plain_text', text: 'Modal Title' },
    submit: { type: 'plain_text', text: 'Submit' },
    close: { type: 'plain_text', text: 'Cancel' },
    private_metadata: JSON.stringify({ key: 'value' }), // Pass state (max 3000 chars)
    blocks: [
      // Input blocks
    ],
  },
});
```

### views.update

Update an existing modal view.

```typescript
await client.views.update({
  view_id: body.view.id,
  hash: body.view.hash,  // Prevents race conditions
  view: {
    type: 'modal',
    callback_id: 'my_modal',
    title: { type: 'plain_text', text: 'Updated Modal' },
    blocks: [/* updated blocks */],
  },
});
```

### views.push

Push a new view onto the modal stack (max 3 views deep).

```typescript
await client.views.push({
  trigger_id: body.trigger_id,
  view: {
    type: 'modal',
    callback_id: 'detail_view',
    title: { type: 'plain_text', text: 'Details' },
    close: { type: 'plain_text', text: 'Back' },
    blocks: [/* detail blocks */],
  },
});
```

### views.publish

Publish or update the App Home tab for a user.

```typescript
await client.views.publish({
  user_id: 'U0123456789',
  view: {
    type: 'home',
    blocks: [/* home tab blocks */],
  },
});
```

---

## Reactions Methods

### reactions.add

Add an emoji reaction to a message.

```typescript
await client.reactions.add({
  channel: 'C0123456789',
  timestamp: '1705612345.123456',
  name: 'thumbsup', // Emoji name without colons
});
```

### reactions.remove

Remove an emoji reaction.

```typescript
await client.reactions.remove({
  channel: 'C0123456789',
  timestamp: '1705612345.123456',
  name: 'thumbsup',
});
```

### reactions.get

Get reactions on a message.

```typescript
const result = await client.reactions.get({
  channel: 'C0123456789',
  timestamp: '1705612345.123456',
  full: true,
});
// result.message.reactions[] — array of { name, users[], count }
```

---

## Auth Methods

### auth.test

Verify your token and get workspace/bot info.

```typescript
const result = await client.auth.test();
// result.url, .team, .user, .team_id, .user_id, .bot_id
```

---

## Rate Limits

Slack enforces per-method, per-workspace, per-app rate limits organized into tiers:

| Tier | Approximate Limit | Example Methods |
|------|-------------------|-----------------|
| Tier 1 | ~1 req/min | `admin.*`, `apps.uninstall` |
| Tier 2 | ~20 req/min | `conversations.list`, `users.list` |
| Tier 3 | ~50 req/min | `chat.postMessage`, `conversations.history` |
| Tier 4 | ~100 req/min | `auth.test`, `conversations.info` |
| Special | Varies | `chat.postMessage`: 1 msg/sec/channel |

### Handling Rate Limits

When rate limited, Slack returns HTTP 429 with a `Retry-After` header:

```typescript
async function callWithRetry(fn: () => Promise<any>, maxRetries = 3): Promise<any> {
  for (let attempt = 0; attempt < maxRetries; attempt++) {
    try {
      return await fn();
    } catch (error: any) {
      if (error.code === 'slack_webapi_rate_limited') {
        const retryAfter = parseInt(error.headers?.['retry-after'] || '1', 10);
        console.warn(`Rate limited. Retrying after ${retryAfter}s (attempt ${attempt + 1})`);
        await new Promise((resolve) => setTimeout(resolve, retryAfter * 1000));
      } else {
        throw error;
      }
    }
  }
  throw new Error('Max retries exceeded');
}
```

### Special Limits

| Method/Area | Limit |
|-------------|-------|
| `chat.postMessage` | 1 message/sec/channel |
| `rtm.connect` | 1 req/min |
| `users.profile.set` | 10/min per user, 30/min per token |
| Events API | 30,000 events/workspace/app per 60 minutes |
| Incoming Webhooks | 1 message/sec |

### Exponential Backoff with Queue

For high-volume operations, use a queue with exponential backoff:

```typescript
class SlackQueue {
  private queue: Array<() => Promise<any>> = [];
  private processing = false;
  private minDelay = 1100; // Slightly over 1 second

  async add<T>(fn: () => Promise<T>): Promise<T> {
    return new Promise((resolve, reject) => {
      this.queue.push(async () => {
        try {
          resolve(await this.executeWithRetry(fn));
        } catch (err) {
          reject(err);
        }
      });
      this.process();
    });
  }

  private async executeWithRetry<T>(
    fn: () => Promise<T>,
    attempt = 0,
    maxAttempts = 5
  ): Promise<T> {
    try {
      return await fn();
    } catch (error: any) {
      if (error.code === 'slack_webapi_rate_limited' && attempt < maxAttempts) {
        const retryAfter = parseInt(error.headers?.['retry-after'] || '1', 10);
        const backoff = retryAfter * 1000 * Math.pow(2, attempt);
        console.warn(`Rate limited. Backing off ${backoff}ms (attempt ${attempt + 1})`);
        await new Promise((r) => setTimeout(r, backoff));
        return this.executeWithRetry(fn, attempt + 1, maxAttempts);
      }
      throw error;
    }
  }

  private async process() {
    if (this.processing) return;
    this.processing = true;

    while (this.queue.length > 0) {
      const task = this.queue.shift()!;
      await task();
      await new Promise((r) => setTimeout(r, this.minDelay));
    }

    this.processing = false;
  }
}

// Usage
const slackQueue = new SlackQueue();

// Send many messages without hitting rate limits
for (const channel of channels) {
  await slackQueue.add(() =>
    client.chat.postMessage({ channel, text: 'Notification' })
  );
}
```

### Bolt Built-in Rate Limit Handling

Bolt SDK has built-in retry logic. Configure it at initialization:

```typescript
const app = new App({
  token: process.env.SLACK_BOT_TOKEN,
  signingSecret: process.env.SLACK_SIGNING_SECRET,
  // Bolt automatically retries on rate limit errors
  // Default: retries up to 10 times with exponential backoff
});
```

---

## Pagination

Many list methods use cursor-based pagination:

```typescript
async function paginateAll(method: string, params: any): Promise<any[]> {
  const results: any[] = [];
  let cursor: string | undefined;

  do {
    const response = await client[method]({
      ...params,
      cursor,
      limit: 200,
    });

    // Collect results (key varies by method)
    if (response.channels) results.push(...response.channels);
    if (response.members) results.push(...response.members);
    if (response.messages) results.push(...response.messages);

    cursor = response.response_metadata?.next_cursor;
  } while (cursor);

  return results;
}

// Usage
const allChannels = await paginateAll('conversations.list', {
  types: 'public_channel',
});
```

---

## Error Handling

All Slack API responses include an `ok` field:

```typescript
const result = await client.chat.postMessage({
  channel: 'C0123456789',
  text: 'Hello',
});

if (!result.ok) {
  console.error('Error:', result.error);
  // Common errors:
  // 'channel_not_found' — invalid channel ID
  // 'not_in_channel' — bot not invited to channel
  // 'invalid_auth' — bad token
  // 'missing_scope' — need additional OAuth scopes
  // 'rate_limited' — too many requests
}
```

### Common Error Codes

| Error | Meaning | Fix |
|-------|---------|-----|
| `channel_not_found` | Invalid channel ID | Verify channel ID with `conversations.list` |
| `not_in_channel` | Bot not in the channel | Invite bot with `/invite @BotName` or `conversations.join` |
| `invalid_auth` | Token is invalid or expired | Check `SLACK_BOT_TOKEN` value |
| `missing_scope` | Token lacks required permission | Add scope in OAuth & Permissions, reinstall app |
| `rate_limited` | Too many requests | Wait `Retry-After` seconds and retry |
| `no_text` | Message has no text | Include `text` field even when using blocks |
| `msg_too_long` | Message exceeds 40,000 chars | Shorten message or split into multiple |
| `is_archived` | Channel is archived | Unarchive or use different channel |
| `user_not_found` | Invalid user ID | Verify user ID with `users.list` |
| `trigger_expired` | Trigger ID older than 3 seconds | Open modal faster after interaction |
| `account_inactive` | Token owner deactivated | Reinstall app or use new token |
| `token_revoked` | Token has been revoked | Reinstall app to get new token |
| `request_timeout` | Slack did not respond in time | Retry the request |

### Bolt Global Error Handler

Register a global error handler to catch all unhandled errors in Bolt:

```typescript
app.error(async (error) => {
  if (error.code === 'slack_webapi_platform_error') {
    console.error('Slack API error:', error.data);
  } else if (error.code === 'slack_webapi_rate_limited') {
    console.warn('Rate limited — Bolt will retry automatically');
  } else {
    console.error('Unexpected error:', error);
  }
});
```

### Graceful Error Handling Pattern

Wrap handlers in try/catch to prevent silent failures:

```typescript
app.command('/report', async ({ ack, respond, command }) => {
  await ack();

  try {
    const report = await generateReport(command.text);
    await respond({ response_type: 'ephemeral', text: report });
  } catch (error) {
    console.error('Report generation failed:', error);
    await respond({
      response_type: 'ephemeral',
      text: ':warning: Something went wrong generating the report. Please try again.',
    });
  }
});

app.action('risky_action', async ({ ack, body, client }) => {
  await ack();

  try {
    await performRiskyOperation();
    await client.chat.postEphemeral({
      channel: body.channel!.id,
      user: body.user.id,
      text: ':white_check_mark: Operation completed successfully.',
    });
  } catch (error) {
    await client.chat.postEphemeral({
      channel: body.channel!.id,
      user: body.user.id,
      text: ':x: Operation failed. Please try again or contact support.',
    });
  }
});
```

### Process-Level Error Handling

Prevent the app from crashing on unhandled errors:

```typescript
process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled promise rejection:', reason);
});

process.on('uncaughtException', (error) => {
  console.error('Uncaught exception:', error);
  process.exit(1);
});
```

---

## Message Formatting (mrkdwn)

Slack uses its own markdown variant called `mrkdwn`:

| Format | Syntax | Result |
|--------|--------|--------|
| Bold | `*bold*` | **bold** |
| Italic | `_italic_` | _italic_ |
| Strikethrough | `~strike~` | ~~strike~~ |
| Code | `` `code` `` | `code` |
| Code block | ` ```code block``` ` | Code block |
| Link | `<https://example.com\|Link text>` | [Link text](https://example.com) |
| User mention | `<@U0123456789>` | @username |
| Channel link | `<#C0123456789>` | #channel |
| Emoji | `:thumbsup:` | :thumbsup: |
| Blockquote | `> quoted text` | Blockquote |
| Ordered list | `1. item` | 1. item |
| Unordered list | `• item` or `- item` | - item |
