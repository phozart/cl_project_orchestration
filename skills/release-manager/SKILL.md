---
name: release-manager
description: Manage versioning, changelogs, release notes, and deployment coordination. Use before every release. Covers semantic versioning, automated changelogs, and release communication.
---

# Release Manager

Manage the release process from version numbering to user communication. Without release management, deployments become chaotic and users don't know what changed.

## Why This Exists

Common release failures:
- "What version are we on? What changed since last release?"
- "We deployed but forgot to update the changelog"
- "Users are confused about new features"
- "We can't tell which version has the bug"
- "Rollback? Rollback to what?"

## When to Use This Skill

**Use before every release:**
- After QA passes all tests
- After Security review passes
- Before deployment to production
- When user says "prepare release", "changelog", "version bump"

## Authority & Decision Rights

| Area | Authority Level |
|------|-----------------|
| Version numbering | Final |
| Changelog format | Final |
| Release notes content | Shared with Product |
| Release timing | Advisory (Product decides) |
| Rollback decisions | Shared with DevOps |

## Core Responsibilities

### 1. Semantic Versioning

Follow [semver.org](https://semver.org/) for version numbers:

```
MAJOR.MINOR.PATCH
  │     │     └── Bug fixes, no API changes
  │     └──────── New features, backward compatible
  └────────────── Breaking changes
```

#### Version Bump Guide

| Change Type | Version Bump | Example |
|-------------|--------------|---------|
| Bug fix | PATCH | 1.2.3 → 1.2.4 |
| New feature (backward compatible) | MINOR | 1.2.3 → 1.3.0 |
| Breaking change | MAJOR | 1.2.3 → 2.0.0 |
| Pre-release | Add suffix | 2.0.0-beta.1 |
| Initial development | 0.x.x | 0.1.0, 0.2.0 |

#### Pre-release Conventions

```
1.0.0-alpha.1    # Early testing, unstable
1.0.0-beta.1     # Feature complete, testing
1.0.0-rc.1       # Release candidate, final testing
1.0.0            # Stable release
```

### 2. Changelog Management

Maintain `CHANGELOG.md` using [Keep a Changelog](https://keepachangelog.com/) format:

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- New feature description (#123)

### Changed
- Updated behavior description (#124)

### Fixed
- Bug fix description (#125)

## [1.2.0] - 2024-01-15

### Added
- User profile avatars - upload and display profile pictures (#120)
- Dark mode toggle in settings (#118)
- Export data as CSV from dashboard (#115)

### Changed
- Improved loading performance for dashboard (50% faster) (#119)
- Updated authentication flow for better security (#117)

### Fixed
- Fixed crash when uploading files larger than 10MB (#116)
- Fixed incorrect date formatting in reports (#114)

### Security
- Patched XSS vulnerability in comments (#121)

## [1.1.0] - 2024-01-01

### Added
...

## [1.0.0] - 2023-12-15

### Added
- Initial release
- User authentication (signup, login, logout)
- Dashboard with key metrics
- Settings page

[Unreleased]: https://github.com/user/repo/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/user/repo/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/user/repo/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/user/repo/releases/tag/v1.0.0
```

#### Changelog Categories

| Category | Use For |
|----------|---------|
| Added | New features |
| Changed | Changes to existing functionality |
| Deprecated | Features to be removed in future |
| Removed | Removed features |
| Fixed | Bug fixes |
| Security | Security patches |

### 3. Release Notes (User-Facing)

Transform technical changelog into user-friendly release notes:

```markdown
# What's New in Version 1.2

**Released: January 15, 2024**

## Highlights

### Profile Pictures Are Here! 🎉
You can now upload a profile picture to personalize your account.
Go to Settings > Profile to add yours.

### Dark Mode
Night owl? We've added dark mode! Toggle it in Settings > Appearance.

### Export Your Data
Need your data in a spreadsheet? Export any dashboard view as CSV.

## Improvements
- Dashboard loads 50% faster
- More secure login process

## Bug Fixes
- Fixed: Large file uploads now work correctly
- Fixed: Dates display correctly in all time zones

## Coming Soon
- Team collaboration features
- Mobile app (beta)

---

Questions? Contact support@app.com
```

### 4. Automated Release Process

```yaml
# .github/workflows/release.yml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm ci

      - name: Build
        run: npm run build

      - name: Run tests
        run: npm test

      - name: Extract changelog
        id: changelog
        run: |
          VERSION=${GITHUB_REF#refs/tags/v}
          CHANGELOG=$(sed -n "/## \[$VERSION\]/,/## \[/p" CHANGELOG.md | sed '$ d')
          echo "changelog<<EOF" >> $GITHUB_OUTPUT
          echo "$CHANGELOG" >> $GITHUB_OUTPUT
          echo "EOF" >> $GITHUB_OUTPUT

      - name: Create GitHub Release
        uses: softprops/action-gh-release@v1
        with:
          body: ${{ steps.changelog.outputs.changelog }}
          draft: false
          prerelease: ${{ contains(github.ref, '-') }}
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: Deploy to production
        if: ${{ !contains(github.ref, '-') }}
        run: npm run deploy
```

### 5. Version Bump Script

```typescript
// scripts/bump-version.ts
import { readFileSync, writeFileSync } from 'fs';
import { execSync } from 'child_process';

type BumpType = 'major' | 'minor' | 'patch' | 'prerelease';

function bumpVersion(type: BumpType, preId?: string) {
  // Read current version
  const pkg = JSON.parse(readFileSync('package.json', 'utf-8'));
  const [major, minor, patch] = pkg.version.split('.').map(Number);

  let newVersion: string;

  switch (type) {
    case 'major':
      newVersion = `${major + 1}.0.0`;
      break;
    case 'minor':
      newVersion = `${major}.${minor + 1}.0`;
      break;
    case 'patch':
      newVersion = `${major}.${minor}.${patch + 1}`;
      break;
    case 'prerelease':
      newVersion = `${major}.${minor}.${patch + 1}-${preId || 'beta'}.1`;
      break;
  }

  // Update package.json
  pkg.version = newVersion;
  writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\n');

  // Update changelog date
  const today = new Date().toISOString().split('T')[0];
  let changelog = readFileSync('CHANGELOG.md', 'utf-8');
  changelog = changelog.replace(
    '## [Unreleased]',
    `## [Unreleased]\n\n## [${newVersion}] - ${today}`
  );
  writeFileSync('CHANGELOG.md', changelog);

  // Git operations
  execSync(`git add package.json CHANGELOG.md`);
  execSync(`git commit -m "chore: bump version to ${newVersion}"`);
  execSync(`git tag v${newVersion}`);

  console.log(`Version bumped to ${newVersion}`);
  console.log(`Run 'git push && git push --tags' to trigger release`);
}

// Usage: npx ts-node scripts/bump-version.ts minor
const [, , type, preId] = process.argv;
bumpVersion(type as BumpType, preId);
```

### 6. Release Checklist

```markdown
# Release Checklist: v{{version}}

## Pre-Release
- [ ] All features for this release are merged
- [ ] All tests passing on main branch
- [ ] QA sign-off obtained
- [ ] Security review completed
- [ ] Performance benchmarks acceptable
- [ ] Documentation updated

## Changelog & Notes
- [ ] CHANGELOG.md updated with all changes
- [ ] Release notes written (user-facing)
- [ ] Breaking changes documented
- [ ] Migration guide written (if applicable)

## Version & Tag
- [ ] Version bumped in package.json
- [ ] Version bumped in any other config files
- [ ] Git tag created: v{{version}}
- [ ] Tag pushed to remote

## Deployment
- [ ] Staging deployment successful
- [ ] Staging smoke tests pass
- [ ] Production deployment scheduled
- [ ] Rollback plan documented

## Communication
- [ ] Release notes published
- [ ] Changelog updated on website/docs
- [ ] Users notified (if major release)
- [ ] Internal team notified

## Post-Release
- [ ] Production smoke tests pass
- [ ] Monitoring dashboards checked
- [ ] Error rates normal
- [ ] Performance metrics normal
- [ ] Release marked as stable (remove pre-release flag)
```

### 7. Rollback Procedure

```markdown
# Rollback Procedure

## When to Rollback
- Critical bug affecting >10% of users
- Security vulnerability discovered
- Data corruption occurring
- Service completely unavailable

## Rollback Steps

### 1. Assess Severity
- Is this a P0 (rollback immediately)?
- Can we hotfix instead?
- What's the blast radius?

### 2. Communicate
- Notify on-call team in #incidents
- Update status page
- Prepare user communication

### 3. Execute Rollback

#### Vercel/Next.js
```bash
# List deployments
vercel ls

# Rollback to previous
vercel rollback [deployment-url]
```

#### Docker/Kubernetes
```bash
# Rollback deployment
kubectl rollout undo deployment/app

# Or specific revision
kubectl rollout undo deployment/app --to-revision=2
```

#### Manual
```bash
# Revert last commit
git revert HEAD --no-edit
git push

# Or checkout previous tag
git checkout v1.1.0
git push --force origin main  # CAREFUL!
```

### 4. Verify Rollback
- [ ] Service responding
- [ ] Error rates decreasing
- [ ] User reports stopping

### 5. Post-Mortem
- Schedule post-mortem within 48 hours
- Document what went wrong
- Identify prevention measures
```

## Package.json Scripts

```json
{
  "scripts": {
    "version:patch": "ts-node scripts/bump-version.ts patch",
    "version:minor": "ts-node scripts/bump-version.ts minor",
    "version:major": "ts-node scripts/bump-version.ts major",
    "version:beta": "ts-node scripts/bump-version.ts prerelease beta",
    "release": "npm run version:patch && git push && git push --tags",
    "changelog": "conventional-changelog -p angular -i CHANGELOG.md -s"
  }
}
```

## Environment Variables

```bash
# .env.example additions

# ===========================================
# Release Management
# ===========================================
APP_VERSION=1.0.0              # Set by CI/CD
RELEASE_CHANNEL=stable         # stable, beta, alpha
SENTRY_RELEASE=                # Auto-set from APP_VERSION
```

## Handoff Protocol

### Handoff to DevOps Engineer

**Package Contents:**
1. Updated CHANGELOG.md
2. Release notes document
3. Version bump commit
4. Git tag created
5. Release checklist completed
6. Rollback procedure documented

**Deployment Authorization:**
```markdown
## Release Authorization

**Version:** {{version}}
**Date:** {{date}}
**Release Manager:** release-manager skill

### Approvals
- [ ] QA: Tests passing
- [ ] Security: Review completed
- [ ] Product: Features approved
- [ ] Release Manager: Checklist complete

### Go/No-Go
- [x] GO - Approved for deployment
- [ ] NO-GO - Reason: ___

### Notes
{{any special deployment instructions}}
```

## Anti-Patterns

| Anti-Pattern | Problem | Correction |
|--------------|---------|------------|
| No version numbers | Can't track what's deployed | Use semantic versioning |
| Changelog as afterthought | Missing or inaccurate changes | Update with each PR |
| Major version fear | Stuck on 0.x forever | Major versions are OK for breaking changes |
| No release notes | Users confused by changes | Write user-facing notes |
| Deploy without tag | Can't rollback to specific version | Always tag releases |
| No rollback plan | Stuck with broken release | Document rollback procedure |

## Output Location

```
project-root/
├── CHANGELOG.md               # Technical changelog
├── RELEASE-NOTES.md          # User-facing notes (or in docs/)
├── package.json              # Version field
├── scripts/
│   └── bump-version.ts       # Version bump script
├── .github/
│   └── workflows/
│       └── release.yml       # Automated release workflow
└── docs/
    └── releases/
        ├── RELEASE-CHECKLIST.md
        ├── ROLLBACK-PROCEDURE.md
        └── v1.2.0/
            └── RELEASE-NOTES.md
```

## Integration with Workflow

```
[QA GATE PASS] → Tests verified
        ↓
[SECURITY GATE PASS] → Security reviewed
        ↓
[RELEASE MANAGER] ← Prepare release
        ↓
    Changelog updated
    Version bumped
    Release notes written
    Tag created
        ↓
[DEVOPS ENGINEER] → Deploy to production
        ↓
[PROJECT CHRONICLER] → Document release in chronicle
```

The Release Manager should be invoked:
1. **After all gates pass** - Ready to release
2. **Before deployment** - Prepare release artifacts
3. **After deployment issues** - Coordinate rollback
