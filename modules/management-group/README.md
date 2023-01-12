# Management Group Module

This module creates a Management Group, and moves an existing Azure subscription to be it's child.

Optionally the Management Group can created under the "Tenant Root Group" without a child subscription by setting `management_group_root = true`, or it can be a child of an existing Management Group and contain a subscription.

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) (=2.98.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_management_group.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/management_group) (resource)
- [azurerm_management_group_subscription_association.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/management_group_subscription_association) (resource)
- [azurerm_subscription.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/data-sources/subscription) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_environment"></a> [environment](#input_environment)

Description: (Required) Environment name

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_management_group_parent_id"></a> [management_group_parent_id](#input_management_group_parent_id)

Description: The ID of the Parent Management Group; Default of 'null' for top level Management Group

Type: `string`

Default: `null`

### <a name="input_subscription_ids"></a> [subscription_ids](#input_subscription_ids)

Description: List of Subscription IDs to associate with this Management Group

Type: `set(string)`

Default: `[]`

## Outputs

The following outputs are exported:

### <a name="output_management_group_guid"></a> [management_group_guid](#output_management_group_guid)

Description: (Deprecated) The GUID of the Management Group

### <a name="output_management_group_id"></a> [management_group_id](#output_management_group_id)

Description: The ID of the Management Group

### <a name="output_management_group_name"></a> [management_group_name](#output_management_group_name)

Description: The name of the Management Group
