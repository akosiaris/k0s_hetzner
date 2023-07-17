locals {
  controller_ips = flatten([
    for _, addresses in var.controller_addresses :
    compact(values(addresses))
  ])
}
# k0s resource to create a cluster and store a kubeconfig file
resource "k0s_cluster" "k0s" {
  name    = var.domain
  version = var.k0s_version
  config = templatefile("modules/k0s/templates/k0s.tftpl", {
    controller_lb_address   = length(var.cp_balancer_ips) > 0 ? var.cp_balancer_ips[0] : "",
    controller_ip_addresses = local.controller_ips,
  })
  hosts = concat(
    [
      for host, addresses in var.controller_addresses :
      {
        role        = var.controller_role
        no_taints   = var.controller_role == "controller+worker" ? true : false
        environment = { "ROLE" = var.controller_role }
        install_flags = [
          "--enable-metrics-scraper",
        ]
        ssh = {
          # If we don't have public IPv4 connectivity, use IPv6 for the provisioner
          address  = addresses["public_ipv4"] != "" ? addresses["public_ipv4"] : addresses["public_ipv6"]
          port     = 22
          user     = "root"
          key_path = var.ssh_priv_key_path
        }
        # If a private network has been allocated, use it
        private_address = addresses["private_ipv4"] != null ? addresses["private_ipv4"] : ""
        # If we don't have public IPv4 connectivity, we need to upload binaries ourselves over IPv6
        uploadBinary = addresses["public_ipv4"] == "" ? true : false
      }
    ],
    [
      for host, addresses in var.worker_addresses :
      {
        role        = "worker"
        environment = { "ROLE" = "worker" }
        install_flags = var.hccm_enable ? [
          "--enable-cloud-provider",
          "--kubelet-extra-args=\"--cloud-provider=external\""
        ] : []
        ssh = {
          # If we don't have public IPv4 connectivity, use IPv6 for the provisioner
          address  = addresses["public_ipv4"] != "" ? addresses["public_ipv4"] : addresses["public_ipv6"]
          port     = 22
          user     = "root"
          key_path = var.ssh_priv_key_path
        }
        # If a private network has been allocated, use it
        private_address = addresses["private_ipv4"] != null ? addresses["private_ipv4"] : ""
        # If we don't have public IPv4 connectivity, we need to upload binaries ourselves over IPv6
        uploadBinary = addresses["public_ipv4"] == "" ? true : false
      }
    ]
  )
}

resource "local_file" "kubeconfig" {
  filename        = "kubeconfig-${var.domain}"
  file_permission = "0600"
  content         = nonsensitive(k0s_cluster.k0s.kubeconfig)
}
