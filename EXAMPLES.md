# Development Workflow Plugin - Examples

Simple prompts that let the skills do their job. Each skill has comprehensive built-in methodology - you just need to tell it what to work on.

---

## Quick Start

### New Product (Full Workflow)
```
Run /project-orchestrator for a task management app for remote teams
```

### Existing Codebase (Reverse Engineering)
```
Run /project-orchestrator in brownfield mode on /path/to/existing-app
```

That's it. The orchestrator handles the rest.

---

## By Scenario

### 1. Reverse Engineering

```
Analyze /path/to/codebase with codebase-archaeologist
```

```
Document the existing system at /path/to/project
```

```
Create architecture documentation for this legacy codebase
```

### 2. New Product Idea

```
I want to build a marketplace for local artisans
```

```
Help me define a product for [problem you're solving]
```

```
Start a new project for an AI-powered recipe app
```

### 3. UX/UI Design

```
Design the UI for a fitness tracking app
```

```
Create user flows and wireframes for an e-commerce checkout
```

```
I need UX design for a dashboard - here are the requirements: [paste or link]
```

### 4. Digital Product (Full Chain)

```
Run /project-orchestrator for a SaaS invoicing platform
```

```
Build a mobile app for event ticketing - full workflow
```

```
Create an API for a payment processing service
```

### 5. Physical Product (Full Chain)

```
Run /project-orchestrator for a smart home thermostat
```

```
Design a consumer electronics product - wireless earbuds
```

```
Develop a medical device for blood pressure monitoring
```

### 6. Innovation & R&D

```
Explore product opportunities in the pet care space
```

```
Is it technically feasible to build [describe approach]?
```

```
Run a design thinking session for improving hospital check-in
```

### 7. Marketing & Launch

```
Create a go-to-market strategy for [product]
```

```
Plan the launch for our new app releasing next month
```

### 8. Documentation

```
Create documentation for this project
```

```
Generate a project chronicle
```

---

## Single Skills

When you want just one skill without the full workflow:

| Need | Prompt |
|------|--------|
| Requirements | `Write requirements for [feature]` |
| Architecture | `Design the architecture for [system]` |
| API | `Design an API for [purpose]` |
| Database | `Create a data model for [domain]` |
| Security | `Security review for [target]` |
| Testing | `Create test plan for [feature]` |
| Legal | `Create privacy policy and terms for [product]` |

---

## Tips

**Less is more** - The skills have built-in methodology. A simple prompt lets them do comprehensive analysis.

**Trust the process** - Skills will ask clarifying questions if needed. You don't have to anticipate everything.

**Add context when relevant** - Point to existing docs if you have them:
```
Based on docs/requirements/BRD.md, design the architecture
```

**Request format when needed** - For stakeholder docs:
```
Export to DOCX format
```

---

## What Happens Behind the Scenes

When you say "Run /project-orchestrator for X", it automatically:

1. **Product Intake** - Gathers problem, users, constraints, success criteria
2. **Product Design** - Strategy, customer journeys, 50-100 features, MVP scope
3. **Requirements** - REQ-XXX catalogue, user stories, acceptance criteria
4. **Architecture** - System design, ADRs, API contracts, data model
5. **Design** - User flows, wireframes, design system
6. **Platform** - Docker, CI/CD, infrastructure
7. **Implementation** - Code generation with contract compliance
8. **QA** - Test cases, defect tracking, accessibility
9. **Security** - Vulnerability review, auth verification
10. **Release** - Changelog, documentation, deployment

Each phase has validation gates. The orchestrator enforces them.

You just provide the idea - the workflow handles the rest.
