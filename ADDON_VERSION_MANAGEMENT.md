# Add-on Version Management Guide

## The Issue You Just Encountered

**Error**: `Can't install ghcr.io/abaddon/zigbee2mqtt:1.0.0: DockerError(404, 'manifest unknown')`

**Cause**: The add-on configuration referenced a Docker image tag (`1.0.0`) that doesn't exist in GHCR yet.

## Understanding Image Tags

Your CI workflow builds different image tags:

| Git Action | Docker Image Tag | When Available |
|------------|------------------|----------------|
| Push to `dev` branch | `latest-dev` | ✅ Available now |
| Push tag `1.0.0` | `1.0.0`, `1.0`, `1` | ❌ Only after creating release |
| Push tag `1.2.3` | `1.2.3`, `1.2`, `1` | ❌ Only after creating release |

## Current Setup (Development)

**For development**, use the `latest-dev` tag:

**`abaddon-zigbee2mqtt/Dockerfile`**:
```dockerfile
ARG BUILD_FROM=ghcr.io/abaddon/zigbee2mqtt:latest-dev
FROM ${BUILD_FROM}
```

**`abaddon-zigbee2mqtt/config.yaml`**:
```yaml
version: "dev"
```

This pulls the latest development build every time you update.

## Production Setup (After First Release)

**After creating your first release**, you'll have versioned tags:

### Step 1: Create a Release

```bash
# Ensure code is ready
git add .
git commit -m "feat: ready for first release"
git push origin dev

# Wait for CI to build latest-dev

# Create and push release tag
git tag 1.0.0
git push origin 1.0.0
```

### Step 2: Workflow Auto-Updates

The `update-addon-version.yml` workflow will automatically:
- Update `config.yaml` to `version: "1.0.0"`
- Update `Dockerfile` to use `ghcr.io/abaddon/zigbee2mqtt:1.0.0`
- Commit changes to `master` branch

### Step 3: Users Get Updates

Home Assistant will:
- Detect the new version
- Show an "Update" button
- Pull the versioned image when updating

## Choosing Your Strategy

### Option A: Development Mode (Current)

**Use**: `latest-dev` tag
**Version**: `"dev"` in config.yaml

**Pros**:
- ✅ Always get latest code
- ✅ No release tags needed
- ✅ Simple for testing

**Cons**:
- ⚠️ No version tracking
- ⚠️ Can break unexpectedly
- ⚠️ Users can't pin versions

**Best for**: Personal use, testing, development

### Option B: Versioned Releases (Recommended)

**Use**: Specific version tags (e.g., `1.0.0`)
**Version**: Matches tag in config.yaml

**Pros**:
- ✅ Stable, predictable updates
- ✅ Users can choose when to update
- ✅ Professional appearance
- ✅ Version tracking in HA

**Cons**:
- ⚠️ Requires creating release tags
- ⚠️ More workflow steps

**Best for**: Sharing with others, production use

### Option C: Hybrid (Both)

Create **two add-ons** in your repository:

```
abaddon-zigbee2mqtt/          # Stable version (uses tags)
abaddon-zigbee2mqtt-dev/      # Dev version (uses latest-dev)
```

Users can choose which to install!

## Quick Fix for Current Error

**Immediate Solution** (already applied):

1. **Updated Dockerfile** to use `latest-dev`:
   ```dockerfile
   ARG BUILD_FROM=ghcr.io/abaddon/zigbee2mqtt:latest-dev
   ```

2. **Updated config.yaml** to version `"dev"`

3. **Next Steps**:
   ```bash
   # Commit the fix
   git add abaddon-zigbee2mqtt/
   git commit -m "fix: use latest-dev tag until first release"
   git push origin dev

   # Wait 1-2 minutes for GitHub to update

   # In Home Assistant:
   # 1. Remove the repository
   # 2. Re-add the repository
   # 3. Install the add-on again
   ```

## Verifying Available Images

Check what images exist in GHCR:

1. Visit: https://github.com/abaddon/zigbee2mqtt/pkgs/container/zigbee2mqtt
2. Look at "Recent tagged image versions"
3. Verify `latest-dev` exists

## Creating Your First Release

When ready for a stable release:

### 1. Prepare the Code

```bash
# Make sure dev is clean and tested
git checkout dev
git pull
```

### 2. Update Version in package.json

```bash
# Edit package.json
# Change version from "1.0.0" to your desired version
```

### 3. Create Conventional Commit

```bash
git add package.json
git commit -m "feat: ready for v1.0.0 release"
git push origin dev
```

### 4. Wait for Release-Please

Release-please will create a PR with:
- Updated CHANGELOG
- Version bump
- Release notes

### 5. Merge the PR

When you merge the release-please PR:
- A tag is created (e.g., `1.0.0`)
- CI builds versioned images
- Update workflow updates add-on config

### 6. Users Can Update

In Home Assistant:
- Add-on shows "Update available"
- Click update to get the new version

## Manual Release (Alternative)

If you don't want to use release-please:

```bash
# 1. Update versions manually
# Edit: package.json, .release-please-manifest.json

# 2. Commit
git add .
git commit -m "chore: release v1.0.0"
git push origin dev

# 3. Create and push tag
git tag 1.0.0
git push origin 1.0.0

# 4. CI will build the versioned image
# 5. Update workflow will update add-on config
```

## Troubleshooting

### Error: manifest unknown

**Cause**: Image tag doesn't exist in GHCR
**Fix**:
- Check GHCR for available tags
- Update Dockerfile to use existing tag
- Or create a release to build the tag

### Add-on Shows Old Version

**Cause**: GitHub caching
**Fix**:
1. In HA: Remove repository
2. Wait 30 seconds
3. Re-add repository
4. Install add-on

### Image Pull Fails

**Cause**: Image is private or doesn't exist
**Fix**:
1. Verify image is public in GHCR
2. Check image tag exists
3. Try `latest-dev` instead

## Best Practices

1. **Development Phase**:
   - Use `latest-dev` tag
   - Version: `"dev"`
   - Fast iteration

2. **First Release**:
   - Create `1.0.0` tag
   - Switch to versioned tags
   - Update CHANGELOG

3. **Ongoing**:
   - Use semantic versioning
   - Create release for each version
   - Let automation handle add-on updates

4. **Sharing with Others**:
   - Always use versioned releases
   - Maintain CHANGELOG
   - Test before releasing

## Summary

**Current Setup**: ✅ Fixed to use `latest-dev`

**What to do**:
1. ✅ Commit the fix (Dockerfile + config.yaml)
2. ✅ Push to dev branch
3. ✅ Re-add repository in Home Assistant
4. ✅ Install add-on (should work now!)
5. 📅 Later: Create first release for version `1.0.0`

**Next time**: Before creating a version tag in config.yaml, make sure that version exists as a Docker image tag in GHCR!
