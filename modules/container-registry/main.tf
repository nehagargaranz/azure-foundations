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
  name = var.name != "" ? var.name : join("", [var.company_prefix, var.environment, var.location_abbreviations[var.location]])
}

resource "azurerm_resource_group" "module" {
  name = "${var.resource_prefix}-rg"

  location = var.location
  tags     = local.tags
}

resource "azurerm_container_registry" "module" {
  name = local.name

  resource_group_name = azurerm_resource_group.module.name
  location            = azurerm_resource_group.module.location
  sku                 = var.sku
  admin_enabled       = false
  tags                = local.tags

  dynamic "georeplications" {
    for_each = var.sku == "Premium" ? var.georeplications : []

    content {
      location = georeplications.value
    }
  }

  dynamic "retention_policy" {
    for_each = var.sku == "Premium" ? [1] : []

    content {
      days    = 90
      enabled = true
    }
  }

  dynamic "network_rule_set" {
    for_each = var.sku == "Premium" ? [1] : []

    content {
      default_action = "Deny"
      # Allowed IP ranges
      ip_rule = [
        for ip_range in var.allowed_ip_ranges : {
          action   = "Allow"
          ip_range = ip_range
        }
      ]

      virtual_network = [
        for subnet in var.allowed_subnet_ids : {
          action    = "Allow"
          subnet_id = subnet
        }
      ]
    }
  }
}
