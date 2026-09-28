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
