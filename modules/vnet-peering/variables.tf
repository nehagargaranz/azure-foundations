variable "resource_prefix" {
  type        = string
  description = "(Required) Prefix given to all resources within the module."
}

variable "hub_virtual_network_id" {
  type        = string
  description = "(Required) The Resource ID of the remote VNet"
}

variable "hub_virtual_network_name" {
  type        = string
  description = "(Required) The Resource ID of the remote VNet"
}

variable "hub_virtual_network_resource_group_name" {
  type        = string
  description = "(Required) The resource group of the remote VNet"
}

variable "hub_subscription_id" {
  type        = string
  description = "(Required) The subscription ID of the remote VNet"
}

variable "spoke_virtual_network_id" {
  type        = string
  description = "(Required) The Resource ID of the local VNet"
}

variable "spoke_virtual_network_name" {
  type        = string
  description = "(Required) The name of the local VNet"
}

variable "spoke_virtual_network_resource_group_name" {
  type        = string
  description = "(Required) The resource group of the local VNet"
}

variable "spoke_allow_virtual_network_access" {
  type        = bool
  default     = null
  description = "Controls if the VMs in the remote virtual network can access VMs in the local virtual network"
}

variable "spoke_allow_forwarded_traffic" {
  type        = bool
  default     = null
  description = "Controls if forwarded traffic from VMs in the remote virtual network is allowed"
}

variable "spoke_allow_gateway_transit" {
  type        = bool
  default     = null
  description = "Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network"
}

variable "spoke_use_remote_gateways" {
  type        = bool
  default     = null
  description = "Controls if remote gateways can be used on the local virtual network"
}

variable "hub_allow_virtual_network_access" {
  type        = bool
  default     = null
  description = "Controls if the VMs in the remote virtual network can access VMs in the local virtual network"
}

variable "hub_allow_forwarded_traffic" {
  type        = bool
  default     = null
  description = "Controls if forwarded traffic from VMs in the remote virtual network is allowed"
}

variable "hub_allow_gateway_transit" {
  type        = bool
  default     = null
  description = "Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network"
}

variable "hub_use_remote_gateways" {
  type        = bool
  default     = null
  description = "Controls if remote gateways can be used on the local virtual network"
}
