# Test Plan: {{PROJECT_NAME}}

## Document Control
| Field | Value |
|-------|-------|
| **Version** | 1.0 |
| **Status** | Draft / Active / Complete |
| **Author** | {{AUTHOR}} |
| **Date** | {{DATE}} |

---

## 1. Overview

### 1.1 Purpose
{{PURPOSE}}

### 1.2 Scope
**In Scope**:
- {{IN_SCOPE_1}}
- {{IN_SCOPE_2}}

**Out of Scope**:
- {{OUT_OF_SCOPE_1}}

### 1.3 Objectives
- Verify all requirements are implemented correctly
- Identify defects before production
- Ensure quality meets acceptance criteria

---

## 2. Test Strategy

### 2.1 Test Levels
| Level | Description | Responsibility |
|-------|-------------|----------------|
| Unit | Individual functions/components | Developer |
| Integration | Component interactions | Developer |
| System | End-to-end flows | QA |
| Acceptance | Business requirements | BA/QA |

### 2.2 Test Types
| Type | Purpose | Tools |
|------|---------|-------|
| Functional | Verify features work | {{TOOL}} |
| Performance | Load and response times | {{TOOL}} |
| Security | Vulnerability testing | {{TOOL}} |
| Accessibility | WCAG compliance | {{TOOL}} |
| Usability | User experience | Manual |

### 2.3 Test Approach
{{TEST_APPROACH}}

---

## 3. Test Environment

### 3.1 Environments
| Environment | Purpose | URL |
|-------------|---------|-----|
| Development | Developer testing | localhost |
| Staging | QA testing | {{STAGING_URL}} |
| Production | Live | {{PROD_URL}} |

### 3.2 Test Data
- Source: {{DATA_SOURCE}}
- Refresh: {{REFRESH_FREQUENCY}}
- PII handling: {{PII_APPROACH}}

---

## 4. Test Schedule

| Phase | Start | End | Status |
|-------|-------|-----|--------|
| Test Planning | {{DATE}} | {{DATE}} | ⏳ |
| Test Case Creation | {{DATE}} | {{DATE}} | ⏳ |
| Test Execution | {{DATE}} | {{DATE}} | ⏳ |
| Defect Resolution | {{DATE}} | {{DATE}} | ⏳ |
| Final Report | {{DATE}} | {{DATE}} | ⏳ |

---

## 5. Test Coverage

### 5.1 Requirements Coverage
| Priority | Total | Covered | Percentage |
|----------|-------|---------|------------|
| Must-Have | {{COUNT}} | {{COVERED}} | {{PCT}}% |
| Should-Have | {{COUNT}} | {{COVERED}} | {{PCT}}% |
| Could-Have | {{COUNT}} | {{COVERED}} | {{PCT}}% |

### 5.2 Feature Coverage
| Feature | Test Cases | Status |
|---------|------------|--------|
| F-001: {{Feature}} | TC-001, TC-002 | ⏳ |
| F-002: {{Feature}} | TC-003 | ⏳ |

---

## 6. Entry & Exit Criteria

### 6.1 Entry Criteria
- [ ] Requirements approved
- [ ] Test environment ready
- [ ] Test data available
- [ ] Build deployed to staging

### 6.2 Exit Criteria
- [ ] All Must-Have requirements tested
- [ ] No Critical defects open
- [ ] No High defects open (or approved exceptions)
- [ ] Test coverage > 80%
- [ ] Performance targets met

---

## 7. Defect Management

### 7.1 Severity Levels
| Severity | Description | Response |
|----------|-------------|----------|
| Critical | System unusable | Immediate |
| High | Major feature broken | Same day |
| Medium | Feature degraded | Next sprint |
| Low | Minor issue | Backlog |

### 7.2 Defect Workflow
```
New → Assigned → In Progress → Fixed → Verified → Closed
                     ↓
                 Reopened
```

---

## 8. Risks & Mitigations

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Environment unavailable | Medium | High | Backup env |
| Test data issues | Low | Medium | Data scripts |
| Resource constraints | Medium | Medium | Prioritize |

---

## 9. Deliverables

- [ ] Test Plan (this document)
- [ ] Test Cases (TEST-CASES.md)
- [ ] Test Results (TEST-RESULTS.md)
- [ ] Defect Log (DEFECT-LOG.md)
- [ ] Test Summary Report

---

## 10. Approvals

| Role | Name | Signature | Date |
|------|------|-----------|------|
| QA Lead | {{NAME}} | | |
| Dev Lead | {{NAME}} | | |
| Product Owner | {{NAME}} | | |
