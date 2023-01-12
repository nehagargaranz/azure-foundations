# DNS Forwarder Module

This module deploys a Linux Virtual Machine Scale Set and a Load Balancer with static private address which act as a DNS forwarder in a given subnet.

Conditional forwarding is configured by setting the `dns_forwarder_servers` variable:
```
dns_forwarder_servers = [
  {
    domain = "example.com"
    server = "8.8.8.8"
  }
]
```

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) (=2.98.0)

## Modules

The following Modules are called:

### <a name="module_autoscale_diagnostic"></a> [autoscale_diagnostic](#module_autoscale_diagnostic)

Source: ../diagnostic-settings

Version:

### <a name="module_lb_diagnostic"></a> [lb_diagnostic](#module_lb_diagnostic)

Source: ../diagnostic-settings

Version:

### <a name="module_vmss_diagnostic"></a> [vmss_diagnostic](#module_vmss_diagnostic)

Source: ../diagnostic-settings

Version:

## Resources

The following resources are used by this module:

- [azurerm_lb.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/lb) (resource)
- [azurerm_lb_backend_address_pool.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/lb_backend_address_pool) (resource)
- [azurerm_lb_probe.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/lb_probe) (resource)
- [azurerm_lb_rule.tcp](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/lb_rule) (resource)
- [azurerm_lb_rule.udp](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/lb_rule) (resource)
- [azurerm_linux_virtual_machine_scale_set.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/linux_virtual_machine_scale_set) (resource)
- [azurerm_management_lock.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/management_lock) (resource)
- [azurerm_monitor_autoscale_setting.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/monitor_autoscale_setting) (resource)
- [azurerm_resource_group.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/resource_group) (resource)
- [azurerm_virtual_machine_scale_set_extension.diagnostic](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/virtual_machine_scale_set_extension) (resource)
- [azurerm_virtual_machine_scale_set_extension.monitoring](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/virtual_machine_scale_set_extension) (resource)
- [azurerm_storage_account_sas.diagnostic](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/data-sources/storage_account_sas) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_company_prefix"></a> [company_prefix](#input_company_prefix)

Description: (Required) Prefix given to all globally unique names

Type: `string`

### <a name="input_compliance_storage"></a> [compliance_storage](#input_compliance_storage)

Description: (Required) Map of storage_account_id and log_analytics_workspace_resource_id used for diagnostic setting

Type:

```hcl
object({
    storage_accounts                  = any
    storage_account_retention_in_days = number
    log_analytics_workspaces          = any
    log_analytics_retention_in_days   = number
  })
```

### <a name="input_dns_forwarder_ip_address"></a> [dns_forwarder_ip_address](#input_dns_forwarder_ip_address)

Description: IP Address of the DNS Forwarder

Type: `string`

### <a name="input_dns_forwarder_subnet_id"></a> [dns_forwarder_subnet_id](#input_dns_forwarder_subnet_id)

Description: (Required) Subnet ID to deploy the Bastion Host

Type: `string`

### <a name="input_location"></a> [location](#input_location)

Description: (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.

Type: `string`

### <a name="input_resource_prefix"></a> [resource_prefix](#input_resource_prefix)

Description: (Required) Prefix given to all resources within the module.

Type: `string`

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

### <a name="input_dns_forwarder_servers"></a> [dns_forwarder_servers](#input_dns_forwarder_servers)

Description: List of maps with `domain` and `address` to configure conditional forwarding in dnsmasq. E.G. [{ domain = 'google.com', address = '8.8.8.8' }]

Type: `list(map(string))`

Default: `[]`

### <a name="input_dns_forwarder_ssh_public_keys"></a> [dns_forwarder_ssh_public_keys](#input_dns_forwarder_ssh_public_keys)

Description: Public keys for remote SSH access

Type: `set(string)`

Default: `[]`

### <a name="input_dns_forwarder_ssh_username"></a> [dns_forwarder_ssh_username](#input_dns_forwarder_ssh_username)

Description: Username for remote SSH access

Type: `string`

Default: `"adminuser"`

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
