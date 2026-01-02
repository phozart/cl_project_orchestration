# Product Vision: Plugin Scaffolding System

## Vision Statement
Transform the development-workflow-plugin from an instruction-only system to an **instruction + automation** system that creates project structures, templates, and boilerplate instantly.

## Value Proposition

### For Claude Code Users
> "Instead of Claude generating the same BRD template structure every time, it references a template and fills in only the project-specific parts - saving tokens and ensuring consistency."

### Key Benefits
| Benefit | Before | After |
|---------|--------|-------|
| **Speed** | Minutes to create folder structure | Seconds (one command) |
| **Consistency** | Varies by session | Identical every time |
| **Token Usage** | Claude generates full templates | Claude fills templates |
| **Quality** | Miss things, inconsistent | Complete, standardized |

## Strategic Positioning

### What This Is
- A **scaffolding layer** for the existing plugin
- **Templates** skills can reference (not regenerate)
- **Automation tools** Claude can invoke directly
- **Examples** that show correct patterns

### What This Is NOT
- A replacement for skills (skills still guide the work)
- An external dependency (everything ships with plugin)
- A complex build system (simple, readable files)

## Success Metrics

| Metric | Target | How to Measure |
|--------|--------|----------------|
| Manual file creations | < 5 per project | Count file writes not in templates/ |
| Template coverage | 100% of skill outputs | Audit skills vs templates |
| Token reduction | 50%+ for scaffolding | Compare before/after |
| User adoption | Friends use it | Informal feedback |

## Key Differentiators

1. **Native Integration** - Works within Claude Code plugin system, not external
2. **Token-Efficient** - Designed to reduce, not increase, Claude token usage
3. **Offline** - No external APIs or dependencies
4. **Simple** - Plain files, easy to understand and modify
5. **Complete** - Covers all 34 skills' outputs

## Business Model
- **Free** (MIT License)
- **Open Source** (GitHub)
- **Personal + Public** distribution

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Templates become stale | Medium | Version with skills |
| MCP adds complexity | Medium | Make MCP optional |
| Overhead > savings | High | Measure token usage |
| Breaks existing workflow | High | Additive only, don't change skills |
