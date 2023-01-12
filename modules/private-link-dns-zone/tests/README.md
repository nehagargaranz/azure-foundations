# Private Link DNS Zone Test Module

This module deploys resources to test the addition of dns rescords using the private-link-dns-zone module. The tests are written using bats.

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider_azurerm)

- <a name="provider_random"></a> [random](#provider_random)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_app_configuration.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_configuration) (resource)
- [azurerm_app_service.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service) (resource)
- [azurerm_app_service_plan.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_plan) (resource)
- [azurerm_application_insights.machine_learning_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) (resource)
- [azurerm_container_registry.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) (resource)
- [azurerm_cosmosdb_account.cassandra](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) (resource)
- [azurerm_cosmosdb_account.gremlin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) (resource)
- [azurerm_cosmosdb_account.mongodb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) (resource)
- [azurerm_cosmosdb_account.sql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) (resource)
- [azurerm_cosmosdb_account.table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) (resource)
- [azurerm_eventgrid_domain.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_domain) (resource)
- [azurerm_eventgrid_topic.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_topic) (resource)
- [azurerm_eventhub_namespace.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace) (resource)
- [azurerm_iothub.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub) (resource)
- [azurerm_key_vault.machine_learning_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) (resource)
- [azurerm_key_vault.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) (resource)
- [azurerm_machine_learning_workspace.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/machine_learning_workspace) (resource)
- [azurerm_mariadb_server.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mariadb_server) (resource)
- [azurerm_mysql_server.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_server) (resource)
- [azurerm_postgresql_server.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_server) (resource)
- [azurerm_private_endpoint.app_configuration](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.app_service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.container_registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.cosmosdb_cassandra](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.cosmosdb_gremlin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.cosmosdb_mongodb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.cosmosdb_sql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.cosmosdb_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.dfs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.eventgrid_domain](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.eventgrid_topic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.eventhub_namespace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.iothub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.machine_learning_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.mariadb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.mssqlserver](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.mysql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.postgres](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.relay_namespace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.servicebus_namespace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.signalr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.storage_queue](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.storage_share](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.storage_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.storage_web](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_relay_namespace.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/relay_namespace) (resource)
- [azurerm_resource_group.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_servicebus_namespace.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_namespace) (resource)
- [azurerm_signalr_service.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/signalr_service) (resource)
- [azurerm_sql_server.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sql_server) (resource)
- [azurerm_storage_account.dfs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) (resource)
- [azurerm_storage_account.machine_learning_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) (resource)
- [azurerm_storage_account.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) (resource)
- [azurerm_storage_container.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) (resource)
- [azurerm_storage_container.web](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) (resource)
- [azurerm_storage_data_lake_gen2_filesystem.dfs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_data_lake_gen2_filesystem) (resource)
- [azurerm_storage_queue.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_queue) (resource)
- [azurerm_storage_share.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share) (resource)
- [azurerm_storage_table.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_table) (resource)
- [random_password.test](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) (resource)
- [random_string.test](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_subnet_id"></a> [subnet_id](#input_subnet_id)

Description: Subnet ID

Type: `string`

### <a name="input_subscription_id"></a> [subscription_id](#input_subscription_id)

Description: Subscription ID

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input_location)

Description: Location to deploy resources

Type: `string`

Default: `"australiaeast"`

## Outputs

The following outputs are exported:

### <a name="output_location"></a> [location](#output_location)

Description: Location

### <a name="output_prefix"></a> [prefix](#output_prefix)

Description: Resource name prefix
