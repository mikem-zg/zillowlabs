# Security Audit Checklist

Systematic checklist organized by vulnerability category. For each item, search the codebase for the relevant patterns and verify the control is in place.

## 1. Authentication

- [ ] **Password storage**: Passwords hashed with bcrypt/scrypt/argon2 (not MD5/SHA1/SHA256)
- [ ] **Session management**: Sessions use secure, httpOnly, sameSite cookies; tokens have expiration
- [ ] **Session fixation**: Session ID regenerated after login
- [ ] **Brute force protection**: Rate limiting on login/auth endpoints
- [ ] **Token validation**: JWTs verified with proper algorithm (not `alg: none`); signature checked server-side
- [ ] **Logout**: Sessions/tokens properly invalidated on logout (not just client-side deletion)
- [ ] **Multi-factor auth**: Available for sensitive operations if applicable
- [ ] **Password reset**: Tokens are single-use, time-limited, and sufficiently random
- [ ] **OAuth/SSO**: State parameter used to prevent CSRF; redirect URI validated strictly

Search patterns:
```
grep -rn "bcrypt\|argon2\|scrypt\|pbkdf2" server/
grep -rn "password\|passwd" server/ --include="*.ts"
grep -rn "httpOnly\|secure\|sameSite" server/
grep -rn "jwt\.verify\|jwt\.sign\|jsonwebtoken" server/
```

## 2. Authorization & Access Control

- [ ] **Endpoint protection**: Every route has auth middleware; no accidental public endpoints
- [ ] **Vertical privilege escalation**: Admin endpoints check admin role, not just authentication
- [ ] **Horizontal privilege escalation**: User A cannot access User B's resources (IDOR)
- [ ] **Resource ownership**: Data queries filter by authenticated user ID
- [ ] **API key scoping**: API keys have minimal required permissions
- [ ] **Default deny**: New routes require explicit auth; whitelist approach preferred

Search patterns:
```
grep -rn "isAdmin\|role\|permission" server/
grep -rn "req\.user\|req\.auth\|req\.session" server/
# Look for routes without auth middleware
```

## 3. Injection Vulnerabilities

- [ ] **SQL injection**: All queries use parameterized statements or ORM; no string concatenation in SQL
- [ ] **NoSQL injection**: MongoDB queries use typed operators, not raw user input in query objects
- [ ] **Command injection**: No `exec()`, `spawn()`, `system()` with user input
- [ ] **LDAP injection**: LDAP queries use proper escaping
- [ ] **Template injection**: Server-side templates don't render raw user input
- [ ] **Path traversal**: File paths validated; `../` sequences blocked
- [ ] **SSRF**: User-supplied URLs validated against allowlist; no arbitrary HTTP requests

Search patterns:
```
grep -rn "exec\|spawn\|execSync\|execFile" server/
grep -rn "\.raw\|\.query(" server/ --include="*.ts"
grep -rn "readFile\|writeFile\|createReadStream\|path\.join" server/
grep -rn "fetch\|axios\|http\.get\|request(" server/ --include="*.ts"
```

## 4. Cross-Site Scripting (XSS)

- [ ] **Reflected XSS**: User input in query params/headers not reflected in HTML without encoding
- [ ] **Stored XSS**: User-generated content sanitized before storage and encoded on output
- [ ] **DOM XSS**: Frontend doesn't use `innerHTML`, `dangerouslySetInnerHTML`, `eval()` with user data
- [ ] **Content-Type**: API responses set correct `Content-Type` (not `text/html` for JSON APIs)
- [ ] **CSP header**: Content Security Policy restricts inline scripts and untrusted sources

Search patterns:
```
grep -rn "dangerouslySetInnerHTML\|innerHTML\|document\.write" client/
grep -rn "eval\|Function(" client/ --include="*.ts" --include="*.tsx"
grep -rn "Content-Security-Policy\|helmet" server/
```

## 5. Cross-Site Request Forgery (CSRF)

- [ ] **CSRF tokens**: State-changing endpoints validate CSRF tokens
- [ ] **SameSite cookies**: Session cookies use `SameSite=Strict` or `SameSite=Lax`
- [ ] **Origin validation**: Server validates `Origin` or `Referer` headers for mutations
- [ ] **Custom headers**: API uses custom headers (e.g., `X-Requested-With`) that prevent simple CORS requests

## 6. Data Exposure

- [ ] **Sensitive data in responses**: API responses don't include passwords, tokens, internal IDs unnecessarily
- [ ] **Error messages**: Stack traces and internal errors not exposed to users; generic error messages returned
- [ ] **Logging**: Sensitive data (passwords, tokens, PII) not written to logs
- [ ] **Source maps**: Production builds don't expose source maps
- [ ] **API documentation**: Swagger/OpenAPI docs not publicly accessible in production
- [ ] **Debug endpoints**: Debug/test endpoints disabled in production
- [ ] **Database backups**: Backup files not accessible via web server
- [ ] **Git exposure**: `.git` directory not served by web server

Search patterns:
```
grep -rn "console\.log\|console\.error" server/ --include="*.ts" | grep -i "password\|token\|secret\|key"
grep -rn "stack\|stackTrace\|err\.message" server/ --include="*.ts"
grep -rn "source[Mm]ap" vite.config.*
```

## 7. Cryptography

- [ ] **TLS**: All external communications use HTTPS; no HTTP fallback
- [ ] **Hardcoded secrets**: No API keys, passwords, or tokens in source code
- [ ] **Random number generation**: Crypto operations use `crypto.randomBytes()` not `Math.random()`
- [ ] **Encryption at rest**: Sensitive database fields encrypted if required by compliance
- [ ] **Key management**: Encryption keys stored in environment variables or secret managers, not in code

Search patterns:
```
grep -rn "Math\.random" server/ --include="*.ts"
grep -rn "http://" server/ --include="*.ts" | grep -v localhost | grep -v "127\.0\.0\.1"
grep -rn "apikey\|api_key\|secret\|password\|token" . --include="*.ts" --include="*.env" | grep -v node_modules | grep -v ".env.example"
```

## 8. Security Headers & Configuration

- [ ] **HTTPS redirect**: HTTP requests redirected to HTTPS
- [ ] **HSTS**: `Strict-Transport-Security` header set with adequate max-age
- [ ] **X-Content-Type-Options**: Set to `nosniff`
- [ ] **X-Frame-Options**: Set to `DENY` or `SAMEORIGIN`
- [ ] **X-XSS-Protection**: Set to `0` (rely on CSP instead) or `1; mode=block`
- [ ] **Referrer-Policy**: Set to `strict-origin-when-cross-origin` or stricter
- [ ] **Permissions-Policy**: Restricts unnecessary browser features
- [ ] **CORS**: `Access-Control-Allow-Origin` not set to `*` for authenticated endpoints

Search patterns:
```
grep -rn "helmet\|cors\|Access-Control" server/
grep -rn "X-Frame-Options\|X-Content-Type\|Strict-Transport" server/
```

## 9. Dependencies

- [ ] **Known vulnerabilities**: `npm audit` / `pip audit` / `cargo audit` shows no critical/high CVEs
- [ ] **Outdated packages**: Major versions not more than 2 behind latest
- [ ] **Lock file**: `package-lock.json` / `yarn.lock` committed and used in builds
- [ ] **Typosquatting**: Package names verified against official registries
- [ ] **Supply chain**: No `postinstall` scripts from untrusted packages

Run:
```bash
npm audit --json 2>/dev/null || echo "npm audit not available"
```

## 10. Infrastructure & Deployment

- [ ] **Environment variables**: Secrets not in code; `.env` files in `.gitignore`
- [ ] **Debug mode**: `NODE_ENV=production` in production; debug features disabled
- [ ] **File uploads**: Validated by type, size-limited, stored outside web root, filename sanitized
- [ ] **Rate limiting**: Applied to all public endpoints; stricter on auth endpoints
- [ ] **Request size limits**: Body parser limits set (e.g., `express.json({ limit: '1mb' })`)
- [ ] **Timeouts**: Request timeouts configured to prevent slowloris attacks
- [ ] **Health checks**: Health endpoint doesn't expose sensitive system information
- [ ] **Database connection**: Uses connection pooling with limits; credentials not in connection strings in code
