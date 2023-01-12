/*
 * # Compliance Settings Module
 *
 * This module configures:
 * * Diagnostics Settings that sends subscription diagnostic logs to Compliance Storage resources.
 * * Security Center Contact
 * * Connects Security Center to Log Analytics Workspace if `Standard` pricing tier is selected
 * * Enables Network Watcher in whitelisted Azure Regions.
 *
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
  subscription_diagnostic_log_categories = [
    "Administrative",
    "Security",
    "ServiceHealth",
    "Alert",
    "Recommendation",
    "Policy",
    "Autoscale",
    "ResourceHealth"
  ]
}

data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "module" {
  name = "${var.resource_prefix}-rg"

  location = var.location
  tags     = local.tags
}

resource "azurerm_resource_group" "networkwatcher" {
  name = "NetworkWatcherRG"

  location = var.location
  tags     = local.tags
}

resource "azurerm_management_lock" "networkwatcher" {
  count = var.resource_group_lock ? 1 : 0

  name       = "resource-group-lock"
  scope      = azurerm_resource_group.networkwatcher.id
  lock_level = "CanNotDelete"
}

resource "azurerm_monitor_diagnostic_setting" "activity_log_storage" {
  name = "${var.company_prefix}-storage-account-diagnostic-setting"

  target_resource_id = data.azurerm_subscription.current.id
  storage_account_id = var.compliance_storage.storage_accounts[var.location].id

  dynamic "log" {
    for_each = local.subscription_diagnostic_log_categories
    content {
      category = log.value
      enabled  = true
      retention_policy {
        enabled = true
        days    = var.compliance_storage.storage_account_retention_in_days
      }
    }
  }

  lifecycle {
    ignore_changes = [
      log,
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "activity_log_analytics" {
  name = "${var.company_prefix}-log-analytics-diagnostic-setting"

  target_resource_id             = data.azurerm_subscription.current.id
  log_analytics_workspace_id     = var.compliance_storage.log_analytics_workspaces[var.location].id
  log_analytics_destination_type = "Dedicated"

  dynamic "log" {
    for_each = local.subscription_diagnostic_log_categories
    content {
      category = log.value
      enabled  = true
      retention_policy {
        enabled = true
        days    = var.compliance_storage.log_analytics_retention_in_days
      }
    }
  }

  lifecycle {
    ignore_changes = [
      log_analytics_destination_type,
      log,
    ]
  }
}

resource "azurerm_security_center_contact" "module" {
  email = var.security_center_contact_email
  phone = var.security_center_contact_phone

  alert_notifications = var.alert_notifications
  alerts_to_admins    = var.alerts_to_admins
}

resource "azurerm_security_center_workspace" "module" {
  count = contains(values(var.security_center_pricing_tiers), "Standard") ? 1 : 0

  scope        = data.azurerm_subscription.current.id
  workspace_id = var.vm_management.log_analytics_workspace.id

  timeouts {
    create = "90m"
    delete = "90m"
  }

  depends_on = [
    azurerm_subscription_template_deployment.security_center_tier
  ]
}

resource "azurerm_network_watcher" "module" {
  for_each = var.compliance_locations

  name = "${var.resource_prefix}-${var.location_abbreviations[each.value]}-nw"

  resource_group_name = azurerm_resource_group.networkwatcher.name
  location            = each.value
  tags                = local.tags
}

resource "azurerm_subscription_template_deployment" "security_center_tier" {
  for_each = var.security_center_pricing_tiers

  name             = "security-center-${each.key}-deployment"
  location         = var.location
  template_content = templatefile("${path.module}/templates/security-center-pricing-tier.json.tpl", { resourceType = each.key, pricingTier = each.value })
}

resource "azurerm_subscription_template_deployment" "security_center_auto_provisioning" {
  name             = "security-center-auto-provisioning"
  location         = var.location
  template_content = templatefile("${path.module}/templates/security-center-auto-provisioning.json.tpl", { autoprovisionVmAgent = var.security_center_autoprovision_vm_agent ? "On" : "Off" })
}
