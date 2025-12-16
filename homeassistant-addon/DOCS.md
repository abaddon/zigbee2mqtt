# Abaddon Zigbee2MQTT Add-on Documentation

This is a custom build of Zigbee2MQTT with additional features and fixes.

## About

Zigbee2MQTT is a powerful bridge that allows you to use Zigbee devices without the need for vendor-specific bridges or gateways. It bridges events and allows you to control your Zigbee devices via MQTT.

This custom build includes:
- Custom features and enhancements
- Bug fixes and improvements
- Optimized for your specific use case

## Configuration

### Basic Configuration

The add-on requires minimal configuration to get started. At minimum, you need to configure:

1. **MQTT Broker**: Connection details for your MQTT server
2. **Serial Port**: The device path to your Zigbee adapter

### MQTT Configuration

```yaml
mqtt:
  server: mqtt://localhost:1883
  user: your_mqtt_user
  password: your_mqtt_password
  base_topic: zigbee2mqtt
```

### Serial Configuration

Find your Zigbee adapter device:

```bash
ls -l /dev/serial/by-id
```

Common paths:
- `/dev/ttyACM0` - ConBee II, CC2531 with USB
- `/dev/ttyUSB0` - CC2531 with serial
- `/dev/serial/by-id/usb-Texas_Instruments_...` - Texas Instruments adapters

```yaml
serial:
  port: /dev/ttyACM0
```

### Advanced Configuration

For advanced configuration options, you can create a `configuration.yaml` file in your data directory (`/share/zigbee2mqtt/configuration.yaml` by default).

Example configuration:

```yaml
# Home Assistant integration
homeassistant: true

# MQTT settings
mqtt:
  base_topic: zigbee2mqtt
  server: mqtt://localhost:1883

# Serial settings
serial:
  port: /dev/ttyACM0

# Enable frontend
frontend:
  port: 8080

# Permit join
permit_join: false

# Advanced settings
advanced:
  log_level: info
  pan_id: 6754
  channel: 11
  network_key: GENERATE

# Device-specific configuration
devices:
  '0x00158d0001234567':
    friendly_name: 'living_room_sensor'
```

## Usage

### Pairing Devices

1. Open the Zigbee2MQTT frontend (http://homeassistant.local:8099)
2. Click "Permit join (All)" to enable pairing mode
3. Put your Zigbee device into pairing mode (usually by holding a button)
4. Wait for the device to appear in the devices list
5. Disable pairing mode when done

### Home Assistant Integration

If you have `homeassistant: true` in your configuration, devices will automatically appear in Home Assistant via MQTT discovery.

### Viewing Logs

- Click on the "Log" tab in the add-on page
- Set log level in configuration: `debug`, `info`, `warn`, or `error`

## Troubleshooting

### Device won't pair

- Ensure permit join is enabled
- Reset the device (check device manual)
- Move the device closer to the Zigbee coordinator
- Check the logs for errors

### MQTT connection issues

- Verify MQTT broker is running
- Check username and password
- Ensure network connectivity
- Review MQTT broker logs

### Serial port errors

- Verify the device is connected: `ls -l /dev/ttyACM0`
- Check device permissions
- Ensure no other service is using the port
- Try unplugging and replugging the adapter

## Support

For issues specific to this custom build:
- GitHub Issues: https://github.com/abaddon/zigbee2mqtt/issues

For general Zigbee2MQTT help:
- Official Documentation: https://www.zigbee2mqtt.io/
- Community Forum: https://github.com/Koenkk/zigbee2mqtt/discussions

## Version Information

This is a custom fork based on Zigbee2MQTT. Version numbers are independent from the upstream project.

- Current Version: 1.0.0
- Base: Zigbee2MQTT (upstream)
- Custom Features: [Document your custom features here]
