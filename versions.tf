# Docs at https://registry.terraform.io/providers/hetznercloud/hcloud/latest
terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.49.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
  }
}
