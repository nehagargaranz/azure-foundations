/*
 * # Virtual Network Route Table Module
 *
 * This module creates a route table and a list of routes, and associates the route table with a list of subnets.
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
  resource_group_name = var.create_resource_group ? azurerm_resource_group.module[0].name : var.resource_group_name
  subnets = {
    for s in var.subnets : s => s
  }
  routes = {
    for s in var.routes : s.name => s
  }
}

resource "azurerm_resource_group" "module" {
  count = var.create_resource_group ? 1 : 0

  name     = "${var.resource_prefix}-rg"
  location = var.location
  tags     = local.tags
}

resource "azurerm_management_lock" "module" {
  count = var.create_resource_group && var.resource_group_lock ? 1 : 0

  name       = "resource-group-lock"
  scope      = azurerm_resource_group.module[0].id
  lock_level = "CanNotDelete"
}

resource "azurerm_route_table" "module" {
  name = var.resource_prefix

  location                      = var.location
  resource_group_name           = local.resource_group_name
  disable_bgp_route_propagation = var.disable_bgp_route_propagation
  tags                          = local.tags
}

resource "azurerm_route" "module" {
  for_each = local.routes

  name                   = each.value.name
  resource_group_name    = local.resource_group_name
  route_table_name       = azurerm_route_table.module.name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_type == "VirtualAppliance" ? each.value.next_hop_in_ip_address : null
}

resource "azurerm_subnet_route_table_association" "module" {
  for_each = local.subnets

  subnet_id      = each.value
  route_table_id = azurerm_route_table.module.id
}
