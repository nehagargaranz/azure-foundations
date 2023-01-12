# Virtual Network Route Table Module

This module creates a route table and a list of routes, and associates the route table with a list of subnets.

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) (=2.98.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_management_lock.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/management_lock) (resource)
- [azurerm_resource_group.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/resource_group) (resource)
- [azurerm_route.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/route) (resource)
- [azurerm_route_table.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/route_table) (resource)
- [azurerm_subnet_route_table_association.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/subnet_route_table_association) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input_location)

Description: (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.

Type: `string`

### <a name="input_resource_prefix"></a> [resource_prefix](#input_resource_prefix)

Description: (Required) Prefix given to all resources within the module.

Type: `string`

### <a name="input_subnets"></a> [subnets](#input_subnets)

Description: (Required) List of Subnet Resource IDs to associate the route table

Type: `list(string)`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_create_resource_group"></a> [create_resource_group](#input_create_resource_group)

Description: Create a resource group within this module

Type: `bool`

Default: `true`

### <a name="input_disable_bgp_route_propagation"></a> [disable_bgp_route_propagation](#input_disable_bgp_route_propagation)

Description: Boolean flag which controls propagation of routes learned by BGP on that route table. True means disable.

Type: `bool`

Default: `false`

### <a name="input_resource_group_lock"></a> [resource_group_lock](#input_resource_group_lock)

Description: Lock the modules Resource Group with a CanNotDelete Management Lock

Type: `bool`

Default: `true`

### <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name)

Description: Resource Group to deploy resources to; Used if create_resource_group is false.

Type: `string`

Default: `""`

### <a name="input_routes"></a> [routes](#input_routes)

Description: List of objects representing routes

Type:

```hcl
list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = string
  }))
```

Default:

```json
[
  {
    "address_prefix": "0.0.0.0/0",
    "name": "Internet",
    "next_hop_in_ip_address": "",
    "next_hop_type": "Internet"
  }
]
```

### <a name="input_tags"></a> [tags](#input_tags)

Description: Set of base tags that will be associated with each supported resource.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_route_table_id"></a> [route_table_id](#output_route_table_id)

Description: Route table Resource ID

### <a name="output_route_table_name"></a> [route_table_name](#output_route_table_name)

Description: Route table name
