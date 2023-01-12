/*
 * # Policy Module
 *
 * This module deploys Custom Azure Policy Definitions if specified, then creates a Policy Set which is assigned to relevant management groups.
 *
 * Azure Policy takes a policy describing the required (or prohibited) properties of resources, and automatically takes action such as:
 * - remediate the breach of policy by deploying additional resources ("DeployIfNotExists");
 * - prevent the non-compliant resource from being deployed ("Deny"); or
 * - record the breach of policy in a log ("Audit").
 *
 * The `policy` module itself reads its input variables (specified in `module.yaml`) and creates "policy definition" and "policy assignment" resources accordingly.
 *
 * Note that it is not possible to specify policy for a specific region. The "scope" of the policy must be a management group.
 */
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.98.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.1.0"
    }
  }
}

locals {
  policy_assignments     = { for policy in var.policy_assignments : policy.name => policy }
  policy_set_assignments = { for set in var.policy_set_assignments : set.id => set }
}

resource "random_uuid" "policy_definition" {
  for_each = var.policy_definitions
}

resource "azurerm_policy_definition" "module" {
  for_each = var.policy_definitions

  name                = random_uuid.policy_definition[each.key].result
  management_group_id = var.management_group_name
  policy_type         = "Custom"
  mode                = each.value.mode
  display_name        = "${var.resource_prefix} ${each.value.display_name}"
  description         = "${var.resource_prefix} ${each.value.description}"
  metadata            = jsonencode(each.value.metadata)
  policy_rule         = jsonencode(each.value.policy_rule)

  lifecycle {
    ignore_changes = [
      metadata
    ]
  }
}

data "azurerm_policy_definition" "policy_assignments" {
  for_each = local.policy_assignments

  name = each.value.name
}

resource "random_id" "policy_assignments" {
  for_each = local.policy_assignments

  byte_length = 12
}

resource "azurerm_management_group_policy_assignment" "policy_assignments" {
  for_each = local.policy_assignments

  name                 = random_id.policy_assignments[each.key].hex
  display_name         = data.azurerm_policy_definition.policy_assignments[each.key].display_name
  description          = data.azurerm_policy_definition.policy_assignments[each.key].description
  location             = var.location
  management_group_id  = var.management_group_id
  policy_definition_id = data.azurerm_policy_definition.policy_assignments[each.key].id
  parameters           = try(jsonencode(each.value.parameters), null)

  identity {
    type = "SystemAssigned"
  }
}

resource "random_id" "policy_definitions" {
  for_each = azurerm_policy_definition.module

  byte_length = 12
}

resource "azurerm_management_group_policy_assignment" "policy_definitions" {
  for_each = azurerm_policy_definition.module

  name                 = random_id.policy_definitions[each.key].hex
  display_name         = each.value.display_name
  description          = each.value.description
  location             = var.location
  management_group_id  = var.management_group_id
  policy_definition_id = each.value.id

  identity {
    type = "SystemAssigned"
  }
}

resource "random_id" "policy_set" {
  for_each    = local.policy_set_assignments
  byte_length = 12
}

resource "azurerm_management_group_policy_assignment" "policy_set" {
  for_each = local.policy_set_assignments

  name                 = random_id.policy_set[each.key].hex
  display_name         = each.value.name
  description          = each.value.name
  location             = var.location
  management_group_id  = var.management_group_id
  policy_definition_id = each.value.id
  parameters           = each.value.json_parameters

  identity {
    type = "SystemAssigned"
  }
}
