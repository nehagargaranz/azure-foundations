# Private Link Listener

This module creates an Event Grid subscription for Private Endpoint events, and triggers an Azure Function to manage DNS entries.

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) (=2.98.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_eventgrid_event_subscription.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/eventgrid_event_subscription) (resource)
- [azurerm_management_lock.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/management_lock) (resource)
- [azurerm_resource_group.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/resource_group) (resource)
- [azurerm_role_assignment.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/role_assignment) (resource)
- [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/data-sources/subscription) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_environment"></a> [environment](#input_environment)

Description: (Required) Environment name

Type: `string`

### <a name="input_function_app_identity"></a> [function_app_identity](#input_function_app_identity)

Description: (Required) Function App Identity [Principal ID]

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

### <a name="input_function_id"></a> [function_id](#input_function_id)

Description: (Required) Function App ID

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

No outputs.
