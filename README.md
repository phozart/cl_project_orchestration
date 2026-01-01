# Development Workflow Plugin

A comprehensive Claude Code plugin providing 34+ specialized skills for end-to-end product development. Covers strategy, **product design**, architecture, infrastructure, implementation, **observability**, verification, testing, validation, security, **legal compliance**, and **release management** with **12 quality gates**, **requirements traceability**, **parallel work streams**, and **blocking/restart protocols**.

## Installation

### Option 1: Install from Directory (Local)

```bash
# Clone or download the plugin
git clone https://github.com/phozart/cl_project_orchestration.git

# Add to your Claude Code settings
# In ~/.claude/settings.json, add:
{
  "plugins": [
    "/path/to/development-workflow-plugin"
  ]
}
```

### Option 2: Install for a Specific Project

```bash
# Copy to your project
cp -r development-workflow-plugin /your-project/.claude/plugins/

# Or add to project settings
# In /your-project/.claude/settings.json:
{
  "plugins": [
    "./.claude/plugins/development-workflow-plugin"
  ]
}
```

### Option 3: Test Before Installing

```bash
# Run Claude Code with the plugin loaded
claude --plugin-dir ./development-workflow-plugin
```

## Quick Start

Start any project with:

```
I want to build [your project description].

Please use the /project-orchestrator skill to guide me through the entire development process.
```

The orchestrator will:

1. Ask discovery questions to understand your needs
2. Create a skill execution plan
3. Invoke skills in the correct order
4. Validate outputs at each quality gate
5. Route feedback between skills
6. Track progress to completion
7. Generate project chronicle documentation

## Commands

| Command | Purpose |
| ------- | ------- |
| `/start` | Start project orchestration |
| `/project-chronicle` | Generate project documentation |
| `/project-chronicle --full` | Include all artifact content |
| `/project-chronicle --minimal` | Summary only |
| `/project-chronicle --theme dark` | Set default theme |
| `/plan-next-release` | **Plan iteration from MVP to v2, v3, etc.** |
| `/plan-next-release --hotfix` | Plan bug fix release |
| `/plan-next-release --minor` | Plan feature release |
| `/plan-next-release --major` | Plan major version release |

## Skills (34 Total)

### Meta/Management

| Skill                  | Purpose                                        |
| ---------------------- | ---------------------------------------------- |
| `project-orchestrator` | Coordinates entire workflow, enforces 12 gates |
| `project-chronicler`   | Generates HTML documentation of project journey |
| `requirements-tracker` | RTM maintenance, coverage reports, traceability |
| `release-manager`      | Versioning, changelog, release notes           |

### Strategy & Product Design

| Skill                | Purpose                                           |
| -------------------- | ------------------------------------------------- |
| `product-strategist` | Market research, business model, validation       |
| `product-design`     | **Feature discovery, MVP scope, R&D, completeness** |
| `ux-researcher`      | User interviews, usability testing                |
| `cx-strategist`      | Customer journey, touchpoints, NPS                |

### Requirements & Architecture

| Skill                | Purpose                                        |
| -------------------- | ---------------------------------------------- |
| `business-analyst`   | Requirements, BRD, user stories, acceptance testing |
| `solution-architect` | System design, ADRs, tech decisions            |

### Design

| Skill                  | Purpose                       |
| ---------------------- | ----------------------------- |
| `ux-designer`          | User flows, wireframes, IA    |
| `ui-designer`          | Visual design, design system  |
| `interaction-designer` | Micro-interactions, animation |

### Data & API

| Skill            | Purpose                          |
| ---------------- | -------------------------------- |
| `data-architect` | Database schemas, data models    |
| `api-designer`   | REST/GraphQL APIs, OpenAPI specs |
| `data-analyst`   | Metrics, dashboards, insights    |
| `bi-engineer`    | ETL, data warehouse, reporting   |

### Content & Documentation

| Skill                | Purpose                            |
| -------------------- | ---------------------------------- |
| `content-strategist` | Website copy, marketing, messaging |
| `technical-writer`   | Documentation, API docs, guides    |
| `demo-data-designer` | Realistic test/demo data           |

### Infrastructure & Operations

| Skill                     | Purpose                                      |
| ------------------------- | -------------------------------------------- |
| `platform-engineer`       | Docker, database setup, environment config   |
| `implementation-verifier` | Smoke test before QA (does it actually run?) |
| `observability-engineer`  | Logging, error tracking (Sentry), health checks |

### Implementation

| Skill                 | Purpose                           |
| --------------------- | --------------------------------- |
| `fullstack-developer` | Frontend + backend code, RBAC     |
| `devops-engineer`     | CI/CD, infrastructure, deployment |

### Quality & Security

| Skill                      | Purpose                               |
| -------------------------- | ------------------------------------- |
| `qa-engineer`              | Testing, defect reports, sign-off     |
| `security-engineer`        | Security review, vulnerability checks |
| `accessibility-specialist` | WCAG compliance, a11y audit           |
| `test-automation-engineer` | CI/CD test pipelines                  |
| `performance-engineer`     | Load testing, optimization            |

### Legal & Compliance

| Skill                | Purpose                                      |
| -------------------- | -------------------------------------------- |
| `legal-advisor`      | Privacy policy, terms of service, GDPR/CCPA |
| `compliance-analyst` | Privacy, regulatory compliance               |

### Communications

| Skill            | Purpose                               |
| ---------------- | ------------------------------------- |
| `email-designer` | Transactional email templates (React Email) |

## Agents

Pre-configured agents for common workflows:

| Agent                | Purpose                                       |
| -------------------- | --------------------------------------------- |
| `project-lead`       | Orchestrates full development workflow        |
| `code-developer`     | Implements features with best practices       |
| `qa-reviewer`        | Verifies quality before release               |
| `design-coordinator` | Coordinates UX + UI + Interaction alignment   |
| `technical-reviewer` | Coordinates Architecture + Security reviews   |
| `release-coordinator`| Coordinates Release Manager + DevOps          |

## Agile Workflow (Bidirectional Feedback)

**This is an AGILE workflow, not waterfall.** Skills don't just pass work forward - they critically review inputs, collaborate with upstream/downstream skills, and iterate continuously.

### Core Agile Principles

1. **Critical Input Review** - Every skill validates incoming work before accepting
2. **Upstream Feedback (UPFB)** - Later skills can (and should) suggest changes to earlier work
3. **Collaboration over Handoff** - Skills work together at defined collaboration points
4. **Iterate over Perfect First Time** - Expect multiple passes to get it right
5. **Continuous Improvement** - Learn and adapt throughout the project

### Workflow Diagram

```
┌────────────────────────────────────────────────────────────────────────────┐
│                  project-orchestrator (12 Gates + AGILE)                    │
│                                                                             │
│   ◄─────────────────── UPSTREAM FEEDBACK FLOWS ─────────────────────►      │
│   (Any skill can trigger changes to any earlier phase via UPFB-XXX)        │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   [START] ◄──► [DISCOVERY] ◄──► [STRATEGY] ◄──► [PRODUCT DESIGN]          │
│                                                        ▼                    │
│                           ┌─────────────────────────────────┐              │
│                           │ COLLAB: Product + BA + UX       │              │
│                           └─────────────────────────────────┘              │
│                                        ▼                                    │
│   [REQUIREMENTS] ──────────────────────────────────────┐                   │
│        ▼                                               │ Feedback          │
│   ┌────────────────────────────────────────┐          │ Loops             │
│   │ COLLAB: BA + Architect + Data + API    │          │                   │
│   └────────────────────────────────────────┘          │                   │
│        ▼                                               │                   │
│   [ARCHITECTURE] ◄─────────────────────────────────────┤                   │
│        ▼                                               │                   │
│   [DATA + API] + [LEGAL] (parallel)                   │                   │
│        ▼                                               │                   │
│   ┌────────────────────────────────────────┐          │                   │
│   │ COLLAB: UX + UI + Dev                  │          │                   │
│   └────────────────────────────────────────┘          │                   │
│        ▼                                               │                   │
│   [UX] ◄──► [UI] ◄──► [EMAIL DESIGNER]               │                   │
│        ▼                                               │                   │
│   [PLATFORM ENGINEER] ─────────────────────────────────┤                   │
│        ▼                                               │                   │
│   ┌────────────────────────────────────────┐          │                   │
│   │ COLLAB: Dev + QA + Security            │          │                   │
│   └────────────────────────────────────────┘          │                   │
│        ▼                                               │                   │
│   [IMPLEMENTATION] ◄──► [CODE REVIEW] ─────────────────┤                   │
│        ▼                                               │                   │
│   [OBSERVABILITY] ──► [VERIFIER] ──────────────────────┤                   │
│        ▼                                               │                   │
│   ┌────────────────────────────────────────┐          │                   │
│   │ COLLAB: QA + Dev + BA (Defect Triage)  │          │                   │
│   └────────────────────────────────────────┘          │                   │
│        ▼                                               │                   │
│   [QA TESTING] ◄──► [DEVELOPER] (Bug Fixes) ───────────┤                   │
│        ▼                                               │                   │
│   [BUSINESS ACCEPTANCE] ◄──► [UX] (Usability) ─────────┤                   │
│        ▼                                               │                   │
│   [SECURITY REVIEW] ◄──► [DEVELOPER] (Vuln Fixes) ─────┘                   │
│        ▼                                                                    │
│   [RELEASE MANAGER] ──► [DEVOPS] ──► [DEPLOY]                              │
│        ▼                                                                    │
│   [PRODUCTION VERIFICATION] ──► [CHRONICLE] ──► [DONE]                     │
│                                                                             │
│   LEGEND:  ──►  Forward flow       ◄──►  Bidirectional collaboration       │
│            ◄──  Upstream feedback  [COLLAB]  Cross-skill session           │
└────────────────────────────────────────────────────────────────────────────┘
```

### Collaboration Sessions (Mandatory)

| Phase | Skills Involved | Purpose |
|-------|-----------------|---------|
| After Product Design | Product + BA + UX | Align on scope before requirements |
| After Requirements | BA + Architect + Data + API | Technical feasibility check |
| During Design | UX + UI + Interaction + Dev | Design-dev alignment |
| Before Implementation | Dev + QA + Security | Test planning and security by design |
| During QA | QA + Dev + BA | Defect triage and priority |

### Input Validation Protocol

Every skill MUST critically review inputs before proceeding:

```markdown
## Input Validation: [SKILL NAME]

### Completeness Check
- [ ] All required inputs received?
- [ ] Inputs are complete and unambiguous?

### Domain Expertise Check
- What would a real expert notice is missing?
- Is this technically feasible?

### Decision
- [ ] ACCEPT - Proceed with work
- [ ] CLARIFY - Need answers first
- [ ] UPSTREAM FEEDBACK - Previous phase needs changes
- [ ] BLOCK - Cannot proceed
```

## Quality Gates

Each phase must pass validation before proceeding (12 gates total):

| # | Gate | Pass Criteria |
| - | ---- | ------------- |
| **0** | **Product Design** | **50-100 features, all journeys mapped, R&D complete** |
| 1 | Requirements | All requirements have IDs, are testable, prioritized, RTM initialized |
| 2 | Architecture | ADRs documented, no TBDs, security addressed |
| 3 | Contracts | Database schema + API endpoints fully defined |
| 4 | Design | All flows covered, accessible, responsive |
| 5 | Infrastructure | Docker starts, DB accessible, single-command setup works |
| 6 | Implementation | Tests pass, no linting errors, admin seeded |
| **6.5** | **Requirements Coverage** | **100% Must-Have implemented, 90%+ Should-Have, RTM signed off** |
| 7 | Verification | App starts, routes work, auth works, no 500 errors |
| 8 | QA | No critical defects, all requirements have test cases |
| 9 | Business Acceptance | User stories validated from real user perspective |
| 10 | Security | No high/critical vulnerabilities |
| **11** | **Production Verification** | **Auth works, core journeys pass, health checks OK (on request)** |

## Admin & RBAC (Role-Based Access Control)

Most apps with user accounts need admin functionality. The workflow now captures this early:

**Discovery Questions** (asked by orchestrator):
- Will users need accounts?
- What user roles are needed? (viewer, user, editor, admin)
- What can each role do?
- Is there an admin dashboard?

**Skills with RBAC guidance**:
- `business-analyst` - Captures role requirements
- `data-architect` - Users table with role column, audit log
- `fullstack-developer` - Authorization middleware, admin routes
- `implementation-verifier` - Tests admin login works

## Business Acceptance Testing

After technical QA passes, the Business Analyst validates the product from a user perspective:

- **First Impressions Test**: Does the app load? Is purpose clear? Can user navigate?
- **User Story Validation**: Can users achieve their goals per acceptance criteria?
- **Requirements Traceability**: Does implementation match intent?
- **Problem-Solution Fit**: Does the product solve the original problem?

Results: **ACCEPT**, **REJECT**, or **CONDITIONAL** with issues routed to appropriate skills.

## Product Design (NEW - Critical)

The `product-design` skill is the most critical skill in the workflow. It ensures:

- **Complete Scope**: 50-100 features for apps with auth (not 15-20)
- **Context Gathering**: Domain research, competitor analysis, reference products
- **R&D**: Research best approaches before committing to implementation
- **No Half-Systems**: A service owner would never approve an incomplete system

**Why Product Design Matters**:
- Missing 50% of features = useless MVP
- Scope too narrow = users can't complete goals
- No system thinking = forgot auth, admin, emails, legal

**System Features Checklist** - Product Design reviews ALL categories:
- Authentication & Identity (signup, login, reset, logout, verify)
- Admin & User Management (list, search, edit, roles)
- Transactional Emails (welcome, verification, reset)
- Legal & Compliance (privacy policy, terms, cookies)
- Settings & Preferences
- Error Handling & Empty States
- And 20+ more categories

## Requirements Traceability (RTM)

**No requirements get lost.** Every requirement (REQ-XXX) is tracked through:

1. **Product Design** → Feature (F-XXX)
2. **BA** → Requirement (REQ-XXX) with acceptance criteria
3. **Developer** → Implementation with file:line reference
4. **QA** → Test case (TC-XXX) linked to requirement
5. **BAT** → Validation by BA

**Gate 6.5 (Requirements Coverage)** blocks QA if:
- Any Must-Have requirement is not implemented
- Any requirement lacks file:line reference
- Coverage is below 90% for Should-Have

**The RTM is the source of truth:**
- Feature in code but not in RTM → Undocumented (risk)
- Requirement in RTM but not in code → Not implemented (blocker)
- Test exists but not linked → Coverage unknown

## Blocking and Restart Protocols

**A service owner would NEVER approve a half-implemented system.**

### When the System BLOCKS:
| Condition | Action |
|-----------|--------|
| Gate fails | BLOCK at current phase until fixed |
| Feature count < 50 (auth app) | RESTART product design |
| Must-Have not implemented | BLOCK before QA |
| Critical defect in production | ROLLBACK |

### When the System RESTARTS:
| Trigger | Restart From |
|---------|--------------|
| "We forgot X" (major feature) | Product Design |
| "Requirements misunderstood" | Business Analyst |
| "Architecture can't support X" | Solution Architect |
| "Users can't use this" | UX Design |

### Parallel Work Streams

Large projects can parallelize work when features are independent:
- Auth and Settings can develop in parallel
- Infrastructure must complete before any development
- All parallel tracks sync at quality gates

## Iteration: MVP → v2 → v3

**The MVP is shipped. Now what?**

After v1 is deployed, use `/plan-next-release` to iterate. **Each iteration is NOT just "add more features".**

### Iteration Workflow

```
MVP SHIPPED → Stabilization → Requirements Review → Risk Assessment → Process Review
     │              │                │                    │               │
     │         (bugs only)     (what worked?       (risk + impact    (question
     │                         what failed?)        for new items)    everything)
     ↓                                                                     ↓
Feedback Collection → Prioritization → Scope Lock → Execute → RELEASE
         │                                  │
    (user, analytics,              (with traceability)
     deferred, tech debt)
```

### Critical Iteration Steps

| Step | Purpose | Output |
|------|---------|--------|
| **Requirements Review** | Assess each REQ from v[Previous] | RTM coverage score |
| **Risk Assessment** | Score risk × impact for new items | Risk register |
| **Impact Analysis** | Trace changes through system | Regression risk |
| **Process Review** | Question tools, tech, approach | Improvements list |
| **Traceability** | Connect new items to sources | Updated RTM |

### Release Types

| Type | Version | Content | Workflow |
|------|---------|---------|----------|
| **Patch** | v1.0.1 | Bug fixes only | QA → Dev → Deploy |
| **Minor** | v1.1.0 | Bug fixes + small features | Product Design → BA → Dev → QA |
| **Major** | v2.0.0 | Significant new features | Full workflow |

### Iteration Principles

1. **Review before adding** - If RTM coverage < 90%, fix first
2. **Trace everything** - Every item has source + REQ-ID
3. **Assess risk** - High-risk needs approval + mitigation
4. **Question approach** - Don't repeat broken processes
5. **Stay current** - Consider new tech, regulations, market

## Document Output Structure

Skills produce artifacts in standardized locations for traceability:

```
docs/
├── discovery/           # Product Strategist outputs
│   ├── PROJECT-BRIEF.md
│   ├── MARKET-ANALYSIS.md
│   ├── COMPETITIVE-ANALYSIS.md
│   └── BUSINESS-MODEL.md
├── product/             # Product Design outputs (NEW)
│   ├── PRODUCT-VISION.md
│   ├── FEATURE-INVENTORY.md
│   ├── USER-JOURNEYS.md
│   ├── MVP-SCOPE.md
│   └── RD-FINDINGS.md
├── requirements/        # Business Analyst outputs
│   ├── BRD.md
│   ├── REQUIREMENTS-CATALOGUE.md
│   └── USER-STORIES.md
├── traceability/        # Requirements Tracker outputs (NEW)
│   └── RTM.md           # Requirements Traceability Matrix
├── architecture/        # Solution Architect outputs
│   ├── SYSTEM-DESIGN.md
│   └── ADR/
│       └── ADR-001-*.md
├── data/                # Data Architect outputs
│   └── DATA-MODEL.md
├── api/                 # API Designer outputs
│   └── API-SPEC.md
├── design/              # UX/UI Designer outputs
│   ├── USER-FLOWS.md
│   ├── WIREFRAMES.md
│   └── UI-SPEC.md
├── qa/                  # QA Engineer outputs
│   ├── TEST-PLAN.md
│   └── DEFECT-LOG.md
├── security/            # Security Engineer outputs
│   └── SECURITY-REVIEW.md
├── devops/              # DevOps Engineer outputs
│   └── DEPLOYMENT-CONFIG.md
└── chronicles/          # Project Chronicler outputs
    └── PROJECT-CHRONICLE-*.html
```

## Project Chronicle

The `project-chronicler` skill generates a self-contained HTML file documenting the entire project journey:

- **Timeline**: Visual journey from discovery to deployment with gate markers
- **Artifact Gallery**: All produced documents organized by type
- **Decision Log**: ADRs with context and consequences
- **Metrics Dashboard**: Gates passed, defects resolved, test coverage
- **Diagrams**: Architecture, ERD, sequence diagrams (via Mermaid.js)
- **Workflow Visualization**: Skill invocation sequence

Generated automatically at phase completion or manually via `/project-chronicle`.

## Feedback Loops

Skills give feedback to each other:

```
QA finds bug              → Routes to Developer
Developer unclear         → Routes to BA for clarification
Security finds vuln       → Routes to Developer + Architect
Design issue found        → Routes to UX/UI Designer
BA finds UX issue in BAT  → Routes to UX Designer
Feature doesn't work      → Routes to Developer
```

## Sharing with Friends

To share this plugin:

1. **Zip the directory**:

```bash
zip -r development-workflow-plugin.zip development-workflow-plugin/
```

2. **Share the zip file** (email, Slack, etc.)

3. **Recipient installs**:

```bash
unzip development-workflow-plugin.zip
# Add to their Claude Code settings as shown above
```

## Customization

### Adding a New Skill

1. Create a directory: `skills/my-skill/`
2. Add `SKILL.md` with frontmatter:

```markdown
---
name: my-skill
description: What this skill does. Use when [trigger conditions].
---

[Skill instructions...]
```

3. Add Output Location section pointing to appropriate `docs/` subdirectory

### Adding a New Agent

1. Create file: `agents/my-agent.md`
2. Add frontmatter:

```markdown
---
name: my-agent
description: What this agent does. Use PROACTIVELY when [conditions].
tools: Read, Write, Bash
---

[Agent instructions...]
```

### Adding a New Command

1. Create file: `commands/my-command.md`
2. Add frontmatter and instructions

## License

MIT - See [LICENSE](LICENSE) file for details.

## Contributing

Pull requests welcome. For major changes, please open an issue first.
