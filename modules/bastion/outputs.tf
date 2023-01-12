output "bastion_ip_address" {
  value       = azurerm_public_ip.module.ip_address
  description = "IP Address of Bastion Host"
}

output "bastion_fqdn" {
  value       = azurerm_public_ip.module.fqdn
  description = "FQDN of Bastion Host"
}
