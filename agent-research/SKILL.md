---
name: agent-research
description: Zillow real estate agent research covering personas, jobs-to-be-done, pain points, tooling ecosystems, and strategic context. Use when designing products for real estate professionals, building agent-facing features, answering questions about agent workflows, or making persona-informed product decisions.
---

# Agent Research

Zillow's internal research on real estate professionals — agents, team leads, assistants, and brokers. Provides persona profiles, jobs-to-be-done, pain points, tooling context, and strategic direction for building agent-facing products.

## When to Use

- Designing features for Zillow's professional audience
- Answering "What do agents need/want/struggle with?"
- Making persona-informed product decisions (Indie vs Alan vs Audrey vs Alexis)
- Understanding agent workflows, tooling, and day-to-day realities
- Framing product positioning (industry agent vs Premier Agent)

## Persona Quick Reference

Four canonical personas anchor all agent research:

| Persona | Role | Production | Key Priority |
|---------|------|-----------|--------------|
| **Indie** | Independent solo agent | ~12 deals/yr, $56k median | Autonomy, clear ROI on tools |
| **Alan** | Team agent (not lead) | ~6 deals/yr, $46k median | Follow-up, use team systems |
| **Audrey** | Team lead / owner | ~14 deals/yr, $75k+ median | Scale team output, recruit |
| **Alexis** | TC / assistant / coordinator | 100+ txns/yr supported | Keep transactions on track |

### Key Splits

| Dimension | Values | Why It Matters |
|-----------|--------|----------------|
| **Affiliation** | Industry vs Premier Agent (MBP/Flex) | Tool access, data richness, Zillow relationship |
| **Structure** | Independent (82% industry) vs Team-based (most PA) | Workflow complexity, decision-making authority |

Over 97% of general agents do not partner with Zillow today — large growth headroom.

## Routing Dimensions

Use these when answering persona-specific questions:

- `persona`: `indie`, `alan`, `audrey`, `alexis`
- `affiliation`: `industry`, `premier_agent` (optionally `mbp`, `flex`)
- `role_phase`: `prospect`, `earn_business`, `list_home`, `find_home`, `select_offer`, `secure_home`, `transact`, `post_transact`, `manage_business`
- `pain_point`: `lead_quality`, `lead_volume`, `tool_fragmentation`, `double_entry`, `transaction_complexity`, `pricing_cma`, `differentiation`, `commission_pressure`, `trust_zillow`, `work_life`
- `tool_category`: `mls`, `crm`, `showing`, `transaction_mgmt`, `marketing`, `productivity`

## Question Types This Skill Handles

- "What are the top pain points for **[persona]**?"
- "How does an **[industry vs PA]** agent typically run their day?"
- "What tools does **[persona]** lean on for **[job]**?"
- "How do agents define success beyond closed deals?"
- "What's different about designing for **Audrey** vs **Indie**?"
- "What do sellers look for when choosing an agent?"
- "How should we position AI features for agents?"
- "What are the JTBDs for a listing agent in the **[phase]** phase?"

## Cross-Persona Pain Points (Top-Level)

1. **Lead quality & conversion** — top stated priority across all personas
2. **Tool sprawl & fragmented workflows** — 8+ logins, manual data re-entry, duct-tape systems
3. **Transaction complexity** — dates, docs, contingencies; TCs as single points of failure
4. **Pricing/CMA effort** — critical for reputation, time-consuming to build
5. **Differentiation** — hard to stand out; lean on relationships and "exclusive" Zillow access
6. **Work-life balance** — always-on expectation; appetite for smart automation
7. **Trust & data-sharing** — industry agents worry about Zillow as competitor vs partner

## AI Positioning (Critical)

Any AI or automation must be framed as:
- **Augmenting** the agent (co-pilot), not replacing them
- **Preserving** agent ownership of client relationships
- **"AI-assisted, agent-verified"** — instant answers for basics, agent judgment for context
- Agents must have **edit/approve controls** and visible attribution

## Live Research via Glean Agents

When the static reference files below do not fully answer a question — or when you need the latest data, market trends, or deeper analysis — query these specialized Glean agents:

| Agent | ID | Specialization | When to Use |
|-------|----|----------------|-------------|
| **askZRI** | `ua5f5ts9puyxnlzj` | Zillow Research & market data | Market trends, housing stats, regional data, economic indicators |
| **Agent Research** | `a0d50757a0c4485b90bce1ec27024ffc` | Agent personas & workflows | Deep-dive persona questions, workflow details, tooling research beyond what the static files cover |

### How to query

```bash
mcp__glean-tools__askAgent --agent_id="ua5f5ts9puyxnlzj" --message="What are the latest trends in agent commission structures?"

mcp__glean-tools__askAgent --agent_id="a0d50757a0c4485b90bce1ec27024ffc" --message="How do team leads (Audrey persona) evaluate CRM tools?"
```

If `askAgent` is not available, fall back to Glean search scoped to the agent's knowledge domain:

```bash
mcp__glean-tools__search --query="Zillow agent commission trends 2025"
mcp__glean-tools__search --query="real estate agent CRM evaluation criteria"
```

### Query workflow

1. **Check static references first** — the files below cover the core research
2. **Query Glean agents** when you need fresher data, quantitative stats, or details not in the reference files
3. **Cite the source** — note whether the answer came from static skill files or a Glean agent query

## Reference Documents

- **Personas**: See [references/personas.md](references/personas.md) — Full profiles for Indie, Alan, Audrey, Alexis with stats, priorities, motivations, and Zillow relevance
- **Jobs-to-be-done**: See [references/jtbd.md](references/jtbd.md) — Complete JTBD framework by role (listing agent, buyer's agent) and phase
- **Pain points & tooling**: See [references/pain-points.md](references/pain-points.md) — Detailed pain points, tooling ecosystem, and "duct-tape" workflow patterns
- **Key insights**: See [references/insights.md](references/insights.md) — Value signals, tour mechanics, messaging channels, listing media, seller digitization
- **Strategic context**: See [references/strategic-context.md](references/strategic-context.md) — Housing Super App vision, unified agent suite, platform future
