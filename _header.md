# OpenTelekomCloud Networking Port Terraform Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE)

This module manages an OpenTelekomCloud Neutron port using
`opentelekomcloud_networking_port_v2`. It supports fixed IP allocation, security
groups, port security, allowed address pairs, DHCP options and operation timeouts.

# Features

- **Port Management**: Creates a port on an existing network with optional name and administrative status.
- **Address Allocation**: Supports automatic allocation or one fixed IP, with the MAC address assigned by the networking service.
- **Security Groups**: Attaches security groups or explicitly disables them.
- **Address Pairs and DHCP**: Configures additional permitted addresses and per-port DHCP options.
- **Device Settings**: Supports optional device binding fields. Project selection comes from the caller’s provider configuration.
- **Timeout Control**: Supports create and delete timeouts.

# Setup Requirements

Supply OTC credentials through the provider's supported environment variables, such
as `OS_USERNAME`, `OS_PASSWORD`, `OS_DOMAIN_NAME`, `OS_PROJECT_NAME` and `OS_REGION`.
The examples use the eu-de authentication endpoint; adjust `provider.tf` for your
region. Do not commit credentials.

# Example Usage

The [default example](examples/default/main.tf) creates a network and a port using
provider defaults. The [full example](examples/full/main.tf) uses the public
CloudAstro VPC and subnet modules and configures a port with fixed addressing,
security groups, additional address pairs and DHCP options:
