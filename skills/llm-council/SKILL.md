---
name: llm-council
description: Implement a multi-model LLM Council that queries multiple AI providers in parallel, performs anonymized peer review, and synthesizes a final answer via a Chairman model. Use when building multi-model consensus, LLM ensemble, model comparison, peer review AI, multi-provider orchestration, collaborative AI reasoning, or any feature that benefits from combining outputs from multiple language models. Based on Andrej Karpathy's LLM Council architecture.
---

# LLM Council

Multi-model AI orchestration framework that queries multiple LLMs in parallel, has them peer-review each other's responses anonymously, and synthesizes a final answer through a designated Chairman model. Reduces single-model bias, surfaces diverse reasoning, and produces higher-quality outputs through ensemble consensus.

## When to Use This Skill

- Building multi-model AI consensus or ensemble systems
- Querying multiple LLMs and comparing/combining their outputs
- Implementing peer review between AI models
- Creating a "council of experts" for complex decisions
- Building model comparison or evaluation tools
- Any feature that benefits from multiple AI perspectives (strategy, analysis, creative)
- Implementing the Karpathy LLM Council pattern

## Architecture Overview

```
server/lib/
├── llm-providers.ts       ← Provider abstraction: queryModel(), queryModelsParallel()
├── council.ts             ← Orchestrator: runFullCouncil() with 3-stage pipeline
├── council-prompts.ts     ← Prompt templates for each stage
└── council-types.ts       ← TypeScript interfaces

server/routes/
└── council.ts             ← SSE endpoint: /api/council/run

client/src/
├── hooks/useCouncil.ts    ← SSE stream consumer + state management
└── components/
    └── CouncilProgress.tsx ← Real-time progress modal
```

## The 3-Stage Process

### Stage 1: Independent Responses
All configured models are queried **in parallel** with the same prompt. Each model generates its response independently, preventing groupthink and capturing diverse reasoning styles.

### Stage 2: Peer Review
All Stage 1 responses are **anonymized** (labeled "Response A", "Response B", etc.) and sent back to each model. Each model ranks and critiques the others' responses on quality, accuracy, and completeness. Models don't know which model produced which response.

### Stage 3: Chairman Synthesis
A designated Chairman model (typically the strongest available) receives:
- The original prompt
- All individual responses
- All peer rankings and commentary

It produces a single final output that merges the best insights, weighted by peer consensus.

## Available Providers (Replit AI Integrations)

No API keys required for these — they use Replit AI Integrations, billed to your credits:

| Provider | Models | Best For |
|----------|--------|----------|
| **OpenAI** | gpt-5.2, gpt-5.1, gpt-5, gpt-5-mini, o4-mini, o3 | General reasoning, verbose analysis |
| **Anthropic** | claude-opus-4-6, claude-sonnet-4-5, claude-haiku-4-5 | Coding, concise reasoning |
| **Gemini** | gemini-3-pro-preview, gemini-3-flash-preview, gemini-2.5-pro | Synthesis, balanced output |
| **OpenRouter** | Llama, Mistral, Qwen, DeepSeek, etc. | Diverse perspectives, long-tail models |

**Optional (API key required):**

| Provider | Models | Setup |
|----------|--------|-------|
| **xAI** | Grok models | Requires `XAI_API_KEY` secret |

### Recommended Council Configurations

**Balanced (4 models):**
```ts
const COUNCIL = [
  { provider: 'openai', model: 'gpt-5.2' },
  { provider: 'anthropic', model: 'claude-sonnet-4-5' },
  { provider: 'gemini', model: 'gemini-3-pro-preview' },
  { provider: 'openrouter', model: 'meta-llama/llama-4-maverick' },
];
const CHAIRMAN = { provider: 'openai', model: 'gpt-5.2' };
```

**Budget (3 models, fast):**
```ts
const COUNCIL = [
  { provider: 'openai', model: 'gpt-5-mini' },
  { provider: 'anthropic', model: 'claude-haiku-4-5' },
  { provider: 'gemini', model: 'gemini-3-flash-preview' },
];
const CHAIRMAN = { provider: 'gemini', model: 'gemini-3-flash-preview' };
```

**Deep reasoning (3 thinking models):**
```ts
const COUNCIL = [
  { provider: 'openai', model: 'o4-mini' },
  { provider: 'anthropic', model: 'claude-opus-4-6' },
  { provider: 'gemini', model: 'gemini-2.5-pro' },
];
const CHAIRMAN = { provider: 'anthropic', model: 'claude-opus-4-6' };
```

## Implementation Flow

```
User submits prompt
        │
        ▼
[Stage 1] queryModelsParallel(council, prompt)
        │  ← All models respond in parallel
        ▼
[Stage 2] queryModelsParallel(council, peerReviewPrompt)
        │  ← Each model ranks anonymized responses
        ▼
[Stage 3] queryModel(chairman, synthesisPrompt)
        │  ← Chairman merges best insights
        ▼
Final response returned to user
```

Progress is streamed to the client via **Server-Sent Events (SSE)** so users see real-time status of which models are working, completed, and what stage the council is on.

## Cost Considerations

Each council query multiplies API costs:
- **Stage 1**: N model calls (parallel)
- **Stage 2**: N model calls (parallel)
- **Stage 3**: 1 Chairman call
- **Total**: 2N + 1 calls per council query

Use budget configurations for high-volume or non-critical tasks. Reserve deep reasoning configurations for complex analysis.

## Key Design Decisions

| Decision | Recommendation |
|----------|----------------|
| Chairman model | Use the strongest available (gpt-5.2 or claude-opus-4-6) |
| Minimum council size | 3 models for meaningful diversity |
| Maximum council size | 5-6 models (diminishing returns beyond) |
| Anonymization | Always anonymize in Stage 2 (prevents model favoritism) |
| Timeout per model | 60-90 seconds; don't block council on one slow model |
| Error handling | Skip failed models, proceed with remaining (min 2 required) |

## Reference Files

- **Provider setup**: See [references/provider-setup.md](references/provider-setup.md) — Replit AI Integrations setup for all providers
- **Council orchestrator**: See [references/council-orchestrator.md](references/council-orchestrator.md) — `runFullCouncil()` implementation pattern
- **Prompt templates**: See [references/prompt-templates.md](references/prompt-templates.md) — Stage 1, 2, 3 prompt templates
- **SSE streaming**: See [references/sse-streaming.md](references/sse-streaming.md) — Server-Sent Events progress streaming + client UI
