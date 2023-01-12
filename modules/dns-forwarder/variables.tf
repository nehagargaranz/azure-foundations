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

variable "dns_forwarder_subnet_id" {
  type        = string
  description = "(Required) Subnet ID to deploy the Bastion Host"
}

variable "dns_forwarder_ip_address" {
  type        = string
  description = "IP Address of the DNS Forwarder"
}

variable "dns_forwarder_ssh_username" {
  type        = string
  default     = "adminuser"
  description = "Username for remote SSH access"
}

variable "dns_forwarder_ssh_public_keys" {
  type        = set(string)
  default     = []
  description = "Public keys for remote SSH access"
}

variable "dns_forwarder_servers" {
  type        = list(map(string))
  default     = []
  description = "List of maps with `domain` and `address` to configure conditional forwarding in dnsmasq. E.G. [{ domain = 'google.com', address = '8.8.8.8' }]"
}
