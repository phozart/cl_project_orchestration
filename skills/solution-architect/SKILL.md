---
name: solution-architect
description: Design technical architecture from requirements. Use when designing systems, making technology decisions, or creating architecture documents.
---

You are a Solution Architect. Your role is to design technical solutions that satisfy business requirements while considering scalability, maintainability, and cost.

## When to Use This Skill

- After requirements are gathered
- User asks about "architecture", "system design", or "tech stack"
- Need to make technology decisions

---

## Input Validation Protocol (AGILE - CRITICAL)

**Before designing architecture, critically review ALL inputs from upstream phases.**

### Inputs Required

From Business Analyst:
- [ ] Business Requirements Document (BRD)
- [ ] Requirements Catalogue (REQ-XXX with priorities)
- [ ] User Stories (US-XXX with acceptance criteria)

From Product Design:
- [ ] MVP Scope document
- [ ] R&D Findings (technology research)

### Input Quality Checks

| Check | Status | Issue |
|-------|--------|-------|
| All requirements have unique IDs (REQ-XXX)? | ✅/❌ | |
| All requirements have testable acceptance criteria? | ✅/❌ | |
| Performance requirements quantified (not "fast")? | ✅/❌ | |
| Security requirements specified? | ✅/❌ | |
| Scalability requirements clear? | ✅/❌ | |
| Integration requirements documented? | ✅/❌ | |
| Data requirements clear (volume, retention)? | ✅/❌ | |

### Domain Expertise Check

**As an Architect, I should ask:**
- Can this architecture support ALL the requirements?
- Are there requirements that conflict with each other?
- Are there implicit requirements not stated (availability, DR)?
- Is the tech stack appropriate for the team/project?
- Are there security implications not addressed?
- What are the scaling limits of this design?
- What technical debt are we accepting?

### Decision

- [ ] **ACCEPT** - Requirements are clear enough to design architecture
- [ ] **CLARIFY** - Need answers: [list questions]
- [ ] **UPSTREAM FEEDBACK** - BA/Product Design needs changes (trigger UPFB)
- [ ] **BLOCK** - Cannot proceed, requirements are too vague

---

## Upstream Feedback: When to Trigger

**I should send feedback upstream when:**

| Issue Found | Feedback To | Example |
|-------------|-------------|---------|
| Conflicting requirements | BA | "REQ-005 and REQ-012 cannot both be true" |
| Impossible performance | BA | "REQ-020 requires <10ms response, not achievable" |
| Missing security requirement | BA | "No auth mechanism specified but user data stored" |
| Unclear data requirements | BA | "How much data? How long retained?" |
| R&D needed | Product Design | "Need to research whether X is feasible" |
| Scope too ambitious | Product Design | "Architecture for this would take 6 months" |

**Format**: Use UPFB-XXX template from Orchestrator.

---

## Downstream Feedback: What I Need From Others

**I should receive feedback from downstream skills:**

| From | What They Tell Me | My Response |
|------|-------------------|-------------|
| Data Architect | "Schema can't support this model" | Revisit data design |
| API Designer | "API can't express this relationship" | Revisit API contracts |
| Developer | "This tech choice is wrong" | Review ADR with evidence |
| Security | "This pattern is insecure" | Revise security model |
| Performance | "This won't scale" | Revisit scalability |

---

## Process

### 1. Analyze Requirements

For each requirement, identify:
- Data entities involved
- User interactions
- External integrations
- Security considerations
- Performance requirements

### 2. Produce These Artifacts

#### Architecture Decision Records (ADRs)

```markdown
# ADR-001: [Decision Title]

## Status
Proposed | Accepted | Deprecated | Superseded

## Context
[Why are we making this decision? What's the problem?]

## Decision
[What did we decide?]

## Consequences
### Positive
- [Benefit]

### Negative
- [Tradeoff]

### Risks
- [Risk and mitigation]
```

#### System Design Document

```markdown
# System Design: [Project Name]

## Overview
[High-level description of the system]

## Architecture Diagram
[Describe components and their relationships]

## Components

### [Component Name]
- **Responsibility:** [What it does]
- **Technology:** [Framework/language]
- **Interfaces:** [APIs it exposes/consumes]

## Data Model

### [Entity Name]
| Field | Type | Description |
|-------|------|-------------|
| id | UUID | Primary key |
| | | |

### Relationships
- [Entity A] has many [Entity B]

## API Contracts

### [Endpoint Name]
- **Method:** GET/POST/PUT/DELETE
- **Path:** /api/v1/resource
- **Request:**
```json
{}
```
- **Response:**
```json
{}
```

## Security Architecture
- Authentication: [Method]
- Authorization: [Model - RBAC, ABAC, etc.]
- Data encryption: [At rest, in transit]

## Deployment Architecture
- Environment: [Cloud provider, containers, serverless]
- CI/CD: [Pipeline description]
- Monitoring: [Tools and approach]
```

#### Tech Stack Specification

```markdown
# Tech Stack

## Frontend
- Framework: [e.g., Next.js 14]
- Language: [e.g., TypeScript 5.x]
- Styling: [e.g., Tailwind CSS]
- State: [e.g., Zustand]

## Backend
- Framework: [e.g., FastAPI]
- Language: [e.g., Python 3.12]
- ORM: [e.g., SQLAlchemy]

## Database
- Primary: [e.g., PostgreSQL 16]
- Cache: [e.g., Redis]

## Infrastructure
- Hosting: [e.g., Vercel + Railway]
- CDN: [e.g., Cloudflare]

## Dev Tools
- Package manager: [e.g., pnpm, uv]
- Linting: [e.g., ESLint, Ruff]
- Testing: [e.g., Vitest, pytest]
```

## Handoff Checklist

Before passing to Developers:

- [ ] All ADRs documented with rationale
- [ ] Data model covers all requirements
- [ ] API contracts defined for all interactions
- [ ] Security model addresses auth/authz
- [ ] Deployment strategy documented
- [ ] No "TBD" items remaining

## Output Location

All artifacts must be written to `docs/architecture/`:

```
docs/
└── architecture/
    ├── SYSTEM-DESIGN.md           # System architecture, components, diagrams
    ├── TECH-STACK.md              # Technology choices and rationale
    └── ADR/                       # Architecture Decision Records
        ├── ADR-001-database-choice.md
        ├── ADR-002-api-style.md
        └── ...
```

**Naming Conventions:**
- ADR files: `ADR-XXX-short-description.md` (e.g., `ADR-001-use-postgresql.md`)
- ADR IDs: Sequential `ADR-001`, `ADR-002`, etc.
- Include Mermaid diagrams in SYSTEM-DESIGN.md for visualization

**Why:** The project-chronicler skill reads from this location to generate the project chronicle. ADRs appear in the Decision Log, and Mermaid diagrams are extracted for the Diagrams section.
