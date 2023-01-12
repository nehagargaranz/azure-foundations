output "express_route_circuit_id" {
  value       = azurerm_express_route_circuit.module.id
  description = "The ID of the Express Route Circuit"
}

output "express_route_service_key" {
  value       = azurerm_express_route_circuit.module.service_key
  description = "The string needed by the service provider to provision the ExpressRoute circuit"
  sensitive   = true
}

output "resource_group_name" {
  value       = azurerm_resource_group.module.name
  description = "Name of the Resource Group"
}
