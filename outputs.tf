output "controller_ip_addresses" {
  value = module.controllers.addresses
}

output "worker_ip_addresses" {
  value = module.workers.addresses
}
