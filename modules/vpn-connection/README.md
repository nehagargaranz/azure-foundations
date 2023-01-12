# Virtual VPN Gateway module

This module deploys a VPN gateway and configures VPN connections

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) (=2.98.0)

- <a name="provider_random"></a> [random](#provider_random) (=3.1.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_local_network_gateway.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/local_network_gateway) (resource)
- [azurerm_virtual_network_gateway_connection.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/virtual_network_gateway_connection) (resource)
- [random_password.module](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/password) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input_location)

Description: (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.

Type: `string`

### <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name)

Description: (Required) Name of the Resource Group to deploy resources to

Type: `string`

### <a name="input_virtual_network_gateway_id"></a> [virtual_network_gateway_id](#input_virtual_network_gateway_id)

Description: (Required) The ID of the Virtual Network Gateway in which the connection will be created

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_tags"></a> [tags](#input_tags)

Description: Set of base tags that will be associated with each supported resource.

Type: `map(string)`

Default: `{}`

### <a name="input_vpns"></a> [vpns](#input_vpns)

Description: List of VPNs and their configuration

Type:

```hcl
list(object({
    name                               = string
    gateway_address                    = string
    remote_address_spaces              = list(string)
    local_address_spaces               = list(string)
    dh_group                           = string
    ike_version                        = string
    ike_encryption                     = string
    ike_integrity                      = string
    ipsec_encryption                   = string
    ipsec_integrity                    = string
    pfs_group                          = string
    use_policy_based_traffic_selectors = bool
    routing_weight                     = number
    sa_lifetime                        = string
  }))
```

Default: `[]`

## Outputs

No outputs.
