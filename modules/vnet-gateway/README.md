# Virtual Network Gateway module

This module deploys a VNET gateway

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) (=2.98.0)

## Modules

The following Modules are called:

### <a name="module_vpn_gateway_diagnostic"></a> [vpn_gateway_diagnostic](#module_vpn_gateway_diagnostic)

Source: ../diagnostic-settings

Version:

## Resources

The following resources are used by this module:

- [azurerm_public_ip.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/public_ip) (resource)
- [azurerm_virtual_network_gateway.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/virtual_network_gateway) (resource)

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

### <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name)

Description: (Required) Name of the Resource Group to deploy resources to

Type: `string`

### <a name="input_resource_prefix"></a> [resource_prefix](#input_resource_prefix)

Description: (Required) Prefix given to all resources within the module.

Type: `string`

### <a name="input_subnet_id"></a> [subnet_id](#input_subnet_id)

Description: (Required) Subnet ID of the GatewaySubnet

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_gateway_sku"></a> [gateway_sku](#input_gateway_sku)

Description: Configuration of the size and capacity of the virtual network gateway

Type: `string`

Default: `"Basic"`

### <a name="input_gateway_type"></a> [gateway_type](#input_gateway_type)

Description: The type of the Virtual Network Gateway. Valid options are Vpn or ExpressRoute.

Type: `string`

Default: `"Vpn"`

### <a name="input_tags"></a> [tags](#input_tags)

Description: Set of base tags that will be associated with each supported resource.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_virtual_network_gateway_id"></a> [virtual_network_gateway_id](#output_virtual_network_gateway_id)

Description: Resource ID of the Virtual Network Gateway
