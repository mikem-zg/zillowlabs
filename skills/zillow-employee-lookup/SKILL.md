---
name: zillow-employee-lookup
description: Look up Zillow employees by name, title, team, or expertise using Glean MCP or Slack API. Supports @ mention formatting, ZallWall profile deep links, Slack profile photo lookup via workspace directory cache, and Constellation UI components (Combobox, Avatar, Tag, AssistChip) for building employee search and selection interfaces.
---

# Zillow Employee Lookup

Search for Zillow Group employees using Glean MCP tools or the Slack Web API. Produces @ mention formatting for Slack/docs, ZallWall profile deep links, Slack profile photos via workspace directory cache, and Constellation-based UI patterns for employee typeahead, selection, and display.

## When to Use

- "Who owns this service?"
- "Find the PM for [project]"
- "Who is on the [team name] team?"
- "Look up [person name]"
- "@ mention [person]"
- "Who should I talk to about [topic]?"
- "Find the tech lead for [area]"
- "Get me [person]'s ZallWall profile"
- "Add an employee picker to this form"
- "Build a people search component"
- "I need an @ mention input"
- "Show team members with avatars"
- When building UI that references or selects Zillow employees
- When you need to tag or mention someone in generated output

## Prerequisites

| Requirement | Details |
|-------------|---------|
| **Glean MCP** | `mcp__glean-tools__search` and `mcp__glean-tools__employee_search` must be available |
| **Constellation** | `@zillow/constellation` installed for UI component patterns |
| **Network** | Access to `zallwall.zillowgroup.com` for profile links (requires Zillow VPN/SSO) |

## Employee Lookup via Glean MCP

### Search by Name

```
mcp__glean-tools__employee_search({
  query: "Jane Smith"
})
```

### Search by Role or Team

```
mcp__glean-tools__search({
  query: "tech lead premier agent platform",
  datasource: "people"
})
```

### Search by Expertise

```
mcp__glean-tools__employee_search({
  query: "constellation design system maintainer"
})
```

### Find Service Owners

```
mcp__glean-tools__search({
  query: "owner of zestimate service",
  datasource: "people"
})
```

## Output Formatting

### @ Mention Format

Always format employee references as `@FirstName LastName` for use in Slack messages, Google Docs, code review comments, and generated documentation.

| Context | Format | Example |
|---------|--------|---------|
| Inline text | `@FirstName LastName` | @Jane Smith |
| With title | `@FirstName LastName (Title)` | @Jane Smith (Staff Engineer) |
| With team | `@FirstName LastName — Team Name` | @Jane Smith — Premier Agent Platform |

### ZallWall Profile Links

ZallWall is Zillow's internal employee profile system. Profile URLs use a short username (not the email prefix). The format is:

```
https://zallwall.zillowgroup.com/{username}
```

Where `{username}` is the person's ZallWall short handle (e.g., `mikep` for Mike Payne). This is **not** always the email prefix — you must look it up via Glean or ask the user.

| Person | ZallWall URL |
|--------|-------------|
| Mike Payne | `https://zallwall.zillowgroup.com/mikep` |

If the username is unknown, link to the search page:

```
https://zallwall.zillowgroup.com/search?q={Full+Name}
```

### Slack Profile Links

Link directly to an employee's Slack DM channel using the `/archives/{CHANNEL_ID}` pattern:

```
https://zillowgroup.enterprise.slack.com/archives/{DM_CHANNEL_ID}
```

Where `{DM_CHANNEL_ID}` is the direct message channel ID (starts with `D`). For example:

| Person | Slack DM URL |
|--------|-------------|
| Mike Payne | `https://zillowgroup.enterprise.slack.com/archives/DCXV0BUVD` |

You can also link to a user's profile page if you have their member ID (`UXXXXXXX`):

```
https://zillowgroup.enterprise.slack.com/team/{SLACK_MEMBER_ID}
```

**Tip:** If you don't have the channel or member ID, ask the user or look it up via Glean.

### Markdown Output

When producing employee references in markdown (docs, PRDs, Confluence):

```markdown
**Owner:** [@Jane Smith](https://zallwall.zillowgroup.com/{username}) (Staff Engineer, Premier Agent Platform)
· [Slack](https://zillowgroup.enterprise.slack.com/archives/{DM_CHANNEL_ID})
· [ZallWall](https://zallwall.zillowgroup.com/{username})
```

## Constellation UI Components

Use these patterns when building employee-facing UI in React with Constellation.

### Employee Search with Combobox

Use `Combobox` for typeahead employee search. Provide `renderAdornment` with a search icon for discoverability.

```tsx
import { Combobox, Icon, FormField, Label } from '@zillow/constellation';
import { IconSearchFilled, IconUserFilled } from '@zillow/constellation-icons';

function EmployeeSearch({ employees, onSelect }) {
  const options = employees.map((emp) => ({
    label: emp.name,
    value: emp.email,
    meta: emp.title,
    icon: <Icon render={<IconUserFilled />} />,
  }));

  return (
    <FormField
      label={<Label>Assign to</Label>}
      control={
        <Combobox
          options={options}
          placeholder="Search by name or title"
          showLabelForValue
          onChange={(value) => onSelect(value)}
          renderAdornment={(adornmentProps) => (
            <Combobox.Adornment {...adornmentProps}>
              <Icon render={<IconSearchFilled />} />
            </Combobox.Adornment>
          )}
          renderEmptyState={(emptyStateProps) => (
            <Combobox.EmptyState {...emptyStateProps}>
              No employees found
            </Combobox.EmptyState>
          )}
        />
      }
    />
  );
}
```

### Multi-Select Employee Picker

Use `Combobox` with an array `value` for selecting multiple employees. Constellation's `Combobox` automatically supports multi-select when the value is an array — chips appear for each selection.

```tsx
import { Combobox, Icon, FormField, Label } from '@zillow/constellation';
import { IconSearchFilled, IconUserFilled } from '@zillow/constellation-icons';

function TeamMemberPicker({ employees, selected, onChange }) {
  const options = employees.map((emp) => ({
    label: emp.name,
    value: emp.email,
    meta: emp.title,
    icon: <Icon render={<IconUserFilled />} />,
  }));

  return (
    <FormField
      label={<Label>Team members</Label>}
      control={
        <Combobox
          options={options}
          value={selected}
          onChange={onChange}
          placeholder="Add team members"
          showLabelForValue
          limitChipsShown={3}
          renderAdornment={(adornmentProps) => (
            <Combobox.Adornment {...adornmentProps}>
              <Icon render={<IconSearchFilled />} />
            </Combobox.Adornment>
          )}
        />
      }
    />
  );
}
```

### Employee Display with Avatar

Use `Avatar` to show employee photos or initials alongside their name and title.

```tsx
import { Avatar, Text, Anchor } from '@zillow/constellation';
import { Flex } from '@/styled-system/jsx';

function EmployeeCard({ name, title, photoUrl, zallwallUsername, slackChannelId }) {
  const zallwallUrl = `https://zallwall.zillowgroup.com/${zallwallUsername}`;
  const slackUrl = `https://zillowgroup.enterprise.slack.com/archives/${slackChannelId}`;

  return (
    <Flex gap="300" alignItems="center">
      <Avatar
        size="md"
        src={photoUrl}
        fullName={name}
        aria-hidden
      />
      <Flex direction="column" gap="100">
        <Anchor href={zallwallUrl} target="_blank">
          <Text textStyle="body-bold">{name}</Text>
        </Anchor>
        <Text textStyle="body-sm" css={{ color: 'text.subtle' }}>{title}</Text>
        <Flex gap="200">
          <Anchor href={slackUrl} target="_blank">
            <Text textStyle="body-sm">Slack</Text>
          </Anchor>
          <Anchor href={zallwallUrl} target="_blank">
            <Text textStyle="body-sm">ZallWall</Text>
          </Anchor>
        </Flex>
      </Flex>
    </Flex>
  );
}
```

### @ Mention Tag

Use `Tag` with an icon to render inline @ mentions. Default size is required when using the `icon` prop.

```tsx
import { Tag } from '@zillow/constellation';
import { IconUserFilled } from '@zillow/constellation-icons';
import { Flex } from '@/styled-system/jsx';

function MentionTag({ name, onClick }) {
  return (
    <Flex css={{ alignSelf: 'flex-start' }}>
      <Tag
        icon={<IconUserFilled />}
        css={{ whiteSpace: 'nowrap', cursor: 'pointer' }}
        onClick={onClick}
      >
        {name}
      </Tag>
    </Flex>
  );
}
```

**Important:** The `icon` prop only works on the default (large) `Tag` size. Using `size="sm"` with `icon` will not render the icon.

### Employee AssistChip with Avatar

Use `AssistChip` with the composed avatar pattern for quick-action employee references (e.g., "Email Jane", "Slack Mike").

```tsx
import { AssistChip, Avatar } from '@zillow/constellation';

function EmployeeChip({ name, photoUrl, action, onClick }) {
  return (
    <AssistChip.Root onClick={onClick}>
      <AssistChip.Avatar>
        <Avatar src={photoUrl} alt={name} />
      </AssistChip.Avatar>
      <AssistChip.Label>{action} {name}</AssistChip.Label>
    </AssistChip.Root>
  );
}
```

### Employee ChipGroup

Use `ChipGroup` with `AssistChip` to display a row of employee references.

```tsx
import { AssistChip, Avatar, ChipGroup } from '@zillow/constellation';

function TeamChips({ members, onMemberClick }) {
  return (
    <ChipGroup aria-label="Team members">
      {members.map((member) => (
        <AssistChip.Root key={member.email} onClick={() => onMemberClick(member)}>
          <AssistChip.Avatar>
            <Avatar src={member.photoUrl} alt={member.name} />
          </AssistChip.Avatar>
          <AssistChip.Label>{member.name}</AssistChip.Label>
        </AssistChip.Root>
      ))}
    </ChipGroup>
  );
}
```

## Slack API Employee Lookup

Use the Slack Web API as a programmatic source for employee profile photos and Slack user IDs. This is useful when Glean MCP is unavailable or when you need profile photos for contributor chips, avatars, or team displays.

**Required secret:** `SLACK_BOT_TOKEN` (needs `users:read` scope)

### Load and Cache Workspace Directory

Fetch the full Slack workspace user list on startup and cache it for fast name-based lookups. This avoids repeated API calls and provides instant access to profile photos and user IDs.

```typescript
const slackUserCache = new Map<string, {
  id: string;
  photoUrl?: string;
  slackUrl?: string;
}>();
let slackUsersLoaded = false;

async function loadSlackUsers(): Promise<void> {
  const token = process.env.SLACK_BOT_TOKEN;
  if (!token) return;
  let cursor = "";
  do {
    const url = `https://slack.com/api/users.list?limit=200${
      cursor ? "&cursor=" + encodeURIComponent(cursor) : ""
    }`;
    const res = await fetch(url, {
      headers: { Authorization: `Bearer ${token}` },
    });
    const data = (await res.json()) as any;
    if (!data.ok) break;
    for (const member of data.members || []) {
      if (member.deleted || member.is_bot) continue;
      const realName =
        member.real_name || member.profile?.real_name || "";
      if (realName && !slackUserCache.has(realName.toLowerCase())) {
        slackUserCache.set(realName.toLowerCase(), {
          id: member.id,
          photoUrl:
            member.profile?.image_192 || member.profile?.image_72,
          slackUrl: `https://zillowgroup.enterprise.slack.com/team/${member.id}`,
        });
      }
    }
    cursor = data.response_metadata?.next_cursor || "";
  } while (cursor);
  slackUsersLoaded = true;
}

loadSlackUsers().catch(console.error);
```

### Look Up a Single User by Slack ID

When you already have a Slack user ID (e.g., from a static mapping), fetch their profile photo directly:

```typescript
async function fetchSlackPhoto(userId: string): Promise<string | undefined> {
  const token = process.env.SLACK_BOT_TOKEN;
  if (!token) return undefined;
  const res = await fetch(
    `https://slack.com/api/users.info?user=${userId}`,
    { headers: { Authorization: `Bearer ${token}` } }
  );
  const data = (await res.json()) as any;
  if (data.ok) {
    return data.user?.profile?.image_192 || data.user?.profile?.image_72;
  }
  return undefined;
}
```

### Name-Based Profile Lookup

Combine a static profiles map with the cached Slack directory for a layered lookup strategy. Static entries take priority; the Slack cache is the fallback.

```typescript
const KNOWN_PROFILES: Record<string, {
  slackUserId?: string;
  profileUrl?: string;
  slackUrl?: string;
  photoUrl?: string;
}> = {
  "Mike Payne": {
    slackUserId: "UCY8JLYR4",
    profileUrl: "https://zallwall.zillowgroup.com/mikep",
    slackUrl: "https://zillowgroup.enterprise.slack.com/archives/DCXV0BUVD",
  },
};

function getEmployeeProfile(name: string) {
  const known = KNOWN_PROFILES[name];
  if (known) return known;

  const slackUser = slackUserCache.get(name.toLowerCase());
  if (slackUser) {
    return {
      photoUrl: slackUser.photoUrl,
      slackUrl: slackUser.slackUrl,
    };
  }
  return {};
}
```

### Slack Profile Image Sizes

The Slack API returns multiple image sizes in the user profile object:

| Field | Size | Best for |
|-------|------|----------|
| `image_24` | 24×24 | Inline mentions, tiny badges |
| `image_72` | 72×72 | Small avatars, list items |
| `image_192` | 192×192 | Profile cards, contributor chips |
| `image_512` | 512×512 | Large profile modals |

Use `image_192` as the default — it's high enough quality for most UI but small enough to load quickly.

### Slack URL Formats

| URL Pattern | When to Use |
|-------------|-------------|
| `https://zillowgroup.enterprise.slack.com/team/{MEMBER_ID}` | Link to user's Slack profile (member ID starts with `U`) |
| `https://zillowgroup.enterprise.slack.com/archives/{DM_CHANNEL_ID}` | Open a DM channel (channel ID starts with `D`) |

The `/team/{MEMBER_ID}` format is easier to construct since you get the member ID directly from `users.list` or `users.info`. The `/archives/{DM_CHANNEL_ID}` format requires opening a DM first via `conversations.open`.

## Fallback (No Glean MCP or Slack API)

If both Glean MCP tools and Slack API are unavailable:

1. Inform the user that automated employee lookup requires the Glean MCP connection or a Slack bot token
2. Provide the manual ZallWall search URL:
   ```
   https://zallwall.zillowgroup.com/search?q={search+terms}
   ```
3. Suggest the user search ZallWall directly and paste the result back

## Rules

| ALWAYS | NEVER |
|--------|-------|
| Use `mcp__glean-tools__employee_search` for people lookups | Guess employee emails or titles |
| Format as `@FirstName LastName` for mentions | Use `@username` or Slack member IDs without resolving |
| Link to ZallWall with the email prefix pattern | Expose internal employee IDs or raw API responses |
| Use `Combobox` for employee typeahead search | Build custom autocomplete inputs |
| Use `Avatar` with `fullName` for initials fallback | Show broken image placeholders |
| Use default-size `Tag` when including an icon | Use `size="sm"` with the `icon` prop |
| Wrap `Tag` in `Flex` with `alignSelf: "flex-start"` in column layouts | Let `Tag` stretch to full width |
| Use `AssistChip` with `AssistChip.Avatar` for employee actions | Put `Avatar` inside regular `Button` |
