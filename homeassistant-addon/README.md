# Home Assistant Add-on Configuration

This directory contains templates for setting up your custom Zigbee2MQTT build as a local Home Assistant add-on.

## Installation on Home Assistant OS

### Option 1: Local Add-on (Recommended)

1. **Access your Home Assistant OS filesystem**
   - Via SSH add-on with "Protection mode" disabled
   - Via Samba/SMB share add-on
   - Via terminal on the host machine

2. **Create the add-on directory structure**
   ```bash
   mkdir -p /addons/abaddon-zigbee2mqtt
   ```

3. **Copy the configuration files**
   - Copy `config.yaml` to `/addons/abaddon-zigbee2mqtt/config.yaml`
   - Copy `DOCS.md` to `/addons/abaddon-zigbee2mqtt/DOCS.md`
   - Copy `CHANGELOG.md` to `/addons/abaddon-zigbee2mqtt/CHANGELOG.md`

4. **Install the add-on**
   - Go to Settings → Add-ons → Add-on Store
   - Click the three dots menu (⋮) in the top right
   - Select "Repositories"
   - If you don't see your local add-on, restart Home Assistant Core
   - You should see "Abaddon Zigbee2MQTT" in the Local Add-ons section

5. **Configure the add-on**
   - Click on "Abaddon Zigbee2MQTT"
   - Go to the Configuration tab
   - Set your MQTT server, serial port, etc.
   - Save and start the add-on

### Option 2: Docker Compose (Advanced)

If you prefer to run the container directly without the add-on system:

1. **Create a docker-compose.yml file** on your Home Assistant OS host:
   ```yaml
   services:
     zigbee2mqtt:
       container_name: abaddon-zigbee2mqtt
       image: ghcr.io/abaddon/zigbee2mqtt:latest
       restart: unless-stopped
       volumes:
         - /share/abaddon-zigbee2mqtt:/app/data
       devices:
         - /dev/ttyACM0:/dev/ttyACM0  # Adjust to your Zigbee adapter
       environment:
         - TZ=America/New_York  # Adjust to your timezone
       ports:
         - 8099:8080
   ```

2. **Start the container**:
   ```bash
   docker-compose up -d
   ```

3. **Access the frontend**: Navigate to `http://your-homeassistant-ip:8099`

## Configuration Options

### config.yaml Structure

The `config.yaml` file defines the add-on metadata and options. Key sections:

- **name**: Display name in Home Assistant
- **version**: Should match your Docker image version
- **slug**: URL-friendly identifier
- **description**: Brief description shown in UI
- **arch**: Supported architectures (aarch64, amd64, armv7)
- **image**: Your GHCR image URL
- **ports**: Port mapping (8080/tcp is the default Zigbee2MQTT frontend port)
- **options**: Default configuration values
- **schema**: Configuration validation schema

### Updating the Add-on

When you push a new version:

1. Build and push the new Docker image via GitHub Actions
2. Update the `version` field in `config.yaml`
3. Update `CHANGELOG.md` with changes
4. In Home Assistant, go to the add-on page
5. Click "Reload" (three dots menu → Reload)
6. You should see the update available

## Troubleshooting

### Add-on doesn't appear

- Make sure files are in `/addons/abaddon-zigbee2mqtt/`
- Restart Home Assistant Core
- Check that `config.yaml` is valid YAML

### Container won't start

- Check logs in the add-on page
- Verify the serial device path is correct
- Ensure the device is accessible: `ls -l /dev/ttyACM0`
- Check MQTT connection settings

### Image pull fails

- Verify your GHCR image is public or you've authenticated
- Check the image tag exists: `docker pull ghcr.io/abaddon/zigbee2mqtt:latest`
- Review GitHub Actions workflow run to ensure build succeeded

## Advanced Configuration

### Using Private GHCR Images

If your image is private, you'll need to authenticate Home Assistant with GHCR:

1. Create a GitHub Personal Access Token with `read:packages` permission
2. In Home Assistant, configure Docker registry authentication (varies by setup)

### Pinning to Specific Versions

Instead of `:latest`, you can pin to specific versions:

```yaml
image: ghcr.io/abaddon/zigbee2mqtt:1.2.3
```

This prevents automatic updates and ensures stability.

### Multi-Container Setup

If you're running MQTT broker separately, adjust the MQTT configuration in the add-on options to point to your broker's address.

## Resources

- [Home Assistant Add-on Documentation](https://developers.home-assistant.io/docs/add-ons)
- [Zigbee2MQTT Documentation](https://www.zigbee2mqtt.io/)
- Your GitHub Repository: https://github.com/abaddon/zigbee2mqtt
