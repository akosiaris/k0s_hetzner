output "addresses" {
  value = {
    ipv4 = hcloud_primary_ip.ipv4.*.ip_address,
    ipv6 = hcloud_primary_ip.ipv6.*.ip_address,
    # The CIDR format is useful in hcloud_firewall resources
    ipv4cidr = [for a in hcloud_primary_ip.ipv4 : "${a.ip_address}/32"],
    ipv6cidr = [for a in hcloud_primary_ip.ipv6 : "${a.ip_address}/64"],
  }
}

output "address_ids" {
  value = {
    ipv4 = hcloud_primary_ip.ipv4.*.id,
    ipv6 = hcloud_primary_ip.ipv6.*.id,
  }
}

output "lb_addresses" {
  value = {
    ipv4    = hcloud_load_balancer.lb.*.ipv4,
    ipv6    = hcloud_load_balancer.lb.*.ipv6,
    private = hcloud_load_balancer_network.lb_privnet.*.ip,
    # The CIDR format is useful in hcloud_firewall resources
    ipv4cidr = [for a in hcloud_load_balancer.lb.*.ipv4 : "${a}/32"],
    ipv6cidr = [for a in hcloud_load_balancer.lb.*.ipv6 : "${a}/128"],
  }
}

output "subnet_id" {
  value = length(hcloud_network_subnet.privnet_subnet) > 0 ? one(hcloud_network_subnet.privnet_subnet).id : null
}
