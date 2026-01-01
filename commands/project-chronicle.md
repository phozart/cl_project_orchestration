---
description: Generate a visual HTML chronicle documenting the complete project journey
---

# Project Chronicle

Generate a comprehensive, visually rich HTML file that documents the entire project journey from idea to validation.

## What Gets Generated

A single self-contained HTML file (`chronicles/PROJECT-CHRONICLE-[Name]-[Date].html`) containing:

### Sections
1. **Overview Dashboard** - Key metrics at a glance (phase, gates, days, artifacts)
2. **Journey Timeline** - Visual timeline of phases, gates, and milestones
3. **Artifact Gallery** - All documents organized by category with previews
4. **Decision Log** - ADRs and key decisions with full context
5. **Metrics Dashboard** - Gate stats, issue resolution, test coverage
6. **Architecture Diagrams** - System design, data model, sequences (Mermaid.js)
7. **Workflow Visualization** - Skill invocation sequence and dependencies

### Features
- Opens directly in any browser (no server needed)
- Dark/light theme toggle
- Print-friendly for PDF export
- Collapsible sections for progressive disclosure
- Shareable as a single file

## Usage

```
/project-chronicle              # Generate for current phase
/project-chronicle --full       # Include full artifact content
/project-chronicle --minimal    # Summary only
/project-chronicle --theme dark # Set default theme
```

## When to Use

- After completing a major phase
- When a quality gate passes
- At project milestones (MVP, release)
- To share project progress with stakeholders
- For project documentation and handoff

## Requirements

Before generating, ensure:
- Project Status document exists
- At least one phase has been completed
- Project brief is defined
- Some artifacts have been created

## Output Location

Chronicles are saved to:
```
project-root/
├── chronicles/
│   ├── PROJECT-CHRONICLE-[Name]-[Phase]-[Date].html
│   └── PROJECT-CHRONICLE-Latest.html  (symlink to most recent)
```

## Example

```
> /project-chronicle

Generating Project Chronicle...

Scanning:
  ✓ Project Status document found
  ✓ 12 artifacts discovered
  ✓ 3 gates completed
  ✓ 5 ADRs documented

Generating sections:
  ✓ Overview dashboard
  ✓ Journey timeline (8 events)
  ✓ Artifact gallery (12 documents)
  ✓ Decision log (5 ADRs)
  ✓ Metrics dashboard
  ✓ Architecture diagrams (3)
  ✓ Workflow visualization

Chronicle generated: chronicles/PROJECT-CHRONICLE-MyApp-Architecture-2024-01-25.html

Open in browser to view the complete project journey.
```

Invoke `/development-workflow:project-chronicle` or ask me to "generate project chronicle" to create one.
