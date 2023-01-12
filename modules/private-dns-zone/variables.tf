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

variable "virtual_network_links" {
  type = map(object({
    virtual_network_name = string
    virtual_network_id   = string
    registration_enabled = bool
  }))
  description = "(Required) Map of Virtual Network Objects to link"
}

variable "private_dns_zone_prefix" {
  type        = string
  description = "(Required) Prefix of the Private DNS Zone name"
}

variable "private_dns_zone_suffix" {
  type        = string
  description = "(Required) Suffix of the Private DNS Zone name"
}

variable "resource_group_lock" {
  type        = bool
  default     = true
  description = "Lock the modules Resource Group with a CanNotDelete Management Lock"
}
