variable "company_prefix" {
  type        = string
  description = "(Required) Prefix given to all globally unique names"
}

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

variable "subnet_id" {
  type        = string
  description = "(Required) Subnet ID of the GatewaySubnet"
}

variable "gateway_sku" {
  type        = string
  default     = "Basic"
  description = "Configuration of the size and capacity of the virtual network gateway"
}

variable "gateway_type" {
  type        = string
  default     = "Vpn"
  description = "The type of the Virtual Network Gateway. Valid options are Vpn or ExpressRoute."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Name of the Resource Group to deploy resources to"
}
