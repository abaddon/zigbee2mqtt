# GitHub Actions Workflows Configuration

This document explains the GitHub Actions workflows in this repository, which ones are enabled, and what secrets they require.

## ✅ Active Workflows (No Setup Required)

### 1. CI Workflow (`ci.yml`)
**Triggers:** Push to dev/master, Pull Requests, Version tags
**Purpose:** Build, test, and publish Docker images to GHCR
**Secrets Required:**
- `GITHUB_TOKEN` - **Auto-provided** ✅

**Status:** ✅ Ready to use

---

### 2. Release Please (`release-please.yml`)
**Triggers:** Push to dev branch
**Purpose:** Automated versioning and changelog generation
**Secrets Required:**
- `GH_TOKEN` - GitHub Personal Access Token

**Setup Instructions:**
1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token with permissions:
   - `repo` (Full control of private repositories)
   - `workflow` (Update GitHub Action workflows)
3. Add to repository secrets as `GH_TOKEN`

**Alternative:** You can use `GITHUB_TOKEN` instead by editing the workflow:
```yaml
token: ${{ secrets.GITHUB_TOKEN }}
```

**Status:** ⚠️ Requires `GH_TOKEN` secret or workflow edit

---

### 3. Stale Issues (`stale.yml`)
**Triggers:** Daily schedule (midnight UTC), Manual dispatch
**Purpose:** Mark inactive issues/PRs as stale
**Secrets Required:**
- `GITHUB_TOKEN` - **Auto-provided** ✅

**Status:** ✅ Ready to use

---

### 4. Tests (`ci.yml` - tests job)
**Triggers:** Same as CI workflow
**Purpose:** Run tests across multiple OS and Node.js versions
**Secrets Required:** None

**Status:** ✅ Ready to use

---

## ⚙️ Conditional Workflows (Require Setup)

### 5. GHCR Cleanup (`ghcr-cleanup.yml`)
**Triggers:** Manual dispatch only
**Purpose:** Delete untagged Docker images from GHCR
**Secrets Required:**
- `GH_TOKEN` - GitHub Personal Access Token (needs `write:packages` permission)

**Fixed Issues:**
- ✅ Updated OWNER from `user` to `abaddon`

**Status:** ⚙️ Works when manually triggered, requires `GH_TOKEN`

---

### 6. Merge Master to Dev (`merge-master-to-dev.yml`)
**Triggers:** Push to master branch
**Purpose:** Auto-merge master changes back to dev
**Secrets Required:**
- `GH_TOKEN` - GitHub Personal Access Token

**Status:** ⚙️ Requires `GH_TOKEN` secret

**Note:** Consider if you need this workflow. In most forks, you manually control merging.

---

### 7. Update Dependency (`update-dependency.yml`)
**Triggers:** Repository dispatch event (`update_dep`)
**Purpose:** Automated dependency updates via repository dispatch
**Secrets Required:**
- `GH_TOKEN` - GitHub Personal Access Token

**Status:** ⚙️ Requires `GH_TOKEN` and repository dispatch trigger

**Note:** This is triggered by external automation. You probably don't need this for a custom fork.

---

## 🔇 Disabled Workflows

### 8. Issue Bot (`issue_bot.yml`)
**Status:** ❌ **DISABLED**
**Reason:** References upstream `Koenkk/zigbee-herdsman-converters` repository

**How to Re-enable:**
1. Fork `Koenkk/zigbee-herdsman-converters` to your account
2. Update line 28 in workflow: `repository: abaddon/zigbee-herdsman-converters`
3. Change `if: false` to the original conditions

**Original Purpose:** Automated responses for new device support issues

---

### 9. Claude Code (`claude.yml`)
**Status:** ❌ **DISABLED** (requires secret)
**Purpose:** AI-powered code assistance in issues/PRs
**Secrets Required:**
- `CLAUDE_CODE_OAUTH_TOKEN` - OAuth token from Claude Code

**How to Enable:**
1. Get OAuth token from https://code.claude.com
2. Add to repository secrets as `CLAUDE_CODE_OAUTH_TOKEN`
3. Edit workflow: Change `if: false` to the commented conditions

**Usage:** Tag issues/comments with `@claude` to invoke

---

### 10. Claude Code Review (`claude-code-review.yml`)
**Status:** ❌ **DISABLED** (requires secret)
**Purpose:** Automated AI code review on pull requests
**Secrets Required:**
- `CLAUDE_CODE_OAUTH_TOKEN` - OAuth token from Claude Code

**How to Enable:**
1. Get OAuth token from https://code.claude.com
2. Add to repository secrets as `CLAUDE_CODE_OAUTH_TOKEN`
3. Edit workflow: Change `if: false` to `if: true`

---

## 🔑 Secret Configuration Summary

### Required for Core Functionality

| Secret | Required For | How to Create |
|--------|-------------|---------------|
| `GITHUB_TOKEN` | CI, Stale, Tests | **Auto-provided** - No setup needed |
| `GH_TOKEN` | Release Please, Merge workflows | Personal Access Token with `repo` + `workflow` |

### Optional Features

| Secret | Enables | Priority |
|--------|---------|----------|
| `GH_TOKEN` (with `write:packages`) | GHCR cleanup | Low - Can manually delete images |
| `CLAUDE_CODE_OAUTH_TOKEN` | Claude AI features | Optional - Nice to have |

---

## 📋 Setup Checklist

### Minimal Setup (Just Build & Deploy)
- [x] Repository exists
- [x] Workflows committed to `dev` branch
- [ ] Push to `dev` to trigger first build
- [ ] Verify CI workflow succeeds
- [ ] Check GHCR package appears

**No additional secrets needed!** The `GITHUB_TOKEN` is automatically provided.

### Recommended Setup (With Releases)
- [ ] Create `GH_TOKEN` Personal Access Token
- [ ] Add `GH_TOKEN` to repository secrets
- [ ] Test release-please by merging a PR to `dev`
- [ ] Verify release PR is created

### Full Setup (All Features)
- [ ] Set up `GH_TOKEN` (see above)
- [ ] (Optional) Get `CLAUDE_CODE_OAUTH_TOKEN`
- [ ] (Optional) Enable Claude workflows
- [ ] (Optional) Fork and configure Issue Bot

---

## 🔧 Creating GitHub Personal Access Token (GH_TOKEN)

1. **Go to GitHub Settings**
   - Click your profile → Settings
   - Developer settings → Personal access tokens → Tokens (classic)

2. **Generate New Token**
   - Click "Generate new token (classic)"
   - Name: `Zigbee2MQTT Custom Build`
   - Expiration: Choose duration (90 days, 1 year, or no expiration)

3. **Select Scopes**
   - ✅ `repo` (Full control of private repositories)
   - ✅ `workflow` (Update GitHub Action workflows)
   - ✅ `write:packages` (Upload packages to GitHub Package Registry) - if using GHCR cleanup

4. **Generate and Copy Token**
   - Click "Generate token"
   - **Copy the token immediately** (you won't see it again!)

5. **Add to Repository Secrets**
   - Go to your repository → Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Name: `GH_TOKEN`
   - Value: Paste your token
   - Click "Add secret"

---

## 🐛 Troubleshooting Workflow Failures

### "Error: Resource not accessible by integration"
**Cause:** Missing or insufficient permissions for `GITHUB_TOKEN`
**Fix:** Check repository Settings → Actions → General → Workflow permissions
- Select "Read and write permissions"
- Check "Allow GitHub Actions to create and approve pull requests"

### "Error: HttpError: Bad credentials"
**Cause:** `GH_TOKEN` secret is missing or expired
**Fix:** Create or regenerate the Personal Access Token and update the secret

### "Error: No such secret: CLAUDE_CODE_OAUTH_TOKEN"
**Cause:** Claude workflows are enabled but secret is missing
**Fix:** Either disable the workflows (they're already disabled) or add the secret

### Workflow Doesn't Run
**Cause:** Workflow is disabled or condition is not met
**Fix:**
- Check if `if:` condition is set to `false`
- Verify trigger conditions match your action (e.g., pushing to correct branch)

---

## 📊 Workflow Status Dashboard

After first push, check:
- Actions tab: https://github.com/abaddon/zigbee2mqtt/actions
- Packages: https://github.com/abaddon?tab=packages

Expected after first push to `dev`:
- ✅ CI workflow runs (15-30 mins)
- ✅ Tests workflow runs
- ✅ Docker image appears in GHCR
- ⚠️ Release Please may fail if `GH_TOKEN` not set (non-critical)

---

## 🎯 Recommended Configuration

For most users, the default configuration is sufficient:

**Keep Enabled:**
- ✅ CI (`ci.yml`)
- ✅ Tests (`ci.yml`)
- ✅ Stale (`stale.yml`)

**Enable When Ready:**
- ⚙️ Release Please - when you set up `GH_TOKEN`

**Leave Disabled:**
- ❌ Issue Bot (fork-specific)
- ❌ Claude workflows (optional, requires token)
- ❌ Merge master to dev (manual control preferred)
- ❌ Update dependency (usually not needed)

---

## 🔄 Updating Workflows

When you sync with upstream Zigbee2MQTT:

1. **Review new workflows** in `.github/workflows/`
2. **Check for new secrets** they require
3. **Update owner/repository references** (Koenkk → abaddon)
4. **Test in a feature branch** before merging

---

## 📝 Summary

**What works out of the box:**
- ✅ Building and testing code
- ✅ Publishing Docker images to GHCR
- ✅ Stale issue management

**What needs setup:**
- ⚙️ Automated releases (requires `GH_TOKEN`)

**What's optional:**
- 💡 Claude AI features
- 💡 Issue bot automation
- 💡 GHCR cleanup
- 💡 Auto-merge workflows

You can start building immediately without any secret configuration!
