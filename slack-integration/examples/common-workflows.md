# Slack Integration — Common Workflows

End-to-end examples for building Slack integrations on Replit.

---

## 1. Notification Bot (CI/CD Alerts)

A bot that sends deployment notifications to a Slack channel with status, links, and action buttons.

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

// Express endpoint for your CI/CD to call
receiver.router.post('/api/deploy-notify', async (req, res) => {
  const { environment, version, status, commitUrl, deployer } = req.body;

  const statusEmoji = status === 'success' ? ':white_check_mark:' : ':x:';
  const statusText = status === 'success' ? 'Succeeded' : 'Failed';
  const buttonStyle = status === 'success' ? undefined : 'danger';

  await app.client.chat.postMessage({
    token: process.env.SLACK_BOT_TOKEN,
    channel: process.env.DEPLOY_CHANNEL_ID!,
    text: `Deployment ${statusText}: ${version} to ${environment}`,
    blocks: [
      {
        type: 'header',
        text: {
          type: 'plain_text',
          text: `${statusEmoji} Deployment ${statusText}`,
        },
      },
      {
        type: 'section',
        fields: [
          { type: 'mrkdwn', text: `*Environment:*\n${environment}` },
          { type: 'mrkdwn', text: `*Version:*\n${version}` },
          { type: 'mrkdwn', text: `*Deployed by:*\n${deployer}` },
          {
            type: 'mrkdwn',
            text: `*Time:*\n<!date^${Math.floor(Date.now() / 1000)}^{date_short_pretty} at {time}|${new Date().toISOString()}>`,
          },
        ],
      },
      {
        type: 'actions',
        elements: [
          {
            type: 'button',
            text: { type: 'plain_text', text: 'View Commit' },
            url: commitUrl,
            action_id: 'view_commit',
          },
          {
            type: 'button',
            text: { type: 'plain_text', text: 'View Logs' },
            url: `https://your-app.replit.app/logs/${version}`,
            action_id: 'view_logs',
            ...(buttonStyle ? { style: buttonStyle } : {}),
          },
        ],
      },
    ],
  });

  res.json({ ok: true });
});

(async () => {
  await app.start(5000);
  console.log('Deploy notification bot running on port 5000');
})();
```

**Usage from CI/CD:**

```bash
curl -X POST https://your-app.replit.app/api/deploy-notify \
  -H 'Content-Type: application/json' \
  -d '{
    "environment": "production",
    "version": "v2.4.1",
    "status": "success",
    "commitUrl": "https://github.com/org/repo/commit/abc123",
    "deployer": "Alice"
  }'
```

---

## 2. Slash Command with Delayed Response

A `/search` command that queries an external API and responds with results.

```typescript
app.command('/search', async ({ command, ack, respond }) => {
  await ack(); // Acknowledge immediately

  if (!command.text) {
    await respond({
      response_type: 'ephemeral',
      text: 'Please provide a search term. Usage: `/search [query]`',
    });
    return;
  }

  try {
    // Simulate slow API call
    const results = await searchExternalAPI(command.text);

    if (results.length === 0) {
      await respond({
        response_type: 'ephemeral',
        text: `No results found for "${command.text}".`,
      });
      return;
    }

    // Build result blocks
    const blocks: any[] = [
      {
        type: 'header',
        text: {
          type: 'plain_text',
          text: `Search Results for "${command.text}"`,
        },
      },
    ];

    for (const result of results.slice(0, 5)) {
      blocks.push(
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: `*<${result.url}|${result.title}>*\n${result.description}`,
          },
          accessory: {
            type: 'button',
            text: { type: 'plain_text', text: 'Open' },
            url: result.url,
            action_id: `open_result_${result.id}`,
          },
        },
        { type: 'divider' }
      );
    }

    blocks.push({
      type: 'context',
      elements: [
        {
          type: 'mrkdwn',
          text: `Found ${results.length} results | Showing top 5 | Searched by <@${command.user_id}>`,
        },
      ],
    });

    await respond({
      response_type: 'in_channel',
      blocks,
      text: `Found ${results.length} results for "${command.text}"`,
    });
  } catch (error) {
    await respond({
      response_type: 'ephemeral',
      text: `Search failed: ${error instanceof Error ? error.message : 'Unknown error'}`,
    });
  }
});

async function searchExternalAPI(query: string) {
  // Replace with your actual API call
  const response = await fetch(
    `https://api.example.com/search?q=${encodeURIComponent(query)}`
  );
  return response.json();
}
```

---

## 3. Interactive Approval Flow with Modals

A complete approval workflow: request submission via modal, approval buttons, status tracking.

```typescript
// Step 1: Open request form via slash command
app.command('/request', async ({ ack, body, client }) => {
  await ack();

  await client.views.open({
    trigger_id: body.trigger_id,
    view: {
      type: 'modal',
      callback_id: 'submit_request',
      title: { type: 'plain_text', text: 'New Request' },
      submit: { type: 'plain_text', text: 'Submit' },
      close: { type: 'plain_text', text: 'Cancel' },
      private_metadata: JSON.stringify({ channel: body.channel_id }),
      blocks: [
        {
          type: 'input',
          block_id: 'type_block',
          label: { type: 'plain_text', text: 'Request type' },
          element: {
            type: 'static_select',
            action_id: 'type_select',
            options: [
              { text: { type: 'plain_text', text: 'Time Off' }, value: 'time_off' },
              { text: { type: 'plain_text', text: 'Equipment' }, value: 'equipment' },
              { text: { type: 'plain_text', text: 'Budget' }, value: 'budget' },
            ],
          },
        },
        {
          type: 'input',
          block_id: 'details_block',
          label: { type: 'plain_text', text: 'Details' },
          element: {
            type: 'plain_text_input',
            action_id: 'details_input',
            multiline: true,
            placeholder: { type: 'plain_text', text: 'Describe your request...' },
          },
        },
        {
          type: 'input',
          block_id: 'approver_block',
          label: { type: 'plain_text', text: 'Approver' },
          element: {
            type: 'users_select',
            action_id: 'approver_select',
          },
        },
        {
          type: 'input',
          block_id: 'urgency_block',
          label: { type: 'plain_text', text: 'Urgency' },
          element: {
            type: 'radio_buttons',
            action_id: 'urgency_radio',
            options: [
              { text: { type: 'plain_text', text: 'Low — no rush' }, value: 'low' },
              { text: { type: 'plain_text', text: 'Medium — within this week' }, value: 'medium' },
              { text: { type: 'plain_text', text: 'High — needed today' }, value: 'high' },
            ],
          },
        },
      ],
    },
  });
});

// Step 2: Handle form submission
app.view('submit_request', async ({ ack, body, view, client }) => {
  await ack();

  const values = view.state.values;
  const requestType = values.type_block.type_select.selected_option!.value;
  const details = values.details_block.details_input.value!;
  const approver = values.approver_block.approver_select.selected_user!;
  const urgency = values.urgency_block.urgency_radio.selected_option!.value;
  const requester = body.user.id;
  const metadata = JSON.parse(view.private_metadata || '{}');

  const requestId = `req_${Date.now()}`;

  // Send approval request to the approver via DM
  const dmResult = await client.conversations.open({ users: approver });

  await client.chat.postMessage({
    channel: dmResult.channel!.id!,
    text: `New ${requestType} request from <@${requester}>`,
    blocks: [
      {
        type: 'header',
        text: { type: 'plain_text', text: `New ${requestType} request` },
      },
      {
        type: 'section',
        fields: [
          { type: 'mrkdwn', text: `*From:*\n<@${requester}>` },
          { type: 'mrkdwn', text: `*Type:*\n${requestType}` },
          { type: 'mrkdwn', text: `*Urgency:*\n${urgency}` },
          {
            type: 'mrkdwn',
            text: `*Submitted:*\n<!date^${Math.floor(Date.now() / 1000)}^{date_short_pretty} at {time}|now>`,
          },
        ],
      },
      {
        type: 'section',
        text: { type: 'mrkdwn', text: `*Details:*\n${details}` },
      },
      {
        type: 'actions',
        block_id: 'approval_actions',
        elements: [
          {
            type: 'button',
            text: { type: 'plain_text', text: 'Approve' },
            style: 'primary',
            action_id: 'approve_request',
            value: JSON.stringify({ requestId, requester, channel: metadata.channel }),
          },
          {
            type: 'button',
            text: { type: 'plain_text', text: 'Deny' },
            style: 'danger',
            action_id: 'deny_request',
            value: JSON.stringify({ requestId, requester, channel: metadata.channel }),
          },
        ],
      },
    ],
  });

  // Confirm to the requester
  if (metadata.channel) {
    await client.chat.postEphemeral({
      channel: metadata.channel,
      user: requester,
      text: `Your ${requestType} request has been sent to <@${approver}> for approval.`,
    });
  }
});

// Step 3: Handle approval/denial
app.action(/^(approve|deny)_request$/, async ({ ack, action, body, client }) => {
  await ack();

  const data = JSON.parse(action.value);
  const isApproved = action.action_id === 'approve_request';
  const statusEmoji = isApproved ? ':white_check_mark:' : ':x:';
  const statusText = isApproved ? 'Approved' : 'Denied';

  // Update the approval message
  await client.chat.update({
    channel: body.channel!.id,
    ts: body.message!.ts,
    text: `Request ${statusText}`,
    blocks: [
      ...body.message!.blocks!.slice(0, 3), // Keep header and details
      {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: `${statusEmoji} *${statusText}* by <@${body.user.id}>`,
        },
      },
    ],
  });

  // Notify the requester
  if (data.channel) {
    await client.chat.postMessage({
      channel: data.channel,
      text: `<@${data.requester}> Your request was ${statusText.toLowerCase()} by <@${body.user.id}>.`,
    });
  }
});
```

---

## 4. App Home Dashboard

A personalized dashboard that shows user-specific data with interactive elements.

```typescript
interface UserStats {
  openTickets: number;
  completedToday: number;
  streak: number;
}

async function buildHomeBlocks(userId: string): Promise<any[]> {
  const stats = await getUserStats(userId);
  const recentActivity = await getRecentActivity(userId);

  return [
    {
      type: 'header',
      text: { type: 'plain_text', text: 'Your Dashboard' },
    },
    {
      type: 'section',
      text: {
        type: 'mrkdwn',
        text: `Hey <@${userId}>! Here's your overview for today.`,
      },
    },
    { type: 'divider' },
    {
      type: 'section',
      fields: [
        { type: 'mrkdwn', text: `:clipboard: *Open Tickets:* ${stats.openTickets}` },
        { type: 'mrkdwn', text: `:white_check_mark: *Completed Today:* ${stats.completedToday}` },
        { type: 'mrkdwn', text: `:fire: *Streak:* ${stats.streak} days` },
      ],
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
          text: { type: 'plain_text', text: 'New Ticket' },
          style: 'primary',
          action_id: 'home_new_ticket',
        },
        {
          type: 'button',
          text: { type: 'plain_text', text: 'My Tickets' },
          action_id: 'home_my_tickets',
        },
        {
          type: 'button',
          text: { type: 'plain_text', text: 'Team Stats' },
          action_id: 'home_team_stats',
        },
      ],
    },
    { type: 'divider' },
    {
      type: 'header',
      text: { type: 'plain_text', text: 'Recent Activity' },
    },
    ...recentActivity.slice(0, 5).map((activity: any) => ({
      type: 'context',
      elements: [
        {
          type: 'mrkdwn',
          text: `${activity.emoji} ${activity.description} — <!date^${activity.timestamp}^{date_short_pretty} at {time}|${new Date(activity.timestamp * 1000).toISOString()}>`,
        },
      ],
    })),
  ];
}

app.event('app_home_opened', async ({ event, client }) => {
  if (event.tab !== 'home') return;

  const blocks = await buildHomeBlocks(event.user);

  await client.views.publish({
    user_id: event.user,
    view: {
      type: 'home',
      blocks,
    },
  });
});

// Handle quick action buttons from Home tab
app.action('home_new_ticket', async ({ ack, body, client }) => {
  await ack();

  await client.views.open({
    trigger_id: body.trigger_id!,
    view: {
      type: 'modal',
      callback_id: 'new_ticket_modal',
      title: { type: 'plain_text', text: 'New Ticket' },
      submit: { type: 'plain_text', text: 'Create' },
      blocks: [
        {
          type: 'input',
          block_id: 'title',
          label: { type: 'plain_text', text: 'Title' },
          element: {
            type: 'plain_text_input',
            action_id: 'title_input',
          },
        },
        {
          type: 'input',
          block_id: 'priority',
          label: { type: 'plain_text', text: 'Priority' },
          element: {
            type: 'static_select',
            action_id: 'priority_select',
            options: [
              { text: { type: 'plain_text', text: 'High' }, value: 'high' },
              { text: { type: 'plain_text', text: 'Medium' }, value: 'medium' },
              { text: { type: 'plain_text', text: 'Low' }, value: 'low' },
            ],
          },
        },
      ],
    },
  });
});
```

---

## 5. Incoming Webhook Alerts

Simple one-way notifications from external services.

```typescript
import axios from 'axios';

const WEBHOOK_URL = process.env.SLACK_WEBHOOK_URL!;

// Server monitoring alert
async function sendServerAlert(
  server: string,
  metric: string,
  value: number,
  threshold: number
) {
  const severity = value > threshold * 1.5 ? 'critical' : 'warning';
  const emoji = severity === 'critical' ? ':rotating_light:' : ':warning:';

  await axios.post(WEBHOOK_URL, {
    text: `${emoji} ${severity.toUpperCase()}: ${server} ${metric} at ${value}%`,
    blocks: [
      {
        type: 'header',
        text: {
          type: 'plain_text',
          text: `${emoji} Server Alert — ${severity.toUpperCase()}`,
        },
      },
      {
        type: 'section',
        fields: [
          { type: 'mrkdwn', text: `*Server:*\n${server}` },
          { type: 'mrkdwn', text: `*Metric:*\n${metric}` },
          { type: 'mrkdwn', text: `*Current:*\n${value}%` },
          { type: 'mrkdwn', text: `*Threshold:*\n${threshold}%` },
        ],
      },
      {
        type: 'context',
        elements: [
          {
            type: 'mrkdwn',
            text: `Triggered at <!date^${Math.floor(Date.now() / 1000)}^{date_short_pretty} at {time}|${new Date().toISOString()}>`,
          },
        ],
      },
    ],
  });
}

// Daily summary
async function sendDailySummary(stats: {
  totalUsers: number;
  newSignups: number;
  revenue: number;
  errors: number;
}) {
  await axios.post(WEBHOOK_URL, {
    text: 'Daily Summary',
    blocks: [
      {
        type: 'header',
        text: { type: 'plain_text', text: ':bar_chart: Daily Summary' },
      },
      {
        type: 'section',
        fields: [
          { type: 'mrkdwn', text: `*Total Users:*\n${stats.totalUsers.toLocaleString()}` },
          { type: 'mrkdwn', text: `*New Signups:*\n+${stats.newSignups}` },
          {
            type: 'mrkdwn',
            text: `*Revenue:*\n$${stats.revenue.toLocaleString()}`,
          },
          {
            type: 'mrkdwn',
            text: `*Errors:*\n${stats.errors} ${stats.errors > 10 ? ':warning:' : ':white_check_mark:'}`,
          },
        ],
      },
    ],
  });
}
```

---

## 6. Complete Replit Deployment Example

Full Express + Bolt app structure for Replit deployment.

```typescript
// server.ts
import { App, ExpressReceiver } from '@slack/bolt';

// Create ExpressReceiver for HTTP mode
const receiver = new ExpressReceiver({
  signingSecret: process.env.SLACK_SIGNING_SECRET!,
  endpoints: '/slack/events',
});

// Initialize Bolt app
const app = new App({
  token: process.env.SLACK_BOT_TOKEN!,
  receiver,
});

// --- Health check ---
receiver.router.get('/health', (_req, res) => {
  res.json({
    status: 'ok',
    uptime: process.uptime(),
    timestamp: new Date().toISOString(),
  });
});

// --- Your API routes alongside Slack ---
receiver.router.get('/api/status', (_req, res) => {
  res.json({ botStatus: 'running', connectedWorkspaces: 1 });
});

// --- Slack event handlers ---
app.event('app_mention', async ({ event, say }) => {
  await say({
    text: `Hey <@${event.user}>! I'm running on Replit.`,
    thread_ts: event.ts,
  });
});

app.command('/ping', async ({ ack, respond }) => {
  await ack();
  await respond({
    response_type: 'ephemeral',
    text: `:ping_pong: Pong! Bot latency: ${Math.round(process.uptime())}s uptime`,
  });
});

// --- Error handling ---
app.error(async (error) => {
  console.error('Slack app error:', error);
});

process.on('unhandledRejection', (reason) => {
  console.error('Unhandled promise rejection:', reason);
});

// --- Start ---
(async () => {
  const port = parseInt(process.env.PORT || '5000', 10);
  await app.start(port);
  console.log(`Slack bot running on port ${port}`);
  console.log(`Health check: http://0.0.0.0:${port}/health`);
  console.log(`Slack events: http://0.0.0.0:${port}/slack/events`);
})();
```

### App Manifest (for Quick Setup)

Save this as `slack-manifest.yaml` and use it to create your Slack app:

```yaml
_metadata:
  major_version: 2
  minor_version: 1

display_information:
  name: My Replit Bot
  description: A Slack bot powered by Replit
  background_color: "#4A154B"

features:
  bot_user:
    display_name: ReplitBot
    always_online: true
  app_home:
    home_tab_enabled: true
    messages_tab_enabled: true
    messages_tab_read_only_enabled: false
  slash_commands:
    - command: /ping
      url: https://YOUR-APP.replit.app/slack/events
      description: Check if the bot is alive
      should_escape: false
    - command: /search
      url: https://YOUR-APP.replit.app/slack/events
      description: Search for something
      usage_hint: "[search query]"
      should_escape: false

oauth_config:
  scopes:
    bot:
      - app_mentions:read
      - chat:write
      - chat:write.public
      - commands
      - channels:read
      - channels:history
      - users:read
      - reactions:write
      - files:write

settings:
  event_subscriptions:
    request_url: https://YOUR-APP.replit.app/slack/events
    bot_events:
      - app_mention
      - app_home_opened
      - message.channels
  interactivity:
    is_enabled: true
    request_url: https://YOUR-APP.replit.app/slack/events
  org_deploy_enabled: false
  socket_mode_enabled: false
```

### Deployment Checklist

1. Create Slack app using the manifest above at https://api.slack.com/apps
2. Replace `YOUR-APP.replit.app` with your actual Replit deployment URL
3. Install app to workspace and copy Bot Token (`xoxb-...`)
4. Copy Signing Secret from Basic Information → App Credentials
5. Add secrets in Replit: `SLACK_BOT_TOKEN`, `SLACK_SIGNING_SECRET`
6. Deploy via Replit publish (use Reserved VM for always-on bots)
7. Update Request URLs in Slack if your deployment URL changes
8. Invite bot to channels: `/invite @ReplitBot`

### Environment Variables

```bash
# Required
SLACK_BOT_TOKEN=xoxb-...         # OAuth & Permissions → Bot User OAuth Token
SLACK_SIGNING_SECRET=...          # Basic Information → App Credentials → Signing Secret

# Optional
SLACK_APP_TOKEN=xapp-...          # Only for Socket Mode
SLACK_WEBHOOK_URL=https://hooks.. # Only for incoming webhooks
DEPLOY_CHANNEL_ID=C...            # Channel for deploy notifications
PORT=5000                         # Server port (default: 5000 for Replit)
```
