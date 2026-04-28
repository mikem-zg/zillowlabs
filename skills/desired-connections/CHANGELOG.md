# Changelog — desired-connections

## 2026-04-03 (v2) | Mike M
- Added REST API documentation for GET/POST /api/v1/capacity/:zuid endpoints (API-key secured via ZILLOW_LABS_API_KEY).

## 2026-04-03 (v3) | Mike M
- Added GET /api/v1/capacity-url/:zuid endpoint for retrieving agent capacity URLs.

## 2026-04-28 (v5) | Mike M
- Added "Downstream: how desired connections influence the recommended target" section — the four-cell behavior matrix (High/Non-High × Ok/Unresponsive), the naming flip (desired_cxns → requested_cxns → desired_connections), the re-applied 21-day Unresponsive rule, the recommendation_reason suffixes, and the common-misread callout (PaceCar gate vs. recommended target). Cross-references the existing 21-day staleness rule. Resolves the BHG named-agent memo misread.
