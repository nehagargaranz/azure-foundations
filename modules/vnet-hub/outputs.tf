output "resource_group_id" {
  value       = module.vnet.resource_group_id
  description = "Resource ID of the Resource Group"
}

output "resource_group_name" {
  value       = module.vnet.resource_group_name
  description = "Name of the Resource Group"
}

output "virtual_network_id" {
  value       = module.vnet.virtual_network_id
  description = "Resource ID of the Virtual Network"
}

output "virtual_network_name" {
  value       = module.vnet.virtual_network_name
  description = "Resource name of the Virtual Network"
}

output "subnets" {
  value       = module.vnet.subnets
  description = "List of Subnets created in this module"
}

output "network_security_groups" {
  value       = module.vnet.network_security_groups
  description = "List of Network Security Groups created in this module"
}

output "subscription_id" {
  value       = module.vnet.subscription_id
  description = "Subscription ID"
}

output "dns_forwarder_ip_address" {
  value       = var.dns_forwarder_ip_address
  description = "IP Address of the DNS Forwarder"
}
