# Diagnostic Settings Module

This module configures Diagnostic Settings when provided a list of Resource IDs.

Diagnostic Categories are dynamically retrieved for each resource, and log and metric data are sent to both a Storage Account and Log Analytics Workspace.

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) (=2.98.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_monitor_diagnostic_setting.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_monitor_diagnostic_setting.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_monitor_diagnostic_categories.categories](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/data-sources/monitor_diagnostic_categories) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_company_prefix"></a> [company_prefix](#input_company_prefix)

Description: (Required) Prefix given to all globally unique names

Type: `string`

### <a name="input_compliance_storage"></a> [compliance_storage](#input_compliance_storage)

Description: Map of compliance storage settings

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

Description: (Required) Specifies the supported Azure location where the resources exist, to allow things like diagnostics storage to be co-located.

Type: `string`

### <a name="input_resource_ids"></a> [resource_ids](#input_resource_ids)

Description: List of Resource IDs to associate diagnostic setting

Type: `list(string)`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_enable_logs"></a> [enable_logs](#input_enable_logs)

Description: Enable Logs collection

Type: `bool`

Default: `true`

### <a name="input_enable_metrics"></a> [enable_metrics](#input_enable_metrics)

Description: Enable Metrics collection

Type: `bool`

Default: `true`

## Outputs

No outputs.
