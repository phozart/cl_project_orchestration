---
description: Start a new project with the development workflow orchestrator
---

# Start New Project

Use the project-orchestrator skill to begin a new project.

## Discovery Questions

Before creating any plans, ask the user:

1. **What are you building?**
   - Problem statement
   - Target users
   - Core functionality

2. **What's the scope?**
   - MVP vs full vision
   - Timeline constraints
   - Budget/resource constraints

3. **What does success look like?**
   - Key metrics
   - Must-have features
   - Nice-to-have features

4. **What are the constraints?**
   - Technology requirements
   - Compliance requirements
   - Integration requirements

## After Discovery

1. Create a Project Brief document
2. Determine required skills based on project type
3. Create a Skill Execution Plan
4. Begin with the first skill (usually product-strategist or business-analyst)
5. Track progress through quality gates

## Project Types

| Type | Skills Needed |
|------|---------------|
| New Product | All skills in sequence |
| New Feature | BA → Arch → Design → Dev → QA |
| Bug Fix | QA → Dev → QA |
| UI Redesign | UX → UI → Dev → QA |
| API Addition | BA → API → Dev → QA → Security |

Invoke `/development-workflow:start` or ask me to "start a new project" to begin.
