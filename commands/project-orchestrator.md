---
description: Start a new project with full workflow orchestration
---

# Project Orchestrator

Start any new project with proper structure and guidance. This is the **single entry point** for new projects.

## What Happens

When you run `/project-orchestrator`, the system automatically:

1. **Product Intake** - Asks structured questions to gather requirements
2. **Product Design** - Runs 3-phase flow (Strategy → CX → Design)
3. **Requirements** - Business Analyst creates BRD, user stories, RTM
4. **Architecture** - Solution Architect designs system, creates ADRs
5. **Design** - UX/UI Designer creates flows, wireframes, specs
6. **Implementation** - Fullstack Developer builds with automated gates
7. **Quality** - QA Engineer tests, Security reviews
8. **Validation** - Product Design validates implementation matches design
9. **Release** - Deploy with full traceability

## Usage

```
/project-orchestrator
```

Or simply describe your project:

```
"I want to build a task management app for remote teams"
```

The orchestrator recognizes project intent and begins the structured workflow.

## Key Features

- **Automated Gates** - Implementation phase runs without manual validation each step
- **Continuous Flow** - Work items progress independently through pipeline
- **Feedback Loops** - Skills can send issues back to earlier phases
- **RTM Tracking** - Every requirement traced to implementation and tests
- **Chronicle Generation** - Visual HTML documentation at milestones

## Output

The orchestrator creates and maintains:

```
project-root/
├── PROJECT-STATUS.md          # Live status tracking
├── PROJECT-ANALYSIS.md        # Multi-angle analysis
├── PROJECT-PROFILE.md         # Skill requirements
├── docs/                      # All artifacts by phase
│   ├── discovery/
│   ├── product/
│   ├── requirements/
│   ├── architecture/
│   ├── design/
│   └── ...
├── FEEDBACK/                  # Feedback loop documents
└── chronicles/                # Generated HTML chronicles
```

Invoke `/development-workflow:project-orchestrator` or ask to "start a new project" to begin.
