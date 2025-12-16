#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

CONFIG_PATH=/data/options.json
DATA_PATH=$(bashio::config 'data_path')

# Create data directory if it doesn't exist
mkdir -p "${DATA_PATH}"

# Set environment variable for data directory
export ZIGBEE2MQTT_DATA="${DATA_PATH}"

bashio::log.info "Starting Abaddon Zigbee2MQTT..."
bashio::log.info "Data directory: ${DATA_PATH}"

# Start Zigbee2MQTT
cd /app
exec node index.js
