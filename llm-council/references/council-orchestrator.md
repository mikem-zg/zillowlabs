# Council Orchestrator — `runFullCouncil()` Implementation

## Overview

The council orchestrator runs the 3-stage LLM Council pipeline: independent responses → anonymized peer review → chairman synthesis. It uses `queryModel()` and `queryModelsParallel()` from [provider-setup.md](provider-setup.md) and fires progress callbacks throughout for real-time SSE streaming.

---

## Types

```ts
import type { ModelConfig, ModelResponse } from "./council-types";

interface CouncilConfig {
  models: ModelConfig[];
  chairman: ModelConfig;
  timeout?: number;
}

interface CouncilModelResponse {
  model: ModelConfig;
  response: string;
  duration: number;
  error?: string;
}

interface PeerReview {
  reviewer: ModelConfig;
  rankings: { label: string; rank: number; commentary: string }[];
}

interface CouncilResult {
  stage1Responses: CouncilModelResponse[];
  stage2Reviews: PeerReview[];
  stage3Synthesis: string;
  chairman: ModelConfig;
  totalDuration: number;
}

type CouncilProgress = {
  stage: 1 | 2 | 3;
  model: string;
  status: "pending" | "working" | "done" | "error";
  message?: string;
};
```

---

## Anonymization Logic

Responses from Stage 1 are anonymized before peer review so models can't identify (or favor) specific providers. Each response is assigned a letter label — "Response A", "Response B", etc. — and a mapping is kept to de-anonymize after review.

```ts
const LABELS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

interface AnonymizedResponse {
  label: string;
  response: string;
}

interface AnonymizationMap {
  labelToModel: Map<string, ModelConfig>;
  anonymized: AnonymizedResponse[];
}

function anonymizeResponses(
  responses: CouncilModelResponse[],
): AnonymizationMap {
  const labelToModel = new Map<string, ModelConfig>();
  const anonymized: AnonymizedResponse[] = [];

  responses.forEach((r, i) => {
    const label = `Response ${LABELS[i]}`;
    labelToModel.set(label, r.model);
    anonymized.push({ label, response: r.response });
  });

  return { labelToModel, anonymized };
}

function formatAnonymizedForPrompt(anonymized: AnonymizedResponse[]): string {
  return anonymized
    .map((a) => `### ${a.label}\n\n${a.response}`)
    .join("\n\n---\n\n");
}
```

---

## `runFullCouncil()` Implementation

```ts
import { queryModel, queryModelsParallel } from "./llm-providers";
import {
  buildPeerReviewPrompt,
  buildSynthesisPrompt,
} from "./council-prompts";

const DEFAULT_TIMEOUT_MS = 60_000;

export async function runFullCouncil(
  config: CouncilConfig,
  prompt: string,
  onProgress?: (progress: CouncilProgress) => void,
): Promise<CouncilResult> {
  const councilStart = Date.now();
  const timeoutMs = config.timeout ?? DEFAULT_TIMEOUT_MS;

  // ── Stage 1: Independent Responses ──────────────────────────
  onProgress?.({
    stage: 1,
    model: "all",
    status: "pending",
    message: "Starting Stage 1: Independent responses",
  });

  config.models.forEach((m) =>
    onProgress?.({
      stage: 1,
      model: m.label ?? `${m.provider}/${m.model}`,
      status: "working",
    }),
  );

  const stage1Responses: CouncilModelResponse[] = [];

  const rawStage1 = await queryModelsParallel(
    config.models,
    prompt,
    timeoutMs,
    (result) => {
      const label = result.config.label ?? `${result.config.provider}/${result.config.model}`;
      stage1Responses.push({
        model: result.config,
        response: result.response,
        duration: result.durationMs,
      });
      onProgress?.({ stage: 1, model: label, status: "done" });
    },
    (failedConfig, error) => {
      const label = failedConfig.label ?? `${failedConfig.provider}/${failedConfig.model}`;
      onProgress?.({
        stage: 1,
        model: label,
        status: "error",
        message: error.message,
      });
    },
  );

  // queryModelsParallel already throws if fewer than 2 succeed

  // ── Stage 2: Peer Review ────────────────────────────────────
  onProgress?.({
    stage: 2,
    model: "all",
    status: "pending",
    message: "Starting Stage 2: Peer review",
  });

  const { labelToModel, anonymized } = anonymizeResponses(stage1Responses);
  const anonymizedBlock = formatAnonymizedForPrompt(anonymized);

  const peerReviewPrompt = buildPeerReviewPrompt(prompt, anonymizedBlock);

  const stage2Reviews: PeerReview[] = [];

  config.models.forEach((m) =>
    onProgress?.({
      stage: 2,
      model: m.label ?? `${m.provider}/${m.model}`,
      status: "working",
    }),
  );

  // In Stage 2, all models that succeeded in Stage 1 review each other
  const reviewerModels = stage1Responses.map((r) => r.model);

  await queryModelsParallel(
    reviewerModels,
    peerReviewPrompt,
    timeoutMs,
    (result) => {
      const label = result.config.label ?? `${result.config.provider}/${result.config.model}`;
      try {
        const parsed = parsePeerReviewResponse(result.response, anonymized);
        stage2Reviews.push({
          reviewer: result.config,
          rankings: parsed,
        });
      } catch {
        stage2Reviews.push({
          reviewer: result.config,
          rankings: anonymized.map((a, i) => ({
            label: a.label,
            rank: i + 1,
            commentary: result.response,
          })),
        });
      }
      onProgress?.({ stage: 2, model: label, status: "done" });
    },
    (failedConfig, error) => {
      const label = failedConfig.label ?? `${failedConfig.provider}/${failedConfig.model}`;
      onProgress?.({
        stage: 2,
        model: label,
        status: "error",
        message: error.message,
      });
      // Stage 2 failures are non-fatal — skip the review
    },
  ).catch(() => {
    // If fewer than 2 reviewers succeed, we still continue.
    // Peer review is best-effort; Stage 3 can work with partial reviews.
  });

  // ── Stage 3: Chairman Synthesis ─────────────────────────────
  const chairmanLabel =
    config.chairman.label ??
    `${config.chairman.provider}/${config.chairman.model}`;

  onProgress?.({
    stage: 3,
    model: chairmanLabel,
    status: "working",
    message: "Starting Stage 3: Chairman synthesis",
  });

  const synthesisPrompt = buildSynthesisPrompt(
    prompt,
    anonymizedBlock,
    stage2Reviews,
  );

  let synthesisResponse: string;
  try {
    const result = await queryModel(config.chairman, synthesisPrompt);
    synthesisResponse = result.response;
    onProgress?.({ stage: 3, model: chairmanLabel, status: "done" });
  } catch (error) {
    onProgress?.({
      stage: 3,
      model: chairmanLabel,
      status: "error",
      message: error instanceof Error ? error.message : String(error),
    });
    // Stage 3 failure is fatal — the council cannot produce output without synthesis
    throw new Error(
      `Chairman synthesis failed: ${error instanceof Error ? error.message : String(error)}`,
    );
  }

  const totalDuration = Date.now() - councilStart;

  return {
    stage1Responses,
    stage2Reviews,
    stage3Synthesis: synthesisResponse,
    chairman: config.chairman,
    totalDuration,
  };
}
```

---

## Parsing Peer Review Responses

The peer review prompt asks models to return structured JSON rankings. This parser extracts them, with a fallback for unstructured responses.

```ts
function parsePeerReviewResponse(
  raw: string,
  anonymized: AnonymizedResponse[],
): { label: string; rank: number; commentary: string }[] {
  // Try to extract JSON from the response
  const jsonMatch = raw.match(/\[[\s\S]*?\]/);
  if (jsonMatch) {
    try {
      const parsed = JSON.parse(jsonMatch[0]);
      if (
        Array.isArray(parsed) &&
        parsed.every((p: any) => p.label && typeof p.rank === "number")
      ) {
        return parsed.map((p: any) => ({
          label: String(p.label),
          rank: Number(p.rank),
          commentary: String(p.commentary ?? ""),
        }));
      }
    } catch {
      // Fall through to heuristic parsing
    }
  }

  // Heuristic: assign ranks based on order of mention
  const rankings: { label: string; rank: number; commentary: string }[] = [];
  anonymized.forEach((a, i) => {
    rankings.push({
      label: a.label,
      rank: i + 1,
      commentary: extractCommentaryForLabel(raw, a.label),
    });
  });
  return rankings;
}

function extractCommentaryForLabel(raw: string, label: string): string {
  const regex = new RegExp(
    `${label.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}[:\\s]*([^\\n]+(?:\\n(?!Response [A-Z])[^\\n]+)*)`,
    "i",
  );
  const match = raw.match(regex);
  return match?.[1]?.trim() ?? "";
}
```

---

## Error Resilience

The orchestrator handles failures at each stage differently:

| Stage | On Failure | Behavior |
|-------|-----------|----------|
| **Stage 1** | A model fails or times out | Skip it, continue with remaining. `queryModelsParallel()` handles this via `Promise.allSettled()`. |
| **Stage 1** | Fewer than 2 models succeed | `queryModelsParallel()` throws — council cannot proceed without diversity. |
| **Stage 2** | A reviewer fails | Skip its review. The chairman can synthesize with partial reviews. |
| **Stage 2** | All reviewers fail | Continue to Stage 3 with empty reviews. Chairman works from Stage 1 responses alone. |
| **Stage 3** | Chairman fails | **Fatal.** Throw an error. The council has no output without synthesis. |

```ts
// Stage 2 is wrapped in a .catch() to make it non-fatal:
await queryModelsParallel(reviewerModels, peerReviewPrompt, timeoutMs, ...)
  .catch(() => {
    // Peer review is best-effort
  });

// Stage 3 failure rethrows:
try {
  const result = await queryModel(config.chairman, synthesisPrompt);
} catch (error) {
  throw new Error(`Chairman synthesis failed: ${error.message}`);
}
```

For chairman resilience, consider using the fallback pattern from [provider-setup.md](provider-setup.md) (`queryWithFallbackChairman`) to try alternate models if the primary chairman fails.

---

## Duration Tracking

Timing is tracked at two levels:

**Per-model timing** — Each `queryModel()` call tracks its own duration internally (via `Date.now()` diff), returned as `durationMs` in `ModelResponse`. This is mapped to `CouncilModelResponse.duration` for each stage.

**Total council timing** — The orchestrator records `Date.now()` at the start and computes `totalDuration` after Stage 3 completes.

```ts
const councilStart = Date.now();

// ... all three stages ...

const totalDuration = Date.now() - councilStart;

return {
  stage1Responses,    // each has .duration in ms
  stage2Reviews,
  stage3Synthesis,
  chairman: config.chairman,
  totalDuration,      // total wall-clock time in ms
};
```

This lets the client display per-model response times (useful for comparing provider speed) and total council duration (useful for UX expectations).

---

## Usage Example

```ts
import { runFullCouncil } from "./council";
import type { CouncilConfig, CouncilProgress } from "./council-types";

const config: CouncilConfig = {
  models: [
    { provider: "openai", model: "gpt-5.2", label: "GPT-5.2" },
    { provider: "anthropic", model: "claude-sonnet-4-5", label: "Claude Sonnet" },
    { provider: "gemini", model: "gemini-3-pro-preview", label: "Gemini Pro" },
  ],
  chairman: { provider: "openai", model: "gpt-5.2", label: "GPT-5.2" },
  timeout: 60_000,
};

// Express SSE endpoint
app.get("/api/council/run", async (req, res) => {
  res.setHeader("Content-Type", "text/event-stream");
  res.setHeader("Cache-Control", "no-cache");
  res.setHeader("Connection", "keep-alive");

  const prompt = req.query.prompt as string;

  const onProgress = (progress: CouncilProgress) => {
    res.write(`data: ${JSON.stringify({ type: "progress", ...progress })}\n\n`);
  };

  try {
    const result = await runFullCouncil(config, prompt, onProgress);
    res.write(`data: ${JSON.stringify({ type: "result", ...result })}\n\n`);
  } catch (error) {
    res.write(
      `data: ${JSON.stringify({ type: "error", message: error instanceof Error ? error.message : String(error) })}\n\n`,
    );
  } finally {
    res.end();
  }
});
```
