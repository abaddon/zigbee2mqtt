# Getting Started - Custom Zigbee2MQTT Build

This guide will walk you through the next steps to build, publish, and deploy your custom Zigbee2MQTT build.

## ✅ What's Been Done

Your repository has been configured with:

1. ✅ **GitHub Actions Workflows**
   - GHCR (GitHub Container Registry) publishing configured
   - Multi-architecture builds (amd64, arm64)
   - npm publishing removed
   - Upstream add-on triggers removed

2. ✅ **Repository Configuration**
   - All repository URLs updated to point to abaddon/zigbee2mqtt
   - Funding links cleaned up
   - Docker labels already configured

3. ✅ **Independent Versioning**
   - Version reset to 1.0.0
   - Release-please configured for independent versioning

4. ✅ **Home Assistant Add-on Templates**
   - Configuration templates created in `homeassistant-addon/` directory

## 📋 Prerequisites

Before proceeding, ensure you have:

- [x] GitHub account (abaddon) ✓
- [ ] GitHub Container Registry enabled
- [ ] Understanding of git and GitHub workflows
- [ ] Home Assistant OS installation (for testing)
- [ ] Zigbee adapter for testing

## 🚀 Next Steps

### Step 1: Enable GitHub Container Registry

1. Go to your GitHub profile settings
2. Navigate to "Developer settings" → "Personal access tokens" → "Tokens (classic)"
3. The `GITHUB_TOKEN` secret is automatically available in GitHub Actions - no setup needed!
4. Ensure your repository has "Packages" enabled in Settings

### Step 2: Commit and Push Changes

All the configuration changes have been made locally. Now you need to commit and push them:

```bash
# Review the changes
git status
git diff

# Commit all changes
git add .
git commit -m "Configure custom build: GHCR publishing, independent versioning, remove npm/add-on triggers"

# Push to dev branch
git push origin dev
```

### Step 3: Trigger First Build

Once you push to the `dev` branch, GitHub Actions will automatically:

1. Run tests and linting
2. Build the TypeScript code
3. Build Docker images for amd64 and arm64
4. Push to `ghcr.io/abaddon/zigbee2mqtt:latest-dev`

**Monitor the build:**
- Go to https://github.com/abaddon/zigbee2mqtt/actions
- Click on the latest "CI" workflow run
- Watch the progress (builds can take 10-30 minutes due to multi-architecture)

### Step 4: Verify Image Publication

Once the workflow succeeds:

1. Go to your GitHub profile → Packages
2. You should see `zigbee2mqtt` package
3. Click on it to see tags (should show `latest-dev`)
4. **Important**: Make the package public
   - Click on the package
   - Go to "Package settings" (right sidebar)
   - Scroll to "Danger Zone"
   - Click "Change visibility" → "Public"

### Step 5: Test Pulling the Image

On any machine with Docker:

```bash
# Pull your custom image
docker pull ghcr.io/abaddon/zigbee2mqtt:latest-dev

# Verify it works
docker run --rm ghcr.io/abaddon/zigbee2mqtt:latest-dev --version
```

### Step 6: Set Up Home Assistant Add-on

#### Option A: Local Add-on (Recommended)

1. **Access Home Assistant OS filesystem**
   ```bash
   # Via SSH add-on or direct console access
   mkdir -p /addons/abaddon-zigbee2mqtt
   ```

2. **Copy add-on configuration files**
   - Copy files from `homeassistant-addon/` directory to Home Assistant:
   ```bash
   # On your local machine
   scp homeassistant-addon/* root@homeassistant.local:/addons/abaddon-zigbee2mqtt/
   ```

3. **Update config.yaml with your image**
   - Edit `/addons/abaddon-zigbee2mqtt/config.yaml`
   - Ensure `image: ghcr.io/abaddon/zigbee2mqtt` is correct
   - Update version to match your build

4. **Reload Home Assistant**
   - Go to Settings → System → Reload configuration
   - Or restart Home Assistant Core

5. **Install the add-on**
   - Go to Settings → Add-ons → Add-on Store
   - Look for "Abaddon Zigbee2MQTT" in Local Add-ons
   - Click to install

#### Option B: Docker Compose

See `homeassistant-addon/README.md` for Docker Compose setup instructions.

### Step 7: Create Your First Release

When you're ready to create a stable release:

1. **Let release-please create a PR**
   - After pushing to `dev`, release-please will analyze commits
   - It will create a PR with version bump and changelog
   - Review the PR

2. **Merge the release PR**
   - Merge the release-please PR to `dev`
   - This will create a git tag (e.g., `1.0.0`)

3. **GitHub Actions will automatically:**
   - Build and push versioned images: `ghcr.io/abaddon/zigbee2mqtt:1.0.0`
   - Create a GitHub release with notes

4. **Update your Home Assistant add-on**
   - Edit `/addons/abaddon-zigbee2mqtt/config.yaml`
   - Change version to `1.0.0`
   - Update image tag if you want to pin to a specific version

## 🔧 Development Workflow

### Making Code Changes

1. **Create a feature branch**
   ```bash
   git checkout -b feature/my-new-feature
   ```

2. **Make your changes**
   - Edit code in `lib/` directory
   - Add tests in `test/` directory
   - Update documentation

3. **Test locally**
   ```bash
   pnpm install
   pnpm run build
   pnpm run test
   ```

4. **Commit with conventional commits**
   ```bash
   git commit -m "feat: add new feature X"
   # or
   git commit -m "fix: resolve issue with Y"
   # or
   git commit -m "chore: update dependencies"
   ```

5. **Push and create PR**
   ```bash
   git push origin feature/my-new-feature
   # Create PR on GitHub targeting dev branch
   ```

### Syncing with Upstream (Optional)

If you want to pull updates from the original Zigbee2MQTT:

```bash
# Add upstream remote (one time)
git remote add upstream https://github.com/Koenkk/zigbee2mqtt.git

# Fetch upstream changes
git fetch upstream

# Merge upstream into your dev branch
git checkout dev
git merge upstream/dev

# Resolve conflicts (especially in workflow files)
# Your customizations in:
# - .github/workflows/ci.yml
# - .github/workflows/release-please.yml
# - package.json
# Should be preserved

# Push updated dev branch
git push origin dev
```

## 📊 Monitoring and Maintenance

### GitHub Actions Monitoring

- **CI Workflow**: Runs on every push/PR
  - https://github.com/abaddon/zigbee2mqtt/actions

- **Release Please**: Runs on push to dev
  - Automatically creates release PRs

### Image Management

- **View all images**: https://github.com/abaddon?tab=packages
- **Image tags**:
  - `latest-dev`: Latest development build
  - `1.0.0`, `1.1.0`, etc.: Stable releases
  - `1.0`, `1`: Semantic versioning aliases

### Storage Cleanup

GitHub Container Registry has free storage limits. To manage:

1. Go to Package settings
2. Set up retention policies
3. Delete old/unused tags

## 🐛 Troubleshooting

### Build Fails

**Check the workflow logs:**
- Go to Actions tab
- Click on failed workflow
- Expand failed step to see error

**Common issues:**
- TypeScript errors: Fix in code and push
- Docker build errors: Check Dockerfile and build context
- Permission errors: Verify GITHUB_TOKEN has package write permissions

### Image Won't Pull

**Make package public:**
- Package settings → Change visibility → Public

**Check image exists:**
```bash
docker pull ghcr.io/abaddon/zigbee2mqtt:latest-dev
```

### Add-on Won't Install

**Verify files are in correct location:**
```bash
ls -la /addons/abaddon-zigbee2mqtt/
# Should show: config.yaml, DOCS.md, CHANGELOG.md
```

**Check config.yaml syntax:**
```bash
# Validate YAML
yamllint /addons/abaddon-zigbee2mqtt/config.yaml
```

**Reload Home Assistant:**
- Settings → System → Reload configuration
- Or restart

## 📚 Additional Resources

### Documentation Created

- `CUSTOM_BUILD_PLAN.md` - Comprehensive implementation plan
- `homeassistant-addon/README.md` - Add-on installation guide
- `homeassistant-addon/DOCS.md` - Add-on user documentation
- `homeassistant-addon/CHANGELOG.md` - Version history

### External Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [Release Please](https://github.com/googleapis/release-please)
- [Home Assistant Add-on Development](https://developers.home-assistant.io/docs/add-ons)
- [Zigbee2MQTT Documentation](https://www.zigbee2mqtt.io/)

## ✨ What's Next?

Now that your build system is configured:

1. **Push your changes** to trigger the first build
2. **Verify the Docker image** is published to GHCR
3. **Install the add-on** on Home Assistant
4. **Start developing** your custom features!

## 🆘 Getting Help

If you encounter issues:

1. Check the troubleshooting section above
2. Review GitHub Actions workflow logs
3. Check Docker/Home Assistant logs
4. Create an issue in your repository for tracking

---

**Remember**: This is your custom build! You have complete control over:
- Feature development
- Release timing
- Version numbering
- Build configuration

Happy coding! 🚀
