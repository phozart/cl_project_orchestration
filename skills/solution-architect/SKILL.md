---
name: solution-architect
description: This skill should be used when the user asks to "design the architecture", "create system design", "write ADRs", "choose the tech stack", or needs technical architecture documentation. Designs architecture supporting all requirements with documented decisions.
---

# Solution Architect

Design architecture that supports ALL requirements. Document every decision.

## Rules

1. VERIFY every REQ-XXX can be implemented with proposed architecture.
2. DOCUMENT every technology decision in an ADR with tradeoffs.
3. BLOCK if requirements conflict or are technically impossible. Send back to BA.
4. NO TBDs in architecture docs. If unknown, research first.
5. DEFINE data model, API contracts, security model completely.

## References

| File | Content |
|------|---------|
| `references/adr-template.md` | ADR format and examples |
| `references/system-design-checklist.md` | What must be documented |

---

## Input Validation

REQUIRED from BA:
- [ ] Requirements Catalogue (REQ-XXX with priorities)
- [ ] User Stories (US-XXX)
- [ ] BRD with constraints

VERIFY before designing:
- [ ] All requirements have testable criteria
- [ ] Performance requirements quantified (not "fast")
- [ ] Security requirements specified
- [ ] Scalability requirements clear

IF requirements are vague → STOP. Send back to BA.

---

## Process

```
VALIDATE REQUIREMENTS → DESIGN → DOCUMENT → REVIEW
```

---

## Artifacts

### 1. System Design Document

REQUIRED sections:
- [ ] Overview (high-level description)
- [ ] Architecture diagram (components, relationships)
- [ ] Component specifications (responsibility, tech, interfaces)
- [ ] Class diagram (code structure, inheritance, interfaces)
- [ ] Data model (entities, fields, relationships)
- [ ] API contracts (all endpoints defined)
- [ ] Security architecture (auth, authz, encryption)
- [ ] Deployment architecture (environments, CI/CD)

### Class Diagram (Mermaid)

GENERATE class diagram showing code structure:

```mermaid
classDiagram
    class User {
        +string id
        +string email
        +string passwordHash
        +UserRole role
        +Date createdAt
        +validatePassword(password) bool
    }

    class UserService {
        -UserRepository repository
        +createUser(dto) User
        +getUserById(id) User
        +updateUser(id, dto) User
        +deleteUser(id) void
    }

    class UserRepository {
        +create(user) User
        +findById(id) User
        +update(id, data) User
        +delete(id) void
    }

    class UserController {
        -UserService service
        +getUsers() Response
        +getUserById(id) Response
        +createUser(body) Response
        +updateUser(id, body) Response
        +deleteUser(id) Response
    }

    UserController --> UserService
    UserService --> UserRepository
    UserRepository --> User
```

RULES:
- Class names MUST match implementation exactly
- Method names MUST match API operationIds
- Properties MUST match TYPE-CONTRACTS.ts

### 2. Tech Stack Specification

| Layer | Technology | Rationale |
|-------|------------|-----------|
| Frontend | [Framework] | [Why] |
| Backend | [Framework] | [Why] |
| Database | [Engine] | [Why] |
| Cache | [Engine] | [Why] |
| Hosting | [Platform] | [Why] |

### 3. Architecture Decision Records (ADRs)

For EVERY significant technology choice:

```markdown
# ADR-XXX: [Decision Title]

## Status: Proposed | Accepted | Deprecated

## Context
[Why this decision? What problem?]

## Decision
[What we decided]

## Consequences
- Positive: [Benefits]
- Negative: [Tradeoffs]
- Risks: [With mitigations]
```

---

## Validation Checklist

Before handoff, verify ALL:

- [ ] Every REQ-XXX mapped to architecture component
- [ ] Data model supports all CRUD operations
- [ ] API contracts cover all user stories
- [ ] Security model addresses auth and authz
- [ ] Scalability approach documented
- [ ] Deployment strategy defined
- [ ] **NO "TBD" items remaining**

IF any TBD remains → NOT READY. Complete before handoff.

---

## Feedback to Upstream

| Issue Found | Route To |
|-------------|----------|
| Requirements conflict | business-analyst |
| Performance impossible | BA + product-design |
| Security concerns with feature | product-design |
| Scope too ambitious for timeline | product-design |
| Missing data requirements | business-analyst |

---

## Output

```
docs/architecture/
├── SYSTEM-DESIGN.md
├── TECH-STACK.md
└── ADR/
    ├── ADR-001-database-choice.md
    ├── ADR-002-auth-strategy.md
    └── ...
```

ADR naming: `ADR-XXX-short-description.md`

---

## Templates

| Template | Target |
|----------|--------|
| `templates/docs/architecture/SYSTEM-DESIGN.template.md` | `docs/architecture/SYSTEM-DESIGN.md` |
| `templates/docs/architecture/ADR/ADR-001.template.md` | `docs/architecture/ADR/ADR-XXX.md` |
