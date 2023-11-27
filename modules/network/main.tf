locals {
  ipv6_count             = var.enable_ipv6 ? var.amount : 0
  ipv4_count             = var.enable_ipv4 ? var.amount : 0
  role                   = replace(var.role, "+", "-")
  balancer_count         = (local.role == "single" || !var.enable_balancer) ? 0 : 1
  balanced_port_count    = local.balancer_count == 0 ? 0 : length(var.balanced_services)
  balancer_privnet_count = (var.enable_network && local.balancer_count > 0) ? 1 : 0
  balancer_extra_count   = (local.role == "single" || !var.enable_balancer) ? 0 : length(var.balanced_extraIPs)
  basename               = var.hostname != null ? var.hostname : local.role
}

# Create Primary IPs for servers. We need this to happen in a different step
# from creating the servers in order to populate firewall rules
resource "hcloud_primary_ip" "ipv4" {
  count         = local.ipv4_count
  name          = format("ipv4-%s-%s.%s", local.basename, count.index, var.domain)
  type          = "ipv4"
  datacenter    = var.datacenter
  assignee_type = "server"
  auto_delete   = false # Per comment in provider documentation
  labels = {
    "role" : local.role
  }
}

resource "hcloud_primary_ip" "ipv6" {
  count         = local.ipv6_count
  name          = format("ipv6-%s-%s.%s", local.basename, count.index, var.domain)
  type          = "ipv6"
  datacenter    = var.datacenter
  assignee_type = "server"
  auto_delete   = false # Per comment in provider documentation
  labels = {
    "role" : local.role
  }
}

# DNS Reverse RRs
resource "hcloud_rdns" "ipv4" {
  count         = local.ipv4_count
  primary_ip_id = hcloud_primary_ip.ipv4[count.index].id
  ip_address    = hcloud_primary_ip.ipv4[count.index].ip_address
  dns_ptr       = local.role == "single" ? format("%s.%s", local.basename, var.domain) : format("%s-%s.%s", local.basename, count.index, var.domain)
}

resource "hcloud_rdns" "ipv6" {
  count         = local.ipv6_count
  primary_ip_id = hcloud_primary_ip.ipv6[count.index].id
  ip_address    = hcloud_primary_ip.ipv6[count.index].ip_address
  dns_ptr       = local.role == "single" ? format("%s.%s", local.basename, var.domain) : format("%s-%s.%s", local.basename, count.index, var.domain)
}

# Balancer section
resource "hcloud_load_balancer" "lb" {
  count              = local.balancer_count
  name               = "lb"
  load_balancer_type = var.balancer_type
  network_zone       = var.network_zone
  algorithm {
    type = "round_robin"
  }
  labels = {
    "role" : local.role
  }
}

resource "hcloud_load_balancer_service" "service" {
  count            = local.balanced_port_count
  load_balancer_id = one(hcloud_load_balancer.lb.*.id)
  protocol         = var.balanced_protocol
  listen_port      = var.balanced_services[count.index]
  destination_port = var.balanced_services[count.index]
}

resource "hcloud_load_balancer_target" "target" {
  count            = local.balancer_count
  type             = "label_selector"
  load_balancer_id = one(hcloud_load_balancer.lb.*.id)
  label_selector   = "role=${local.role}"
}

resource "hcloud_load_balancer_target" "extra" {
  count            = local.balancer_extra_count
  type             = "ip"
  load_balancer_id = one(hcloud_load_balancer.lb.*.id)
  ip               = var.balanced_extraIPs[count.index]
}

# Balancer reverse DNS
resource "hcloud_rdns" "lb_ipv4" {
  count            = local.balancer_count
  load_balancer_id = one(hcloud_load_balancer.lb.*.id)
  ip_address       = one(hcloud_load_balancer.lb.*.ipv4)
  dns_ptr          = format("%s-%s.%s", "lb", local.role, var.domain)
}

resource "hcloud_rdns" "lb_ipv6" {
  count            = local.balancer_count
  load_balancer_id = one(hcloud_load_balancer.lb.*.id)
  ip_address       = one(hcloud_load_balancer.lb.*.ipv6)
  dns_ptr          = format("%s-%s.%s", "lb", local.role, var.domain)
}

# Hetzner private network
resource "hcloud_network" "privnet" {
  count    = var.enable_network ? 1 : 0
  name     = "${local.role}-privnet"
  ip_range = var.network_ip_range
  labels = {
    "role" : local.role
  }
}

resource "hcloud_network_subnet" "privnet_subnet" {
  count        = var.enable_network ? 1 : 0
  network_id   = one(hcloud_network.privnet.*.id)
  type         = "cloud"
  network_zone = var.network_zone
  ip_range     = var.network_subnet_ip_range
}

resource "hcloud_load_balancer_network" "lb_privnet" {
  count                   = local.balancer_privnet_count
  load_balancer_id        = one(hcloud_load_balancer.lb.*.id)
  subnet_id               = one(hcloud_network_subnet.privnet_subnet.*.id)
  enable_public_interface = true # We definitely want the lb exposed to the public.
}
