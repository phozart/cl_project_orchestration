---
name: implementation-verifier
description: This skill should be used when invoked by project-orchestrator at Gate 5 (before QA), or when the user asks to "verify the implementation", "smoke test", "check if it runs", or needs pre-QA validation. Smoke tests infrastructure, routes, and database to catch "it doesn't even start" issues.
---

# Implementation Verifier

Verify it works before QA. If it doesn't start, QA doesn't start.

## Rules

1. RUN verification ALWAYS after development, before QA.
2. STOP on any phase failure. Do not continue.
3. BLOCK QA handoff if any blocker exists.
4. RETURN to upstream skill on failure. Not QA's problem.
5. VERIFY core user journey works end-to-end.
6. DOCUMENT all findings in verification report.

## References

| File | Content |
|------|---------|
| `references/verification-phases.md` | Detailed steps for each phase |
| `references/report-template.md` | Verification report format |

---

## Input Validation

REQUIRED before verification:
- [ ] Code complete (developer says "done")
- [ ] `docker-compose.yml` exists
- [ ] Seed data scripts exist
- [ ] Test credentials documented

IF missing → STOP. Get from upstream.

---

## Verification Phases

Execute in order. STOP on failure.

```
1. BUILD        → npm run build
2. INFRASTRUCTURE → docker-compose up
3. DATABASE     → migrations + seed
4. APPLICATION  → npm run dev
5. ROUTES       → curl all main routes
6. AUTH         → login/logout flow
7. CORE FEATURES → smoke test Must-haves
8. ADMIN        → admin panel (if applicable)
```

---

## Phase Execution

### Phase 1: Build

```bash
npm run build
```

- [ ] Exit code 0
- [ ] No TypeScript errors
- [ ] Build output exists

**IF FAILS → STOP → Return to fullstack-developer**

---

### Phase 2: Infrastructure

```bash
docker-compose up -d && docker-compose ps
```

- [ ] All containers "Up"
- [ ] Database responds
- [ ] No port conflicts

**IF FAILS → STOP → Return to platform-engineer**

---

### Phase 3: Database

```bash
npm run db:migrate && npm run db:seed
```

- [ ] Migrations succeed
- [ ] Tables exist
- [ ] Seed data present

**IF FAILS → STOP → Return to platform-engineer**

---

### Phase 4: Application

```bash
npm run dev
curl -I http://localhost:3000/api/health
```

- [ ] App starts without crash
- [ ] Health endpoint returns 200

**IF FAILS → STOP → Return to fullstack-developer**

---

### Phase 5: Routes

```bash
curl -I http://localhost:3000/
curl -I http://localhost:3000/login
curl -I http://localhost:3000/api/health
```

- [ ] No 404 on main routes
- [ ] No 500 errors
- [ ] Static assets load

**IF FAILS → STOP → Return to fullstack-developer**

---

### Phase 6: Auth

```bash
curl -X POST http://localhost:3000/api/auth/login \
  -d '{"email":"test@test.com","password":"Test123!@#"}'
```

- [ ] Login returns token/session
- [ ] Authenticated routes work
- [ ] Logout works

**IF FAILS → STOP → Return to fullstack-developer**

---

### Phase 7: Core Features

For EACH Must-have user story:

| US-ID | Test | Result |
|-------|------|--------|
| US-001 | [One-line test] | PASS/FAIL |

- [ ] All Must-haves have basic functionality
- [ ] CRUD works
- [ ] Data persists

**IF ANY FAIL → STOP → Return to fullstack-developer**

---

### Phase 8: Admin (if applicable)

- [ ] Admin user seeded
- [ ] Admin login works
- [ ] Admin dashboard accessible

**IF FAILS → STOP → Return to fullstack-developer**

---

## Handoff Decision

| Result | Action |
|--------|--------|
| All PASS | → Proceed to QA |
| Any FAIL | → Return to upstream skill |

---

## Handoff to QA

IF all phases PASS:

```markdown
Implementation verified and ready for QA.

**Test Environment:**
- URL: http://localhost:3000
- Admin: admin@app.com / AdminPass123!
- Test User: test@test.com / TestPass123!

**Known Limitations:** [Any non-blocking issues]
```

---

## Return to Developer/Platform

IF any phase FAILS:

```markdown
Implementation verification FAILED. Not ready for QA.

**Blockers:**
1. [Issue] - Route to: [skill]

Re-verify after fixes.
```

---

## Issue Routing

| Issue | Route To |
|-------|----------|
| Build fails | fullstack-developer |
| Docker won't start | platform-engineer |
| Database errors | platform-engineer + data-engineer |
| Routes 404/500 | fullstack-developer |
| Auth broken | fullstack-developer |
| Missing seed data | platform-engineer |
| Missing env var | platform-engineer |

---

## Output

```
docs/verification/
└── VERIFICATION-REPORT.md
```

**This is a GATE. QA does not begin until verification PASSES.**
