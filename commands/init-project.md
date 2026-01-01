---
name: init-project
description: Initialize a new project with the structured intake form
---

# Initialize New Project

Start a new project with proper intake and setup.

## What This Command Does

1. Invokes the `project-intake` skill
2. Walks you through structured questions
3. Creates initial project documents
4. Assesses project readiness
5. Prepares for orchestration

## Usage

```
/init-project
```

Or with a quick description:

```
/init-project A task management app for remote teams
```

## Process

1. **Gather Information** - Answer questions about problem, users, constraints
2. **Validate** - Confirm captured information is correct
3. **Assess Readiness** - Check if enough information to proceed
4. **Create Files** - Generate PROJECT-INTAKE.md, PROJECT-STATUS.md, PROJECT-BRIEF.md
5. **Handoff** - Ready for `/start` to begin orchestration

## Output

```
project-root/
├── PROJECT-INTAKE.md      # Completed intake form
├── PROJECT-STATUS.md      # Initial status document
└── docs/
    └── discovery/
        └── PROJECT-BRIEF.md  # Project brief
```

## Next Steps

After `/init-project` completes:

```
/start                    # Begin full project orchestration
```

Or start with specific skills:

```
Use the product-design skill to define features
```
