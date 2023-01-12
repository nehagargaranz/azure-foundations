output "route_table_id" {
  value       = azurerm_route_table.module.id
  description = "Route table Resource ID"
}

output "route_table_name" {
  value       = azurerm_route_table.module.name
  description = "Route table name"
}
