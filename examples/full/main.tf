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
