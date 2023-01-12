output "network_watchers" {
  value       = azurerm_network_watcher.module
  description = "Network Watchers object, keyed by location"
}

output "network_watcher_resource_group_name" {
  value       = azurerm_resource_group.networkwatcher.name
  description = "Name of the Network Watcher Resource Group"
}
