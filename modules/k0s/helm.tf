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
  version = "1.26.0"
}

locals {
  hcsiconfig = {
    node = {
      kubeletDir = "/var/lib/k0s/kubelet"
    }
    storageClasses = [
      {
        name          = "hcloud-volumes"
        reclaimPolicy = "Delete"
        reclaimPolicy = var.hcsi_reclaim_policy
      },
      {
        name          = "hcloud-volumes-encrypted"
        reclaimPolicy = var.hcsi_encrypted_reclaim_policy
        extraParameters = {
          "csi.storage.k8s.io/node-publish-secret-name"      = "encryption-secret"
          "csi.storage.k8s.io/node-publish-secret-namespace" = "kube-system"
        }
      },
    ]
  }
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
  name       = "hcloud-csi-driver"
  repository = "https://charts.hetzner.cloud"
  chart      = "hcloud-csi"
  namespace  = "kube-system"
  version    = "v2.13.0"
  values = [
    yamlencode(local.hcsiconfig),
  ]
}

locals {
  lsp = {
    classes = [
      {
        name    = "local-storage"
        hostDir = "/mnt/local-storage"
        storageClass = {
          reclaimPolicy  = var.lsp_reclaim_policy,
          isDefaultClass = var.lsp_isDefault,
        }
      },
    ]
  }
}

resource "helm_release" "local-static-provisioner" {
  depends_on = [
    k0s_cluster.k0s,
    local_file.kubeconfig,
  ]
  name       = "local-static-provisioner"
  repository = "https://kubernetes-sigs.github.io/sig-storage-local-static-provisioner"
  chart      = "local-static-provisioner"
  namespace  = "kube-system"
  values = [
    yamlencode(local.lsp),
  ]
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
  sc-encryption = {
    hcsi_encryption_key = var.hcsi_encryption_key
  }
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
    yamlencode(local.sc-encryption),
  ]
  set = [
    {
      name  = "hcloud_token"
      value = local.hcloud_token
    }
  ]
}
