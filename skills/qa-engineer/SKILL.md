---
name: qa-engineer
description: This skill should be used when the user asks to "test the application", "write test cases", "run QA", "check for bugs", "track defects", or needs quality assurance. Creates TC-XXX test cases for every REQ-XXX requirement and tracks DEF-XXX defects through full lifecycle.
---

# QA Engineer

Test against REQUIREMENTS (REQ-XXX), not what exists in code. **Track defects through full lifecycle.**

## Rules

1. CREATE TC-XXX for EVERY REQ-XXX. No exceptions.
2. RUN smoke test first. If core journey fails → BLOCKER → STOP.
3. LOG defects as DEF-XXX with severity and lifecycle.
4. BLOCK release on: Critical defect, Must-Have test failure, security vulnerability.
5. UPDATE RTM with all test results before release gate.
6. VERIFY defect fixes. DEF-XXX stays open until verified.

## References

| File | Content |
|------|---------|
| `references/test-automation.md` | Playwright, integration, unit test patterns |
| `references/performance-testing.md` | k6 load tests, performance budgets |
| `references/defect-management.md` | Severity levels, defect templates |

---

## Process

```
VALIDATE INPUTS → PLAN → AUTOMATE → EXECUTE → REPORT
```

---

## Phase 1: Validate Inputs

REQUIRED before testing:
- [ ] RTM exists with 100% Must-Have coverage
- [ ] All requirements have testable acceptance criteria
- [ ] App runs (smoke test passes)
- [ ] Test environment stable, test data seeded

IF any unchecked → STOP. Report to orchestrator.

---

## Phase 2: Test Planning

### Test Case Creation (MANDATORY)

For EVERY requirement, create test cases with TC-XXX IDs:

```markdown
## Test Case: TC-001

**Requirement:** REQ-001
**Priority:** Must
**Type:** Functional

**Preconditions:**
- User is logged in
- Test data exists

**Steps:**
1. Navigate to /users
2. Click "Add User"
3. Fill form with valid data
4. Submit

**Expected Result:**
- User created successfully
- Success message displayed
- Redirected to user list

**Actual Result:** [Filled during execution]
**Status:** Pass / Fail / Blocked
```

### Test Coverage Matrix (REQUIRED)

```markdown
| REQ-ID | Test Cases | Priority | Coverage |
|--------|------------|----------|----------|
| REQ-001 | TC-001, TC-002 | Must | 100% |
| REQ-002 | TC-003, TC-004, TC-005 | Must | 100% |
| REQ-003 | - | Must | 0% ← BLOCKER |
```

Requirement without test cases = **BLOCKER**. Create tests NOW.

---

## Phase 3: Test Execution

### Smoke Test First

Run smoke tests. If core journey fails:
1. STOP all testing
2. DOCUMENT: What's broken
3. REPORT: BLOCKER to orchestrator
4. WAIT: For fix before continuing

See `project-orchestrator/references/critical-path-testing.md` for BLOCKER protocol.

### Test Order

1. Smoke tests (app runs, critical paths)
2. Functional tests (features work per spec)
3. Edge case tests (boundaries, nulls, errors)
4. Security tests (auth, injection, XSS)
5. Performance tests (load, stress)

---

## Phase 4: Reporting

### Test Results Format

```markdown
## Summary
| Status | Count |
|--------|-------|
| Passed | [N] |
| Failed | [N] |
| Blocked | [N] |

## Results by Requirement
| REQ-ID | Passed | Failed | Status |
|--------|--------|--------|--------|
| REQ-001 | 3 | 0 | PASS |
| REQ-002 | 2 | 1 | FAIL |

## Recommendation
- [ ] SHIP - All tests pass
- [ ] FIX FIRST - Critical issues exist
- [ ] BLOCK - Release not ready
```

---

## Release Gate

### BLOCK Release If

- Critical severity defect
- Core user flow broken
- Data loss/corruption possible
- Security vulnerability
- Any Must-Have test fails
- Performance thresholds exceeded

### APPROVE Release If

- All Critical/High defects fixed
- All smoke tests pass
- 100% Must-Have tests pass
- Performance within targets
- No regression from previous release
- RTM updated with all results

---

## Defect Tracking (MANDATORY)

### Defect Format (REQUIRED)

Every defect MUST follow this format:

```markdown
## Defect: DEF-001

**Severity:** Critical / High / Medium / Low
**Status:** Open → In Progress → Fixed → Verified → Closed
**Found in:** TC-001 (or "exploratory")
**Requirement:** REQ-001
**Assigned to:** fullstack-developer

**Description:**
User registration fails when email contains "+"

**Steps to reproduce:**
1. Go to /register
2. Enter email: test+1@example.com
3. Submit form

**Expected:** User registered
**Actual:** 500 error

**Fix verification:**
- [ ] Fix applied
- [ ] Regression test passed
- [ ] Original test case passes
```

### Defect Lifecycle (ENFORCED)

```
Open → In Progress → Fixed → Verified → Closed
                  ↓
              Reopened (if verification fails)
```

**Rules:**
- DEF-XXX stays OPEN until code fix deployed
- DEF-XXX stays FIXED until QA verifies
- QA MUST verify before closing
- If verification fails → REOPEN, increment reopen count

### Defect Severity

| Severity | Criteria | Action |
|----------|----------|--------|
| **Critical** | Core feature broken, data loss, security hole | BLOCK release |
| **High** | Feature broken, workaround exists | FIX before release |
| **Medium** | Feature impaired, usable | Track, fix in next release |
| **Low** | Cosmetic, minor annoyance | Log, prioritize later |

### Release Blocking

```markdown
## Defect Summary Before Release

| Severity | Open | Fixed | Verified | Closed |
|----------|------|-------|----------|--------|
| Critical | 0 | 0 | 0 | 2 |
| High | 0 | 0 | 1 | 5 |
| Medium | 3 | 2 | 0 | 8 |
| Low | 5 | 1 | 0 | 3 |

**Release Status:** ✅ APPROVED (no open Critical/High)
```

**BLOCK if:** Any Critical or High defect not Verified or Closed.

---

## Feedback Routing

| Issue | Route To |
|-------|----------|
| Requirement untestable | business-analyst |
| Feature doesn't match spec | fullstack-developer |
| Security vulnerability | security-engineer + developer |
| Performance unacceptable | developer + architect |
| UX confusing | designer |

---

## Output

```
docs/qa/
├── TEST-PLAN.md
├── TEST-RESULTS.md
├── DEFECTS.md
└── PERFORMANCE-REPORT.md

tests/
├── e2e/
├── integration/
├── unit/
└── performance/

docs/traceability/
└── RTM.md (updated with test results)
```

---

## Templates

| Template | Target |
|----------|--------|
| `templates/docs/qa/TEST-PLAN.template.md` | `docs/qa/TEST-PLAN.md` |
| `templates/docs/qa/TEST-CASES.template.md` | `docs/qa/TEST-CASES.md` |
