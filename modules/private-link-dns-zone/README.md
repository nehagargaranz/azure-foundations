# Private Link DNS module

This module deploys a set of Private DNS zones that are linked to a virtual network, so that Azure PaaS services can be accessed over a private endpoint in the given virtual network.

The module has been tested with the following Private Endpoint service types:

- Storage account (Microsoft.Storage/storageAccounts) / Blob (blob, blob_secondary)
- Storage account (Microsoft.Storage/storageAccounts) / Queue (queue, queue_secondary)
- Storage account (Microsoft.Storage/storageAccounts) / File (file, file_secondary)
- Storage account (Microsoft.Storage/storageAccounts) / Table (table, table_secondary)
- Storage account (Microsoft.Storage/storageAccounts) / Web (web, web_secondary)
- Azure SQL Database (Microsoft.Sql/servers) / SQL Server
- Azure Data Lake File System Gen2 (Microsoft.Storage/storageAccounts) / Data Lake File System Gen2 (dfs, dfs_secondary)
- Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / SQL
- Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / MongoDB
- Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / Cassandra
- Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / Gremlin
- Azure Cosmos DB (Microsoft.AzureCosmosDB/databaseAccounts) / Table
- Azure Database for PostgreSQL - Single server (Microsoft.DBforPostgreSQL/servers) / postgresqlServer
- Azure Database for MySQL (Microsoft.DBforMySQL/servers) / mysqlServer
- Azure Database for MariaDB (Microsoft.DBforMariaDB/servers) / mariadbServer
- Azure Key Vault (Microsoft.KeyVault/vaults) / vault
- Azure Kubernetes Service - Kubernetes API (Microsoft.ContainerService/managedClusters) / management
- Azure Container Registry (Microsoft.ContainerRegistry/registries) / registry
- Azure App Configuration (Microsoft.AppConfiguration/configurationStores) / configurationStore
- Azure Event Hubs (Microsoft.EventHub/namespaces) / namespace
- Azure Service Bus (Microsoft.ServiceBus/namespaces) / namespace
- Azure IoT Hub (Microsoft.Devices/IotHubs) / iotHub
- Azure Relay (Microsoft.Relay/namespaces) / namespace
- Azure Event Grid (Microsoft.EventGrid/topics) / topic
- Azure Event Grid (Microsoft.EventGrid/domains) / domain
- Azure Web Apps (Microsoft.Web/sites) / sites
- Azure Machine Learning (Microsoft.MachineLearningServices/workspaces) / workspace
- IoT Hub (Microsoft.Devices/IotHubs) / IotHub
- SignalR (Microsoft.SignalRService/SignalR ) / signalR

## Providers

The following providers are used by this module:

- <a name="provider_archive"></a> [archive](#provider_archive) (=2.2.0)

- <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) (=2.98.0)

## Modules

The following Modules are called:

### <a name="module_function_app_diagnostic"></a> [function_app_diagnostic](#module_function_app_diagnostic)

Source: ../diagnostic-settings

Version:

## Resources

The following resources are used by this module:

- [azurerm_app_service_plan.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/app_service_plan) (resource)
- [azurerm_application_insights.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/application_insights) (resource)
- [azurerm_function_app.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/function_app) (resource)
- [azurerm_management_lock.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/management_lock) (resource)
- [azurerm_private_dns_zone.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/private_dns_zone) (resource)
- [azurerm_private_dns_zone_virtual_network_link.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/private_dns_zone_virtual_network_link) (resource)
- [azurerm_resource_group.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/resource_group) (resource)
- [azurerm_role_assignment.dns_role](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.storage_role](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/role_assignment) (resource)
- [azurerm_storage_account.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/storage_account) (resource)
- [azurerm_storage_blob.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/storage_blob) (resource)
- [azurerm_storage_container.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/storage_container) (resource)
- [azurerm_storage_table.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/resources/storage_table) (resource)
- [archive_file.module](https://registry.terraform.io/providers/hashicorp/archive/2.2.0/docs/data-sources/file) (data source)
- [azurerm_storage_account_blob_container_sas.module](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/data-sources/storage_account_blob_container_sas) (data source)
- [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.98.0/docs/data-sources/subscription) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_company_prefix"></a> [company_prefix](#input_company_prefix)

Description: (Required) Prefix given to all globally unique names

Type: `string`

### <a name="input_compliance_storage"></a> [compliance_storage](#input_compliance_storage)

Description: (Required) Map of storage_account_id and log_analytics_workspace_resource_id used for diagnostic setting

Type:

```hcl
object({
    storage_accounts                  = any
    storage_account_retention_in_days = number
    log_analytics_workspaces          = any
    log_analytics_retention_in_days   = number
  })
```

### <a name="input_environment"></a> [environment](#input_environment)

Description: (Required) Environment name

Type: `string`

### <a name="input_location"></a> [location](#input_location)

Description: (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.

Type: `string`

### <a name="input_location_abbreviations"></a> [location_abbreviations](#input_location_abbreviations)

Description: (Required) A map of Azure location names to abbreviations which can be used in (e.g.) storage account names.

Type: `map(string)`

### <a name="input_private_link_dns_zones"></a> [private_link_dns_zones](#input_private_link_dns_zones)

Description: (Required) Azure Private DNS zone names and whether to enable them for Private Link

Type:

```hcl
set(object({
    zone_name = string
    enabled   = bool
  }))
```

### <a name="input_resource_prefix"></a> [resource_prefix](#input_resource_prefix)

Description: (Required) Prefix given to all resources within the module.

Type: `string`

### <a name="input_virtual_network"></a> [virtual_network](#input_virtual_network)

Description: (Required) Map of Virtual Network Object to link

Type:

```hcl
object({
    virtual_network_name = string
    virtual_network_id   = string
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_resource_group_lock"></a> [resource_group_lock](#input_resource_group_lock)

Description: Lock the modules Resource Group with a CanNotDelete Management Lock

Type: `bool`

Default: `true`

### <a name="input_tags"></a> [tags](#input_tags)

Description: Set of base tags that will be associated with each supported resource.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_function_app_identity"></a> [function_app_identity](#output_function_app_identity)

Description: Principal ID of the Function App

### <a name="output_function_app_url"></a> [function_app_url](#output_function_app_url)

Description: URL of Function App

### <a name="output_function_id"></a> [function_id](#output_function_id)

Description: Function ID of the PrivateLinkEndpoint function

### <a name="output_private_dns_zone_names"></a> [private_dns_zone_names](#output_private_dns_zone_names)

Description: Names of the private dns zone
