# Private DNS zone module

This module deploys an Azure Private DNS Zone, optionally linked to one or more Virtual Networks.

Resources in the linked Virtual Network can resolve names in this zone; with `registration_enabled = true` set for the Vnet, VMs in the vnet will have their private IP addresses registered as names in this zone.

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) (=2.98.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_management_lock.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/management_lock) (resource)
- [azurerm_private_dns_zone.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/private_dns_zone) (resource)
- [azurerm_private_dns_zone_virtual_network_link.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/private_dns_zone_virtual_network_link) (resource)
- [azurerm_resource_group.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/resource_group) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input_location)

Description: (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.

Type: `string`

### <a name="input_private_dns_zone_prefix"></a> [private_dns_zone_prefix](#input_private_dns_zone_prefix)

Description: (Required) Prefix of the Private DNS Zone name

Type: `string`

### <a name="input_private_dns_zone_suffix"></a> [private_dns_zone_suffix](#input_private_dns_zone_suffix)

Description: (Required) Suffix of the Private DNS Zone name

Type: `string`

### <a name="input_resource_prefix"></a> [resource_prefix](#input_resource_prefix)

Description: (Required) Prefix given to all resources within the module.

Type: `string`

### <a name="input_virtual_network_links"></a> [virtual_network_links](#input_virtual_network_links)

Description: (Required) Map of Virtual Network Objects to link

Type:

```hcl
map(object({
    virtual_network_name = string
    virtual_network_id   = string
    registration_enabled = bool
  }))
```

## Optional Inputs

The following input variables are optional (have default values):

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

### <a name="output_private_dns_zone_name"></a> [private_dns_zone_name](#output_private_dns_zone_name)

Description: Name of the private dns zone
