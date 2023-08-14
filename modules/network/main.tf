locals {
  ipv6_count             = var.enable_ipv6 ? var.amount : 0
  ipv4_count             = var.enable_ipv4 ? var.amount : 0
  role                   = replace(var.role, "+", "-")
  balancer_count         = (local.role == "single" || !var.enable_balancer) ? 0 : 1
  balanced_port_count    = local.balancer_count == 0 ? 0 : length(var.balanced_services)
  balancer_privnet_count = (var.enable_network && local.balancer_count > 0) ? 1 : 0
}

# Create Primary IPs for servers. We need this to happen in a different step
# from creating the servers in order to populate firewall rules
resource "hcloud_primary_ip" "ipv4" {
  count         = local.ipv4_count
  name          = var.hostname != null ? var.hostname : "ipv4-${local.role}-${count.index}"
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
  name          = var.hostname != null ? var.hostname : "ipv6-${local.role}-${count.index}"
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
  dns_ptr       = format("%s.%s", hcloud_primary_ip.ipv4[count.index].name, var.domain)
}

resource "hcloud_rdns" "ipv6" {
  count         = local.ipv6_count
  primary_ip_id = hcloud_primary_ip.ipv6[count.index].id
  ip_address    = hcloud_primary_ip.ipv6[count.index].ip_address
  dns_ptr       = format("%s.%s", hcloud_primary_ip.ipv6[count.index].name, var.domain)
}

# Balancer section
resource "hcloud_load_balancer" "lb" {
  count              = local.balancer_count
  name               = "lb"
  load_balancer_type = var.balancer_type
  # TODO: fix location
  location = "fsn1"
  algorithm {
    type = "round_robin"
  }
  labels = {
    "role" : local.role
  }
}

resource "hcloud_load_balancer_service" "service" {
  count            = local.balanced_port_count
  load_balancer_id = hcloud_load_balancer.lb[0].id
  protocol         = var.balanced_protocol
  listen_port      = var.balanced_services[count.index]
  destination_port = var.balanced_services[count.index]
}

resource "hcloud_load_balancer_target" "target" {
  count            = local.balancer_count
  type             = "label_selector"
  load_balancer_id = hcloud_load_balancer.lb[0].id
  label_selector   = "role=${local.role}"
}

# Balancer reverse DNS
resource "hcloud_rdns" "lb_ipv4" {
  count            = local.balancer_count
  load_balancer_id = hcloud_load_balancer.lb[0].id
  ip_address       = hcloud_load_balancer.lb[0].ipv4
  dns_ptr          = format("%s-%s.%s", "lb", local.role, var.domain)
}

resource "hcloud_rdns" "lb_ipv6" {
  count            = local.balancer_count
  load_balancer_id = hcloud_load_balancer.lb[0].id
  ip_address       = hcloud_load_balancer.lb[0].ipv6
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
  network_id   = hcloud_network.privnet[0].id
  type         = "cloud"
  network_zone = var.network_zone
  ip_range     = var.network_subnet_ip_range
}

resource "hcloud_load_balancer_network" "lb_privnet" {
  count                   = local.balancer_privnet_count
  load_balancer_id        = hcloud_load_balancer.lb[0].id
  subnet_id               = hcloud_network_subnet.privnet_subnet[0].id
  enable_public_interface = true # We definitely want the lb exposed to the public.
}
