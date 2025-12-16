# Custom Zigbee2MQTT Build - Implementation Plan

## Overview
This plan outlines the steps to configure your forked Zigbee2MQTT repository to:
- Build custom Docker images with your features/fixes
- Publish to GitHub Container Registry (GHCR)
- Use the custom image in Home Assistant via local add-on configuration

## Current State Analysis

### Already Completed ✓
- Repository forked to `abaddon/zigbee2mqtt`
- Docker labels partially updated with "abaddon" branding
- Local git repository configured

### What Needs To Be Done

## Phase 1: Repository Configuration

### 1.1 Update package.json Metadata
**File**: `package.json`
**Changes Needed**:
- Repository URL: Change from `Koenkk/zigbee2mqtt` to `abaddon/zigbee2mqtt`
- Bug tracker URL: Point to your fork's issues
- Homepage: Point to your fork or custom docs
- **Optional**: Change package name from `zigbee2mqtt` to `@abaddon/zigbee2mqtt` (only if publishing to npm)

**Impact**: Proper attribution, issue tracking links, and package identity

### 1.2 Update GitHub Workflows
**File**: `.github/workflows/ci.yml`

**Critical Changes**:
1. **Docker Registry Configuration** (lines 68-77):
   - Change Docker Hub username from `koenkk` to your username OR remove Docker Hub entirely
   - Keep GHCR configuration
   - Update image name to `ghcr.io/abaddon/zigbee2mqtt`

2. **Remove Add-on Build Triggers** (lines 161-182):
   - Remove the API dispatches to `zigbee2mqtt/hassio-zigbee2mqtt`
   - You're not maintaining the official add-on, so this is unnecessary

3. **NPM Publishing** (lines 142-158):
   - **Option A** (Recommended): Remove npm publishing entirely
   - **Option B**: Change to publish as `@abaddon/zigbee2mqtt` (requires npm account)

4. **Auto-merge dev→master** (lines 197-213):
   - **Keep if**: You want automated merging like upstream
   - **Remove if**: You prefer manual control over master branch

5. **Secrets Required**:
   - `GH_TOKEN`: GitHub Personal Access Token (already exists or use GITHUB_TOKEN)
   - Remove `DOCKER_KEY` if not using Docker Hub
   - Remove `NPM_TOKEN` if not publishing to npm

**File**: `.github/workflows/release-please.yml`

**Critical Changes**:
1. **Repository Reference** (line 36):
   - Already points to `abaddon/zigbee2mqtt` - verify this is correct

2. **Changelog Gist** (line 53):
   - Update gist ID from `bfd4c3d1725a2cccacc11d6ba51008ba` to your own gist
   - **OR** remove the gist update step entirely (lines 44-65)

3. **Secrets Required**:
   - `GH_TOKEN`: For creating releases and updating gist

### 1.3 Update Funding/Sponsorship
**File**: `.github/FUNDING.yml`

**Changes**:
- Remove or replace with your own sponsorship links
- This prevents users from accidentally sponsoring the original author when they meant to support your fork

### 1.4 Complete Docker Branding
**File**: `docker/Dockerfile`

**Current State**: Partially updated with "Abaddon" branding
**Verify/Complete**:
```dockerfile
LABEL org.opencontainers.image.authors="Abaddon"
LABEL org.opencontainers.image.title="abaddon-Zigbee2MQTT"
LABEL org.opencontainers.image.description="Abaddon Zigbee to MQTT bridge"
LABEL org.opencontainers.image.url="https://github.com/abaddon/zigbee2mqtt"
LABEL org.opencontainers.image.source="https://github.com/abaddon/zigbee2mqtt"
```

## Phase 2: Optional Customizations

### 2.1 Application Branding (Optional)
**File**: `index.js` (lines 80, 124, 132)
**Change**: Update console messages from "Zigbee2MQTT" to "Abaddon-Zigbee2MQTT"

**File**: `lib/controller.ts` (line 97)
**Change**: Update startup log message to include custom branding

**Impact**: Makes it clear in logs that you're running a custom build

### 2.2 Default Configuration (Optional)
**File**: `lib/util/settings.ts`

**Possible Customizations**:
- Change default MQTT base topic from `zigbee2mqtt` to `abaddon-zigbee2mqtt`
- Change default frontend port from 8080
- Enable/disable features by default
- Customize default frontend package

**Warning**: Changing MQTT topics or ports may break existing Home Assistant integrations

### 2.3 Version Management Strategy

**Option A - Independent Versioning** (Recommended):
- Use your own version numbers (e.g., start at 1.0.0 or use date-based like 2025.1.0)
- Modify release-please configuration to use your scheme
- Clearly indicates this is a custom fork

**Option B - Track Upstream**:
- Keep current version (2.7.1) and increment from there
- Easier to track which upstream version you're based on
- Risk of version conflicts if you ever want to sync with upstream

## Phase 3: Build & Publish Setup

### 3.1 GitHub Container Registry Setup

**Prerequisites**:
1. Enable GHCR for your account (https://github.com/settings/packages)
2. Make package public (or keep private if preferred)

**Workflow Changes**:
```yaml
# In .github/workflows/ci.yml
- name: Login to GitHub Container Registry
  uses: docker/login-action@v3
  with:
    registry: ghcr.io
    username: ${{ github.repository_owner }}
    password: ${{ secrets.GITHUB_TOKEN }}

- name: Build and push
  uses: docker/build-push-action@v6
  with:
    tags: |
      ghcr.io/abaddon/zigbee2mqtt:latest
      ghcr.io/abaddon/zigbee2mqtt:${{ github.sha }}
      ghcr.io/abaddon/zigbee2mqtt:${{ steps.version.outputs.version }}
```

**Image Tags Strategy**:
- `latest`: Always points to latest dev build
- `latest-dev`: Development builds (from dev branch)
- `1.x.x`: Specific version tags (from releases)
- `sha-<commit>`: Specific commit builds (for testing)

### 3.2 Multi-Architecture Builds

**Current Support**:
- linux/arm64/v8 (Home Assistant Yellow, Pi 4+ 64-bit)
- linux/amd64 (Most PCs, x86 servers)
- linux/arm/v6 (Pi Zero, old Pi models)
- linux/arm/v7 (Pi 2/3 32-bit)
- linux/riscv64 (experimental)
- linux/386 (old 32-bit x86)

**Recommendations**:
- **Keep arm64 and amd64** (covers 95% of Home Assistant installations)
- **Optional**: Keep arm/v7 if you have older Pi devices
- **Remove**: riscv64 and 386 (rarely used, slow to build)

### 3.3 Build Triggers

**Recommended Setup**:
- **Push to `dev` branch**: Build and push `ghcr.io/abaddon/zigbee2mqtt:latest-dev`
- **Push version tags** (v1.2.3): Build and push versioned tags
- **Pull Requests**: Build only, don't push (for testing)
- **Manual trigger**: Add `workflow_dispatch` for on-demand builds

## Phase 4: Home Assistant Integration

### 4.1 Create Local Add-on Configuration

Since you're not forking the hassio-zigbee2mqtt repository, you'll create a local add-on configuration.

**Steps**:
1. On Home Assistant OS, create `/addons/abaddon-zigbee2mqtt/` directory
2. Create `config.json` pointing to your custom image
3. Create `Dockerfile` that references your GHCR image
4. Install as local add-on

**Example config.json**:
```json
{
  "name": "Abaddon Zigbee2MQTT",
  "version": "1.0.0",
  "slug": "abaddon-zigbee2mqtt",
  "description": "Custom Zigbee2MQTT with Abaddon features",
  "image": "ghcr.io/abaddon/zigbee2mqtt",
  "arch": ["amd64", "aarch64", "armv7"],
  "ports": {
    "8080/tcp": 8099
  },
  "options": {},
  "schema": {}
}
```

### 4.2 Alternative: Direct Docker Compose

Instead of using the add-on system, run via Docker Compose on Home Assistant OS:

```yaml
services:
  zigbee2mqtt:
    image: ghcr.io/abaddon/zigbee2mqtt:latest
    volumes:
      - /share/zigbee2mqtt:/app/data
    devices:
      - /dev/ttyACM0:/dev/ttyACM0
    environment:
      - TZ=America/New_York
    ports:
      - 8099:8080
```

## Phase 5: Testing & Validation

### 5.1 Pre-Release Checklist
- [ ] All repository references updated
- [ ] GitHub Actions workflow passes locally (act tool)
- [ ] Docker image builds successfully
- [ ] Image pushed to GHCR
- [ ] Image can be pulled from GHCR
- [ ] Multi-arch images built for your target platforms

### 5.2 Home Assistant Testing
- [ ] Add-on configuration loads
- [ ] Container starts successfully
- [ ] Zigbee adapter detected
- [ ] MQTT connection works
- [ ] Devices can be paired
- [ ] Frontend accessible
- [ ] Home Assistant discovery works

## Phase 6: Maintenance Strategy

### 6.1 Syncing with Upstream

**Strategy for Getting Updates**:
```bash
# Add upstream remote
git remote add upstream https://github.com/Koenkk/zigbee2mqtt.git

# Fetch upstream changes
git fetch upstream

# Merge upstream into your dev branch
git checkout dev
git merge upstream/dev

# Resolve conflicts (especially in workflows)
# Rebuild and test
```

**Conflicts to Expect**:
- GitHub workflow files (you've customized these)
- package.json (different repo URLs)
- Docker labels (your branding)

### 6.2 Custom Feature Development

**Recommended Branch Strategy**:
- `master`: Stable releases (mirrors upstream cadence or your own)
- `dev`: Development branch (where you merge upstream + your features)
- `feature/*`: Individual feature branches
- `upstream`: Clean mirror of upstream/dev (no changes)

**Workflow**:
1. Create feature branch from `dev`
2. Develop and test feature
3. Merge to `dev`
4. CI builds and pushes `latest-dev` tag
5. After testing, merge `dev` to `master` for release
6. CI builds and pushes version tags

## Summary of Files to Modify

### Must Change:
1. `.github/workflows/ci.yml` - Docker registry, remove add-on triggers, npm
2. `.github/workflows/release-please.yml` - Gist ID or remove gist
3. `.github/FUNDING.yml` - Remove or replace
4. `package.json` - Repository URLs

### Should Verify:
5. `docker/Dockerfile` - Labels already updated, verify correctness

### Optional:
6. `index.js` - Branding in console output
7. `lib/controller.ts` - Branding in logs
8. `lib/util/settings.ts` - Default configuration

## Next Steps

After approval of this plan:
1. Make Phase 1 changes (required configuration)
2. Test GitHub Actions workflow
3. Build and push first Docker image
4. Set up Home Assistant add-on configuration
5. Deploy and test
6. (Optional) Phase 2 customizations
7. Develop your custom features

## Questions/Decisions Needed

1. **Version Strategy**: Independent versioning or track upstream?
2. **NPM Publishing**: Remove entirely or publish under your scope?
3. **Auto-merge dev→master**: Keep or remove?
4. **Architecture Support**: Which platforms do you need?
5. **Home Assistant Setup**: Local add-on config or Docker Compose?
6. **Branding Level**: Minimal or full custom branding?

---

**Estimated Complexity**: Medium
**Time to Complete Phase 1**: 1-2 hours (mostly waiting for CI builds)
**Prerequisites**: GitHub account with GHCR enabled, Home Assistant OS installation
