# CI/CD Documentation

This document explains the Continuous Integration and Continuous Deployment setup for the Love2D Library Collection.

## Overview

The project uses **GitHub Actions** for automated testing, quality checks, and releases.

## Workflows

### 1. **CI - Tests & Linting** (`ci.yml`)

**Triggers:**
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop`

**Jobs:**
- **Lint**: Lua code linting with Luacheck
- **Test**: Unit tests with Busted (Lua 5.1 and LuaJIT)
- **Structure Check**: Verify all required files exist
- **Love2D Check**: Test library loading in Love2D environment
- **Security**: Trivy vulnerability scanner
- **Report**: Generate CI summary

**Status Badge:**
```markdown
![CI Status](https://github.com/lilaTrue/love2D-librairy/workflows/CI%20-%20Tests%20%26%20Linting/badge.svg)
```

---

### 2. **CD - Release & Publish** (`release.yml`)

**Triggers:**
- Version tags (e.g., `v1.0.0`, `v1.2.3`)
- Manual workflow dispatch

**Jobs:**
- **Build**: Create ZIP and TAR.GZ release archives
- **Documentation**: Generate and deploy API docs to GitHub Pages
- **Release Notes**: Extract changelog and create GitHub release
- **Notify**: Send notifications (Discord/Slack)
- **Metrics**: Calculate and report code metrics

**Creating a Release:**
```bash
# Tag a new version
git tag -a v1.1.0 -m "Release version 1.1.0"
git push origin v1.1.0

# GitHub Actions will automatically:
# 1. Build release archives
# 2. Create GitHub release
# 3. Deploy documentation
# 4. Send notifications
```

---

### 3. **Documentation Update** (`docs.yml`)

**Triggers:**
- Push to `main` branch with changes in `docs/`, `README.md`, etc.
- Manual workflow dispatch

**Jobs:**
- **Deploy Docs**: Build and deploy documentation site to GitHub Pages

**View Documentation:**
https://lilaTrue.github.io/love2D-librairy/

---

### 4. **Code Quality Analysis** (`quality.yml`)

**Triggers:**
- Push to `main` or `develop`
- Pull requests
- Weekly schedule (Sunday at midnight)

**Jobs:**
- **Complexity**: Analyze code complexity
- **Duplication**: Check for code duplication
- **Security Audit**: Scan for security issues
- **Performance**: Run performance benchmarks
- **Doc Coverage**: Check documentation coverage
- **Style Check**: Verify code style consistency

---

## Setup Instructions

### Required Secrets

No secrets are required for basic functionality. Optional secrets:

| Secret | Purpose | Required |
|--------|---------|----------|
| `DISCORD_WEBHOOK` | Discord notifications | Optional |
| `SLACK_WEBHOOK` | Slack notifications | Optional |

**To add secrets:**
1. Go to repository Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add the secret name and value

### Enable GitHub Pages

1. Go to repository Settings → Pages
2. Source: Deploy from a branch
3. Branch: `gh-pages`
4. Folder: `/ (root)`
5. Save

Documentation will be available at: `https://lilaTrue.github.io/love2D-librairy/`

---

## Local Testing

### Install Dependencies

```bash
# Install Lua
# Windows: Download from https://luabinaries.sourceforge.net/
# macOS: brew install lua
# Linux: sudo apt-get install lua5.1

# Install LuaRocks
# https://github.com/luarocks/luarocks/wiki/Download

# Install tools
luarocks install luacheck
luarocks install busted
```

### Run Checks Locally

```bash
# Lint code
luacheck lib/ --globals love

# Run tests (when available)
busted tests/

# Check syntax
find lib -name "*.lua" -exec lua -e "assert(loadfile('{}'))" \;
```

---

## Workflow Files

### File Structure

```
.github/
└── workflows/
    ├── ci.yml           # Continuous Integration
    ├── release.yml      # Release & Deployment
    ├── docs.yml         # Documentation Updates
    └── quality.yml      # Code Quality Analysis
```

### Configuration Files

```
.luacheckrc              # Luacheck configuration
```

---

## CI/CD Best Practices

### 1. **Before Pushing**

```bash
# Check syntax
lua -c lib/YourLib.lua

# Run luacheck
luacheck lib/

# Test manually
love .
```

### 2. **Pull Request Guidelines**

- Ensure CI passes before requesting review
- Add tests for new features
- Update documentation
- Follow code style guidelines

### 3. **Creating Releases**

```bash
# 1. Update CHANGELOG.md
# Add your changes under [Unreleased]

# 2. Create version tag
git tag -a v1.2.0 -m "Release 1.2.0"

# 3. Push tag
git push origin v1.2.0

# GitHub Actions will handle the rest!
```

### 4. **Semantic Versioning**

Follow [SemVer](https://semver.org/):

- **MAJOR** (v2.0.0): Breaking changes
- **MINOR** (v1.1.0): New features, backwards compatible
- **PATCH** (v1.0.1): Bug fixes

---

## Troubleshooting

### CI Fails on Lint

```bash
# Run locally to see errors
luacheck lib/ --globals love

# Fix common issues:
# - Remove trailing whitespace
# - Fix undefined globals
# - Add -- luacheck: ignore comments if needed
```

### Tests Fail

```bash
# Run tests locally
busted tests/

# Debug specific test
busted tests/test_collision.lua --verbose
```

### Release Doesn't Trigger

- Check tag format: Must be `v*.*.*` (e.g., `v1.0.0`)
- Verify tag is pushed: `git push origin v1.0.0`
- Check Actions tab for error messages

### Documentation Not Deploying

1. Verify GitHub Pages is enabled
2. Check `gh-pages` branch exists
3. Look for errors in Actions tab
4. Wait 5-10 minutes for GitHub Pages to update

---

## Maintenance

### Update Dependencies

GitHub Actions automatically uses latest versions of actions. To update:

1. Check for action updates in workflows
2. Test locally if possible
3. Update version numbers in workflow files

### Add New Tests

```bash
# Create test file
cat > tests/test_myfeature.lua << 'EOF'
describe("MyFeature", function()
    it("should work correctly", function()
        local result = myFunction()
        assert.are.equal(expected, result)
    end)
end)
EOF
```

### Add New Quality Checks

Edit `.github/workflows/quality.yml` to add new checks.

---

## Monitoring

### View CI/CD Status

- **GitHub Actions Tab**: See all workflow runs
- **Repository Badges**: Add to README.md
- **Email Notifications**: Configure in GitHub settings

### Metrics

Check the following in Actions summaries:
- Lines of code
- Test coverage
- Documentation coverage
- Performance metrics
- Security vulnerabilities

---

## Support

- **Issues**: Create GitHub issue
- **Documentation**: Check workflow files for comments
- **Actions Logs**: Review detailed logs in Actions tab

---

## References

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Luacheck Documentation](https://luacheck.readthedocs.io/)
- [Busted Documentation](https://olivinelabs.com/busted/)
- [Semantic Versioning](https://semver.org/)

---

**Last Updated**: October 30, 2025
