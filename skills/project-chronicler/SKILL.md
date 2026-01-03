---
name: project-chronicler
description: This skill should be used when invoked by project-orchestrator at Gate 6, or when the user asks to "generate chronicle", "document the project", "/project-chronicle", or needs project documentation. Creates a COMPREHENSIVE HTML documentation suite including timeline, artifacts, decisions, diagrams, persona galleries, interactive flows, capability matrices, and user guide summaries.
---

# Project Chronicler - Full Documentation Generator

Generate a comprehensive, self-contained HTML documentation suite that captures the complete project from idea to validation. Beyond a simple timeline, this produces a **complete product documentation package** suitable for stakeholders, users, and future developers.

## Full Documentation Suite

This skill produces documentation that includes:
- **Project Journey** - Timeline, gates, milestones
- **Persona Galleries** - Visual persona cards with demographics, goals, pain points
- **User Journey Visualization** - Interactive flow diagrams
- **Feature-Capability Matrix** - Requirements mapped to delivered features
- **Design System Summary** - Colors, typography, components
- **Architecture Overview** - System diagrams with explanations
- **User Guide Summary** - Key how-tos embedded from documentation
- **Release Information** - What shipped, what's next

## When to Use This Skill

**Manual Invocation:**
- User runs `/project-chronicle`
- User requests "document the project journey", "generate project report"

**Auto-Invocation by Orchestrator:**
- Project completes a major phase
- A quality gate passes or fails
- Project reaches MVP or release milestone

## Input Validation

> See `_templates/TEMPLATES.md` for protocol. Apply these skill-specific checks:

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

### 9. Persona Gallery (NEW)
Visual persona cards from UX research:
```html
<!-- Persona Card Template -->
<div class="persona-card">
  <div class="persona-avatar">[Generated avatar or placeholder]</div>
  <h3>Sarah, Marketing Manager</h3>
  <div class="persona-demographics">
    <span class="age">34 years old</span>
    <span class="location">San Francisco, CA</span>
  </div>
  <div class="persona-quote">"I need to see ROI on every tool we use."</div>
  <div class="persona-section">
    <h4>Goals</h4>
    <ul><li>Streamline campaign management</li></ul>
  </div>
  <div class="persona-section">
    <h4>Pain Points</h4>
    <ul><li>Too many disconnected tools</li></ul>
  </div>
  <div class="persona-section">
    <h4>Behaviors</h4>
    <ul><li>Checks metrics daily</li></ul>
  </div>
</div>
```

### 10. User Journey Visualization (NEW)
Interactive journey maps from service-designer/designer:
- Step-by-step flow with emotional indicators
- Touchpoint icons (web, email, app, phone)
- Pain point and delight markers
- Connection to personas

### 11. Feature-Capability Matrix (NEW)
Maps requirements to delivered capabilities:
```markdown
| Requirement | Feature | Status | Evidence |
|-------------|---------|--------|----------|
| REQ-001: User login | Auth Module | ✅ Implemented | auth/login.ts:45 |
| REQ-002: Dashboard | Dashboard | ✅ Implemented | pages/dashboard.tsx |
| REQ-003: Export | Export Module | 🚧 Partial | export/csv.ts |
```

### 12. Design System Summary (NEW)
Embedded design tokens and component preview:
- Color palette with hex/rgb values
- Typography scale
- Spacing system
- Key component examples (buttons, cards, forms)
- Icon library preview

### 13. Quick Start Guide (NEW)
Embedded from user-guide-writer:
- Installation steps
- First-time setup
- Key features with screenshots
- Common tasks

### 14. Release Information (NEW)
- Current version and release date
- Key features shipped
- Known limitations
- Roadmap preview (next 2-3 releases)
- Migration notes (if applicable)

---

## Document Sources

| Skill | Location | Files | Chronicle Section |
|-------|----------|-------|-------------------|
| orchestrator | `./` | PROJECT-STATUS.md | Overview, Timeline |
| product-design | `docs/product/` | Vision, Features, MVP | Overview, Features |
| ux-researcher | `docs/research/` | Personas, Journeys | Persona Gallery, Journeys |
| business-analyst | `docs/requirements/` | BRD, Catalogue, Stories | Requirements, Matrix |
| project-tracker | `docs/traceability/` | RTM.md | Traceability |
| solution-architect | `docs/architecture/` | Design, Tech Stack, ADRs | Architecture, Decisions |
| designer | `docs/design/` | Flows, Wireframes, System | Design System, Journeys |
| service-designer | `docs/service-design/` | Blueprints, Journeys | Journey Visualization |
| user-guide-writer | `docs/user-guide/` | Quick Start, How-tos | Quick Start Guide |
| release-manager | `docs/releases/` | CHANGELOG, Notes | Release Information |
| qa-engineer | `docs/testing/` | Plan, Results, Defects | Metrics, Quality |
| security-engineer | `docs/security/` | SECURITY-REVIEW.md | Security |
| marketing-strategist | `docs/marketing/` | Messaging, Positioning | Product Overview |
| feedback loops | `./FEEDBACK/` | FEEDBACK-*.md | Decisions |

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

### Primary Output
**File**: `chronicles/PROJECT-CHRONICLE-[Name]-[Phase]-[YYYY-MM-DD].html`

A self-contained HTML file that:
- Opens directly in any browser
- Supports dark/light theme toggle
- Is print-friendly for PDF export
- Can be shared as a standalone file

### Chronicle Variants

| Variant | Command | Content |
|---------|---------|---------|
| **Full** | `/project-chronicle --full` | All sections, embedded artifacts |
| **Minimal** | `/project-chronicle --minimal` | Summary, timeline, key metrics only |
| **Stakeholder** | `/project-chronicle --stakeholder` | Business-focused, no technical details |
| **Developer** | `/project-chronicle --developer` | Technical focus, architecture, code refs |
| **User** | `/project-chronicle --user` | User-facing, journeys, guides, features |

### Interactive Features
- **Navigation**: Sticky sidebar with section links
- **Search**: Full-text search across all content
- **Filters**: Filter by phase, status, persona
- **Zoom**: Click diagrams to enlarge
- **Print**: Optimized print styles, page breaks

### Export Options
- **HTML**: Self-contained, shareable file
- **PDF**: Print dialog → Save as PDF
- **JSON**: `/project-chronicle --json` for data export
