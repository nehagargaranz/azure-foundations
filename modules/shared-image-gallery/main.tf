/*
 * # Shared Image Gallery Module
 *
 * This module deploys an Azure Shared Image Gallery and Shared Image definitions when provided with a list of custom images.
 *
 * The module does not manage or deploy custom image versions. These are intended to be managed by the SOE Image Factory.
 */
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.98.0"
    }
  }
}

locals {
  tags = merge(var.tags, local.module_tags)
  module_tags = {
    "Module" = basename(abspath(path.module))
  }
  name = var.name != "" ? var.name : join("", [var.company_prefix, var.environment, var.location_abbreviations[var.location], "sig"])
  images = {
    for image in var.images : image.image_name => image
  }
}

resource "azurerm_resource_group" "module" {
  name = "${var.resource_prefix}-rg"

  location = var.location
  tags     = local.tags
}

resource "azurerm_shared_image_gallery" "module" {
  name = local.name

  resource_group_name = azurerm_resource_group.module.name
  location            = azurerm_resource_group.module.location
  description         = "Shared Image Gallery"
  tags                = local.tags
}

resource "azurerm_shared_image" "module" {
  for_each = local.images

  name                = each.value.image_name
  gallery_name        = azurerm_shared_image_gallery.module.name
  resource_group_name = azurerm_resource_group.module.name
  location            = azurerm_resource_group.module.location
  os_type             = each.value.os_type
  hyper_v_generation  = each.value.hyper_v_generation

  identifier {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
  }
}
