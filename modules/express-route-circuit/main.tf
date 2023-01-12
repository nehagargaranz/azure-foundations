/*
 * # Express Route module
 *
 * This module deploys an express route circuit.
 *
 * Optionally Azure Private and Microsoft peering can be enabled, and a list of Virtual Network Gateways can be connected to the circuit.
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
  connected_vnets = { for vnet in var.connected_vnets : vnet.vnet_name => vnet if var.enable_private_peering }
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

resource "azurerm_express_route_circuit" "module" {
  name = var.resource_prefix

  resource_group_name   = azurerm_resource_group.module.name
  location              = var.location
  service_provider_name = var.service_provider_name
  peering_location      = var.peering_location
  bandwidth_in_mbps     = var.bandwidth_in_mbps
  tags                  = local.tags

  sku {
    tier   = var.sku_tier
    family = var.sku_family
  }
}

module "express_route_diagnostic" {
  source = "../diagnostic-settings"

  resource_ids       = [azurerm_express_route_circuit.module.id]
  compliance_storage = var.compliance_storage
  location           = var.location
  company_prefix     = var.company_prefix
}

resource "azurerm_express_route_circuit_peering" "private_peering" {
  count = var.enable_private_peering ? 1 : 0

  peering_type                  = "AzurePrivatePeering"
  express_route_circuit_name    = azurerm_express_route_circuit.module.name
  resource_group_name           = azurerm_resource_group.module.name
  primary_peer_address_prefix   = var.private_peering_primary_address_prefix
  secondary_peer_address_prefix = var.private_peering_secondary_address_prefix
  vlan_id                       = var.private_peering_vlan_id
  peer_asn                      = var.private_peering_asn
}

resource "azurerm_express_route_circuit_peering" "microsoft_peering" {
  count = var.enable_microsoft_peering ? 1 : 0

  peering_type                  = "MicrosoftPeering"
  express_route_circuit_name    = azurerm_express_route_circuit.module.name
  resource_group_name           = azurerm_resource_group.module.name
  primary_peer_address_prefix   = var.microsoft_peering_primary_address_prefix
  secondary_peer_address_prefix = var.microsoft_peering_secondary_address_prefix
  vlan_id                       = var.microsoft_peering_vlan_id
  peer_asn                      = var.microsoft_peering_asn
  route_filter_id               = azurerm_route_filter.module[0].id

  microsoft_peering_config {
    advertised_public_prefixes = var.advertised_public_prefixes
    customer_asn               = var.microsoft_peering_customer_asn
    routing_registry_name      = var.microsoft_peering_routing_registry_name
  }
}

resource "azurerm_route_filter" "module" {
  count = var.enable_microsoft_peering ? 1 : 0

  name                = "${var.resource_prefix}-route-filter"
  resource_group_name = azurerm_resource_group.module.name
  location            = azurerm_resource_group.module.location
  tags                = local.tags

  rule {
    name        = "${var.resource_prefix}-rule"
    access      = "Allow"
    rule_type   = "Community"
    communities = var.microsoft_peering_route_filter_communities
  }
}

resource "azurerm_express_route_circuit_authorization" "module" {
  for_each = local.connected_vnets

  name                       = "${each.value.vnet_name}-erc-auth"
  express_route_circuit_name = azurerm_express_route_circuit.module.name
  resource_group_name        = azurerm_resource_group.module.name
}

resource "azurerm_virtual_network_gateway_connection" "module" {
  for_each = local.connected_vnets

  name                       = "${each.value.vnet_name}-er-connection"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.module.name
  type                       = "ExpressRoute"
  virtual_network_gateway_id = each.value.vnet_gateway_id
  express_route_circuit_id   = azurerm_express_route_circuit.module.id
  authorization_key          = azurerm_express_route_circuit_authorization.module[each.key].authorization_key
  enable_bgp                 = true
  routing_weight             = each.value.routing_weight # Suboptimal routing between virtual networks - https://docs.microsoft.com/en-us/azure/expressroute/expressroute-optimize-routing#suboptimal-routing-between-virtual-networks
  tags                       = local.tags
}
