variable "resource_prefix" {
  type        = string
  description = "(Required) Prefix given to all resources within the module."
}

variable "service_principals" {
  type = list(object({
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
  default     = []
  description = "List of API permissions to apply to the Service Principal"
}
