# Service Health Alerts Module

This module creates an Activity Log Alert for Azure Service Health events and sends those events to an email address.

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) (=2.98.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_management_lock.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/management_lock) (resource)
- [azurerm_monitor_action_group.security](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/monitor_action_group) (resource)
- [azurerm_monitor_action_group.service_health](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/monitor_action_group) (resource)
- [azurerm_monitor_activity_log_alert.create_update_network_security_group_rules](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/monitor_activity_log_alert) (resource)
- [azurerm_monitor_activity_log_alert.create_update_network_security_groups](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/monitor_activity_log_alert) (resource)
- [azurerm_monitor_activity_log_alert.create_update_policy_assignments](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/monitor_activity_log_alert) (resource)
- [azurerm_monitor_activity_log_alert.create_update_security_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/monitor_activity_log_alert) (resource)
- [azurerm_monitor_activity_log_alert.create_update_security_solutions](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/monitor_activity_log_alert) (resource)
- [azurerm_monitor_activity_log_alert.create_update_sql_server_firewall_rule](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/monitor_activity_log_alert) (resource)
- [azurerm_monitor_activity_log_alert.delete_network_security_group_rules](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/monitor_activity_log_alert) (resource)
- [azurerm_monitor_activity_log_alert.delete_network_security_groups](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/monitor_activity_log_alert) (resource)
- [azurerm_monitor_activity_log_alert.delete_security_solutions](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/monitor_activity_log_alert) (resource)
- [azurerm_monitor_activity_log_alert.delete_sql_server_firewall_rule](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/monitor_activity_log_alert) (resource)
- [azurerm_monitor_activity_log_alert.service_health](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/monitor_activity_log_alert) (resource)
- [azurerm_resource_group.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/resource_group) (resource)
- [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/data-sources/subscription) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input_location)

Description: (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.

Type: `string`

### <a name="input_resource_prefix"></a> [resource_prefix](#input_resource_prefix)

Description: (Required) Prefix given to all resources within the module.

Type: `string`

### <a name="input_security_center_contact_email"></a> [security_center_contact_email](#input_security_center_contact_email)

Description: (Required) The email of the Security Center Contact

Type: `string`

### <a name="input_service_health_alerts_email"></a> [service_health_alerts_email](#input_service_health_alerts_email)

Description: (Required) The email of the Service Health Alerts

Type: `string`

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

No outputs.
