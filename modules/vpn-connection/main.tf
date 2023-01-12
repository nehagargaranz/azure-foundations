/*
 * # Virtual VPN Gateway module
 *
 * This module deploys a VPN gateway and configures VPN connections
 */
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.98.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.1.0"
    }
  }
}

locals {
  tags = merge(var.tags, local.module_tags)
  module_tags = {
    "Module" = basename(abspath(path.module))
  }
  vpns = {
    for vpn in var.vpns : vpn.name => vpn
  }
}

resource "random_password" "module" {
  for_each = local.vpns

  length  = 64
  special = false

  lifecycle {
    ignore_changes = [
      length,
      lower,
      min_lower,
      min_numeric,
      min_special,
      min_upper,
      number,
      special,
      upper,
    ]
  }
}

resource "azurerm_local_network_gateway" "module" {
  for_each = local.vpns

  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location
  gateway_address     = each.value.gateway_address
  address_space       = each.value.remote_address_spaces
}

resource "azurerm_virtual_network_gateway_connection" "module" {
  for_each = local.vpns

  name                               = each.value.name
  resource_group_name                = var.resource_group_name
  location                           = var.location
  virtual_network_gateway_id         = var.virtual_network_gateway_id
  local_network_gateway_id           = azurerm_local_network_gateway.module[each.key].id
  type                               = "IPsec"
  shared_key                         = random_password.module[each.key].result
  connection_protocol                = each.value.ike_version
  enable_bgp                         = false
  use_policy_based_traffic_selectors = each.value.use_policy_based_traffic_selectors
  routing_weight                     = each.value.routing_weight
  tags                               = local.tags

  dynamic "traffic_selector_policy" {
    for_each = each.value.use_policy_based_traffic_selectors == true ? [1] : []

    content {
      local_address_cidrs  = each.value.local_address_spaces
      remote_address_cidrs = each.value.remote_address_spaces
    }
  }

  ipsec_policy {
    dh_group         = each.value.dh_group
    ike_encryption   = each.value.ike_encryption
    ike_integrity    = each.value.ike_integrity
    ipsec_encryption = each.value.ipsec_encryption
    ipsec_integrity  = each.value.ipsec_integrity
    pfs_group        = each.value.pfs_group
    sa_lifetime      = each.value.sa_lifetime
  }
}
