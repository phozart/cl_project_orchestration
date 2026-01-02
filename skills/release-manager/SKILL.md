---
name: release-manager
description: Manage versioning, changelogs, release notes, and deployment coordination. Use before every release. Covers semantic versioning, automated changelogs, and release communication.
---

# Release Manager

Manage the release process from version numbering to user communication. Without release management, deployments become chaotic and users don't know what changed.

## When to Use This Skill

**Use before every release:**
- After QA passes all tests
- After Security review passes
- Before deployment to production
- When user says "prepare release", "changelog", "version bump"

---

## Input Validation

> See `_shared/TEMPLATES.md` for protocol. Apply these skill-specific checks:

**Required from QA/Security:** Test pass report, security review sign-off, list of changes since last release

**Quality Checks:**
- All tests passing?
- Security review completed?
- All changes documented?
- Breaking changes identified?

**Domain Questions:** Is version bump correct (major/minor/patch)? Are release notes user-friendly? Rollback plan ready?

**Upstream Feedback triggers:** Tests failing, security issues unresolved, undocumented changes → QA/Security/Developer

---

## Authority & Decision Rights

| Area | Authority Level |
|------|-----------------|
| Version numbering | Final |
| Changelog format | Final |
| Release notes content | Shared with Product |
| Release timing | Advisory (Product decides) |
| Rollback decisions | Shared with DevOps |

---

## Core Responsibilities

### 1. Semantic Versioning

Follow [semver.org](https://semver.org/):

```
MAJOR.MINOR.PATCH
  |     |     └── Bug fixes, no API changes
  |     └──────── New features, backward compatible
  └────────────── Breaking changes
```

| Change Type | Bump | Example |
|-------------|------|---------|
| Bug fix | PATCH | 1.2.3 → 1.2.4 |
| New feature (backward compatible) | MINOR | 1.2.3 → 1.3.0 |
| Breaking change | MAJOR | 1.2.3 → 2.0.0 |
| Pre-release | Suffix | 2.0.0-beta.1 |

### 2. Changelog Management

Maintain `CHANGELOG.md` using [Keep a Changelog](https://keepachangelog.com/) format:

```markdown
# Changelog

## [Unreleased]

### Added
- New feature description (#123)

### Changed
- Updated behavior description (#124)

### Fixed
- Bug fix description (#125)

## [1.2.0] - 2024-01-15

### Added
- User profile avatars (#120)
- Dark mode toggle (#118)

### Fixed
- Fixed crash on large file uploads (#116)

### Security
- Patched XSS vulnerability (#121)

[Unreleased]: https://github.com/user/repo/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/user/repo/compare/v1.1.0...v1.2.0
```

| Category | Use For |
|----------|---------|
| Added | New features |
| Changed | Changes to existing functionality |
| Deprecated | Features to be removed |
| Removed | Removed features |
| Fixed | Bug fixes |
| Security | Security patches |

### 3. Release Notes (User-Facing)

Transform technical changelog into user-friendly notes:

```markdown
# What's New in Version 1.2

**Released: January 15, 2024**

## Highlights

### Profile Pictures Are Here!
Upload a profile picture in Settings > Profile.

### Dark Mode
Toggle it in Settings > Appearance.

## Improvements
- Dashboard loads 50% faster

## Bug Fixes
- Large file uploads now work correctly

## Coming Soon
- Team collaboration features
```

### 4. Release Checklist

```markdown
# Release Checklist: v{{version}}

## Pre-Release
- [ ] All features merged
- [ ] All tests passing
- [ ] QA sign-off
- [ ] Security review completed
- [ ] Documentation updated

## Changelog & Notes
- [ ] CHANGELOG.md updated
- [ ] Release notes written
- [ ] Breaking changes documented
- [ ] Migration guide (if applicable)

## Version & Tag
- [ ] Version bumped in package.json
- [ ] Git tag created: v{{version}}
- [ ] Tag pushed to remote

## Deployment
- [ ] Staging deployment successful
- [ ] Staging smoke tests pass
- [ ] Rollback plan documented

## Communication
- [ ] Release notes published
- [ ] Users notified (if major)

## Post-Release
- [ ] Production smoke tests pass
- [ ] Monitoring dashboards checked
- [ ] Error rates normal
```

### 5. Rollback Procedure

**When to Rollback:**
- Critical bug affecting >10% of users
- Security vulnerability discovered
- Data corruption occurring

**Steps:**
1. Assess severity (P0 = immediate rollback)
2. Communicate (notify team, update status page)
3. Execute rollback (Vercel: `vercel rollback`, K8s: `kubectl rollout undo`)
4. Verify service restored
5. Schedule post-mortem within 48 hours

---

## Handoff to DevOps Engineer

**Package Contents:**
1. Updated CHANGELOG.md
2. Release notes document
3. Version bump commit
4. Git tag created
5. Release checklist completed
6. Rollback procedure documented

**Authorization:**
```markdown
## Release Authorization

**Version:** {{version}} | **Date:** {{date}}

### Approvals
- [ ] QA: Tests passing
- [ ] Security: Review completed
- [ ] Product: Features approved
- [ ] Release Manager: Checklist complete

### Decision
- [x] GO - Approved for deployment
- [ ] NO-GO - Reason: ___
```

---

## Integration with Workflow

```
[QA GATE PASS] → [SECURITY GATE PASS] → [RELEASE MANAGER] → [DEVOPS] → [CHRONICLER]
```

---

## Output Location

```
project-root/
├── CHANGELOG.md
├── RELEASE-NOTES.md
├── package.json              # Version field
└── docs/releases/
    ├── RELEASE-CHECKLIST.md
    ├── ROLLBACK-PROCEDURE.md
    └── v1.2.0/
        └── RELEASE-NOTES.md
```
