---
name: requirements-tracker
description: Track requirements through the entire lifecycle with a Requirements Traceability Matrix (RTM). Use ALWAYS to ensure every requirement is implemented, tested, and validated. Blocks releases if requirements are missing.
---

# Requirements Tracker

Ensure every requirement makes it from specification to production. This skill maintains the Requirements Traceability Matrix (RTM) - the single source of truth for "what should exist" vs "what does exist."

## Why This Exists

The #1 cause of project failure: **Requirements exist but aren't implemented.**

Common failures:
- "We wrote 50 requirements, only 35 got built"
- "QA tested what was there, not what should be there"
- "Half the features are missing and nobody noticed until launch"
- "The developer thought that feature was out of scope"

## When to Use This Skill

**Use throughout the project lifecycle:**
1. After BA creates requirements → Initialize RTM
2. After each implementation phase → Update implementation status
3. Before QA begins → Verify coverage
4. Before release → Final traceability check

**Trigger phrases:**
- "Track requirements", "traceability matrix", "requirements coverage"
- "What's not implemented?", "what's missing?"
- "Are all requirements done?"

## The Requirements Traceability Matrix (RTM)

The RTM is a living document that tracks each requirement through:

```
REQUIREMENT → DESIGN → IMPLEMENTATION → TEST → VALIDATION
   REQ-001      ✓           ✓            ✓         ✓     = Ready
   REQ-002      ✓           ✓            ✗         ✗     = BLOCKED (no test)
   REQ-003      ✓           ✗            ✗         ✗     = BLOCKED (not implemented)
```

### RTM Template

```markdown
# Requirements Traceability Matrix

**Project:** {{projectName}}
**Last Updated:** {{date}}
**Coverage:** {{implemented}}/{{total}} ({{percentage}}%)

## Summary

| Status | Count | Percentage |
|--------|-------|------------|
| ✅ Complete (Implemented + Tested + Validated) | X | X% |
| 🔨 Implemented (Needs Testing) | X | X% |
| ⚠️ Designed (Needs Implementation) | X | X% |
| ❌ Not Started | X | X% |
| 🚫 Descoped | X | X% |

## Blockers (Must Fix Before Release)

| REQ-ID | Description | Missing | Owner |
|--------|-------------|---------|-------|
| REQ-003 | Export as CSV | Implementation | Developer |
| REQ-007 | Dark mode toggle | Test case | QA |

## Full Traceability Matrix

| REQ-ID | Priority | Description | Design | Impl | Test | Valid | Status | Notes |
|--------|----------|-------------|--------|------|------|-------|--------|-------|
| REQ-001 | Must | User signup with email | [US-001] | ✅ auth/signup.ts:45 | ✅ TC-001 | ✅ | Complete | |
| REQ-002 | Must | Password min 8 chars | [US-001] | ✅ auth/validate.ts:12 | ✅ TC-002 | ✅ | Complete | |
| REQ-003 | Must | Export data as CSV | [US-005] | ❌ | ❌ | ❌ | **BLOCKED** | Not implemented |
| REQ-004 | Should | Dark mode | [US-008] | ✅ theme/toggle.tsx | ❌ | ❌ | Needs Test | Missing test case |
| REQ-005 | Could | Social login | [US-002] | 🚫 | 🚫 | 🚫 | Descoped | Moved to v2 |

## Legend

- ✅ Complete
- ❌ Missing / Not Done
- 🔨 In Progress
- 🚫 Descoped / Out of Scope
- ⚠️ At Risk

## Traceability by User Story

### US-001: User Registration
| REQ-ID | Description | Status |
|--------|-------------|--------|
| REQ-001 | User signup with email | ✅ |
| REQ-002 | Password min 8 chars | ✅ |
| REQ-006 | Email verification | ✅ |

### US-005: Data Export
| REQ-ID | Description | Status |
|--------|-------------|--------|
| REQ-003 | Export as CSV | ❌ **BLOCKED** |
| REQ-012 | Export as PDF | ❌ **BLOCKED** |

## Change Log

| Date | Change | By |
|------|--------|-----|
| 2024-01-20 | REQ-005 descoped to v2 | Product Owner |
| 2024-01-18 | REQ-001 through REQ-010 implemented | Developer |
| 2024-01-15 | Initial RTM created | BA |
```

## Process: Maintaining the RTM

### Phase 1: Initialize (After Requirements)

When BA completes requirements:

```markdown
## RTM Initialization Checklist

- [ ] All REQ-XXX from Requirements Catalogue added to RTM
- [ ] All US-XXX from User Stories linked to requirements
- [ ] Priority (Must/Should/Could) captured
- [ ] Initial status set to "Not Started"
- [ ] RTM saved to docs/traceability/RTM.md
```

### Phase 2: Design Traceability

When designers complete work:

```markdown
## Design Traceability Update

For each requirement, link to design artifacts:
- REQ-001 → Wireframe: ux/wireframes/signup.png
- REQ-001 → User Flow: ux/flows/registration.md
- REQ-004 → UI Spec: ui/specs/theme-toggle.md
```

### Phase 3: Implementation Traceability

When developer implements a requirement:

```markdown
## Implementation Sign-Off

**REQ-ID:** REQ-001
**Description:** User signup with email
**Implemented:** ✅ Yes
**Location:** src/auth/signup.ts:45-120
**Commit:** abc123
**Developer Notes:** Implemented with email validation, rate limiting

[ ] I confirm this requirement is fully implemented per the acceptance criteria.
```

### Phase 4: Test Traceability

When QA creates/runs tests:

```markdown
## Test Coverage

**REQ-ID:** REQ-001
**Test Case:** TC-001
**Test Location:** tests/auth/signup.test.ts
**Test Type:** Integration
**Last Run:** 2024-01-20
**Result:** PASS

[ ] I confirm this requirement has adequate test coverage.
```

### Phase 5: Validation Traceability

When BA validates during BAT:

```markdown
## Business Validation

**REQ-ID:** REQ-001
**Validated By:** business-analyst
**Date:** 2024-01-22
**Result:** PASS
**Notes:** Signup flow works as expected, email received within 30 seconds.

[ ] I confirm this requirement meets the acceptance criteria from a user perspective.
```

## Coverage Reports

### Pre-Implementation Coverage Report

Run before development begins:

```markdown
# Pre-Implementation Coverage Report

**Date:** {{date}}
**Total Requirements:** 50
**Must-Have:** 25
**Should-Have:** 15
**Could-Have:** 10

## Requirements Ready for Implementation

All 50 requirements have:
- [ ] Clear acceptance criteria
- [ ] Linked user story
- [ ] Design artifacts (if UI-related)

## Blockers
- REQ-023: Missing acceptance criteria (assigned to BA)
- REQ-034: Design not complete (assigned to UX)
```

### Post-Implementation Coverage Report

Run after development, before QA:

```markdown
# Implementation Coverage Report

**Date:** {{date}}
**Total Requirements:** 50
**Implemented:** 45 (90%)
**Not Implemented:** 5 (10%)

## ❌ NOT IMPLEMENTED (Blockers)

| REQ-ID | Priority | Description | Reason |
|--------|----------|-------------|--------|
| REQ-003 | Must | Export CSV | Developer ran out of time |
| REQ-007 | Must | Dark mode | Waiting on design |
| REQ-012 | Should | PDF export | Descoped? (needs confirmation) |
| REQ-028 | Could | Keyboard shortcuts | Low priority |
| REQ-041 | Could | Animation | Low priority |

## ⚠️ ACTION REQUIRED

**Must-Have not implemented: 2**
- REQ-003: Export CSV → MUST implement before release
- REQ-007: Dark mode → MUST implement before release

**Recommendation:** BLOCK QA until Must-Have requirements implemented.
```

### Pre-Release Coverage Report

Run before release:

```markdown
# Pre-Release Traceability Report

**Date:** {{date}}
**Release Version:** 1.0.0

## Summary

| Metric | Value | Status |
|--------|-------|--------|
| Total Requirements | 50 | |
| Implemented | 48 | ✅ |
| Tested | 48 | ✅ |
| Validated | 48 | ✅ |
| Descoped | 2 | ✅ (approved) |
| Missing | 0 | ✅ |

## Gate Status: ✅ PASS

All Must-Have and Should-Have requirements are:
- ✅ Implemented
- ✅ Tested
- ✅ Validated

## Descoped Items (Approved)

| REQ-ID | Description | Reason | Approved By |
|--------|-------------|--------|-------------|
| REQ-028 | Keyboard shortcuts | V2 feature | Product Owner |
| REQ-041 | Animation effects | V2 feature | Product Owner |

## Release Recommendation

✅ **APPROVED FOR RELEASE**

All requirements are accounted for. Proceed to deployment.
```

## Gate: Requirements Coverage Gate

This gate runs **after Implementation, before QA**.

### Pass Criteria

```markdown
## Requirements Coverage Gate

**Status:** PASS / FAIL

### Must-Have Requirements (Priority: Must)
- Total: X
- Implemented: X
- Coverage: X%
- **Required: 100%**
- **Result:** PASS / FAIL

### Should-Have Requirements (Priority: Should)
- Total: X
- Implemented: X
- Coverage: X%
- **Required: 90%**
- **Result:** PASS / FAIL

### Overall Gate
- [ ] All Must-Have requirements implemented
- [ ] 90%+ of Should-Have requirements implemented
- [ ] All implemented requirements have test cases planned
- [ ] No requirement marked "Unknown" or "TBD"

**Gate Result:** PASS / FAIL
```

### Fail Actions

If gate fails:

1. **List all missing requirements** with owners
2. **Estimate effort** to complete
3. **Decision required:**
   - Implement missing requirements (delay release)
   - Descope requirements (requires Product Owner approval)
   - Accept risk (requires stakeholder sign-off)

## Integration with Other Skills

### Business Analyst
- Creates requirements with unique IDs
- Links requirements to user stories
- Validates requirements during BAT
- Updates RTM validation status

### Fullstack Developer
- Signs off on each requirement when implemented
- Provides file/function references
- Updates RTM implementation status

### QA Engineer
- Creates test cases for each requirement
- Links test cases to requirements
- Updates RTM test status

### Project Orchestrator
- Invokes requirements-tracker at each phase
- Enforces Requirements Coverage Gate
- Blocks release if requirements missing

## Anti-Patterns

| Anti-Pattern | Problem | Correction |
|--------------|---------|------------|
| RTM as afterthought | Created after implementation | Initialize RTM immediately after requirements |
| No implementation sign-off | "I think I did that one" | Require explicit sign-off per requirement |
| Testing code, not requirements | QA tests what exists | QA tests against requirements list |
| Descoping without approval | Features silently dropped | Require Product Owner approval |
| Stale RTM | Not updated regularly | Update at each phase transition |
| No file references | "It's in there somewhere" | Require specific file:line references |

## Output Location

```
docs/
└── traceability/
    ├── RTM.md                          # Requirements Traceability Matrix
    ├── COVERAGE-IMPLEMENTATION.md       # Post-implementation report
    ├── COVERAGE-QA.md                   # Post-QA report
    └── COVERAGE-RELEASE.md              # Pre-release report
```

## Workflow Integration

```
[BUSINESS ANALYST] → Creates requirements
        ↓
[REQUIREMENTS TRACKER] ← Initialize RTM
        ↓
[DESIGN PHASE] → Update RTM with design links
        ↓
[IMPLEMENTATION] → Developer signs off each REQ
        ↓
[REQUIREMENTS TRACKER] ← Generate coverage report
        ↓
[GATE: Requirements Coverage] ← Block if Must-Have missing
        ↓
[QA] → Tests against requirements, updates RTM
        ↓
[BAT] → BA validates each requirement
        ↓
[REQUIREMENTS TRACKER] ← Final traceability report
        ↓
[RELEASE]
```

## Quick Commands

```markdown
## Check Coverage
"Show me requirements coverage" → Generate coverage report

## Find Missing
"What requirements are not implemented?" → List gaps

## Update Status
"Mark REQ-003 as implemented in auth/export.ts:45" → Update RTM

## Descope
"Descope REQ-028 to v2" → Mark as descoped (requires approval)

## Validate
"Validate REQ-001" → Mark as validated in RTM
```
