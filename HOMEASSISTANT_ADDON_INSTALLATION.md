# Installing Abaddon Zigbee2MQTT as a Home Assistant Add-on

This repository is configured as a **Home Assistant Add-on Repository**, allowing you to install your custom Zigbee2MQTT build directly from Home Assistant without any manual file copying!

## 🎯 Quick Installation

### Step 1: Add Repository to Home Assistant

1. **Open Home Assistant**
   - Navigate to **Settings** → **Add-ons** → **Add-on Store**

2. **Add Custom Repository**
   - Click the **⋮** menu button (top right corner)
   - Select **Repositories**
   - Add this URL:
     ```
     https://github.com/abaddon/zigbee2mqtt
     ```
   - Click **Add**
   - Click **Close**

3. **Refresh the Page**
   - Refresh your browser or click around to reload the add-on store

### Step 2: Install the Add-on

1. **Find Your Add-on**
   - Scroll down in the Add-on Store
   - Look for **"Abaddon Zigbee2MQTT"**
   - (It may take a minute to appear after adding the repository)

2. **Install**
   - Click on "Abaddon Zigbee2MQTT"
   - Click **Install**
   - Wait for installation to complete (pulls from GHCR)

### Step 3: Configure the Add-on

1. **Basic Configuration**
   - Go to the **Configuration** tab
   - Set your configuration:

   ```yaml
   data_path: /config/zigbee2mqtt
   mqtt:
     server: mqtt://core-mosquitto:1883
     user: your_mqtt_user
     password: your_mqtt_password
   serial:
     port: /dev/ttyACM0
   ```

2. **Find Your Serial Device**

   If you don't know your device path:
   - Install **Advanced SSH & Web Terminal** add-on
   - Run: `ls -l /dev/serial/by-id`
   - Use the full path shown

3. **Save Configuration**

### Step 4: Start the Add-on

1. **Start**
   - Go to the **Info** tab
   - Click **Start**

2. **Check Logs**
   - Go to the **Log** tab
   - Verify Zigbee2MQTT starts successfully

3. **Access Frontend**
   - Open: `http://homeassistant.local:8099`
   - Or use the **Web UI** button if it appears

## 📝 Configuration Options

### Full Configuration Example

```yaml
data_path: /config/zigbee2mqtt
mqtt:
  server: mqtt://core-mosquitto:1883
  user: mqtt_user
  password: mqtt_password
  base_topic: zigbee2mqtt
serial:
  port: /dev/ttyACM0
  adapter: auto
socat:
  enabled: false
```

### Configuration Fields

| Field | Required | Description | Default |
|-------|----------|-------------|---------|
| `data_path` | Yes | Where Zigbee2MQTT stores data | `/config/zigbee2mqtt` |
| `mqtt.server` | Yes | MQTT broker address | - |
| `mqtt.user` | No | MQTT username | - |
| `mqtt.password` | No | MQTT password | - |
| `mqtt.base_topic` | No | MQTT topic prefix | `zigbee2mqtt` |
| `serial.port` | Yes | Zigbee adapter device | - |
| `serial.adapter` | No | Adapter type | `auto` |

## 🔄 Updating the Add-on

When a new version is released:

1. **Automatic Update**
   - Go to **Settings** → **Add-ons**
   - If an update is available, you'll see an **Update** button
   - Click **Update**

2. **Manual Update**
   - Go to the add-on page
   - Click **Rebuild** to pull the latest image

## 🏗️ How It Works

### Architecture

```
GitHub Repository (abaddon/zigbee2mqtt)
    ├── repository.yaml          # Repository metadata
    └── abaddon-zigbee2mqtt/     # Add-on definition
        ├── config.yaml           # Add-on configuration
        ├── Dockerfile            # Pulls from GHCR
        ├── run.sh               # Startup script
        ├── DOCS.md              # Documentation
        └── CHANGELOG.md         # Version history

GitHub Actions (CI/CD)
    ├── Builds Docker image → pushes to GHCR
    └── Updates add-on version automatically

Home Assistant
    ├── Pulls add-on definition from GitHub
    └── Pulls Docker image from GHCR
```

### Update Flow

1. **Code Changes** → Push to `dev` branch
2. **CI Builds** → Creates Docker image
3. **Docker Image** → Pushed to `ghcr.io/abaddon/zigbee2mqtt`
4. **Release Created** → Version tag pushed
5. **Add-on Updated** → Workflow updates `config.yaml` version
6. **Home Assistant** → Sees new version, offers update

## 🔧 Troubleshooting

### Add-on Doesn't Appear

**Problem**: Repository added but add-on not showing

**Solutions**:
1. Wait 1-2 minutes and refresh the page
2. Check the repository URL is correct
3. Ensure `repository.yaml` exists in the GitHub repo
4. Check browser console for errors (F12)

### Installation Fails

**Problem**: "Failed to install add-on"

**Solutions**:
1. **Check GHCR image exists**:
   - Visit: https://github.com/abaddon/zigbee2mqtt/pkgs/container/zigbee2mqtt
   - Verify the image is public

2. **Check logs**:
   - System → System Log
   - Look for add-on installation errors

3. **Rebuild**:
   - Sometimes the first install fails
   - Try clicking **Rebuild**

### Can't Start Add-on

**Problem**: Add-on installed but won't start

**Solutions**:
1. **Check serial device**:
   ```bash
   ls -l /dev/ttyACM0
   # Should show the device exists
   ```

2. **Check configuration**:
   - Verify MQTT server is reachable
   - Verify serial port is correct

3. **Check logs**:
   - Go to add-on Log tab
   - Look for error messages

### MQTT Connection Failed

**Problem**: "Failed to connect to MQTT server"

**Solutions**:
1. **Verify MQTT broker is running**:
   - Check Mosquitto broker add-on is started

2. **Check MQTT settings**:
   - Server format: `mqtt://core-mosquitto:1883`
   - Use `core-mosquitto` hostname for HA add-on broker
   - Check username/password are correct

3. **Test MQTT**:
   - Use MQTT Explorer to verify broker works
   - Check broker logs

## 🎨 Customization

### Change Add-on Icon

1. Add `icon.png` and `logo.png` to `abaddon-zigbee2mqtt/`
2. Size: 256x256 pixels
3. Format: PNG with transparency
4. Commit and push changes

### Change Add-on Name/Description

Edit `abaddon-zigbee2mqtt/config.yaml`:
```yaml
name: My Custom Zigbee2MQTT
description: My personalized Zigbee bridge
```

## 📊 Version Management

### How Versions Are Updated

1. **Manual Update** (during development):
   - Edit `abaddon-zigbee2mqtt/config.yaml`
   - Change `version: "1.0.0"` to new version
   - Commit and push

2. **Automatic Update** (on release):
   - Create a release tag (e.g., `1.1.0`)
   - GitHub Action automatically updates:
     - `abaddon-zigbee2mqtt/config.yaml` version
     - `abaddon-zigbee2mqtt/Dockerfile` image tag
   - Commits changes back to `dev` branch

### Best Practices

- Keep add-on version in sync with package.json version
- Use semantic versioning (MAJOR.MINOR.PATCH)
- Update CHANGELOG.md with each version
- Test add-on before releasing new version

## 🆚 Comparison: Add-on Repository vs Local Add-on

### Home Assistant Add-on Repository (This Method)

✅ **Pros**:
- Install directly from HA UI
- Automatic updates
- Easy to share with others
- Professional appearance
- No manual file copying

❌ **Cons**:
- Requires public GitHub repository
- Need to push changes to update

### Local Add-on (Manual)

✅ **Pros**:
- Works offline
- Instant updates (just restart)
- Full control

❌ **Cons**:
- Manual file management
- Need filesystem access
- No automatic updates
- Can't easily share

## 🚀 Advanced Usage

### Using Specific Versions

Edit `abaddon-zigbee2mqtt/Dockerfile` to pin to a specific version:

```dockerfile
ARG BUILD_FROM=ghcr.io/abaddon/zigbee2mqtt:1.2.3
FROM ${BUILD_FROM}
```

### Using Dev Builds

For testing, use `latest-dev`:

```dockerfile
ARG BUILD_FROM=ghcr.io/abaddon/zigbee2mqtt:latest-dev
FROM ${BUILD_FROM}
```

### Multiple Add-ons

You can have multiple add-on variants in one repository:

```
repository.yaml
├── abaddon-zigbee2mqtt/          # Stable version
├── abaddon-zigbee2mqtt-beta/     # Beta version
└── abaddon-zigbee2mqtt-dev/      # Development version
```

Each appears as a separate add-on in Home Assistant!

## 📚 Additional Resources

- [Home Assistant Add-on Development](https://developers.home-assistant.io/docs/add-ons)
- [Zigbee2MQTT Documentation](https://www.zigbee2mqtt.io/)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)

## 🆘 Getting Help

**For custom build issues**:
- GitHub Issues: https://github.com/abaddon/zigbee2mqtt/issues

**For general Zigbee2MQTT help**:
- Official Docs: https://www.zigbee2mqtt.io/
- Community: https://github.com/Koenkk/zigbee2mqtt/discussions

---

**Congratulations!** 🎉 You now have your custom Zigbee2MQTT running as a Home Assistant add-on!
