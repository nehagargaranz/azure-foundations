variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Set of base tags that will be associated with each supported resource."
}

variable "vpns" {
  type = list(object({
    name                               = string
    gateway_address                    = string
    remote_address_spaces              = list(string)
    local_address_spaces               = list(string)
    dh_group                           = string
    ike_version                        = string
    ike_encryption                     = string
    ike_integrity                      = string
    ipsec_encryption                   = string
    ipsec_integrity                    = string
    pfs_group                          = string
    use_policy_based_traffic_selectors = bool
    routing_weight                     = number
    sa_lifetime                        = string
  }))
  default     = []
  description = "List of VPNs and their configuration"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Name of the Resource Group to deploy resources to"
}

variable "virtual_network_gateway_id" {
  type        = string
  description = "(Required) The ID of the Virtual Network Gateway in which the connection will be created"
}
