output "private_dns_zone_name" {
  value       = azurerm_private_dns_zone.module.name
  description = "Name of the private dns zone"
}
