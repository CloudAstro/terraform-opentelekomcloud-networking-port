resource "opentelekomcloud_networking_port_v2" "this" {
  name                  = var.name
  network_id            = var.network_id
  admin_state_up        = var.admin_state_up
  device_owner          = var.device_owner
  security_group_ids    = var.security_group_ids
  no_security_groups    = var.no_security_groups
  port_security_enabled = var.port_security_enabled
  device_id             = var.device_id

  dynamic "allowed_address_pairs" {
    for_each = var.allowed_address_pairs != null ? var.allowed_address_pairs : []
    content {
      ip_address  = allowed_address_pairs.value.ip_address
      mac_address = allowed_address_pairs.value.mac_address
    }
  }

  dynamic "extra_dhcp_option" {
    for_each = var.extra_dhcp_option != null ? var.extra_dhcp_option : []
    content {
      name  = extra_dhcp_option.value.name
      value = extra_dhcp_option.value.value
    }
  }

  dynamic "fixed_ip" {
    for_each = var.fixed_ip != null ? [var.fixed_ip] : []
    content {
      ip_address = fixed_ip.value.ip_address
      subnet_id  = fixed_ip.value.subnet_id
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
    }
  }
}
