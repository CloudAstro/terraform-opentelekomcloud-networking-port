<!-- BEGINNING OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
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

```hcl
module "vpc" {
  source  = "CloudAstro/vpc/opentelekomcloud"
  version = "1.1.1"

  name = "vpc-example"
  cidr = "10.10.0.0/24"
}

module "subnet" {
  source  = "CloudAstro/vpc-subnet/opentelekomcloud"
  version = "1.1.1"

  name        = "snet-example"
  cidr        = "10.10.0.0/26"
  gateway_ip  = "10.10.0.1"
  vpc_id      = module.vpc.vpc_v1.id
  dhcp_enable = true
}

resource "opentelekomcloud_networking_secgroup_v2" "sg" {
  name        = "sg-example"
  description = "Security group for the example port"
}

module "port" {
  source = "../.."

  name                  = "port-example"
  network_id            = module.subnet.vpc_subnet.network_id
  admin_state_up        = true
  port_security_enabled = true
  no_security_groups    = false
  security_group_ids    = [opentelekomcloud_networking_secgroup_v2.sg.id]

  allowed_address_pairs = [
    {
      ip_address = "10.10.0.50"
    },
    {
      ip_address  = "10.10.0.51"
      mac_address = "fa:16:3e:ab:cd:ef"
    }
  ]

  extra_dhcp_option = [
    {
      name  = "ntp-server"
      value = "10.10.0.10"
    },
    {
      name  = "domain-name"
      value = "example.internal"
    }
  ]

  fixed_ip = {
    ip_address = "10.10.0.20"
    subnet_id  = module.subnet.vpc_subnet.subnet_id
  }

  timeouts = {
    create = "10m"
    delete = "10m"
  }
}
```
<!-- markdownlint-disable MD033 -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.12 |
| <a name="requirement_opentelekomcloud"></a> [opentelekomcloud](#requirement\_opentelekomcloud) | >= 1.36.35 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_opentelekomcloud"></a> [opentelekomcloud](#provider\_opentelekomcloud) | >= 1.36.35 |

## Resources

| Name | Type |
|------|------|
| [opentelekomcloud_networking_port_v2.this](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/networking_port_v2) | resource |

<!-- markdownlint-disable MD013 -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | * `network_id` - (Required) Neutron network ID to attach the port to. Use vpc\_subnet.network\_id, not vpc\_subnet.id or vpc\_subnet.subnet\_id. Changing it creates a new port.<br/><br/>Example input:<pre>hcl<br/>network_id = module.subnet.vpc_subnet.network_id</pre> | `string` | n/a | yes |
| <a name="input_admin_state_up"></a> [admin\_state\_up](#input\_admin\_state\_up) | * `admin_state_up` - (Optional) Administrative status of the port. Omit to use the provider default.<br/><br/>Example input:<pre>hcl<br/>admin_state_up = true</pre> | `bool` | `null` | no |
| <a name="input_allowed_address_pairs"></a> [allowed\_address\_pairs](#input\_allowed\_address\_pairs) | * `allowed_address_pairs` - (Optional) Set of additional IP/MAC pairs permitted on the port, for example for virtual IPs.<br/>  * `ip_address` - (Required) Additional IP address or supported CIDR.<br/>  * `mac_address` - (Optional) MAC address associated with the additional IP.<br/><br/>Example input:<pre>hcl<br/>allowed_address_pairs = [<br/>  {<br/>    ip_address  = "10.10.0.50"<br/>    mac_address = "fa:16:3e:ab:cd:ef"<br/>  }<br/>]</pre> | <pre>set(object({<br/>    ip_address  = string<br/>    mac_address = optional(string)<br/>  }))</pre> | `null` | no |
| <a name="input_device_id"></a> [device\_id](#input\_device\_id) | * `device_id` - (Optional) ID of the device attached to the port. Changing it creates a new port. Leave unset for an unattached port.<br/><br/>Example input:<pre>hcl<br/>device_id = "00000000-0000-0000-0000-000000000001"</pre> | `string` | `null` | no |
| <a name="input_device_owner"></a> [device\_owner](#input\_device\_owner) | * `device_owner` - (Optional) Owner of the attached device, such as compute:nova. Changing it creates a new port. Leave unset unless assigning an existing device.<br/><br/>Example input:<pre>hcl<br/>device_owner = "compute:nova"</pre> | `string` | `null` | no |
| <a name="input_extra_dhcp_option"></a> [extra\_dhcp\_option](#input\_extra\_dhcp\_option) | * `extra_dhcp_option` - (Optional) Set of DHCP options for this port. Requires DHCP support on the subnet.<br/>  * `name` - (Required) Option name supported by the networking service.<br/>  * `value` - (Required) Option value.<br/><br/>Example input:<pre>hcl<br/>extra_dhcp_option = [<br/>  {<br/>    name  = "ntp-server"<br/>    value = "10.10.0.10"<br/>  }<br/>]</pre> | <pre>set(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `null` | no |
| <a name="input_fixed_ip"></a> [fixed\_ip](#input\_fixed\_ip) | * `fixed_ip` - (Optional) One fixed-IP allocation for this port.<br/>  * `subnet_id` - (Required) Neutron subnet ID belonging to network\_id. For an OTC VPC subnet, use vpc\_subnet.subnet\_id.<br/>  * `ip_address` - (Optional) Desired address in that subnet. Omit to allocate an available address.<br/><br/>Example input:<pre>hcl<br/>fixed_ip = {<br/>  subnet_id  = module.subnet.vpc_subnet.subnet_id<br/>  ip_address = "10.10.0.20"<br/>}</pre> | <pre>object({<br/>    ip_address = optional(string)<br/>    subnet_id  = string<br/>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | * `name` - (Optional) Name of the networking port.<br/><br/>Example input:<pre>hcl<br/>name = "port-application"</pre> | `string` | `null` | no |
| <a name="input_no_security_groups"></a> [no\_security\_groups](#input\_no\_security\_groups) | * `no_security_groups` - (Optional) Set true to remove all security groups. With false or null and no explicit group IDs, the networking service may attach its default group.<br/><br/>Example input:<pre>hcl<br/>no_security_groups = true</pre> | `bool` | `null` | no |
| <a name="input_port_security_enabled"></a> [port\_security\_enabled](#input\_port\_security\_enabled) | * `port_security_enabled` - (Optional) Enable or disable port security. Omit to use the provider default. Disable only without security groups; set no\_security\_groups = true to prevent default-group attachment.<br/><br/>Example input:<pre>hcl<br/>port_security_enabled = true</pre> | `bool` | `null` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | * `security_group_ids` - (Optional) Security-group IDs to attach to the port. Mutually exclusive with no\_security\_groups = true.<br/><br/>Example input:<pre>hcl<br/>security_group_ids = ["00000000-0000-0000-0000-000000000002"]</pre> | `set(string)` | `null` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | * `timeouts` - (Optional) Maximum wait times for port operations.<br/>  * `create` - (Optional) Maximum time to create the port.<br/>  * `delete` - (Optional) Maximum time to delete the port.<br/><br/>Example input:<pre>hcl<br/>timeouts = {<br/>  create = "10m"<br/>  delete = "10m"<br/>}</pre> | <pre>object({<br/>    create = optional(string)<br/>    delete = optional(string)<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_networking_port"></a> [networking\_port](#output\_networking\_port) | The networking-port resource, including its ID, MAC address, security groups and allocated IP addresses.<br/><br/>Example output:<pre>hcl<br/>output "port_id" {<br/>  value = module.port.networking_port.id<br/>}<br/><br/>output "port_addresses" {<br/>  value = module.port.networking_port.all_fixed_ips<br/>}</pre> |

## Modules

No modules.

## 🌐 Additional Information

Use `module.port.networking_port.id` when attaching the port to an instance.
The output also exposes `mac_address`, `all_fixed_ips` and the other provider
attributes. Device binding inputs are optional; leave them unset when a compute
resource will attach the port separately.

The full example pins published versions of the CloudAstro VPC and subnet modules.
Its NTP address and additional address pairs are illustrative; the example does
not deploy an NTP server, configure guest networking or implement HA failover.

## 📚 Resources

- [Terraform Networking Port Resource](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/networking_port_v2)
- [Terraform VPC Subnet Resource](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/vpc_subnet_v1)
- [Terraform OpenTelekomCloud Provider](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs)
- [Contributing](CONTRIBUTING.md)

## ⚠️ Notes

- `network_id` is the Neutron network identifier. For the CloudAstro VPC subnet module, use `module.subnet.vpc_subnet.network_id`; use `.subnet_id` only inside `fixed_ip`. The VPC subnet resource's `.id` is a different identifier.
- The module supports one `fixed_ip` object. Omit its `ip_address` for automatic allocation within the selected subnet.
- When `no_security_groups = true`, omit `security_group_ids` or pass an empty set. Otherwise, the networking service may attach its default group if no IDs are supplied.
- To disable port security, remove security groups and set `no_security_groups = true`. Additional IP/MAC pairs, routes and guest configuration must meet OTC networking requirements.
- The unused top-level `mac_address` and `tenant_id` inputs have been removed. The current provider computes the port MAC and does not accept a tenant override on this resource. Remove these arguments from existing module calls and select the project through the OTC provider configuration (or a provider alias). The assigned MAC remains available through `networking_port.mac_address`.
- `allowed_address_pairs.mac_address` is still supported; it is distinct from the port’s own computed MAC address.
- The resource address `opentelekomcloud_networking_port_v2.this` and the `networking_port` output are unchanged. No migration blocks are added.
- Detach a port from its device before deleting it where required by the networking service.
- Generate this README with `terraform-docs .`; edit `_header.md`, `_footer.md` and Terraform descriptions. GitHub workflows assume this directory is the root of a standalone repository.
- No public registry release has been created by this preparation. The intended module address is `CloudAstro/networking-port/opentelekomcloud` once published.

## 🧾 License

This module is released under the **Apache 2.0 License**, as declared in its existing
documentation. See [LICENSE](LICENSE) for the full text.
<!-- END OF PRE-COMMIT-OPENTOFU DOCS HOOK -->