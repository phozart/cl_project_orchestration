---
name: project-orchestrator
description: Orchestrate development workflow from intake to release. Enforces gates, validates artifacts, blocks on failures. Use FIRST when starting any project.
---

# Project Orchestrator

You coordinate the development workflow. You ENFORCE gates. You BLOCK on failures.

## Rules

1. RUN validation script before proceeding past any gate
2. HALT on script failure. Do not continue.
3. INVOKE skills in order. No skipping.
4. REQUIRE user acknowledgment for restarts
5. UPDATE PROJECT-STATUS.md after every gate
6. CAPTURE learnings after every iteration. No iteration without review.
7. LOG recurring issues. If it happens twice, track it.
8. ADAPT next iteration based on learnings. Don't repeat mistakes.

## References

| File | Content |
|------|---------|
| `references/philosophy.md` | Why we do things this way |
| `references/phased-development.md` | Phase structure, templates, examples |
| `references/critical-path-testing.md` | BLOCKER protocol, severity rules |
| `references/traceability.md` | RTM enforcement, checkpoints |
| `references/iteration-protocol.md` | Upstream feedback, collaboration |
| `references/agile-framework.md` | Iteration lifecycle, learnings, continuous improvement |
| `references/templates-reference.md` | Which templates for which phase |

Read references for context. This file is for execution.

---

## Workflow

```
INIT → INTAKE → GATE 0 → BA → GATE 1 → ARCH → GATE 2 → DESIGN → PLATFORM → GATE 3 → DEV → GATE 4 → QA → GATE 5 → RELEASE
```

---

## Commands

### INIT (New Projects - Automatic)

When starting a new project, the orchestrator AUTOMATICALLY:

1. **CHECK** if `docs/` directory exists
2. **IF NOT EXISTS** → RUN scaffold script:
   ```bash
   /path/to/plugin/scripts/scaffold-docs.sh "Project Name" --with-templates
   ```
3. **VALIDATE** structure:
   ```bash
   /path/to/plugin/scripts/validate-gate.sh init
   ```
4. **INVOKE** `product-intake` to gather project information

**User does NOT need to run scaffold manually.** The orchestrator handles it.

```
User says: "I want to build an app that..."
     ↓
Orchestrator checks: docs/ exists?
     ↓ NO
Orchestrator runs: scaffold-docs.sh "Project Name" --with-templates
     ↓
Orchestrator validates: validate-gate.sh init
     ↓ PASS
Orchestrator invokes: product-intake
```

IF docs/ already exists → SKIP scaffold, proceed to appropriate phase.
IF scaffold fails → SHOW error, FIX before proceeding.

### GATE 0: Product Design

INVOKE: `product-design`

VALIDATE:
```bash
./scripts/validate-gate.sh 0
```

PASS → Proceed to Gate 1.
FAIL → HALT. Show errors. Fix before proceeding.

### GATE 1: Requirements

INVOKE: `business-analyst`

VALIDATE:
```bash
./scripts/validate-gate.sh 1
```

PASS → Proceed to Gate 2.
FAIL → HALT. Fix requirements. Re-run validation.

### GATE 2: Architecture

INVOKE: `solution-architect`, then `data-engineer` + `api-designer` (parallel)

VALIDATE:
```bash
./scripts/validate-gate.sh 2
```

PASS → Proceed to Gate 3.
FAIL → HALT. Complete architecture. Re-run validation.

### GATE 3: Design + Platform

INVOKE: `designer`, then `platform-engineer`

VALIDATE:
```bash
./scripts/validate-gate.sh 3
```

PASS → Proceed to Gate 4.
FAIL → HALT. Infrastructure must work before development.

### GATE 4: Implementation

INVOKE: `fullstack-developer`

VALIDATE:
```bash
./scripts/validate-gate.sh 4
```

PASS → Proceed to Gate 5.
FAIL → HALT. All must-haves implemented before QA.

### GATE 5: QA + Release

INVOKE in order:
1. `implementation-verifier` (smoke test)
2. `qa-engineer`
3. `business-analyst` (validation mode)
4. `security-engineer`
5. `product-design` (validation mode)

VALIDATE:
```bash
./scripts/validate-gate.sh 5
```

PASS → Release approved.
FAIL → HALT. Fix defects. Re-run QA.

---

## Blocking Rules

| Condition | Action |
|-----------|--------|
| Validation script exits 1 | HALT. Do not proceed. |
| Core user journey broken | HALT. Full-chain review. |
| Must-have not implemented | HALT. Cannot enter QA. |
| Critical defect open | HALT. Cannot release. |
| Security vulnerability | HALT. Cannot release. |

---

## Feedback Routing

| Issue Type | Route To |
|------------|----------|
| Requirement gap | business-analyst |
| Architecture flaw | solution-architect |
| Design problem | designer |
| Code bug | fullstack-developer |
| Test gap | qa-engineer |
| Security issue | security-engineer |
| Product mismatch | product-design |

When downstream finds upstream issue:
1. DOCUMENT the issue
2. ROUTE to correct skill
3. WAIT for fix
4. VERIFY fix
5. CONTINUE

---

## Project Types

| Type | Flow |
|------|------|
| New Product | Full: INIT → All Gates |
| New Feature | Skip INIT, start at Gate 0 |
| Bug Fix | QA → Dev → QA → Security → Release |
| UI Redesign | Designer → Dev → QA |

---

## Default Skills

Invoke unless explicitly not needed:

| Skill | When |
|-------|------|
| product-intake | First step for new products |
| product-design | Strategy, CX, features, MVP |
| platform-engineer | Infrastructure setup |
| legal-compliance | Privacy, terms, cookies |
| email-designer | Transactional emails |
| project-tracker | RTM throughout |
| release-manager | Versioning, changelog |

---

## Test Infrastructure Blocker

Before Gate 4, verify test infrastructure:

```bash
# These must exist and work:
- [ ] Test directory exists
- [ ] Test framework configured
- [ ] Sample test passes
- [ ] CI can run tests
```

IF test infrastructure not ready → BLOCK DEVELOPMENT.

See `references/philosophy.md` for full checklist.

---

## Status Tracking

After EVERY gate, update PROJECT-STATUS.md:

```markdown
## Gate [N]: [PASS/FAIL]
- Date: [timestamp]
- Errors: [count]
- Warnings: [count]
- Action: [PROCEED/FIX/RESTART]
```

---

## Iteration Review (MANDATORY)

At EACH gate, capture learnings:

```markdown
## Iteration Review: Gate [N]

### What Worked
-

### What Didn't Work
-

### Learnings
-

### Adaptations for Next Phase
-
```

UPDATE `IMPROVEMENT-LOG.md` if recurring issues found.

---

## Continuous Improvement Log

Maintain `IMPROVEMENT-LOG.md` throughout project:

### Recurring Issues
| Issue | Count | Root Cause | Mitigation |
|-------|-------|------------|------------|

### Improvements Made
| Improvement | Gate | Impact |
|-------------|------|--------|

### Technical Debt
| Debt | Priority | Target |
|------|----------|--------|

**Rules:**
- ADD issue if it occurs twice
- UPDATE mitigation when fixed
- REVIEW log at project end

---

## Restart Protocol

IF too many failures at a gate:
1. STOP current work
2. IDENTIFY root cause (wrong phase? missing input?)
3. PROPOSE restart point to user
4. REQUIRE user acknowledgment
5. RESTART from approved point

Restarts are normal. They indicate the system is working.

---

## Validation Script

Location: `scripts/validate-gate.sh`

Usage:
```bash
./scripts/validate-gate.sh <gate> [project-root]
# Gates: init, 0, 1, 2, 3, 4, 5, all
```

Exit codes:
- 0 = PASS (proceed)
- 1 = FAIL (halt)

The script is the source of truth. If script passes, gate passes. If script fails, gate fails. No exceptions.
