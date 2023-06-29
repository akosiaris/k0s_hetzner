# Spread out for great chance a Hetzner outage doesn't impact us
resource "hcloud_placement_group" "worker-pg" {
  count = var.controller_role == "single" ? 0 : (
  var.worker_count > 0 ? 1 : 0)
  name = "worker-pg"
  type = "spread"
  labels = {
    "role" : "worker"
  }
}

# Create Primary IPs for servers. We need this to happen in a different step
# from creating the servers in order to populate ferm
resource "hcloud_primary_ip" "worker_ipv4" {
  count         = var.controller_role == "single" ? 0 : var.worker_count
  name          = "worker_ipv4_worker${count.index}"
  type          = "ipv4"
  datacenter    = var.worker_server_datacenter
  assignee_type = "server"
  auto_delete   = false # Per comment in provider documentation
  labels = {
    "role" : "worker"
  }
}

resource "hcloud_primary_ip" "worker_ipv6" {
  count         = var.controller_role == "single" ? 0 : var.worker_count
  name          = "worker_ipv6_worker${count.index}"
  type          = "ipv6"
  datacenter    = var.worker_server_datacenter
  assignee_type = "server"
  auto_delete   = false # Per comment in provider documentation
  labels = {
    "role" : "worker"
  }
}

# Create workers and link them to the above IPs
resource "hcloud_server" "worker" {
  count              = var.controller_role == "single" ? 0 : var.worker_count
  name               = "worker${count.index}"
  server_type        = var.worker_server_type
  placement_group_id = hcloud_placement_group.worker-pg[0].id
  image              = var.worker_server_image
  location           = var.worker_server_location
  user_data = templatefile(
    "user-data.tftpl",
    { fqdn = format("%s%s.%s", "worker", count.index, var.domain),
      ip_addresses = join(" ", sort(
        concat(
          hcloud_primary_ip.controller_ipv4.*.ip_address,
          hcloud_primary_ip.controller_ipv6.*.ip_address,
          hcloud_primary_ip.worker_ipv4.*.ip_address,
          hcloud_primary_ip.worker_ipv6.*.ip_address,
      ))),
      controller_lb_addresses = "",
    }
  )
  ssh_keys = [
    hcloud_ssh_key.default.id
  ]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
    ipv4         = hcloud_primary_ip.worker_ipv4[count.index].id
    ipv6         = hcloud_primary_ip.worker_ipv6[count.index].id
  }
  labels = {
    "role" : "worker"
  }
}

# DNS Reverse RRs
resource "hcloud_rdns" "worker_ipv4" {
  count         = var.controller_role == "single" ? 0 : var.worker_count
  primary_ip_id = hcloud_primary_ip.worker_ipv4[count.index].id
  ip_address    = hcloud_primary_ip.worker_ipv4[count.index].ip_address
  dns_ptr       = format("%s.%s", hcloud_server.worker[count.index].name, var.domain)
}

resource "hcloud_rdns" "worker_ipv6" {
  count         = var.controller_role == "single" ? 0 : var.worker_count
  primary_ip_id = hcloud_primary_ip.worker_ipv6[count.index].id
  ip_address    = hcloud_primary_ip.worker_ipv6[count.index].ip_address
  dns_ptr       = format("%s.%s", hcloud_server.worker[count.index].name, var.domain)
}
