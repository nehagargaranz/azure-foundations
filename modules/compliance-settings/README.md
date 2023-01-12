# Compliance Settings Module

This module configures:
* Diagnostics Settings that sends subscription diagnostic logs to Compliance Storage resources.
* Security Center Contact
* Connects Security Center to Log Analytics Workspace if `Standard` pricing tier is selected
* Enables Network Watcher in whitelisted Azure Regions.

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) (=2.98.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_management_lock.networkwatcher](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/management_lock) (resource)
- [azurerm_monitor_diagnostic_setting.activity_log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_monitor_diagnostic_setting.activity_log_storage](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_network_watcher.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/network_watcher) (resource)
- [azurerm_resource_group.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/resource_group) (resource)
- [azurerm_resource_group.networkwatcher](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/resource_group) (resource)
- [azurerm_security_center_contact.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/security_center_contact) (resource)
- [azurerm_security_center_workspace.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/security_center_workspace) (resource)
- [azurerm_subscription_template_deployment.security_center_auto_provisioning](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/subscription_template_deployment) (resource)
- [azurerm_subscription_template_deployment.security_center_tier](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/subscription_template_deployment) (resource)
- [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/data-sources/subscription) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_company_prefix"></a> [company_prefix](#input_company_prefix)

Description: (Required) Prefix given to all globally unique names

Type: `string`

### <a name="input_compliance_locations"></a> [compliance_locations](#input_compliance_locations)

Description: (Required) Specifies locations where configuration is required.

Type: `set(string)`

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

Description: (Required) Specifies the primary or default Azure location; if a resource only needs to be deployed once regardless of the number of regions in use, the resource will be deployed to this location. See also `compliance_locations`.

Type: `string`

### <a name="input_location_abbreviations"></a> [location_abbreviations](#input_location_abbreviations)

Description: (Required) A map of Azure location names to abbreviations which can be used in (e.g.) storage account names.

Type: `map(string)`

### <a name="input_resource_prefix"></a> [resource_prefix](#input_resource_prefix)

Description: (Required) Prefix given to all resources within the module.

Type: `string`

### <a name="input_security_center_contact_email"></a> [security_center_contact_email](#input_security_center_contact_email)

Description: (Required) The email of the Security Center Contact

Type: `string`

### <a name="input_security_center_contact_phone"></a> [security_center_contact_phone](#input_security_center_contact_phone)

Description: The phone number of the Security Center Contact

Type: `string`

### <a name="input_security_center_pricing_tiers"></a> [security_center_pricing_tiers](#input_security_center_pricing_tiers)

Description: (Required) Resource type(s) to be enabled with specified pricing tier for Security Center protection

Type: `map(string)`

### <a name="input_vm_management"></a> [vm_management](#input_vm_management)

Description: (Required) Map of storage_account and log_analytics_workspace used for VM management.

Type:

```hcl
object({
    storage_account         = any
    log_analytics_workspace = any
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_alert_notifications"></a> [alert_notifications](#input_alert_notifications)

Description: Whether to send security alerts notifications to the security contact

Type: `bool`

Default: `true`

### <a name="input_alerts_to_admins"></a> [alerts_to_admins](#input_alerts_to_admins)

Description: Whether to send security alerts notifications to subscription admins

Type: `bool`

Default: `true`

### <a name="input_resource_group_lock"></a> [resource_group_lock](#input_resource_group_lock)

Description: Lock the modules Resource Group with a CanNotDelete Management Lock

Type: `bool`

Default: `true`

### <a name="input_security_center_autoprovision_vm_agent"></a> [security_center_autoprovision_vm_agent](#input_security_center_autoprovision_vm_agent)

Description: Enable Azure Secuirty Center auto-provisioning of Azure Monitor Agent on VMs

Type: `bool`

Default: `true`

### <a name="input_tags"></a> [tags](#input_tags)

Description: Set of base tags that will be associated with each supported resource.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_network_watcher_resource_group_name"></a> [network_watcher_resource_group_name](#output_network_watcher_resource_group_name)

Description: Name of the Network Watcher Resource Group

### <a name="output_network_watchers"></a> [network_watchers](#output_network_watchers)

Description: Network Watchers object, keyed by location
