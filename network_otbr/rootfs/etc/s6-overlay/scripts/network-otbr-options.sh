#!/usr/bin/with-contenv bash
set -euo pipefail

OPTIONS_FILE="/data/options.json"
ENV_DIR="/run/s6/container_environment"

if [[ ! -f "${OPTIONS_FILE}" ]]; then
    echo "ERROR: Home Assistant App options file not found: ${OPTIONS_FILE}"
    exit 1
fi

mkdir -p "${ENV_DIR}"

python3 - "${OPTIONS_FILE}" "${ENV_DIR}" <<'PY'
import json
import pathlib
import sys

options_file = pathlib.Path(sys.argv[1])
env_dir = pathlib.Path(sys.argv[2])

with options_file.open(encoding="utf-8") as file:
    options = json.load(file)

def boolean(value):
    return "1" if value is True else "0"

environment = {
    "DEVICE": "/tmp/ttyOTBR",
    "NETWORK_DEVICE": str(options["network_device"]),
    "BACKBONE_IF": str(options["backbone_interface"]),
    "BAUDRATE": str(options["baudrate"]),
    "FLOW_CONTROL": boolean(options["flow_control"]),
    "AUTOFLASH_FIRMWARE": "0",
    "OTBR_LOG_LEVEL": str(options["otbr_log_level"]),
    "FIREWALL": boolean(options["firewall"]),
    "NAT64": boolean(options["nat64"]),
    "BETA": boolean(options["beta"]),
}

for name, value in environment.items():
    destination = env_dir / name
    destination.write_text(value, encoding="utf-8")
    destination.chmod(0o600)
    print(f"export {name}={value!r}")

print("INFO: Network OTBR configuration loaded")
print(f"INFO: Network RCP: {environment['NETWORK_DEVICE']}")
print(f"INFO: Backbone interface: {environment['BACKBONE_IF']}")
PY
