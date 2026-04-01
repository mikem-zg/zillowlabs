# Super-Decision Skill v3.0 → v3.1 Self-Analysis Plan

**Date:** March 25, 2026
**Skill:** `.agents/skills/super-decision/SKILL.md`
**Analysis method:** Full 7-subagent, 3-stage super-decision pipeline applied to itself

---

## 1. Decision

What improvements should be made to the super-decision skill v3.0.0 to close gaps in error handling, data flow specification, and content redundancy — without sacrificing the skill's core agentic philosophy or dual-track output model?

## 2. Framing

- **Problem type:** Prioritization problem — multiple potential improvements, need to rank by value
- **Status quo gaps identified:** No failure/error handling, no complexity scaling, no feedback loops, redundant content (same concepts repeated 3-8x), no data flow spec between stages, no progress visibility
- **Constraints:** Must preserve core agentic philosophy, dual-track model, 7 subagent roles, Replit-aware design
- **Reversibility:** Highly reversible — single markdown file under version control
- **Stakes:** Low — worst case is a git revert; best case is meaningfully more robust decision analysis

## 3. Criteria (Priority-Ordered)

| Priority | Criterion | Why It Matters |
|----------|-----------|----------------|
| 1 | Decision Quality Improvement | The skill's entire reason for existing |
| 2 | Adaptability Across Decision Types | Current workflow is one-size-fits-all despite anti-rigidity philosophy |
| 3 | Subagent Efficiency | 7 subagents across 3 stages = real latency and token cost |
| 4 | Output Clarity and Actionability | Best analysis is worthless if users skim past it |
| 5 | Instruction Clarity for Agent | Ambiguous instructions lead to inconsistent execution |
| 6 | Failure Mode Handling | No guidance exists for when things go wrong |
| 7 | Maintainability | File is already 435 lines; additions must be offset by consolidation |

## 4. Options Evaluated

| # | Option | Effort | Impact | Risk | Verdict |
|---|--------|--------|--------|------|---------|
| 1 | Status Quo | None | None | None | Baseline |
| 2 | Content Consolidation | Low | Medium | Low | **Accepted** |
| 3 | Adaptive Complexity Scaling | Medium | High | High | Rejected (contradicts anti-rigidity philosophy) |
| 4 | Decision Confidence Calibration | Low | Medium | Medium-High | Rejected (LLMs cannot self-calibrate reliably) |
| 5 | Tighter architect() + Prototype-First | Medium | Medium | Medium | Rejected (already stated 8x; diminishing returns) |
| 6 | Meta-Learning & Decision Logging | Medium-High | Medium | High | Rejected (infeasible in stateless markdown skill) |
| — | Error Recovery Guidance (new) | Low | High | Low | **Accepted** (identified by Red Team) |
| — | Stage Data-Passing Spec (new) | Low | Medium | Low | **Accepted** (identified by Red Team) |

## 5. Key Subagent Findings

### Codebase Reality
- Option 2 (consolidation) is the foundation — only option that reduces file length
- File should stay under 500 lines for reliable agent interpretation
- Code blocks (delegation patterns) are the most sensitive area — don't touch without reason
- All lightweight options combined keep the file within 410-460 lines

### Risk Analysis
- Options 2+5 had best risk/reward profiles
- Options 3+6 had worst — most complexity for least certain benefit
- Cross-cutting risk: each structural addition chips away at the philosophy-driven flexibility that is the skill's core strength

### Red Team (Strongest Challenges)
1. **No evidence the skill is underperforming** — it successfully analyzed itself through the full pipeline
2. **"Decision Quality Improvement" is unmeasurable** — any change can claim to serve it without proof
3. **Option 4 killed** — LLMs cannot self-calibrate; confidence scores add false precision
4. **Option 5 killed** — "build don't theorize" already appears 8 times; restating adds zero value
5. **Missing options identified:** Error recovery guidance, stage data-passing spec, decision scope guard, user interaction checkpoints
6. **Strongest single objection:** "We're doing surgery on a healthy patient" — the prudent move would be to collect failure data first, but no telemetry infrastructure exists to do so

## 6. Synthesis: What Changed and Why

### The three changes implemented (v3.1.0):

**1. Content Consolidation (~15% reduction)**
- Removed redundant "How subagents should work together" section (was a prose restatement of the Delegation Patterns section)
- Consolidated "build don't theorize" from 8 mentions to 2 (one in Environment Context, one in Behavioral Rules)
- Removed duplicate from Core Rules and What Not To Do sections
- Net reduction: ~25 lines removed

**2. Error Recovery and Graceful Degradation Section (new, 9 lines)**
- Covers: low-quality subagent output, contradictory Stage 1 outputs, vague decisions, irrelevant codebase, constrained capacity, subagent timeouts
- Key principle: Red Team is never skippable; other subagents can merge for simpler decisions
- Addresses the single most clearly missing capability in v3.0

**3. Stage Data-Passing Specification (new, 7 lines)**
- Explicitly states what each stage produces and what the next stage receives
- Closes the ambiguity where v3.0 said "informed by Stage 1 outputs" without specifying what those outputs are
- Key principle: pass full structured output, don't summarize — let downstream subagents decide what matters

### What was NOT changed (and why):
- **Core philosophy** — untouched; the adaptive, anti-rigid stance is the skill's primary strength
- **7 subagent roles** — all retained; the responsibilities are well-defined
- **Dual-track output model** — untouched; working as designed
- **Code examples** — untouched; high-value for agent instruction-following
- **Complexity scaling** — not added; formal triage contradicts the anti-rigidity philosophy. The error recovery section provides soft scaling guidance instead (which subagents can merge/skip)

## 7. Recommendations

### Best-in-class path (IMPLEMENTED)
- **What:** Surgical v3.1 — content consolidation + error recovery section + stage data-passing spec
- **Why optimal:** Addresses the three structurally obvious gaps without touching what works. Consolidation creates room for new sections, keeping file near original length (440 lines, under 500 target).
- **Key upside:** More robust for edge cases without philosophical changes
- **Key downside:** Still optimizing without failure data
- **When to choose:** When you believe structural gaps are real and you want careful, reversible improvement

### Quick/pragmatic path
- **What:** Status quo + error recovery section only (no consolidation, no data-flow spec)
- **Why it ships fast:** Purely additive — zero regression risk, 10 minutes of work
- **Key upside:** Fills the single most critical gap with zero chance of breaking existing behavior
- **Key downside:** Leaves redundancy and data-flow ambiguity in place
- **When to choose:** When you prefer maximum caution and plan to revisit later

### Preferred: Best-in-class path
The quick path is reasonable but leaves known clutter and known gaps in place out of an abundance of caution that isn't warranted for a reversible markdown edit.

## 8. What Would Change This Recommendation
- If testing reveals the 8x repetition of "build don't theorize" actually improved agent compliance, revert the consolidation
- If the skill starts being used for very simple decisions, revisit lightweight complexity scaling
- If a telemetry mechanism emerges, revisit decision logging
- If the user decides the current length is fine, drop to quick/pragmatic path

## 9. Final File Metrics

| Metric | v3.0.0 | v3.1.0 | Change |
|--------|--------|--------|--------|
| Total lines | 436 | 440 | +4 |
| Redundant concept repetitions | 8x "build don't theorize", 3x workflow | 2x "build don't theorize", 1x workflow | Significant reduction |
| Error recovery guidance | None | 6 failure modes covered | New capability |
| Data flow specification | None | Full stage-to-stage spec | New capability |
| Core philosophy sections | Unchanged | Unchanged | No regression |
| Subagent roles | 7 | 7 | No change |
