locals {
  enable_ipv6   = length(var.ip_address_ids["ipv6"]) > 0 ? true : false
  enable_ipv4   = length(var.ip_address_ids["ipv4"]) > 0 ? true : false
  role          = replace(var.role, "+", "-")
  network_count = var.enable_network ? var.amount : 0
}

# Spread out for great chance a Hetzner outage doesn't impact us
resource "hcloud_placement_group" "pg" {
  name = "${local.role}-pg"
  type = "spread"
  labels = {
    "role" : local.role,
  }
}

# Create servers and link them to the above IPs
resource "hcloud_server" "server" {
  count              = var.amount
  name               = var.hostname != null ? var.hostname : "${local.role}-${count.index}"
  server_type        = var.type
  placement_group_id = hcloud_placement_group.pg.id
  image              = var.image
  datacenter         = var.datacenter
  user_data = templatefile(
    "modules/server/templates/user-data.tftpl",
    {
      fqdn = format("%s.%s",
        var.hostname != null ? var.hostname : "${local.role}-${count.index}",
        var.domain,
      )
    }
  )
  ssh_keys = [
    var.ssh_pub_key_id
  ]
  public_net {
    ipv4_enabled = local.enable_ipv4
    ipv6_enabled = local.enable_ipv6
    ipv4         = local.enable_ipv4 ? var.ip_address_ids["ipv4"][count.index] : null
    ipv6         = local.enable_ipv6 ? var.ip_address_ids["ipv6"][count.index] : null
  }
  labels = {
    "role" : local.role,
  }

  # TODO: Add support for doing this over private networks
  connection {
    type        = "ssh"
    user        = "root"
    host        = local.enable_ipv4 ? self.ipv4_address : (local.enable_ipv6 ? self.ipv6_address : null)
    private_key = file(var.ssh_priv_key_path)
  }

  provisioner "remote-exec" {
    inline = ["cloud-init status --wait"]
  }
}

resource "hcloud_server_network" "privnet" {
  count     = local.network_count
  server_id = hcloud_server.server[count.index].id
  subnet_id = var.network_subnet_id
}
