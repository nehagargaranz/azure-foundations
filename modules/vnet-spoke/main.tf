/*
 * # Virtual Network Spoke module
 *
 * This module deploys a "spoke" virtual network and peers it with the hub virtual network.
 */
terraform {
  required_version = ">= 0.13"
}

locals {
  subnets = [
    {
      name                 = "Public"
      newbits              = 3
      netnum               = 4
      service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Web", "Microsoft.Storage", "Microsoft.AzureActiveDirectory"]
      service_delegation   = []
      privatelink_service  = true
      privatelink_endpoint = false
    },
    {
      name                 = "Application"
      newbits              = 2
      netnum               = 1
      service_endpoints    = ["Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.ContainerRegistry", "Microsoft.EventHub", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web"]
      service_delegation   = []
      privatelink_service  = false
      privatelink_endpoint = false
    },
    {
      name                 = "Data"
      newbits              = 2
      netnum               = 0
      service_endpoints    = ["Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.ContainerRegistry", "Microsoft.EventHub", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web"]
      service_delegation   = []
      privatelink_service  = false
      privatelink_endpoint = true
    },
  ]

  network_security_rules = [
    {
      subnet_name                = "Public"
      name                       = "Deny-Public-to-Data"
      priority                   = 100
      direction                  = "Outbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = module.vnet.subnets.Data.address_prefix
    },
    {
      subnet_name                = "Data"
      name                       = "Deny-Data-to-Public"
      priority                   = 100
      direction                  = "Outbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = module.vnet.subnets.Public.address_prefix
    },
    {
      subnet_name                = "Data"
      name                       = "Deny-Data-to-Internet"
      priority                   = 110
      direction                  = "Outbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "Internet"
    },
  ]
}

module "vnet" {
  source = "../vnet"

  resource_prefix                     = var.resource_prefix
  location                            = var.location
  tags                                = var.tags
  company_prefix                      = var.company_prefix
  compliance_storage                  = var.compliance_storage
  vnet_address_space                  = var.vnet_address_space
  ddos_standard                       = var.ddos_standard
  dns_servers                         = [var.dns_forwarder_ip_address]
  subnets                             = concat(var.subnets, local.subnets)
  network_security_rules              = concat(var.network_security_rules, local.network_security_rules)
  resource_group_lock                 = var.resource_group_lock
  network_watcher_name                = var.network_watcher_name
  network_watcher_resource_group_name = var.network_watcher_resource_group_name
}

module "vnet_peering" {
  source = "../vnet-peering"

  resource_prefix                           = var.resource_prefix
  spoke_virtual_network_id                  = module.vnet.virtual_network_id
  spoke_virtual_network_name                = module.vnet.virtual_network_name
  spoke_virtual_network_resource_group_name = module.vnet.resource_group_name
  spoke_allow_virtual_network_access        = var.spoke_allow_virtual_network_access
  spoke_allow_forwarded_traffic             = var.spoke_allow_forwarded_traffic
  spoke_use_remote_gateways                 = var.spoke_use_remote_gateways
  hub_virtual_network_id                    = var.hub_virtual_network_id
  hub_virtual_network_name                  = var.hub_virtual_network_name
  hub_virtual_network_resource_group_name   = var.hub_virtual_network_resource_group_name
  hub_subscription_id                       = var.hub_subscription_id
  hub_allow_virtual_network_access          = var.hub_allow_virtual_network_access
  hub_allow_forwarded_traffic               = var.hub_allow_forwarded_traffic
  hub_allow_gateway_transit                 = var.hub_allow_gateway_transit
}
