# Docs at https://registry.terraform.io/providers/hetznercloud/hcloud/latest
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.4.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }
    k0s = {
      source  = "alessiodionisi/k0s"
      version = "0.2.2"
    }
  }
}
