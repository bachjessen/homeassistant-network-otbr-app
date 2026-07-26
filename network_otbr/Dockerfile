FROM denniswitt/homeassistant-otbr:4

ARG BUILD_VERSION
ARG BUILD_ARCH

RUN apk add --no-cache jq

COPY rootfs /

RUN chmod 0755 /etc/s6-overlay/scripts/00-network-otbr-options.sh

LABEL \
  io.hass.version="${BUILD_VERSION}" \
  io.hass.type="app" \
  io.hass.arch="${BUILD_ARCH}"
