variable "controller_count" {
  type        = number
  description = "The number of controllers. Defaults to 3"
  default     = 3
}

variable "controller_server_type" {
  type        = string
  description = "The Hetzner cloud server type. Values: cax11, cax21, cax31, cax41 (all ARM64)"
  # arm64 machine
  default = "cax11"
  validation {
    condition     = can(regex("c[apc]?x[1234]1", var.controller_server_type))
    error_message = "Unsupported server type provided"
  }
}

variable "controller_server_image" {
  type        = string
  description = "The Hetzner cloud server image. Values: debian-11, debian-12"
  # TODO: Bump to 12 once it's available
  default = "debian-11"
  validation {
    condition     = can(regex("debian-1[12]", var.controller_server_image))
    error_message = "Unsupported server image provided"
  }
}

variable "controller_server_location" {
  type        = string
  description = "The Hetzner cloud server location. Values: fsn1"
  # Only falkenstein has arm64 for now
  default = "fsn1"
  validation {
    condition     = can(regex("fsn1", var.controller_server_location))
    error_message = "Unsupported server location provided"
  }
}

variable "controller_server_datacenter" {
  type        = string
  description = "The Hetzner datacenter name to create the server in. Values: nbg1-dc3, fsn1-dc14, hel1-dc2, ash-dc1 or hil-dc1"
  default     = "fsn1-dc14"
  validation {
    condition     = contains(["nbg1-dc3", "hel1-dc2", "fsn1-dc14", "ash-dc1", "hil-dc1"], var.controller_server_datacenter)
    error_message = "Unsupported datacenter provided"
  }
}

variable "controller_role" {
  type        = string
  description = "The k0s role for a controller. Values: controller, controller+worker, single"
  default     = "controller"
  validation {
    condition     = can(regex("controller|controller+worker|single", var.controller_role))
    error_message = "Unsupported controller role"
  }
}

variable "single_controller_name" {
  type        = string
  description = "If you are deploying a single role, it's probably a pet. Name it"
  default     = "darkstar"
}

variable "controller_load_balancer_type" {
  type        = string
  description = "The load balancer type to deploy in front of the controllers"
  default     = "lb11"
  validation {
    condition     = can(regex("lb[123]1", var.controller_load_balancer_type))
    error_message = "Unsupported load balancer type provided"
  }
}
