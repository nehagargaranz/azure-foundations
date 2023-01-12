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

variable "create_resource_group" {
  type        = bool
  default     = true
  description = "Create a resource group within this module"
}

variable "resource_group_name" {
  type        = string
  default     = ""
  description = "Resource Group to deploy resources to; Used if create_resource_group is false."
}

variable "routes" {
  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = string
  }))
  default = [
    {
      name                   = "Internet"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "Internet"
      next_hop_in_ip_address = ""
    }
  ]
  description = "List of objects representing routes"
}

variable "disable_bgp_route_propagation" {
  type        = bool
  default     = false
  description = "Boolean flag which controls propagation of routes learned by BGP on that route table. True means disable."
}

variable "subnets" {
  type        = list(string)
  description = "(Required) List of Subnet Resource IDs to associate the route table"
}
