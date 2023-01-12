/*
 * # Bastion Host Module
 *
 * This module deploys an Azure Bastion Host Instance in a given subnet with a static public IP address.
 *
 * Diagnostic data is sent to Compliance Storage resources.
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

resource "azurerm_public_ip" "module" {
  name = "${var.resource_prefix}-ip"

  resource_group_name = azurerm_resource_group.module.name
  location            = azurerm_resource_group.module.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

module "public_ip_diagnostic" {
  source = "../diagnostic-settings"

  resource_ids       = [azurerm_public_ip.module.id]
  compliance_storage = var.compliance_storage
  location           = var.location
  company_prefix     = var.company_prefix
}

resource "azurerm_bastion_host" "module" {
  name = "${var.resource_prefix}-host"

  resource_group_name = azurerm_resource_group.module.name
  location            = azurerm_resource_group.module.location
  tags                = local.tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.module.id
  }
}

module "bastion_host_diagnostic" {
  source = "../diagnostic-settings"

  resource_ids       = [azurerm_bastion_host.module.id]
  compliance_storage = var.compliance_storage
  location           = var.location
  company_prefix     = var.company_prefix
  enable_metrics     = false
}
