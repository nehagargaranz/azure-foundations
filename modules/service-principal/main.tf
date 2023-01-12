/*
 * # Service Principal module
 *
 * This module creates a Service Principals and assigns API permissions to the associated Application Registration.
 *
 * Permissions can be supplied using their API names, GUIDs will be derived automatically. The module will fail if a permission or API name can't be found.
 *
 * ```
 * service_principals = [
 *   {
 *     name_suffix = "foo"
 *     required_resource_access = [
 *       {
 *         application_display_name = "Windows Azure Active Directory"
 *         application_resource_access = [
 *           "Directory.Read.All",
 *           "Policy.Read.All",
 *         ]
 *         delegated_resource_access = [
 *           "Directory.Read.All",
 *           "User.Read",
 *         ]
 *       },
 *       {
 *         application_display_name = "Microsoft Graph"
 *         application_resource_access = [
 *           "Team.ReadBasic.All",
 *         ]
 *         delegated_resource_access = [
 *           "AuditLog.Read.All",
 *         ]
 *       },
 *     ]
 *   },
 *   {
 *     name_suffix = "bar"
 *     required_resource_access = [
 *       {
 *         application_display_name = "Windows Azure Active Directory"
 *         application_resource_access = [
 *           "Directory.Read.All",
 *           "Policy.Read.All",
 *         ]
 *         delegated_resource_access = [
 *           "Directory.Read.All",
 *         ]
 *       },
 *     ]
 *   },
 * ]
 * ```
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
  service_principals = {
    for sp in var.service_principals : sp.name_suffix => sp
  }
  service_principal_role_assignments = {
    for entry in flatten([
      for sp in var.service_principals : [
        for ra in sp.role_assignments : {
          name_suffix          = sp.name_suffix
          scope                = ra.scope
          role_definition_name = ra.role_definition_name
        }
      ]
    ]) : "${entry.name_suffix}-${entry.scope}-${entry.role_definition_name}" => entry
  }
  applications = toset(distinct(flatten([
    for sp in local.service_principals : [
      for ra in sp.required_resource_access : ra.application_display_name
    ]
  ])))
}

data "azurerm_subscription" "current" {}

provider "azuread" {
  tenant_id = data.azurerm_subscription.current.tenant_id
}

data "azuread_service_principal" "module" {
  for_each     = local.applications
  display_name = each.value
}

resource "azuread_application" "module" {
  for_each = local.service_principals

  display_name = "${var.resource_prefix}-${each.key}"

  dynamic "required_resource_access" {
    for_each = { for ra in each.value.required_resource_access : ra.application_display_name => ra }

    content {
      resource_app_id = data.azuread_service_principal.module[required_resource_access.key].application_id

      dynamic "resource_access" {
        for_each = required_resource_access.value.application_resource_access

        content {
          id   = element([for role in data.azuread_service_principal.module[required_resource_access.key].app_roles : role.id if role.value == resource_access.value], 0)
          type = "Role"
        }
      }

      dynamic "resource_access" {
        for_each = required_resource_access.value.delegated_resource_access

        content {
          id   = element([for role in data.azuread_service_principal.module[required_resource_access.key].oauth2_permission_scopes : role.id if role.value == resource_access.value], 0)
          type = "Scope"
        }
      }
    }
  }
}

resource "azuread_service_principal" "module" {
  for_each = local.service_principals

  application_id               = azuread_application.module[each.key].application_id
  app_role_assignment_required = false
}

resource "azuread_application_password" "module" {
  for_each = local.service_principals

  application_object_id = azuread_application.module[each.key].object_id
  end_date_relative     = "8760h" # credential expires in 1 year
}

resource "azurerm_role_assignment" "module" {
  for_each = local.service_principal_role_assignments

  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = azuread_service_principal.module[each.value.name_suffix].object_id
}
