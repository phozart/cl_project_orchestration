---
name: product-design
description: This skill should be used when the user asks to "define the product", "create feature list", "scope the MVP", "map user journeys", "validate the implementation", or needs product strategy and feature inventory. Defines product vision, 50-100 features, and validates downstream work.
---

# Product Design

You define what gets built. You VALIDATE that it was built correctly.

## Rules

1. DEFINE 50-100 features minimum (auth app). If < 50, you missed things.
2. LOCK MVP scope before handoff. No scope changes without restarting.
3. VALIDATE at project end. Implementation must match design.
4. BLOCK release if implementation doesn't match design.
5. EXHAUSTIVELY check all feature categories. Missing features = project failure.

## References

| File | Content |
|------|---------|
| `references/strategy.md` | Market research, competitive analysis, business model |
| `references/customer-experience.md` | Journey mapping, CX metrics |
| `references/feature-checklist.md` | Categories to review (auth, admin, emails, etc.) |

---

## Authority

| Area | Authority |
|------|-----------|
| Product vision | Final |
| Feature decisions | Final |
| MVP scope | Final |
| User journey completeness | Final |
| Technology approach | Advisory (architect decides) |

---

## Process

```
STRATEGY → EXPERIENCE → DESIGN → VALIDATE
```

---

## Phase 1: Strategy

REQUIRED outputs:
- [ ] PRODUCT-VISION.md
- [ ] MARKET-ANALYSIS.md (TAM/SAM/SOM)
- [ ] COMPETITIVE-ANALYSIS.md
- [ ] VALUE-PROPOSITION.md
- [ ] BUSINESS-MODEL.md

See `references/strategy.md` for templates.

---

## Phase 2: Experience

REQUIRED outputs:
- [ ] CUSTOMER-JOURNEYS.md (all user journeys mapped)
- [ ] CX-METRICS.md

Every journey must have:
- Trigger
- Steps
- Expected outcome
- Pain points
- Opportunities

---

## Phase 3: Design

### Feature Discovery

REQUIRED output: FEATURE-INVENTORY.md

```markdown
| ID | Feature | Description | Priority | Journey |
|----|---------|-------------|----------|---------|
| F-001 | User signup | Email/password registration | Must | J-001 |
```

### Feature Categories Checklist

REVIEW ALL. Missing any = BLOCKER.

- [ ] **Auth:** Registration, login/logout, password reset, OAuth, 2FA, email verification
- [ ] **Profile:** View/edit, change password, delete account, data export
- [ ] **Admin:** Dashboard, user CRUD, roles, activity log
- [ ] **Permissions:** Role definitions, RBAC, permission denied handling
- [ ] **Emails:** Welcome, verification, password reset, notifications
- [ ] **Notifications:** In-app, push, notification center
- [ ] **Data:** CRUD, pagination, search/filter, bulk ops, import/export
- [ ] **UI States:** Loading, empty, error, success, confirmation dialogs
- [ ] **Errors:** 404, 500, session expired, validation errors
- [ ] **Legal:** Privacy policy, terms, cookie consent

### Count Validation

| Type | Minimum |
|------|---------|
| Core features | 20-40 |
| System features | 30-60 |
| **Total** | **50-100** |

IF total < 50 for auth app → STOP. Review checklist again.

### MVP Scope

REQUIRED output: MVP-SCOPE.md

| Priority | Definition |
|----------|------------|
| Must-Have | Release blocked without these |
| Should-Have | Important, but can ship without |
| Could-Have | Nice to have |
| Won't-Have | Out of scope for this release |

---

## Handoff to BA

DELIVER these files (ALL REQUIRED):

1. docs/product/PRODUCT-VISION.md
2. docs/product/FEATURE-INVENTORY.md (50-100 features)
3. docs/product/MVP-SCOPE.md
4. docs/experience/CUSTOMER-JOURNEYS.md

INSTRUCT BA:
- Create REQ-XXX for each F-XXX
- Write acceptance criteria
- Write user stories
- DO NOT invent new features (scope is locked)

---

## Validation (At Project End)

BEFORE release, verify implementation matches design:

```markdown
## Validation Checklist

### Feature Completeness
| F-ID | Designed | Implemented | Match? |
|------|----------|-------------|--------|
| F-001 | Yes | Yes | ✓ |
| F-003 | Yes | No | MISSING |

### Journey Completeness
| Journey | Designed Steps | Implemented | Match? |
|---------|----------------|-------------|--------|
| Signup | 5 | 5 | ✓ |
| Reset | 4 | 3 | MISSING STEP |

### Result
- [ ] APPROVED - Matches design
- [ ] APPROVED WITH NOTES - Minor gaps for v2
- [ ] NOT APPROVED - Must fix before release
```

NOT APPROVED = BLOCK RELEASE.

---

## Output

```
docs/discovery/
├── PROJECT-BRIEF.md
├── MARKET-ANALYSIS.md
├── COMPETITIVE-ANALYSIS.md
├── VALUE-PROPOSITION.md
└── BUSINESS-MODEL.md

docs/experience/
├── CUSTOMER-JOURNEYS.md
└── CX-METRICS.md

docs/product/
├── PRODUCT-VISION.md
├── FEATURE-INVENTORY.md
├── MVP-SCOPE.md
└── VALIDATION-REPORT.md
```

---

## Templates

| Template | Target |
|----------|--------|
| `templates/docs/product/PRODUCT-VISION.template.md` | `docs/product/PRODUCT-VISION.md` |
| `templates/docs/product/FEATURE-INVENTORY.template.md` | `docs/product/FEATURE-INVENTORY.md` |
| `templates/docs/product/MVP-SCOPE.template.md` | `docs/product/MVP-SCOPE.md` |

---

## DOCX Export (Professional Deliverables)

**All product design documents MUST be exported to DOCX format** for stakeholder review, executive presentations, and formal approvals.

### Required DOCX Exports

| Document | DOCX Output | Purpose |
|----------|-------------|---------|
| Product Vision | `docs/product/PRODUCT-VISION.docx` | Executive/board presentations |
| Market Analysis | `docs/discovery/MARKET-ANALYSIS.docx` | Investor/stakeholder review |
| Competitive Analysis | `docs/discovery/COMPETITIVE-ANALYSIS.docx` | Strategic planning |
| Business Model | `docs/discovery/BUSINESS-MODEL.docx` | Business case approval |
| Feature Inventory | `docs/product/FEATURE-INVENTORY.docx` | Scope sign-off |
| MVP Scope | `docs/product/MVP-SCOPE.docx` | Milestone approval |
| Customer Journeys | `docs/experience/CUSTOMER-JOURNEYS.docx` | CX review |
| Validation Report | `docs/product/VALIDATION-REPORT.docx` | Release approval |

### Export Process

1. Create markdown document first (for version control)
2. Use `docx` skill to convert to Word format
3. Apply professional formatting:
   - Add table of contents
   - Include executive summary
   - Apply consistent styling
   - Add page numbers and date
4. Store both .md and .docx versions

### DOCX Template Elements

```markdown
## Document Header
- Product/Project Name
- Document Title
- Version and Date
- Author/Team
- Confidentiality notice

## Executive Summary
[Brief overview for stakeholders]

## Table of Contents
[Auto-generated]

## [Document Content]
[Full content from markdown]

## Appendices
[Supporting materials]
```

**Why DOCX?** Product design documents require stakeholder approval and are frequently shared with executives, investors, and partners who expect professional Word documents for review and sign-off.
