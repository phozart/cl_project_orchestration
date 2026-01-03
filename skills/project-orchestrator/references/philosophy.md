# Project Orchestrator Philosophy

This document explains the WHY behind the orchestrator rules. The SKILL.md file contains the WHAT (commands). Read this for context, not instruction.

---

## Core Philosophy: Complete Systems, Not Half-Baked MVPs

**THE GOAL: Production-ready, fully working system in ONE proper cycle.**

### Anti-Pattern: 50-Iteration Death Spiral
```
❌ Build MVP → Deploy → Find gaps → Patch → Find more gaps → Patch → Repeat 50x
```

### Correct Pattern: Phased Completeness
```
✅ Phase 1: Complete foundation (auth, admin, core feature) → WORKING & TESTABLE
   Phase 2: Complete feature set B → WORKING & TESTABLE
   Phase 3: Complete feature set C → WORKING & TESTABLE
   Each phase: Full chain review → Trigger upstream updates → Fix before proceeding
```

---

## Why Gates Are Deterministic

Subjective criteria ("looks good", "seems complete") lead to:
- Different interpretations each run
- Gaps slipping through
- Accumulated technical debt

Deterministic checks ensure:
- Same input = same result
- No "I thought you meant..." failures
- Clear, fixable errors

---

## Why We Block Early

The cost of fixing a bug grows exponentially:
- Found in design: 1x cost
- Found in development: 10x cost
- Found in QA: 50x cost
- Found in production: 500x cost

Blocking at gates front-loads the pain but reduces total pain.

---

## Why Upstream Updates Are Normal

Traditional waterfall treats upstream changes as failures. This workflow treats them as **expected**.

When QA finds that a requirement was ambiguous, that's not QA failing—that's the system working. The fix is to update the requirement, not patch around it.

### The Feedback Chain

```
Product Design → BA → Architect → Designer → Platform → Developer → QA
      ↑           ↑        ↑           ↑          ↑          ↑        │
      └───────────┴────────┴───────────┴──────────┴──────────┴────────┘
                         (feedback flows back)
```

Every downstream skill can trigger updates in upstream skills. This is success, not failure.

---

## Why "Core Journey First"

If the user can login but can't use the main feature, you have:
- A working login
- A broken product

Testing edge cases on a broken core is waste. The orchestrator enforces core journey validation before detailed testing.

---

## Phase Completion Review Template

After each gate, use this template:

```markdown
## Phase Review: [Phase Name]

### Delivered
- [List completed items]

### Completeness Check
| Item | 100% Complete? | If No, What's Missing? |
|------|----------------|------------------------|

### Testability Check
- [ ] QA can test without asking questions
- [ ] Test cases defined
- [ ] Test data available
- [ ] Feature works end-to-end

### Integration Check
- [ ] Works with previous features
- [ ] No breaking changes
- [ ] Dependencies satisfied

### Gaps That Slipped Through
[List anything that should have been caught earlier]

### Upstream Updates Required
| Skill | Update Needed | Priority |
|-------|---------------|----------|

### Decision
- [ ] PROCEED - No gaps
- [ ] FIX FIRST - Gaps identified, fix before next phase
- [ ] UPDATE UPSTREAM - Trigger upstream skills to update their work
- [ ] RESTART PHASE - Too many gaps, redo phase
```

---

## Testing Infrastructure First

Testing is a prerequisite, not an afterthought.

Before ANY development:
- Test environment exists
- Test database is separate
- CI/CD can run tests
- Test frameworks configured
- Sample tests passing

**If test infrastructure is not ready → BLOCK DEVELOPMENT**

A feature without tests is not implemented.

---

## Full-Chain Iteration Matrix

| When THIS Skill... | Finds This Issue... | Updates THIS Skill |
|--------------------|---------------------|-------------------|
| BA | Feature missing from vision | Product Design |
| BA | User journey has gaps | Product Design |
| Architect | Requirement technically impossible | BA → Product Design |
| Architect | Security concern with feature | BA + Product Design |
| Designer | Flow doesn't make sense | BA → Product Design |
| Designer | Missing screens/states | BA |
| Platform | Architecture can't deploy | Architect |
| Developer | Design not implementable | Designer |
| Developer | API contract doesn't work | Architect + API Designer |
| Developer | Requirement ambiguous | BA |
| QA | Feature not testable | Developer + BA |
| QA | Acceptance criteria unclear | BA |
| QA | Journey doesn't match design | Designer + Product Design |
| Security | Architecture has vulnerability | Architect |
| Security | Feature design is insecure | Product Design + BA |

---

## Authority Levels

| Area | Authority |
|------|-----------|
| Skill invocation order | Orchestrator decides |
| Gate pass/fail | Script decides (deterministic) |
| Feedback routing | Orchestrator decides |
| Scope/priority changes | User approval required |
| Technical decisions | Specialist skills decide |

The orchestrator coordinates. It does not make technical decisions.

---

## Exception Handling

**Scope Change Mid-Project:**
STOP → Return to Discovery → Re-evaluate → Get user approval → Resume

**Blocked by External:**
Document → Identify workaround → Continue available work → Escalate

**Critical Bug in Production:**
Security assessment → Hotfix → Fast-track QA → Post-mortem

---

## Output Structure

```
docs/
├── discovery/PROJECT-BRIEF.md
├── product/
│   ├── PRODUCT-VISION.md
│   ├── FEATURE-INVENTORY.md
│   └── MVP-SCOPE.md
├── experience/USER-JOURNEYS.md
├── requirements/REQUIREMENTS-CATALOGUE.md
├── architecture/
│   ├── SYSTEM-DESIGN.md
│   └── ADR/
├── design/
├── qa/
│   ├── TEST-PLAN.md
│   ├── TEST-CASES.md
│   ├── TEST-RESULTS.md
│   └── SECURITY-REVIEW.md
├── traceability/RTM.md
└── PROJECT-STATUS.md
```
