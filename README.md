# Development Workflow Plugin

A comprehensive Claude Code plugin providing 25+ specialized skills for end-to-end product development. Covers strategy, design, architecture, implementation, testing, and security with quality gates and feedback loops.

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

## Skills (25 Total)

### Meta/Management

| Skill                  | Purpose                                     |
| ---------------------- | ------------------------------------------- |
| `project-orchestrator` | Coordinates entire workflow, enforces gates |

### Strategy & Research

| Skill                | Purpose                                     |
| -------------------- | ------------------------------------------- |
| `product-strategist` | Market research, business model, validation |
| `ux-researcher`      | User interviews, usability testing          |
| `cx-strategist`      | Customer journey, touchpoints, NPS          |

### Requirements & Architecture

| Skill                | Purpose                             |
| -------------------- | ----------------------------------- |
| `business-analyst`   | Requirements, BRD, user stories     |
| `solution-architect` | System design, ADRs, tech decisions |

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
│                                    [GATE: OK?]                   │
│                                         │                        │
│   [DATA + API] ←────────────────────────┘                       │
│        │                                                         │
│   [GATE: Contracts OK?]                                          │
│        │                                                         │
│   [UX] ──→ [UI] ──→ [INTERACTION] ──→ [CONTENT]                 │
│        │                                                         │
│   [GATE: Design OK?]                                             │
│        │                                                         │
│   [IMPLEMENTATION] ──→ [DOCS]                                    │
│        │                                                         │
│   [GATE: Code OK?]                                               │
│        │                                                         │
│   [QA] + [ACCESSIBILITY] + [PERFORMANCE]                         │
│        │                                                         │
│   [GATE: Quality OK?]                                            │
│        │                                                         │
│   [SECURITY]                                                     │
│        │                                                         │
│   [GATE: Security OK?]                                           │
│        │                                                         │
│   [DEVOPS] ──→ [DEPLOY] ──→ [DONE]                              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Quality Gates

Each phase must pass validation before proceeding:

| Gate           | Pass Criteria                                        |
| -------------- | ---------------------------------------------------- |
| Requirements   | All requirements have IDs, are testable, prioritized |
| Architecture   | ADRs documented, no TBDs, security addressed         |
| Design         | All flows covered, accessible, responsive            |
| Implementation | Tests pass, no linting errors, documented            |
| Quality        | No critical defects, requirements verified           |
| Security       | No high/critical vulnerabilities                     |

## Feedback Loops

Skills give feedback to each other:

```
QA finds bug         → Routes to Developer
Developer unclear    → Routes to BA for clarification
Security finds vuln  → Routes to Developer + Architect
Design issue found   → Routes to UX/UI Designer
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

## License

MIT - Feel free to use, modify, and share.

## Contributing

Pull requests welcome. For major changes, please open an issue first.
