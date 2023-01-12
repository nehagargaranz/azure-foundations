/*
 * # Virtual Network Hub module
 *
 * This module deploys a hub virtual network, including subnets for Gateway, Azure Bastion and DNS Forwarders.
 */
terraform {
  required_version = ">= 0.13"
}

locals {
  subnets = [
    {
      name                 = "AzureBastionSubnet"
      newbits              = 5
      netnum               = 28
      service_endpoints    = ["Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.ContainerRegistry", "Microsoft.EventHub", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web"]
      service_delegation   = []
      privatelink_service  = false
      privatelink_endpoint = false
    },
    {
      name                 = "GatewaySubnet"
      newbits              = 5
      netnum               = 31
      service_endpoints    = []
      service_delegation   = []
      privatelink_service  = false
      privatelink_endpoint = false
    },
    {
      name                 = "ApplicationGatewaySubnet"
      newbits              = 5
      netnum               = 27
      service_endpoints    = []
      service_delegation   = []
      privatelink_service  = false
      privatelink_endpoint = false
    },
    {
      name                 = "DnsForwarderSubnet"
      newbits              = 5
      netnum               = 29
      service_endpoints    = []
      service_delegation   = []
      privatelink_service  = false
      privatelink_endpoint = false
    },
    {
      name                 = "AzureFirewallSubnet"
      newbits              = 3
      netnum               = 5
      service_endpoints    = []
      service_delegation   = []
      privatelink_service  = false
      privatelink_endpoint = false
    },
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
      protocol                   = "Tcp"
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
      protocol                   = "Tcp"
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
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "Internet"
    },
    {
      subnet_name                = "AzureBastionSubnet"
      name                       = "bastion-in-allow"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      subnet_name                = "AzureBastionSubnet"
      name                       = "bastion-control-in-allow-443"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "GatewayManager"
      destination_address_prefix = "*"
    },
    {
      subnet_name                = "AzureBastionSubnet"
      name                       = "bastion-control-in-allow-4443"
      priority                   = 121
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "4443"
      source_address_prefix      = "GatewayManager"
      destination_address_prefix = "*"
    },
    {
      subnet_name                = "AzureBastionSubnet"
      name                       = "bastion-in-deny"
      priority                   = 900
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      subnet_name                = "AzureBastionSubnet"
      name                       = "bastion-vnet-out-allow-22"
      priority                   = 100
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "VirtualNetwork"
    },
    {
      subnet_name                = "AzureBastionSubnet"
      name                       = "bastion-vnet-out-allow-3389"
      priority                   = 101
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "*"
      destination_address_prefix = "VirtualNetwork"
    },
    {
      subnet_name                = "AzureBastionSubnet"
      name                       = "bastion-azure-out-allow"
      priority                   = 120
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "AzureCloud"
    },
    # {
    #   subnet_name                = "DnsForwarderSubnet"
    #   name                       = "dns-forwarder-out-azure-platform-dns"
    #   priority                   = 100
    #   direction                  = "Outbound"
    #   access                     = "Allow"
    #   protocol                   = "*"
    #   source_port_range          = "*"
    #   destination_port_range     = "53"
    #   source_address_prefix      = "*"
    #   destination_address_prefix = "168.63.129.16/32"
    # },
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
  skip_network_security_groups        = ["AzureFirewallSubnet", "GatewaySubnet"]
  network_security_rules              = concat(var.network_security_rules, local.network_security_rules)
  resource_group_lock                 = var.resource_group_lock
  network_watcher_name                = var.network_watcher_name
  network_watcher_resource_group_name = var.network_watcher_resource_group_name
}
