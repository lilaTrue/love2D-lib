# Release Process Guide

This document describes the process for creating a new release of the Love2D Library Collection.

## Before Release

### 1. Ensure All Changes Are Merged
- All features for the release are merged to `main`
- All tests pass in CI
- Code review is complete

### 2. Update Version Numbers
No manual version updates needed - version is determined by git tag.

### 3. Update CHANGELOG.md

Move changes from `[Unreleased]` to a new version section:

```markdown
## [Unreleased]

## [1.2.0] - 2025-10-30

### Added
- New feature 1
- New feature 2

### Changed
- Change 1

### Fixed
- Bug fix 1
```

### 4. Update Documentation
- Review and update all docs in `/docs`
- Update README.md if needed
- Ensure examples are up to date

### 5. Test Locally

```bash
# Run all checks
luacheck lib/

# Test with Love2D
love .

# Test examples
cd example/scene && love .
cd ../class && love .
cd ../collider && love .
```

## Release Steps

### 1. Create and Push Tag

```bash
# Ensure you're on main branch and up to date
git checkout main
git pull origin main

# Create annotated tag (use semantic versioning)
git tag -a v1.2.0 -m "Release version 1.2.0"

# Push tag to trigger release workflow
git push origin v1.2.0
```

### 2. Monitor GitHub Actions

1. Go to repository → Actions tab
2. Watch the "CD - Release & Publish" workflow
3. Ensure all jobs complete successfully:
   - ✅ Build
   - ✅ Documentation
   - ✅ Release Notes
   - ✅ Notify
   - ✅ Metrics

### 3. Verify Release

After workflow completes:

1. **Check GitHub Release**
   - Go to repository → Releases
   - Verify release appears with correct version
   - Check release notes are populated
   - Download and test archives (ZIP and TAR.GZ)

2. **Check Documentation**
   - Visit https://lilaTrue.github.io/love2D-librairy/
   - Verify documentation is updated
   - Check all links work

3. **Test Downloads**
   ```bash
   # Download release archive
   curl -LO https://github.com/lilaTrue/love2D-librairy/releases/download/v1.2.0/love2d-librairy-v1.2.0.zip
   
   # Extract and test
   unzip love2d-librairy-v1.2.0.zip
   cd love2d-librairy-v1.2.0
   love .
   ```

## Post-Release

### 1. Announce Release

Create announcements on:
- GitHub Discussions (if enabled)
- Discord (if webhook configured)
- Love2D Forums
- Reddit (r/love2d)
- Twitter/Social media

**Announcement Template:**
```
🚀 Love2D Library Collection v1.2.0 Released!

New features:
- Feature 1
- Feature 2

Improvements:
- Improvement 1
- Improvement 2

Download: https://github.com/lilaTrue/love2D-librairy/releases/tag/v1.2.0
Docs: https://lilaTrue.github.io/love2D-librairy/
```

### 2. Update Version Badge

The badges in README.md will automatically update.

### 3. Monitor Issues

- Watch for bug reports related to new release
- Respond to questions promptly
- Note any hotfix needs

## Hotfix Releases

For urgent bug fixes:

### 1. Create Hotfix Branch
```bash
git checkout -b hotfix/v1.2.1 v1.2.0
```

### 2. Fix Bug
```bash
# Make fix
git commit -m "fix: critical bug in CollisionManager"
```

### 3. Update CHANGELOG
Add hotfix section:
```markdown
## [1.2.1] - 2025-10-31

### Fixed
- Critical bug in CollisionManager spatial grid
```

### 4. Merge and Tag
```bash
# Merge to main
git checkout main
git merge hotfix/v1.2.1

# Create tag
git tag -a v1.2.1 -m "Hotfix release 1.2.1"
git push origin main v1.2.1
```

## Version Numbering

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR** (v2.0.0): Breaking changes
  - API changes that break backward compatibility
  - Major architectural changes
  - Remove deprecated features

- **MINOR** (v1.1.0): New features
  - New functionality added
  - New libraries added
  - Backward compatible improvements

- **PATCH** (v1.0.1): Bug fixes
  - Bug fixes only
  - Documentation fixes
  - Performance improvements (non-breaking)

## Release Checklist

Use this checklist for each release:

### Pre-Release
- [ ] All features merged to main
- [ ] CI passes on main
- [ ] CHANGELOG.md updated
- [ ] Documentation reviewed and updated
- [ ] Examples tested
- [ ] Version decided (MAJOR.MINOR.PATCH)

### Release
- [ ] Tag created with correct version
- [ ] Tag pushed to GitHub
- [ ] GitHub Actions workflow completed successfully
- [ ] GitHub Release created automatically
- [ ] Release archives available
- [ ] Documentation deployed

### Post-Release
- [ ] Downloads tested
- [ ] Documentation site verified
- [ ] Release announced
- [ ] Badges updated
- [ ] Monitoring for issues

### If Problems
- [ ] Identified issue
- [ ] Created hotfix branch
- [ ] Fixed problem
- [ ] Tested fix
- [ ] Released hotfix version

## Rollback Procedure

If a release has critical issues:

### 1. Delete Release and Tag
```bash
# Delete local tag
git tag -d v1.2.0

# Delete remote tag
git push origin :refs/tags/v1.2.0

# Delete release on GitHub
# Go to Releases → Click release → Delete release
```

### 2. Create Hotfix
Follow hotfix procedure above.

### 3. Announce Issue
Communicate the issue and rollback to users.

## Automation

The release process is mostly automated:

### What's Automated
- ✅ Building release archives
- ✅ Creating GitHub release
- ✅ Generating release notes from CHANGELOG
- ✅ Deploying documentation
- ✅ Running quality checks
- ✅ Calculating metrics
- ✅ Sending notifications (if configured)

### What's Manual
- ❌ Updating CHANGELOG.md
- ❌ Creating version tag
- ❌ Announcing release
- ❌ Responding to feedback

## Troubleshooting

### Release Workflow Fails

1. Check Actions tab for error details
2. Common issues:
   - CHANGELOG.md not updated
   - Files missing in release structure
   - Documentation build errors

### Release Not Created

- Verify tag format: `v1.2.3` (must start with 'v')
- Check GitHub Actions permissions
- Review workflow logs

### Documentation Not Deployed

- Verify GitHub Pages is enabled
- Check gh-pages branch exists
- Wait 5-10 minutes for deployment
- Check workflow logs for errors

## Support

- **Questions**: Create GitHub issue with `question` label
- **Urgent Issues**: Mention in issue title
- **Workflow Issues**: Check `.github/workflows/` files

---

**Last Updated**: October 30, 2025
