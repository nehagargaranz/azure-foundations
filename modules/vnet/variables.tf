variable "company_prefix" {
  type        = string
  description = "(Required) Prefix given to all globally unique names"
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

variable "vnet_address_space" {
  type        = string
  description = "IP networking range that will be used for the VNet in CIDR notation."
}

variable "ddos_standard" {
  type        = bool
  default     = false
  description = "Create a DDoS Standard plan and assign the VNet to it if set to true."
}

variable "dns_servers" {
  type        = list(string)
  default     = ["168.63.129.16"] # Azure DNS for external resolution.
  description = "List of DNS server IPs that will be associated with the VNet"
}

variable "subnets" {
  type = list(object({
    name    = string
    newbits = number
    netnum  = number
    service_delegation = list(object({
      service = string
      actions = list(string)
    }))
    service_endpoints    = list(string)
    privatelink_service  = bool
    privatelink_endpoint = bool
  }))
  description = "(Required) List of Subnet Objects to create"
}

variable "network_security_rules" {
  type = list(object({
    subnet_name                = string
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default     = []
  description = "List of Network Security Rules to create"
}

variable "skip_network_security_groups" {
  type        = list(string)
  default     = []
  description = "List of Subnet names to skip Network Security Group creation and association"
}

variable "network_watcher_name" {
  type        = string
  description = "(Required) Name of the Network Watcher"
}

variable "network_watcher_resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group that the Network Watcher was deployed"
}
