# User Stories: {{PROJECT_NAME}}

## Overview
| Metric | Count |
|--------|-------|
| Total Stories | {{TOTAL}} |
| Completed | {{COMPLETED}} |
| In Progress | {{IN_PROGRESS}} |
| Pending | {{PENDING}} |

---

## Epic: {{EPIC_NAME}}

### US-001: {{STORY_TITLE}}

**As a** {{USER_ROLE}}
**I want to** {{ACTION}}
**So that** {{BENEFIT}}

| Field | Value |
|-------|-------|
| **Priority** | Must / Should / Could |
| **Points** | {{STORY_POINTS}} |
| **Sprint** | {{SPRINT}} |
| **Status** | Pending / In Progress / Done |
| **Requirement** | REQ-xxx |
| **Feature** | F-xxx |

**Acceptance Criteria**:
- [ ] **Given** {{CONTEXT}}, **when** {{ACTION}}, **then** {{RESULT}}
- [ ] **Given** {{CONTEXT}}, **when** {{ACTION}}, **then** {{RESULT}}
- [ ] **Given** {{CONTEXT}}, **when** {{ACTION}}, **then** {{RESULT}}

**Notes**:
{{ADDITIONAL_NOTES}}

---

### US-002: {{STORY_TITLE}}

**As a** {{USER_ROLE}}
**I want to** {{ACTION}}
**So that** {{BENEFIT}}

| Field | Value |
|-------|-------|
| **Priority** | Must / Should / Could |
| **Status** | Pending |
| **Requirement** | REQ-xxx |

**Acceptance Criteria**:
- [ ] {{CRITERION}}

---

## Epic: {{EPIC_2_NAME}}

### US-003: {{STORY_TITLE}}

**As a** {{USER_ROLE}}
**I want to** {{ACTION}}
**So that** {{BENEFIT}}

**Acceptance Criteria**:
- [ ] {{CRITERION}}

---

## Story Map

```
                    User Journey
    ┌─────────┬─────────┬─────────┬─────────┐
    │ Discover│  Sign Up │  Use    │ Manage  │
    ├─────────┼─────────┼─────────┼─────────┤
MVP │ US-001  │ US-002  │ US-005  │ US-010  │
    │         │ US-003  │ US-006  │         │
    ├─────────┼─────────┼─────────┼─────────┤
v2  │         │ US-004  │ US-007  │ US-011  │
    │         │         │ US-008  │ US-012  │
    └─────────┴─────────┴─────────┴─────────┘
```

---

## Story Status Summary

| Epic | Total | Done | In Progress | Pending |
|------|-------|------|-------------|---------|
| {{EPIC_1}} | {{COUNT}} | {{DONE}} | {{IP}} | {{PENDING}} |
| {{EPIC_2}} | {{COUNT}} | {{DONE}} | {{IP}} | {{PENDING}} |

---

## Definition of Ready

A story is ready for development when:
- [ ] Acceptance criteria are defined
- [ ] Dependencies identified
- [ ] Estimated (story points)
- [ ] Fits in one sprint

## Definition of Done

A story is done when:
- [ ] All acceptance criteria met
- [ ] Code reviewed
- [ ] Tests written and passing
- [ ] Documentation updated
- [ ] Product owner accepted
