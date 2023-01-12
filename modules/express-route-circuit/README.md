# Express Route module

This module deploys an express route circuit.

Optionally Azure Private and Microsoft peering can be enabled, and a list of Virtual Network Gateways can be connected to the circuit.

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) (=2.98.0)

## Modules

The following Modules are called:

### <a name="module_express_route_diagnostic"></a> [express_route_diagnostic](#module_express_route_diagnostic)

Source: ../diagnostic-settings

Version:

## Resources

The following resources are used by this module:

- [azurerm_express_route_circuit.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/express_route_circuit) (resource)
- [azurerm_express_route_circuit_authorization.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/express_route_circuit_authorization) (resource)
- [azurerm_express_route_circuit_peering.microsoft_peering](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/express_route_circuit_peering) (resource)
- [azurerm_express_route_circuit_peering.private_peering](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/express_route_circuit_peering) (resource)
- [azurerm_management_lock.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/management_lock) (resource)
- [azurerm_resource_group.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/resource_group) (resource)
- [azurerm_route_filter.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/route_filter) (resource)
- [azurerm_virtual_network_gateway_connection.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/virtual_network_gateway_connection) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_bandwidth_in_mbps"></a> [bandwidth_in_mbps](#input_bandwidth_in_mbps)

Description: (Required) The bandwidth in Mbps of the circuit being created

Type: `string`

### <a name="input_company_prefix"></a> [company_prefix](#input_company_prefix)

Description: (Required) Prefix given to all globally unique names

Type: `string`

### <a name="input_compliance_storage"></a> [compliance_storage](#input_compliance_storage)

Description: (Required) Map of compliance storage settings

Type:

```hcl
object({
    storage_accounts                  = any
    storage_account_retention_in_days = number
    log_analytics_workspaces          = any
    log_analytics_retention_in_days   = number
  })
```

### <a name="input_connected_vnets"></a> [connected_vnets](#input_connected_vnets)

Description: (Required) One or more virtual networks that the ExpressRoute should connect to

Type:

```hcl
map(object({
    vnet_name       = string
    vnet_gateway_id = string
    routing_weight  = number
  }))
```

### <a name="input_location"></a> [location](#input_location)

Description: (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.

Type: `string`

### <a name="input_peering_location"></a> [peering_location](#input_peering_location)

Description: (Required) The name of the peering location and not the Azure resource location

Type: `string`

### <a name="input_resource_prefix"></a> [resource_prefix](#input_resource_prefix)

Description: (Required) Prefix given to all resources within the module.

Type: `string`

### <a name="input_service_provider_name"></a> [service_provider_name](#input_service_provider_name)

Description: (Required) The name of the ExpressRoute Service provider

Type: `string`

### <a name="input_sku_family"></a> [sku_family](#input_sku_family)

Description: (Required) The billing mode for ExpressRoute bandwidth. Possible values are MeteredData or UnlimitedData

Type: `string`

### <a name="input_sku_tier"></a> [sku_tier](#input_sku_tier)

Description: (Required) The ExpressRoute service tier. Possible values are Basic, Local, Standard or Premium

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_advertised_public_prefixes"></a> [advertised_public_prefixes](#input_advertised_public_prefixes)

Description: A list of public prefixes to advertise over the BGP session, required when `enable_microsoft_peering` is `true`

Type: `list(string)`

Default: `[]`

### <a name="input_enable_microsoft_peering"></a> [enable_microsoft_peering](#input_enable_microsoft_peering)

Description: Whether to enable Microsoft Peering with the ExpressRoute Circuit

Type: `bool`

Default: `false`

### <a name="input_enable_private_peering"></a> [enable_private_peering](#input_enable_private_peering)

Description: Whether to enable Azure Private Peering with the ExpressRoute Circuit

Type: `bool`

Default: `false`

### <a name="input_microsoft_peering_asn"></a> [microsoft_peering_asn](#input_microsoft_peering_asn)

Description: A 16-bit or a 32-bit ASN for Microsoft Peering

Type: `number`

Default: `null`

### <a name="input_microsoft_peering_customer_asn"></a> [microsoft_peering_customer_asn](#input_microsoft_peering_customer_asn)

Description: The CustomerASN of the peering

Type: `number`

Default: `null`

### <a name="input_microsoft_peering_primary_address_prefix"></a> [microsoft_peering_primary_address_prefix](#input_microsoft_peering_primary_address_prefix)

Description: A /30 subnet for the primary link of Microsoft Peering, required when `enable_microsoft_peering` is `true`

Type: `string`

Default: `null`

### <a name="input_microsoft_peering_route_filter_communities"></a> [microsoft_peering_route_filter_communities](#input_microsoft_peering_route_filter_communities)

Description: List of communities for route filter rule

Type: `list(string)`

Default: `[]`

### <a name="input_microsoft_peering_routing_registry_name"></a> [microsoft_peering_routing_registry_name](#input_microsoft_peering_routing_registry_name)

Description: The RoutingRegistryName of the configuration

Type: `string`

Default: `null`

### <a name="input_microsoft_peering_secondary_address_prefix"></a> [microsoft_peering_secondary_address_prefix](#input_microsoft_peering_secondary_address_prefix)

Description: A /30 subnet for the secondary link of Microsoft Peering, required when `enable_microsoft_peering` is `true`

Type: `string`

Default: `null`

### <a name="input_microsoft_peering_vlan_id"></a> [microsoft_peering_vlan_id](#input_microsoft_peering_vlan_id)

Description: A valid VLAN ID to establish Microsoft Peering on, required when `enable_microsoft_peering` is `true`

Type: `string`

Default: `null`

### <a name="input_private_peering_asn"></a> [private_peering_asn](#input_private_peering_asn)

Description: A 16-bit or a 32-bit ASN for Azure Private Peering

Type: `number`

Default: `null`

### <a name="input_private_peering_primary_address_prefix"></a> [private_peering_primary_address_prefix](#input_private_peering_primary_address_prefix)

Description: A /30 subnet for the primary link of Azure Private Peering, required when `enable_private_peering` is `true`

Type: `string`

Default: `null`

### <a name="input_private_peering_secondary_address_prefix"></a> [private_peering_secondary_address_prefix](#input_private_peering_secondary_address_prefix)

Description: A /30 subnet for the secondary link of Azure Private Peering, required when `enable_private_peering` is `true`

Type: `string`

Default: `null`

### <a name="input_private_peering_vlan_id"></a> [private_peering_vlan_id](#input_private_peering_vlan_id)

Description: A valid VLAN ID to establish Azure Private Peering on, required when `enable_private_peering` is `true`

Type: `string`

Default: `null`

### <a name="input_resource_group_lock"></a> [resource_group_lock](#input_resource_group_lock)

Description: Lock the modules Resource Group with a CanNotDelete Management Lock

Type: `bool`

Default: `true`

### <a name="input_tags"></a> [tags](#input_tags)

Description: Set of base tags that will be associated with each supported resource.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_express_route_circuit_id"></a> [express_route_circuit_id](#output_express_route_circuit_id)

Description: The ID of the Express Route Circuit

### <a name="output_express_route_service_key"></a> [express_route_service_key](#output_express_route_service_key)

Description: The string needed by the service provider to provision the ExpressRoute circuit

### <a name="output_resource_group_name"></a> [resource_group_name](#output_resource_group_name)

Description: Name of the Resource Group
