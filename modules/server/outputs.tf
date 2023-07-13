output "addresses" {
  value = {
    ipv4    = hcloud_server.server.*.ipv4_address,
    ipv6    = hcloud_server.server.*.ipv6_address,
    private = hcloud_server_network.privnet.*.ip,
  }
}
