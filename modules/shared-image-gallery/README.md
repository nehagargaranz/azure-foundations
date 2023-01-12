# Shared Image Gallery Module

This module deploys an Azure Shared Image Gallery and Shared Image definitions when provided with a list of custom images.

The module does not manage or deploy custom image versions. These are intended to be managed by the SOE Image Factory.

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) (=2.98.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_resource_group.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/resource_group) (resource)
- [azurerm_shared_image.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/shared_image) (resource)
- [azurerm_shared_image_gallery.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/shared_image_gallery) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_company_prefix"></a> [company_prefix](#input_company_prefix)

Description: (Required) Prefix given to all globally unique names

Type: `string`

### <a name="input_environment"></a> [environment](#input_environment)

Description: (Required) Environment name

Type: `string`

### <a name="input_images"></a> [images](#input_images)

Description: (Required) List of Shared Images to create

Type:

```hcl
list(object({
    image_name         = string
    os_type            = string
    hyper_v_generation = string
    publisher          = string
    offer              = string
    sku                = string
  }))
```

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

### <a name="input_name"></a> [name](#input_name)

Description: Overrides the name of the Shared Image Gallery; defaults to [company_prefix][environment][location_abbreviation]sig

Type: `string`

Default: `""`

### <a name="input_tags"></a> [tags](#input_tags)

Description: Set of base tags that will be associated with each supported resource.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_shared_image_gallery_id"></a> [shared_image_gallery_id](#output_shared_image_gallery_id)

Description: The ID of the Shared Image Gallery

### <a name="output_shared_image_gallery_name"></a> [shared_image_gallery_name](#output_shared_image_gallery_name)

Description: The unique name of the Shared Image Gallery
