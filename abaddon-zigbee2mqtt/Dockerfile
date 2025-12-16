ARG BUILD_FROM=ghcr.io/abaddon/zigbee2mqtt:1.0.0
FROM ${BUILD_FROM}

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
