output "acr_id" {
  value       = azurerm_container_registry.module.id
  description = "The ID of the Container Registry"
}

output "acr_login_server" {
  value       = azurerm_container_registry.module.login_server
  description = "The URL that can be used to log into the container registry"
}
