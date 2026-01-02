---
name: implementation-verifier
description: Verify the implementation actually works before QA testing. Smoke test infrastructure, routes, database connections, and basic functionality. Use ALWAYS after development, before QA. Catches "it doesn't even start" issues early.
---

# Implementation Verifier

Verify the implementation actually runs before passing to QA. This skill catches fundamental issues like broken links, missing database tables, failed builds, and configuration errors.

**QA testers shouldn't discover "the app doesn't start" - those are implementation failures, not bugs to test.**

## When to Use This Skill

**ALWAYS** run before QA testing:
- After Fullstack Developer completes implementation
- After Platform Engineer sets up infrastructure
- Before passing to QA Engineer
- When user says "verify it works", "smoke test", "sanity check"

---

## Input Validation

> See `_shared/TEMPLATES.md` for protocol. Apply these skill-specific checks:

**Required from Developer/Platform:** Complete codebase, environment configuration, seed data, test credentials

**Quality Checks:**
- Build completes without errors?
- Environment variables configured?
- Database migrations exist?
- Seed data provided?

**Domain Questions:** Can app start? Do routes respond? Does auth work? Can core features be exercised?

**Upstream Feedback triggers:** Build fails, missing env vars, no seed data, broken infrastructure → Developer/Platform Engineer

---

## Verification Process

### Phase 1: Build Verification

```bash
npm run build  # Must succeed without errors
```

- [ ] Build completes successfully
- [ ] No TypeScript/compilation errors
- [ ] No missing dependencies
- [ ] Build output exists (dist/, .next/, build/)

**If fails: STOP - return to developer**

### Phase 2: Infrastructure Verification

```bash
docker-compose up -d && docker-compose ps  # All "Up"
docker-compose exec db psql -U postgres -c "SELECT 1"
```

- [ ] All Docker containers start
- [ ] Database accessible
- [ ] Cache/Redis accessible (if used)
- [ ] No port conflicts

### Phase 3: Database Verification

```bash
npm run db:migrate && npm run db:seed
```

- [ ] Migrations run without errors
- [ ] All expected tables exist
- [ ] Seed data present
- [ ] Foreign keys valid

### Phase 4: Application Startup

```bash
npm run dev  # Then: curl -I http://localhost:3000
```

- [ ] App starts without crash
- [ ] No unhandled exceptions
- [ ] Responds on expected port

### Phase 5: Route Verification

Test all main routes respond (not 404 or 500):

```bash
curl -I http://localhost:3000/           # Homepage
curl -I http://localhost:3000/login      # Login page
curl -I http://localhost:3000/api/health # API health
```

- [ ] Homepage loads (200 or redirect)
- [ ] Login/signup pages load
- [ ] API health endpoint responds
- [ ] Static assets load
- [ ] No 404s on main navigation
- [ ] No 500 errors

### Phase 6: Authentication Flow

```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"Test123!@#"}'
```

- [ ] Login returns session/token
- [ ] Authenticated routes work
- [ ] Logout invalidates session

### Phase 7: Core Feature Smoke Test

For each Must-have user story, verify happy path:

| US-ID | Quick Test | Result |
|-------|-----------|--------|
| US-001 | [One-line test] | PASS/FAIL |

- [ ] Each Must-have story has basic functionality
- [ ] CRUD operations work
- [ ] Forms submit successfully
- [ ] Data persists after refresh

### Phase 8: Admin Functionality (if applicable)

- [ ] Admin user exists (seeded)
- [ ] Admin can log in
- [ ] Admin dashboard accessible
- [ ] User management works

---

## Verification Report

```markdown
# Implementation Verification Report

**Project:** [Name] | **Date:** [Date]
**Status:** PASS / FAIL / PARTIAL
**Ready for QA:** YES / NO

## Summary
| Area | Status |
|------|--------|
| Build | PASS/FAIL |
| Infrastructure | PASS/FAIL |
| Database | PASS/FAIL |
| Application | PASS/FAIL |
| Routes | PASS/FAIL |
| Auth | PASS/FAIL |
| Core Features | PASS/FAIL |

## Routes Tested
| Route | Expected | Actual | Status |
|-------|----------|--------|--------|
| / | 200/redirect | [result] | PASS/FAIL |

## Blockers (Must Fix Before QA)
1. [Critical issue]

## Warnings (Should Fix)
1. [Non-blocking issue]

## Recommendation
[ ] PROCEED to QA
[ ] RETURN to Developer - [issues]
[ ] RETURN to Platform Engineer - [issues]
```

---

## Routing Issues

| Issue Type | Route To |
|------------|----------|
| Build fails | Developer |
| Docker won't start | Platform Engineer |
| Database errors | Platform Engineer + Data Engineer |
| Routes 404 | Developer |
| Auth broken | Developer |
| Missing seed data | Platform Engineer |
| Env var missing | Platform Engineer |

---

## Handoff Protocol

### If PASS → QA Engineer

```markdown
Implementation verified and ready for QA.

**Test Environment:**
- URL: http://localhost:3000
- Admin: admin@app.com / AdminPass123!
- Test User: test@test.com / TestPass123!

**Known Limitations:** [Any non-blocking issues]
```

### If FAIL → Developer/Platform Engineer

```markdown
Implementation verification FAILED. Not ready for QA.

**Blockers:**
1. [Issue] - Assigned to: [skill]

Re-verify after fixes are applied.
```

---

## Integration with Workflow

```
[Developer] → [Implementation Verifier] → PASS → [QA Engineer]
                       ↓
                     FAIL → Return to Developer/Platform
```

This is a **gate** - QA should not begin until verification passes.

---

## Output Location

```
docs/verification/
└── VERIFICATION-REPORT.md
```
