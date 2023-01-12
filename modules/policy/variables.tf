variable "resource_prefix" {
  type        = string
  description = "(Required) Prefix given to all resources within the module."
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "management_group_id" {
  type        = string
  description = "The Management Group ID that the policy will be assigned to."
}

variable "management_group_name" {
  type        = string
  default     = null
  description = "The name of the Parent Management Group; Default of 'null' for top level Management Group"
}

variable "policy_assignments" {
  type        = any
  description = "A list of policy definitions with specific format; https://www.terraform.io/docs/providers/azurerm/r/policy_set_definition.html#policy_definitions"
  default     = []
}

variable "policy_set_assignments" {
  type = list(object({
    name            = string
    id              = string
    json_parameters = string
  }))
  description = "A list of policy set definitions with specific format; https://www.terraform.io/docs/providers/azurerm/r/policy_set_definition.html#policy_definitions. json_parameters must be in JSON formatting"
  default     = []
}

variable "policy_definitions" {
  type        = any
  description = "A list of policy definition arguments including name, display_name, description, policy_rule, metadata and parameters; https://www.terraform.io/docs/providers/azurerm/r/policy_definition.html"
  default     = {}
}
