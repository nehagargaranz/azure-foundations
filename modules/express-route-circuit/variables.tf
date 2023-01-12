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
  description = "(Required) Map of compliance storage settings"
}

variable "service_provider_name" {
  type        = string
  description = "(Required) The name of the ExpressRoute Service provider"
}

variable "peering_location" {
  type        = string
  description = "(Required) The name of the peering location and not the Azure resource location"
}

variable "bandwidth_in_mbps" {
  type        = string
  description = "(Required) The bandwidth in Mbps of the circuit being created"
}

variable "sku_tier" {
  type        = string
  description = "(Required) The ExpressRoute service tier. Possible values are Basic, Local, Standard or Premium"
}

variable "sku_family" {
  type        = string
  description = "(Required) The billing mode for ExpressRoute bandwidth. Possible values are MeteredData or UnlimitedData"
}

variable "enable_private_peering" {
  type        = bool
  default     = false
  description = "Whether to enable Azure Private Peering with the ExpressRoute Circuit"
}

variable "private_peering_primary_address_prefix" {
  type        = string
  default     = null
  description = "A /30 subnet for the primary link of Azure Private Peering, required when `enable_private_peering` is `true`"
}

variable "private_peering_secondary_address_prefix" {
  type        = string
  default     = null
  description = "A /30 subnet for the secondary link of Azure Private Peering, required when `enable_private_peering` is `true`"
}

variable "private_peering_vlan_id" {
  type        = string
  default     = null
  description = "A valid VLAN ID to establish Azure Private Peering on, required when `enable_private_peering` is `true`"
}

variable "private_peering_asn" {
  type        = number
  default     = null
  description = "A 16-bit or a 32-bit ASN for Azure Private Peering"
}

variable "enable_microsoft_peering" {
  type        = bool
  default     = false
  description = "Whether to enable Microsoft Peering with the ExpressRoute Circuit"
}

variable "microsoft_peering_primary_address_prefix" {
  type        = string
  default     = null
  description = "A /30 subnet for the primary link of Microsoft Peering, required when `enable_microsoft_peering` is `true`"
}

variable "microsoft_peering_secondary_address_prefix" {
  type        = string
  default     = null
  description = "A /30 subnet for the secondary link of Microsoft Peering, required when `enable_microsoft_peering` is `true`"
}

variable "microsoft_peering_vlan_id" {
  type        = string
  default     = null
  description = "A valid VLAN ID to establish Microsoft Peering on, required when `enable_microsoft_peering` is `true`"
}

variable "microsoft_peering_asn" {
  type        = number
  default     = null
  description = "A 16-bit or a 32-bit ASN for Microsoft Peering"
}

variable "advertised_public_prefixes" {
  type        = list(string)
  default     = []
  description = "A list of public prefixes to advertise over the BGP session, required when `enable_microsoft_peering` is `true`"
}

variable "microsoft_peering_route_filter_communities" {
  type        = list(string)
  default     = []
  description = "List of communities for route filter rule"
}

variable "microsoft_peering_customer_asn" {
  type        = number
  default     = null
  description = "The CustomerASN of the peering"
}

variable "microsoft_peering_routing_registry_name" {
  type        = string
  default     = null
  description = "The RoutingRegistryName of the configuration"
}

variable "connected_vnets" {
  type = map(object({
    vnet_name       = string
    vnet_gateway_id = string
    routing_weight  = number
  }))
  description = "(Required) One or more virtual networks that the ExpressRoute should connect to"
}
