resource "opentelekomcloud_networking_network_v2" "network" {
  name = "network-example"
}

module "port" {
  source     = "../.."
  network_id = opentelekomcloud_networking_network_v2.network.id
}
