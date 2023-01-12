/*
 * # Compliance Storage Module
 *
 * This module deploys:
 * * An Azure Storage Account and Log Analytics Workspace for storing compliance logging data.
 * * Activity Log Analytics solution that provides insights from collected Azure Activity logs.
 */
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.98.0"
    }
  }
}

locals {
  tags = merge(var.tags, local.module_tags)
  module_tags = {
    "Module" = basename(abspath(path.module))
  }
}

resource "azurerm_resource_group" "module" {
  name = "${var.resource_prefix}-rg"

  location = var.location
  tags     = local.tags
}

resource "azurerm_management_lock" "module" {
  count = var.resource_group_lock ? 1 : 0

  name       = "resource-group-lock"
  scope      = azurerm_resource_group.module.id
  lock_level = "CanNotDelete"
}

resource "azurerm_storage_account" "module" {
  for_each = var.compliance_locations

  name = "${var.company_prefix}${var.location_abbreviations[each.value]}logs"

  resource_group_name       = azurerm_resource_group.module.name
  location                  = each.key
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  tags                      = local.tags

  blob_properties {
    delete_retention_policy {
      days = var.soft_delete_retention_period
    }
  }
}

resource "azurerm_storage_account_network_rules" "module" {
  for_each = var.compliance_locations

  storage_account_id = azurerm_storage_account.module[each.value].id

  default_action = "Deny"
  ip_rules       = []
  bypass         = ["AzureServices"]
}

resource "azurerm_log_analytics_workspace" "module" {
  for_each = var.compliance_locations

  name = "${var.company_prefix}-${var.location_abbreviations[each.value]}-logs"

  resource_group_name = azurerm_resource_group.module.name
  location            = each.key
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_in_days
  tags                = local.tags
}

resource "azurerm_log_analytics_solution" "activity_log_analytics" {
  for_each = { for x in var.compliance_locations : x => var.location_abbreviations[x] }

  solution_name = "AzureActivity"

  resource_group_name   = azurerm_resource_group.module.name
  location              = each.key
  workspace_resource_id = azurerm_log_analytics_workspace.module[each.key].id
  workspace_name        = azurerm_log_analytics_workspace.module[each.key].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/AzureActivity"
  }
}

# Virtual Machine Management
resource "azurerm_log_analytics_workspace" "vm_management" {
  name = "${var.company_prefix}-${var.location_abbreviations[var.vm_management_location]}-vm-logs"

  resource_group_name = azurerm_resource_group.module.name
  location            = var.vm_management_location
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_in_days
  tags                = local.tags
}

resource "azurerm_automation_account" "vm_management" {
  name = "${var.environment}-vm-management"

  resource_group_name = azurerm_resource_group.module.name
  location            = var.vm_management_location
  sku_name            = "Basic"
}

resource "azurerm_log_analytics_linked_service" "vm_management" {
  resource_group_name = azurerm_resource_group.module.name
  workspace_id        = azurerm_log_analytics_workspace.vm_management.id
  read_access_id      = azurerm_automation_account.vm_management.id
}

module "automation_account_diagnostic" {
  source = "../diagnostic-settings"

  resource_ids = [azurerm_automation_account.vm_management.id]
  compliance_storage = {
    storage_accounts                  = azurerm_storage_account.module
    storage_account_retention_in_days = 0
    log_analytics_workspaces          = azurerm_log_analytics_workspace.module
    log_analytics_retention_in_days   = var.retention_in_days
  }
  location       = var.vm_management_location
  company_prefix = var.company_prefix
}

resource "azurerm_log_analytics_solution" "vm_management" {
  solution_name = "Updates"

  resource_group_name   = azurerm_resource_group.module.name
  location              = var.vm_management_location
  workspace_resource_id = azurerm_log_analytics_workspace.vm_management.id
  workspace_name        = azurerm_log_analytics_workspace.vm_management.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Updates"
  }

  depends_on = [
    azurerm_log_analytics_linked_service.vm_management
  ]
}

resource "azurerm_storage_account" "vm_management" {
  name = "${var.company_prefix}${var.location_abbreviations[var.vm_management_location]}vmlogs"

  resource_group_name       = azurerm_resource_group.module.name
  location                  = var.vm_management_location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  tags                      = local.tags

  blob_properties {
    delete_retention_policy {
      days = var.soft_delete_retention_period
    }
  }
}

resource "azurerm_template_deployment" "windows_event_logs" {
  name                = "vm-management-data-windows-event-logs"
  resource_group_name = azurerm_resource_group.module.name
  deployment_mode     = "Incremental"
  template_body       = file("${path.module}/assets/arm/windows_event_logs.json")

  parameters = {
    "workspaceName" = azurerm_log_analytics_workspace.vm_management.name
    "location"      = var.vm_management_location
  }
}

resource "azurerm_template_deployment" "windows_performance_counters" {
  name                = "vm-management-data-windows-performance-counters"
  resource_group_name = azurerm_resource_group.module.name
  deployment_mode     = "Incremental"
  template_body       = file("${path.module}/assets/arm/windows_performance_counters.json")

  parameters = {
    "workspaceName" = azurerm_log_analytics_workspace.vm_management.name
    "location"      = var.vm_management_location
  }
}

resource "azurerm_template_deployment" "linux_performance_counters" {
  name                = "vm-management-data-linux-performance-counters"
  resource_group_name = azurerm_resource_group.module.name
  deployment_mode     = "Incremental"
  template_body       = file("${path.module}/assets/arm/linux_performance_counters.json")

  parameters = {
    "workspaceName" = azurerm_log_analytics_workspace.vm_management.name
    "location"      = var.vm_management_location
  }
}

resource "azurerm_template_deployment" "syslog" {
  name                = "vm-management-data-syslog"
  resource_group_name = azurerm_resource_group.module.name
  deployment_mode     = "Incremental"
  template_body       = file("${path.module}/assets/arm/syslog.json")

  parameters = {
    "workspaceName" = azurerm_log_analytics_workspace.vm_management.name
    "location"      = var.vm_management_location
  }
}

resource "azurerm_template_deployment" "iis_logs" {
  name                = "vm-management-data-iis-logs"
  resource_group_name = azurerm_resource_group.module.name
  deployment_mode     = "Incremental"
  template_body       = file("${path.module}/assets/arm/iis_logs.json")

  parameters = {
    "workspaceName" = azurerm_log_analytics_workspace.vm_management.name
    "location"      = var.vm_management_location
  }
}
