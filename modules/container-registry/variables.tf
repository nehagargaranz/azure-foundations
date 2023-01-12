variable "name" {
  type        = string
  default     = ""
  description = "Overrides the name of the Container Registry; defaults to [company_prefix][environment][location_abbreviation]"
}

variable "environment" {
  type        = string
  description = "(Required) Environment name"
}

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

variable "location_abbreviations" {
  type        = map(string)
  description = "(Required) A map of Azure location names to abbreviations which can be used in (e.g.) storage account names."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Set of base tags that will be associated with each supported resource."
}

variable "georeplications" {
  type        = list(string)
  default     = []
  description = "(Required) Location for the registry replica, using the region's short name. It must be different from the home registry location."
}

variable "sku" {
  type        = string
  default     = "Basic"
  description = "The SKU name of the container registry. Possible values are Basic, Standard and Premium"
}

variable "allowed_subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of subnet ids from which be allowed"
}

variable "allowed_ip_ranges" {
  type        = list(string)
  default     = []
  description = "List of CIDR blocks from which be allowed"
}
