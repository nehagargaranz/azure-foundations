variable "company_prefix" {
  type        = string
  description = "(Required) Prefix given to all globally unique names"
}

variable "environment" {
  type        = string
  description = "(Required) Environment name"
}

variable "resource_prefix" {
  type        = string
  description = "(Required) Prefix given to all resources within the module."
}

variable "resource_group_lock" {
  type        = bool
  default     = true
  description = "Lock the modules Resource Group with a CanNotDelete Management Lock"
}

variable "location" {
  type        = string
  description = "(Required) Specifies the primary or default Azure location; if a resource only needs to be deployed once regardless of the number of regions in use, the resource will be deployed to this location. See also `compliance_locations`."
}

variable "compliance_locations" {
  type        = set(string)
  description = "(Required) Specifies locations where storage is required."
}

variable "vm_management_location" {
  type        = string
  description = "(Required) Specifies location where Log Analytics and Update Management are deployed."
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

variable "retention_in_days" {
  type        = string
  default     = "90"
  description = "The number of days to retain logs within the workspace."
}

variable "soft_delete_retention_period" {
  type        = number
  default     = 90
  description = "The number of days to retain blobs for soft deletion"
}
