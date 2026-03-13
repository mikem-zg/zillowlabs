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

