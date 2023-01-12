variable "company_prefix" {
  type        = string
  description = "(Required) Prefix given to all globally unique names"
}

variable "resource_prefix" {
  type        = string
  description = "(Required) Prefix given to all resources within the module."
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
  description = "Map of compliance storage settings"
}

variable "vm_management" {
  type = object({
    storage_account         = any
    log_analytics_workspace = any
  })
  description = "(Required) Map of storage_account and log_analytics_workspace used for VM management."
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
  description = "(Required) Specifies locations where configuration is required."
}

variable "security_center_contact_email" {
  type        = string
  description = "(Required) The email of the Security Center Contact"
}

variable "security_center_contact_phone" {
  type        = string
  description = "The phone number of the Security Center Contact"
}

variable "alert_notifications" {
  type        = bool
  default     = true
  description = "Whether to send security alerts notifications to the security contact"
}

variable "alerts_to_admins" {
  type        = bool
  default     = true
  description = "Whether to send security alerts notifications to subscription admins"
}

variable "security_center_pricing_tiers" {
  type        = map(string)
  description = "(Required) Resource type(s) to be enabled with specified pricing tier for Security Center protection"
}

variable "location_abbreviations" {
  type        = map(string)
  description = "(Required) A map of Azure location names to abbreviations which can be used in (e.g.) storage account names."
}

variable "security_center_autoprovision_vm_agent" {
  type        = bool
  default     = true
  description = "Enable Azure Secuirty Center auto-provisioning of Azure Monitor Agent on VMs"
}
