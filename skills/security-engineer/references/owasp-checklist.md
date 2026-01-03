# OWASP Top 10 Security Checklist

Reference for security review code patterns and anti-patterns.

---

## 1. Injection (SQL, XSS, Command)

```typescript
// BAD: SQL Injection
const query = `SELECT * FROM users WHERE id = ${userId}`;

// GOOD: Parameterized queries
const query = `SELECT * FROM users WHERE id = $1`;
await db.query(query, [userId]);

// BAD: XSS
element.innerHTML = userInput;

// GOOD: Safe rendering
element.textContent = userInput;
// Or use framework that escapes by default (React, Vue)
```

---

## 2. Broken Authentication

```typescript
const authSecurityChecklist = {
  passwordMinLength: 12,
  passwordRequiresMixed: true,
  passwordCheckBreached: true, // haveibeenpwned
  sessionTimeout: 30 * 60 * 1000, // 30 minutes
  sessionSecureCookie: true,
  sessionHttpOnly: true,
  sessionSameSite: 'strict',
  loginAttemptLimit: 5,
  loginLockoutDuration: 15 * 60 * 1000,
  mfaRequired: true, // For sensitive operations
};
```

---

## 3. Sensitive Data Exposure

```typescript
enum DataClassification {
  PUBLIC = 'public',
  INTERNAL = 'internal',
  CONFIDENTIAL = 'confidential',
  RESTRICTED = 'restricted', // PII, credentials, health
}

// BAD: Logging sensitive data
console.log(`User login: ${email}, password: ${password}`);

// GOOD: Mask sensitive data
console.log(`User login: ${maskEmail(email)}`);
```

---

## 4. Security Headers

```typescript
const securityHeaders = {
  'X-Frame-Options': 'DENY',
  'X-Content-Type-Options': 'nosniff',
  'X-XSS-Protection': '1; mode=block',
  'Strict-Transport-Security': 'max-age=31536000; includeSubDomains; preload',
  'Content-Security-Policy': "default-src 'self'; frame-ancestors 'none'",
  'Permissions-Policy': 'geolocation=(), microphone=(), camera=()',
  'Referrer-Policy': 'strict-origin-when-cross-origin',
};
```

---

## 5. Input Validation

```typescript
// Validation schema (Zod)
const userCreateSchema = z.object({
  email: z.string().email().max(255),
  name: z.string().min(1).max(100).regex(/^[a-zA-Z\s\-']+$/),
  password: z.string()
    .min(12)
    .regex(/[A-Z]/).regex(/[a-z]/)
    .regex(/[0-9]/).regex(/[^A-Za-z0-9]/),
});

// Validate ALL input at boundaries
```

---

## 6. Authorization Checks

```typescript
// BAD: No authorization check
app.get('/users/:id', async (req, res) => {
  const user = await db.getUser(req.params.id);
  res.json(user);
});

// GOOD: Proper authorization
app.get('/users/:id', authenticate, async (req, res) => {
  const user = await db.getUser(req.params.id);
  if (!canAccess(req.user, user)) {
    throw new ForbiddenError('Access denied');
  }
  res.json(sanitizeForViewer(user, req.user));
});
```

---

## Quick Reference

| Vulnerability | Check For | Fix |
|--------------|-----------|-----|
| SQL Injection | String concatenation in queries | Parameterized queries |
| XSS | innerHTML, dangerouslySetInnerHTML | textContent, framework escaping |
| CSRF | Missing token validation | CSRF tokens, SameSite cookies |
| Auth bypass | Missing auth middleware | Auth on every protected route |
| Broken access | No ownership check | Check user.id === resource.owner |
| Data exposure | PII in logs/responses | Mask, filter, classify |
