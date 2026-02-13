# Prompt Templates — LLM Council Stages 1, 2, 3

## Overview

These TypeScript template functions generate the prompts for each stage of the LLM Council pipeline. Import and use them in `council-prompts.ts` (or inline in your orchestrator).

---

## Stage 1: Independent Response

Each council model receives this prompt independently. It wraps the user's question with instructions for a thorough answer. It does **not** mention other models.

```ts
function buildStage1Prompt(userPrompt: string, context?: string): string {
  const contextBlock = context
    ? `\n\nAdditional context:\n${context}\n`
    : "";

  return `You are a knowledgeable expert. Answer the following question or complete the following task thoroughly and accurately.

Provide a well-structured, comprehensive response. Use concrete examples, data, or reasoning where appropriate. If the question is ambiguous, state your assumptions.
${contextBlock}
Question/Task:
${userPrompt}`;
}
```

**Key design choices:**
- No mention of other models or a council — each model believes it is the sole responder
- `context` is optional — use it to inject documents, prior conversation, user preferences, or domain data
- Keeps instructions minimal to avoid biasing the model's natural reasoning style

---

## Stage 2: Peer Review

Each model receives all Stage 1 responses (anonymized) and ranks them. The output is structured JSON for reliable parsing.

```ts
interface AnonymizedResponse {
  label: string;   // "Response A", "Response B", etc.
  response: string;
}

function buildPeerReviewPrompt(
  userPrompt: string,
  anonymizedResponses: AnonymizedResponse[]
): string {
  const responsesBlock = anonymizedResponses
    .map((r) => `### ${r.label}\n${r.response}`)
    .join("\n\n---\n\n");

  return `You are an impartial evaluator. Below is a question followed by several candidate responses. Evaluate purely on quality. You do not know which model produced which response.

## Original Question
${userPrompt}

## Candidate Responses

${responsesBlock}

## Your Task

Rank all responses from best (rank 1) to worst. For each response, identify specific strengths, weaknesses, and provide brief commentary.

Return your evaluation as a JSON object with this exact structure:

\`\`\`json
{
  "rankings": [
    {
      "label": "Response A",
      "rank": 1,
      "strengths": "Clear structure, accurate data, addresses all parts of the question",
      "weaknesses": "Could provide more examples",
      "commentary": "Overall the strongest response due to depth and accuracy"
    }
  ]
}
\`\`\`

Rules:
- Every response must appear exactly once in your rankings
- Ranks must be unique integers from 1 (best) to ${anonymizedResponses.length} (worst)
- Be specific in strengths/weaknesses — reference actual content
- Return ONLY the JSON object, no additional text`;
}
```

**Key design choices:**
- Explicit instruction that the reviewer does not know which model produced which response
- Forces structured JSON output for reliable downstream parsing
- Requires specific commentary (not just a number) to inform the Chairman

---

## Stage 3: Chairman Synthesis

The Chairman model receives the original question, all individual responses, and the aggregated peer rankings. It produces a single best-possible answer.

```ts
interface LabeledResponse {
  label: string;
  response: string;
}

interface PeerRanking {
  reviewer: string;   // "Reviewer 1", "Reviewer 2", etc.
  rankings: {
    label: string;
    rank: number;
    strengths?: string;
    weaknesses?: string;
    commentary?: string;
  }[];
}

function buildSynthesisPrompt(
  userPrompt: string,
  responses: LabeledResponse[],
  peerRankings: PeerRanking[]
): string {
  const responsesBlock = responses
    .map((r) => `### ${r.label}\n${r.response}`)
    .join("\n\n---\n\n");

  const rankingsBlock = peerRankings
    .map((pr) => {
      const rows = pr.rankings
        .sort((a, b) => a.rank - b.rank)
        .map((r) => `  ${r.rank}. ${r.label} — ${r.commentary || "No commentary"}`)
        .join("\n");
      return `**${pr.reviewer}:**\n${rows}`;
    })
    .join("\n\n");

  return `You are the Chairman of an expert council. Multiple experts independently answered a question, then peer-reviewed each other's responses. Your job is to synthesize a single, definitive answer.

## Original Question
${userPrompt}

## Individual Expert Responses

${responsesBlock}

## Peer Review Rankings

${rankingsBlock}

## Your Task

Produce the best possible answer by:
1. Drawing the strongest elements from each response
2. Weighing insights by peer consensus — higher-ranked responses should carry more weight
3. Resolving any conflicts or contradictions between responses
4. Correcting any errors identified in the peer reviews
5. Producing a coherent, well-structured final output

Do NOT simply pick one response. Synthesize and improve upon all of them. Your answer should be better than any individual response.`;
}
```

**Key design choices:**
- Chairman sees everything: raw responses + peer rankings with commentary
- Explicit instruction to synthesize (not just pick a winner)
- Rankings are sorted so the Chairman can quickly see consensus
- No JSON output requirement — the Chairman's output is the final user-facing answer

---

## Parsing Helpers

Stage 2 responses should be JSON, but models sometimes wrap it in markdown fences or add preamble text. This parser handles common variations.

```ts
interface ParsedRanking {
  label: string;
  rank: number;
  strengths: string;
  weaknesses: string;
  commentary: string;
}

interface ParsedPeerReview {
  rankings: ParsedRanking[];
}

function parsePeerReviewResponse(raw: string): ParsedPeerReview {
  // Try 1: Direct JSON parse
  try {
    const parsed = JSON.parse(raw);
    if (parsed.rankings && Array.isArray(parsed.rankings)) {
      return parsed as ParsedPeerReview;
    }
  } catch {}

  // Try 2: Extract JSON from markdown code fences
  const fenceMatch = raw.match(/```(?:json)?\s*\n?([\s\S]*?)\n?```/);
  if (fenceMatch) {
    try {
      const parsed = JSON.parse(fenceMatch[1].trim());
      if (parsed.rankings && Array.isArray(parsed.rankings)) {
        return parsed as ParsedPeerReview;
      }
    } catch {}
  }

  // Try 3: Find JSON object in the text
  const jsonMatch = raw.match(/\{[\s\S]*"rankings"[\s\S]*\}/);
  if (jsonMatch) {
    try {
      const parsed = JSON.parse(jsonMatch[0]);
      if (parsed.rankings && Array.isArray(parsed.rankings)) {
        return parsed as ParsedPeerReview;
      }
    } catch {}
  }

  // Try 4: Regex fallback — extract individual rankings
  const rankings: ParsedRanking[] = [];
  const labelPattern = /Response\s+([A-Z])/g;
  const labels = new Set<string>();
  let match;
  while ((match = labelPattern.exec(raw)) !== null) {
    labels.add(match[1]);
  }

  let rank = 1;
  for (const label of labels) {
    rankings.push({
      label: `Response ${label}`,
      rank: rank++,
      strengths: "Could not parse — see raw response",
      weaknesses: "Could not parse — see raw response",
      commentary: "Fallback parse: ranking order inferred from mention order",
    });
  }

  if (rankings.length > 0) {
    return { rankings };
  }

  // Last resort: return empty with a warning
  console.warn("Failed to parse peer review response:", raw.slice(0, 200));
  return { rankings: [] };
}
```

---

## Anonymization Helper

Use this to anonymize Stage 1 responses before sending them to Stage 2 reviewers.

```ts
function anonymizeResponses(
  responses: { model: string; response: string }[]
): AnonymizedResponse[] {
  const labels = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  return responses.map((r, i) => ({
    label: `Response ${labels[i] || i + 1}`,
    response: r.response,
  }));
}
```

---

## Customization Notes

These prompts work as general-purpose templates. Adapt them for specific use cases by modifying the Stage 1 system instructions and the Chairman's synthesis criteria.

### Goal Generation
Add to Stage 1 `context`: user's current goals, past performance data, team OKRs. Modify the Chairman prompt to prioritize actionability and measurability.

### Document Analysis
Pass the document text as `context` in Stage 1. Adjust Stage 1 instructions to focus on extraction, summarization, or critique depending on the task.

### Code Review
In Stage 1, instruct models to evaluate code quality, bugs, security, and performance. In Stage 2, weight rankings toward correctness over style. Add specific criteria to the peer review prompt (e.g., "Does the code handle edge cases?").

### Strategy Evaluation
Add decision criteria and constraints to Stage 1 `context`. Modify the Chairman prompt to produce a recommendation with trade-offs, not just a synthesis.

### Example: Customized Stage 1 for Code Review

```ts
function buildCodeReviewPrompt(code: string, language: string): string {
  return buildStage1Prompt(
    `Review the following ${language} code. Identify bugs, security issues, performance problems, and suggest improvements. Provide specific line references where possible.`,
    `\`\`\`${language}\n${code}\n\`\`\``
  );
}
```
