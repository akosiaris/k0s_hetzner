output "controller_ip_addresses" {
  value = module.controllers.addresses
}

output "worker_ip_addresses" {
  value = module.workers.addresses
}

output "worker_ip_addresses_ng" {
  value = module.workers.addresses_ng
}

output "controller_ip_addresses_ng" {
  value = module.controllers.addresses_ng
}

output "lb_ip_addresses" {
  value = module.controller_ips.lb_addresses
}
