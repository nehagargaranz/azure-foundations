output "compliance_storage" {
  value = {
    storage_accounts                  = azurerm_storage_account.module
    storage_account_retention_in_days = 0
    log_analytics_workspaces          = azurerm_log_analytics_workspace.module
    log_analytics_retention_in_days   = var.retention_in_days
  }
  description = "Map containing compliance storage variables"
  sensitive   = true
}

output "vm_management" {
  value = {
    storage_account         = azurerm_storage_account.vm_management
    log_analytics_workspace = azurerm_log_analytics_workspace.vm_management
  }
  description = "Map containing VM Management storage variables"
  sensitive   = true
}
