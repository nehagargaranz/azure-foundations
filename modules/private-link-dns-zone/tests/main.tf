/*
 * # Private Link DNS Zone Test Module
 *
 * This module deploys resources to test the addition of dns rescords using the private-link-dns-zone module. The tests are written using bats.
 *
 */

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID"
}

variable "subscription_id" {
  type        = string
  description = "Subscription ID"
}

variable "location" {
  type        = string
  default     = "australiaeast"
  description = "Location to deploy resources"
}

resource "random_string" "test" {
  length  = 8
  special = false
  upper   = false
  number  = false
}

resource "random_password" "test" {
  length = 12
}

resource "azurerm_resource_group" "test" {
  name     = "${random_string.test.result}-rg"
  location = var.location
}

data "azurerm_client_config" "current" {}

# Storage account (Microsoft.Storage/storageAccounts)
resource "azurerm_storage_account" "test" {
  name = "${random_string.test.result}testsa"

  resource_group_name      = azurerm_resource_group.test.name
  location                 = azurerm_resource_group.test.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
}

# Storage account (Microsoft.Storage/storageAccounts) / Blob (blob, blob_secondary)
resource "azurerm_storage_container" "test" {
  name                  = "${random_string.test.result}-container"
  storage_account_name  = azurerm_storage_account.test.name
  container_access_type = "private"
}

resource "azurerm_private_endpoint" "storage_container" {
  name                = "${random_string.test.result}-container"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-container"
    private_connection_resource_id = azurerm_storage_account.test.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}

# Storage account (Microsoft.Storage/storageAccounts) / Queue (queue, queue_secondary)
resource "azurerm_storage_queue" "test" {
  name                 = "${random_string.test.result}-queue"
  storage_account_name = azurerm_storage_account.test.name
}

resource "azurerm_private_endpoint" "storage_queue" {
  name                = "${random_string.test.result}-queue"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-queue"
    private_connection_resource_id = azurerm_storage_account.test.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }
}

# Storage account (Microsoft.Storage/storageAccounts) / File (file, file_secondary)
resource "azurerm_storage_share" "test" {
  name                 = "${random_string.test.result}-share"
  storage_account_name = azurerm_storage_account.test.name
}

resource "azurerm_private_endpoint" "storage_share" {
  name                = "${random_string.test.result}-share"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-share"
    private_connection_resource_id = azurerm_storage_account.test.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }
}

# Storage account (Microsoft.Storage/storageAccounts) / Table (table, table_secondary)
resource "azurerm_storage_table" "test" {
  name                 = "${random_string.test.result}table"
  storage_account_name = azurerm_storage_account.test.name
}

resource "azurerm_private_endpoint" "storage_table" {
  name                = "${random_string.test.result}-table"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-table"
    private_connection_resource_id = azurerm_storage_account.test.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }
}

# Storage account (Microsoft.Storage/storageAccounts) / Web (web, web_secondary)
resource "azurerm_storage_container" "web" {
  name                 = "${random_string.test.result}-web"
  storage_account_name = azurerm_storage_account.test.name
}

resource "azurerm_private_endpoint" "storage_web" {
  name                = "${random_string.test.result}-web"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-web"
    private_connection_resource_id = azurerm_storage_account.test.id
    subresource_names              = ["web"]
    is_manual_connection           = false
  }
}

# Azure SQL Database (Microsoft.Sql/servers) / SQL Server
resource "azurerm_sql_server" "test" {
  name                         = "${random_string.test.result}-mssqlserver"
  resource_group_name          = azurerm_resource_group.test.name
  location                     = azurerm_resource_group.test.location
  version                      = "12.0"
  administrator_login          = "sqladministrator"
  administrator_login_password = random_password.test.result
}

resource "azurerm_private_endpoint" "mssqlserver" {
  name                = "${random_string.test.result}-mssqlserver"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-mssqlserver"
    private_connection_resource_id = azurerm_sql_server.test.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}

# Azure Data Lake File System Gen2 (Microsoft.Storage/storageAccounts) / Data Lake File System Gen2 (dfs, dfs_secondary)
resource "azurerm_storage_account" "dfs" {
  name = "${random_string.test.result}dfssa"

  resource_group_name      = azurerm_resource_group.test.name
  location                 = azurerm_resource_group.test.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = "true"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "dfs" {
  name               = "${random_string.test.result}-dfs"
  storage_account_id = azurerm_storage_account.dfs.id
}

resource "azurerm_private_endpoint" "dfs" {
  name                = "${random_string.test.result}-dfs"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-dfs"
    private_connection_resource_id = azurerm_storage_account.dfs.id
    subresource_names              = ["dfs"]
    is_manual_connection           = false
  }
}

# Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / SQL
resource "azurerm_cosmosdb_account" "sql" {
  name                = "${random_string.test.result}-cosmos-sql"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Eventual"
  }

  geo_location {
    location          = azurerm_resource_group.test.location
    failover_priority = 0
  }
}

resource "azurerm_private_endpoint" "cosmosdb_sql" {
  name                = "${random_string.test.result}-cosmos-sql"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-cosmos-sql"
    private_connection_resource_id = azurerm_cosmosdb_account.sql.id
    subresource_names              = ["Sql"]
    is_manual_connection           = false
  }
}

# Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / MongoDB
resource "azurerm_cosmosdb_account" "mongodb" {
  name                = "${random_string.test.result}-cosmos-mongodb"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  consistency_policy {
    consistency_level = "Eventual"
  }

  geo_location {
    location          = azurerm_resource_group.test.location
    failover_priority = 0
  }

  capabilities {
    name = "EnableMongo"
  }
}

resource "azurerm_private_endpoint" "cosmosdb_mongodb" {
  name                = "${random_string.test.result}-cosmos-mongodb"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-cosmos-mongodb"
    private_connection_resource_id = azurerm_cosmosdb_account.mongodb.id
    subresource_names              = ["MongoDB"]
    is_manual_connection           = false
  }
}

# Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / Cassandra
resource "azurerm_cosmosdb_account" "cassandra" {
  name                = "${random_string.test.result}-cosmos-cassandra"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Eventual"
  }

  geo_location {
    location          = azurerm_resource_group.test.location
    failover_priority = 0
  }

  capabilities {
    name = "EnableCassandra"
  }
}

resource "azurerm_private_endpoint" "cosmosdb_cassandra" {
  name                = "${random_string.test.result}-cosmos-cassandra"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-cosmos-cassandra"
    private_connection_resource_id = azurerm_cosmosdb_account.cassandra.id
    subresource_names              = ["Cassandra"]
    is_manual_connection           = false
  }
}

# Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / Gremlin
resource "azurerm_cosmosdb_account" "gremlin" {
  name                = "${random_string.test.result}-cosmos-gremlin"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Eventual"
  }

  geo_location {
    location          = azurerm_resource_group.test.location
    failover_priority = 0
  }

  capabilities {
    name = "EnableGremlin"
  }
}

resource "azurerm_private_endpoint" "cosmosdb_gremlin" {
  name                = "${random_string.test.result}-cosmos-gremlin"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-cosmos-gremlin"
    private_connection_resource_id = azurerm_cosmosdb_account.gremlin.id
    subresource_names              = ["Gremlin"]
    is_manual_connection           = false
  }
}

# Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / Table
resource "azurerm_cosmosdb_account" "table" {
  name                = "${random_string.test.result}-cosmos-table"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Eventual"
  }

  geo_location {
    location          = azurerm_resource_group.test.location
    failover_priority = 0
  }

  capabilities {
    name = "EnableTable"
  }
}

resource "azurerm_private_endpoint" "cosmosdb_table" {
  name                = "${random_string.test.result}-cosmos-table"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-cosmos-table"
    private_connection_resource_id = azurerm_cosmosdb_account.table.id
    subresource_names              = ["Table"]
    is_manual_connection           = false
  }
}

# Azure Database for PostgreSQL - Single server (Microsoft.DBforPostgreSQL/servers) / postgresqlServer
resource "azurerm_postgresql_server" "test" {
  name                         = "${random_string.test.result}-postgres"
  location                     = azurerm_resource_group.test.location
  resource_group_name          = azurerm_resource_group.test.name
  administrator_login          = "pgadminlogin"
  administrator_login_password = random_password.test.result
  sku_name                     = "GP_Gen5_4"
  version                      = "10.0"
  ssl_enforcement_enabled      = true
}

resource "azurerm_private_endpoint" "postgres" {
  name                = "${random_string.test.result}-postgres"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-postgres"
    private_connection_resource_id = azurerm_postgresql_server.test.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }
}

# Azure Database for MySQL (Microsoft.DBforMySQL/servers) / mysqlServer
resource "azurerm_mysql_server" "test" {
  name                         = "${random_string.test.result}-mysql"
  location                     = azurerm_resource_group.test.location
  resource_group_name          = azurerm_resource_group.test.name
  administrator_login          = "mysqladminun"
  administrator_login_password = random_password.test.result
  sku_name                     = "GP_Gen5_2"
  version                      = "5.7"
  storage_mb                   = 5120
  ssl_enforcement_enabled      = true
}

resource "azurerm_private_endpoint" "mysql" {
  name                = "${random_string.test.result}-mysql"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-mysql"
    private_connection_resource_id = azurerm_mysql_server.test.id
    subresource_names              = ["mysqlServer"]
    is_manual_connection           = false
  }
}

# Azure Database for MariaDB (Microsoft.DBforMariaDB/servers) / mariadbServer
resource "azurerm_mariadb_server" "test" {
  name                         = "${random_string.test.result}-mariadb"
  location                     = azurerm_resource_group.test.location
  resource_group_name          = azurerm_resource_group.test.name
  administrator_login          = "mariadbadmin"
  administrator_login_password = random_password.test.result
  sku_name                     = "GP_Gen5_2"
  storage_mb                   = 5120
  version                      = "10.2"
  ssl_enforcement_enabled      = true
}

resource "azurerm_private_endpoint" "mariadb" {
  name                = "${random_string.test.result}-mariadb"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-mariadb"
    private_connection_resource_id = azurerm_mariadb_server.test.id
    subresource_names              = ["mariadbServer"]
    is_manual_connection           = false
  }
}

# Azure Key Vault (Microsoft.KeyVault/vaults) / vault
resource "azurerm_key_vault" "test" {
  name                = "${random_string.test.result}-kv"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"
}

resource "azurerm_private_endpoint" "key_vault" {
  name                = "${random_string.test.result}-kv"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-kv"
    private_connection_resource_id = azurerm_key_vault.test.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
}

# Azure Kubernetes Service - Kubernetes API (Microsoft.ContainerService/managedClusters) / management
# Manually tested

# Azure Container Registry (Microsoft.ContainerRegistry/registries) / registry
resource "azurerm_container_registry" "test" {
  name                = "${random_string.test.result}acr"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  sku                 = "Premium"
  admin_enabled       = false
}

resource "azurerm_private_endpoint" "container_registry" {
  name                = "${random_string.test.result}-acr"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-acr"
    private_connection_resource_id = azurerm_container_registry.test.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }
}

# Azure App Configuration (Microsoft.AppConfiguration/configurationStores) / configurationStore
resource "azurerm_app_configuration" "test" {
  name                = "${random_string.test.result}-app-config"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  sku                 = "standard"
}

resource "azurerm_private_endpoint" "app_configuration" {
  name                = "${random_string.test.result}-app-config"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-app-config"
    private_connection_resource_id = azurerm_app_configuration.test.id
    subresource_names              = ["configurationStores"]
    is_manual_connection           = false
  }
}

# Azure Event Hubs (Microsoft.EventHub/namespaces) / namespace
resource "azurerm_eventhub_namespace" "test" {
  name                = "${random_string.test.result}-ehnamespace"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  sku                 = "Standard"
  capacity            = 1
}

resource "azurerm_private_endpoint" "eventhub_namespace" {
  name                = "${random_string.test.result}-ehnamespace"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-ehnamespace"
    private_connection_resource_id = azurerm_eventhub_namespace.test.id
    subresource_names              = ["namespace"]
    is_manual_connection           = false
  }
}

# Azure Service Bus (Microsoft.ServiceBus/namespaces) / namespace
resource "azurerm_servicebus_namespace" "test" {
  name                = "${random_string.test.result}-sbnamespace"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  sku                 = "Premium"
  capacity            = 1
}

resource "azurerm_private_endpoint" "servicebus_namespace" {
  name                = "${random_string.test.result}-sbnamespace"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-sbnamespace"
    private_connection_resource_id = azurerm_servicebus_namespace.test.id
    subresource_names              = ["namespace"]
    is_manual_connection           = false
  }
}

# Azure IoT Hub (Microsoft.Devices/IotHubs) / iotHub
resource "azurerm_iothub" "test" {
  name                = "${random_string.test.result}-iothub"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  sku {
    name     = "S1"
    capacity = "1"
  }
}

resource "azurerm_private_endpoint" "iothub" {
  name                = "${random_string.test.result}-iothub"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-iothub"
    private_connection_resource_id = azurerm_iothub.test.id
    subresource_names              = ["iothub"]
    is_manual_connection           = false
  }
}

# Azure Relay (Microsoft.Relay/namespaces) / namespace
resource "azurerm_relay_namespace" "test" {
  name                = "${random_string.test.result}-relay"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  sku_name            = "Standard"
}

resource "azurerm_private_endpoint" "relay_namespace" {
  name                = "${random_string.test.result}-relay"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-relay"
    private_connection_resource_id = azurerm_relay_namespace.test.id
    subresource_names              = ["namespace"]
    is_manual_connection           = false
  }
}

# Azure Event Grid (Microsoft.EventGrid/topics) / topic
resource "azurerm_eventgrid_topic" "test" {
  name                = "${random_string.test.result}-eventgrid-topic"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}

resource "azurerm_private_endpoint" "eventgrid_topic" {
  name                = "${random_string.test.result}-eventgrid-topic"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-eventgrid-topic"
    private_connection_resource_id = azurerm_eventgrid_topic.test.id
    subresource_names              = ["topic"]
    is_manual_connection           = false
  }
}

# Azure Event Grid (Microsoft.EventGrid/domains) / domain
resource "azurerm_eventgrid_domain" "test" {
  name                = "${random_string.test.result}-eventgrid-domain"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}

resource "azurerm_private_endpoint" "eventgrid_domain" {
  name                = "${random_string.test.result}-eventgrid-domain"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-eventgrid-domain"
    private_connection_resource_id = azurerm_eventgrid_domain.test.id
    subresource_names              = ["domain"]
    is_manual_connection           = false
  }
}

# Azure Web Apps (Microsoft.Web/sites) / sites
resource "azurerm_app_service_plan" "test" {
  name                = "${random_string.test.result}-appservice-plan"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  sku {
    tier = "PremiumV2"
    size = "P1v2"
  }
}

resource "azurerm_app_service" "test" {
  name                = "${random_string.test.result}-appservice"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  app_service_plan_id = azurerm_app_service_plan.test.id
}

resource "azurerm_private_endpoint" "app_service" {
  name                = "${random_string.test.result}-appservice"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-appservice"
    private_connection_resource_id = azurerm_app_service.test.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}

# Azure Machine Learning (Microsoft.MachineLearningServices/workspaces) / workspace
resource "azurerm_machine_learning_workspace" "test" {
  name                    = "${random_string.test.result}-mlworkspace"
  location                = "westus2"
  resource_group_name     = azurerm_resource_group.test.name
  application_insights_id = azurerm_application_insights.machine_learning_workspace.id
  key_vault_id            = azurerm_key_vault.machine_learning_workspace.id
  storage_account_id      = azurerm_storage_account.machine_learning_workspace.id

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_application_insights" "machine_learning_workspace" {
  name                = "${random_string.test.result}-mlworkspace-ai"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  application_type    = "web"
}

resource "azurerm_key_vault" "machine_learning_workspace" {
  name                = "${random_string.test.result}-mlworkspace-kv"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "premium"
}

resource "azurerm_storage_account" "machine_learning_workspace" {
  name                     = "${random_string.test.result}mlworkspacesa"
  location                 = azurerm_resource_group.test.location
  resource_group_name      = azurerm_resource_group.test.name
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_private_endpoint" "machine_learning_workspace" {
  name                = "${random_string.test.result}-mlworkspace"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-mlworkspace"
    private_connection_resource_id = azurerm_machine_learning_workspace.test.id
    subresource_names              = ["amlworkspace"]
    is_manual_connection           = false
  }
}

# SignalR (Microsoft.SignalRService/SignalR ) / signalR
resource "azurerm_signalr_service" "test" {
  name                = "${random_string.test.result}-signalr"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  sku {
    name     = "Standard_S1"
    capacity = 1
  }
}

resource "azurerm_private_endpoint" "signalr" {
  name                = "${random_string.test.result}-signalr"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${random_string.test.result}-signalr"
    private_connection_resource_id = azurerm_signalr_service.test.id
    subresource_names              = ["signalr"]
    is_manual_connection           = false
  }
}

# Outputs
output "prefix" {
  value       = random_string.test.result
  description = "Resource name prefix"
}

output "location" {
  value       = var.location
  description = "Location"
}
