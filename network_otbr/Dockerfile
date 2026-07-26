FROM denniswitt/homeassistant-otbr:4

ARG BUILD_VERSION
ARG BUILD_ARCH

COPY rootfs /

RUN chmod 0755 /etc/s6-overlay/scripts/network-otbr-options.sh \
    && sed -i '2i eval "$(/etc/s6-overlay/scripts/network-otbr-options.sh | tee /dev/stderr | grep ^export)"' \
       /etc/s6-overlay/scripts/enable-check.sh

LABEL \
  io.hass.version="${BUILD_VERSION}" \
  io.hass.type="app" \
  io.hass.arch="${BUILD_ARCH}"
