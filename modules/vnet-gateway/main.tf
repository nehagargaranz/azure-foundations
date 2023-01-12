/*
 * # Virtual Network Gateway module
 *
 * This module deploys a VNET gateway
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

resource "azurerm_public_ip" "module" {
  name = "${var.resource_prefix}-ip"

  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"
  tags                = local.tags
}

resource "azurerm_virtual_network_gateway" "module" {
  name = "${var.company_prefix}-${var.resource_prefix}"

  resource_group_name = var.resource_group_name
  location            = var.location
  type                = var.gateway_type
  sku                 = var.gateway_sku
  tags                = local.tags

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.module.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }
}

module "vpn_gateway_diagnostic" {
  source = "../diagnostic-settings"

  resource_ids = [
    azurerm_virtual_network_gateway.module.id,
    azurerm_public_ip.module.id,
  ]
  compliance_storage = var.compliance_storage
  location           = var.location
  company_prefix     = var.company_prefix
}
