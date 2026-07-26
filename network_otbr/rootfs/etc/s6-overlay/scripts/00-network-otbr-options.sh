#!/usr/bin/with-contenv bash
set -euo pipefail

OPTIONS_FILE="/data/options.json"
ENV_DIR="/run/s6/container_environment"

if [[ ! -f "${OPTIONS_FILE}" ]]; then
    echo "ERROR: Home Assistant App options file not found: ${OPTIONS_FILE}"
    exit 1
fi

mkdir -p "${ENV_DIR}"

write_env() {
    local name="$1"
    local value="$2"

    printf '%s' "${value}" > "${ENV_DIR}/${name}"
    chmod 0600 "${ENV_DIR}/${name}"
}

bool_to_int() {
    if [[ "$1" == "true" ]]; then
        printf '1'
    else
        printf '0'
    fi
}

NETWORK_DEVICE="$(jq -er '.network_device' "${OPTIONS_FILE}")"
BACKBONE_IF="$(jq -er '.backbone_interface' "${OPTIONS_FILE}")"
BAUDRATE="$(jq -er '.baudrate' "${OPTIONS_FILE}")"
FLOW_CONTROL="$(bool_to_int "$(jq -er '.flow_control' "${OPTIONS_FILE}")")"
OTBR_LOG_LEVEL="$(jq -er '.otbr_log_level' "${OPTIONS_FILE}")"
FIREWALL="$(bool_to_int "$(jq -er '.firewall' "${OPTIONS_FILE}")")"
NAT64="$(bool_to_int "$(jq -er '.nat64' "${OPTIONS_FILE}")")"
BETA="$(bool_to_int "$(jq -er '.beta' "${OPTIONS_FILE}")")"

write_env DEVICE "/tmp/ttyOTBR"
write_env NETWORK_DEVICE "${NETWORK_DEVICE}"
write_env BACKBONE_IF "${BACKBONE_IF}"
write_env BAUDRATE "${BAUDRATE}"
write_env FLOW_CONTROL "${FLOW_CONTROL}"
write_env AUTOFLASH_FIRMWARE "0"
write_env OTBR_LOG_LEVEL "${OTBR_LOG_LEVEL}"
write_env FIREWALL "${FIREWALL}"
write_env NAT64 "${NAT64}"
write_env BETA "${BETA}"

echo "INFO: Network OTBR configuration loaded"
echo "INFO: Network RCP: ${NETWORK_DEVICE}"
echo "INFO: Backbone interface: ${BACKBONE_IF}"
echo "INFO: Baud rate: ${BAUDRATE}"
echo "INFO: OTBR log level: ${OTBR_LOG_LEVEL}"
