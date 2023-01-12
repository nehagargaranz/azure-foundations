/*
 * # Private Link DNS module
 *
 * This module deploys a set of Private DNS zones that are linked to a virtual network, so that Azure PaaS services can be accessed over a private endpoint in the given virtual network.
 *
 * The module has been tested with the following Private Endpoint service types:
 *
 * - Storage account (Microsoft.Storage/storageAccounts) / Blob (blob, blob_secondary)
 * - Storage account (Microsoft.Storage/storageAccounts) / Queue (queue, queue_secondary)
 * - Storage account (Microsoft.Storage/storageAccounts) / File (file, file_secondary)
 * - Storage account (Microsoft.Storage/storageAccounts) / Table (table, table_secondary)
 * - Storage account (Microsoft.Storage/storageAccounts) / Web (web, web_secondary)
 * - Azure SQL Database (Microsoft.Sql/servers) / SQL Server
 * - Azure Data Lake File System Gen2 (Microsoft.Storage/storageAccounts) / Data Lake File System Gen2 (dfs, dfs_secondary)
 * - Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / SQL
 * - Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / MongoDB
 * - Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / Cassandra
 * - Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / Gremlin
 * - Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / Table
 * - Azure Database for PostgreSQL - Single server (Microsoft.DBforPostgreSQL/servers) / postgresqlServer
 * - Azure Database for MySQL (Microsoft.DBforMySQL/servers) / mysqlServer
 * - Azure Database for MariaDB (Microsoft.DBforMariaDB/servers) / mariadbServer
 * - Azure Key Vault (Microsoft.KeyVault/vaults) / vault
 * - Azure Kubernetes Service - Kubernetes API (Microsoft.ContainerService/managedClusters) / management
 * - Azure Container Registry (Microsoft.ContainerRegistry/registries) / registry
 * - Azure App Configuration (Microsoft.AppConfiguration/configurationStores) / configurationStore
 * - Azure Event Hubs (Microsoft.EventHub/namespaces) / namespace
 * - Azure Service Bus (Microsoft.ServiceBus/namespaces) / namespace
 * - Azure IoT Hub (Microsoft.Devices/IotHubs) / iotHub
 * - Azure Relay (Microsoft.Relay/namespaces) / namespace
 * - Azure Event Grid (Microsoft.EventGrid/topics) / topic
 * - Azure Event Grid (Microsoft.EventGrid/domains) / domain
 * - Azure Web Apps (Microsoft.Web/sites) / sites
 * - Azure Machine Learning (Microsoft.MachineLearningServices/workspaces) / workspace
 * - IoT Hub (Microsoft.Devices/IotHubs) / IotHub
 * - SignalR (Microsoft.SignalRService/SignalR ) / signalR
 */

terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.98.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "=2.2.0"
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

resource "azurerm_private_dns_zone" "module" {
  for_each = toset([for zone in var.private_link_dns_zones : replace(zone.zone_name, "{region}", var.location) if zone.enabled == true])

  name = each.key

  resource_group_name = azurerm_resource_group.module.name
  tags                = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "module" {
  for_each = azurerm_private_dns_zone.module

  name                  = var.virtual_network.virtual_network_name
  resource_group_name   = azurerm_resource_group.module.name
  private_dns_zone_name = azurerm_private_dns_zone.module[each.key].name
  virtual_network_id    = var.virtual_network.virtual_network_id
  tags                  = local.tags
}

resource "azurerm_storage_account" "module" {
  name = "${var.company_prefix}${var.location_abbreviations[var.location]}privatelinkfunc"

  resource_group_name      = azurerm_resource_group.module.name
  location                 = azurerm_resource_group.module.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = local.tags
}

resource "azurerm_storage_table" "module" {
  name                 = "privateendpoints"
  storage_account_name = azurerm_storage_account.module.name
}

resource "azurerm_storage_container" "module" {
  name                  = "deployments"
  storage_account_name  = azurerm_storage_account.module.name
  container_access_type = "private"
}

data "azurerm_storage_account_blob_container_sas" "module" {
  connection_string = azurerm_storage_account.module.primary_connection_string
  container_name    = azurerm_storage_container.module.name
  https_only        = true

  start  = "2020-01-01"
  expiry = "2029-01-01"

  permissions {
    read   = true
    add    = false
    create = false
    write  = false
    delete = false
    list   = false
  }
}

data "archive_file" "module" {
  type        = "zip"
  source_dir  = "${path.module}/assets/functionapp"
  output_path = "${path.module}/build/functionapp.zip"
}

resource "azurerm_storage_blob" "module" {
  name = "${data.archive_file.module.output_sha}/functionapp.zip"

  storage_account_name   = azurerm_storage_account.module.name
  storage_container_name = azurerm_storage_container.module.name
  type                   = "Block"
  source                 = data.archive_file.module.output_path
}

resource "azurerm_application_insights" "module" {
  name = "${var.resource_prefix}-ai"

  resource_group_name = azurerm_resource_group.module.name
  location            = azurerm_resource_group.module.location
  application_type    = "other"
}

resource "azurerm_app_service_plan" "module" {
  name = "${var.company_prefix}-${var.environment}-${var.location_abbreviations[var.location]}-plan"

  resource_group_name = azurerm_resource_group.module.name
  location            = azurerm_resource_group.module.location
  kind                = "FunctionApp"
  tags                = local.tags

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "module" {
  name = "${var.company_prefix}-${var.environment}-${var.location_abbreviations[var.location]}-privatelink-func"

  resource_group_name        = azurerm_resource_group.module.name
  location                   = azurerm_resource_group.module.location
  app_service_plan_id        = azurerm_app_service_plan.module.id
  storage_account_name       = azurerm_storage_account.module.name
  storage_account_access_key = azurerm_storage_account.module.primary_access_key
  https_only                 = true
  version                    = "~3"
  tags                       = local.tags

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on       = false
    min_tls_version = "1.2"
    ftps_state      = "Disabled"
    http2_enabled   = true
  }

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE                   = "${azurerm_storage_blob.module.url}${data.azurerm_storage_account_blob_container_sas.module.sas}"
    FUNCTION_APP_EDIT_MODE                     = "readonly"
    FUNCTIONS_WORKER_RUNTIME                   = "powershell"
    PSWorkerInProcConcurrencyUpperBound        = 10
    APPINSIGHTS_INSTRUMENTATIONKEY             = azurerm_application_insights.module.instrumentation_key
    ApplicationInsightsAgent_EXTENSION_VERSION = "~2"
    SUBSCRIPTION_ID                            = data.azurerm_subscription.current.subscription_id
    RESOURCE_GROUP_NAME                        = azurerm_resource_group.module.name
    STORAGE_ACCOUNT_NAME                       = azurerm_storage_table.module.storage_account_name
    STORAGE_TABLE_NAME                         = azurerm_storage_table.module.name
    LOCATION                                   = azurerm_resource_group.module.location
  }
}

module "function_app_diagnostic" {
  source = "../diagnostic-settings"

  resource_ids       = [azurerm_function_app.module.id]
  compliance_storage = var.compliance_storage
  location           = var.location
  company_prefix     = var.company_prefix
}

resource "azurerm_role_assignment" "dns_role" {
  principal_id         = azurerm_function_app.module.identity[0].principal_id
  role_definition_name = "Private DNS Zone Contributor"
  scope                = azurerm_resource_group.module.id
}

resource "azurerm_role_assignment" "storage_role" {
  principal_id         = azurerm_function_app.module.identity[0].principal_id
  role_definition_name = "Storage Account Contributor"
  scope                = azurerm_resource_group.module.id
}
