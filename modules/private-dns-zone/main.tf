/*
 * # Private DNS zone module
 *
 * This module deploys an Azure Private DNS Zone, optionally linked to one or more Virtual Networks.
 *
 * Resources in the linked Virtual Network can resolve names in this zone; with `registration_enabled = true` set for the Vnet, VMs in the vnet will have their private IP addresses registered as names in this zone.
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

resource "azurerm_private_dns_zone" "module" {
  name = "${var.private_dns_zone_prefix}.${var.private_dns_zone_suffix}"

  resource_group_name = azurerm_resource_group.module.name
  tags                = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "module" {
  for_each = var.virtual_network_links

  name                  = each.value.virtual_network_name
  resource_group_name   = azurerm_resource_group.module.name
  private_dns_zone_name = azurerm_private_dns_zone.module.name
  virtual_network_id    = each.value.virtual_network_id
  registration_enabled  = each.value.registration_enabled
  tags                  = local.tags
}
