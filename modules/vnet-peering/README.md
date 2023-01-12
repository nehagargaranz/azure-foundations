# Virtual Network Peering module

This module configures peering between the remote vnet and the specified local vnet. (Called from the vnet-spoke module.)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) (=2.98.0)

- <a name="provider_azurerm.hub"></a> [azurerm.hub](#provider_azurerm.hub) (=2.98.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_virtual_network_peering.hub_to_spoke](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/virtual_network_peering) (resource)
- [azurerm_virtual_network_peering.spoke_to_hub](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/virtual_network_peering) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_hub_subscription_id"></a> [hub_subscription_id](#input_hub_subscription_id)

Description: (Required) The subscription ID of the remote VNet

Type: `string`

### <a name="input_hub_virtual_network_id"></a> [hub_virtual_network_id](#input_hub_virtual_network_id)

Description: (Required) The Resource ID of the remote VNet

Type: `string`

### <a name="input_hub_virtual_network_name"></a> [hub_virtual_network_name](#input_hub_virtual_network_name)

Description: (Required) The Resource ID of the remote VNet

Type: `string`

### <a name="input_hub_virtual_network_resource_group_name"></a> [hub_virtual_network_resource_group_name](#input_hub_virtual_network_resource_group_name)

Description: (Required) The resource group of the remote VNet

Type: `string`

### <a name="input_resource_prefix"></a> [resource_prefix](#input_resource_prefix)

Description: (Required) Prefix given to all resources within the module.

Type: `string`

### <a name="input_spoke_virtual_network_id"></a> [spoke_virtual_network_id](#input_spoke_virtual_network_id)

Description: (Required) The Resource ID of the local VNet

Type: `string`

### <a name="input_spoke_virtual_network_name"></a> [spoke_virtual_network_name](#input_spoke_virtual_network_name)

Description: (Required) The name of the local VNet

Type: `string`

### <a name="input_spoke_virtual_network_resource_group_name"></a> [spoke_virtual_network_resource_group_name](#input_spoke_virtual_network_resource_group_name)

Description: (Required) The resource group of the local VNet

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_hub_allow_forwarded_traffic"></a> [hub_allow_forwarded_traffic](#input_hub_allow_forwarded_traffic)

Description: Controls if forwarded traffic from VMs in the remote virtual network is allowed

Type: `bool`

Default: `null`

### <a name="input_hub_allow_gateway_transit"></a> [hub_allow_gateway_transit](#input_hub_allow_gateway_transit)

Description: Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network

Type: `bool`

Default: `null`

### <a name="input_hub_allow_virtual_network_access"></a> [hub_allow_virtual_network_access](#input_hub_allow_virtual_network_access)

Description: Controls if the VMs in the remote virtual network can access VMs in the local virtual network

Type: `bool`

Default: `null`

### <a name="input_hub_use_remote_gateways"></a> [hub_use_remote_gateways](#input_hub_use_remote_gateways)

Description: Controls if remote gateways can be used on the local virtual network

Type: `bool`

Default: `null`

### <a name="input_spoke_allow_forwarded_traffic"></a> [spoke_allow_forwarded_traffic](#input_spoke_allow_forwarded_traffic)

Description: Controls if forwarded traffic from VMs in the remote virtual network is allowed

Type: `bool`

Default: `null`

### <a name="input_spoke_allow_gateway_transit"></a> [spoke_allow_gateway_transit](#input_spoke_allow_gateway_transit)

Description: Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network

Type: `bool`

Default: `null`

### <a name="input_spoke_allow_virtual_network_access"></a> [spoke_allow_virtual_network_access](#input_spoke_allow_virtual_network_access)

Description: Controls if the VMs in the remote virtual network can access VMs in the local virtual network

Type: `bool`

Default: `null`

### <a name="input_spoke_use_remote_gateways"></a> [spoke_use_remote_gateways](#input_spoke_use_remote_gateways)

Description: Controls if remote gateways can be used on the local virtual network

Type: `bool`

Default: `null`

## Outputs

No outputs.
