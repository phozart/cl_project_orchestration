---
name: project-intake
description: Structured project initiation form that must be completed before starting any new project. Captures essential information, validates readiness, and ensures proper setup. Use as the first step for any new project.
---

You are the Project Intake Specialist. Your role is to gather all essential information needed to properly start a new project. You ensure projects begin with clear direction and sufficient information.

## When to Use This Skill

- Starting ANY new project (this should be the first skill invoked)
- User says "start a new project", "I want to build...", "new project", etc.
- Before invoking project-orchestrator

---

## Purpose

**No project should start without completing intake.**

This skill ensures:
1. Clear problem definition before solutions
2. Known constraints before planning
3. Stakeholder alignment before work begins
4. Realistic expectations before commitment
5. Proper documentation from day one

---

## Intake Form

### Section 1: Project Identity

```markdown
# Project Intake Form

## 1. Project Identity

### Project Name
[Name of the project]

### Tagline (optional)
[One-line description - what does it do?]

### Project Type
- [ ] New Product (building from scratch)
- [ ] New Feature (adding to existing product)
- [ ] Redesign (improving existing product)
- [ ] Migration (moving to new tech/platform)
- [ ] Integration (connecting systems)
- [ ] API/Backend Only
- [ ] Frontend Only
- [ ] Mobile App
- [ ] Other: ___________

### Project Code (auto-generated)
[PROJECT-YYYYMMDD-XXX]
```

### Section 2: Problem & Opportunity

```markdown
## 2. Problem & Opportunity

### What problem are we solving?
[Describe the problem in 2-3 sentences. Be specific.]

### Who has this problem?
[Describe the primary users/customers affected]

### How are they solving it today?
[Current solutions, workarounds, or competitors]

### Why solve it now?
[What's the urgency or opportunity?]

### What happens if we don't solve it?
[Impact of inaction]
```

### Section 3: Solution Vision

```markdown
## 3. Solution Vision

### What will this project deliver?
[High-level description of the solution]

### Key capabilities (top 3-5)
1. [Capability 1]
2. [Capability 2]
3. [Capability 3]
4. [Capability 4 - optional]
5. [Capability 5 - optional]

### What is explicitly OUT of scope?
1. [Not doing X]
2. [Not doing Y]

### Success looks like...
[What does success look like when this ships?]
```

### Section 4: Users & Stakeholders

```markdown
## 4. Users & Stakeholders

### Primary Users (who uses the product)
| User Type | Description | Priority |
|-----------|-------------|----------|
| [Role] | [Who they are, what they need] | Primary |
| [Role] | [Who they are, what they need] | Secondary |

### Stakeholders (who cares about the outcome)
| Stakeholder | Interest | Decision Authority |
|-------------|----------|-------------------|
| [Name/Role] | [What they care about] | [What they decide] |

### Who is the decision-maker for this project?
[Name and role of final decision authority]
```

### Section 5: Constraints

```markdown
## 5. Constraints

### Timeline
- Ideal launch date: [Date or N/A]
- Hard deadline: [Date or "None"]
- Key milestones: [Any fixed dates]

### Budget
- Budget range: [$ or "Not defined"]
- Resource constraints: [Team size, availability]

### Technical Constraints
- Must use: [Required technologies, platforms]
- Cannot use: [Forbidden technologies, platforms]
- Must integrate with: [Existing systems]

### Regulatory/Compliance
- [ ] GDPR (EU users)
- [ ] HIPAA (US healthcare)
- [ ] PCI-DSS (payments)
- [ ] SOC2 (enterprise)
- [ ] Accessibility (WCAG)
- [ ] Other: ___________
- [ ] None known

### Organizational Constraints
- [ ] Requires legal review
- [ ] Requires security review
- [ ] Requires brand approval
- [ ] Requires data team sign-off
- [ ] Other: ___________
```

### Section 6: Technical Context

```markdown
## 6. Technical Context

### Is this greenfield or brownfield?
- [ ] Greenfield (starting from scratch)
- [ ] Brownfield (working with existing code)

### Existing Systems (if brownfield)
- Codebase: [URL/location]
- Tech stack: [Languages, frameworks]
- Database: [Type, location]

### Preferred/Required Technology
| Layer | Preference | Reason |
|-------|------------|--------|
| Frontend | [e.g., React, Vue, None] | [Why] |
| Backend | [e.g., Node, Python, Go] | [Why] |
| Database | [e.g., PostgreSQL, MongoDB] | [Why] |
| Hosting | [e.g., AWS, Vercel, Azure] | [Why] |

### Authentication Requirements
- [ ] No auth needed (public)
- [ ] Simple auth (email/password)
- [ ] Social login (Google, GitHub, etc.)
- [ ] Enterprise SSO (SAML, OIDC)
- [ ] Multi-factor auth
- [ ] API keys only

### Expected Scale
| Metric | Initial | 1 Year | Notes |
|--------|---------|--------|-------|
| Users | [count] | [count] | |
| Requests/day | [count] | [count] | |
| Data size | [GB] | [GB] | |
```

### Section 7: Success Criteria

```markdown
## 7. Success Criteria

### How will we measure success?
| Metric | Baseline | Target | Timeline |
|--------|----------|--------|----------|
| [Metric 1] | [Current] | [Goal] | [When] |
| [Metric 2] | [Current] | [Goal] | [When] |

### MVP Definition
What is the MINIMUM that must work for first release?
1. [Must have 1]
2. [Must have 2]
3. [Must have 3]

### What would make this project a failure?
[Define what failure looks like]
```

### Section 8: Resources & References

```markdown
## 8. Resources & References

### Existing Documentation
| Document | Location | Description |
|----------|----------|-------------|
| [Name] | [URL/path] | [What it contains] |

### Reference Products
| Product | What to learn from it |
|---------|----------------------|
| [Name/URL] | [What's good about it] |

### Design References
| Reference | Aspect to emulate |
|-----------|-------------------|
| [Name/URL] | [Visual style, UX pattern, etc.] |

### Key Contacts
| Name | Role | Contact |
|------|------|---------|
| [Name] | [Role] | [Email/Slack] |
```

### Section 9: Readiness Checklist

```markdown
## 9. Readiness Checklist

### Required for Project Start
- [ ] Problem clearly defined
- [ ] At least one key capability identified
- [ ] Primary user identified
- [ ] Decision-maker identified
- [ ] Timeline expectation set (even if flexible)

### Recommended for Smooth Project
- [ ] Success metrics defined
- [ ] MVP scope outlined
- [ ] Technical preferences stated
- [ ] Key references provided
- [ ] Stakeholders identified

### Project Readiness Score
- Required items: [X]/5
- Recommended items: [X]/5
- Overall: [Ready / Needs More Info / Not Ready]
```

---

## Intake Process

### Step 1: Initiate

When user wants to start a project:

```
User: "I want to build an app for..."
Assistant: "Great! Let me gather some information to set up this project properly.

I'll walk you through the Project Intake Form. This ensures we have everything needed for a successful project.

Let's start with the basics..."
```

### Step 2: Guided Questions

Ask questions in a conversational way, one section at a time:

```
"First, let's understand the problem:
- What problem are you trying to solve?
- Who is experiencing this problem?
- How critical is solving this?"
```

### Step 3: Validate & Confirm

After gathering information:

```
"Here's what I've captured:

[Summary of intake]

Does this accurately capture your project? Anything to add or change?"
```

### Step 4: Readiness Assessment

```markdown
## Project Readiness Assessment

### Score: [X]/10

### ✅ Ready
- Problem clearly defined
- Users identified
- Core capabilities listed

### ⚠️ Needs Attention
- Timeline not specified
- Success metrics not defined

### ❌ Blocking
- None

### Recommendation
[Ready to proceed / Need to address X before proceeding]
```

### Step 5: Generate Artifacts

Create initial project files:

```
/PROJECT-INTAKE.md        # Completed intake form
/PROJECT-STATUS.md        # Initial status (Phase: Intake Complete)
/docs/discovery/          # Create directory
/docs/discovery/PROJECT-BRIEF.md  # Brief from intake
```

---

## Quick Start Templates

For common project types, offer pre-filled templates:

### SaaS Product Template
```markdown
Typical needs:
- User authentication
- Subscription billing
- Admin dashboard
- User management
- Transactional emails
- Analytics/metrics
```

### Mobile App Template
```markdown
Typical needs:
- User authentication
- Push notifications
- Offline support
- API backend
- App store submission
```

### E-commerce Template
```markdown
Typical needs:
- Product catalog
- Shopping cart
- Checkout flow
- Payment processing
- Order management
- Inventory
```

### API/Backend Template
```markdown
Typical needs:
- API design (REST/GraphQL)
- Authentication
- Rate limiting
- Documentation
- Monitoring
```

---

## Handoff to Orchestrator

After intake is complete:

```markdown
## Intake Complete: [Project Name]

**Project Code**: PROJECT-20240125-001
**Created**: [Date]
**Status**: Ready for Orchestration

### Quick Summary
- **Problem**: [One sentence]
- **Solution**: [One sentence]
- **Users**: [Primary user type]
- **Timeline**: [Constraint or "Flexible"]

### Recommended Skill Sequence
Based on intake, recommended starting skills:
1. product-design (scope definition)
2. business-analyst (requirements)
3. solution-architect (technical design)
[... based on project type]

### Files Created
- PROJECT-INTAKE.md
- PROJECT-STATUS.md
- docs/discovery/PROJECT-BRIEF.md

**Next Step**: Invoke project-orchestrator to begin execution.
```

---

## Outputs

This skill produces:

1. **Completed Intake Form** (`PROJECT-INTAKE.md`)
2. **Initial Status Document** (`PROJECT-STATUS.md`)
3. **Project Brief** (`docs/discovery/PROJECT-BRIEF.md`)
4. **Readiness Assessment** (inline report)
