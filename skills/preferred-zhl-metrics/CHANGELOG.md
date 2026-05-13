# Changelog — preferred-zhl-metrics

## 2026-04-10 (v1) | Dereck Steele
- Initial publish — full metric library covering Buyer, Seller, ZHL, Ops Health, Agent Performance, and funnel definitions

## 2026-04-10 (v2) | Dereck Steele
- Rebranded from Audrey Insights to Preferred & ZHL Metric Library; renamed all section headers from Buyer/Seller to Preferred Buyer/Preferred Seller; updated description and purpose to be dashboard-agnostic; clarified KPI card date-filter behavior

## 2026-04-18 (v3) | Mike Messenger
- Corrected active_flag misinformation: clarified that active_flag = TRUE in agent_performance_summary and the agent_performance_report pitfalls section is an analytical cohort filter only — not a routing-eligibility check — and that it silently drops false + NULL rows (~21% NULL).

## 2026-05-13 (v4) | Dereck Steele
- Added prominent "Work in Progress — May Not Be Accurate" disclaimer at the top of the skill, instructing users to verify metrics against canonical sources before using in production decisions
