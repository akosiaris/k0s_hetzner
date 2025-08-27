output "controller_ip_addresses" {
  value = module.controllers.addresses
}

output "worker_ip_addresses" {
  value = merge(try(module.workers.addresses, {}), var.extra_workers)
}

output "lb_ip_addresses" {
  value = module.controller_ips.lb_addresses
}
