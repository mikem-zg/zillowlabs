# Agent Personas — Detailed Profiles

Canonical personas from Zillow's internal agent research. Use for persona-specific product decisions, workflow design, and feature prioritization.

## Contents
- Indie (Independent Solo Agent)
- Alan (Team Agent)
- Audrey (Team Lead / Owner)
- Alexis (Assistant / TC / Coordinator)
- Cross-Persona Comparison

## Indie — Independent Solo Agent

### Profile
| Attribute | Value |
|-----------|-------|
| Structure | Solo agent |
| Tenure | Typically 5+ years |
| Production | ~12 transactions/year (median) |
| Volume | ~$3.4M (median) |
| Income | ~$56k median |
| Market share | ~82% of industry agents; only 25% of MBP PAs; 0% of Flex PAs |

### Top Business Priorities
1. Increase number of transactions closed
2. Improve lead quality
3. Increase lead volume
4. Nurture existing client relationships

### Motivations & Attitudes
- Values autonomy and control; often declines invitations to join teams
- Balances "wearing every hat" (marketing, ops, client service) with limited time and budget for tools
- Usually lighter tech spend; adoption hinges on clear ROI, low friction, and trust in how Zillow uses their data

### Why Indie Matters to Zillow
- Largest segment by count; huge TAM for tools and membership
- Over 97% of general agents do not partner with Zillow today
- Adoption will hinge on clear ROI, low friction, and trust

### Design Implications
- Keep onboarding fast and value-visible within minutes
- Don't assume team infrastructure (shared CRM, admin support)
- Respect autonomy — position tools as amplifiers, not replacements
- Price sensitivity is real; free or low-cost tiers drive adoption

---

## Alan — Team Agent (Member of a Team)

### Profile
| Attribute | Value |
|-----------|-------|
| Structure | Agent on a team (not the lead) |
| Team size | Avg ~3 in industry; ~22 in Flex teams |
| Tenure | Often 5+ years, though many newer agents start on teams |
| Production | ~6 transactions/year (median) |
| Volume | ~$1.7M (median) |
| Income | ~$46k median for sales agents; ~$9.6k for <2 years experience |
| Market share | ~17% of industry agents; ~61% of MBP PAs; ~97% of Flex PAs |

### Top Business Priorities
- Increase closed transactions
- Improve lead quality
- Increase lead volume

### Context & Role
- Primary day-to-day user of team tools (Follow Up Boss, Zillow Workspace, ShowingTime+, transaction systems)
- Front-line delivery of Zillow's consumer experience in Premier Agent/Flex programs
- Behavior and performance highly shaped by team's systems, coaching, and expectations

### Why Alan Matters to Zillow
- For Flex and membership strategies, Alan is the person actually using the tools, following up leads, and creating Zillow-trackable outcomes
- Tool adoption depends on Alan's daily experience, not just Audrey's purchase decision

### Design Implications
- Design for the tools Audrey mandates (FUB, Workspace) — Alan must use them
- Prioritize speed and simplicity in lead follow-up workflows
- Mobile-first for field work (showings, touring)
- Coach-ability features matter (scripts, checklists, performance feedback)

---

## Audrey — Team Lead / Team Owner

### Profile
| Attribute | Value |
|-----------|-------|
| Structure | Team lead or small brokerage owner |
| Team size | Avg ~3 in industry; ~22 in Flex; may manage pods and sub-teams |
| Tenure | Typically 5+ years |
| Production | ~14 transactions/year (median) |
| Volume | ~$3.9M (median) |
| Income | ~$75k+ median for high-tenure agents (6+ years) |
| Market share | ~5% of industry agents; ~13% of MBP PAs; ~3% of Flex PAs |

### Top Business Priorities
1. Increase team transaction volume and GCI
2. Improve lead quality
3. Grow team headcount
4. Build brokerage/team brand

### What Keeps Audrey Up at Night
- Constantly context-switching between recruiting, coaching, performance management, and admin
- Difficulty scaling team output without exponentially increasing back-office overhead
- Ensuring consistent client experience across agents with widely varying skill and discipline

### Why Audrey Matters to Zillow
- Gatekeeper for tool adoption: decides whether the team buys, configures, and enforces products
- Responsible for coaching agents into behaviors Zillow wants to scale (consistent follow-up, high CSAT, proper tool use)
- Multiplier effect: one Audrey adoption = many Alan adoptions

### Design Implications
- Dashboard and reporting features are critical (team performance, lead distribution, conversion)
- Admin/config capabilities matter more than individual-agent UX
- Onboarding must include team setup, not just individual setup
- ROI proof at team level (not just per-agent) drives purchase decisions

---

## Alexis — Assistant / TC / Coordinator

### Profile
| Attribute | Value |
|-----------|-------|
| Roles & titles | Transaction coordinator, listing coordinator, team assistant, office admin |
| Licensing | Sometimes licensed, sometimes not; may be shared across agents/teams |
| Workload | Can support 100+ transactions per year, juggling dozens of active files |
| Market presence | ~17% of agents report having a personal assistant |

### Top Priorities
- Keep multiple transactions on track (dates, docs, contingencies, signatures)
- Maintain clear communication with agents, clients, lenders, title/escrow, and co-op agents
- Create and refine repeatable workflows and checklists for recurring tasks
- Minimize errors and last-minute chaos that threaten closings

### Why Alexis Matters to Zillow
- Operational "glue" for listing and transaction workflows
- Adoption of transaction tools, listing operations, and automation features often depends on whether Alexis can trust and integrate them
- Often the real owner of spreadsheets, JotForms/Cognito forms, and other duct-tape systems Zillow aims to replace

### Design Implications
- Bulk operations and batch processing are essential (not one-at-a-time)
- Checklist and timeline views matter more than dashboards
- Integration with existing tools (MLS, email, forms) is critical — Alexis won't abandon what works
- Error prevention and compliance guardrails are high-value features

---

## Cross-Persona Comparison

| Dimension | Indie | Alan | Audrey | Alexis |
|-----------|-------|------|--------|--------|
| Decision authority | Full | Low (follows team) | Full (for team) | Operational only |
| Tool budget | Low/personal | Team-provided | Team budget holder | Uses team tools |
| Primary value | Autonomy | Structure/leads | Scale/leverage | Reliability/throughput |
| Zillow relationship | Skeptical/unaware | Embedded (PA/Flex) | Gatekeeper | Indirect |
| Key metric | Deals closed | Deals closed | Team GCI | Txns supported |
| Mobile vs desktop | Mixed | Mobile-heavy | Desktop-heavy | Desktop-heavy |
| AI appetite | Cautious (control) | Open (productivity) | Strategic (scale) | High (automation) |
