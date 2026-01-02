# Development Workflow Plugin

A comprehensive Claude Code plugin providing **34 specialized skills** for end-to-end product development. Features a streamlined workflow: **Product Intake → Product Design (Strategy→CX→Design) → BA → Architecture → Automated Implementation → QA → Product Validation → Deploy**.

**Key Features:**
- **Product Design as Central Authority** - Contains Strategy, CX, and Design phases internally; validates implementation before deploy
- **Automated Implementation Phase** - Dev iterations flow without manual gate checks between each fix
- **Combined Skills** - Reduced from 46+ to 34 by combining related skills (data-engineer, legal-compliance, project-tracker, etc.)
- **10 Quality Gates** - From Product Design through Production Verification
- **Requirements Traceability** - RTM tracks every requirement from design to production
- **Project Chronicles** - Auto-generated HTML documentation at each milestone

**Three modes of operation:**
- **Full Project Mode** - End-to-end orchestration from idea to production
- **Continuous Flow Mode** - Kanban-style parallel item processing for larger projects
- **Standalone Mode** - Call individual skills directly for specific tasks

## Scaffolding & Templates

The plugin includes a **scaffolding system** to accelerate project setup and reduce token usage.

### Quick Scaffold

```bash
# Create full docs structure for a new project
./scripts/scaffold-docs.sh "My Project"

# With templates copied
./scripts/scaffold-docs.sh "My Project" --with-templates

# Minimal structure only
./scripts/scaffold-docs.sh "My Project" --minimal
```

### Templates Directory

```
templates/
├── PRODUCT-INTAKE.template.md      # Product intake form
├── PROJECT-STATUS.template.md      # Project status tracker
├── .env.example.template           # Environment variables
├── docker-compose.template.yml     # Docker configuration
└── docs/
    ├── discovery/PROJECT-BRIEF.template.md
    ├── product/FEATURE-INVENTORY.template.md
    ├── requirements/BRD.template.md
    ├── traceability/RTM.template.md
    ├── architecture/SYSTEM-DESIGN.template.md
    ├── api/API-SPEC.template.md
    ├── qa/TEST-PLAN.template.md
    └── security/SECURITY-REVIEW.template.md
```

### Benefits

| Benefit | Description |
|---------|-------------|
| **Token Efficiency** | ~75% reduction - Claude fills templates instead of generating |
| **Consistency** | Same document structure across all projects |
| **Speed** | Project structure created in seconds |
| **Completeness** | Templates include all required sections |

See `templates/README.md` for full documentation.

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

### Full Project Mode (Recommended for New Projects)

Start any project with the orchestrator:

```
/project-orchestrator
```

Or simply describe what you want to build:

```
"I want to build an app that helps students track their study habits"
```

The orchestrator automatically:

1. **Calls product-intake** - Structured questions to gather requirements
2. **Invokes product-design** - 3-phase flow (Strategy → CX → Design)
3. **Routes to specialists** - BA, Architect, Designer, Developer, QA
4. **Automates implementation** - Dev iterations without manual gates
5. **Validates at gates** - Quality checkpoints that matter
6. **Generates chronicles** - Visual HTML documentation at milestones

### Standalone Mode (For Specific Tasks)

**You don't need to run a full project to use individual skills.** Call any skill directly for specific tasks:

```
Use the qa-engineer skill to create a test plan for my login feature.
```

```
Use the svg-designer skill to create icons for my navigation menu.
```

```
Use the security-engineer skill to review my authentication code.
```

```
Use the data-engineer skill to design a schema for user subscriptions.
```

#### Common Standalone Use Cases

| Task | Skill to Use | Example Prompt |
|------|--------------|----------------|
| **Create icons/logos** | `svg-designer` | "Create a logo for my app called TaskFlow" |
| **Design database** | `data-engineer` | "Design a schema for an e-commerce product catalog" |
| **Write tests** | `qa-engineer` | "Create test cases for user registration" |
| **Review security** | `security-engineer` | "Review this API for security vulnerabilities" |
| **Design API** | `api-designer` | "Design REST endpoints for a booking system" |
| **Design UI/UX** | `designer` | "Create user flows and design system for a fintech app" |
| **Write user stories** | `business-analyst` | "Write user stories for a password reset feature" |
| **Plan reliability** | `reliability-engineer` | "Design SLOs and monitoring for my API" |
| **Create email templates** | `email-designer` | "Create a welcome email template" |
| **Setup notifications** | `notification-designer` | "Design push notification strategy for my app" |

#### Skill Chaining (Manual Pipeline)

You can also chain skills manually for a focused workflow:

```
1. Use the designer skill to create user flows and wireframes for checkout
2. Use the svg-designer skill to create icons needed in the wireframes
3. Use the fullstack-developer skill to implement the designs
```

## Commands

| Command | Purpose |
| ------- | ------- |
| `/project-orchestrator` | **Start a new project** - Auto-calls product-intake, then orchestrates full workflow |
| `/project-chronicle` | Generate visual HTML documentation of project journey |
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
| `project-orchestrator` | Coordinates entire workflow, enforces gates, calls product-intake first |
| `project-chronicler`   | Generates HTML documentation of project journey |
| `product-intake`       | **First step** - Structured intake form, gathers all essential info |
| `project-tracker`      | **Combined** - RTM + Kanban board + WIP limits + flow metrics |
| `release-manager`      | Versioning, changelog, release notes           |

### Product Design (Central Authority)

| Skill                | Purpose                                           |
| -------------------- | ------------------------------------------------- |
| `product-design`     | **3-phase flow**: Strategy → CX → Design. Validates implementation at end |
| `ux-researcher`      | User interviews, usability testing                |

### Requirements & Architecture

| Skill                | Purpose                                        |
| -------------------- | ---------------------------------------------- |
| `business-analyst`   | Requirements, BRD, user stories, acceptance testing |
| `solution-architect` | System design, ADRs, tech decisions            |

### Design

| Skill          | Purpose                                              |
| -------------- | ---------------------------------------------------- |
| `designer`     | **Complete UX/UI/Interaction design** - flows, wireframes, visual design, design system, animations |
| `svg-designer` | Icons, logos, illustrations, visual assets           |

### Data & API

| Skill            | Purpose                          |
| ---------------- | -------------------------------- |
| `data-engineer`  | **Combined** - Database schemas, data models, ETL, data warehouse |
| `api-designer`   | REST/GraphQL APIs, OpenAPI specs |
| `data-analyst`   | Metrics, dashboards, insights    |

### Content & Documentation

| Skill                | Purpose                            |
| -------------------- | ---------------------------------- |
| `content-strategist` | Website copy, marketing, messaging |
| `technical-writer`   | Documentation, API docs, guides    |
| `demo-data-designer` | Realistic test/demo data           |

### Infrastructure & Platform

| Skill                     | Purpose                                      |
| ------------------------- | -------------------------------------------- |
| `platform-engineer`       | Docker, database setup, environment config   |
| `implementation-verifier` | Smoke test before QA (does it actually run?) |
| `observability-engineer`  | Logging, error tracking (Sentry), health checks |

### Operations & Reliability

| Skill                     | Purpose                                           |
| ------------------------- | ------------------------------------------------- |
| `reliability-engineer`    | **Combined** - SLOs, monitoring, backup/DR, incident management, audit logging |

### Implementation

| Skill                 | Purpose                           |
| --------------------- | --------------------------------- |
| `fullstack-developer` | Frontend + backend code, RBAC     |
| `ml-engineer`         | ML features, model training, AI integrations |

### Quality & Security

| Skill                      | Purpose                               |
| -------------------------- | ------------------------------------- |
| `qa-engineer`              | **Combined** - Testing, automation, performance, defect reports |
| `security-engineer`        | Security review, vulnerability checks |
| `accessibility-specialist` | WCAG compliance, a11y audit           |

### Legal & Compliance

| Skill                | Purpose                                      |
| -------------------- | -------------------------------------------- |
| `legal-compliance`   | **Combined** - Privacy policy, terms, GDPR/CCPA, cookie consent |

### Communications & Notifications

| Skill                 | Purpose                                   |
| --------------------- | ----------------------------------------- |
| `email-designer`      | Transactional email templates (React Email) |
| `notification-designer` | **Push, in-app, SMS notification systems** |

### Production Features (NEW)

| Skill                       | Purpose                                           |
| --------------------------- | ------------------------------------------------- |
| `file-media-handler`        | **File uploads, media processing, CDN** |
| `search-engineer`           | **Full-text search, faceted navigation, relevance** |
| `payment-integration-engineer` | **Payment flows, PCI compliance, subscriptions** |
| `feature-flag-manager`      | **A/B testing, progressive rollouts, experiments** |
| `i18n-designer`             | **Internationalization, localization, RTL support** |

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
│                  project-orchestrator (10 Gates + AGILE)                    │
│                                                                             │
│   ◄─────────────────── UPSTREAM FEEDBACK FLOWS ─────────────────────►      │
│   (Any skill can trigger changes to any earlier phase via UPFB-XXX)        │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ╔═══════════════════════════════════════════════════════════════════╗    │
│   ║                    PRODUCT DEFINITION PHASE                        ║    │
│   ║   ┌────────────────┐    ┌─────────────────────────────────────┐   ║    │
│   ║   │ PRODUCT INTAKE │ ─► │ PRODUCT DESIGN (3-Phase Flow)       │   ║    │
│   ║   │ (Gather info)  │    │  Strategy → CX → Design             │   ║    │
│   ║   └────────────────┘    └─────────────────────────────────────┘   ║    │
│   ╚═══════════════════════════════════════════════════════════════════╝    │
│                               ▼ [GATE 0: Product Design Complete?]         │
│                                                                             │
│   ╔═══════════════════════════════════════════════════════════════════╗    │
│   ║                    REQUIREMENTS & ARCHITECTURE                     ║    │
│   ║   BUSINESS ANALYST ──► SOLUTION ARCHITECT ──► DATA-ENGINEER       ║    │
│   ║                                              + API-DESIGNER        ║    │
│   ║                                              + LEGAL-COMPLIANCE    ║    │
│   ╚═══════════════════════════════════════════════════════════════════╝    │
│                               ▼ [GATE 1-2: Requirements + Arch OK?]        │
│                                                                             │
│   ╔═══════════════════════════════════════════════════════════════════╗    │
│   ║                    DESIGN PHASE                                    ║    │
│   ║   DESIGNER ──► PLATFORM-ENGINEER ──► COLLAB: Design+Dev           ║    │
│   ╚═══════════════════════════════════════════════════════════════════╝    │
│                               ▼ [GATE 3: Design + Infrastructure Ready?]   │
│                                                                             │
│   ╔═══════════════════════════════════════════════════════════════════╗    │
│   ║              ⚡ AUTOMATED IMPLEMENTATION PHASE ⚡                   ║    │
│   ║   FULLSTACK-DEVELOPER ───► CODE REVIEW ───► VERIFICATION          ║    │
│   ║        ▲                                         │                 ║    │
│   ║        └─────── Bug Fix Loop (automated) ────────┘                 ║    │
│   ║   PROJECT-TRACKER monitors RTM coverage throughout                 ║    │
│   ╚═══════════════════════════════════════════════════════════════════╝    │
│                               ▼ [GATE 4: Auto-pass if tests pass]          │
│                                                                             │
│   ╔═══════════════════════════════════════════════════════════════════╗    │
│   ║                    QA PHASE                                        ║    │
│   ║   QA-ENGINEER ◄──► DEVELOPER (Bug fixes, auto-routed)             ║    │
│   ╚═══════════════════════════════════════════════════════════════════╝    │
│                               ▼ [GATE 5: QA Complete?]                     │
│                                                                             │
│   ╔═══════════════════════════════════════════════════════════════════╗    │
│   ║                    RELEASE PHASE (Required Gates)                  ║    │
│   ║   BUSINESS ACCEPTANCE ──► SECURITY REVIEW ──► PRODUCT VALIDATION  ║    │
│   ║        (BA)                 (Security)          (Product Design)  ║    │
│   ╚═══════════════════════════════════════════════════════════════════╝    │
│                               ▼ [GATES 6-8: Cannot Skip]                   │
│                                                                             │
│   ╔═══════════════════════════════════════════════════════════════════╗    │
│   ║                    DEPLOY                                          ║    │
│   ║   RELEASE-MANAGER ──► PLATFORM-ENGINEER ──► DEPLOY ──► CHRONICLE  ║    │
│   ╚═══════════════════════════════════════════════════════════════════╝    │
│                               ▼ [GATE 9: Production OK?]                   │
│                                                                             │
│   LEGEND:  ──►  Forward flow    ⚡ Automated phase                          │
│            ╔═══╗ Phase boundary                                             │
└────────────────────────────────────────────────────────────────────────────┘
```

### Key Workflow Changes

| Change | Description |
|--------|-------------|
| **Product Intake First** | Orchestrator calls `product-intake` before anything else |
| **Product Design 3-Phase** | Strategy → CX → Design all within `product-design` skill |
| **Automated Implementation** | Dev iterations flow without manual gate checks |
| **Product Validation Gate** | `product-design` validates implementation before deploy |
| **Combined Skills** | Fewer skills, same coverage (data-engineer, legal-compliance, etc.) |

### Collaboration Sessions (Mandatory)

| Phase | Skills Involved | Purpose |
|-------|-----------------|---------|
| After Product Design | Product + BA + Designer | Align on scope before requirements |
| After Requirements | BA + Architect + Data + API | Technical feasibility check |
| During Design | Designer + Dev | Design-dev alignment |
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

Each phase must pass validation before proceeding (10 gates total):

| # | Gate | Pass Criteria |
| - | ---- | ------------- |
| **0** | **Product Design** | **50-100 features, all journeys mapped, MVP scope locked** |
| 1 | Requirements | All requirements have IDs, are testable, prioritized, RTM initialized |
| 2 | Architecture + Contracts | ADRs documented, schema + API defined, legal docs drafted |
| 3 | Design + Infrastructure | All flows covered, Docker starts, single-command setup works |
| **4** | **Implementation** | **Auto-pass if: tests pass, RTM 100% coverage** |
| 5 | QA | No critical defects, all requirements have test cases |
| **6** | **Business Acceptance** | **User stories validated (REQUIRED - cannot skip)** |
| **7** | **Security** | **No high/critical vulnerabilities (REQUIRED - cannot skip)** |
| **8** | **Product Validation** | **Product Design validates implementation matches design (REQUIRED)** |
| **9** | **Production Verification** | **Auth works, core journeys pass, health checks OK** |

### Automation Rules

| Phase | Automation Level | Manual Intervention |
|-------|------------------|---------------------|
| Product Intake | Semi-auto | User answers questions |
| Product Design | Semi-auto | User approves scope |
| Requirements | Semi-auto | User confirms requirements |
| Architecture | Semi-auto | Major decisions only |
| **Implementation** | **FULL AUTO** | Only if tests fail repeatedly |
| QA | Semi-auto | Bug triage if ambiguous |
| Release Gates | **Manual** | Business, Security, Product Validation required |

## Admin & RBAC (Role-Based Access Control)

Most apps with user accounts need admin functionality. The workflow now captures this early:

**Discovery Questions** (asked by orchestrator):
- Will users need accounts?
- What user roles are needed? (viewer, user, editor, admin)
- What can each role do?
- Is there an admin dashboard?

**Skills with RBAC guidance**:
- `business-analyst` - Captures role requirements
- `data-engineer` - Users table with role column, audit log
- `fullstack-developer` - Authorization middleware, admin routes
- `implementation-verifier` - Tests admin login works

## Business Acceptance Testing

After technical QA passes, the Business Analyst validates the product from a user perspective:

- **First Impressions Test**: Does the app load? Is purpose clear? Can user navigate?
- **User Story Validation**: Can users achieve their goals per acceptance criteria?
- **Requirements Traceability**: Does implementation match intent?
- **Problem-Solution Fit**: Does the product solve the original problem?

Results: **ACCEPT**, **REJECT**, or **CONDITIONAL** with issues routed to appropriate skills.

## Product Design (Central Authority)

The `product-design` skill is the **central authority** for the entire workflow. It:

1. **Defines WHAT to build** through three internal phases:
   - **Phase 1: Strategy** - Market research, competitive analysis, value proposition, business model
   - **Phase 2: CX** - Customer journey mapping, experience metrics, service blueprint
   - **Phase 3: Design** - Feature discovery, system completeness, MVP scope

2. **Validates implementation** at the end (Gate 8: Product Validation)

### Product Design Authority

| Decision Area | Authority Level |
|---------------|-----------------|
| Product vision | **Final** |
| Feature decisions | **Final** |
| MVP scope | **Final** |
| User journey completeness | **Final** |
| System completeness | **Final** |
| Technology approach | Advisory (architect decides) |

**Critical Rule**: If implementation doesn't match the product design, it's wrong.

### System Features Checklist

Product Design reviews ALL categories (expect 50-100 features for apps with auth):
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

## Continuous Flow Mode (Kanban)

For larger projects (30+ requirements), enable **continuous flow** where individual requirements progress through the pipeline independently:

```
┌──────────────────────────────────────────────────────────────────────────┐
│                     CONTINUOUS FLOW PIPELINE                               │
├──────────────────────────────────────────────────────────────────────────┤
│  BACKLOG    ANALYSIS    ARCHITECTURE    DESIGN    DEV    QA              │
│  ───────    ────────    ────────────    ──────    ───    ──              │
│  │WI-010│   │WI-007│    │ WI-005 │     │WI-003│  │WI-002│ │WI-001│       │
│  │WI-011│   │WI-008│    │ WI-006 │     │WI-004│  │      │ │      │       │
│  │ ...  │   │      │    │        │     │      │  │      │ │      │       │
│  └──────┘   └──────┘    └────────┘     └──────┘  └──────┘ └──────┘       │
│                                                                           │
│  WI-001 is in QA while WI-010 is still in backlog                        │
│  Each item progresses at its own pace                                    │
│  WIP limits prevent overloading any stage                                │
└──────────────────────────────────────────────────────────────────────────┘
```

### Benefits

- **Faster time-to-value**: Finished items ship sooner
- **Better visibility**: See bottlenecks immediately
- **Efficient resources**: No waiting for batch completion
- **Independent progress**: Items move at their own pace

### WIP Limits (Recommended)

| Stage | Limit | Why |
|-------|-------|-----|
| Analysis | 5 | BA can handle ~5 at once |
| Architecture | 3 | Complex, needs focus |
| Design | 5 | UX + UI can parallel |
| Development | 8 | Multiple devs possible |
| QA | 5 | Testing takes time |
| Review | 3 | Should be fast |

### Enabling Continuous Flow

The orchestrator automatically suggests continuous flow for projects with 30+ requirements. Or enable manually:

```
Use continuous flow mode for this project.
```

The `project-tracker` skill manages the Kanban board, RTM, and tracks each work item (WI-XXX) through the pipeline.

## Feedback Loops

Skills give feedback to each other:

```
QA finds bug              → Routes to Developer
Developer unclear         → Routes to BA for clarification
Security finds vuln       → Routes to Developer + Architect
Design issue found        → Routes to Designer
BA finds UX issue in BAT  → Routes to Designer
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
