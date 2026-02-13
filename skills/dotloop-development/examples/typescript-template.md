# Dotloop TypeScript App Template

Copy-paste template for building a production-ready dotloop integration with Express, OAuth 2.0, webhook handling, and full API client.

---

## Project Structure

```
dotloop-app/
├── src/
│   ├── index.ts          # Express server entry point
│   ├── dotloop-client.ts # Dotloop API client class
│   ├── oauth.ts          # OAuth 2.0 flow handlers
│   ├── webhooks.ts       # Webhook handler routes
│   └── types.ts          # TypeScript type definitions
├── package.json
├── tsconfig.json
├── .env.example
└── README.md
```

---

## File: `package.json`

```json
{
  "name": "dotloop-app",
  "version": "1.0.0",
  "description": "Dotloop integration app",
  "type": "module",
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "dev": "tsx watch src/index.ts"
  },
  "dependencies": {
    "express": "^4.21.0",
    "dotenv": "^16.4.5"
  },
  "devDependencies": {
    "@types/express": "^4.17.21",
    "@types/node": "^22.10.0",
    "tsx": "^4.19.2",
    "typescript": "^5.7.2"
  }
}
```

---

## File: `tsconfig.json`

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "Node16",
    "moduleResolution": "Node16",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "declaration": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

---

## File: `.env.example`

```
DOTLOOP_CLIENT_ID=your_client_id
DOTLOOP_CLIENT_SECRET=your_client_secret
DOTLOOP_REDIRECT_URI=https://yourapp.com/oauth/callback
DOTLOOP_WEBHOOK_SECRET=your_webhook_signing_key
PORT=3000
```

---

## File: `src/types.ts`

```typescript
export interface DotloopTokens {
  access_token: string;
  refresh_token: string;
  token_type: string;
  expires_in: number;
  scope: string;
  issuedAt?: number;
}

export interface DotloopAccount {
  id: number;
  email: string;
  firstName: string;
  lastName: string;
  defaultProfileId: number;
}

export interface DotloopProfile {
  id: number;
  name: string;
  type: 'INDIVIDUAL' | 'OFFICE' | 'BROKERAGE';
  default: boolean;
  requiresTemplate: boolean;
  userId: number;
}

export interface DotloopLoop {
  id: number;
  profileId: number;
  name: string;
  transactionType: DotloopTransactionType;
  status: DotloopStatus;
  created: string;
  updated: string;
  loopUrl: string;
  totalTaskCount?: number;
  completedTaskCount?: number;
}

export type DotloopTransactionType =
  | 'PURCHASE_OFFER'
  | 'LISTING_FOR_SALE'
  | 'LISTING_FOR_LEASE'
  | 'LEASE'
  | 'REAL_ESTATE_OTHER'
  | 'OTHER';

export type DotloopStatus =
  | 'PRE_OFFER'
  | 'PRE_LISTING'
  | 'PRIVATE_LISTING'
  | 'ACTIVE_LISTING'
  | 'UNDER_CONTRACT'
  | 'SOLD';

export interface DotloopParticipant {
  id?: number;
  fullName: string;
  email?: string;
  role: string;
  [key: string]: unknown;
}

export interface DotloopContact {
  id: number;
  firstName?: string;
  lastName?: string;
  email?: string;
  homePhone?: string;
  officePhone?: string;
  cellPhone?: string;
  address?: string;
  city?: string;
  state?: string;
  zipCode?: string;
  [key: string]: unknown;
}

export interface DotloopLoopDetail {
  propertyAddress?: Record<string, string>;
  financials?: Record<string, string>;
  contractDates?: Record<string, string>;
  closingInformation?: Record<string, string>;
  listingInformation?: Record<string, string>;
  listingBrokerage?: Record<string, string>;
  buyingBrokerage?: Record<string, string>;
  [key: string]: unknown;
}

export interface DotloopLoopItRequest {
  name: string;
  transactionType: DotloopTransactionType;
  status: DotloopStatus;
  streetName?: string;
  streetNumber?: string;
  city?: string;
  zipCode?: string;
  state?: string;
  country?: string;
  participants?: DotloopParticipant[];
  templateId?: number;
}

export interface DotloopWebhookPayload {
  eventId: string;
  eventType: DotloopWebhookEventType;
  timestamp: number;
  subscriptionExternalId?: string;
  event: {
    id: string;
    profileId: string;
    loopId?: string;
    [key: string]: unknown;
  };
}

export type DotloopWebhookEventType =
  | 'LOOP_CREATED'
  | 'LOOP_UPDATED'
  | 'LOOP_PARTICIPANT_CREATED'
  | 'LOOP_PARTICIPANT_UPDATED'
  | 'LOOP_PARTICIPANT_DELETED'
  | 'LOOP_DOCUMENT_UPLOADED'
  | 'LOOP_DOCUMENT_COMPLETED'
  | 'LOOP_TASK_UPDATED'
  | 'CONTACT_CREATED'
  | 'CONTACT_UPDATED'
  | 'CONTACT_DELETED';

export interface DotloopBatchOptions {
  batch_number?: number;
  batch_size?: number;
}

export interface DotloopApiResponse<T> {
  data: T;
}
```

---

## File: `src/dotloop-client.ts`

```typescript
import { DotloopAccount, DotloopProfile, DotloopLoop, DotloopParticipant, DotloopContact, DotloopLoopDetail, DotloopLoopItRequest, DotloopBatchOptions, DotloopApiResponse } from './types.js';

const BASE_URL = 'https://api-gateway.dotloop.com/public/v2';

export class DotloopClient {
  private accessToken: string;

  constructor(accessToken: string) {
    this.accessToken = accessToken;
  }

  setAccessToken(token: string): void {
    this.accessToken = token;
  }

  private async _request<T>(method: string, endpoint: string, options: {
    params?: Record<string, string | number>;
    body?: unknown;
  } = {}): Promise<T> {
    const { params, body } = options;

    const url = new URL(`${BASE_URL}${endpoint}`);
    if (params) {
      for (const [key, value] of Object.entries(params)) {
        if (value !== undefined) {
          url.searchParams.set(key, String(value));
        }
      }
    }

    const headers: Record<string, string> = {
      'Authorization': `Bearer ${this.accessToken}`,
      'Content-Type': 'application/json',
    };

    const response = await fetch(url.toString(), {
      method,
      headers,
      body: body ? JSON.stringify(body) : undefined,
      redirect: 'follow',
    });

    const remaining = response.headers.get('X-RateLimit-Remaining');
    const resetMs = response.headers.get('X-RateLimit-Reset');
    if (remaining !== null && parseInt(remaining, 10) < 10) {
      console.warn(`[Dotloop] Rate limit warning: ${remaining} requests remaining, resets in ${resetMs}ms`);
    }

    if (response.status === 429) {
      const waitMs = parseInt(resetMs || '5000', 10);
      console.warn(`[Dotloop] Rate limited. Waiting ${waitMs}ms`);
      await new Promise(resolve => setTimeout(resolve, waitMs));
      return this._request<T>(method, endpoint, options);
    }

    if (response.status === 401) {
      throw new DotloopApiError(401, 'Access token expired or invalid — refresh and retry');
    }

    if (!response.ok) {
      const errorBody = await response.text();
      throw new DotloopApiError(response.status, `Dotloop API ${method} ${endpoint} failed: ${response.status} ${errorBody}`);
    }

    return response.json() as Promise<T>;
  }

  async getAccount(): Promise<DotloopApiResponse<DotloopAccount>> {
    return this._request<DotloopApiResponse<DotloopAccount>>('GET', '/account');
  }

  async getProfiles(): Promise<DotloopApiResponse<DotloopProfile[]>> {
    return this._request<DotloopApiResponse<DotloopProfile[]>>('GET', '/profile');
  }

  async getProfile(profileId: number): Promise<DotloopApiResponse<DotloopProfile>> {
    return this._request<DotloopApiResponse<DotloopProfile>>('GET', `/profile/${profileId}`);
  }

  async getLoops(profileId: number, options?: DotloopBatchOptions): Promise<DotloopApiResponse<DotloopLoop[]>> {
    const params: Record<string, string | number> = {};
    if (options?.batch_number) params.batch_number = options.batch_number;
    if (options?.batch_size) params.batch_size = options.batch_size;
    return this._request<DotloopApiResponse<DotloopLoop[]>>('GET', `/profile/${profileId}/loop`, { params });
  }

  async getLoop(profileId: number, loopId: number): Promise<DotloopApiResponse<DotloopLoop>> {
    return this._request<DotloopApiResponse<DotloopLoop>>('GET', `/profile/${profileId}/loop/${loopId}`);
  }

  async createLoop(profileId: number, data: Partial<DotloopLoop>): Promise<DotloopApiResponse<DotloopLoop>> {
    return this._request<DotloopApiResponse<DotloopLoop>>('POST', `/profile/${profileId}/loop`, { body: data });
  }

  async loopIt(profileId: number, data: DotloopLoopItRequest): Promise<DotloopApiResponse<DotloopLoop>> {
    return this._request<DotloopApiResponse<DotloopLoop>>('POST', '/loop-it', {
      params: { profile_id: profileId },
      body: data,
    });
  }

  async getLoopDetail(profileId: number, loopId: number): Promise<DotloopApiResponse<DotloopLoopDetail>> {
    return this._request<DotloopApiResponse<DotloopLoopDetail>>('GET', `/profile/${profileId}/loop/${loopId}/detail`);
  }

  async updateLoopDetail(profileId: number, loopId: number, sections: Partial<DotloopLoopDetail>): Promise<DotloopApiResponse<DotloopLoopDetail>> {
    return this._request<DotloopApiResponse<DotloopLoopDetail>>('PATCH', `/profile/${profileId}/loop/${loopId}/detail`, { body: sections });
  }

  async getParticipants(profileId: number, loopId: number): Promise<DotloopApiResponse<DotloopParticipant[]>> {
    return this._request<DotloopApiResponse<DotloopParticipant[]>>('GET', `/profile/${profileId}/loop/${loopId}/participant`);
  }

  async addParticipant(profileId: number, loopId: number, data: DotloopParticipant): Promise<DotloopApiResponse<DotloopParticipant>> {
    return this._request<DotloopApiResponse<DotloopParticipant>>('POST', `/profile/${profileId}/loop/${loopId}/participant`, { body: data });
  }

  async getContacts(options?: DotloopBatchOptions): Promise<DotloopApiResponse<DotloopContact[]>> {
    const params: Record<string, string | number> = {};
    if (options?.batch_number) params.batch_number = options.batch_number;
    if (options?.batch_size) params.batch_size = options.batch_size;
    return this._request<DotloopApiResponse<DotloopContact[]>>('GET', '/contact', { params });
  }

  async createContact(data: Partial<DotloopContact>): Promise<DotloopApiResponse<DotloopContact>> {
    return this._request<DotloopApiResponse<DotloopContact>>('POST', '/contact', { body: data });
  }

  async getLoopTemplates(profileId: number): Promise<DotloopApiResponse<any[]>> {
    return this._request<DotloopApiResponse<any[]>>('GET', `/profile/${profileId}/loop-template`);
  }

  async getAllLoops(profileId: number): Promise<DotloopLoop[]> {
    const allLoops: DotloopLoop[] = [];
    let batchNumber = 1;
    while (true) {
      const response = await this.getLoops(profileId, { batch_number: batchNumber, batch_size: 50 });
      const loops = response.data;
      allLoops.push(...loops);
      if (loops.length < 50) break;
      batchNumber++;
    }
    return allLoops;
  }

  async getAllContacts(): Promise<DotloopContact[]> {
    const allContacts: DotloopContact[] = [];
    let batchNumber = 1;
    while (true) {
      const response = await this.getContacts({ batch_number: batchNumber, batch_size: 50 });
      const contacts = response.data;
      allContacts.push(...contacts);
      if (contacts.length < 50) break;
      batchNumber++;
    }
    return allContacts;
  }
}

export class DotloopApiError extends Error {
  status: number;
  constructor(status: number, message: string) {
    super(message);
    this.name = 'DotloopApiError';
    this.status = status;
  }
}
```

---

## File: `src/oauth.ts`

```typescript
import { Router, Request, Response } from 'express';
import crypto from 'node:crypto';
import { DotloopTokens } from './types.js';

const router = Router();

const AUTH_BASE = 'https://auth.dotloop.com/oauth';
const CLIENT_ID = process.env.DOTLOOP_CLIENT_ID || '';
const CLIENT_SECRET = process.env.DOTLOOP_CLIENT_SECRET || '';
const REDIRECT_URI = process.env.DOTLOOP_REDIRECT_URI || '';

// In-memory token storage — use a database in production
const tokenStore: Map<string, DotloopTokens & { issuedAt: number }> = new Map();

export function getTokens(userId: string): (DotloopTokens & { issuedAt: number }) | undefined {
  return tokenStore.get(userId);
}

export function saveTokens(userId: string, tokens: DotloopTokens): void {
  tokenStore.set(userId, { ...tokens, issuedAt: Date.now() });
}

async function exchangeCodeForTokens(code: string): Promise<DotloopTokens> {
  const basicAuth = Buffer.from(`${CLIENT_ID}:${CLIENT_SECRET}`).toString('base64');

  const response = await fetch(`${AUTH_BASE}/token?grant_type=authorization_code&code=${code}&redirect_uri=${encodeURIComponent(REDIRECT_URI)}`, {
    method: 'POST',
    headers: {
      'Authorization': `Basic ${basicAuth}`,
    },
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`Token exchange failed: ${response.status} ${error}`);
  }

  return response.json() as Promise<DotloopTokens>;
}

async function refreshAccessToken(refreshToken: string): Promise<DotloopTokens> {
  const basicAuth = Buffer.from(`${CLIENT_ID}:${CLIENT_SECRET}`).toString('base64');

  const response = await fetch(`${AUTH_BASE}/token?grant_type=refresh_token&refresh_token=${refreshToken}`, {
    method: 'POST',
    headers: {
      'Authorization': `Basic ${basicAuth}`,
    },
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`Token refresh failed: ${response.status} ${error}`);
  }

  return response.json() as Promise<DotloopTokens>;
}

router.get('/authorize', (_req: Request, res: Response) => {
  const state = crypto.randomBytes(16).toString('hex');
  // In production, store state in session for CSRF validation

  const authUrl = new URL(`${AUTH_BASE}/authorize`);
  authUrl.searchParams.set('response_type', 'code');
  authUrl.searchParams.set('client_id', CLIENT_ID);
  authUrl.searchParams.set('redirect_uri', REDIRECT_URI);
  authUrl.searchParams.set('state', state);

  res.redirect(authUrl.toString());
});

router.get('/callback', async (req: Request, res: Response) => {
  try {
    const { code, state, error } = req.query;

    if (error) {
      console.error(`[OAuth] Authorization denied: ${error}`);
      res.status(400).json({ error: `Authorization denied: ${error}` });
      return;
    }

    if (!code || typeof code !== 'string') {
      res.status(400).json({ error: 'Missing authorization code' });
      return;
    }

    // In production, validate state against session to prevent CSRF

    const tokens = await exchangeCodeForTokens(code);
    console.log('[OAuth] Tokens received successfully');

    // Store tokens — use authenticated user ID in production
    saveTokens('default', tokens);

    res.json({
      success: true,
      message: 'Authorization successful',
      expires_in: tokens.expires_in,
      scope: tokens.scope,
    });
  } catch (err) {
    console.error('[OAuth] Callback error:', err);
    res.status(500).json({ error: 'Token exchange failed' });
  }
});

router.post('/refresh', async (req: Request, res: Response) => {
  try {
    const userId = req.body?.userId || 'default';
    const existing = getTokens(userId);

    if (!existing) {
      res.status(400).json({ error: 'No tokens found — authorize first' });
      return;
    }

    // CRITICAL: Refreshing invalidates the previous access token immediately
    const tokens = await refreshAccessToken(existing.refresh_token);
    saveTokens(userId, tokens);

    console.log('[OAuth] Token refreshed successfully');
    res.json({
      success: true,
      expires_in: tokens.expires_in,
    });
  } catch (err) {
    console.error('[OAuth] Refresh error:', err);
    res.status(500).json({ error: 'Token refresh failed' });
  }
});

export default router;
```

---

## File: `src/webhooks.ts`

```typescript
import { Router, Request, Response, NextFunction } from 'express';
import crypto from 'node:crypto';
import { DotloopWebhookPayload } from './types.js';

const router = Router();

const WEBHOOK_SECRET = process.env.DOTLOOP_WEBHOOK_SECRET || '';
const MAX_TIMESTAMP_AGE_MS = 5 * 60 * 1000; // 5 minutes

function verifyWebhookSignature(secret: string) {
  return (req: Request, res: Response, next: NextFunction) => {
    const signature = req.headers['x-dotloop-signature'] as string | undefined;

    if (!signature) {
      console.error('[Webhook] Missing X-DOTLOOP-SIGNATURE header');
      res.status(401).json({ error: 'Missing signature' });
      return;
    }

    const rawBody = (req as any).rawBody as Buffer;
    if (!rawBody) {
      console.error('[Webhook] Missing raw body — ensure express.json() preserves rawBody');
      res.status(400).json({ error: 'Missing body' });
      return;
    }

    const expectedSignature = crypto
      .createHmac('sha1', secret)
      .update(rawBody)
      .digest('hex');

    const isValid = crypto.timingSafeEqual(
      Buffer.from(signature),
      Buffer.from(expectedSignature)
    );

    if (!isValid) {
      console.error('[Webhook] Invalid signature');
      res.status(401).json({ error: 'Invalid signature' });
      return;
    }

    next();
  };
}

function validateTimestamp(req: Request, res: Response, next: NextFunction) {
  const payload = req.body as DotloopWebhookPayload;
  const eventTime = payload.timestamp;
  const now = Date.now();

  if (Math.abs(now - eventTime) > MAX_TIMESTAMP_AGE_MS) {
    console.error(`[Webhook] Stale event: timestamp ${eventTime} is more than 5 minutes old`);
    res.status(400).json({ error: 'Event timestamp too old' });
    return;
  }

  next();
}

router.use(verifyWebhookSignature(WEBHOOK_SECRET));
router.use(validateTimestamp);

const processedEvents = new Set<string>();

router.post('/dotloop', async (req: Request, res: Response) => {
  const payload = req.body as DotloopWebhookPayload;
  const { eventId, eventType } = payload;

  // Idempotency check — a single action can trigger multiple webhook events
  if (processedEvents.has(eventId)) {
    console.log(`[Webhook] Duplicate event ${eventId}, skipping`);
    res.status(200).json({ received: true, duplicate: true });
    return;
  }

  processedEvents.add(eventId);
  // In production, store processed event IDs in a database with TTL

  console.log(`[Webhook] Received ${eventType}: ${JSON.stringify(payload.event)}`);

  res.status(200).json({ received: true });

  try {
    switch (eventType) {
      case 'LOOP_CREATED':
        await handleLoopCreated(payload);
        break;
      case 'LOOP_UPDATED':
        await handleLoopUpdated(payload);
        break;
      case 'LOOP_PARTICIPANT_CREATED':
        await handleParticipantCreated(payload);
        break;
      case 'LOOP_PARTICIPANT_UPDATED':
        await handleParticipantUpdated(payload);
        break;
      case 'LOOP_PARTICIPANT_DELETED':
        await handleParticipantDeleted(payload);
        break;
      case 'LOOP_DOCUMENT_UPLOADED':
        await handleDocumentUploaded(payload);
        break;
      case 'LOOP_DOCUMENT_COMPLETED':
        await handleDocumentCompleted(payload);
        break;
      case 'LOOP_TASK_UPDATED':
        await handleTaskUpdated(payload);
        break;
      case 'CONTACT_CREATED':
        await handleContactCreated(payload);
        break;
      case 'CONTACT_UPDATED':
        await handleContactUpdated(payload);
        break;
      case 'CONTACT_DELETED':
        await handleContactDeleted(payload);
        break;
      default:
        console.log(`[Webhook] Unhandled event type: ${eventType}`);
    }
  } catch (error) {
    console.error(`[Webhook] Error processing ${eventType}:`, error);
  }
});

async function handleLoopCreated(payload: DotloopWebhookPayload): Promise<void> {
  console.log(`[Webhook] Loop created: ${payload.event.loopId} in profile ${payload.event.profileId}`);
}

async function handleLoopUpdated(payload: DotloopWebhookPayload): Promise<void> {
  console.log(`[Webhook] Loop updated: ${payload.event.loopId}`);
}

async function handleParticipantCreated(payload: DotloopWebhookPayload): Promise<void> {
  console.log(`[Webhook] Participant added to loop: ${payload.event.loopId}`);
}

async function handleParticipantUpdated(payload: DotloopWebhookPayload): Promise<void> {
  console.log(`[Webhook] Participant updated in loop: ${payload.event.loopId}`);
}

async function handleParticipantDeleted(payload: DotloopWebhookPayload): Promise<void> {
  console.log(`[Webhook] Participant removed from loop: ${payload.event.loopId}`);
}

async function handleDocumentUploaded(payload: DotloopWebhookPayload): Promise<void> {
  console.log(`[Webhook] Document uploaded to loop: ${payload.event.loopId}`);
}

async function handleDocumentCompleted(payload: DotloopWebhookPayload): Promise<void> {
  console.log(`[Webhook] Document completed in loop: ${payload.event.loopId}`);
}

async function handleTaskUpdated(payload: DotloopWebhookPayload): Promise<void> {
  console.log(`[Webhook] Task updated in loop: ${payload.event.loopId}`);
}

async function handleContactCreated(payload: DotloopWebhookPayload): Promise<void> {
  console.log(`[Webhook] Contact created: ${payload.event.id}`);
}

async function handleContactUpdated(payload: DotloopWebhookPayload): Promise<void> {
  console.log(`[Webhook] Contact updated: ${payload.event.id}`);
}

async function handleContactDeleted(payload: DotloopWebhookPayload): Promise<void> {
  console.log(`[Webhook] Contact deleted: ${payload.event.id}`);
}

export default router;
```

---

## File: `src/index.ts`

```typescript
import 'dotenv/config';
import express from 'express';
import oauthRouter, { getTokens } from './oauth.js';
import webhookRouter from './webhooks.js';
import { DotloopClient, DotloopApiError } from './dotloop-client.js';

const app = express();
const PORT = parseInt(process.env.PORT || '3000', 10);

app.use(
  express.json({
    verify: (req: any, _res, buf) => {
      req.rawBody = buf;
    },
  })
);

app.use('/oauth', oauthRouter);
app.use('/webhooks', webhookRouter);

function getDotloopClient(): DotloopClient {
  const tokens = getTokens('default');
  if (!tokens) {
    throw new DotloopApiError(401, 'Not authenticated — visit /oauth/authorize first');
  }
  return new DotloopClient(tokens.access_token);
}

app.get('/health', (_req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.get('/api/account', async (_req, res) => {
  try {
    const client = getDotloopClient();
    const account = await client.getAccount();
    res.json(account);
  } catch (error) {
    handleApiError(res, error);
  }
});

app.get('/api/profiles', async (_req, res) => {
  try {
    const client = getDotloopClient();
    const profiles = await client.getProfiles();
    res.json(profiles);
  } catch (error) {
    handleApiError(res, error);
  }
});

app.get('/api/profiles/:profileId/loops', async (req, res) => {
  try {
    const client = getDotloopClient();
    const profileId = parseInt(req.params.profileId, 10);
    const batchNumber = req.query.batch_number ? parseInt(req.query.batch_number as string, 10) : undefined;
    const batchSize = req.query.batch_size ? parseInt(req.query.batch_size as string, 10) : undefined;
    const loops = await client.getLoops(profileId, { batch_number: batchNumber, batch_size: batchSize });
    res.json(loops);
  } catch (error) {
    handleApiError(res, error);
  }
});

app.get('/api/profiles/:profileId/loops/all', async (req, res) => {
  try {
    const client = getDotloopClient();
    const profileId = parseInt(req.params.profileId, 10);
    const allLoops = await client.getAllLoops(profileId);
    res.json({ data: allLoops, total: allLoops.length });
  } catch (error) {
    handleApiError(res, error);
  }
});

app.post('/api/profiles/:profileId/loop-it', async (req, res) => {
  try {
    const client = getDotloopClient();
    const profileId = parseInt(req.params.profileId, 10);
    const loop = await client.loopIt(profileId, req.body);
    res.status(201).json(loop);
  } catch (error) {
    handleApiError(res, error);
  }
});

app.get('/api/profiles/:profileId/loops/:loopId/detail', async (req, res) => {
  try {
    const client = getDotloopClient();
    const profileId = parseInt(req.params.profileId, 10);
    const loopId = parseInt(req.params.loopId, 10);
    const detail = await client.getLoopDetail(profileId, loopId);
    res.json(detail);
  } catch (error) {
    handleApiError(res, error);
  }
});

app.patch('/api/profiles/:profileId/loops/:loopId/detail', async (req, res) => {
  try {
    const client = getDotloopClient();
    const profileId = parseInt(req.params.profileId, 10);
    const loopId = parseInt(req.params.loopId, 10);
    const detail = await client.updateLoopDetail(profileId, loopId, req.body);
    res.json(detail);
  } catch (error) {
    handleApiError(res, error);
  }
});

app.get('/api/profiles/:profileId/loops/:loopId/participants', async (req, res) => {
  try {
    const client = getDotloopClient();
    const profileId = parseInt(req.params.profileId, 10);
    const loopId = parseInt(req.params.loopId, 10);
    const participants = await client.getParticipants(profileId, loopId);
    res.json(participants);
  } catch (error) {
    handleApiError(res, error);
  }
});

app.get('/api/contacts', async (req, res) => {
  try {
    const client = getDotloopClient();
    const batchNumber = req.query.batch_number ? parseInt(req.query.batch_number as string, 10) : undefined;
    const contacts = await client.getContacts({ batch_number: batchNumber });
    res.json(contacts);
  } catch (error) {
    handleApiError(res, error);
  }
});

app.post('/api/contacts', async (req, res) => {
  try {
    const client = getDotloopClient();
    const contact = await client.createContact(req.body);
    res.status(201).json(contact);
  } catch (error) {
    handleApiError(res, error);
  }
});

function handleApiError(res: express.Response, error: unknown): void {
  if (error instanceof DotloopApiError) {
    res.status(error.status).json({ error: error.message });
  } else {
    console.error('[API] Unhandled error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
}

app.use((err: Error, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
  console.error('[Server] Unhandled error:', err);
  res.status(500).json({ error: 'Internal server error' });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`[Server] Dotloop app listening on port ${PORT}`);
  console.log(`[Server] OAuth: GET http://localhost:${PORT}/oauth/authorize`);
  console.log(`[Server] Webhooks: POST http://localhost:${PORT}/webhooks/dotloop`);
  console.log(`[Server] Health: GET http://localhost:${PORT}/health`);
});
```

---

## File: `README.md`

````markdown
# Dotloop Integration App

Express.js app integrating with the dotloop real estate transaction management API.

## Quick Start

```bash
npm install
cp .env.example .env
# Edit .env with your dotloop credentials
npm run dev
```

## Setup

1. Request API access at https://info.dotloop.com/developers or register at https://www.dotloop.com/my/account/#/clients
2. Set your redirect URI to a publicly accessible HTTPS URL
3. Copy `.env.example` to `.env` and fill in your credentials

## OAuth Flow

1. Visit `GET /oauth/authorize` to start the authorization flow
2. User authorizes your app on dotloop
3. Dotloop redirects to `/oauth/callback` with an authorization code
4. The app exchanges the code for access and refresh tokens
5. Access tokens expire every ~12 hours — use `POST /oauth/refresh` to refresh

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | /oauth/authorize | Start OAuth flow |
| GET | /oauth/callback | OAuth callback handler |
| POST | /oauth/refresh | Refresh access token |
| GET | /api/account | Get account info |
| GET | /api/profiles | List profiles |
| GET | /api/profiles/:id/loops | List loops (paginated) |
| GET | /api/profiles/:id/loops/all | List ALL loops (auto-paginated) |
| POST | /api/profiles/:id/loop-it | Create loop via Loop-It |
| GET | /api/profiles/:id/loops/:id/detail | Get loop details |
| PATCH | /api/profiles/:id/loops/:id/detail | Update loop details |
| GET | /api/profiles/:id/loops/:id/participants | List participants |
| GET | /api/contacts | List contacts |
| POST | /api/contacts | Create contact |
| GET | /health | Health check |

## Webhook Endpoint

| Method | Path | Description |
|--------|------|-------------|
| POST | /webhooks/dotloop | Receive all dotloop webhook events |

## Register a Webhook

```bash
curl -X POST "https://api-gateway.dotloop.com/public/v2/subscription" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://yourapp.com/webhooks/dotloop",
    "eventTypes": ["LOOP_CREATED", "LOOP_UPDATED"],
    "signingKey": "your_webhook_secret",
    "externalId": "your-tracking-id"
  }'
```

## Production

```bash
npm run build
npm start
```
````

---

## Customization Checklist

When adapting this template:

1. Replace in-memory token storage with a database (encrypted at rest)
2. Add CSRF state validation in the OAuth callback
3. Implement proactive token refresh (at 80% of token lifetime)
4. Add authentication to your API routes (the `/api/*` routes are unprotected in this template)
5. Replace `console.log` with a structured logger (winston, pino)
6. Store processed webhook event IDs in a database with TTL instead of in-memory Set
7. Configure HTTPS for production webhook URLs
8. Handle concurrent token refresh in clustered environments with distributed locks
9. Add `templateId` to Loop-It requests if the profile requires it (`profile.requiresTemplate`)
