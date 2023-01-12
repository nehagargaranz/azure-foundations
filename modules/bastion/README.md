# Bastion Host Module

This module deploys an Azure Bastion Host Instance in a given subnet with a static public IP address.

Diagnostic data is sent to Compliance Storage resources.

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) (=2.98.0)

## Modules

The following Modules are called:

### <a name="module_bastion_host_diagnostic"></a> [bastion_host_diagnostic](#module_bastion_host_diagnostic)

Source: ../diagnostic-settings

Version:

### <a name="module_public_ip_diagnostic"></a> [public_ip_diagnostic](#module_public_ip_diagnostic)

Source: ../diagnostic-settings

Version:

## Resources

The following resources are used by this module:

- [azurerm_bastion_host.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/bastion_host) (resource)
- [azurerm_management_lock.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/management_lock) (resource)
- [azurerm_public_ip.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/public_ip) (resource)
- [azurerm_resource_group.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/resource_group) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_bastion_subnet_id"></a> [bastion_subnet_id](#input_bastion_subnet_id)

Description: (Required) Subnet ID to deploy the Bastion Host

Type: `string`

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

### <a name="input_location"></a> [location](#input_location)

Description: (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.

Type: `string`

### <a name="input_resource_prefix"></a> [resource_prefix](#input_resource_prefix)

Description: (Required) Prefix given to all resources within the module.

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

The following outputs are exported:

### <a name="output_bastion_fqdn"></a> [bastion_fqdn](#output_bastion_fqdn)

Description: FQDN of Bastion Host

### <a name="output_bastion_ip_address"></a> [bastion_ip_address](#output_bastion_ip_address)

Description: IP Address of Bastion Host
