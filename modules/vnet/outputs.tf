output "resource_group_id" {
  value       = azurerm_resource_group.module.id
  description = "Resource ID of the Resource Group"
}

output "resource_group_name" {
  value       = azurerm_resource_group.module.name
  description = "Name of the Resource Group"
}

output "virtual_network_id" {
  value       = azurerm_virtual_network.module.id
  description = "Resource ID of the Virtual Network"
}

output "virtual_network_name" {
  value       = azurerm_virtual_network.module.name
  description = "Resource name of the Virtual Network"
}

output "subnets" {
  value       = azurerm_subnet.module
  description = "List of Subnets created in this module"
}

output "network_security_groups" {
  value       = azurerm_network_security_group.module
  description = "List of Network Security Groups created in this module"
}

output "subscription_id" {
  value       = data.azurerm_subscription.current.subscription_id
  description = "Subscription ID"
}
