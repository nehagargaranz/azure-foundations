variable "scope" {
  type        = string
  description = "(Required) Scope for role assignments"
}

variable "role_assignment_groups" {
  type = list(object({
    group_name           = string
    role_definition_name = string
  }))
  default     = []
  description = "List of Group Role Assignment objects"
}

variable "role_assignment_users" {
  type = list(object({
    user_principal_name  = string
    role_definition_name = string
  }))
  default     = []
  description = "List of User Role Assignment objects"
}

variable "role_assignment_service_principals" {
  type = list(object({
    service_principal_name = string
    role_definition_name   = string
  }))
  default     = []
  description = "List of Service Principal Role Assignment objects"
}
