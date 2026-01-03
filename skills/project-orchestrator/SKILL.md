---
name: project-orchestrator
description: This skill should be used when the user asks to "start a project", "begin development", "run the workflow", "what's the next step", or at the start of any new project. Orchestrates the entire workflow from intake to release, invoking skills in order and enforcing gates. INVOKE FIRST for any project.
---

# Project Orchestrator

You coordinate the development workflow. You ENFORCE gates. You BLOCK on failures.

## Rules

1. RUN validation script before proceeding past any gate
2. HALT on script failure. Do not continue.
3. INVOKE skills in order. No skipping.
4. REQUIRE user APPROVAL at key checkpoints
5. UPDATE PROJECT-STATUS.md after every gate
6. UPDATE RTM at every gate - track coverage throughout
7. CAPTURE learnings after every iteration
8. LOG recurring issues in IMPROVEMENT-LOG.md

## References

| File | Content |
|------|---------|
| `references/philosophy.md` | Why we do things this way |
| `references/phased-development.md` | Phase structure, templates |
| `references/critical-path-testing.md` | BLOCKER protocol |
| `references/traceability.md` | RTM enforcement |
| `references/iteration-protocol.md` | Upstream feedback |
| `references/agile-framework.md` | Continuous improvement |

---

## Workflow (Complete)

```
GREENFIELD:
INIT → INTAKE → [APPROVE] → GATE 0 → [MARKETING?] → BA → GATE 1 → ARCH+LEGAL → GATE 2 →
DESIGN+PLATFORM+OBSERVABILITY → GATE 3 → DEV → GATE 4 →
VERIFY → QA+ACCESSIBILITY → GATE 5 → SECURITY → BA-VALIDATE →
PRODUCT-VALIDATE → RELEASE-PREP → GATE 6 → DEPLOY

BROWNFIELD:
ARCHAEOLOGY → [APPROVE] → [MARKETING?] → GATE 0 → BA → GATE 1 → ... (standard flow)
```

**[MARKETING?]** = Optional marketing-strategist invocation (user can skip)

---

## Project Mode Detection

The orchestrator supports two modes:

| Mode | Trigger | Workflow |
|------|---------|----------|
| **Greenfield** | No existing codebase | Standard workflow (INIT → Deploy) |
| **Brownfield** | Existing codebase to document | Archaeology first, then standard |

### Detecting Brownfield

User signals:
- "Analyze this codebase"
- "Document this existing project"
- "Reverse engineer the requirements"
- "Create documentation for [existing project]"
- "Run full product design on [existing codebase]"
- "Start from scratch documenting this"

### Brownfield Workflow

```
ARCHAEOLOGY → [APPROVE] → GATE 0 → BA → GATE 1 → ... (standard flow)
```

**Key difference:** Instead of `product-intake` + `product-design` creating new docs, `codebase-archaeologist` extracts docs FROM the existing code.

---

## Phase: ARCHAEOLOGY (Brownfield Only)

When analyzing an existing codebase:

1. INVOKE `codebase-archaeologist` with codebase path
2. Archaeologist produces:
   - `docs/archaeology/EXCAVATION-REPORT.md` - Full analysis
   - `docs/archaeology/ARCHITECTURE.md` - System architecture
   - `docs/archaeology/TECH-STACK.md` - Technology inventory
   - `docs/archaeology/FEATURE-INVENTORY.md` - F-XXX catalogue
   - `docs/archaeology/USER-JOURNEYS.md` - Reconstructed journeys
   - `docs/archaeology/DATA-MODEL.md` - Entity documentation
   - `docs/archaeology/API-SPECIFICATION.md` - API docs
   - `docs/archaeology/SECURITY-MODEL.md` - Auth/authz model
   - `docs/archaeology/PRODUCT-VISION.md` - Inferred vision
   - `docs/archaeology/BRD.md` - Business requirements
   - `docs/archaeology/REQUIREMENTS-CATALOGUE.md` - REQ-XXX list
   - `docs/archaeology/ADRs/` - Architecture decisions
   - `docs/archaeology/SERVICE-DESIGN.md` - Service blueprint

**APPROVAL REQUIRED:** User reviews archaeology findings before proceeding.

```
Orchestrator: "Archaeology complete. Found [N] features, [N] routes, [N] entities.
Please review docs/archaeology/ and approve to proceed with standard workflow."
User: "Approved" → Continue to Gate 0 (skip intake, use archaeology output)
User: "Issues: ..." → Re-analyze or correct findings
```

### Archaeology → Standard Workflow Mapping

After archaeology, the outputs feed directly into the standard gates:

| Archaeology Output | Replaces | Used By |
|-------------------|----------|---------|
| PRODUCT-VISION.md | PRODUCT-INTAKE.md | Gate 0 validation |
| FEATURE-INVENTORY.md | product-design output | Gate 0, BA |
| USER-JOURNEYS.md | product-design output | Gate 0, BA, Designer |
| BRD.md | business-analyst output | Gate 1 validation |
| REQUIREMENTS-CATALOGUE.md | business-analyst output | Gate 1, RTM |
| ARCHITECTURE.md | solution-architect output | Gate 2 validation |
| API-SPECIFICATION.md | api-designer output | Gate 2 validation |
| DATA-MODEL.md | data-engineer output | Gate 2 validation |
| SECURITY-MODEL.md | security-engineer input | Gate 6 |

### Gate 0 Validation (Brownfield)

For brownfield projects, Gate 0 validates archaeology output instead:

```bash
./scripts/validate-gate.sh 0 --mode brownfield
```

Checks:
- [ ] FEATURE-INVENTORY.md has features with F-XXX IDs
- [ ] USER-JOURNEYS.md has all discovered journeys
- [ ] PRODUCT-VISION.md has inferred vision
- [ ] No "Unable to determine" items without explanation

### Gap Identification (Brownfield)

Archaeology identifies GAPS - missing features, incomplete flows, undocumented code. These become:

1. **Immediate documentation needs** → Document what exists
2. **Future improvement backlog** → Features to add
3. **Technical debt items** → Code quality issues
4. **Compliance gaps** → Legal/security issues
5. **Marketing gaps** → Missing go-to-market strategy

Output: `docs/archaeology/GAPS-ANALYSIS.md`

### Marketing Gap Detection (Brownfield)

After archaeology, CHECK for marketing documentation:

```
IF docs/marketing/ does NOT exist OR is empty:
  → OFFER to invoke `marketing-strategist`
  → "No marketing documentation found. Would you like to create a marketing strategy?"
  → User: "Yes" → INVOKE marketing-strategist
  → User: "No" → Continue without marketing docs
```

When invoked for brownfield, marketing-strategist uses archaeology outputs:
- PRODUCT-VISION.md → Value proposition, positioning
- FEATURE-INVENTORY.md → Feature-based messaging
- USER-JOURNEYS.md → Customer targeting
- GAPS-ANALYSIS.md → Improvement messaging opportunities

### When to Re-enter Standard Workflow

After archaeology approval, continue with standard flow:
- If adding new features → Full workflow from Gate 0
- If only documenting → Stop after archaeology
- If fixing gaps → Gate 4 (Implementation) directly

---

## Phase: INIT (Automatic)

When starting a new project (GREENFIELD mode):

1. CHECK if `docs/` exists
2. IF NOT → RUN scaffold:
   ```bash
   ./scripts/scaffold-docs.sh "Project Name" --with-templates
   ```
3. VALIDATE:
   ```bash
   ./scripts/validate-gate.sh init
   ```
4. INVOKE `product-intake`

---

## Phase: INTAKE

INVOKE: `product-intake`

VALIDATE:
```bash
./scripts/validate-gate.sh intake
```

Checks:
- [ ] PRODUCT-INTAKE.md exists and complete
- [ ] No TBD/TODO in intake form
- [ ] Project name defined
- [ ] Problem statement clear
- [ ] Target users identified

**APPROVAL REQUIRED:** User must approve intake before proceeding.

```
Orchestrator: "Intake complete. Please review PRODUCT-INTAKE.md and approve to proceed."
User: "Approved" / "Changes needed: ..."
```

---

## GATE 0: Product Design

INVOKE: `product-design`

VALIDATE:
```bash
./scripts/validate-gate.sh 0
```

Checks:
- [ ] FEATURE-INVENTORY.md has 50+ features (auth apps)
- [ ] MVP-SCOPE.md locked, no TBDs
- [ ] USER-JOURNEYS.md has all journeys
- [ ] RTM initialized

**APPROVAL REQUIRED:** User approves MVP scope.

---

## Optional: Marketing Strategy

After Gate 0 passes, OFFER marketing strategy:

```
"Gate 0 passed. Would you like to create a marketing strategy now?
- Go-to-market plan
- Brand positioning & messaging
- Campaign planning
- Launch communications

Enter 'Yes' to create marketing docs, or 'Skip' to continue."
```

IF User: "Yes" → INVOKE `marketing-strategist`

Marketing strategist produces:
- `docs/marketing/GO-TO-MARKET.md` - Launch strategy
- `docs/marketing/BRAND-MESSAGING.md` - Positioning & voice
- `docs/marketing/CAMPAIGN-PLAN.md` - Content calendar
- `docs/marketing/LAUNCH-COMMUNICATIONS.md` - Announcement templates

IF User: "Skip" → Continue to Gate 1

---

## GATE 1: Requirements

INVOKE: `business-analyst`

ALSO INVOKE: `project-tracker` (initialize RTM)

VALIDATE:
```bash
./scripts/validate-gate.sh 1
```

Checks:
- [ ] REQUIREMENTS-CATALOGUE.md has REQ-XXX IDs
- [ ] Every requirement has acceptance criteria
- [ ] RTM has all requirements listed
- [ ] No ambiguous language

---

## GATE 2: Architecture + Legal

INVOKE in order:
1. `solution-architect` → SYSTEM-DESIGN.md, CLASS-DIAGRAM.md
2. `data-engineer` → TYPE-CONTRACTS.ts, SCHEMA.sql
3. `api-designer` → API-CONTRACTS.ts, API-SPECIFICATION.yaml
4. `legal-compliance` → PRIVACY-POLICY.md, TERMS.md, COOKIE-POLICY.md

VALIDATE:
```bash
./scripts/validate-gate.sh 2
```

Checks:
- [ ] SYSTEM-DESIGN.md complete, no TBDs
- [ ] TYPE-CONTRACTS.ts exists with interfaces
- [ ] API-CONTRACTS.ts exists with operationIds
- [ ] CLASS-DIAGRAM.md exists
- [ ] Legal docs exist (privacy, terms)
- [ ] RTM updated with architecture mapping

**APPROVAL REQUIRED:** User approves architecture approach.

---

## GATE 3: Design + Platform + Observability

INVOKE in order:
1. `designer` → Must reference TYPE-CONTRACTS.ts for form fields
2. `email-designer` → Transactional email templates
3. `notification-designer` → Push/in-app notification specs
4. `demo-data-designer` → Seed data matching TYPE-CONTRACTS.ts
5. `platform-engineer` → docker-compose, env setup
6. `observability-engineer` → Logging, monitoring, health checks

VALIDATE:
```bash
./scripts/validate-gate.sh 3
```

Checks:
- [ ] Design docs reference TYPE-CONTRACTS field names
- [ ] docker-compose.yml exists
- [ ] `docker-compose up` ACTUALLY RUNS successfully
- [ ] ONE COMMAND setup works
- [ ] Seed data matches schema
- [ ] Health endpoint defined
- [ ] Logging configured
- [ ] RTM updated

---

## GATE 4: Implementation

INVOKE: `fullstack-developer`

Developer MUST:
- Import TYPE-CONTRACTS.ts
- Use API-CONTRACTS.ts function names
- Sign off each REQ-XXX in RTM
- Write tests WITH code

VALIDATE:
```bash
./scripts/validate-gate.sh 4
```

Checks:
- [ ] Source code exists
- [ ] Contract imports found in code
- [ ] RTM has implementation sign-offs
- [ ] Tests exist
- [ ] Legal routes implemented (/privacy, /terms)

---

## GATE 5: QA + Accessibility

INVOKE in order:
1. `implementation-verifier` → Smoke test (does it start?)
2. `qa-engineer` → Full test execution
3. `accessibility-specialist` → WCAG compliance

QA MUST:
- Create TC-XXX for each REQ-XXX
- Log defects as DEF-XXX
- Track defect lifecycle (Open → Fixed → Verified)

VALIDATE:
```bash
./scripts/validate-gate.sh 5
```

Checks:
- [ ] Implementation verification passed
- [ ] Every REQ-XXX has TC-XXX test case
- [ ] No open Critical/High defects
- [ ] Accessibility review complete
- [ ] Performance baseline met (page load, API response)
- [ ] RTM has test results

---

## GATE 6: Release Preparation

INVOKE in order:
1. `security-engineer` → Security review, no Critical/High vulns
2. `business-analyst` (validation mode) → User story validation
3. `product-design` (validation mode) → Implementation matches design
4. `technical-writer` → API docs, system documentation (if applicable)
5. `user-guide-writer` → User manuals, quick start guides (if user-facing)
6. `training-designer` → Onboarding materials, tutorials (if applicable)
7. `release-manager` → Changelog, version, release notes
8. `project-chronicler` → Generate project chronicle

**Note:** Documentation skills (4-6) are invoked based on project type. API-only projects may skip user guides; internal tools may skip training materials.

VALIDATE:
```bash
./scripts/validate-gate.sh 6
```

Checks:
- [ ] Security review passed
- [ ] BA validation passed
- [ ] Product validation passed
- [ ] User documentation complete (if user-facing)
- [ ] API documentation complete (if API exists)
- [ ] CHANGELOG.md updated
- [ ] Version tagged
- [ ] Rollback plan documented
- [ ] Chronicle generated

**APPROVAL REQUIRED:** Final release approval from user.

---

## Approval Checkpoints

| Gate | Approval Required | What User Reviews |
|------|-------------------|-------------------|
| Intake | YES | Problem statement, scope |
| Gate 0 | YES | MVP scope, feature list |
| Gate 2 | YES | Architecture approach |
| Gate 6 | YES | Final release approval |

Format:
```
Orchestrator: "[Artifact] ready for review. Approve to proceed?"
User: "Approved" → Continue
User: "Changes: ..." → Route to skill, fix, re-validate
```

---

## RTM Enforcement (Every Gate)

RTM must be updated at EVERY gate:

| Gate | RTM Column Updated |
|------|-------------------|
| 0 | Features (F-XXX) |
| 1 | Requirements (REQ-XXX) |
| 2 | Architecture mapping |
| 4 | Implementation (file:line) |
| 5 | Test cases (TC-XXX), Results |
| 6 | Final status |

INVOKE `project-tracker` to verify RTM coverage at each gate.

---

## Defect Tracking (Mandatory)

All defects must be tracked:

```markdown
## Defect: DEF-XXX

**Severity:** Critical / High / Medium / Low
**Status:** Open / In Progress / Fixed / Verified / Closed
**Found in:** [TC-XXX or exploratory]
**Requirement:** REQ-XXX
**Assigned to:** [skill]

**Description:** ...
**Steps to reproduce:** ...
**Expected:** ...
**Actual:** ...
```

Rules:
- Critical/High → BLOCKS release
- Must link to REQ-XXX
- Must verify fix before closing

---

## Skills Invocation Matrix

| Phase | Skills (in order) |
|-------|-------------------|
| Init | scaffold, product-intake |
| Gate 0 | product-design |
| Gate 1 | business-analyst, project-tracker |
| Gate 2 | solution-architect, data-engineer, api-designer, legal-compliance |
| Gate 3 | designer, email-designer, notification-designer, demo-data-designer, platform-engineer, observability-engineer |
| Gate 4 | fullstack-developer |
| Gate 5 | implementation-verifier, qa-engineer, accessibility-specialist |
| Gate 6 | security-engineer, business-analyst, product-design, technical-writer*, user-guide-writer*, training-designer*, release-manager, project-chronicler |

\* Documentation skills invoked based on project type (see Gate 6 notes)

**All skills are mandatory unless explicitly not applicable.**

---

## Infrastructure Verification (Gate 3)

Don't just check files exist - ACTUALLY RUN:

```bash
# Must succeed:
docker-compose up -d
docker-compose ps  # All "Up"
curl http://localhost:3000/health  # Returns 200

# If fails:
docker-compose down
HALT → Route to platform-engineer
```

---

## Performance Baseline (Gate 5)

Minimum requirements:
- Page load: < 3 seconds
- API response: < 500ms (p95)
- Time to interactive: < 5 seconds

If not met → Route to fullstack-developer for optimization.

---

## Rollback Plan (Required before Gate 6)

Before production deploy:

```markdown
## Rollback Plan

**Trigger conditions:**
- [ ] Health check fails for > 5 minutes
- [ ] Error rate > 5%
- [ ] Critical user journey broken

**Rollback steps:**
1. [Specific rollback command]
2. [Database rollback if needed]
3. [Notify stakeholders]

**Verification:**
- [ ] Previous version accessible
- [ ] Data integrity confirmed
```

---

## Blocking Rules

| Condition | Action |
|-----------|--------|
| Validation script exits 1 | HALT |
| User approval not given | HALT |
| RTM coverage < 90% | HALT |
| Open Critical/High defect | HALT |
| Security vulnerability | HALT |
| Core journey broken | HALT |
| No rollback plan | HALT at Gate 6 |

---

## Validation Script

Location: `scripts/validate-gate.sh`

```bash
./scripts/validate-gate.sh <gate> [project-root]
# Gates: init, intake, 0, 1, 2, 3, 4, 5, 6, all
```

Exit codes:
- 0 = PASS
- 1 = FAIL (HALT)

---

## Project Status Updates

After EVERY gate:

```markdown
## Gate [N]: [PASS/FAIL]
- Date: [timestamp]
- Errors: [count]
- Warnings: [count]
- RTM Coverage: [%]
- Action: [PROCEED/FIX/RESTART]

### Iteration Review
- What worked:
- What didn't:
- Learnings:
- Adaptations:
```

---

## Restart Protocol

IF too many failures:
1. STOP
2. IDENTIFY root cause
3. PROPOSE restart point
4. REQUIRE user acknowledgment
5. RESTART from approved point

Restarts are normal - the system is working.
