# MCP Server Evaluation Guide

## Overview

The quality of an MCP server is measured by how well its tools enable LLMs to answer realistic questions — NOT by how many API endpoints are covered or how comprehensively tools are implemented.

An evaluation consists of **10 human-readable questions** that an LLM must answer using only the MCP server's tools. Each question:

- Requires **READ-ONLY** operations (no mutations)
- Is **INDEPENDENT** (no question depends on another)
- Uses only **NON-DESTRUCTIVE, IDEMPOTENT** tool calls
- Has a **single, verifiable answer** that is stable over time

If an LLM with access to your MCP server can consistently answer all 10 questions correctly, your server exposes the right data in the right way.

---

## Question Guidelines

### Core Requirements

Every question in your evaluation MUST satisfy ALL of the following:

| Requirement | Why |
|---|---|
| **Independent** | Each question stands alone. No question's answer depends on having answered another question first. |
| **Non-destructive** | Only read operations. Never create, update, or delete anything. |
| **Idempotent** | Running the same tool calls again produces the same result. |
| **Realistic** | Reflects something a real human would actually want to know. |
| **Clear** | Unambiguous phrasing. A knowledgeable human would agree on the answer. |
| **Concise** | One sentence when possible. No unnecessary context or backstory. |
| **Complex** | Requires multiple tool calls (often 5–30+). Cannot be answered with a single lookup. |

### Complexity and Depth

Questions should demand genuine reasoning and multi-step exploration:

**Multi-hop questions** — The answer to one tool call determines the input to the next. The LLM must chain results across 3+ steps.

**Extensive pagination** — Some questions should require paging through many results (e.g., scanning all items in a large collection to find a specific one).

**Historical data** — Questions may reference data from 1–2 years ago, requiring the LLM to navigate to older content rather than defaulting to recent items.

**Deep understanding** — Questions should test whether the LLM truly understands the data model, not just surface-level keyword matching.

**True/False with evidence** — Ask the LLM to verify a claim by gathering evidence. Example: "True or False: The project labeled 'infrastructure' had more than 50 completed tasks before March 2024. Respond True or False."

**Multiple-choice with search** — Present 3–4 options where the LLM must investigate each hypothesis before selecting the correct one. Example: "Which team shipped the most features in Q2 2024: Alpha, Beta, or Gamma? Respond with the team name."

---

## Avoiding Keyword Search

Questions must NOT contain specific keywords that appear verbatim in the target content. If the answer is found in a document titled "Q3 Revenue Analysis," the question should NOT include the phrase "Q3 Revenue Analysis."

**Instead:**

- Use **synonyms** and **related concepts** — "third-quarter financial performance" instead of "Q3 Revenue Analysis"
- Use **paraphrases** — describe what the content is about without naming it
- Require **multiple searches** — the LLM should search for related items, analyze connections, and derive the answer
- Force **context extraction** — the LLM must read surrounding content to understand what it found

**Why this matters:** If the question contains the exact keywords, the LLM can trivially find the answer with a single search call. This tests the search tool, not the overall MCP server quality.

**Bad:** "What is the status of the 'Q3 Revenue Analysis' document?"
**Good:** "What is the status of the document that analyzed the company's financial performance during the summer months of 2023?"

---

## Stress-Testing Tool Return Values

Design questions that exercise the full range of data your tools return:

**Large JSON objects** — Some questions should require tools that return complex, nested responses. The LLM must parse and extract the relevant field from a large payload.

**Multiple data modalities** — Across your 10 questions, require the LLM to work with diverse data types:

| Data Type | Example |
|---|---|
| IDs | User IDs, resource GIDs, message IDs |
| Names | Usernames, channel names, project names |
| Timestamps | Created dates, modified dates, due dates |
| File types | Document formats, MIME types, extensions |
| URLs | Web links, API endpoints, file URLs |
| Counts | Numerical aggregations derived from data |
| Booleans | True/False determinations from evidence |

**Probe all useful data forms** — If a tool returns both a `display_name` and an `id`, create questions that require each. If a tool returns timestamps in ISO format, ask questions that require date comparison.

---

## Question Diversity

Your 10 questions should collectively:

- **Reflect real human use cases** — "Who created this?" "When was this last updated?" "Which project has the most X?"
- **Require varying tool call counts** — Some questions need 3–5 calls, others need 15–30+
- **Include ambiguous framing** — The question is slightly vague but has exactly one verifiable answer. The LLM must figure out which tools to use and how to interpret results.
- **Force difficult tool selection** — When multiple tools could potentially answer a question, the LLM must choose the most effective approach.
- **Cover different tool categories** — Don't test only search tools. Include questions that exercise list, get, filter, and aggregation tools.

---

## Stability Requirements

Every answer must remain the same regardless of when the evaluation is run.

### DO base questions on:

- **Completed/closed items** — Archived projects, merged pull requests, resolved tickets
- **Historical data with fixed timestamps** — "Who posted the first message in #general before 2024?"
- **Immutable properties** — Creator, creation date, original title (if not editable)
- **Fixed time windows** — "Between January and March 2024, which..."

### DO NOT base questions on:

- **Reaction counts** — These change as users add/remove reactions
- **Reply counts** — New replies can be added at any time
- **Member counts** — Users join and leave
- **"Latest" or "most recent"** — New content is created constantly
- **Unqualified superlatives** — "most popular" changes over time unless bounded by a fixed time window
- **Open/active items** — Their state can change

**Rule of thumb:** If running the evaluation 6 months from now could produce a different answer, the question is unstable. Rewrite it with a fixed time window or target immutable data.

---

## Answer Guidelines

### Verifiability

Every answer must be verifiable via **direct string comparison**. The evaluation runner compares the LLM's response to the expected answer character-by-character (case-insensitive, trimmed).

**Specify the output format in the question itself:**

- "Respond with the username."
- "Use the format YYYY/MM/DD."
- "Respond True or False."
- "Respond with the channel name, without the # prefix."
- "Provide the count as a whole number."

### Answer Types

Use a diverse mix across your 10 questions:

| Type | Example | Format Note |
|---|---|---|
| Username | `jsmith` | Specify "username" vs "display name" |
| User ID | `U04A1B2C3D` | Only when the question specifically asks for an ID |
| Channel/project name | `engineering-updates` | Specify with or without prefix |
| Timestamp | `2024/03/15` | Always specify the date format |
| Number | `42` | Specify "whole number" or precision |
| Boolean | `True` | Specify "True or False" |
| URL | `https://example.com/doc/123` | Specify "full URL" |
| Email | `jane@example.com` | Rare, but useful for diversity |
| Single name/title | `Project Phoenix` | Use exact casing from the source |

### Answer Quality Checklist

| Property | Requirement |
|---|---|
| **Human-readable** | Prefer names over opaque IDs. Ask for `jsmith` not `U04A1B2C3D` unless testing ID extraction specifically. |
| **Stable/stationary** | Based on old, completed, or immutable content. Will not change tomorrow. |
| **Clear and unambiguous** | Only one correct answer exists. No reasonable person would disagree. |
| **Diverse modalities** | Across 10 questions, use at least 5 different answer types. |
| **Not a complex structure** | Never a list, array, object, or multi-part answer. Always a single scalar value. |

---

## Evaluation Process

Follow these 5 steps in order. Do NOT skip steps or jump ahead.

### Step 1: Documentation Inspection

Read the target API's documentation thoroughly:

- Official API reference (endpoints, parameters, response schemas)
- Authentication and authorization model
- Rate limits, pagination patterns, and query capabilities
- Data model: entities, relationships, and available fields

Fetch additional documentation from the web if the API docs are ambiguous or incomplete. Parallelize documentation reads — open multiple doc pages simultaneously.

**Goal:** Understand what data exists and how it is organized, without touching the MCP server yet.

### Step 2: Tool Inspection

List all available tools on the MCP server and study each one:

- Tool name and description
- Input schema (required/optional parameters, types, constraints)
- Output schema (response structure, fields, types)
- Annotations (readOnlyHint, destructiveHint, etc.)

**Do NOT call any tools yet.** Only read their schemas and descriptions.

**Goal:** Understand what the MCP server exposes and how its tools map to the underlying API.

### Step 3: Developing Understanding

Iterate between Steps 1 and 2 to build a mental model:

- How do the tools map to API concepts?
- What types of questions could these tools answer?
- Which tools would need to be chained together for complex queries?
- What data is accessible vs. what gaps exist?
- What content is old enough to be stable?

**Think about question categories:** search-based, aggregation-based, comparison-based, historical, evidence-gathering.

**NEVER read the MCP server's implementation code.** You are evaluating the server as a black box, the same way an LLM would use it. Reading source code would bias your questions toward implementation details rather than realistic use cases.

### Step 4: Read-Only Content Inspection

Now USE the MCP server's tools — but only read-only operations:

- Browse collections, channels, projects, or repositories
- Search for content across different time periods
- Page through results to find specific items
- Read individual items to understand their data structure

**Guidelines for tool usage during inspection:**

| Guideline | Rationale |
|---|---|
| Make small, targeted calls | Avoid overwhelming your context window |
| Use `limit` parameters (set to <10) | Large result sets waste tokens and may truncate |
| Use pagination | Page through results incrementally rather than fetching everything |
| Focus on older content | Recent content may change; target data from 1–2 years ago |
| Note specific IDs, names, and dates | You will need these to construct questions with verifiable answers |

**Goal:** Identify specific, concrete content that you can build questions around. Write down exact values (names, dates, IDs) that will become your expected answers.

### Step 5: Task Generation

Create 10 questions following all guidelines above. For each question:

1. Write the question with explicit output format instructions
2. Determine the expected answer by actually using the tools yourself
3. Verify the answer is stable (based on immutable/historical data)
4. Confirm the question requires multiple tool calls
5. Check that no keywords from the target content appear in the question
6. Ensure the answer is a single scalar value

**Self-verification is mandatory.** Every answer must be confirmed by walking through the tool calls yourself. Never guess an answer.

---

## Output Format

Present the final evaluation as XML:

```xml
<evaluation>
   <qa_pair>
      <question>Question text here, including output format instructions.</question>
      <answer>Single verifiable answer</answer>
   </qa_pair>

   <qa_pair>
      <question>Second question text here.</question>
      <answer>Answer</answer>
   </qa_pair>

   <!-- ... 10 qa_pairs total -->
</evaluation>
```

**Rules:**
- Exactly 10 `<qa_pair>` elements
- Each `<question>` is a single, complete question with format instructions
- Each `<answer>` is a single scalar value (string, number, boolean, date)
- No additional markup, explanations, or metadata inside the XML

---

## Good Question Examples

### Example 1: Multi-hop requiring deep exploration

**Question:** "In the Slack workspace, find the channel that was created by the same person who posted the first message in #engineering-announcements. What is that channel's name? Respond without the # prefix."

**Answer:** `project-atlas`

**Why this is good:**
- Requires finding the first message in one channel (pagination to oldest)
- Extracting the author of that message
- Searching all channels to find ones created by that user
- The answer is a stable channel name (channel creation is immutable)
- No keywords from the answer appear in the question

### Example 2: Context understanding without keyword matching

**Question:** "A Google Drive document shared in Q1 2024 discussed strategies for reducing customer churn. What is the email address of the document's owner? Respond with the full email address."

**Answer:** `maria.chen@example.com`

**Why this is good:**
- The document's actual title might be "Retention Playbook 2024" — the question uses "reducing customer churn" instead
- Requires searching for documents in a time range, reading their content or metadata to identify the right one
- The answer (owner email) is immutable
- Forces the LLM to understand document content, not just match titles

### Example 3: Complex aggregation requiring multiple steps

**Question:** "Across all completed GitHub milestones in the 'platform-core' repository that closed between April and September 2024, which milestone had the highest ratio of issues closed by a single contributor? Respond with the milestone title."

**Answer:** `v2.8-hotfixes`

**Why this is good:**
- Requires listing milestones, filtering by date range and status
- For each milestone, fetching all closed issues
- Counting contributor frequency per milestone
- Computing a ratio and comparing across milestones
- Potentially requires 20+ tool calls
- Answer is stable (closed milestones don't change)

### Example 4: Synthesis across multiple data types

**Question:** "True or False: The Asana project that contains a task assigned to the user who joined the team most recently (before 2024) has more than 30 completed tasks. Respond True or False."

**Answer:** `False`

**Why this is good:**
- Multi-hop: find newest team member (before 2024) → find their tasks → identify the project → count completed tasks
- Requires working with users, tasks, and projects across different tools
- The time boundary ("before 2024") makes the answer stable
- True/False format is unambiguous and easy to verify
- Tests evidence-gathering: the LLM must collect data to support its conclusion

### Example 5: Historical data with pagination

**Question:** "In the Jira project 'BACKEND', what was the title of the first issue ever created? Use the exact issue title as it appears in Jira."

**Answer:** `Set up CI/CD pipeline for staging environment`

**Why this is good:**
- Requires sorting or paginating to the very first issue (potentially hundreds of pages)
- The first issue ever created is immutable — its title won't change
- Tests the LLM's ability to handle pagination and ordering
- The answer is a specific string that can be verified exactly

---

## Poor Question Examples

### Example 1: Answer changes over time

**Question:** "How many members are in the #general Slack channel?"

**Answer:** `347`

**Why this is bad:**
- Member count changes as people join and leave
- The answer today will differ from the answer next month
- **Fix:** Target a fixed metric — "How many members were in #general when it was created?" (always 1, the creator) or reference a closed/archived channel

### Example 2: Too easy with keyword search

**Question:** "Find the document titled 'Q4 Budget Forecast' and tell me who created it."

**Answer:** `david.kim`

**Why this is bad:**
- The exact document title is in the question — one search call finds it immediately
- No multi-hop reasoning required
- **Fix:** Describe the document by its content or context without naming it — "Find the financial planning document for the final quarter of 2023 that was shared in the #finance channel"

### Example 3: Ambiguous answer format

**Question:** "What labels are applied to issue #142 in the 'web-app' repository?"

**Answer:** `bug, priority-high, frontend`

**Why this is bad:**
- The answer is a list, not a single scalar value
- Order matters — is it `bug, priority-high, frontend` or `frontend, bug, priority-high`?
- The number of labels can change if someone adds/removes one
- **Fix:** Ask about a single specific property — "What is the priority label on issue #142?" or "True or False: Issue #142 has the 'bug' label. Respond True or False."

### Example 4: Too simple / single tool call

**Question:** "What is the name of Slack channel C04A1B2C3D?"

**Answer:** `random`

**Why this is bad:**
- Answerable with a single `get_channel` call
- Tests only one tool with no reasoning
- No complexity or multi-hop behavior
- **Fix:** Require the LLM to discover the channel ID through other means — "What is the name of the channel where the CEO posted a company update on 2024/01/15?"

---

## Running Evaluations

### Verify Tools with MCP Inspector

Before running the evaluation, use [MCP Inspector](https://github.com/modelcontextprotocol/inspector) to verify that all tools work correctly:

```bash
npx @modelcontextprotocol/inspector
```

- Confirm all tools are listed with correct schemas
- Test each tool with sample inputs
- Verify that read-only tools do not modify any data
- Check that pagination parameters work as expected

### Manual Answer Verification

Run each of your 10 questions manually before including them in the evaluation:

1. Start with the question text
2. Use the MCP server's tools step by step, as an LLM would
3. Record every tool call and its result
4. Confirm the final answer matches your expected answer
5. Run the same sequence again to verify idempotency

### Document Expected Tool Call Sequences

For each question, document the approximate tool call sequence:

```
Question 3: "Across all completed GitHub milestones..."
Expected sequence:
  1. list_milestones(repo="platform-core", state="closed") → 12 milestones
  2. Filter to April–September 2024 → 5 milestones
  3. For each milestone:
     a. list_issues(milestone=X, state="closed") → N issues per milestone
     b. Extract assignee/closer for each issue
  4. Compute contributor ratios
  5. Return milestone with highest single-contributor ratio
Estimated tool calls: ~22
Expected answer: "v2.8-hotfixes"
```

This documentation helps diagnose failures: if the LLM gets the wrong answer, you can identify where in the sequence it diverged.

### Track Results Over Time

Maintain a simple scorecard:

| Date | Model | Score | Notes |
|---|---|---|---|
| 2024/08/15 | Claude 3.5 Sonnet | 8/10 | Missed Q3 (pagination), Q7 (date parsing) |
| 2024/09/01 | Claude 3.5 Sonnet | 9/10 | Fixed pagination; Q7 still fails |
| 2024/09/01 | GPT-4o | 7/10 | Missed Q3, Q5, Q9 |

Track improvements after MCP server changes — better tool descriptions, pagination fixes, or response format changes should correlate with higher scores.
