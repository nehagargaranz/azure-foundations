output "management_group_id" {
  value       = azurerm_management_group.module.id
  description = "The ID of the Management Group"
}

output "management_group_guid" {
  value       = azurerm_management_group.module.group_id
  description = "(Deprecated) The GUID of the Management Group"
}

output "management_group_name" {
  value       = azurerm_management_group.module.name
  description = "The name of the Management Group"
}
