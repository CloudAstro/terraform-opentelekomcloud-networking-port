output "networking_port" {
  value       = opentelekomcloud_networking_port_v2.this
  description = <<DESCRIPTION
The networking-port resource, including its ID, MAC address, security groups and allocated IP addresses.

Example output:
```hcl
output "port_id" {
  value = module.port.networking_port.id
}

output "port_addresses" {
  value = module.port.networking_port.all_fixed_ips
}
```
DESCRIPTION
}
