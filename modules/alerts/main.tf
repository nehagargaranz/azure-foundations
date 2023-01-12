/*
 * # Service Health Alerts Module
 *
 * This module creates an Activity Log Alert for Azure Service Health events and sends those events to an email address.
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
}

data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "module" {
  name = "${var.resource_prefix}-rg"

  location = var.location
  tags     = local.tags
}

resource "azurerm_management_lock" "module" {
  count = var.resource_group_lock ? 1 : 0

  name       = "resource-group-lock"
  scope      = azurerm_resource_group.module.id
  lock_level = "CanNotDelete"
}

# Service Health
resource "azurerm_monitor_action_group" "service_health" {
  name                = "${var.resource_prefix}-service-health"
  resource_group_name = azurerm_resource_group.module.name
  short_name          = "healthalerts"

  email_receiver {
    name                    = "service-health"
    email_address           = var.service_health_alerts_email
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_activity_log_alert" "service_health" {
  name                = "${var.resource_prefix}-service-health"
  resource_group_name = azurerm_resource_group.module.name
  scopes              = [data.azurerm_subscription.current.id]
  description         = "Monitor Service Health"

  criteria {
    category = "ServiceHealth"
    level    = "Warning"
  }

  action {
    action_group_id = azurerm_monitor_action_group.service_health.id
  }
}

# Security
resource "azurerm_monitor_action_group" "security" {
  name                = "${var.resource_prefix}-security"
  resource_group_name = azurerm_resource_group.module.name
  short_name          = "healthalerts"

  email_receiver {
    name                    = "security"
    email_address           = var.security_center_contact_email
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_activity_log_alert" "create_update_policy_assignments" {
  name                = "${var.resource_prefix}-create-policy-assignment"
  resource_group_name = azurerm_resource_group.module.name
  scopes              = [data.azurerm_subscription.current.id]
  description         = "Monitor Create or Update Azure Policy Assignment events"

  criteria {
    category       = "Policy"
    operation_name = "Microsoft.Authorization/policyAssignments/write"
  }

  action {
    action_group_id = azurerm_monitor_action_group.security.id
  }
}

resource "azurerm_monitor_activity_log_alert" "create_update_network_security_groups" {
  name                = "${var.resource_prefix}-create-update-network-security-groups"
  resource_group_name = azurerm_resource_group.module.name
  scopes              = [data.azurerm_subscription.current.id]
  description         = "Monitor Create or Update Network Security Group events"

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Network/networkSecurityGroups/write"
  }

  action {
    action_group_id = azurerm_monitor_action_group.security.id
  }
}

resource "azurerm_monitor_activity_log_alert" "delete_network_security_groups" {
  name                = "${var.resource_prefix}-delete-network-security-groups"
  resource_group_name = azurerm_resource_group.module.name
  scopes              = [data.azurerm_subscription.current.id]
  description         = "Monitor Delete Network Security Group events"

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Network/networkSecurityGroups/delete"
  }

  action {
    action_group_id = azurerm_monitor_action_group.security.id
  }
}

resource "azurerm_monitor_activity_log_alert" "create_update_network_security_group_rules" {
  name                = "${var.resource_prefix}-create-update-network-security-group-rules"
  resource_group_name = azurerm_resource_group.module.name
  scopes              = [data.azurerm_subscription.current.id]
  description         = "Monitor Create or Update Network Security Group Rule events"

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Network/networkSecurityGroups/securityRules/write"
  }

  action {
    action_group_id = azurerm_monitor_action_group.security.id
  }
}

resource "azurerm_monitor_activity_log_alert" "delete_network_security_group_rules" {
  name                = "${var.resource_prefix}-delete-network-security-group-rules"
  resource_group_name = azurerm_resource_group.module.name
  scopes              = [data.azurerm_subscription.current.id]
  description         = "Monitor Delete Network Security Group Rule events"

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Network/networkSecurityGroups/securityRules/delete"
  }

  action {
    action_group_id = azurerm_monitor_action_group.security.id
  }
}

resource "azurerm_monitor_activity_log_alert" "create_update_security_solutions" {
  name                = "${var.resource_prefix}-create-update-security-solutions"
  resource_group_name = azurerm_resource_group.module.name
  scopes              = [data.azurerm_subscription.current.id]
  description         = "Monitor Create or Update Security Solution events"

  criteria {
    category       = "Security"
    operation_name = "Microsoft.Security/securitySolutions/write"
  }

  action {
    action_group_id = azurerm_monitor_action_group.security.id
  }
}

resource "azurerm_monitor_activity_log_alert" "delete_security_solutions" {
  name                = "${var.resource_prefix}-delete-security-solutions"
  resource_group_name = azurerm_resource_group.module.name
  scopes              = [data.azurerm_subscription.current.id]
  description         = "Monitor Delete Security Solution events"

  criteria {
    category       = "Security"
    operation_name = "Microsoft.Security/securitySolutions/delete"
  }

  action {
    action_group_id = azurerm_monitor_action_group.security.id
  }
}

resource "azurerm_monitor_activity_log_alert" "create_update_sql_server_firewall_rule" {
  name                = "${var.resource_prefix}-create-update-sql-server-firewall-rule"
  resource_group_name = azurerm_resource_group.module.name
  scopes              = [data.azurerm_subscription.current.id]
  description         = "Monitor Create or Update SQL Server Firewall Rule events"

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Sql/servers/firewallRules/write"
  }

  action {
    action_group_id = azurerm_monitor_action_group.security.id
  }
}

resource "azurerm_monitor_activity_log_alert" "delete_sql_server_firewall_rule" {
  name                = "${var.resource_prefix}-delete-sql-server-firewall-rule"
  resource_group_name = azurerm_resource_group.module.name
  scopes              = [data.azurerm_subscription.current.id]
  description         = "Monitor Delete SQL Server Firewall Rule events"

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Sql/servers/firewallRules/delete"
  }

  action {
    action_group_id = azurerm_monitor_action_group.security.id
  }
}

resource "azurerm_monitor_activity_log_alert" "create_update_security_policy" {
  name                = "${var.resource_prefix}-create-update-security-policy"
  resource_group_name = azurerm_resource_group.module.name
  scopes              = [data.azurerm_subscription.current.id]
  description         = "Monitor Create or Update Security Policy events"

  criteria {
    category       = "Security"
    operation_name = "Microsoft.Security/policies/write"
  }

  action {
    action_group_id = azurerm_monitor_action_group.security.id
  }
}
