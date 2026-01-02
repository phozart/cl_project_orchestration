# Project Brief: Plugin Scaffolding System

## Product Code
PLUGIN-SCAFFOLD-20260102-001

## Problem Statement
The development-workflow-plugin provides 34 specialized skills with detailed instructions, but users must manually create all file structures, templates, and boilerplate code. This results in:
- Repetitive manual work creating `docs/` folder hierarchies
- Inconsistent document structures across projects
- Wasted Claude tokens re-explaining the same patterns
- Slower project initialization

## Target Users
1. **Primary**: The plugin author (personal productivity)
2. **Secondary**: Friends and colleagues who use the plugin
3. **Tertiary**: Public Claude Code users (MIT license, free distribution)

## Solution Vision
Add a scaffolding system that automates repetitive project setup tasks through:
- Pre-built templates for documents and code
- Reusable examples that skills can reference
- Efficient patterns that minimize token usage while maximizing output

## Success Definition
- Projects initialize faster (fewer manual file creations)
- Consistent document structures across all projects
- Reduced token usage through template references
- Skills can invoke scaffolding directly

## Scope

### In Scope (MVP)
1. Document templates (`docs/` folder structure)
2. Template files for BRD, RTM, ADRs, user stories, etc.
3. Code scaffolding templates (common project types)
4. MCP server integration (if beneficial for efficiency)
5. Helper scripts for common operations

### Out of Scope
- External API dependencies
- Heavy npm packages
- Features that don't improve Claude efficiency

## Constraints
| Constraint | Description |
|------------|-------------|
| Token Efficiency | Must reduce, not increase, token usage |
| Speed | Must accelerate project setup |
| Portability | Must work as part of plugin (no external deps) |
| License | MIT - free for all |

## Key Metrics
| Metric | Current | Target |
|--------|---------|--------|
| Manual file creations per project | ~20-30 | <5 |
| Token usage for scaffolding | High (instructions each time) | Low (reference templates) |
| Time to project structure | Minutes | Seconds |

## Technical Context
- **Platform**: Claude Code plugin
- **Integration**: MCP servers, skills, commands
- **Distribution**: Directory-based plugin installation
