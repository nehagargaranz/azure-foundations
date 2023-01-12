variable "company_prefix" {
  type        = string
  description = "(Required) Prefix given to all globally unique names"
}

variable "resource_ids" {
  type        = list(string)
  description = "List of Resource IDs to associate diagnostic setting"
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

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resources exist, to allow things like diagnostics storage to be co-located."
}

variable "enable_metrics" {
  type        = bool
  default     = true
  description = "Enable Metrics collection"
}

variable "enable_logs" {
  type        = bool
  default     = true
  description = "Enable Logs collection"
}
