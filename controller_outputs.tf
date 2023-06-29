output "controller_ip4_addr" {
  value = hcloud_server.controller.*.ipv4_address
}

output "controller_ip6_addr" {
  value = hcloud_server.controller.*.ipv6_address
}

output "controller_load_balancer_ip4_addr" {
  value = hcloud_load_balancer.cp_load_balancer.*.ipv4
}

output "controller_load_balancer_ip6_addr" {
  value = hcloud_load_balancer.cp_load_balancer.*.ipv6
}