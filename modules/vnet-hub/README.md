# Virtual Network Hub module

This module deploys a hub virtual network, including subnets for Gateway, Azure Bastion and DNS Forwarders.

## Providers

No providers.

## Modules

The following Modules are called:

### <a name="module_vnet"></a> [vnet](#module_vnet)

Source: ../vnet

Version:

## Resources

No resources.

## Required Inputs

The following input variables are required:

### <a name="input_company_prefix"></a> [company_prefix](#input_company_prefix)

Description: (Required) Prefix given to all globally unique names

Type: `string`

### <a name="input_compliance_storage"></a> [compliance_storage](#input_compliance_storage)

Description: (Required) Map of storage_account_id and log_analytics_workspace_resource_id used for diagnostic setting

Type:

```hcl
object({
    storage_accounts                  = any
    storage_account_retention_in_days = number
    log_analytics_workspaces          = any
    log_analytics_retention_in_days   = number
  })
```

### <a name="input_location"></a> [location](#input_location)

Description: (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.

Type: `string`

### <a name="input_network_watcher_name"></a> [network_watcher_name](#input_network_watcher_name)

Description: (Required) Name of the Network Watcher

Type: `string`

### <a name="input_network_watcher_resource_group_name"></a> [network_watcher_resource_group_name](#input_network_watcher_resource_group_name)

Description: (Required) The name of the Resource Group that the Network Watcher was deployed

Type: `string`

### <a name="input_resource_prefix"></a> [resource_prefix](#input_resource_prefix)

Description: (Required) Prefix given to all resources within the module.

Type: `string`

### <a name="input_vnet_address_space"></a> [vnet_address_space](#input_vnet_address_space)

Description: IP networking range that will be used for the VNet in CIDR notation.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_ddos_standard"></a> [ddos_standard](#input_ddos_standard)

Description: Create a DDoS Standard plan and assign the VNet to it if set to true.

Type: `bool`

Default: `false`

### <a name="input_dns_forwarder_ip_address"></a> [dns_forwarder_ip_address](#input_dns_forwarder_ip_address)

Description: IP Address of the DNS Forwarder

Type: `string`

Default: `"168.63.129.16"`

### <a name="input_network_security_rules"></a> [network_security_rules](#input_network_security_rules)

Description: List of additional Network Security Rules to create

Type:

```hcl
list(object({
    subnet_name                = string
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
```

Default: `[]`

### <a name="input_resource_group_lock"></a> [resource_group_lock](#input_resource_group_lock)

Description: Lock the modules Resource Group with a CanNotDelete Management Lock

Type: `bool`

Default: `true`

### <a name="input_subnets"></a> [subnets](#input_subnets)

Description: List of additional Subnet Objects to create

Type:

```hcl
list(object({
    name    = string
    newbits = number
    netnum  = number
    service_delegation = list(object({
      service = string
      actions = list(string)
    }))
    service_endpoints    = list(string)
    privatelink_service  = bool
    privatelink_endpoint = bool
  }))
```

Default: `[]`

### <a name="input_tags"></a> [tags](#input_tags)

Description: Set of base tags that will be associated with each supported resource.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_dns_forwarder_ip_address"></a> [dns_forwarder_ip_address](#output_dns_forwarder_ip_address)

Description: IP Address of the DNS Forwarder

### <a name="output_network_security_groups"></a> [network_security_groups](#output_network_security_groups)

Description: List of Network Security Groups created in this module

### <a name="output_resource_group_id"></a> [resource_group_id](#output_resource_group_id)

Description: Resource ID of the Resource Group

### <a name="output_resource_group_name"></a> [resource_group_name](#output_resource_group_name)

Description: Name of the Resource Group

### <a name="output_subnets"></a> [subnets](#output_subnets)

Description: List of Subnets created in this module

### <a name="output_subscription_id"></a> [subscription_id](#output_subscription_id)

Description: Subscription ID

### <a name="output_virtual_network_id"></a> [virtual_network_id](#output_virtual_network_id)

Description: Resource ID of the Virtual Network

### <a name="output_virtual_network_name"></a> [virtual_network_name](#output_virtual_network_name)

Description: Resource name of the Virtual Network
