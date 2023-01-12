variable "resource_prefix" {
  type        = string
  description = "(Required) Prefix given to all resources within the module."
}

variable "environment" {
  type        = string
  description = "(Required) Environment name"
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "location_abbreviations" {
  type        = map(string)
  description = "(Required) A map of Azure location names to abbreviations which can be used in (e.g.) storage account names."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Set of base tags that will be associated with each supported resource."
}

variable "resource_group_lock" {
  type        = bool
  default     = true
  description = "Lock the modules Resource Group with a CanNotDelete Management Lock"
}

variable "function_app_identity" {
  type        = string
  description = "(Required) Function App Identity [Principal ID]"
}

variable "function_id" {
  type        = string
  description = "(Required) Function App ID"
  default     = null # TODO
}
