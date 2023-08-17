# Note: don't go overboard adding helm charts in this file. It is meant just
# for infrastructural stuff, not generic applications
resource "helm_release" "cert-manager" {
  depends_on = [
    k0s_cluster.k0s,
    local_file.kubeconfig
  ]
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "kube-system"
  version    = "1.12.0"

  set {
    name  = "installCRDs"
    value = "true"
  }
  set {
    name  = "prometheus.enabled"
    value = "true"
  }
}

resource "helm_release" "ingress-nginx" {
  depends_on = [
    k0s_cluster.k0s,
    local_file.kubeconfig
  ]
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "kube-system"
  version    = "4.7.0"

  set {
    name  = "controller.service.type"
    value = "ClusterIP"
  }
  set_list {
    name  = "controller.service.externalIPs"
    value = var.externalIPs
  }
}

resource "terraform_data" "hcloud_token" {
  count = (var.hccm_enable || var.hcsi_enable) ? 1 : 0
  depends_on = [
    k0s_cluster.k0s,
    local_file.kubeconfig,
  ]
  provisioner "local-exec" {
    command    = "kubectl --kubeconfig=kubeconfig-${var.domain} -n kube-system create secret generic hcloud --from-literal=token=${var.hcloud_token}"
    on_failure = continue
  }
}

resource "helm_release" "hccm" {
  # Versioning policy at https://github.com/hetznercloud/hcloud-cloud-controller-manager#versioning-policy
  count = var.hccm_enable ? 1 : 0
  depends_on = [
    k0s_cluster.k0s,
    local_file.kubeconfig,
    terraform_data.hcloud_token,
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
    terraform_data.hcloud_token,
    helm_release.hccm,
  ]
  name      = "hcloud-csi-driver"
  chart     = "./hcloud-csi-driver-helm-chart"
  namespace = "kube-system"
  set {
    name  = "EncryptedStorageClass.encryptionpassphrase"
    value = var.hcsi_encryption_key
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
