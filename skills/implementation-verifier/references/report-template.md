# Verification Report Template

Use this template for all verification reports.

---

## Report Format

```markdown
# Implementation Verification Report

**Project:** [Name]
**Date:** [Date]
**Verifier:** Implementation Verifier
**Status:** PASS / FAIL / PARTIAL
**Ready for QA:** YES / NO

---

## Summary

| Area | Status | Notes |
|------|--------|-------|
| Build | PASS/FAIL | |
| Infrastructure | PASS/FAIL | |
| Database | PASS/FAIL | |
| Application | PASS/FAIL | |
| Routes | PASS/FAIL | |
| Auth | PASS/FAIL | |
| Core Features | PASS/FAIL | |
| Admin | PASS/FAIL | N/A if no admin |

---

## Routes Tested

| Route | Expected | Actual | Status |
|-------|----------|--------|--------|
| / | 200/redirect | [code] | PASS/FAIL |
| /login | 200 | [code] | PASS/FAIL |
| /signup | 200 | [code] | PASS/FAIL |
| /api/health | 200 | [code] | PASS/FAIL |

---

## Core Feature Tests

| US-ID | Test | Result |
|-------|------|--------|
| US-001 | [Quick test description] | PASS/FAIL |
| US-002 | [Quick test description] | PASS/FAIL |

---

## Blockers (Must Fix Before QA)

> These issues BLOCK handoff to QA.

1. [BLOCKER-001] [Description] - Route to: [skill]
2. [BLOCKER-002] [Description] - Route to: [skill]

---

## Warnings (Should Fix)

> Non-blocking but should be addressed.

1. [WARN-001] [Description]
2. [WARN-002] [Description]

---

## Test Environment

- **URL:** http://localhost:3000
- **Admin:** admin@app.com / AdminPass123!
- **Test User:** test@test.com / TestPass123!
- **Database:** PostgreSQL (docker-compose)

---

## Recommendation

[ ] PROCEED to QA - All checks pass
[ ] RETURN to Developer - Code issues
[ ] RETURN to Platform Engineer - Infrastructure issues
[ ] RETURN to Data Engineer - Database issues

---

## Sign-off

| Role | Decision | Date |
|------|----------|------|
| Implementation Verifier | [PASS/FAIL] | [Date] |
```

---

## Quick Status Indicators

| Symbol | Meaning |
|--------|---------|
| PASS | All checks successful |
| FAIL | One or more blockers |
| PARTIAL | Passes with warnings |
| N/A | Not applicable |

---

## Issue Routing Quick Reference

| Issue Type | Route To |
|------------|----------|
| Build fails | fullstack-developer |
| Docker won't start | platform-engineer |
| Database errors | platform-engineer + data-engineer |
| Routes 404 | fullstack-developer |
| Auth broken | fullstack-developer |
| Missing seed data | platform-engineer |
| Env var missing | platform-engineer |
| Missing feature | fullstack-developer |
