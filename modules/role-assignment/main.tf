/*
 * # Role assignments module
 *
 * This module assigns roles in the specified scope (e.g. a subscription) to the specified users, groups or service principals.
 *
 * For each user or group, a role must be specified.
 */
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.98.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.18.0"
    }
  }
}

locals {
  role_assignment_users = {
    for s in var.role_assignment_users : "${s.user_principal_name}-${s.role_definition_name}" => s
  }
  role_assignment_groups = {
    for s in var.role_assignment_groups : "${s.group_name}-${s.role_definition_name}" => s
  }
  role_assignment_service_principals = {
    for s in var.role_assignment_service_principals : "${s.service_principal_name}-${s.role_definition_name}" => s
  }
}

data "azurerm_subscription" "current" {}

provider "azuread" {
  tenant_id = data.azurerm_subscription.current.tenant_id
}

data "azuread_group" "module" {
  for_each = local.role_assignment_groups

  display_name = each.value.group_name
}

resource "azurerm_role_assignment" "group" {
  for_each = local.role_assignment_groups

  scope                = var.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = data.azuread_group.module[each.key].id
}

data "azuread_user" "module" {
  for_each = local.role_assignment_users

  user_principal_name = each.value.user_principal_name
}

resource "azurerm_role_assignment" "user" {
  for_each = local.role_assignment_users

  scope                = var.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = data.azuread_user.module[each.key].id
}

data "azuread_service_principal" "module" {
  for_each = local.role_assignment_service_principals

  display_name = each.value.service_principal_name
}

resource "azurerm_role_assignment" "service_principal" {
  for_each = local.role_assignment_service_principals

  scope                = var.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = data.azuread_service_principal.module[each.key].object_id
}
