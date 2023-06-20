variable "hcloud_token" {
  sensitive   = true # Requires terraform >= 0.14
  description = "Value of the Hetzner token"
  type        = string
}

variable "ssh_pub_key" {
  type        = string
  description = "Public SSH key for connecting to servers"
}

variable "ssh_priv_key_path" {
  type        = string
  description = "The private part of the above"
  sensitive   = true
}

variable "domain" {
  type        = string
  description = "The domain of all hosts. Will be used to generate all PTRs"
}

variable "k0s_version" {
  type        = string
  description = "The version of k0s to target. Default: 1.27.2+k0s.0"
  default     = "1.27.2+k0s.0"
  validation {
    condition     = can(regex("1.27.2\\+k0s\\.0", var.k0s_version))
    error_message = "Unsupported k0s version provided"
  }
}
