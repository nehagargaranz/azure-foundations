# Role assignments module

This module assigns roles in the specified scope (e.g. a subscription) to the specified users, groups or service principals.

For each user or group, a role must be specified.

## Providers

The following providers are used by this module:

- <a name="provider_azuread"></a> [azuread](#provider_azuread) (=2.18.0)

- <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) (=2.98.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_role_assignment.group](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.service_principal](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.user](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/role_assignment) (resource)
- [azuread_group.module](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/data-sources/group) (data source)
- [azuread_service_principal.module](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/data-sources/service_principal) (data source)
- [azuread_user.module](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/data-sources/user) (data source)
- [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/data-sources/subscription) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_scope"></a> [scope](#input_scope)

Description: (Required) Scope for role assignments

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_role_assignment_groups"></a> [role_assignment_groups](#input_role_assignment_groups)

Description: List of Group Role Assignment objects

Type:

```hcl
list(object({
    group_name           = string
    role_definition_name = string
  }))
```

Default: `[]`

### <a name="input_role_assignment_service_principals"></a> [role_assignment_service_principals](#input_role_assignment_service_principals)

Description: List of Service Principal Role Assignment objects

Type:

```hcl
list(object({
    service_principal_name = string
    role_definition_name   = string
  }))
```

Default: `[]`

### <a name="input_role_assignment_users"></a> [role_assignment_users](#input_role_assignment_users)

Description: List of User Role Assignment objects

Type:

```hcl
list(object({
    user_principal_name  = string
    role_definition_name = string
  }))
```

Default: `[]`

## Outputs

No outputs.
