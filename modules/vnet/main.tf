/*
 * # Virtual Network module
 *
 * This module deploys a virtual network and adds the specified subnets and network security groups. This module is called by the vnet-hub and vnet-spoke modules, but can be used in isolation.
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
  ddos_standard = var.ddos_standard ? [{}] : []
  subnets = {
    for s in var.subnets : s.name => s
  }
  # Some subnets cannot have a Network Security Group attached
  network_security_groups = {
    for s in var.subnets : s.name => s
    if !contains(var.skip_network_security_groups, s.name)
  }
  network_security_rules = {
    for s in var.network_security_rules : "${s.subnet_name}-${s.direction}-${s.priority}" => s
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

resource "azurerm_network_ddos_protection_plan" "module" {
  count = var.ddos_standard == true ? 1 : 0

  name                = "${var.resource_prefix}-ddos"
  resource_group_name = azurerm_resource_group.module.name
  location            = azurerm_resource_group.module.location
  tags                = local.tags
}

resource "azurerm_virtual_network" "module" {
  name = var.resource_prefix

  resource_group_name = azurerm_resource_group.module.name
  location            = azurerm_resource_group.module.location
  address_space       = [var.vnet_address_space]
  dns_servers         = var.dns_servers
  tags                = local.tags

  dynamic "ddos_protection_plan" {
    for_each = local.ddos_standard

    content {
      id     = azurerm_network_ddos_protection_plan.module.*.id[0]
      enable = true
    }
  }
}

module "virtual_network_diagnostic" {
  source = "../diagnostic-settings"

  resource_ids       = [azurerm_virtual_network.module.id]
  compliance_storage = var.compliance_storage
  location           = var.location
  company_prefix     = var.company_prefix
}

resource "azurerm_subnet" "module" {
  for_each = local.subnets

  name = each.value.name

  resource_group_name                            = azurerm_resource_group.module.name
  virtual_network_name                           = azurerm_virtual_network.module.name
  service_endpoints                              = each.value.service_endpoints
  address_prefixes                               = [cidrsubnet(var.vnet_address_space, each.value.newbits, each.value.netnum)]
  enforce_private_link_service_network_policies  = each.value.privatelink_service
  enforce_private_link_endpoint_network_policies = each.value.privatelink_endpoint

  dynamic "delegation" {
    for_each = each.value.service_delegation

    content {
      name = delegation.value.service
      service_delegation {
        name    = delegation.value.service
        actions = delegation.value.actions
      }
    }
  }
}

resource "azurerm_network_security_group" "module" {
  for_each = local.network_security_groups

  name = "${var.resource_prefix}-${each.value.name}-nsg"

  resource_group_name = azurerm_resource_group.module.name
  location            = azurerm_resource_group.module.location
  tags                = local.tags
}

module "network_security_group_diagnostic" {
  source = "../diagnostic-settings"

  resource_ids       = [for value in azurerm_network_security_group.module : value.id]
  compliance_storage = var.compliance_storage
  location           = var.location
  company_prefix     = var.company_prefix
  enable_metrics     = false
}

resource "azurerm_subnet_network_security_group_association" "module" {
  for_each = local.network_security_groups

  subnet_id                 = azurerm_subnet.module[each.key].id
  network_security_group_id = azurerm_network_security_group.module[each.key].id

  depends_on = [
    azurerm_subnet.module,
    azurerm_network_security_group.module,
    azurerm_network_security_rule.module,
  ]
}

resource "azurerm_network_security_rule" "module" {
  for_each = local.network_security_rules

  name = each.value.name

  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.module.name
  network_security_group_name = azurerm_network_security_group.module[each.value.subnet_name].name
}

resource "azurerm_network_watcher_flow_log" "module" {
  for_each = local.network_security_groups

  name                      = azurerm_network_security_group.module[each.key].name
  network_watcher_name      = var.network_watcher_name
  resource_group_name       = var.network_watcher_resource_group_name
  network_security_group_id = azurerm_network_security_group.module[each.key].id
  storage_account_id        = var.compliance_storage.storage_accounts[var.location].id
  version                   = 2
  enabled                   = true

  retention_policy {
    enabled = true
    days    = var.compliance_storage.storage_account_retention_in_days
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = var.compliance_storage.log_analytics_workspaces[var.location].workspace_id
    workspace_region      = var.compliance_storage.log_analytics_workspaces[var.location].location
    workspace_resource_id = var.compliance_storage.log_analytics_workspaces[var.location].id
  }
}
