## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) (=2.98.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_container_registry.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/container_registry) (resource)
- [azurerm_resource_group.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/resource_group) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_company_prefix"></a> [company_prefix](#input_company_prefix)

Description: (Required) Prefix given to all globally unique names

Type: `string`

### <a name="input_environment"></a> [environment](#input_environment)

Description: (Required) Environment name

Type: `string`

### <a name="input_location"></a> [location](#input_location)

Description: (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.

Type: `string`

### <a name="input_location_abbreviations"></a> [location_abbreviations](#input_location_abbreviations)

Description: (Required) A map of Azure location names to abbreviations which can be used in (e.g.) storage account names.

Type: `map(string)`

### <a name="input_resource_prefix"></a> [resource_prefix](#input_resource_prefix)

Description: (Required) Prefix given to all resources within the module.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_allowed_ip_ranges"></a> [allowed_ip_ranges](#input_allowed_ip_ranges)

Description: List of CIDR blocks from which be allowed

Type: `list(string)`

Default: `[]`

### <a name="input_allowed_subnet_ids"></a> [allowed_subnet_ids](#input_allowed_subnet_ids)

Description: List of subnet ids from which be allowed

Type: `list(string)`

Default: `[]`

### <a name="input_georeplications"></a> [georeplications](#input_georeplications)

Description: (Required) Location for the registry replica, using the region's short name. It must be different from the home registry location.

Type: `list(string)`

Default: `[]`

### <a name="input_name"></a> [name](#input_name)

Description: Overrides the name of the Container Registry; defaults to [company_prefix][environment][location_abbreviation]

Type: `string`

Default: `""`

### <a name="input_sku"></a> [sku](#input_sku)

Description: The SKU name of the container registry. Possible values are Basic, Standard and Premium

Type: `string`

Default: `"Basic"`

### <a name="input_tags"></a> [tags](#input_tags)

Description: Set of base tags that will be associated with each supported resource.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_acr_id"></a> [acr_id](#output_acr_id)

Description: The ID of the Container Registry

### <a name="output_acr_login_server"></a> [acr_login_server](#output_acr_login_server)

Description: The URL that can be used to log into the container registry
