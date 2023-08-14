variable "amount" {
  type        = number
  description = "The number of servers"
}

variable "role" {
  type        = string
  description = "The role of the server. It will be set in labels"
  validation {
    condition     = can(regex("(worker|controller|controller+worker|single)", var.role))
    error_message = "Unsupported server role provided"
  }
}

variable "domain" {
  type        = string
  description = "The domain of all hosts. Will be used to generate all PTRs"
}

variable "enable_ipv4" {
  type        = bool
  description = "Whether an IPv4 address should be allocated"
  default     = true
}

variable "enable_ipv6" {
  type        = bool
  description = "Whether an IPv6 address should be allocated"
  default     = true
}

variable "hostname" {
  type        = string
  description = "You can override the generated name to one of your choose. Only use if spawning up a single server"
  default     = null
}

variable "datacenter" {
  type        = string
  description = "The Hetzner datacenter name to create the server in. Values: nbg1-dc3, fsn1-dc14, hel1-dc2, ash-dc1, hil-dc1. Defaults to fsn1-dc14"
  default     = "fsn1-dc14"
  validation {
    condition     = contains(["nbg1-dc3", "fsn1-dc14", "hel1-dc2", "ash-dc1", "hil-dc1"], var.datacenter)
    error_message = "Unsupported datacenter provided"
  }
}

variable "enable_balancer" {
  type        = bool
  description = "Whether a balancer should be allocated"
  default     = false
}

variable "balancer_type" {
  type        = string
  description = "The load balancer type to deploy in front of the created IPs"
  default     = "lb11"
  validation {
    condition     = can(regex("lb[123]1", var.balancer_type))
    error_message = "Unsupported load balancer type provided"
  }
}

variable "balanced_services" {
  type        = list(number)
  description = "The ports that will get load balanced. NOTE: currently listen and dest port need to be the same"
  default     = [6443, 8132, 9443]
  validation {
    condition     = length(var.balanced_services) > 0
    error_message = "Empty port list supplied"
  }
}

variable "balanced_protocol" {
  type        = string
  description = "The load balanced protocol"
  default     = "tcp"
  validation {
    condition     = can(regex("tcp", var.balanced_protocol))
    error_message = "Unsupported load balanced protocol provided. We only support TCP for now"
  }
}

# Hetzner private network related variables
variable "enable_network" {
  type        = bool
  description = "Enable a Hetzner private network"
  default     = false
}

variable "network_ip_range" {
  type        = string
  description = "A CIDR in the RFC1918 space for the Hetzner private network. This is an umbrella entity, don't be frugal"
  default     = "10.100.0.0/16"
}

variable "network_subnet_ip_range" {
  type        = string
  description = "A CIDR in the RFC1918 space for the Hetzner private network subnet. This needs to be part of the network_ip_range"
  default     = "10.100.1.0/24"
}

variable "network_subnet_type" {
  type        = string
  description = "Either cloud of vswitch. vswitch is only possible if you also have a Hetzner Robot vswitch"
  default     = "cloud"
  validation {
    condition     = contains(["cloud", "vswitch"], var.network_subnet_type)
    error_message = "Unsupported load balanced protocol provided. We only support TCP for now"
  }
}

variable "network_vswitch_id" {
  type        = number
  description = "ID of the vswitch, Required if type is vswitch"
  default     = null
}

variable "network_zone" {
  type        = string
  description = "The Hetzner network zone. Stick to eu-central for now"
  default     = "eu-central"
}
