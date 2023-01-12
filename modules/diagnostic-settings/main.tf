/*
 * # Diagnostic Settings Module
 *
 * This module configures Diagnostic Settings when provided a list of Resource IDs.
 *
 * Diagnostic Categories are dynamically retrieved for each resource, and log and metric data are sent to both a Storage Account and Log Analytics Workspace.
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

data "azurerm_monitor_diagnostic_categories" "categories" {
  count = length(var.resource_ids)

  resource_id = var.resource_ids[count.index]
}

resource "azurerm_monitor_diagnostic_setting" "storage_account" {
  count = length(var.resource_ids)

  name = "${var.company_prefix}-storage-account-diagnostic-settings"

  target_resource_id = var.resource_ids[count.index]
  storage_account_id = var.compliance_storage.storage_accounts[var.location].id

  dynamic "log" {
    for_each = var.enable_logs ? data.azurerm_monitor_diagnostic_categories.categories[count.index].logs : []
    content {
      category = log.value
      enabled  = true
      retention_policy {
        enabled = true
        days    = var.compliance_storage.storage_account_retention_in_days
      }
    }
  }

  dynamic "metric" {
    for_each = var.enable_metrics ? data.azurerm_monitor_diagnostic_categories.categories[count.index].metrics : []
    content {
      category = metric.value
      enabled  = true
      retention_policy {
        enabled = true
        days    = var.compliance_storage.storage_account_retention_in_days
      }
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "log_analytics" {
  count = length(var.resource_ids)

  name = "${var.company_prefix}-log-analytics-diagnostic-settings"

  target_resource_id             = var.resource_ids[count.index]
  log_analytics_workspace_id     = var.compliance_storage.log_analytics_workspaces[var.location].id
  log_analytics_destination_type = "Dedicated"

  dynamic "log" {
    for_each = var.enable_logs ? data.azurerm_monitor_diagnostic_categories.categories[count.index].logs : []
    content {
      category = log.value
      enabled  = true
      retention_policy {
        enabled = true
        days    = var.compliance_storage.log_analytics_retention_in_days
      }
    }
  }

  dynamic "metric" {
    for_each = var.enable_metrics ? data.azurerm_monitor_diagnostic_categories.categories[count.index].metrics : []
    content {
      category = metric.value
      enabled  = true
      retention_policy {
        enabled = true
        days    = var.compliance_storage.log_analytics_retention_in_days
      }
    }
  }

  lifecycle {
    ignore_changes = [
      log_analytics_destination_type
    ]
  }
}
