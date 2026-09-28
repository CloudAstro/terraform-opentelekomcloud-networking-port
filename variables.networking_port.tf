variable "admin_state_up" {
  type        = bool
  default     = null
  description = <<DESCRIPTION
* `admin_state_up` - (Optional) Administrative status of the port. Omit to use the provider default.

Example input:
```hcl
admin_state_up = true
```
DESCRIPTION
}

variable "device_id" {
  type        = string
  default     = null
  description = <<DESCRIPTION
* `device_id` - (Optional) ID of the device attached to the port. Changing it creates a new port. Leave unset for an unattached port.

Example input:
```hcl
device_id = "00000000-0000-0000-0000-000000000001"
```
DESCRIPTION
}

variable "device_owner" {
  type        = string
  default     = null
  description = <<DESCRIPTION
* `device_owner` - (Optional) Owner of the attached device, such as compute:nova. Changing it creates a new port. Leave unset unless assigning an existing device.

Example input:
```hcl
device_owner = "compute:nova"
```
DESCRIPTION
}

variable "name" {
  type        = string
  default     = null
  description = <<DESCRIPTION
* `name` - (Optional) Name of the networking port.

Example input:
```hcl
name = "port-application"
```
DESCRIPTION
}

variable "network_id" {
  type        = string
  nullable    = false
  description = <<DESCRIPTION
* `network_id` - (Required) Neutron network ID to attach the port to. Use vpc_subnet.network_id, not vpc_subnet.id or vpc_subnet.subnet_id. Changing it creates a new port.

Example input:
```hcl
network_id = module.subnet.vpc_subnet.network_id
```
DESCRIPTION

  validation {
    condition     = length(trimspace(var.network_id)) > 0
    error_message = "network_id must not be empty or contain only whitespace."
  }
}

variable "no_security_groups" {
  type        = bool
  default     = null
  description = <<DESCRIPTION
* `no_security_groups` - (Optional) Set true to remove all security groups. With false or null and no explicit group IDs, the networking service may attach its default group.

Example input:
```hcl
no_security_groups = true
```
DESCRIPTION

  validation {
    condition     = var.no_security_groups != true || (var.security_group_ids == null ? true : length(var.security_group_ids) == 0)
    error_message = "no_security_groups = true cannot be combined with non-empty security_group_ids."
  }
}

variable "port_security_enabled" {
  type        = bool
  default     = null
  description = <<DESCRIPTION
* `port_security_enabled` - (Optional) Enable or disable port security. Omit to use the provider default. Disable only without security groups; set no_security_groups = true to prevent default-group attachment.

Example input:
```hcl
port_security_enabled = true
```
DESCRIPTION

  validation {
    condition     = var.port_security_enabled != false || (var.security_group_ids == null ? true : length(var.security_group_ids) == 0)
    error_message = "Security groups must be removed before disabling port security."
  }
}

variable "security_group_ids" {
  type        = set(string)
  default     = null
  description = <<DESCRIPTION
* `security_group_ids` - (Optional) Security-group IDs to attach to the port. Mutually exclusive with no_security_groups = true.

Example input:
```hcl
security_group_ids = ["00000000-0000-0000-0000-000000000002"]
```
DESCRIPTION
}

variable "allowed_address_pairs" {
  type = set(object({
    ip_address  = string
    mac_address = optional(string)
  }))
  default     = null
  description = <<DESCRIPTION
* `allowed_address_pairs` - (Optional) Set of additional IP/MAC pairs permitted on the port, for example for virtual IPs.
  * `ip_address` - (Required) Additional IP address or supported CIDR.
  * `mac_address` - (Optional) MAC address associated with the additional IP.

Example input:
```hcl
allowed_address_pairs = [
  {
    ip_address  = "10.10.0.50"
    mac_address = "fa:16:3e:ab:cd:ef"
  }
]
```
DESCRIPTION
}

variable "extra_dhcp_option" {
  type = set(object({
    name  = string
    value = string
  }))
  default     = null
  description = <<DESCRIPTION
* `extra_dhcp_option` - (Optional) Set of DHCP options for this port. Requires DHCP support on the subnet.
  * `name` - (Required) Option name supported by the networking service.
  * `value` - (Required) Option value.

Example input:
```hcl
extra_dhcp_option = [
  {
    name  = "ntp-server"
    value = "10.10.0.10"
  }
]
```
DESCRIPTION
}

variable "fixed_ip" {
  type = object({
    ip_address = optional(string)
    subnet_id  = string
  })
  default     = null
  description = <<DESCRIPTION
* `fixed_ip` - (Optional) One fixed-IP allocation for this port.
  * `subnet_id` - (Required) Neutron subnet ID belonging to network_id. For an OTC VPC subnet, use vpc_subnet.subnet_id.
  * `ip_address` - (Optional) Desired address in that subnet. Omit to allocate an available address.

Example input:
```hcl
fixed_ip = {
  subnet_id  = module.subnet.vpc_subnet.subnet_id
  ip_address = "10.10.0.20"
}
```
DESCRIPTION
}

variable "timeouts" {
  type = object({
    create = optional(string)
    delete = optional(string)
  })
  default     = null
  description = <<DESCRIPTION
* `timeouts` - (Optional) Maximum wait times for port operations.
  * `create` - (Optional) Maximum time to create the port.
  * `delete` - (Optional) Maximum time to delete the port.

Example input:
```hcl
timeouts = {
  create = "10m"
  delete = "10m"
}
```
DESCRIPTION
}
