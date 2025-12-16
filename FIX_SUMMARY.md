# Fix Summary - Master Branch Configuration

## ✅ What Was Fixed

All workflows and configurations have been updated to use `master` branch instead of `dev`:

### 1. CI Workflow (`.github/workflows/ci.yml`)
- ✅ Changed trigger from `dev` to `master`
- ✅ Updated all branch condition checks
- ✅ Changed Docker image tag from `latest-dev` to `latest`
- ✅ Renamed build step from "dev" to "master"
- ✅ Updated bench test to compare against `master`

### 2. Release Please (`.github/workflows/release-please.yml`)
- ✅ Changed trigger from `main` to `master`
- ✅ Updated target-branch to `master`

### 3. Add-on Configuration
- ✅ Updated `abaddon-zigbee2mqtt/Dockerfile` to use `latest` tag
- ✅ Set add-on version to `"dev"`

### 4. Already Correct
- ✅ `update-addon-version.yml` already uses `master`

## 🚀 Next Steps

### Step 1: Commit and Push Changes

```bash
# Review changes
git status
git diff

# Commit all fixes
git add .
git commit -m "fix: configure all workflows for master branch instead of dev"
git push origin master
```

### Step 2: Wait for CI Build (~15-30 minutes)

After pushing, GitHub Actions will:
1. Build Docker images for amd64 and arm64
2. Push to GHCR as `ghcr.io/abaddon/zigbee2mqtt:latest`

Monitor at: https://github.com/abaddon/zigbee2mqtt/actions

### Step 3: Verify Image in GHCR

Check that the image was published:
1. Go to: https://github.com/abaddon/zigbee2mqtt/pkgs/container/zigbee2mqtt
2. Verify you see a `latest` tag
3. Make sure the package is **public**

### Step 4: Install Add-on in Home Assistant

1. **Remove old repository** (if previously added):
   - Settings → Add-ons → ⋮ menu → Repositories
   - Remove `https://github.com/abaddon/zigbee2mqtt`

2. **Wait 30 seconds** (clear cache)

3. **Re-add repository**:
   - Settings → Add-ons → ⋮ menu → Repositories
   - Add: `https://github.com/abaddon/zigbee2mqtt`

4. **Install add-on**:
   - Refresh Add-on Store
   - Find "Abaddon Zigbee2MQTT"
   - Click Install

## 📊 Current Configuration

### Docker Image Tags

| Branch/Tag | Image Tag | When Built |
|------------|-----------|------------|
| `master` branch | `latest` | On every push to master |
| Tag `1.0.0` | `1.0.0`, `1.0`, `1` | When you create release tag |
| Tag `1.2.3` | `1.2.3`, `1.2`, `1` | When you create release tag |

### Add-on Versions

**Current** (development):
- Dockerfile: `ghcr.io/abaddon/zigbee2mqtt:latest`
- config.yaml: `version: "dev"`

**After first release** (automatic via workflow):
- Dockerfile: `ghcr.io/abaddon/zigbee2mqtt:1.0.0`
- config.yaml: `version: "1.0.0"`

## 🐛 Troubleshooting

### Image Still Not Found

**After pushing**, if the image still doesn't exist:

1. **Check workflow run**:
   - Go to Actions tab
   - Click on latest "CI" workflow
   - Check if "master - Docker build and push" step ran
   - Look for errors

2. **Check branch**:
   ```bash
   git branch
   # Should show: * master
   ```

3. **Verify push went to master**:
   ```bash
   git log --oneline -1
   # Check the commit is there
   ```

### Workflow Doesn't Run

**If CI doesn't trigger after push**:

1. Check `.github/workflows/ci.yml` exists on master
2. Go to Actions tab → Check if workflow is disabled
3. Check repository Settings → Actions → General → Workflow permissions

### Add-on Install Still Fails

**If HA still can't pull the image**:

1. **Verify image is public**:
   - Go to package settings
   - Check visibility is "Public"

2. **Check exact error in HA logs**:
   - Settings → System → Logs
   - Look for add-on installation errors

3. **Try manual Docker pull** (from any machine):
   ```bash
   docker pull ghcr.io/abaddon/zigbee2mqtt:latest
   ```

## 📝 Creating Your First Release

When you're ready for version 1.0.0:

### Option A: Using Release-Please (Automatic)

1. **Push to master** with conventional commits:
   ```bash
   git commit -m "feat: add custom feature X"
   git push origin master
   ```

2. **Wait for release-please** to create a PR

3. **Merge the PR** → Creates tag and builds versioned image

### Option B: Manual Release

1. **Create and push tag**:
   ```bash
   git tag 1.0.0
   git push origin 1.0.0
   ```

2. **CI automatically**:
   - Builds versioned Docker image
   - Update workflow updates add-on config

## ✨ What Works Now

After these fixes:

✅ Push to `master` → Builds `latest` image
✅ Create tag `1.0.0` → Builds `1.0.0` image
✅ Add-on uses `latest` by default
✅ Auto-updates add-on config on releases
✅ Users can install from HA UI

## 🎯 Summary

**Before**: All workflows configured for `dev` branch
**After**: All workflows configured for `master` branch

**Next**: Push changes → Wait for build → Install add-on!

---

**Need Help?** Check `WORKFLOWS_CONFIGURATION.md` for detailed workflow documentation.
