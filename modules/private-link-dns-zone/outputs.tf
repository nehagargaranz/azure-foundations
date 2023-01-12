output "private_dns_zone_names" {
  value       = [for zone in azurerm_private_dns_zone.module : zone.name]
  description = "Names of the private dns zone"
}

output "function_app_url" {
  value       = "https://${azurerm_function_app.module.default_hostname}/api/PrivateLinkEndpoint"
  description = "URL of Function App"
  sensitive   = true
}

output "function_app_identity" {
  value       = azurerm_function_app.module.identity[0].principal_id
  description = "Principal ID of the Function App"
}

output "function_id" {
  value       = "${azurerm_function_app.module.id}/functions/PrivateLinkEndpoint"
  description = "Function ID of the PrivateLinkEndpoint function"
}
