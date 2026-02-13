# Follow Up Boss TypeScript App Template

Copy-paste template for building a production-ready Follow Up Boss integration with Express, webhook handling, and full API client.

---

## Project Structure

```
fub-app/
├── src/
│   ├── index.ts          # Express server entry point
│   ├── fub-client.ts     # FUB API client class
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
  "name": "fub-app",
  "version": "1.0.0",
  "description": "Follow Up Boss integration app",
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
FUB_API_KEY=your_api_key_here
FUB_SYSTEM=YourSystemName
FUB_SYSTEM_KEY=your_system_key_here
FUB_WEBHOOK_SECRET=your_webhook_secret
PORT=3000
```

---

## File: `src/types.ts`

```typescript
export interface FUBEmail {
  value: string;
  type?: string;
}

export interface FUBPhone {
  value: string;
  type?: string;
}

export interface FUBAddress {
  street?: string;
  city?: string;
  state?: string;
  code?: string;
  country?: string;
  type?: string;
}

export interface FUBPerson {
  id: number;
  firstName?: string;
  lastName?: string;
  stage?: string;
  source?: string;
  sourceUrl?: string;
  emails?: FUBEmail[];
  phones?: FUBPhone[];
  addresses?: FUBAddress[];
  tags?: string[];
  assignedTo?: string;
  assignedUserId?: number;
  collaborators?: number[];
  created?: string;
  updated?: string;
  lastActivity?: string;
  price?: number;
  contacted?: boolean;
  claimed?: boolean;
  customFields?: Record<string, unknown>;
  [key: string]: unknown;
}

export interface FUBEventPerson {
  id?: number;
  firstName?: string;
  lastName?: string;
  emails?: FUBEmail[];
  phones?: FUBPhone[];
  tags?: string[];
  [key: string]: unknown;
}

export interface FUBEventProperty {
  street?: string;
  city?: string;
  state?: string;
  code?: string;
  mlsNumber?: string;
  price?: number;
  forRent?: boolean;
  url?: string;
  type?: string;
  [key: string]: unknown;
}

export interface FUBEvent {
  source: string;
  system?: string;
  type: string;
  message?: string;
  description?: string;
  person: FUBEventPerson;
  property?: FUBEventProperty;
  occurredAt?: string;
  [key: string]: unknown;
}

export interface FUBNote {
  id?: number;
  personId: number;
  body: string;
  subject?: string;
  isHtml?: boolean;
  created?: string;
}

export interface FUBTask {
  id?: number;
  personId: number;
  name: string;
  description?: string;
  dueDate?: string;
  assignedTo?: number;
  status?: string;
  created?: string;
}

export interface FUBDeal {
  id?: number;
  personId: number;
  name: string;
  dealType?: string;
  stage?: string;
  price?: number;
  commissionValue?: number;
  agentCommission?: number;
  teamCommission?: number;
  closingDate?: string;
  pipelineId?: number;
  assignedUserId?: number;
  [key: string]: unknown;
}

export interface FUBPaginatedResponse<T> {
  [collection: string]: T[] | FUBMetadata;
  _metadata: FUBMetadata;
}

export interface FUBMetadata {
  collection: string;
  offset: number;
  limit: number;
  total: number;
  next?: string;
  nextLink?: string;
}

export interface FUBWebhookPayload {
  event: string;
  resourceIds: number[];
  uri: string;
  timestamp: string;
}

export interface FUBClientConfig {
  apiKey: string;
  system: string;
  systemKey: string;
  baseUrl?: string;
}

export interface FUBRequestOptions {
  method?: string;
  params?: Record<string, string | number | boolean | undefined>;
  body?: unknown;
}
```

---

## File: `src/fub-client.ts`

```typescript
import { FUBClientConfig, FUBEvent, FUBPerson, FUBNote, FUBTask, FUBDeal, FUBRequestOptions, FUBMetadata } from './types.js';

const BASE_URL = 'https://api.followupboss.com/v1';

export class FUBClient {
  private apiKey: string;
  private system: string;
  private systemKey: string;
  private baseUrl: string;

  constructor(config: FUBClientConfig) {
    this.apiKey = config.apiKey;
    this.system = config.system;
    this.systemKey = config.systemKey;
    this.baseUrl = config.baseUrl || BASE_URL;
  }

  private async _request<T>(endpoint: string, options: FUBRequestOptions = {}): Promise<T> {
    const { method = 'GET', params, body } = options;

    const url = new URL(`${this.baseUrl}${endpoint}`);
    if (params) {
      for (const [key, value] of Object.entries(params)) {
        if (value !== undefined) {
          url.searchParams.set(key, String(value));
        }
      }
    }

    const headers: Record<string, string> = {
      'Authorization': `Basic ${Buffer.from(`${this.apiKey}:`).toString('base64')}`,
      'Content-Type': 'application/json',
      'X-System': this.system,
      'X-System-Key': this.systemKey,
    };

    const response = await fetch(url.toString(), {
      method,
      headers,
      body: body ? JSON.stringify(body) : undefined,
    });

    const remaining = response.headers.get('X-RateLimit-Remaining');
    if (remaining !== null && parseInt(remaining, 10) < 10) {
      console.warn(`[FUB] Rate limit warning: ${remaining} requests remaining in window`);
    }

    if (response.status === 204) {
      return undefined as T;
    }

    if (response.status === 429) {
      const retryAfter = parseInt(response.headers.get('Retry-After') || '10', 10);
      console.warn(`[FUB] Rate limited. Retry after ${retryAfter}s`);
      await new Promise(resolve => setTimeout(resolve, retryAfter * 1000));
      return this._request<T>(endpoint, options);
    }

    if (!response.ok) {
      const errorBody = await response.text();
      throw new FUBApiError(response.status, `FUB API ${method} ${endpoint} failed: ${response.status} ${errorBody}`);
    }

    return response.json() as Promise<T>;
  }

  async sendEvent(event: FUBEvent): Promise<{ id?: number; status: number }> {
    const response = await fetch(`${this.baseUrl}/events`, {
      method: 'POST',
      headers: {
        'Authorization': `Basic ${Buffer.from(`${this.apiKey}:`).toString('base64')}`,
        'Content-Type': 'application/json',
        'X-System': this.system,
        'X-System-Key': this.systemKey,
      },
      body: JSON.stringify(event),
    });

    if (response.status === 204) {
      return { status: 204 };
    }

    if (response.status === 429) {
      const retryAfter = parseInt(response.headers.get('Retry-After') || '10', 10);
      await new Promise(resolve => setTimeout(resolve, retryAfter * 1000));
      return this.sendEvent(event);
    }

    if (!response.ok) {
      const errorBody = await response.text();
      throw new FUBApiError(response.status, `Failed to send event: ${response.status} ${errorBody}`);
    }

    const data = await response.json();
    return { id: data.id, status: response.status };
  }

  async getPeople(params?: Record<string, string | number | boolean | undefined>): Promise<{ people: FUBPerson[]; _metadata: FUBMetadata }> {
    return this._request<{ people: FUBPerson[]; _metadata: FUBMetadata }>('/people', { params });
  }

  async getPerson(id: number, includeCustomFields = false): Promise<FUBPerson> {
    const params = includeCustomFields ? { fields: 'allFields' } : undefined;
    return this._request<FUBPerson>(`/people/${id}`, { params });
  }

  async createPerson(data: Partial<FUBPerson>, deduplicate = false): Promise<FUBPerson> {
    const params = deduplicate ? { deduplicate: true } : undefined;
    return this._request<FUBPerson>('/people', { method: 'POST', body: data, params });
  }

  async updatePerson(id: number, data: Partial<FUBPerson>): Promise<FUBPerson> {
    return this._request<FUBPerson>(`/people/${id}`, { method: 'PUT', body: data });
  }

  async createNote(personId: number, body: string, subject?: string): Promise<FUBNote> {
    return this._request<FUBNote>('/notes', {
      method: 'POST',
      body: { personId, body, subject },
    });
  }

  async createTask(data: Omit<FUBTask, 'id' | 'created'>): Promise<FUBTask> {
    return this._request<FUBTask>('/tasks', { method: 'POST', body: data });
  }

  async createDeal(data: Omit<FUBDeal, 'id'>): Promise<FUBDeal> {
    return this._request<FUBDeal>('/deals', { method: 'POST', body: data });
  }

  async getAllPeople(params?: Record<string, string | number | boolean | undefined>): Promise<FUBPerson[]> {
    const allPeople: FUBPerson[] = [];
    let requestParams: Record<string, string | number | boolean | undefined> = {
      limit: 100,
      ...params,
    };

    while (true) {
      const data = await this.getPeople(requestParams);
      allPeople.push(...(data.people || []));

      const next = data._metadata?.next;
      if (!next) break;

      requestParams = { limit: 100, next };
    }

    return allPeople;
  }
}

export class FUBApiError extends Error {
  status: number;
  constructor(status: number, message: string) {
    super(message);
    this.name = 'FUBApiError';
    this.status = status;
  }
}
```

---

## File: `src/webhooks.ts`

```typescript
import { Router, Request, Response, NextFunction } from 'express';
import crypto from 'node:crypto';
import { FUBWebhookPayload } from './types.js';

const router = Router();

function verifyWebhookSignature(secret: string) {
  return (req: Request, res: Response, next: NextFunction) => {
    const signature = req.headers['fub-signature'] as string | undefined;

    if (!signature) {
      console.error('[Webhook] Missing FUB-Signature header');
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
      .createHmac('sha256', secret)
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

const webhookSecret = process.env.FUB_WEBHOOK_SECRET || '';

router.use(verifyWebhookSignature(webhookSecret));

router.post('/people-created', async (req: Request, res: Response) => {
  const payload = req.body as FUBWebhookPayload;
  console.log(`[Webhook] People created: ${payload.resourceIds.join(', ')}`);

  res.status(200).json({ received: true });

  try {
    for (const personId of payload.resourceIds) {
      console.log(`[Webhook] Processing new person: ${personId}`);
    }
  } catch (error) {
    console.error('[Webhook] Error processing people-created:', error);
  }
});

router.post('/people-updated', async (req: Request, res: Response) => {
  const payload = req.body as FUBWebhookPayload;
  console.log(`[Webhook] People updated: ${payload.resourceIds.join(', ')}`);

  res.status(200).json({ received: true });

  try {
    for (const personId of payload.resourceIds) {
      console.log(`[Webhook] Processing updated person: ${personId}`);
    }
  } catch (error) {
    console.error('[Webhook] Error processing people-updated:', error);
  }
});

router.post('/deals-created', async (req: Request, res: Response) => {
  const payload = req.body as FUBWebhookPayload;
  console.log(`[Webhook] Deals created: ${payload.resourceIds.join(', ')}`);
  res.status(200).json({ received: true });
});

router.post('/notes-created', async (req: Request, res: Response) => {
  const payload = req.body as FUBWebhookPayload;
  console.log(`[Webhook] Notes created: ${payload.resourceIds.join(', ')}`);
  res.status(200).json({ received: true });
});

export default router;
```

---

## File: `src/index.ts`

```typescript
import 'dotenv/config';
import express from 'express';
import webhookRouter from './webhooks.js';
import { FUBClient, FUBApiError } from './fub-client.js';

const app = express();
const PORT = parseInt(process.env.PORT || '3000', 10);

app.use(
  express.json({
    verify: (req: any, _res, buf) => {
      req.rawBody = buf;
    },
  })
);

const fub = new FUBClient({
  apiKey: process.env.FUB_API_KEY || '',
  system: process.env.FUB_SYSTEM || '',
  systemKey: process.env.FUB_SYSTEM_KEY || '',
});

app.use('/webhooks', webhookRouter);

app.get('/health', (_req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.post('/api/leads', async (req, res) => {
  try {
    const { firstName, lastName, email, phone, message, source } = req.body;

    const result = await fub.sendEvent({
      source: source || 'MyApp',
      system: process.env.FUB_SYSTEM || 'MyApp',
      type: 'General Inquiry',
      message,
      person: {
        firstName,
        lastName,
        emails: email ? [{ value: email }] : [],
        phones: phone ? [{ value: phone }] : [],
      },
    });

    if (result.status === 204) {
      res.json({ success: true, message: 'Lead received but archived by lead flow' });
    } else {
      res.status(result.status === 201 ? 201 : 200).json({
        success: true,
        personId: result.id,
        isNew: result.status === 201,
      });
    }
  } catch (error) {
    console.error('[API] Error sending lead:', error);
    if (error instanceof FUBApiError) {
      res.status(error.status).json({ error: error.message });
    } else {
      res.status(500).json({ error: 'Failed to send lead' });
    }
  }
});

app.get('/api/people', async (req, res) => {
  try {
    const { limit, next, sort, tags, stage, fields } = req.query;
    const params: Record<string, string | number | boolean> = {};

    if (limit) params.limit = parseInt(limit as string, 10);
    if (next) params.next = next as string;
    if (sort) params.sort = sort as string;
    if (tags) params.tags = tags as string;
    if (stage) params.stage = stage as string;
    if (fields) params.fields = fields as string;

    const data = await fub.getPeople(params);
    res.json(data);
  } catch (error) {
    console.error('[API] Error fetching people:', error);
    if (error instanceof FUBApiError) {
      res.status(error.status).json({ error: error.message });
    } else {
      res.status(500).json({ error: 'Failed to fetch people' });
    }
  }
});

app.get('/api/people/:id', async (req, res) => {
  try {
    const id = parseInt(req.params.id, 10);
    const includeCustom = req.query.fields === 'allFields';
    const person = await fub.getPerson(id, includeCustom);
    res.json(person);
  } catch (error) {
    console.error('[API] Error fetching person:', error);
    if (error instanceof FUBApiError) {
      res.status(error.status).json({ error: error.message });
    } else {
      res.status(500).json({ error: 'Failed to fetch person' });
    }
  }
});

app.post('/api/people/:id/notes', async (req, res) => {
  try {
    const personId = parseInt(req.params.id, 10);
    const { body, subject } = req.body;
    const note = await fub.createNote(personId, body, subject);
    res.status(201).json(note);
  } catch (error) {
    console.error('[API] Error creating note:', error);
    if (error instanceof FUBApiError) {
      res.status(error.status).json({ error: error.message });
    } else {
      res.status(500).json({ error: 'Failed to create note' });
    }
  }
});

app.post('/api/tasks', async (req, res) => {
  try {
    const task = await fub.createTask(req.body);
    res.status(201).json(task);
  } catch (error) {
    console.error('[API] Error creating task:', error);
    if (error instanceof FUBApiError) {
      res.status(error.status).json({ error: error.message });
    } else {
      res.status(500).json({ error: 'Failed to create task' });
    }
  }
});

app.post('/api/deals', async (req, res) => {
  try {
    const deal = await fub.createDeal(req.body);
    res.status(201).json(deal);
  } catch (error) {
    console.error('[API] Error creating deal:', error);
    if (error instanceof FUBApiError) {
      res.status(error.status).json({ error: error.message });
    } else {
      res.status(500).json({ error: 'Failed to create deal' });
    }
  }
});

app.use((err: Error, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
  console.error('[Server] Unhandled error:', err);
  res.status(500).json({ error: 'Internal server error' });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`[Server] FUB app listening on port ${PORT}`);
  console.log(`[Server] Webhooks: POST http://localhost:${PORT}/webhooks/{event}`);
  console.log(`[Server] Health: GET http://localhost:${PORT}/health`);
});
```

---

## File: `README.md`

````markdown
# Follow Up Boss Integration App

Express.js app integrating with the Follow Up Boss CRM API.

## Quick Start

```bash
npm install
cp .env.example .env
# Edit .env with your FUB credentials
npm run dev
```

## Setup

1. Create a trial FUB account at https://app.followupboss.com/signup
2. Generate an API key in Admin → API
3. Register your system at https://apps.followupboss.com/system-registration
4. Copy `.env.example` to `.env` and fill in your credentials

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| POST | /api/leads | Send a lead into FUB via Events |
| GET | /api/people | List people with pagination |
| GET | /api/people/:id | Get a single person |
| POST | /api/people/:id/notes | Add a note to a person |
| POST | /api/tasks | Create a task |
| POST | /api/deals | Create a deal |
| GET | /health | Health check |

## Webhook Endpoints

| Method | Path | FUB Event |
|--------|------|-----------|
| POST | /webhooks/people-created | peopleCreated |
| POST | /webhooks/people-updated | peopleUpdated |
| POST | /webhooks/deals-created | dealsCreated |
| POST | /webhooks/notes-created | notesCreated |

## Register Webhooks

```bash
curl -X POST https://api.followupboss.com/v1/webhooks \
  -u "$FUB_API_KEY:" \
  -H "X-System: $FUB_SYSTEM" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  -H "Content-Type: application/json" \
  -d '{"event": "peopleCreated", "url": "https://yourapp.com/webhooks/people-created"}'
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

1. Replace `FUB_SYSTEM` value with your registered system name
2. Update event `source` to match your application name
3. Add additional webhook routes for events you need (`tasksCreated`, `dealsUpdated`, etc.)
4. Implement async processing for webhooks (queue, database) instead of inline processing
5. Add authentication to your API routes (the `/api/*` routes are unprotected in this template)
6. Configure HTTPS for production webhook URLs
7. Add proper logging (winston, pino) replacing `console.log`
