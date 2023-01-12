/*
 * # Virtual Network Peering module
 *
 * This module configures peering between the remote vnet and the specified local vnet. (Called from the vnet-spoke module.)
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

provider "azurerm" {
  alias = "hub"
  features {}
  subscription_id = var.hub_subscription_id
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name = "${var.resource_prefix}-spoke-to-hub"

  resource_group_name          = var.spoke_virtual_network_resource_group_name
  virtual_network_name         = var.spoke_virtual_network_name
  remote_virtual_network_id    = var.hub_virtual_network_id
  allow_virtual_network_access = var.spoke_allow_virtual_network_access
  allow_forwarded_traffic      = var.spoke_allow_forwarded_traffic
  allow_gateway_transit        = var.spoke_allow_gateway_transit
  use_remote_gateways          = var.spoke_use_remote_gateways
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name = "${var.resource_prefix}-hub-to-spoke"

  resource_group_name          = var.hub_virtual_network_resource_group_name
  virtual_network_name         = var.hub_virtual_network_name
  remote_virtual_network_id    = var.spoke_virtual_network_id
  allow_virtual_network_access = var.hub_allow_virtual_network_access
  allow_forwarded_traffic      = var.hub_allow_forwarded_traffic
  allow_gateway_transit        = var.hub_allow_gateway_transit
  use_remote_gateways          = var.hub_use_remote_gateways
  provider                     = azurerm.hub
}
