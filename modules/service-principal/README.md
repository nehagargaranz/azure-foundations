# Service Principal module

This module creates a Service Principals and assigns API permissions to the associated Application Registration.

Permissions can be supplied using their API names, GUIDs will be derived automatically. The module will fail if a permission or API name can't be found.

```
service_principals = [
  {
    name_suffix = "foo"
    required_resource_access = [
      {
        application_display_name = "Windows Azure Active Directory"
        application_resource_access = [
          "Directory.Read.All",
          "Policy.Read.All",
        ]
        delegated_resource_access = [
          "Directory.Read.All",
          "User.Read",
        ]
      },
      {
        application_display_name = "Microsoft Graph"
        application_resource_access = [
          "Team.ReadBasic.All",
        ]
        delegated_resource_access = [
          "AuditLog.Read.All",
        ]
      },
    ]
  },
  {
    name_suffix = "bar"
    required_resource_access = [
      {
        application_display_name = "Windows Azure Active Directory"
        application_resource_access = [
          "Directory.Read.All",
          "Policy.Read.All",
        ]
        delegated_resource_access = [
          "Directory.Read.All",
        ]
      },
    ]
  },
]
```

## Providers

The following providers are used by this module:

- <a name="provider_azuread"></a> [azuread](#provider_azuread) (=2.18.0)

- <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) (=2.98.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azuread_application.module](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/resources/application) (resource)
- [azuread_application_password.module](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/resources/application_password) (resource)
- [azuread_service_principal.module](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/resources/service_principal) (resource)
- [azurerm_role_assignment.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/role_assignment) (resource)
- [azuread_service_principal.module](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/data-sources/service_principal) (data source)
- [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/data-sources/subscription) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_resource_prefix"></a> [resource_prefix](#input_resource_prefix)

Description: (Required) Prefix given to all resources within the module.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_service_principals"></a> [service_principals](#input_service_principals)

Description: List of API permissions to apply to the Service Principal

Type:

```hcl
list(object({
    name_suffix = string
    required_resource_access = list(object({
      application_display_name    = string
      application_resource_access = list(string)
      delegated_resource_access   = list(string)
    }))
    role_assignments = list(object({
      scope                = string
      role_definition_name = string
    }))
  }))
```

Default: `[]`

## Outputs

The following outputs are exported:

### <a name="output_service_principals"></a> [service_principals](#output_service_principals)

Description: Service Principal details; display_name, application_id, object_id, secret, secret_key_id
