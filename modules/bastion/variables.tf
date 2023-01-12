variable "resource_prefix" {
  type        = string
  description = "(Required) Prefix given to all resources within the module."
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Set of base tags that will be associated with each supported resource."
}

variable "compliance_storage" {
  type = object({
    storage_accounts                  = any
    storage_account_retention_in_days = number
    log_analytics_workspaces          = any
    log_analytics_retention_in_days   = number
  })
  description = "(Required) Map of storage_account_id and log_analytics_workspace_resource_id used for diagnostic setting"
}

variable "resource_group_lock" {
  type        = bool
  default     = true
  description = "Lock the modules Resource Group with a CanNotDelete Management Lock"
}

variable "bastion_subnet_id" {
  type        = string
  description = "(Required) Subnet ID to deploy the Bastion Host"
}

variable "company_prefix" {
  type        = string
  description = "(Required) Prefix given to all globally unique names"
}
