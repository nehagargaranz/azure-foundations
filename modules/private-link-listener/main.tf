/*
 * # Private Link Listener
 *
 * This module creates an Event Grid subscription for Private Endpoint events, and triggers an Azure Function to manage DNS entries.
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
}

data "azurerm_subscription" "current" {}

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

resource "azurerm_eventgrid_event_subscription" "module" {
  name  = "${var.environment}-${var.location_abbreviations[var.location]}-pl-listener"
  scope = data.azurerm_subscription.current.id

  advanced_filter {
    string_contains {
      key = "data.operationName"
      values = [
        "Microsoft.Network/privateEndpoints/write",
        "Microsoft.Network/privateEndpoints/delete",
      ]
    }
  }

  included_event_types = [
    "Microsoft.Resources.ResourceWriteSuccess",
    "Microsoft.Resources.ResourceDeleteSuccess",
  ]

  azure_function_endpoint {
    function_id                       = var.function_id
    max_events_per_batch              = 1
    preferred_batch_size_in_kilobytes = 64
  }
}

resource "azurerm_role_assignment" "module" {
  principal_id         = var.function_app_identity
  role_definition_name = "Reader"
  scope                = data.azurerm_subscription.current.id
}
