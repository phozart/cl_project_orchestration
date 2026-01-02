# Security Review: {{PROJECT_NAME}}

## Document Control
| Field | Value |
|-------|-------|
| **Version** | 1.0 |
| **Status** | Draft / In Review / Approved |
| **Reviewer** | {{REVIEWER}} |
| **Date** | {{DATE}} |

---

## 1. Executive Summary

### Overall Security Posture
{{SECURITY_POSTURE}} (Strong / Acceptable / Needs Improvement / Critical Issues)

### Key Findings
| Severity | Count |
|----------|-------|
| Critical | {{CRITICAL_COUNT}} |
| High | {{HIGH_COUNT}} |
| Medium | {{MEDIUM_COUNT}} |
| Low | {{LOW_COUNT}} |

### Recommendation
{{RECOMMENDATION}} (Approve / Approve with Conditions / Do Not Approve)

---

## 2. Scope

### Reviewed Components
- [ ] Authentication system
- [ ] Authorization/RBAC
- [ ] API endpoints
- [ ] Data storage
- [ ] Third-party integrations
- [ ] Infrastructure configuration
- [ ] Dependencies

### Out of Scope
- {{OUT_OF_SCOPE}}

---

## 3. OWASP Top 10 Assessment

| # | Vulnerability | Status | Notes |
|---|---------------|--------|-------|
| A01 | Broken Access Control | ✅ / ⚠️ / ❌ | {{NOTES}} |
| A02 | Cryptographic Failures | ✅ / ⚠️ / ❌ | {{NOTES}} |
| A03 | Injection | ✅ / ⚠️ / ❌ | {{NOTES}} |
| A04 | Insecure Design | ✅ / ⚠️ / ❌ | {{NOTES}} |
| A05 | Security Misconfiguration | ✅ / ⚠️ / ❌ | {{NOTES}} |
| A06 | Vulnerable Components | ✅ / ⚠️ / ❌ | {{NOTES}} |
| A07 | Auth Failures | ✅ / ⚠️ / ❌ | {{NOTES}} |
| A08 | Software/Data Integrity | ✅ / ⚠️ / ❌ | {{NOTES}} |
| A09 | Logging/Monitoring | ✅ / ⚠️ / ❌ | {{NOTES}} |
| A10 | SSRF | ✅ / ⚠️ / ❌ | {{NOTES}} |

Legend: ✅ Addressed | ⚠️ Partial | ❌ Not Addressed

---

## 4. Findings

### VULN-001: {{VULNERABILITY_TITLE}}

| Field | Value |
|-------|-------|
| **Severity** | Critical / High / Medium / Low |
| **CVSS Score** | {{SCORE}} |
| **Status** | Open / In Progress / Resolved |
| **Component** | {{COMPONENT}} |

**Description**:
{{DESCRIPTION}}

**Impact**:
{{IMPACT}}

**Recommendation**:
{{RECOMMENDATION}}

**Remediation**:
```
{{REMEDIATION_CODE_OR_STEPS}}
```

**References**:
- {{REFERENCE_URL}}

---

### VULN-002: {{VULNERABILITY_TITLE}}

| Field | Value |
|-------|-------|
| **Severity** | High |
| **Status** | Open |

**Description**:
{{DESCRIPTION}}

**Recommendation**:
{{RECOMMENDATION}}

---

## 5. Authentication Review

### Current Implementation
| Aspect | Implementation | Status |
|--------|----------------|--------|
| Password hashing | {{ALGORITHM}} | ✅ / ❌ |
| Password policy | {{POLICY}} | ✅ / ❌ |
| Session management | {{METHOD}} | ✅ / ❌ |
| Token expiration | {{DURATION}} | ✅ / ❌ |
| MFA available | {{MFA_STATUS}} | ✅ / ❌ |
| Account lockout | {{LOCKOUT}} | ✅ / ❌ |

### Recommendations
- {{AUTH_REC_1}}
- {{AUTH_REC_2}}

---

## 6. Authorization Review

### RBAC Implementation
| Role | Permissions | Properly Enforced |
|------|-------------|-------------------|
| User | {{PERMS}} | ✅ / ❌ |
| Admin | {{PERMS}} | ✅ / ❌ |

### Authorization Checks
- [ ] All endpoints have authorization checks
- [ ] Admin functions protected
- [ ] Data isolation (users can't access others' data)
- [ ] API keys properly scoped

---

## 7. Data Protection

### Encryption
| Data Type | At Rest | In Transit |
|-----------|---------|------------|
| Passwords | ✅ Bcrypt | N/A |
| PII | ✅ / ❌ | ✅ TLS |
| Tokens | N/A | ✅ TLS |

### Sensitive Data Handling
- [ ] No secrets in code
- [ ] No secrets in logs
- [ ] PII minimization
- [ ] Data retention policy

---

## 8. Infrastructure Security

### Configuration Review
| Item | Status | Notes |
|------|--------|-------|
| HTTPS only | ✅ / ❌ | |
| Security headers | ✅ / ❌ | |
| CORS configured | ✅ / ❌ | |
| Rate limiting | ✅ / ❌ | |
| WAF enabled | ✅ / ❌ | |

### Security Headers Checklist
- [ ] Content-Security-Policy
- [ ] X-Content-Type-Options
- [ ] X-Frame-Options
- [ ] Strict-Transport-Security
- [ ] X-XSS-Protection

---

## 9. Dependency Analysis

### Vulnerable Dependencies
| Package | Version | Vulnerability | Severity |
|---------|---------|---------------|----------|
| {{PACKAGE}} | {{VERSION}} | {{CVE}} | {{SEVERITY}} |

### Recommendations
- Update {{PACKAGE}} to version {{SAFE_VERSION}}

---

## 10. Remediation Plan

| Finding | Priority | Owner | Due Date | Status |
|---------|----------|-------|----------|--------|
| VULN-001 | Critical | {{OWNER}} | {{DATE}} | Open |
| VULN-002 | High | {{OWNER}} | {{DATE}} | Open |

---

## 11. Sign-Off

### Pre-Release Checklist
- [ ] All Critical findings resolved
- [ ] All High findings resolved or accepted
- [ ] Security testing complete
- [ ] Penetration test passed (if required)

### Approval
| Role | Name | Signature | Date |
|------|------|-----------|------|
| Security Lead | {{NAME}} | | |
| Tech Lead | {{NAME}} | | |
| Product Owner | {{NAME}} | | |
