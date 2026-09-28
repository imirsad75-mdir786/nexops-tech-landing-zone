output "subnet_details" {
  value       = module.subnets.subnet_outputs
  description = "Banaye gaye sabhi Subnets ki details"
}


output "network_interface_details" {
  value       = module.network_interface.nic_outputs
  description = "Banaye gaye sabhi NICs ki details"
}

