# Note: don't go overboard adding helm charts in this file. It is meant just
# for infrastructural stuff, not generic applications
resource "helm_release" "hccm" {
  # Versioning policy at https://github.com/hetznercloud/hcloud-cloud-controller-manager#versioning-policy
  count = var.hccm_enable ? 1 : 0
  depends_on = [
    k0s_cluster.k0s,
    local_file.kubeconfig,
    helm_release.terraform-hcloud-k0s-configs,
  ]
  name       = "hccm"
  repository = "https://charts.hetzner.cloud"
  chart      = "hcloud-cloud-controller-manager"
  namespace  = "kube-system"
  # Versioning policy at https://github.com/hetznercloud/hcloud-cloud-controller-manager#versioning-policy
  version = "1.16.0"
}

resource "helm_release" "hcloud-csi-driver" {
  # Versioning policy at https://github.com/hetznercloud/csi-driver/blob/main/docs/kubernetes/README.md#versioning-policy
  count = var.hcsi_enable ? 1 : 0
  depends_on = [
    k0s_cluster.k0s,
    local_file.kubeconfig,
    helm_release.hccm,
    helm_release.terraform-hcloud-k0s-configs,
  ]
  name      = "hcloud-csi-driver"
  chart     = "./hcloud-csi-driver-helm-chart"
  namespace = "kube-system"
  set {
    name  = "EncryptedStorageClass.encryptionpassphrase"
    value = var.hcsi_encryption_key
  }
  set {
    name  = "storageClass.reclaimPolicy"
    value = "Retain"
  }
  set {
    name  = "EncryptedStorageClass.reclaimPolicy"
    value = "Retain"
  }
}

locals {
  controller_hpes = (var.controller_role == "controller+worker" || var.controller_role == "single") ? var.controller_addresses : {}
  hpes = {
    for hpe, v in merge(local.controller_hpes, var.worker_addresses) :
    hpe => {
      expectedIPs = compact([
        v["public_ipv4"],
        v["public_ipv6"],
        v["private_ipv4"],
      ])
    }
  }
  configs_workers = {
    HostEndpoints = {
      workers = local.hpes
    }
  }
  gnp = {
    GlobalNetworkPolicies = var.firewall_rules
  }
  hcloud_token = (var.hccm_enable || var.hcsi_enable) ? var.hcloud_token : null
}

resource "helm_release" "terraform-hcloud-k0s-configs" {
  depends_on = [
    k0s_cluster.k0s,
    local_file.kubeconfig,
  ]
  name      = "terraform-hcloud-k0s-configs"
  chart     = "./configs-helm-chart"
  namespace = "kube-system"
  values = [
    yamlencode(local.configs_workers),
    yamlencode(local.gnp),
  ]
  set {
    name  = "hcloud_token"
    value = local.hcloud_token
  }
}

resource "helm_release" "kube-stack-prometheus" {
  count = var.prometheus_enable ? 1 : 0
  depends_on = [
    k0s_cluster.k0s,
    local_file.kubeconfig,
  ]
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "kube-system"
  version    = "47.0.0"
}
