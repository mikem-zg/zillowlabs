# Writer AI API Reference

Source: [Writer AI Studio Developer Documentation](https://dev.writer.com/)

Writer AI is the platform that powers the Zillow Style Guide. The Writer API enables programmatic content generation, style checking, and AI-assisted writing that follows Zillow's voice, tone, and brand guidelines.

**Environment variable:** `WRITER_API_KEY` (stored as a Replit secret)

---

## Base URL & Authentication

**Base URL:** `https://api.writer.com/v1/`

All requests require Bearer token authentication:

```
Authorization: Bearer $WRITER_API_KEY
Content-Type: application/json
```

---

## Available Models

| Model | API ID | Context Window | Max Output | Best For |
|-------|--------|---------------|------------|----------|
| **Palmyra X5** | `palmyra-x5` | 1M tokens | 8,192 tokens | General-purpose, agentic workflows, latest model |
| **Palmyra X4** | `palmyra-x4` | 128k tokens | 4,096 tokens | Complex language tasks |
| **Palmyra X 003 Instruct** | `palmyra-x-003-instruct` | 32k tokens | 4,096 tokens | Precise, detailed instruction-following |
| **Palmyra Vision** | `palmyra-vision` | 8k tokens | 4,096 tokens | Image processing |
| **Palmyra Med** | `palmyra-med` | 32k tokens | 4,096 tokens | Healthcare content |
| **Palmyra Fin** | `palmyra-fin` | 128k tokens | 4,096 tokens | Financial content |
| **Palmyra Creative** | `palmyra-creative` | 128k tokens | 4,096 tokens | Creative writing |

**Recommended default:** `palmyra-x5` — best cost-performance ratio, largest context window.

### Pricing (per 1M tokens)

| Model | Input | Output |
|-------|-------|--------|
| Palmyra X5 | $0.60 | $6.00 |
| Palmyra X4 | $2.50 | $10.00 |
| Palmyra X 003 Instruct | $7.50 | $22.50 |

---

## Endpoints

### 1. Chat Completion

**`POST /v1/chat`** — Create a conversational exchange with an LLM. Supports multi-turn conversations, system prompts, streaming, and tool calling.

#### Request

```bash
curl 'https://api.writer.com/v1/chat' \
  -X POST \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $WRITER_API_KEY" \
  --data-raw '{
    "model": "palmyra-x5",
    "messages": [
      {
        "role": "system",
        "content": "You are a Zillow UX writer. Follow Zillow voice and tone guidelines: sentence case, active voice, contractions, Oxford comma."
      },
      {
        "role": "user",
        "content": "Write an empty state message for a saved homes page."
      }
    ],
    "temperature": 0.7,
    "max_tokens": 200
  }'
```

#### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `model` | string | Yes | Model ID (e.g., `palmyra-x5`) |
| `messages` | array | Yes | Conversation history |
| `messages[].role` | string | Yes | `user`, `assistant`, `system`, or `tool` |
| `messages[].content` | string | Yes | Message content |
| `temperature` | float | No | Randomness (0–1). Default: 1. Lower = more predictable |
| `max_tokens` | integer | No | Maximum response length |
| `top_p` | float | No | Nucleus sampling (0–1) |
| `stream` | boolean | No | Enable streaming (default: false) |
| `tools` | array | No | Tool definitions for function calling |
| `tool_choice` | string/object | No | Control tool selection behavior |
| `n` | integer | No | Number of completions to generate |
| `stop` | string/array | No | Stop sequences |

#### Response (Non-Streaming)

```json
{
  "id": "78766762-bd30-4a42-bb2b-e0b35c608217",
  "object": "chat.completion",
  "choices": [
    {
      "index": 0,
      "finish_reason": "stop",
      "message": {
        "content": "You haven't saved any homes yet. Start a new search to find homes you'll love.",
        "role": "assistant"
      }
    }
  ],
  "model": "palmyra-x5",
  "usage": {
    "prompt_tokens": 50,
    "total_tokens": 79,
    "completion_tokens": 29
  }
}
```

#### Response (Streaming)

When `stream: true`, responses arrive as server-sent events. Content is in `choices[0].delta.content` instead of `choices[0].message.content`.

---

### 2. Text Generation (Completions)

**`POST /v1/completions`** — Generate text from a prompt (non-conversational).

```bash
curl 'https://api.writer.com/v1/completions' \
  -X POST \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $WRITER_API_KEY" \
  --data-raw '{
    "model": "palmyra-x-003-instruct",
    "prompt": "Write a one-sentence error message for an invalid ZIP code entry on a Zillow form:",
    "max_tokens": 50,
    "temperature": 0.3
  }'
```

#### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `model` | string | Yes | Model ID |
| `prompt` | string | Yes | Input text for generation |
| `max_tokens` | integer | No | Maximum response length |
| `temperature` | float | No | Randomness (0–1) |
| `top_p` | float | No | Nucleus sampling |
| `stop` | string/array | No | Stop sequences |
| `best_of` | integer | No | Generate n completions, return best |
| `random_seed` | integer | No | For reproducible results |
| `stream` | boolean | No | Enable streaming |

#### Response

```json
{
  "choices": [
    {
      "text": "Enter a 5-digit ZIP code.",
      "log_probs": null
    }
  ],
  "model": "palmyra-x-003-instruct"
}
```

---

### 3. No-Code Agents (Applications API)

**`POST /v1/applications/{application_id}`** — Invoke deployed no-code agents with custom inputs.

```bash
curl 'https://api.writer.com/v1/applications/<application-id>' \
  -X POST \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $WRITER_API_KEY" \
  --data-raw '{
    "inputs": [
      {
        "id": "Content type",
        "value": ["Error message"]
      },
      {
        "id": "Context",
        "value": ["User entered an invalid email address on a Zillow sign-in form"]
      }
    ]
  }'
```

**Get agent details:** `GET /v1/applications/{application_id}` — Returns the agent's input schema.

---

### 4. Knowledge Graph (RAG)

Writer's graph-based RAG achieves higher accuracy than traditional vector retrieval.

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/v1/graphs` | POST | Create a Knowledge Graph |
| `/v1/graphs/{graph_id}/file` | POST | Add a file to a Knowledge Graph |
| `/v1/graphs/{graph_id}/file/{file_id}` | DELETE | Remove a file |
| `/v1/graphs/{graph_id}/urls` | POST | Add URLs to a Knowledge Graph |

#### Create a Knowledge Graph

```bash
curl 'https://api.writer.com/v1/graphs' \
  -X POST \
  -H "Authorization: Bearer $WRITER_API_KEY" \
  -H 'Content-Type: application/json' \
  --data-raw '{
    "name": "Zillow Content Guidelines",
    "description": "Knowledge Graph of Zillow brand, voice, tone, and UX writing guidelines"
  }'
```

#### Use with Chat Completion

After creating a Knowledge Graph and adding files, reference it in chat completions via tool calling to ground responses in your content guidelines.

---

### 5. Tool Calling

Extend chat completions with custom functions. The model decides when to call tools based on the conversation.

```bash
curl 'https://api.writer.com/v1/chat' \
  -X POST \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $WRITER_API_KEY" \
  --data-raw '{
    "model": "palmyra-x5",
    "messages": [
      {"role": "user", "content": "Check if this copy follows Zillow style: Click here to see homes near you!"}
    ],
    "tools": [
      {
        "type": "function",
        "function": {
          "name": "check_zillow_style",
          "description": "Validate copy against Zillow UX writing guidelines",
          "parameters": {
            "type": "object",
            "properties": {
              "copy": {"type": "string", "description": "The copy to validate"},
              "audience": {"type": "string", "enum": ["consumer", "professional"]}
            },
            "required": ["copy"]
          }
        }
      }
    ]
  }'
```

---

## Node.js SDK

Install the Writer SDK for programmatic access:

```bash
npm install writer-sdk
```

### Initialize

```typescript
import Writer from 'writer-sdk';

const client = new Writer();
// Automatically reads WRITER_API_KEY from environment
```

### Chat Completion

```typescript
const response = await client.chat.chat({
  model: 'palmyra-x5',
  messages: [
    {
      role: 'system',
      content: 'You are a Zillow UX writer following constellation-content guidelines.'
    },
    {
      role: 'user',
      content: 'Write a success toast for saving a home.'
    }
  ],
  temperature: 0.7,
});

console.log(response.choices[0].message.content);
```

### Streaming

```typescript
const stream = await client.chat.chat({
  model: 'palmyra-x5',
  messages: [{ role: 'user', content: 'Write onboarding copy for a new renter.' }],
  stream: true,
});

for await (const chunk of stream) {
  const content = chunk.choices?.[0]?.delta?.content;
  if (content) process.stdout.write(content);
}
```

---

## Python SDK

```bash
pip install writer-sdk
```

```python
from writerai import Writer

client = Writer()  # reads WRITER_API_KEY from environment

response = client.chat.chat(
    model="palmyra-x5",
    messages=[
        {"role": "system", "content": "You are a Zillow UX writer."},
        {"role": "user", "content": "Write an error message for a failed search."}
    ],
    temperature=0.5,
)

print(response.choices[0].message.content)
```

---

## Zillow-Specific System Prompts

Use these system prompts to generate copy that follows Zillow guidelines:

### General UX Copy

```
You are a Zillow UX writer. Follow these rules strictly:
- Sentence case for all UI text
- Use contractions (we'll, you're, it's)
- Active voice, front-load the outcome
- Address users as "you", Zillow as "we/us/our"
- Oxford comma in all lists
- Use "Select" instead of "Click" or "Tap"
- No emojis in UI text
- No exclamation points on buttons
- No periods on headings, labels, toasts, or alerts (unless multi-sentence)
```

### Consumer Copy

```
You are a Zillow UX writer for consumer experiences (homebuyers, renters, sellers).
Tone: Joyful, vibrant, emotional. Promise: "Get home."
- Speak to the person's goal, not just data
- Benefit-oriented headlines
- Warm and aspirational — but never vague
- One exclamation mark OK in celebrations ("Home saved!")
- Follow all Zillow sentence case and punctuation rules
```

### Professional Copy

```
You are a Zillow UX writer for professional experiences (agents, loan officers, property managers).
Tone: Efficient, organized, trustworthy. Promise: "Unlock success."
- Lead with data and outcomes, not enthusiasm
- No exclamation marks in data UI, dashboards, or tables
- Use industry-standard terminology (leads, pipeline, CRM, listings)
- Concise and direct — no unnecessary warmth
- Follow all Zillow sentence case and punctuation rules
```

### AI Agent Copy

```
You are writing for a Zillow AI agent experience. Follow Zillow's AI behavioral guidelines:
- Confident, not coercive: use "recommend" and "suggest", not "must" or "should"
- Helpful without over-explaining: short answer first, depth available
- Empathic, not performative: name the situation, not the feeling
- Direct about tradeoffs: surface constraints early
- Calm under failure: plain acknowledgment + next steps
- Never anthropomorphize ("I feel...", "I think...")
- Never create false urgency
- Never repeat recommendations after refusal
```

---

## Integration Patterns

### Content Validation Pipeline

Use the Writer API to programmatically validate UI copy against Zillow guidelines:

```typescript
import Writer from 'writer-sdk';

const client = new Writer();

async function validateCopy(copy: string, audience: 'consumer' | 'professional'): Promise<string> {
  const response = await client.chat.chat({
    model: 'palmyra-x5',
    messages: [
      {
        role: 'system',
        content: `You are a Zillow content reviewer. Check the following copy against Zillow UX writing guidelines for ${audience} audiences. Report any violations of: sentence case, active voice, contractions, Oxford comma, banned terms (click, tap, master, walkthrough, etc.), periods on labels/buttons, exclamation points (professional only), and inclusive language. Return a JSON array of violations with "rule", "issue", and "suggestion" fields. If no violations, return an empty array.`
      },
      {
        role: 'user',
        content: copy
      }
    ],
    temperature: 0,
  });

  return response.choices[0].message.content;
}
```

### Batch Copy Generation

Generate multiple copy variants for A/B testing:

```typescript
async function generateCopyVariants(context: string, count: number = 3): Promise<string[]> {
  const response = await client.chat.chat({
    model: 'palmyra-x5',
    messages: [
      {
        role: 'system',
        content: 'You are a Zillow UX writer. Generate copy variants following Zillow guidelines. Return each variant on a new line, numbered.'
      },
      {
        role: 'user',
        content: `Generate ${count} variants for: ${context}`
      }
    ],
    temperature: 0.8,
  });

  return response.choices[0].message.content
    .split('\n')
    .filter(line => line.trim())
    .map(line => line.replace(/^\d+\.\s*/, ''));
}
```

---

## Guardrails

Writer supports configurable guardrails for content safety:

- **PII protection** — Detect and redact personal information
- **Content safety** — Filter inappropriate or off-brand content
- **Compliance policies** — Enforce industry-specific rules

Configure guardrails in [AI Studio](https://app.writer.com/aistudio) under your organization settings.

---

## Observability

Track API usage and costs:

- Organization-wide usage dashboards in AI Studio
- Per-agent performance metrics
- Session logs for debugging
- OpenLLMetry export for external observability tools

---

## Resources

- [Writer AI Studio](https://dev.writer.com/) — Full developer documentation
- [API Reference](https://dev.writer.com/api-reference/) — Complete endpoint specs
- [Models Guide](https://dev.writer.com/home/models) — Model comparison and pricing
- [Knowledge Graph Guide](https://dev.writer.com/home/knowledge-graph) — RAG setup
- [Tool Calling Guide](https://dev.writer.com/home/tool-calling) — Function calling patterns
- [SDKs](https://dev.writer.com/home/sdks) — Python and Node.js setup
