# Requirements Traceability Matrix (RTM)

## Project: {{PROJECT_NAME}}
## Last Updated: {{LAST_UPDATED}}

---

## Coverage Summary

| Category | Total | Designed | Implemented | Tested | Validated |
|----------|-------|----------|-------------|--------|-----------|
| Must-Have | {{MUST_TOTAL}} | {{MUST_DESIGNED}} | {{MUST_IMPL}} | {{MUST_TESTED}} | {{MUST_VALID}} |
| Should-Have | {{SHOULD_TOTAL}} | {{SHOULD_DESIGNED}} | {{SHOULD_IMPL}} | {{SHOULD_TESTED}} | {{SHOULD_VALID}} |
| Could-Have | {{COULD_TOTAL}} | {{COULD_DESIGNED}} | {{COULD_IMPL}} | {{COULD_TESTED}} | {{COULD_VALID}} |
| **Total** | **{{TOTAL}}** | **{{DESIGNED}}** | **{{IMPL}}** | **{{TESTED}}** | **{{VALID}}** |

### Coverage Percentages
- **Design Coverage**: {{DESIGN_PCT}}%
- **Implementation Coverage**: {{IMPL_PCT}}%
- **Test Coverage**: {{TEST_PCT}}%
- **Validation Coverage**: {{VALID_PCT}}%

---

## Full Traceability Matrix

| REQ ID | Feature | Priority | Design | Implementation | Test Case | Test Result | BA Validated |
|--------|---------|----------|--------|----------------|-----------|-------------|--------------|
| REQ-001 | F-001 | Must | ✅ | ✅ `file:line` | TC-001 | ✅ Pass | ✅ |
| REQ-002 | F-002 | Must | ✅ | ✅ `file:line` | TC-002 | ✅ Pass | ✅ |
| REQ-003 | F-003 | Must | ✅ | 🔄 In Progress | TC-003 | ⏳ Pending | ⏳ |
| REQ-004 | F-004 | Should | ✅ | ⏳ Pending | TC-004 | ⏳ Pending | ⏳ |
| REQ-005 | F-005 | Could | ⏳ | ⏳ Pending | - | - | - |

---

## Detailed Traceability

### REQ-001: {{REQUIREMENT_NAME}}

| Field | Value |
|-------|-------|
| **Feature** | F-001: {{FEATURE_NAME}} |
| **Priority** | Must |
| **User Story** | US-001 |

**Design Reference**:
- Document: `docs/design/USER-FLOWS.md`
- Section: {{SECTION}}

**Implementation Reference**:
- File: `{{FILE_PATH}}`
- Line: {{LINE_NUMBER}}
- Function/Component: `{{FUNCTION_NAME}}`
- Commit: {{COMMIT_HASH}}

**Test Reference**:
- Test Case: TC-001
- Test File: `{{TEST_FILE_PATH}}`
- Last Run: {{TEST_DATE}}
- Result: Pass / Fail

**Validation**:
- Validated By: {{VALIDATOR}}
- Date: {{VALIDATION_DATE}}
- Notes: {{VALIDATION_NOTES}}

---

### REQ-002: {{REQUIREMENT_NAME}}

| Field | Value |
|-------|-------|
| **Feature** | F-002 |
| **Priority** | Must |

**Implementation Reference**:
- File: `{{FILE_PATH}}`
- Line: {{LINE_NUMBER}}

**Test Reference**:
- Test Case: TC-002

---

## Gap Analysis

### Missing Implementation
| REQ ID | Feature | Priority | Blocker |
|--------|---------|----------|---------|
| REQ-xxx | F-xxx | Must | {{BLOCKER}} |

### Missing Tests
| REQ ID | Feature | Priority | Reason |
|--------|---------|----------|--------|
| REQ-xxx | F-xxx | Should | {{REASON}} |

### Missing Validation
| REQ ID | Feature | Priority | Status |
|--------|---------|----------|--------|
| REQ-xxx | F-xxx | Must | Awaiting BA |

---

## Gate Readiness

### Gate 4 (Implementation) Check
- [ ] 100% Must-Have implemented
- [ ] 90%+ Should-Have implemented
- [ ] All implementations have file:line reference

### Gate 5 (QA) Check
- [ ] All Must-Have have test cases
- [ ] All tests passing
- [ ] No critical defects

### Gate 6 (BAT) Check
- [ ] All Must-Have validated by BA
- [ ] Acceptance criteria verified
- [ ] User stories completable

---

## Change Log

| Date | Change | Author |
|------|--------|--------|
| {{DATE}} | Initial RTM creation | {{AUTHOR}} |
| {{DATE}} | Updated implementation refs | {{AUTHOR}} |
