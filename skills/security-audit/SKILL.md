---
name: security-audit
description: Conducts a comprehensive security audit of a web application codebase. Identifies vulnerabilities across authentication, authorization, injection, data exposure, dependency, and infrastructure categories. Use when the user asks for a security audit, security review, vulnerability assessment, or penetration test of their application.
---

# Security Audit

Perform a systematic, comprehensive security audit of a web application. The output is a structured report with real-world impact analysis for every finding, modeled on professional penetration test reports. DONT BE LAZY I WILL GET FIRED IF THERE IS A VULNERABILITY GO OVER EVERY FILE MULTIPLE TIMES IF NEEDED.

## Process

### Phase 1: Reconnaissance (Information Gathering)

Understand the application before auditing. Run these in parallel:

1. **Identify the stack**: Read `package.json`, `requirements.txt`, `Cargo.toml`, `go.mod`, or equivalent to catalog all dependencies and their versions.
2. **Map the attack surface**: Find all route/endpoint definitions, middleware chains, and public-facing entry points.
3. **Locate auth boundaries**: Find authentication middleware, session management, and authorization checks.
4. **Identify data stores**: Find database connections, ORMs, caches, file storage, and external API calls.
5. **Find secrets handling**: Search for environment variable usage, API keys, tokens, and credential patterns.

```bash
# Useful reconnaissance commands (adapt to stack)
grep -r "app\.\(get\|post\|put\|delete\|patch\|use\)" server/ --include="*.ts" --include="*.js" -n
grep -rn "process\.env\." server/ --include="*.ts" --include="*.js"
grep -rn "cookie\|session\|jwt\|token\|auth" server/ --include="*.ts" --include="*.js" -l
grep -rn "exec\|eval\|spawn\|raw\|unsafe\|dangerouslySetInnerHTML" . --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" -l
```

### Phase 2: Systematic Audit

Audit each category from the checklist in `reference/checklist.md`. For each category:

1. Read all relevant files identified in Phase 1
2. Trace data flow from user input to output/storage
3. Check against the vulnerability patterns in the checklist
4. Document every finding immediately — do not batch

### Phase 3: Dependency Audit

1. Check for known vulnerabilities: `npm audit` / `pip audit` / equivalent
2. Review dependency versions against known CVE databases
3. Flag outdated dependencies with known security issues
4. Check for typosquatting or suspicious packages

### Phase 4: Report Generation

Write `SECURITY_AUDIT.md` using the output format below.

## Output Format

```markdown
# Security Audit Report — [Application Name]

**Date:** [date]
**Scope:** [what was audited]
**Methodology:** Manual code review + automated dependency scanning

---

## Executive Summary

[2-3 sentences on overall security posture. State the total finding count and severity distribution.]

| Severity | Count | Description |
|----------|-------|-------------|
| CRITICAL | N | Exploitable vulnerabilities causing data breach or full compromise |
| HIGH | N | Significant vulnerabilities requiring immediate attention |
| MEDIUM | N | Moderate risk; exploitable under specific conditions |
| LOW | N | Minor issues; defense-in-depth improvements |
| INFO | N | Positive security patterns worth maintaining |

---

## Findings

### [SEVERITY]-[N]: [Short Title]

**File:** `path/to/file.ts` lines X-Y
**Category:** [Auth | Injection | XSS | CSRF | Data Exposure | Access Control | Cryptography | Configuration | Dependencies | Infrastructure]
**CVSS Estimate:** [0.0-10.0] ([vector string if applicable])

**Description:**
[What the vulnerability is. Include the specific code pattern.]

**Proof of Concept:**
[How an attacker would exploit this. Include curl commands, payloads, or attack steps.]

**Real-World Impact:**
- [Concrete consequence 1]
- [Concrete consequence 2]
- [Data at risk, user impact, compliance implications]

**Remediation:**
1. [Specific fix with code example]
2. [Additional hardening]

---

## Positive Security Patterns

[List good security practices found in the codebase that should be maintained.]

## Remediation Priority Matrix

| Priority | Finding | Fix | Effort |
|----------|---------|-----|--------|
| 1 | [ID] | [action] | [time] |

```

## Severity Classification

Use these definitions consistently:

- **CRITICAL**: Remotely exploitable without authentication, or leads to full data breach / system compromise. Examples: SQL injection in login, unauthenticated admin access, exposed secrets in source code.
- **HIGH**: Exploitable with low-privilege access, or exposes significant sensitive data. Examples: broken access control allowing cross-user data access, stored XSS, insecure deserialization.
- **MEDIUM**: Exploitable under specific conditions or with user interaction. Examples: CSRF on state-changing actions, reflected XSS, missing rate limiting on sensitive endpoints.
- **LOW**: Defense-in-depth issues unlikely to be exploited alone. Examples: verbose error messages, missing security headers, overly permissive CORS.
- **INFO**: Not a vulnerability, but a positive pattern or informational note.

## Key Principles

- **Every finding needs a real-world impact section**: Do not report theoretical issues without concrete exploitation scenarios
- **Trace full data flows**: Follow user input from HTTP request → validation → processing → storage → output
- **Check the negative path**: What happens when auth fails? When validation is missing? When errors occur?
- **Test authorization, not just authentication**: Can user A access user B's data? Can non-admins reach admin endpoints?
- **Read the actual code**: Do not rely on framework defaults — verify that security middleware is actually applied to all routes
- **Check for secrets in source**: Search for hardcoded API keys, passwords, tokens in code and config files
- **Review error handling**: Ensure stack traces and internal details are not leaked to users