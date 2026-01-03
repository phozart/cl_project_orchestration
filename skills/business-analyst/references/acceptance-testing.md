# Business Acceptance Testing (BAT)

Manual validation that product meets requirements from user perspective.

---

## When to Run BAT

After QA passes, before release gate.

---

## BAT Process

### 1. Prepare

- [ ] Open staging/pre-production environment
- [ ] Have available: Project Brief, Requirements, User Stories
- [ ] Clear browser cache, use incognito if needed
- [ ] Have test accounts ready (admin, regular user)

### 2. First Impressions (5 minutes)

| Check | Pass/Fail |
|-------|-----------|
| App loads without errors | |
| Purpose is immediately clear | |
| Navigation is intuitive | |
| No obvious broken elements | |

IF any fail → Critical issue. Document and assess if testing can continue.

### 3. User Story Validation

For EACH user story (US-XXX):

```markdown
### US-XXX: [Title]

**As a** [role]
**I want** [action]
**So that** [benefit]

**Acceptance Criteria:**
- [ ] Criteria 1: [Pass/Fail]
- [ ] Criteria 2: [Pass/Fail]
- [ ] Criteria 3: [Pass/Fail]

**Can user achieve goal?** Yes/No
**Notes:** [Any issues observed]
```

### 4. Requirements Traceability

For EACH requirement (REQ-XXX):
- Is it implemented?
- Does it match the intent?
- Would the stakeholder approve?

### 5. Problem-Solution Fit

- Does the product solve the stated problem?
- Would target users find value?
- Is the experience acceptable?

---

## BAT Report Template

```markdown
# Business Acceptance Report

**Project:** [Name]
**Date:** [Date]
**Environment:** [URL]
**Tester:** [Name]

## Recommendation
- [ ] ACCEPT - Ready for release
- [ ] REJECT - Cannot release
- [ ] CONDITIONAL - Release with known limitations

## Summary
| Metric | Count |
|--------|-------|
| User Stories Tested | X |
| User Stories Passed | X |
| User Stories Failed | X |
| Critical Issues | X |
| High Issues | X |

## Issues Found

| ID | Severity | Story/Req | Description | Steps to Reproduce |
|----|----------|-----------|-------------|-------------------|
| BAT-001 | Critical | US-003 | Cannot complete signup | 1. Go to /signup 2. Fill form 3. Submit 4. Error |

## Detailed Results

### User Stories
| ID | Title | Status | Notes |
|----|-------|--------|-------|
| US-001 | User signup | PASS | |
| US-002 | User login | PASS | |
| US-003 | Password reset | FAIL | Email not sent |

### Requirements
| ID | Title | Implemented | Matches Intent |
|----|-------|-------------|----------------|
| REQ-001 | Registration | Yes | Yes |
| REQ-002 | Verification | Yes | Partially |

## Recommendation Details

### If ACCEPT
- All critical user stories pass
- Product solves the stated problem
- User experience is acceptable
- Known issues are documented

### If REJECT
- Critical user story blocked: [which one]
- Product does not solve problem because: [reason]
- Must fix before release: [list]

### If CONDITIONAL
- Release despite: [list minor issues]
- Known limitations: [list]
- Fix in next release: [list]
```

---

## Issue Severity

| Severity | Definition | Release Impact |
|----------|------------|----------------|
| Critical | User cannot complete core task | REJECT - must fix |
| High | Feature broken, workaround exists | Fix before release |
| Medium | Works but suboptimal | Ship with notes |
| Low | Polish issue | Track for later |

---

## Decision Rules

| Condition | Decision |
|-----------|----------|
| Any critical issue | REJECT |
| Multiple high issues | REJECT or CONDITIONAL |
| Only medium/low issues | ACCEPT or CONDITIONAL |
| All stories pass | ACCEPT |
