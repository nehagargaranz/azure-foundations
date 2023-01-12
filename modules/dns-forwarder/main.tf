/*
 * # DNS Forwarder Module
 *
 * This module deploys a Linux Virtual Machine Scale Set and a Load Balancer with static private address which act as a DNS forwarder in a given subnet.
 *
 * Conditional forwarding is configured by setting the `dns_forwarder_servers` variable:
 * ```
 * dns_forwarder_servers = [
 *   {
 *     domain = "example.com"
 *     server = "8.8.8.8"
 *   }
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
  }
}

locals {
  tags = merge(var.tags, local.module_tags)
  module_tags = {
    "Module" = basename(abspath(path.module))
  }
}

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

resource "azurerm_linux_virtual_machine_scale_set" "module" {
  name = "${var.resource_prefix}-vmss"

  resource_group_name = azurerm_resource_group.module.name
  location            = azurerm_resource_group.module.location
  sku                 = "Standard_B1ms"
  instances           = 1
  custom_data         = base64encode(templatefile("${path.module}/templates/cloud-init.tpl", { servers = var.dns_forwarder_servers }))
  admin_username      = "adminuser"
  upgrade_mode        = "Automatic"
  health_probe_id     = azurerm_lb_probe.module.id
  tags                = local.tags

  automatic_os_upgrade_policy {
    disable_automatic_rollback  = false
    enable_automatic_os_upgrade = true
  }

  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 20
    pause_time_between_batches              = "PT0S"
  }

  automatic_instance_repair {
    enabled      = true
    grace_period = "PT30M"
  }

  dynamic "admin_ssh_key" {
    for_each = var.dns_forwarder_ssh_public_keys
    iterator = ssh_key
    content {
      username   = var.dns_forwarder_ssh_username
      public_key = ssh_key.value
    }
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name        = "primary"
    primary     = true
    dns_servers = ["168.63.129.16"]

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.dns_forwarder_subnet_id
      load_balancer_backend_address_pool_ids = [
        azurerm_lb_backend_address_pool.module.id
      ]
    }
  }

  lifecycle {
    ignore_changes = [
      instances,
    ]
  }

  depends_on = [
    azurerm_lb_rule.udp,
    azurerm_lb_rule.tcp,
  ]
}

module "vmss_diagnostic" {
  source = "../diagnostic-settings"

  resource_ids       = [azurerm_linux_virtual_machine_scale_set.module.id]
  compliance_storage = var.compliance_storage
  location           = var.location
  company_prefix     = var.company_prefix
  enable_logs        = false
}

resource "azurerm_monitor_autoscale_setting" "module" {
  name                = "static"
  resource_group_name = azurerm_resource_group.module.name
  location            = azurerm_resource_group.module.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.module.id
  tags                = local.tags

  profile {
    name = "static"

    capacity {
      default = 2
      minimum = 2
      maximum = 2
    }
  }

  depends_on = [
    azurerm_virtual_machine_scale_set_extension.monitoring,
    azurerm_virtual_machine_scale_set_extension.diagnostic,
  ]
}

module "autoscale_diagnostic" {
  source = "../diagnostic-settings"

  resource_ids       = [azurerm_monitor_autoscale_setting.module.id]
  compliance_storage = var.compliance_storage
  location           = var.location
  company_prefix     = var.company_prefix
}

resource "azurerm_virtual_machine_scale_set_extension" "monitoring" {
  name = "OMSExtension"

  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.module.id
  publisher                    = "Microsoft.EnterpriseCloud.Monitoring"
  type                         = "OmsAgentForLinux"
  type_handler_version         = "1.13"
  auto_upgrade_minor_version   = true
  settings                     = jsonencode({ "workspaceId" = var.vm_management.log_analytics_workspace.workspace_id })
  protected_settings           = jsonencode({ "workspaceKey" = var.vm_management.log_analytics_workspace.primary_shared_key })
}

data "azurerm_storage_account_sas" "diagnostic" {
  connection_string = var.vm_management.storage_account.primary_connection_string
  https_only        = true
  start             = "2020-01-01T00:00:00Z"
  expiry            = timeadd("2020-01-01T00:00:00Z", "17520h") # 2 Years

  resource_types {
    service   = false
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = true
    file  = false
  }

  permissions {
    read    = false
    write   = true
    delete  = false
    list    = true
    add     = true
    create  = true
    update  = true
    process = false
  }
}

resource "azurerm_virtual_machine_scale_set_extension" "diagnostic" {
  name = "LinuxDiagnostic"

  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.module.id
  publisher                    = "Microsoft.Azure.Diagnostics"
  type                         = "LinuxDiagnostic"
  type_handler_version         = "3.0"
  auto_upgrade_minor_version   = true
  settings                     = templatefile("${path.module}/templates/diagnostics-settings.tpl", { storage_account = var.vm_management.storage_account.name, resource_id = azurerm_linux_virtual_machine_scale_set.module.id })

  protected_settings = jsonencode(
    {
      "storageAccountName"     = var.vm_management.storage_account.name
      "storageAccountSasToken" = substr(data.azurerm_storage_account_sas.diagnostic.sas, 1, length(data.azurerm_storage_account_sas.diagnostic.sas))
    }
  )
}

resource "azurerm_lb" "module" {
  name = "${var.resource_prefix}-lb"

  resource_group_name = azurerm_resource_group.module.name
  location            = azurerm_resource_group.module.location
  tags                = local.tags

  frontend_ip_configuration {
    name                          = "PrivateIPAddress"
    subnet_id                     = var.dns_forwarder_subnet_id
    private_ip_address            = var.dns_forwarder_ip_address
    private_ip_address_allocation = "static"
  }
}

module "lb_diagnostic" {
  source = "../diagnostic-settings"

  resource_ids       = [azurerm_lb.module.id]
  compliance_storage = var.compliance_storage
  location           = var.location
  company_prefix     = var.company_prefix
}

resource "azurerm_lb_rule" "tcp" {
  name = "dns-tcp-rule"

  resource_group_name            = azurerm_resource_group.module.name
  loadbalancer_id                = azurerm_lb.module.id
  protocol                       = "Tcp"
  frontend_port                  = "53"
  backend_port                   = "53"
  frontend_ip_configuration_name = "PrivateIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.module.id]
  probe_id                       = azurerm_lb_probe.module.id
}

resource "azurerm_lb_rule" "udp" {
  name = "dns-udp-rule"

  resource_group_name            = azurerm_resource_group.module.name
  loadbalancer_id                = azurerm_lb.module.id
  protocol                       = "Udp"
  frontend_port                  = "53"
  backend_port                   = "53"
  frontend_ip_configuration_name = "PrivateIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.module.id]
  probe_id                       = azurerm_lb_probe.module.id
}

resource "azurerm_lb_backend_address_pool" "module" {
  name = "dns-backend-pool"

  loadbalancer_id = azurerm_lb.module.id
}

resource "azurerm_lb_probe" "module" {
  name = "dns-probe"

  resource_group_name = azurerm_resource_group.module.name
  loadbalancer_id     = azurerm_lb.module.id
  port                = 53
}
