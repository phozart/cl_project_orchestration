# Development Workflow Plugin

A comprehensive Claude Code plugin providing 26+ specialized skills for end-to-end product development. Covers strategy, design, architecture, implementation, testing, validation, and security with quality gates and feedback loops.

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

## Skills (26 Total)

### Meta/Management

| Skill                  | Purpose                                     |
| ---------------------- | ------------------------------------------- |
| `project-orchestrator` | Coordinates entire workflow, enforces gates |
| `project-chronicler`   | Generates HTML documentation of project journey |

### Strategy & Research

| Skill                | Purpose                                     |
| -------------------- | ------------------------------------------- |
| `product-strategist` | Market research, business model, validation |
| `ux-researcher`      | User interviews, usability testing          |
| `cx-strategist`      | Customer journey, touchpoints, NPS          |

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

### Implementation

| Skill                 | Purpose                           |
| --------------------- | --------------------------------- |
| `fullstack-developer` | Frontend + backend code           |
| `devops-engineer`     | CI/CD, infrastructure, deployment |

### Quality & Security

| Skill                      | Purpose                               |
| -------------------------- | ------------------------------------- |
| `qa-engineer`              | Testing, defect reports, sign-off     |
| `security-engineer`        | Security review, vulnerability checks |
| `accessibility-specialist` | WCAG compliance, a11y audit           |
| `test-automation-engineer` | CI/CD test pipelines                  |
| `performance-engineer`     | Load testing, optimization            |

### Compliance

| Skill                | Purpose                    |
| -------------------- | -------------------------- |
| `compliance-analyst` | Privacy, legal, regulatory |

## Agents

Pre-configured agents for common workflows:

| Agent            | Purpose                                 |
| ---------------- | --------------------------------------- |
| `project-lead`   | Orchestrates full development workflow  |
| `code-developer` | Implements features with best practices |
| `qa-reviewer`    | Verifies quality before release         |

## Workflow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                     project-orchestrator                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   [DISCOVERY] ──→ [STRATEGY] ──→ [REQUIREMENTS] ──→ [ARCH]      │
│                                         │                        │
│                                    [GATE 1: Requirements OK?]    │
│                                         │                        │
│   [DATA + API] ←────────────────────────┘                       │
│        │                                                         │
│   [GATE 2: Contracts OK?]                                        │
│        │                                                         │
│   [UX] ──→ [UI] ──→ [INTERACTION] ──→ [CONTENT]                 │
│        │                                                         │
│   [GATE 3: Design OK?]                                           │
│        │                                                         │
│   [IMPLEMENTATION] ──→ [DOCS]                                    │
│        │                                                         │
│   [GATE 4: Code OK?]                                             │
│        │                                                         │
│   [QA] + [ACCESSIBILITY] + [PERFORMANCE]                         │
│        │                                                         │
│   [GATE 5: QA OK?] ←── First Launch Protocol                     │
│        │                                                         │
│   [BUSINESS ACCEPTANCE TESTING] ←── BA validates user stories    │
│        │                                                         │
│   [GATE 6: Business Acceptance OK?]                              │
│        │                                                         │
│   [SECURITY]                                                     │
│        │                                                         │
│   [GATE 7: Security OK?]                                         │
│        │                                                         │
│   [DEVOPS] ──→ [DEPLOY] ──→ [CHRONICLE] ──→ [DONE]              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Quality Gates

Each phase must pass validation before proceeding:

| Gate | Pass Criteria |
| ---- | ------------- |
| Requirements | All requirements have IDs, are testable, prioritized |
| Architecture | ADRs documented, no TBDs, security addressed |
| Design | All flows covered, accessible, responsive |
| Implementation | Tests pass, no linting errors, documented |
| QA | No critical defects, First Launch Protocol passes |
| Business Acceptance | User stories validated from real user perspective |
| Security | No high/critical vulnerabilities |

## Business Acceptance Testing

After technical QA passes, the Business Analyst validates the product from a user perspective:

- **First Impressions Test**: Does the app load? Is purpose clear? Can user navigate?
- **User Story Validation**: Can users achieve their goals per acceptance criteria?
- **Requirements Traceability**: Does implementation match intent?
- **Problem-Solution Fit**: Does the product solve the original problem?

Results: **ACCEPT**, **REJECT**, or **CONDITIONAL** with issues routed to appropriate skills.

## Document Output Structure

Skills produce artifacts in standardized locations for traceability:

```
docs/
├── discovery/           # Product Strategist outputs
│   ├── PROJECT-BRIEF.md
│   ├── MARKET-ANALYSIS.md
│   ├── COMPETITIVE-ANALYSIS.md
│   └── BUSINESS-MODEL.md
├── requirements/        # Business Analyst outputs
│   ├── BRD.md
│   ├── REQUIREMENTS-CATALOGUE.md
│   └── USER-STORIES.md
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
