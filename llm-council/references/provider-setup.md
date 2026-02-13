# Provider Setup — Replit AI Integrations

## Overview

Replit AI Integrations provide built-in access to **OpenAI**, **Anthropic**, **Gemini**, and **OpenRouter** — no API keys needed. Usage is billed directly to your Replit credits. Each provider is installed via an integration blueprint that auto-configures the SDK client and manages authentication.

For optional providers like **xAI/Grok**, you'll need to supply your own API key.

---

## Provider Setup

### Installing Integrations

Each provider has a corresponding blueprint. Install them using the agent tools:

1. Use `search_integrations` to find the provider (e.g., query `"openai"`)
2. Use `use_integration` with `operation: "add"` and the blueprint ID

Install all four for a full council setup.

---

### OpenAI

**Blueprint ID:** `blueprint:javascript_openai_ai_integrations`

**Available Models:**

| Model | Type | Best For |
|-------|------|----------|
| `gpt-5.2` | Latest flagship | Complex reasoning, chairman role |
| `gpt-5.1` | Flagship | Strong general-purpose |
| `gpt-5` | Flagship | Balanced reasoning |
| `gpt-5-mini` | Fast | Budget council members |
| `gpt-5-nano` | Fastest | High-volume, low-cost |
| `o4-mini` | Reasoning | Deep thinking tasks |
| `o3` | Reasoning | Complex multi-step analysis |

**Usage after installation:**

```ts
import OpenAI from "openai";

const openai = new OpenAI();

async function queryOpenAI(model: string, prompt: string): Promise<string> {
  const response = await openai.chat.completions.create({
    model,
    messages: [{ role: "user", content: prompt }],
  });
  return response.choices[0]?.message?.content ?? "";
}
```

---

### Anthropic

**Blueprint ID:** `blueprint:javascript_anthropic_ai_integrations`

**Available Models:**

| Model | Type | Best For |
|-------|------|----------|
| `claude-opus-4-6` | Most capable | Deep reasoning, chairman role |
| `claude-sonnet-4-5` | Balanced | Coding, concise analysis |
| `claude-haiku-4-5` | Fast | Budget council, quick tasks |

**Usage after installation:**

```ts
import Anthropic from "@anthropic-ai/sdk";

const anthropic = new Anthropic();

async function queryAnthropic(model: string, prompt: string): Promise<string> {
  const response = await anthropic.messages.create({
    model,
    max_tokens: 4096,
    messages: [{ role: "user", content: prompt }],
  });
  const block = response.content[0];
  return block.type === "text" ? block.text : "";
}
```

---

### Gemini

**Blueprint ID:** `blueprint:javascript_gemini_ai_integrations`

**Available Models:**

| Model | Type | Best For |
|-------|------|----------|
| `gemini-3-pro-preview` | Latest flagship | Complex synthesis |
| `gemini-3-flash-preview` | Latest fast | Budget council |
| `gemini-2.5-pro` | Stable flagship | Reliable reasoning |
| `gemini-2.5-flash` | Stable fast | High-volume tasks |

**Usage after installation:**

```ts
import { GoogleGenAI } from "@google/genai";

const genai = new GoogleGenAI();

async function queryGemini(model: string, prompt: string): Promise<string> {
  const response = await genai.models.generateContent({
    model,
    contents: prompt,
  });
  return response.text ?? "";
}
```

---

### OpenRouter

**Blueprint ID:** `blueprint:javascript_openrouter_ai_integrations`

**Available Models (examples):**

| Model | Provider | Best For |
|-------|----------|----------|
| `meta-llama/llama-4-maverick` | Meta | Diverse perspective |
| `mistralai/mistral-large-latest` | Mistral | European AI perspective |
| `qwen/qwen3-235b-a22b` | Alibaba | Multilingual reasoning |
| `deepseek/deepseek-r1` | DeepSeek | Chain-of-thought reasoning |

OpenRouter provides access to hundreds of models from various providers. Browse available models at [openrouter.ai/models](https://openrouter.ai/models).

**Usage after installation:**

When using Replit AI Integrations, authentication is handled automatically — no API key needed. The integration blueprint configures the SDK client for you. Refer to the blueprint's setup instructions for the exact import and initialization pattern, as it may configure the OpenAI-compatible client with the correct base URL and auth headers automatically.

```ts
import OpenAI from "openai";

// Replit AI Integrations handles auth automatically
// The blueprint configures baseURL and API key via environment
const openrouter = new OpenAI({
  baseURL: "https://openrouter.ai/api/v1",
});

async function queryOpenRouter(model: string, prompt: string): Promise<string> {
  const response = await openrouter.chat.completions.create({
    model,
    messages: [{ role: "user", content: prompt }],
  });
  return response.choices[0]?.message?.content ?? "";
}
```

> **Note:** If using OpenRouter outside of Replit AI Integrations (e.g., direct API access), you'll need to set an `OPENROUTER_API_KEY` secret and pass it as `apiKey` to the OpenAI constructor.

---

## Unified Provider Interface

Create a single abstraction layer so the council orchestrator doesn't need to know which SDK to call.

### Types (`server/lib/council-types.ts`)

```ts
export interface ModelConfig {
  provider: "openai" | "anthropic" | "gemini" | "openrouter" | "xai";
  model: string;
  label?: string;
}

export interface ModelResponse {
  config: ModelConfig;
  response: string;
  durationMs: number;
}
```

### Provider Router (`server/lib/llm-providers.ts`)

```ts
import OpenAI from "openai";
import Anthropic from "@anthropic-ai/sdk";
import { GoogleGenAI } from "@google/genai";
import type { ModelConfig, ModelResponse } from "./council-types";

const openai = new OpenAI();
const anthropic = new Anthropic();
const genai = new GoogleGenAI();
// Replit AI Integrations handles auth — check blueprint setup for exact config
const openrouter = new OpenAI({
  baseURL: "https://openrouter.ai/api/v1",
});

export async function queryModel(
  config: ModelConfig,
  prompt: string,
): Promise<ModelResponse> {
  const start = Date.now();
  let response: string;

  switch (config.provider) {
    case "openai": {
      const res = await openai.chat.completions.create({
        model: config.model,
        messages: [{ role: "user", content: prompt }],
      });
      response = res.choices[0]?.message?.content ?? "";
      break;
    }

    case "anthropic": {
      const res = await anthropic.messages.create({
        model: config.model,
        max_tokens: 4096,
        messages: [{ role: "user", content: prompt }],
      });
      const block = res.content[0];
      response = block.type === "text" ? block.text : "";
      break;
    }

    case "gemini": {
      const res = await genai.models.generateContent({
        model: config.model,
        contents: prompt,
      });
      response = res.text ?? "";
      break;
    }

    case "openrouter": {
      const res = await openrouter.chat.completions.create({
        model: config.model,
        messages: [{ role: "user", content: prompt }],
      });
      response = res.choices[0]?.message?.content ?? "";
      break;
    }

    case "xai": {
      const xai = new OpenAI({
        baseURL: "https://api.x.ai/v1",
        apiKey: process.env.XAI_API_KEY,
      });
      const res = await xai.chat.completions.create({
        model: config.model,
        messages: [{ role: "user", content: prompt }],
      });
      response = res.choices[0]?.message?.content ?? "";
      break;
    }

    default:
      throw new Error(`Unknown provider: ${config.provider}`);
  }

  return {
    config,
    response,
    durationMs: Date.now() - start,
  };
}
```

---

## Parallel Query Pattern

Query all council models simultaneously with timeout and error resilience.

```ts
const DEFAULT_TIMEOUT_MS = 60_000;

function withTimeout<T>(promise: Promise<T>, ms: number): Promise<T> {
  return new Promise((resolve, reject) => {
    const timer = setTimeout(
      () => reject(new Error(`Timeout after ${ms}ms`)),
      ms,
    );
    promise.then(
      (val) => {
        clearTimeout(timer);
        resolve(val);
      },
      (err) => {
        clearTimeout(timer);
        reject(err);
      },
    );
  });
}

export async function queryModelsParallel(
  models: ModelConfig[],
  prompt: string,
  timeoutMs: number = DEFAULT_TIMEOUT_MS,
  onModelComplete?: (result: ModelResponse) => void,
  onModelError?: (config: ModelConfig, error: Error) => void,
): Promise<ModelResponse[]> {
  const results = await Promise.allSettled(
    models.map((config) =>
      withTimeout(queryModel(config, prompt), timeoutMs).then((result) => {
        onModelComplete?.(result);
        return result;
      }),
    ),
  );

  const successful: ModelResponse[] = [];

  results.forEach((result, index) => {
    if (result.status === "fulfilled") {
      successful.push(result.value);
    } else {
      const error =
        result.reason instanceof Error
          ? result.reason
          : new Error(String(result.reason));
      onModelError?.(models[index], error);
      console.error(
        `[Council] ${models[index].provider}/${models[index].model} failed: ${error.message}`,
      );
    }
  });

  if (successful.length < 2) {
    throw new Error(
      `Council requires at least 2 responses, only got ${successful.length}`,
    );
  }

  return successful;
}
```

### Usage Example

```ts
const council: ModelConfig[] = [
  { provider: "openai", model: "gpt-5.2", label: "GPT-5.2" },
  { provider: "anthropic", model: "claude-sonnet-4-5", label: "Claude Sonnet" },
  { provider: "gemini", model: "gemini-3-pro-preview", label: "Gemini Pro" },
  {
    provider: "openrouter",
    model: "meta-llama/llama-4-maverick",
    label: "Llama Maverick",
  },
];

const responses = await queryModelsParallel(
  council,
  "What are the key considerations for building a distributed system?",
  60_000,
  (result) =>
    console.log(
      `✓ ${result.config.label} responded in ${result.durationMs}ms`,
    ),
  (config, error) => console.warn(`✗ ${config.label} failed: ${error.message}`),
);
```

---

## Optional: xAI/Grok

xAI is **not** available via Replit AI Integrations. It requires a separate API key.

**Blueprint ID:** `blueprint:javascript_xai`

**Setup:**
1. Add your xAI API key as a secret named `XAI_API_KEY`
2. Install the blueprint: `use_integration` with `blueprint:javascript_xai`

**Usage:**

```ts
import OpenAI from "openai";

const xai = new OpenAI({
  baseURL: "https://api.x.ai/v1",
  apiKey: process.env.XAI_API_KEY,
});

async function queryXAI(model: string, prompt: string): Promise<string> {
  const response = await xai.chat.completions.create({
    model,
    messages: [{ role: "user", content: prompt }],
  });
  return response.choices[0]?.message?.content ?? "";
}
```

**Available Models:** Grok models (check xAI docs for latest).

> **Note:** xAI is optional for the council. The four Replit AI Integration providers give sufficient model diversity for most use cases.

---

## Error Handling

### Timeout Handling

Each model call should be wrapped with a timeout (60s default). The `withTimeout` helper shown above prevents a single slow model from blocking the entire council pipeline.

```ts
try {
  const result = await withTimeout(queryModel(config, prompt), 60_000);
} catch (error) {
  if (error.message.includes("Timeout")) {
    console.warn(`${config.label} timed out — skipping`);
  }
}
```

### Rate Limiting

Replit AI Integrations have rate limits per provider. Handle 429 responses with exponential backoff:

```ts
async function queryWithRetry(
  config: ModelConfig,
  prompt: string,
  maxRetries: number = 2,
): Promise<ModelResponse> {
  for (let attempt = 0; attempt <= maxRetries; attempt++) {
    try {
      return await queryModel(config, prompt);
    } catch (error: any) {
      const isRateLimit =
        error?.status === 429 || error?.message?.includes("rate");
      if (isRateLimit && attempt < maxRetries) {
        const delay = Math.pow(2, attempt) * 1000;
        console.warn(
          `${config.label} rate limited, retrying in ${delay}ms...`,
        );
        await new Promise((resolve) => setTimeout(resolve, delay));
        continue;
      }
      throw error;
    }
  }
  throw new Error("Unreachable");
}
```

### Graceful Degradation

The council is designed to continue with partial results:

| Scenario | Behavior |
|----------|----------|
| 1 model fails out of 4 | Continue with 3 responses |
| 2 models fail out of 4 | Continue with 2 responses (minimum) |
| 3+ models fail out of 4 | Throw error — insufficient diversity |
| Chairman model fails | Fall back to next strongest model |

```ts
export async function queryWithFallbackChairman(
  chairmanCandidates: ModelConfig[],
  prompt: string,
): Promise<ModelResponse> {
  for (const candidate of chairmanCandidates) {
    try {
      return await withTimeout(queryModel(candidate, prompt), 90_000);
    } catch (error) {
      console.warn(
        `Chairman ${candidate.label} failed, trying next candidate...`,
      );
    }
  }
  throw new Error("All chairman candidates failed");
}

const chairmanFallbacks: ModelConfig[] = [
  { provider: "openai", model: "gpt-5.2", label: "GPT-5.2" },
  { provider: "anthropic", model: "claude-opus-4-6", label: "Claude Opus" },
  { provider: "gemini", model: "gemini-3-pro-preview", label: "Gemini Pro" },
];
```
