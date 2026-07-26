FROM denniswitt/homeassistant-otbr:4

ARG BUILD_VERSION
ARG BUILD_ARCH

COPY rootfs /

RUN chmod 0755 /etc/cont-init.d/00-network-otbr-options

LABEL \
  io.hass.version="${BUILD_VERSION}" \
  io.hass.type="app" \
  io.hass.arch="${BUILD_ARCH}"
