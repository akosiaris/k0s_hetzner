output "controller_ip4_addr" {
  value = hcloud_server.controller.*.ipv4_address
}

output "controller_ip6_addr" {
  value = hcloud_server.controller.*.ipv6_address
}

output "kubeconfig" {
  value = nonsensitive(k0s_cluster.k0s1.kubeconfig)
}
