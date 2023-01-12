RESOURCE_GROUP=hub-australiaeast-private-link-dns-zone-rg
HUB_SUBSCRIPTION=Hub
TEST_SUBSCRIPTION=Dev
PREFIX=$(terraform output -raw prefix)
LOCATION=$(terraform output -raw location)

# Storage account (Microsoft.Storage/storageAccounts) / Blob (blob, blob_secondary)
@test "Storage account (Microsoft.Storage/storageAccounts) / Blob (blob, blob_secondary)" {
  az network private-dns record-set a show \
    --name "${PREFIX}testsa" \
    --zone-name privatelink.blob.core.windows.net \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Storage account (Microsoft.Storage/storageAccounts) / Queue (queue, queue_secondary)
@test "Storage account (Microsoft.Storage/storageAccounts) / Queue (queue, queue_secondary)" {
  az network private-dns record-set a show \
    --name "${PREFIX}testsa" \
    --zone-name privatelink.queue.core.windows.net \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Storage account (Microsoft.Storage/storageAccounts) / File (file, file_secondary)
@test "Storage account (Microsoft.Storage/storageAccounts) / File (file, file_secondary)" {
  az network private-dns record-set a show \
    --name "${PREFIX}testsa" \
    --zone-name privatelink.file.core.windows.net \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Storage account (Microsoft.Storage/storageAccounts) / Table (table, table_secondary)
@test "Storage account (Microsoft.Storage/storageAccounts) / Table (table, table_secondary)" {
  az network private-dns record-set a show \
    --name "${PREFIX}testsa" \
    --zone-name privatelink.table.core.windows.net \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Storage account (Microsoft.Storage/storageAccounts) / Web (web, web_secondary)
@test "Storage account (Microsoft.Storage/storageAccounts) / Web (web, web_secondary)" {
  az network private-dns record-set a list \
    --zone-name privatelink.web.core.windows.net \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}" | grep "${PREFIX}testsa"
}

# Azure SQL Database (Microsoft.Sql/servers) / SQL Server
@test "Azure SQL Database (Microsoft.Sql/servers) / SQL Server" {
  az network private-dns record-set a show \
    --name "${PREFIX}-mssqlserver" \
    --zone-name privatelink.database.windows.net \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Azure Data Lake File System Gen2 (Microsoft.Storage/storageAccounts) / Data Lake File System Gen2 (dfs, dfs_secondary)
@test "Azure Data Lake File System Gen2 (Microsoft.Storage/storageAccounts) / Data Lake File System Gen2 (dfs, dfs_secondary)" {
  az network private-dns record-set a show \
    --name "${PREFIX}dfssa" \
    --zone-name privatelink.dfs.core.windows.net \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / SQL
@test "Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / SQL" {
  az network private-dns record-set a show \
    --name "${PREFIX}-cosmos-sql" \
    --zone-name privatelink.documents.azure.com \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / MongoDB
@test "Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / MongoDB" {
  az network private-dns record-set a show \
    --name "${PREFIX}-cosmos-mongodb" \
    --zone-name privatelink.mongo.cosmos.azure.com \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / Cassandra
@test "Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / Cassandra" {
  az network private-dns record-set a show \
    --name "${PREFIX}-cosmos-cassandra" \
    --zone-name privatelink.cassandra.cosmos.azure.com \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / Gremlin
@test "Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / Gremlin" {
  az network private-dns record-set a show \
    --name "${PREFIX}-cosmos-gremlin" \
    --zone-name privatelink.gremlin.cosmos.azure.com \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / Table
@test "Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / Table" {
  az network private-dns record-set a show \
    --name "${PREFIX}-cosmos-table" \
    --zone-name privatelink.table.cosmos.azure.com \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Azure Database for PostgreSQL - Single server (Microsoft.DBforPostgreSQL/servers) / postgresqlServer
@test "Azure Database for PostgreSQL - Single server (Microsoft.DBforPostgreSQL/servers) / postgresqlServer" {
  az network private-dns record-set a show \
    --name "${PREFIX}-postgres" \
    --zone-name privatelink.postgres.database.azure.com \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Azure Database for MySQL (Microsoft.DBforMySQL/servers) / mysqlServer
@test "Azure Database for MySQL (Microsoft.DBforMySQL/servers) / mysqlServer" {
  az network private-dns record-set a show \
    --name "${PREFIX}-mysql" \
    --zone-name privatelink.mysql.database.azure.com \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Azure Database for MariaDB (Microsoft.DBforMariaDB/servers) / mariadbServer
@test "Azure Database for MariaDB (Microsoft.DBforMariaDB/servers) / mariadbServer" {
  az network private-dns record-set a show \
    --name "${PREFIX}-mariadb" \
    --zone-name privatelink.mariadb.database.azure.com \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Azure Key Vault (Microsoft.KeyVault/vaults) / vault
@test "Azure Key Vault (Microsoft.KeyVault/vaults) / vault" {
  az network private-dns record-set a show \
    --name "${PREFIX}-kv" \
    --zone-name privatelink.vaultcore.azure.net \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Azure Kubernetes Service - Kubernetes API (Microsoft.ContainerService/managedClusters) / management
@test "Azure Kubernetes Service - Kubernetes API (Microsoft.ContainerService/managedClusters) / management" {
  skip # Manually tested
}

# Azure Container Registry (Microsoft.ContainerRegistry/registries) / registry
@test "Azure Container Registry (Microsoft.ContainerRegistry/registries) / registry" {
  az network private-dns record-set a show \
    --name "${PREFIX}acr" \
    --zone-name privatelink.azurecr.io \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
  az network private-dns record-set a show \
    --name "${PREFIX}acr.${LOCATION}.data" \
    --zone-name privatelink.azurecr.io \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Azure App Configuration (Microsoft.AppConfiguration/configurationStores) / configurationStore
@test "Azure App Configuration (Microsoft.AppConfiguration/configurationStores) / configurationStore" {
  az network private-dns record-set a show \
    --name "${PREFIX}-app-config" \
    --zone-name privatelink.azconfig.io \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Azure Event Hubs (Microsoft.EventHub/namespaces) / namespace
@test "Azure Event Hubs (Microsoft.EventHub/namespaces) / namespace" {
  az network private-dns record-set a show \
    --name "${PREFIX}-ehnamespace" \
    --zone-name privatelink.servicebus.windows.net \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Azure Service Bus (Microsoft.ServiceBus/namespaces) / namespace
@test "Azure Service Bus (Microsoft.ServiceBus/namespaces) / namespace" {
  az network private-dns record-set a show \
    --name "${PREFIX}-sbnamespace" \
    --zone-name privatelink.servicebus.windows.net \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Azure IoT Hub (Microsoft.Devices/IotHubs) / iotHub
@test "Azure IoT Hub (Microsoft.Devices/IotHubs) / iotHub" {
  az network private-dns record-set a show \
    --name "${PREFIX}-iothub" \
    --zone-name privatelink.azure-devices.net \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Azure Relay (Microsoft.Relay/namespaces) / namespace
@test "Azure Relay (Microsoft.Relay/namespaces) / namespace" {
  az network private-dns record-set a show \
    --name "${PREFIX}-relay" \
    --zone-name privatelink.servicebus.windows.net \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Azure Event Grid (Microsoft.EventGrid/topics) / topic
@test "Azure Event Grid (Microsoft.EventGrid/topics) / topic" {
  az network private-dns record-set a show \
    --name "${PREFIX}-eventgrid-topic.${LOCATION}-1" \
    --zone-name privatelink.eventgrid.azure.net \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Azure Event Grid (Microsoft.EventGrid/domains) / domain
@test "Azure Event Grid (Microsoft.EventGrid/domains) / domain" {
  az network private-dns record-set a show \
    --name "${PREFIX}-eventgrid-domain.${LOCATION}-1" \
    --zone-name privatelink.eventgrid.azure.net \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Azure Web Apps (Microsoft.Web/sites) / sites
@test "Azure Web Apps (Microsoft.Web/sites) / sites" {
  az network private-dns record-set a show \
    --name "${PREFIX}-appservice" \
    --zone-name privatelink.azurewebsites.net \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# Azure Machine Learning (Microsoft.MachineLearningServices/workspaces) / workspace
@test "Azure Machine Learning (Microsoft.MachineLearningServices/workspaces) / workspace" {
  WORKSPACE_ID=$(az rest -u https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/${PREFIX}-rg/providers/Microsoft.MachineLearningServices/workspaces/\?api-version\=2019-11-01 --query 'value[0].properties.workspaceId' -o tsv --subscription "${TEST_SUBSCRIPTION}")
  az network private-dns record-set a show --name "${WORKSPACE_ID}.workspace.westus2" \
    --zone-name privatelink.api.azureml.ms \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
  az network private-dns record-set a show --name "${WORKSPACE_ID}.studio.workspace.westus2" \
    --zone-name privatelink.api.azureml.ms \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}

# SignalR (Microsoft.SignalRService/SignalR ) / signalR
@test "SignalR (Microsoft.SignalRService/SignalR ) / signalR" {
  az network private-dns record-set a show \
    --name "${PREFIX}-signalr" \
    --zone-name privatelink.service.signalr.net \
    --resource-group "${RESOURCE_GROUP}" \
    --subscription "${HUB_SUBSCRIPTION}"
}
