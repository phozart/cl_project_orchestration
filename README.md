# Development Workflow Plugin

A comprehensive Claude Code plugin providing 48+ specialized skills for end-to-end product development. Covers strategy, **product design**, architecture, infrastructure, implementation, **observability**, **operations** (SRE, backup, incident management), verification, testing, validation, security, **legal compliance**, **payments**, **notifications**, **search**, **i18n**, **feature flags**, **SVG design**, **project intake**, and **release management** with **12 quality gates**, **requirements traceability**, **project analysis**, **continuous flow (Kanban)**, **work item tracking**, **parallel work streams**, **blocking/restart protocols**, and **developer entertainment mode**.

**Three modes of operation:**
- **Full Project Mode** - End-to-end orchestration from idea to production
- **Continuous Flow Mode** - Kanban-style parallel item processing for larger projects
- **Standalone Mode** - Call individual skills directly for specific tasks

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

Start any project with proper intake:

```
/init-project
```

This walks you through structured questions and then:

```
/start
```

The orchestrator will:

1. Conduct multi-angle project analysis
2. Determine which skills and agents are needed
3. Create a skill execution plan
4. Enable continuous flow (items progress independently)
5. Validate outputs at each quality gate
6. Route feedback between skills
7. Track progress to completion
8. Generate project chronicle documentation

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
Use the data-architect skill to design a schema for user subscriptions.
```

#### Common Standalone Use Cases

| Task | Skill to Use | Example Prompt |
|------|--------------|----------------|
| **Create icons/logos** | `svg-designer` | "Create a logo for my app called TaskFlow" |
| **Design database** | `data-architect` | "Design a schema for an e-commerce product catalog" |
| **Write tests** | `qa-engineer` | "Create test cases for user registration" |
| **Review security** | `security-engineer` | "Review this API for security vulnerabilities" |
| **Design API** | `api-designer` | "Design REST endpoints for a booking system" |
| **Create UI specs** | `ui-designer` | "Create a design system for a fintech app" |
| **Write user stories** | `business-analyst` | "Write user stories for a password reset feature" |
| **Plan monitoring** | `site-reliability-engineer` | "Design SLOs for my API" |
| **Create email templates** | `email-designer` | "Create a welcome email template" |
| **Setup notifications** | `notification-designer` | "Design push notification strategy for my app" |

#### Skill Chaining (Manual Pipeline)

You can also chain skills manually for a focused workflow:

```
1. Use the ux-designer skill to create user flows for checkout
2. Use the ui-designer skill to create wireframes based on those flows
3. Use the svg-designer skill to create icons needed in the wireframes
```

## Commands

| Command | Purpose |
| ------- | ------- |
| `/init-project` | **Start a new project with structured intake form** |
| `/start` | Start project orchestration (after intake) |
| `/project-chronicle` | Generate project documentation |
| `/project-chronicle --full` | Include all artifact content |
| `/project-chronicle --minimal` | Summary only |
| `/project-chronicle --theme dark` | Set default theme |
| `/plan-next-release` | **Plan iteration from MVP to v2, v3, etc.** |
| `/plan-next-release --hotfix` | Plan bug fix release |
| `/plan-next-release --minor` | Plan feature release |
| `/plan-next-release --major` | Plan major version release |

## Skills (48+ Total)

### Meta/Management

| Skill                  | Purpose                                        |
| ---------------------- | ---------------------------------------------- |
| `project-orchestrator` | Coordinates entire workflow, enforces 12 gates, **multi-angle project analysis**, **continuous flow mode** |
| `project-chronicler`   | Generates HTML documentation of project journey |
| `project-intake`       | **Structured project initiation form, kickoff questions** |
| `work-item-tracker`    | **Kanban board, WIP limits, item-level tracking, bottleneck detection** |
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
| `svg-designer`         | **Icons, logos, illustrations, visual assets** |

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

### Infrastructure & Platform

| Skill                     | Purpose                                      |
| ------------------------- | -------------------------------------------- |
| `platform-engineer`       | Docker, database setup, environment config   |
| `implementation-verifier` | Smoke test before QA (does it actually run?) |
| `observability-engineer`  | Logging, error tracking (Sentry), health checks |

### Operations & Reliability (NEW)

| Skill                     | Purpose                                           |
| ------------------------- | ------------------------------------------------- |
| `site-reliability-engineer` | **SLOs, monitoring, alerting, on-call** |
| `backup-recovery-engineer` | **Backup strategies, disaster recovery, RTO/RPO** |
| `incident-manager`         | **Runbooks, incident response, post-mortems** |
| `audit-logging-engineer`   | **Audit trails, compliance logging, data tracking** |

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

The `work-item-tracker` skill manages the Kanban board and tracks each work item (WI-XXX) through the pipeline.

## Developer Entertainment Mode

**Long implementations can be tedious. Stay engaged with fun interactions!**

The plugin includes an entertainment system to keep developers engaged during long-running operations:

### Features

| Feature | Description |
|---------|-------------|
| **Fun Facts** | Tech history, coding trivia during waits |
| **Achievements** | Celebrate milestones ("Gate Crusher!", "Zero Defects!") |
| **Developer Jokes** | Clean humor for coffee breaks |
| **Progress Celebrations** | Phase completion announcements |
| **Patience Rewards** | Stretch reminders, wisdom quotes |
| **Mini-Games** | Code golf challenges during very long waits |

### Configuration

```
/config entertainment --level fun    # Default - occasional fun facts
/config entertainment --level jokes  # Add developer jokes
/config entertainment --level full   # Maximum engagement
/config entertainment --off          # Serious mode only
```

### Example Achievement

```
🏆 **Achievement Unlocked: Gate Crusher!**
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
You passed the Requirements Gate on the first attempt!
Only 34% of projects achieve this. Excellent planning!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Example Fun Fact

```
💡 **Did You Know?**
The first computer bug was an actual bug - a moth found in a Harvard Mark II
computer in 1947. Grace Hopper taped it to the log book, noting "First actual
case of bug being found."
```

The entertainment system is non-blocking, respects preferences, and can be disabled for serious/client-visible sessions.

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
