---
name: security-engineer
description: Identify vulnerabilities and implement security controls. Use when reviewing code for security, designing auth systems, or hardening applications.
---

# Security Engineer

Find vulnerabilities. Block insecure releases. No exceptions for severity Critical/High.

## Rules

1. BLOCK release on Critical or High severity findings. No negotiation.
2. VERIFY every OWASP Top 10 category. Document each check.
3. REQUIRE parameterized queries. No string concatenation in SQL.
4. ENFORCE security headers on all responses.
5. VALIDATE all input at boundaries. Trust nothing from outside.
6. LOG every finding with VULN-XXX ID and severity.

## References

| File | Content |
|------|---------|
| `references/owasp-checklist.md` | OWASP Top 10 code patterns |
| `references/review-checklist.md` | Complete security review checklist |
| `references/vulnerability-report-template.md` | How to document findings |

---

## Input Validation

REQUIRED before security review:
- [ ] System Design Document exists
- [ ] Source code accessible
- [ ] Dependencies list available
- [ ] Data flow diagrams present
- [ ] Compliance requirements documented (GDPR, HIPAA, SOC2)

IF missing → STOP. Get from upstream skill.

---

## Security Review Process

```
1. SCAN dependencies for vulnerabilities
2. CHECK OWASP Top 10 categories
3. VERIFY authentication implementation
4. VERIFY authorization on all endpoints
5. CHECK data protection (encryption, logging)
6. REVIEW infrastructure configuration
7. DOCUMENT all findings
```

---

## Blocking Conditions

These findings BLOCK release immediately:

| Severity | Examples | Response |
|----------|----------|----------|
| Critical | RCE, Auth bypass, Data breach | HALT. Fix within 24h. |
| High | Privilege escalation, SQLi, Stored XSS | BLOCK. Fix within 7 days. |
| Medium | CSRF, Reflected XSS, Info disclosure | WARN. Fix within 30 days. |
| Low | Minor info leak, Best practice | NOTE. Fix within 90 days. |

**Critical or High = NO RELEASE**

---

## Authentication Checklist

- [ ] Passwords hashed with bcrypt/argon2 (cost >= 10)
- [ ] Sessions invalidated on password change
- [ ] MFA available for sensitive operations
- [ ] Rate limiting on auth endpoints (5 attempts, 15min lockout)
- [ ] Secure cookies (secure, httpOnly, sameSite=strict)

IF any unchecked → DOCUMENT as finding.

---

## Authorization Checklist

- [ ] Every endpoint has authorization check
- [ ] No direct object references without ownership check
- [ ] Admin functions require admin role
- [ ] API keys have minimal required permissions

IF any unchecked → DOCUMENT as finding.

---

## Data Protection Checklist

- [ ] Sensitive data encrypted at rest
- [ ] TLS 1.3 for all connections
- [ ] PII not logged
- [ ] Secrets not in code/config files (use vault)

IF any unchecked → DOCUMENT as finding.

---

## Required Security Headers

```
X-Frame-Options: DENY
X-Content-Type-Options: nosniff
Strict-Transport-Security: max-age=31536000; includeSubDomains
Content-Security-Policy: default-src 'self'
Referrer-Policy: strict-origin-when-cross-origin
```

VERIFY all headers present. Missing header = Medium finding.

---

## Feedback Routing

| Issue | Route To |
|-------|----------|
| Architecture insecure | solution-architect |
| Data model exposes PII | data-engineer |
| API exposes sensitive data | API designer |
| Code vulnerability | fullstack-developer |
| Infrastructure misconfiguration | platform-engineer |
| Missing compliance requirement | business-analyst |

---

## Handoff Checklist

Before passing to release:

- [ ] Security review completed
- [ ] No Critical findings
- [ ] No High findings (or risk accepted in writing)
- [ ] Dependency vulnerabilities checked
- [ ] All findings logged with VULN-XXX

IF Critical or High exists → BLOCK RELEASE.

---

## Output

```
docs/security/
├── SECURITY-REVIEW.md         # Completed checklist
└── VULNERABILITY-REPORT.md    # All VULN-XXX findings
```

**Finding Format:**
| ID | Severity | Category | Description | Status |
|----|----------|----------|-------------|--------|
| VULN-001 | High | A03:Injection | SQL injection in search | Open |
