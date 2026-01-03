# Security Review Checklist

Complete checklist for security review. ALL items must be verified.

---

## Authentication

- [ ] Passwords hashed with bcrypt/argon2 (cost >= 10)
- [ ] Sessions invalidated on password change
- [ ] MFA available for sensitive operations
- [ ] Rate limiting on auth endpoints
- [ ] Password requirements enforced (12+ chars, mixed case, numbers, symbols)
- [ ] Account lockout after failed attempts
- [ ] Secure password reset flow (time-limited tokens)

---

## Authorization

- [ ] Every endpoint has authorization check
- [ ] No direct object references without ownership check
- [ ] Admin functions require admin role
- [ ] API keys have minimal required permissions
- [ ] Role-based access control implemented
- [ ] Privilege escalation not possible
- [ ] Service-to-service auth secured

---

## Input Validation

- [ ] All input validated before processing
- [ ] File uploads validated (type, size, content)
- [ ] SQL queries use parameterized statements
- [ ] No eval() or dynamic code execution
- [ ] Path traversal prevented (../)
- [ ] JSON/XML parsing limits set
- [ ] Regular expressions DoS-safe (no ReDoS)

---

## Data Protection

- [ ] Sensitive data encrypted at rest
- [ ] TLS 1.3 for all connections
- [ ] PII not logged
- [ ] Secrets not in code/config files
- [ ] Data classified (Public/Internal/Confidential/Restricted)
- [ ] Encryption keys properly managed
- [ ] Data retention policies enforced

---

## Error Handling

- [ ] Errors don't leak sensitive info
- [ ] Stack traces not shown to users
- [ ] Generic error messages externally
- [ ] Errors logged with context (for debugging)
- [ ] Error responses consistent format

---

## Headers & Config

- [ ] Security headers set (see OWASP checklist)
- [ ] CORS restricted to known origins
- [ ] Cookies set secure, httponly, samesite
- [ ] Debug mode disabled in production
- [ ] Server version headers removed
- [ ] X-Frame-Options prevents clickjacking

---

## Dependencies

- [ ] No known vulnerabilities in dependencies
- [ ] Dependencies from trusted sources
- [ ] Lock files committed
- [ ] Regular dependency updates scheduled
- [ ] Sub-dependencies scanned

---

## Infrastructure

- [ ] Secrets in vault/secrets manager (not env files)
- [ ] Database not publicly accessible
- [ ] S3/storage buckets not public
- [ ] Network segmentation proper
- [ ] Logging/monitoring enabled
- [ ] Backup encryption verified

---

## Compliance (if applicable)

- [ ] GDPR: Consent, right to delete, data portability
- [ ] HIPAA: PHI protection, audit logs
- [ ] SOC2: Access controls, change management
- [ ] PCI: Card data handling, encryption
