# Compliance Storage Module

This module deploys:
* An Azure Storage Account and Log Analytics Workspace for storing compliance logging data.
* Activity Log Analytics solution that provides insights from collected Azure Activity logs.

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) (=2.98.0)

## Modules

The following Modules are called:

### <a name="module_automation_account_diagnostic"></a> [automation_account_diagnostic](#module_automation_account_diagnostic)

Source: ../diagnostic-settings

Version:

## Resources

The following resources are used by this module:

- [azurerm_automation_account.vm_management](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/automation_account) (resource)
- [azurerm_log_analytics_linked_service.vm_management](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/log_analytics_linked_service) (resource)
- [azurerm_log_analytics_solution.activity_log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/log_analytics_solution) (resource)
- [azurerm_log_analytics_solution.vm_management](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/log_analytics_solution) (resource)
- [azurerm_log_analytics_workspace.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/log_analytics_workspace) (resource)
- [azurerm_log_analytics_workspace.vm_management](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/log_analytics_workspace) (resource)
- [azurerm_management_lock.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/management_lock) (resource)
- [azurerm_resource_group.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/resource_group) (resource)
- [azurerm_storage_account.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/storage_account) (resource)
- [azurerm_storage_account.vm_management](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/storage_account) (resource)
- [azurerm_storage_account_network_rules.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/storage_account_network_rules) (resource)
- [azurerm_template_deployment.iis_logs](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/template_deployment) (resource)
- [azurerm_template_deployment.linux_performance_counters](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/template_deployment) (resource)
- [azurerm_template_deployment.syslog](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/template_deployment) (resource)
- [azurerm_template_deployment.windows_event_logs](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/template_deployment) (resource)
- [azurerm_template_deployment.windows_performance_counters](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/template_deployment) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_company_prefix"></a> [company_prefix](#input_company_prefix)

Description: (Required) Prefix given to all globally unique names

Type: `string`

### <a name="input_compliance_locations"></a> [compliance_locations](#input_compliance_locations)

Description: (Required) Specifies locations where storage is required.

Type: `set(string)`

### <a name="input_environment"></a> [environment](#input_environment)

Description: (Required) Environment name

Type: `string`

### <a name="input_location"></a> [location](#input_location)

Description: (Required) Specifies the primary or default Azure location; if a resource only needs to be deployed once regardless of the number of regions in use, the resource will be deployed to this location. See also `compliance_locations`.

Type: `string`

### <a name="input_location_abbreviations"></a> [location_abbreviations](#input_location_abbreviations)

Description: (Required) A map of Azure location names to abbreviations which can be used in (e.g.) storage account names.

Type: `map(string)`

### <a name="input_resource_prefix"></a> [resource_prefix](#input_resource_prefix)

Description: (Required) Prefix given to all resources within the module.

Type: `string`

### <a name="input_vm_management_location"></a> [vm_management_location](#input_vm_management_location)

Description: (Required) Specifies location where Log Analytics and Update Management are deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_resource_group_lock"></a> [resource_group_lock](#input_resource_group_lock)

Description: Lock the modules Resource Group with a CanNotDelete Management Lock

Type: `bool`

Default: `true`

### <a name="input_retention_in_days"></a> [retention_in_days](#input_retention_in_days)

Description: The number of days to retain logs within the workspace.

Type: `string`

Default: `"90"`

### <a name="input_soft_delete_retention_period"></a> [soft_delete_retention_period](#input_soft_delete_retention_period)

Description: The number of days to retain blobs for soft deletion

Type: `number`

Default: `90`

### <a name="input_tags"></a> [tags](#input_tags)

Description: Set of base tags that will be associated with each supported resource.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_compliance_storage"></a> [compliance_storage](#output_compliance_storage)

Description: Map containing compliance storage variables

### <a name="output_vm_management"></a> [vm_management](#output_vm_management)

Description: Map containing VM Management storage variables
