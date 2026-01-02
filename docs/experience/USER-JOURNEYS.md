# User Journeys: Plugin Scaffolding System

## Journey 1: Start New Project (Primary)

**Actor**: Claude Code user starting a new project with the plugin

### Current Flow (Pain)
```
User: "Start a new project for a task manager app"
Claude: *Generates full PROJECT-BRIEF.md from scratch* (500+ tokens)
Claude: *Generates full BRD.md from scratch* (800+ tokens)
Claude: *Creates docs/ folder manually, one by one*
User: *Waits while Claude writes boilerplate*
```

### Desired Flow (With Scaffolding)
```
User: "Start a new project for a task manager app"
Claude: *Invokes scaffold_docs_structure tool* → Instant folder tree
Claude: *Reads PROJECT-BRIEF.template.md* (already exists)
Claude: *Fills in only project-specific fields* (100 tokens)
User: *Gets structured project immediately*
```

### Journey Steps
| Step | Action | Tool/Template Used | Tokens Saved |
|------|--------|-------------------|--------------|
| 1 | Create docs structure | `scaffold_docs_structure` | N/A (automation) |
| 2 | Fill project brief | `PROJECT-BRIEF.template.md` | ~400 |
| 3 | Fill BRD | `BRD.template.md` | ~600 |
| 4 | Initialize RTM | `RTM.template.md` | ~300 |

---

## Journey 2: Skill Produces Output

**Actor**: A skill (e.g., business-analyst) producing documents

### Current Flow
```
Skill: *Writes full BRD structure from scratch each time*
Skill: *May forget sections or use inconsistent format*
Skill: *Spends tokens on boilerplate*
```

### Desired Flow
```
Skill: "Fill the BRD template at templates/docs/requirements/BRD.template.md"
Skill: *Only writes project-specific content*
Skill: *Template ensures completeness*
```

### Template Reference Pattern
```markdown
## In Skill Instructions:

When creating the BRD, use the template at:
`templates/docs/requirements/BRD.template.md`

Copy the template to `docs/requirements/BRD.md` and fill in:
- [ ] Project name and code
- [ ] Problem statement
- [ ] Requirements list (REQ-XXX)
- [ ] Acceptance criteria

DO NOT regenerate the template structure - it's already correct.
```

---

## Journey 3: Scaffold Code Project

**Actor**: User wanting to start a specific type of code project

### Desired Flow
```
User: "Create a Next.js frontend for this project"
Claude: *Reads code project template*
Claude: *Uses template as reference for structure*
Claude: *Creates files following the pattern*
```

### Code Templates Needed
| Project Type | Template Contents |
|--------------|-------------------|
| Next.js + TypeScript | package.json, tsconfig, app structure |
| FastAPI + Python | pyproject.toml, main.py, structure |
| Docker Compose | docker-compose.yml for full stack |

---

## Journey 4: Check Template Exists

**Actor**: Claude checking if a template is available

### Flow
```
Claude: *About to create docs/requirements/BRD.md*
Claude: *Checks templates/docs/requirements/BRD.template.md*
If exists: Copy and fill
If not: Generate from scratch (fallback)
```

---

## Journey 5: MCP Tool Invocation (Optional Enhancement)

**Actor**: Claude invoking scaffolding directly

### MCP Tools Flow
```
Claude: *Needs project structure*
Claude: <invoke tool="scaffold_project_structure" type="full"/>
Tool: *Creates all folders and copies all templates*
Claude: *Proceeds with project-specific content*
```

### Potential MCP Tools
| Tool | Purpose | Arguments |
|------|---------|-----------|
| `scaffold_docs_structure` | Create full docs/ tree | None or `--minimal` |
| `scaffold_from_template` | Copy specific template | `template_path`, `target_path` |
| `init_code_project` | Create code project | `type: nextjs|fastapi|docker` |

---

## Experience Metrics

### Token Efficiency
| Document | Without Template | With Template | Savings |
|----------|------------------|---------------|---------|
| PROJECT-BRIEF | ~500 tokens | ~100 tokens | 80% |
| BRD | ~800 tokens | ~200 tokens | 75% |
| RTM | ~400 tokens | ~50 tokens | 88% |
| Full docs structure | ~2000 tokens | ~100 tokens | 95% |

### Time Efficiency
| Task | Manual | With Scaffolding |
|------|--------|------------------|
| Create docs/ structure | 2-3 minutes | < 5 seconds |
| Fill BRD template | 5 minutes | 2 minutes |
| Start code project | 10 minutes | 1 minute |

---

## Pain Points Addressed

| Pain Point | Solution |
|------------|----------|
| Repetitive folder creation | One-command scaffold |
| Inconsistent document formats | Standardized templates |
| Token waste on boilerplate | Reference existing templates |
| Missing sections in documents | Templates are complete |
| Different patterns each session | Same template every time |
