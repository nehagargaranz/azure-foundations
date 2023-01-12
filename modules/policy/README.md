# Policy Module

This module deploys Custom Azure Policy Definitions if specified, then creates a Policy Set which is assigned to relevant management groups.

Azure Policy takes a policy describing the required (or prohibited) properties of resources, and automatically takes action such as:
- remediate the breach of policy by deploying additional resources ("DeployIfNotExists");
- prevent the non-compliant resource from being deployed ("Deny"); or
- record the breach of policy in a log ("Audit").

The `policy` module itself reads its input variables (specified in `module.yaml`) and creates "policy definition" and "policy assignment" resources accordingly.

Note that it is not possible to specify policy for a specific region. The "scope" of the policy must be a management group.

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) (=2.98.0)

- <a name="provider_random"></a> [random](#provider_random) (=3.1.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_management_group_policy_assignment.policy_assignments](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/management_group_policy_assignment) (resource)
- [azurerm_management_group_policy_assignment.policy_definitions](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/management_group_policy_assignment) (resource)
- [azurerm_management_group_policy_assignment.policy_set](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/management_group_policy_assignment) (resource)
- [azurerm_policy_definition.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/policy_definition) (resource)
- [random_id.policy_assignments](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/id) (resource)
- [random_id.policy_definitions](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/id) (resource)
- [random_id.policy_set](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/id) (resource)
- [random_uuid.policy_definition](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/uuid) (resource)
- [azurerm_policy_definition.policy_assignments](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/data-sources/policy_definition) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input_location)

Description: (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.

Type: `string`

### <a name="input_management_group_id"></a> [management_group_id](#input_management_group_id)

Description: The Management Group ID that the policy will be assigned to.

Type: `string`

### <a name="input_resource_prefix"></a> [resource_prefix](#input_resource_prefix)

Description: (Required) Prefix given to all resources within the module.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_management_group_name"></a> [management_group_name](#input_management_group_name)

Description: The name of the Parent Management Group; Default of 'null' for top level Management Group

Type: `string`

Default: `null`

### <a name="input_policy_assignments"></a> [policy_assignments](#input_policy_assignments)

Description: A list of policy definitions with specific format; https://www.terraform.io/docs/providers/azurerm/r/policy_set_definition.html#policy_definitions

Type: `any`

Default: `[]`

### <a name="input_policy_definitions"></a> [policy_definitions](#input_policy_definitions)

Description: A list of policy definition arguments including name, display_name, description, policy_rule, metadata and parameters; https://www.terraform.io/docs/providers/azurerm/r/policy_definition.html

Type: `any`

Default: `{}`

### <a name="input_policy_set_assignments"></a> [policy_set_assignments](#input_policy_set_assignments)

Description: A list of policy set definitions with specific format; https://www.terraform.io/docs/providers/azurerm/r/policy_set_definition.html#policy_definitions. json_parameters must be in JSON formatting

Type:

```hcl
list(object({
    name            = string
    id              = string
    json_parameters = string
  }))
```

Default: `[]`

## Outputs

No outputs.
