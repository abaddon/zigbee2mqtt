ARG BUILD_FROM=ghcr.io/abaddon/zigbee2mqtt:latest
FROM ${BUILD_FROM}

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
