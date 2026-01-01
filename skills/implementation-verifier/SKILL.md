---
name: implementation-verifier
description: Verify the implementation actually works before QA testing. Smoke test infrastructure, routes, database connections, and basic functionality. Use ALWAYS after development, before QA. Catches "it doesn't even start" issues early.
---

# Implementation Verifier

Verify the implementation actually runs before passing to QA. This skill catches fundamental issues like broken links, missing database tables, failed builds, and configuration errors.

## Why This Exists

QA testers shouldn't discover:
- "The app doesn't start"
- "Half the links are broken"
- "Database connection fails"
- "Login doesn't work at all"

These are **implementation failures**, not bugs to test. Catch them here.

## When to Use This Skill

**ALWAYS** run before QA testing:
- After Fullstack Developer completes implementation
- After Platform Engineer sets up infrastructure
- Before passing to QA Engineer
- When user says "verify it works", "smoke test", "sanity check"

## Verification Process

### Phase 1: Build Verification

```bash
# Can the project build at all?
npm run build  # or equivalent

# Expected: Build succeeds without errors
# If fails: STOP - return to developer
```

**Checklist:**
- [ ] Build command completes successfully
- [ ] No TypeScript/compilation errors
- [ ] No missing dependencies
- [ ] Build output exists (dist/, .next/, build/)

### Phase 2: Infrastructure Verification

```bash
# Do all services start?
docker-compose up -d
docker-compose ps  # All services should be "Up"

# Is database accessible?
docker-compose exec db psql -U postgres -c "SELECT 1"

# Is Redis accessible (if used)?
docker-compose exec redis redis-cli ping
```

**Checklist:**
- [ ] All Docker containers start
- [ ] Database container healthy
- [ ] Redis/cache container healthy (if used)
- [ ] No port conflicts
- [ ] Volumes mounted correctly

### Phase 3: Database Verification

```bash
# Do migrations run?
npm run db:migrate

# Is seed data present?
npm run db:seed

# Can we query the database?
# Check that expected tables exist
```

**Checklist:**
- [ ] Migrations run without errors
- [ ] All expected tables exist
- [ ] Seed data is present
- [ ] Foreign key relationships valid
- [ ] Indexes created

### Phase 4: Application Startup

```bash
# Does the app start?
npm run dev  # or npm start

# Wait for startup, then verify
curl -I http://localhost:3000
# Expected: HTTP 200 or redirect to login
```

**Checklist:**
- [ ] Application starts without crash
- [ ] No unhandled exceptions on startup
- [ ] Logs show successful initialization
- [ ] App responds on expected port

### Phase 5: Route Verification

Test all main routes respond (not 404 or 500):

```bash
# Public routes
curl -I http://localhost:3000/
curl -I http://localhost:3000/login
curl -I http://localhost:3000/signup

# API routes (expect 401 if auth required, not 404/500)
curl -I http://localhost:3000/api/health
curl -I http://localhost:3000/api/users

# Static assets
curl -I http://localhost:3000/favicon.ico
```

**Checklist:**
- [ ] Homepage loads (200 or redirect)
- [ ] Login page loads
- [ ] Signup page loads (if applicable)
- [ ] API health endpoint responds
- [ ] Static assets load
- [ ] No 404s on main navigation links
- [ ] No 500 errors on any route

### Phase 6: Authentication Flow

```bash
# Can a user sign up? (if signup enabled)
curl -X POST http://localhost:3000/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"Test123!@#"}'

# Can a user log in?
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"Test123!@#"}'

# Does session work?
# Use returned token/cookie for authenticated request
```

**Checklist:**
- [ ] Signup creates user (if enabled)
- [ ] Login returns session/token
- [ ] Authenticated routes work with token
- [ ] Logout invalidates session
- [ ] Password requirements enforced

### Phase 7: Core Feature Smoke Test

For each core user story, verify the happy path works:

```markdown
## US-001: [User Story Title]
**Quick Test:** [One-line description of test]
**Result:** PASS / FAIL / BLOCKED

Example:
## US-001: Resume Reading
**Quick Test:** Upload PDF, start reading, close app, reopen - should resume
**Result:** PASS
```

**Checklist:**
- [ ] Each Must-have user story has basic functionality
- [ ] CRUD operations work for main entities
- [ ] Navigation between pages works
- [ ] Forms submit successfully
- [ ] Data persists after page refresh

### Phase 8: Admin Functionality (if applicable)

```bash
# Can admin log in?
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@app.com","password":"AdminPass123!"}'

# Can admin access admin routes?
curl -I http://localhost:3000/admin \
  -H "Authorization: Bearer <admin_token>"
```

**Checklist:**
- [ ] Admin user exists (seeded)
- [ ] Admin can log in
- [ ] Admin dashboard accessible
- [ ] User management works
- [ ] Role assignment works
- [ ] Admin-only routes protected

## Verification Report

```markdown
# Implementation Verification Report

## Project: [Name]
## Date: [Date]
## Verified by: implementation-verifier

## Summary
- **Status**: PASS / FAIL / PARTIAL
- **Ready for QA**: YES / NO
- **Blockers**: [Count]

## Build
- [ ] Build succeeds: PASS/FAIL
- [ ] No compilation errors: PASS/FAIL
- Notes: [Any warnings or issues]

## Infrastructure
- [ ] Docker services start: PASS/FAIL
- [ ] Database accessible: PASS/FAIL
- [ ] Cache accessible: PASS/FAIL
- Notes: [Any issues]

## Database
- [ ] Migrations run: PASS/FAIL
- [ ] Seed data present: PASS/FAIL
- [ ] Tables exist: PASS/FAIL
- Notes: [Any issues]

## Application
- [ ] App starts: PASS/FAIL
- [ ] No startup errors: PASS/FAIL
- [ ] Responds on port: PASS/FAIL
- Notes: [Any issues]

## Routes Tested
| Route | Expected | Actual | Status |
|-------|----------|--------|--------|
| / | 200/redirect | [result] | PASS/FAIL |
| /login | 200 | [result] | PASS/FAIL |
| /api/health | 200 | [result] | PASS/FAIL |
| ... | ... | ... | ... |

## Broken Links Found
| Page | Broken Link | Expected Target |
|------|-------------|-----------------|
| [page] | [link text] | [where it should go] |

## Authentication
- [ ] Signup works: PASS/FAIL/NA
- [ ] Login works: PASS/FAIL
- [ ] Session persists: PASS/FAIL
- [ ] Logout works: PASS/FAIL
- Notes: [Any issues]

## Admin Functionality
- [ ] Admin user exists: PASS/FAIL/NA
- [ ] Admin can login: PASS/FAIL/NA
- [ ] Admin dashboard works: PASS/FAIL/NA
- [ ] User management works: PASS/FAIL/NA
- Notes: [Any issues]

## Core Features Smoke Test
| User Story | Test | Result |
|------------|------|--------|
| US-001 | [test] | PASS/FAIL |
| US-002 | [test] | PASS/FAIL |
| ... | ... | ... |

## Blockers (Must Fix Before QA)
1. [Critical issue that blocks QA]
2. [Another blocker]

## Warnings (Should Fix)
1. [Non-blocking issue]
2. [Another warning]

## Recommendation
[ ] PROCEED to QA - All critical verifications pass
[ ] RETURN to Developer - Blockers must be fixed
[ ] RETURN to Platform Engineer - Infrastructure issues
```

## Routing Issues

| Issue Type | Route To | Example |
|------------|----------|---------|
| Build fails | Fullstack Developer | "TypeScript errors in auth module" |
| Docker won't start | Platform Engineer | "Port 5432 already in use" |
| Database errors | Platform Engineer + Data Architect | "Migration fails on foreign key" |
| Routes 404 | Fullstack Developer | "Missing /api/users endpoint" |
| Auth broken | Fullstack Developer | "Login returns 500" |
| Missing seed data | Platform Engineer | "No admin user to test with" |
| Env var missing | Platform Engineer | "DATABASE_URL not set" |

## Handoff Protocol

### If PASS → QA Engineer
```markdown
Implementation verified and ready for QA testing.

**Verified:**
- Build: OK
- Infrastructure: OK
- Database: OK
- Routes: OK
- Auth: OK
- Core features: Basic functionality confirmed

**Test Environment:**
- URL: http://localhost:3000
- Admin: admin@app.com / AdminPass123!
- Test User: test@test.com / TestPass123!

**Known Limitations:**
- [Any non-blocking issues]

Ready for full QA testing.
```

### If FAIL → Developer/Platform Engineer
```markdown
Implementation verification FAILED. Not ready for QA.

**Blockers:**
1. [Issue 1] - Assigned to: [skill]
2. [Issue 2] - Assigned to: [skill]

**Must be fixed before re-verification.**

Re-verify after fixes are applied.
```

## Anti-Patterns

| Anti-Pattern | Problem | Correction |
|--------------|---------|------------|
| Skipping verification | QA finds "app doesn't start" | Always verify before QA |
| Manual testing only | Inconsistent, misses issues | Use scripted checks |
| No seed data | Can't test anything | Require seed data |
| Testing production | Dangerous, incomplete | Always use dev environment |
| Ignoring warnings | Issues accumulate | Fix or document all warnings |

## Output Location

```
docs/
└── verification/
    └── VERIFICATION-REPORT.md    # Latest verification report
```

## Integration with Workflow

```
[Fullstack Developer] → Implementation complete
        ↓
[Implementation Verifier] → Does it actually work? ← YOU ARE HERE
        ↓
    PASS → [QA Engineer] → Full testing
        ↓
    FAIL → Return to Developer/Platform Engineer
```

This is a **gate** - QA should not begin until verification passes.
