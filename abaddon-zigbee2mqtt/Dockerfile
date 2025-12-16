ARG BUILD_FROM=ghcr.io/abaddon/zigbee2mqtt:0.0.3
FROM ${BUILD_FROM}

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
