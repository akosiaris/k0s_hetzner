# k0s resource to create a cluster and store a kubeconfig file
resource "k0s_cluster" "k0s1" {
  depends_on = [hcloud_load_balancer.cp_load_balancer]
  name       = var.domain
  version    = var.k0s_version
  config = templatefile("templates/k0s.yaml", {
    controller_lb_address = var.controller_role == "single" ? "" : hcloud_load_balancer.cp_load_balancer[0].ipv4,
    controller_ip_addresses = concat(
      hcloud_primary_ip.controller_ipv4.*.ip_address,
      hcloud_primary_ip.controller_ipv6.*.ip_address,
    )
  })
  hosts = concat(
    [
      for address in hcloud_server.controller.*.ipv4_address :
      {
        role        = var.controller_role
        no_taints   = var.controller_role == "controller+worker" ? true : false
        environment = { "ROLE" = var.controller_role }
        install_flags = [
          "--enable-metrics-scraper",
        ]
        ssh = {
          address  = address
          port     = 22
          user     = "root"
          key_path = var.ssh_priv_key_path
        }
      }
    ],
    [
      for address in hcloud_server.worker.*.ipv4_address :
      {
        role        = "worker"
        environment = { "ROLE" = "worker" }
        install_flags = var.hccm_enable ? [
          "--enable-cloud-provider",
          "--kubelet-extra-args=\"--cloud-provider=external\""
        ] : []
        ssh = {
          address  = address
          port     = 22
          user     = "root"
          key_path = var.ssh_priv_key_path
        }
      }
    ]
  )
}

resource "local_file" "kubeconfig" {
  filename        = "kubeconfig-${var.domain}"
  file_permission = "0600"
  content         = nonsensitive(k0s_cluster.k0s1.kubeconfig)
}
