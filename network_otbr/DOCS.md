# Network OTBR

Network OTBR runs OpenThread Border Router with a network-connected Radio
Co-Processor and does not require a local USB serial device.

## Default configuration

- Network RCP: `10.40.10.11:6638`
- Backbone interface: `end0`
- Baud rate: `460800`
- Hardware flow control: disabled
- OTBR firewall: enabled
- NAT64: disabled
- Beta features: disabled
- REST API: `http://homeassistant.local:8081`
- Web interface: `http://homeassistant.local:8080`

## Before starting

Stop the official OpenThread Border Router App. Only one OTBR instance should
connect to the network RCP.

## Home Assistant integration

Automatic discovery is disabled by the standalone base image. Add the
OpenThread Border Router integration manually and use:

`http://10.40.10.10:8081`
