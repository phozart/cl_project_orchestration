# MVP Scope: Plugin Scaffolding System

## Scope Status: LOCKED
**Locked Date**: 2026-01-02
**Decision Maker**: User (Plugin Author)

---

## In Scope (MVP v1)

### Must-Have Features (28)

#### Directory Structure
- [x] F-001: Templates root directory
- [x] F-002: Document templates subdirectory (all 12 folders)

#### Core Document Templates (18 templates)
| ID | Template | Location |
|----|----------|----------|
| F-005 | PROJECT-BRIEF | templates/docs/discovery/ |
| F-006 | PRODUCT-INTAKE | templates/ |
| F-008 | PROJECT-STATUS | templates/ |
| F-009 | PRODUCT-VISION | templates/docs/product/ |
| F-010 | FEATURE-INVENTORY | templates/docs/product/ |
| F-011 | MVP-SCOPE | templates/docs/product/ |
| F-013 | BRD | templates/docs/requirements/ |
| F-014 | REQUIREMENTS-CATALOGUE | templates/docs/requirements/ |
| F-015 | USER-STORIES | templates/docs/requirements/ |
| F-016 | RTM | templates/docs/traceability/ |
| F-017 | SYSTEM-DESIGN | templates/docs/architecture/ |
| F-018 | ADR | templates/docs/architecture/ADR/ |
| F-020 | DATA-MODEL | templates/docs/data/ |
| F-021 | API-SPEC | templates/docs/api/ |
| F-027 | TEST-PLAN | templates/docs/qa/ |
| F-028 | TEST-CASES | templates/docs/qa/ |
| F-030 | SECURITY-REVIEW | templates/docs/security/ |
| F-032 | ENV-EXAMPLE | templates/ |

#### Infrastructure Template
- [x] F-037: Docker Compose template

#### Automation
- [x] F-039: Scaffold docs script (creates full structure)

#### Documentation
- [x] F-042: Templates README
- [x] F-043: Skill integration guide

---

## Should-Have (v1.1)

| ID | Feature | Reason for Deferral |
|----|---------|---------------------|
| F-003 | Code templates subdirectory | After core docs work |
| F-004 | Examples subdirectory | After templates verified |
| F-012 | USER-JOURNEYS template | Less critical |
| F-019 | TECH-STACK template | Can generate on demand |
| F-022 | DATA-DICTIONARY template | Less common need |
| F-023 | USER-FLOWS template | Can generate on demand |
| F-024 | WIREFRAMES template | Can generate on demand |
| F-025 | UI-SPEC template | Can generate on demand |
| F-029 | DEFECT-LOG template | Less common need |
| F-031 | INFRASTRUCTURE-SETUP template | Can use README |
| F-033 | PRIVACY-POLICY template | Legal varies by jurisdiction |
| F-034 | TERMS-OF-SERVICE template | Legal varies by jurisdiction |
| F-035 | Next.js template | After core docs |
| F-038 | Dockerfile template | After core docs |
| F-040 | Template copy helper | Nice to have |
| F-044 | Update existing skills | Incremental improvement |
| F-045 | Filled PROJECT-BRIEF example | After templates verified |
| F-046 | Filled BRD example | After templates verified |

---

## Out of Scope (v2+)

| ID | Feature | Reason |
|----|---------|--------|
| F-007 | MARKET-ANALYSIS template | Specialized use case |
| F-026 | DESIGN-SYSTEM template | Complex, varies greatly |
| F-036 | FastAPI template | After Next.js proven |
| F-041 | MCP Server | Complexity vs benefit unclear |
| F-047 | Complete project example | Large effort |

---

## MVP Success Criteria

### Functional Criteria
| Criterion | Metric | Status |
|-----------|--------|--------|
| Templates directory exists | `templates/` created | Pending |
| Core templates complete | 18 templates created | Pending |
| Scaffold script works | One command creates structure | Pending |
| README documents usage | Clear instructions | Pending |

### Efficiency Criteria
| Criterion | Metric | Status |
|-----------|--------|--------|
| Token reduction | 50%+ for scaffolding tasks | Pending |
| Time reduction | Minutes → Seconds | Pending |
| Consistency | Same structure every project | Pending |

### Quality Criteria
| Criterion | Metric | Status |
|-----------|--------|--------|
| Templates match skill outputs | Verified against skills | Pending |
| No breaking changes | Existing plugin works | Pending |
| Cross-platform | Works on macOS, Linux | Pending |

---

## Constraints Reminder

| Constraint | Requirement | How MVP Addresses |
|------------|-------------|-------------------|
| Token efficiency | Must reduce usage | Templates reduce generation |
| Speed | Faster than manual | Script automates creation |
| No external deps | Offline capable | Plain files only |
| Simple | Easy to maintain | Markdown + shell script |
| MIT compatible | Can distribute freely | All original content |

---

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| Templates drift from skills | Medium | Version together, review periodically |
| Script incompatibility | Low | Fallback: manual copy |
| Templates too rigid | Medium | Keep placeholders flexible |
| Overhead > savings | High | Measure token usage before/after |

---

## Definition of Done

MVP is complete when:
1. [ ] `templates/` directory structure created
2. [ ] All 18 Must-Have templates written
3. [ ] `scripts/scaffold-docs.sh` creates full structure
4. [ ] `templates/README.md` explains usage
5. [ ] Tested on at least one real project
6. [ ] Token usage measured (before/after comparison)
7. [ ] README.md updated with scaffolding section
