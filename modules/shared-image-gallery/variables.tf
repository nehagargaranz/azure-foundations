variable "name" {
  type        = string
  default     = ""
  description = "Overrides the name of the Shared Image Gallery; defaults to [company_prefix][environment][location_abbreviation]sig"
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

variable "images" {
  type = list(object({
    image_name         = string
    os_type            = string
    hyper_v_generation = string
    publisher          = string
    offer              = string
    sku                = string
  }))
  description = "(Required) List of Shared Images to create"
}
