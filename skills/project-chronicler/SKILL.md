---
name: project-chronicler
description: Generate a comprehensive, visually rich HTML chronicle documenting the complete project journey. Use when the project reaches milestones, after gate passes, or when the user requests /project-chronicle. Creates a self-contained HTML file with timeline, artifacts, decisions, metrics, and diagrams.
---

# Project Chronicler

Generate a static HTML file that captures the complete project journey from idea to validation, including timeline visualization, artifact gallery, decision log, metrics dashboard, and architecture diagrams.

## When to Use This Skill

**Manual Invocation:**
- User runs `/project-chronicle`
- User requests "document the project journey", "generate project report"

**Auto-Invocation by Orchestrator:**
- Project completes a major phase
- A quality gate passes or fails
- Project reaches MVP or release milestone

## Input Validation

> See `_shared/TEMPLATES.md` for protocol. Apply these skill-specific checks:

**Required from Orchestrator:** PROJECT-STATUS.md, gate history, artifact list
**Required from BA:** RTM.md (Requirements Traceability Matrix)
**If available:** Test results, security review, feedback logs

**Quality Checks:**
- Project status document exists and parseable?
- At least one phase completed?
- Sufficient data for meaningful visualization?

**Upstream Feedback triggers:**
- Missing project status -> Orchestrator
- RTM incomplete -> BA/Project Tracker

---

## Authority & Decision Rights

| Area | Authority Level |
|------|-----------------|
| Chronicle structure/layout | Final |
| Visual presentation | Final |
| Data aggregation approach | Final |
| Diagram generation | Final |
| What artifacts to include | Advisory (follows orchestrator) |

---

## Chronicle Sections

### 1. Header & Navigation
- Project name, status badge, generation timestamp
- Theme toggle (dark/light), sticky navigation, print button

### 2. Overview Dashboard
- Current phase indicator
- Gates passed / total
- Days in development
- Open issues count, artifact count

### 3. Journey Timeline
Visual vertical timeline:
- Phase start/end markers with dates
- Gate checkpoints (pass: green, fail: red, pending: amber)
- Key decisions and milestones
- Feedback loop events

### 4. Artifact Gallery
Collapsible cards by category:
- **Product**: Vision, Features, MVP, R&D
- **Requirements**: BRD, Catalogue, User Stories, RTM
- **Architecture**: ADRs, System Design, Tech Stack
- **Design**: User Flows, Wireframes, Design System
- **Quality**: Test Plans, Results, Defects
- **Security**: Review, Vulnerabilities

### 5. Requirements Traceability
**Critical section** - shows if project delivered what was promised:
- Coverage summary by priority (Must/Should/Could)
- Traceability table: REQ -> US -> Implementation -> Test -> Validation
- Gap analysis: missing implementations, tests, validations

### 6. Decision Log
- ADR entries with context, decision, consequences
- Feedback loop resolutions
- Requirement-linked justifications

### 7. Metrics Dashboard
CSS-only charts:
- Gate progress bar chart
- Issue resolution by severity
- Test pass/fail/skip percentages
- Days per phase visualization

### 8. Diagrams (Mermaid.js)
Auto-generated from architecture artifacts:
- System architecture (C4-style)
- Entity Relationship
- Sequence diagrams
- Deployment topology

---

## Document Sources

| Skill | Location | Files |
|-------|----------|-------|
| orchestrator | `./` | PROJECT-STATUS.md |
| product-design | `docs/product/` | Vision, Features, MVP |
| business-analyst | `docs/requirements/` | BRD, Catalogue, Stories |
| project-tracker | `docs/traceability/` | RTM.md |
| solution-architect | `docs/architecture/` | Design, Tech Stack, ADRs |
| designer | `docs/design/` | Flows, Wireframes, System |
| qa-engineer | `docs/testing/` | Plan, Results, Defects |
| security-engineer | `docs/security/` | SECURITY-REVIEW.md |
| feedback loops | `./FEEDBACK/` | FEEDBACK-*.md |

---

## Generation Process

1. **Scan** - Check PROJECT-STATUS.md exists, list all docs
2. **Read Status** - Extract phase, gates, issues, feedback
3. **Read Phase Docs** - For each completed phase, read artifacts
4. **Extract Metadata** - Title, status, summary, IDs, Mermaid blocks
5. **Build Cross-References** - Map REQ/ADR/TC/DEF IDs to sources
6. **Aggregate Metrics** - Gates, requirements, tests, defects
7. **Compile Diagrams** - Collect and validate Mermaid blocks
8. **Render HTML** - Apply template with all placeholders
9. **Write Output** - `chronicles/PROJECT-CHRONICLE-{Name}-{Phase}-{Date}.html`

---

## Design Principles

**Typography:**
- Display: Space Grotesk (headings)
- Body: IBM Plex Sans (content)
- Mono: JetBrains Mono (code, IDs)

**Color Palette (Dark Mode Default):**
```css
--bg-primary: #0f172a;
--bg-secondary: #1e293b;
--text-primary: #f1f5f9;
--accent-success: #22c55e;
--accent-warning: #f59e0b;
--accent-error: #ef4444;
```

**Visual Guidelines:**
- NO generic AI aesthetics
- Progressive disclosure via collapsible sections
- Semantic color use
- Responsive layout, print-optimized

---

## Technical Constraints

- **Self-Contained**: Single HTML file, no build step
- **External Dependencies**: Only Mermaid.js via CDN
- **JavaScript**: Vanilla JS only
- **Browsers**: Chrome, Firefox, Safari, Edge
- **File Size**: Target < 500KB

---

## Handling Missing Data

| Missing | Behavior |
|---------|----------|
| PROJECT-STATUS.md | **ERROR** - Cannot generate |
| docs/discovery/* | Show "Discovery not documented" |
| docs/architecture/ADR/* | Show "No decisions documented" |
| docs/qa/* | Show "QA pending" |
| Mermaid diagrams | Show placeholder message |

Never fail silently - always indicate what's missing.

---

## ID Pattern Recognition

| Pattern | Meaning |
|---------|---------|
| REQ-XXX | Requirement |
| ADR-XXX | Architecture Decision |
| TC-XXX | Test Case |
| DEF-XXX | Defect |
| FEEDBACK-XXX | Feedback Item |
| US-XXX | User Story |

Build cross-references by scanning for these patterns.

---

## Output

**File**: `chronicles/PROJECT-CHRONICLE-[Name]-[Phase]-[YYYY-MM-DD].html`

A self-contained HTML file that:
- Opens directly in any browser
- Supports dark/light theme toggle
- Is print-friendly for PDF export
- Can be shared as a standalone file
