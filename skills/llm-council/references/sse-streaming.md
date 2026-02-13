# SSE Streaming — Real-Time Council Progress

Stream council progress to the client via Server-Sent Events so users see which models are working, which have completed, and what stage the council is on.

## Event Types

All events are sent as `data: JSON.stringify(event)\n\n`. The stream ends with `data: [DONE]\n\n`.

```ts
type ProgressEvent =
  | { type: 'stage_start'; stage: 1 | 2 | 3 }
  | { type: 'model_start'; model: string; stage: number }
  | { type: 'model_complete'; model: string; stage: number; duration: number }
  | { type: 'model_error'; model: string; stage: number; error: string }
  | { type: 'stage_complete'; stage: number }
  | { type: 'result'; data: CouncilResult }
  | { type: 'error'; message: string };
```

---

## 1. Server-Side SSE Endpoint

Express.js route handler for `POST /api/council/run`. Sets SSE headers, accepts the user prompt, and streams progress events from `runFullCouncil()`.

```ts
// server/routes/council.ts
import { Router, Request, Response } from 'express';
import { runFullCouncil } from '../lib/council';
import type { ProgressEvent } from '../lib/council-types';

const router = Router();

router.post('/api/council/run', async (req: Request, res: Response) => {
  const { prompt, models, chairman } = req.body;

  if (!prompt) {
    return res.status(400).json({ error: 'prompt is required' });
  }

  // SSE headers
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  res.setHeader('X-Accel-Buffering', 'no'); // Disable nginx buffering
  res.flushHeaders();

  // Track client disconnect
  let clientDisconnected = false;
  req.on('close', () => {
    clientDisconnected = true;
  });

  const sendEvent = (event: ProgressEvent) => {
    if (clientDisconnected) return;
    res.write(`data: ${JSON.stringify(event)}\n\n`);
  };

  try {
    const result = await runFullCouncil({
      prompt,
      models,
      chairman,
      onProgress: (event: ProgressEvent) => {
        sendEvent(event);
      },
    });

    sendEvent({ type: 'result', data: result });
  } catch (err) {
    sendEvent({
      type: 'error',
      message: err instanceof Error ? err.message : 'Council execution failed',
    });
  } finally {
    if (!clientDisconnected) {
      res.write('data: [DONE]\n\n');
      res.end();
    }
  }
});

export default router;
```

### Key details

- **`X-Accel-Buffering: no`** prevents nginx/reverse proxies from buffering the stream.
- **`res.flushHeaders()`** sends headers immediately so the client can start reading.
- **`req.on('close')`** detects client disconnect to stop wasting work sending events to a dead connection.
- The `onProgress` callback is passed to `runFullCouncil()` — the orchestrator calls it at each stage/model transition.
- The final `data: [DONE]\n\n` sentinel tells the client the stream is complete.

---

## 2. Client-Side SSE Consumer

React hook that calls the SSE endpoint via `fetch()`, reads the response body as a stream, and parses SSE events into React state.

```ts
// client/src/hooks/useCouncil.ts
import { useState, useCallback, useRef } from 'react';

type ModelStatus = 'pending' | 'working' | 'done' | 'error';

interface ModelInfo {
  status: ModelStatus;
  duration?: number;
  error?: string;
}

interface CouncilState {
  stage: number;
  modelStatuses: Record<string, ModelInfo>;
  result: any | null;
  error: string | null;
  isRunning: boolean;
}

export function useCouncil() {
  const [state, setState] = useState<CouncilState>({
    stage: 0,
    modelStatuses: {},
    result: null,
    error: null,
    isRunning: false,
  });
  const abortRef = useRef<AbortController | null>(null);

  const runCouncil = useCallback(async (prompt: string) => {
    // Abort any existing run
    abortRef.current?.abort();
    const controller = new AbortController();
    abortRef.current = controller;

    setState({
      stage: 0,
      modelStatuses: {},
      result: null,
      error: null,
      isRunning: true,
    });

    try {
      const response = await fetch('/api/council/run', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ prompt }),
        signal: controller.signal,
      });

      if (!response.ok) {
        const errBody = await response.json().catch(() => ({}));
        throw new Error(errBody.error || `HTTP ${response.status}`);
      }

      const reader = response.body!.getReader();
      const decoder = new TextDecoder();
      let buffer = '';

      while (true) {
        const { done, value } = await reader.read();
        if (done) break;

        buffer += decoder.decode(value, { stream: true });
        const lines = buffer.split('\n');
        buffer = lines.pop() || '';

        for (const line of lines) {
          if (!line.startsWith('data: ')) continue;
          const payload = line.slice(6);

          if (payload === '[DONE]') {
            setState((prev) => ({ ...prev, isRunning: false }));
            return;
          }

          try {
            const event = JSON.parse(payload);
            setState((prev) => applyEvent(prev, event));
          } catch {
            // Skip malformed events
          }
        }
      }

      setState((prev) => ({ ...prev, isRunning: false }));
    } catch (err: any) {
      if (err.name === 'AbortError') return;
      setState((prev) => ({
        ...prev,
        error: err.message || 'Connection failed',
        isRunning: false,
      }));
    }
  }, []);

  const cancel = useCallback(() => {
    abortRef.current?.abort();
    setState((prev) => ({ ...prev, isRunning: false }));
  }, []);

  return {
    runCouncil,
    cancel,
    stage: state.stage,
    modelStatuses: state.modelStatuses,
    result: state.result,
    error: state.error,
    isRunning: state.isRunning,
  };
}

function applyEvent(prev: CouncilState, event: any): CouncilState {
  switch (event.type) {
    case 'stage_start':
      return { ...prev, stage: event.stage };

    case 'model_start':
      return {
        ...prev,
        modelStatuses: {
          ...prev.modelStatuses,
          [event.model]: { status: 'working' },
        },
      };

    case 'model_complete':
      return {
        ...prev,
        modelStatuses: {
          ...prev.modelStatuses,
          [event.model]: { status: 'done', duration: event.duration },
        },
      };

    case 'model_error':
      return {
        ...prev,
        modelStatuses: {
          ...prev.modelStatuses,
          [event.model]: { status: 'error', error: event.error },
        },
      };

    case 'stage_complete':
      return prev; // Stage transitions handled by stage_start

    case 'result':
      return { ...prev, result: event.data, isRunning: false };

    case 'error':
      return { ...prev, error: event.message, isRunning: false };

    default:
      return prev;
  }
}
```

### Key details

- **`fetch()` + `ReadableStream`** is used instead of `EventSource` because `EventSource` only supports GET requests. The council needs POST to send the prompt body.
- **`TextDecoder`** with `{ stream: true }` handles multi-byte characters split across chunks.
- **Buffer accumulation** handles partial lines — SSE events can arrive split across multiple chunks.
- **`AbortController`** allows canceling an in-flight council run.
- **`applyEvent()`** is a pure reducer that maps SSE events to state updates.

---

## 3. Progress Modal Component

Shows real-time council progress with stage indicator, per-model status, and final result display. Uses Constellation components where available — substitute with standard HTML/CSS if Constellation is not in the project.

```tsx
// client/src/components/CouncilProgressModal.tsx
import { Modal, Text, Heading, Icon } from '@zillow/constellation';
import {
  IconCheckCircleFilled,
  IconAlertFilled,
  IconMoreHorizFilled,
} from '@zillow/constellation-icons';
import { Flex, Box } from '@/styled-system/jsx';
import { css } from '@/styled-system/css';
import type { ModelInfo } from '../hooks/useCouncil';

// Note: If Constellation is not available, replace Modal with a <dialog> element,
// Text with <p>, Flex with a flexbox <div>, and Icon with inline SVGs or emoji.

const STAGE_LABELS: Record<number, string> = {
  1: 'Independent responses',
  2: 'Peer review',
  3: 'Chairman synthesis',
};

interface CouncilProgressModalProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  stage: number;
  modelStatuses: Record<string, ModelInfo>;
  result: any | null;
  error: string | null;
  isRunning: boolean;
}

export function CouncilProgressModal({
  open,
  onOpenChange,
  stage,
  modelStatuses,
  result,
  error,
  isRunning,
}: CouncilProgressModalProps) {
  return (
    <Modal
      size="md"
      open={open}
      onOpenChange={onOpenChange}
      dividers
      header={<Heading level={1}>LLM Council</Heading>}
      body={
        <Flex direction="column" gap="400">
          {/* Stage indicator */}
          {stage > 0 && (
            <Flex direction="column" gap="100">
              <Text textStyle="body-lg-bold">
                Stage {stage}/3: {STAGE_LABELS[stage] || ''}
              </Text>
              <Box
                className={css({
                  height: '4px',
                  borderRadius: '2px',
                  bg: 'bg.screen.neutral',
                  overflow: 'hidden',
                })}
              >
                <Box
                  className={css({
                    height: '100%',
                    borderRadius: '2px',
                    transition: 'width 0.3s ease',
                  })}
                  style={{
                    width: `${(stage / 3) * 100}%`,
                    backgroundColor: 'var(--color-icon-action-hero-default)',
                  }}
                />
              </Box>
            </Flex>
          )}

          {/* Model statuses */}
          {Object.keys(modelStatuses).length > 0 && (
            <Flex direction="column" gap="200">
              {Object.entries(modelStatuses).map(([model, info]) => (
                <Flex key={model} justify="space-between" align="center" gap="200">
                  <Flex align="center" gap="200">
                    <StatusIcon status={info.status} />
                    <Text textStyle="body">{model}</Text>
                  </Flex>
                  <Flex align="center" gap="200">
                    {info.status === 'done' && info.duration != null && (
                      <Text textStyle="body-sm" color="text.subtle">
                        {(info.duration / 1000).toFixed(1)}s
                      </Text>
                    )}
                    {info.status === 'error' && info.error && (
                      <Text textStyle="body-sm" color="text.subtle">
                        {info.error}
                      </Text>
                    )}
                  </Flex>
                </Flex>
              ))}
            </Flex>
          )}

          {/* Error display */}
          {error && (
            <Text textStyle="body" style={{ color: 'var(--color-text-action-critical-hero-default)' }}>
              {error}
            </Text>
          )}

          {/* Final result */}
          {result && !isRunning && (
            <Flex direction="column" gap="200">
              <Text textStyle="body-lg-bold">Council result</Text>
              <Box
                className={css({
                  p: '400',
                  borderRadius: 'node.md',
                  bg: 'bg.screen.neutral',
                })}
              >
                <Text textStyle="body">{result.finalResponse}</Text>
              </Box>
            </Flex>
          )}
        </Flex>
      }
    />
  );
}

function StatusIcon({ status }: { status: string }) {
  switch (status) {
    case 'done':
      return (
        <Icon size="sm" css={{ color: 'text.action.positive.hero.default' }}>
          <IconCheckCircleFilled />
        </Icon>
      );
    case 'error':
      return (
        <Icon size="sm" css={{ color: 'text.action.critical.hero.default' }}>
          <IconAlertFilled />
        </Icon>
      );
    case 'working':
      return (
        <Box
          className={css({
            width: '16px',
            height: '16px',
            borderRadius: '50%',
            border: '2px solid',
            borderColor: 'icon.action.hero.default',
            borderTopColor: 'transparent',
            animation: 'spin 0.8s linear infinite',
          })}
        />
      );
    case 'pending':
    default:
      return (
        <Icon size="sm" css={{ color: 'icon.muted' }}>
          <IconMoreHorizFilled />
        </Icon>
      );
  }
}
```

### Usage

```tsx
import { useCouncil } from '../hooks/useCouncil';
import { CouncilProgressModal } from '../components/CouncilProgressModal';
import { useState } from 'react';

function CouncilPage() {
  const [modalOpen, setModalOpen] = useState(false);
  const { runCouncil, stage, modelStatuses, result, error, isRunning } = useCouncil();

  const handleSubmit = (prompt: string) => {
    setModalOpen(true);
    runCouncil(prompt);
  };

  return (
    <>
      {/* Your prompt input UI */}
      <CouncilProgressModal
        open={modalOpen}
        onOpenChange={setModalOpen}
        stage={stage}
        modelStatuses={modelStatuses}
        result={result}
        error={error}
        isRunning={isRunning}
      />
    </>
  );
}
```

---

## 4. Error Handling

### Network errors

The `useCouncil` hook catches fetch failures and `AbortError` (from user cancellation). Non-abort errors are surfaced in the `error` state.

```ts
// Already handled in the hook:
catch (err: any) {
  if (err.name === 'AbortError') return; // User canceled — don't set error
  setState((prev) => ({
    ...prev,
    error: err.message || 'Connection failed',
    isRunning: false,
  }));
}
```

### Stream interruption

If the connection drops mid-stream (server crash, network issue), the `reader.read()` loop exits with `done: true` without receiving `[DONE]`. The hook sets `isRunning: false` at the end of the loop regardless, so the UI won't hang.

If partial results are needed, check `state.result` — if null but `modelStatuses` has entries, the council started but didn't finish. The UI can show "Council interrupted — partial results available" by checking:

```ts
const wasInterrupted = !isRunning && !result && !error && Object.keys(modelStatuses).length > 0;
```

### Server-side error handling

The server wraps `runFullCouncil()` in try/catch and sends an `error` event before closing the stream. Individual model failures are sent as `model_error` events — the council continues with remaining models (minimum 2 required).

```ts
// In the council orchestrator, per-model error handling:
const results = await Promise.allSettled(
  models.map(async (model) => {
    onProgress({ type: 'model_start', model: model.id, stage });
    const start = Date.now();
    try {
      const response = await queryModel(model, prompt);
      onProgress({
        type: 'model_complete',
        model: model.id,
        stage,
        duration: Date.now() - start,
      });
      return response;
    } catch (err) {
      onProgress({
        type: 'model_error',
        model: model.id,
        stage,
        error: err instanceof Error ? err.message : 'Unknown error',
      });
      throw err;
    }
  })
);

const successful = results.filter((r) => r.status === 'fulfilled');
if (successful.length < 2) {
  throw new Error('Too many model failures — need at least 2 responses');
}
```

### Client disconnect

The server checks `clientDisconnected` before writing events. This prevents `ERR_STREAM_WRITE_AFTER_END` errors when the client navigates away or closes the tab mid-council.

```ts
req.on('close', () => {
  clientDisconnected = true;
});

const sendEvent = (event: ProgressEvent) => {
  if (clientDisconnected) return;
  res.write(`data: ${JSON.stringify(event)}\n\n`);
};
```

> **Note:** Client disconnect doesn't automatically cancel the council's LLM calls. If you want to abort in-flight model queries when the client disconnects, pass an `AbortSignal` into `runFullCouncil()` and check it before each stage.
