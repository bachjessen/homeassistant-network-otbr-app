# Home Assistant Network OTBR App

A Home Assistant OS App for running OpenThread Border Router with a network-connected Radio Co-Processor, without requiring a local USB or serial device.

## Features

- Network-only Thread RCP support
- Native Home Assistant configuration UI
- Home Assistant OS lifecycle management
- Start-on-boot and watchdog support
- OpenThread Web UI and REST API
- OpenThread branding
- Support for `aarch64` and `amd64`

## Why this App exists

The official Home Assistant OpenThread Border Router App supports `network_device`, but its configuration schema also requires a local serial device detected by Supervisor.

This prevents network-only installations when Home Assistant OS has no eligible local TTY device.

Relevant upstream reports:

- https://github.com/home-assistant/addons/issues/3620
- https://github.com/home-assistant/addons/issues/3993
- https://github.com/home-assistant/addons/issues/4568

## Installation

1. Open **Settings > Apps > App store** in Home Assistant.
2. Open the three-dot menu and select **Repositories**.
3. Add:

   https://github.com/bachjessen/homeassistant-network-otbr-app

4. Install **Network OTBR**.
5. Enable **Start on boot** and **Watchdog**.

## Example configuration

```yaml
network_device: 192.168.1.10:6638
backbone_interface: end0
baudrate: "460800"
flow_control: false
otbr_log_level: notice
firewall: true
nat64: false
beta: false
```

Change `network_device` to the IP address and TCP port of the Thread RCP.

Set `backbone_interface` to the active Home Assistant host interface. Common interface names include:

- `end0`
- `eth0`
- `wlan0`

The active default interface is shown under Home Assistant System Information.

## Configuration options

### Network device

The address of the network-connected Thread RCP in `host:port` format.

Example:

```text
192.168.1.10:6638
```

For SMLIGHT devices, verify the Thread radio socket port in the SMLIGHT control panel.

### Backbone interface

The Home Assistant host interface used for routing between the Thread network and the infrastructure network.

### Baud rate

The serial baud rate used by the TCP-to-pseudo-serial bridge. The App and RCP must use matching values.

A common value for EFR32-based SMLIGHT radios is:

```text
460800
```

### Hardware flow control

Enable only when required by the RCP firmware. Network-connected SMLIGHT RCPs normally use this disabled.

### OTBR log level

`notice` is recommended for normal operation. Use `info` or `debug` temporarily when troubleshooting.

### Firewall

Enables the OTBR Thread firewall. Keeping this enabled is recommended.

### NAT64

Allows IPv6-only Thread devices to access IPv4-only destinations. Most Matter and Thread installations do not require NAT64.

### Beta features

Enables experimental upstream OTBR behavior. Keep this disabled unless a specific upstream release or troubleshooting procedure requires it.

## Home Assistant integration

Automatic discovery is disabled by the standalone upstream image.

If the OpenThread Border Router integration is not already configured:

1. Open **Settings > Devices & services**.
2. Select **Add integration**.
3. Select **OpenThread Border Router**.
4. Enter:

```text
http://HOME_ASSISTANT_IP:8081
```

Home Assistant can then provision the preferred Thread Operational Dataset.

A healthy OTBR node normally changes through these states:

```text
disabled -> detached -> child -> router
```

The final role may instead be `leader`, depending on the Thread network topology.

## Web interfaces

- OTBR Web UI: port `8080`
- OTBR REST API: port `8081`

The OTBR Web UI is intended mainly for status and troubleshooting.

Manage the preferred Thread network and Operational Dataset through Home Assistant. Do not form a separate network through the OTBR Web UI unless that is explicitly intended.

## Migration from the official App

1. Stop the official OpenThread Border Router App.
2. Disable its **Start on boot** and **Watchdog** options.
3. Install and configure Network OTBR.
4. Start Network OTBR.
5. Confirm that the RCP is connected.
6. Confirm that the REST API responds on port `8081`.
7. Confirm that Network OTBR joins the preferred Thread network.
8. Uninstall the official App if it is no longer needed.

Never run both Apps against the same network RCP simultaneously.

## Upstream image

This App wraps the standalone, multi-architecture OTBR image maintained by Dennis Witt:

https://github.com/wittdennis/homeassistant-otbr

The upstream project provides the OTBR container and environment-variable configuration. This repository provides the Home Assistant OS App packaging, native configuration interface, lifecycle management, and network-only RCP integration.

## Tested configuration

- Home Assistant OS 18.1
- Home Assistant Core 2026.7.4
- Home Assistant Supervisor 2026.07.3
- Raspberry Pi 4, `aarch64`
- SMLIGHT SLZB-MR1
- EFR32MG21 Thread RCP over TCP port `6638`
- OpenThread 1.4

## Troubleshooting

When reporting an issue, include:

- Home Assistant OS version
- Home Assistant Core version
- Supervisor version
- Network OTBR version
- Host architecture
- RCP model and firmware
- Network RCP address, with private details redacted if necessary
- Network OTBR startup logs

Check the REST API directly with:

```bash
curl http://HOME_ASSISTANT_IP:8081/node
```

A connected OTBR should report a role such as `child`, `router`, or `leader`, together with the expected Thread network name.

## License

MIT


## Project status and trademarks

Network OTBR is an independent community project.

The project is not affiliated with, endorsed by, sponsored by, or officially
supported by the Open Home Foundation, Home Assistant, Google, OpenThread,
Thread Group, SMLIGHT, or Dennis Witt.

Product names, project names, and logos remain trademarks of their respective
owners and are used only to identify compatibility and upstream components.

## Warranty and liability

This software is provided without warranty. Use of this App, including changes
to Thread networking, routing, firewall rules, and connected devices, is at the
user's own risk.

See LICENSE and
THIRD_PARTY_NOTICES.md.
