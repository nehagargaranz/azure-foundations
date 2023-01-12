/*
 * # Management Group Module
 *
 * This module creates a Management Group, and moves an existing Azure subscription to be it's child.
 *
 * Optionally the Management Group can created under the "Tenant Root Group" without a child subscription by setting `management_group_root = true`, or it can be a child of an existing Management Group and contain a subscription.
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

resource "azurerm_management_group" "module" {
  display_name               = "${var.environment}-mg"
  parent_management_group_id = var.management_group_parent_id
}

data "azurerm_subscription" "module" {
  for_each = var.subscription_ids

  subscription_id = each.value
}

resource "azurerm_management_group_subscription_association" "module" {
  for_each = var.subscription_ids

  management_group_id = azurerm_management_group.module.id
  subscription_id     = data.azurerm_subscription.module[each.value].id
}
