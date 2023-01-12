include {
  path = find_in_parent_folders()
}

dependency "management_group" {
  config_path  = "../management-group"
  mock_outputs = try(yamldecode(file("${get_parent_terragrunt_dir()}/../modules/management-group/mock_outputs.yaml")), {})
}

dependency "compliance_storage" {
  config_path  = "${get_parent_terragrunt_dir()}/compliance/global/compliance-storage"
  mock_outputs = try(yamldecode(file("${get_parent_terragrunt_dir()}/../modules/compliance-storage/mock_outputs.yaml")), {})
}

inputs = {
  management_group_id = dependency.management_group.outputs.management_group_id
  policy_set_assignments = [
    {
      name = "PCI v3.2.1:2018"
      id   = "/providers/Microsoft.Authorization/policySetDefinitions/496eeda9-8f2f-4d5e-8dfd-204f0a92ed41"
      json_parameters = jsonencode({
        listOfResourceTypesWithDiagnosticLogsEnabled = {
          value = [
            "Microsoft.AnalysisServices/servers",
            "Microsoft.ApiManagement/service",
            "Microsoft.Network/applicationGateways",
            "Microsoft.Automation/automationAccounts",
            "Microsoft.ContainerInstance/containerGroups",
            "Microsoft.ContainerRegistry/registries",
            "Microsoft.ContainerService/managedClusters",
            "Microsoft.Batch/batchAccounts",
            "Microsoft.Cdn/profiles/endpoints",
            "Microsoft.CognitiveServices/accounts",
            "Microsoft.DocumentDB/databaseAccounts",
            "Microsoft.DataFactory/factories",
            "Microsoft.DataLakeAnalytics/accounts",
            "Microsoft.DataLakeStore/accounts",
            "Microsoft.EventGrid/eventSubscriptions",
            "Microsoft.EventGrid/topics",
            "Microsoft.EventHub/namespaces",
            "Microsoft.Network/expressRouteCircuits",
            "Microsoft.Network/azureFirewalls",
            "Microsoft.HDInsight/clusters",
            "Microsoft.Devices/IotHubs",
            "Microsoft.KeyVault/vaults",
            "Microsoft.Network/loadBalancers",
            "Microsoft.Logic/integrationAccounts",
            "Microsoft.Logic/workflows",
            "Microsoft.DBforMySQL/servers",
            "Microsoft.Network/networkInterfaces",
            "Microsoft.Network/networkSecurityGroups",
            "Microsoft.DBforPostgreSQL/servers",
            "Microsoft.PowerBIDedicated/capacities",
            "Microsoft.Network/publicIPAddresses",
            "Microsoft.RecoveryServices/vaults",
            "Microsoft.Cache/redis",
            "Microsoft.Relay/namespaces",
            "Microsoft.Search/searchServices",
            "Microsoft.ServiceBus/namespaces",
            "Microsoft.SignalRService/SignalR",
            "Microsoft.Sql/servers/databases",
            "Microsoft.Sql/servers/elasticPools",
            "Microsoft.StreamAnalytics/streamingjobs",
            "Microsoft.TimeSeriesInsights/environments",
            "Microsoft.Network/trafficManagerProfiles",
            "Microsoft.Compute/virtualMachines",
            "Microsoft.Compute/virtualMachineScaleSets",
            "Microsoft.Network/virtualNetworks",
            "Microsoft.Network/virtualNetworkGateways",
          ]
        }
      })
    },
    {
      name = "NIST SP 800-53 R4"
      id   = "/providers/Microsoft.Authorization/policySetDefinitions/cf25b9c1-bd23-4eb6-bd2c-f4f3ac644a5f"
      json_parameters = jsonencode({
        listOfResourceTypesWithDiagnosticLogsEnabled = {
          value = [
            "Microsoft.AnalysisServices/servers",
            "Microsoft.ApiManagement/service",
            "Microsoft.Network/applicationGateways",
            "Microsoft.Automation/automationAccounts",
            "Microsoft.ContainerInstance/containerGroups",
            "Microsoft.ContainerRegistry/registries",
            "Microsoft.ContainerService/managedClusters",
            "Microsoft.Batch/batchAccounts",
            "Microsoft.Cdn/profiles/endpoints",
            "Microsoft.CognitiveServices/accounts",
            "Microsoft.DocumentDB/databaseAccounts",
            "Microsoft.DataFactory/factories",
            "Microsoft.DataLakeAnalytics/accounts",
            "Microsoft.DataLakeStore/accounts",
            "Microsoft.EventGrid/eventSubscriptions",
            "Microsoft.EventGrid/topics",
            "Microsoft.EventHub/namespaces",
            "Microsoft.Network/expressRouteCircuits",
            "Microsoft.Network/azureFirewalls",
            "Microsoft.HDInsight/clusters",
            "Microsoft.Devices/IotHubs",
            "Microsoft.KeyVault/vaults",
            "Microsoft.Network/loadBalancers",
            "Microsoft.Logic/integrationAccounts",
            "Microsoft.Logic/workflows",
            "Microsoft.DBforMySQL/servers",
            "Microsoft.Network/networkInterfaces",
            "Microsoft.Network/networkSecurityGroups",
            "Microsoft.DBforPostgreSQL/servers",
            "Microsoft.PowerBIDedicated/capacities",
            "Microsoft.Network/publicIPAddresses",
            "Microsoft.RecoveryServices/vaults",
            "Microsoft.Cache/redis",
            "Microsoft.Relay/namespaces",
            "Microsoft.Search/searchServices",
            "Microsoft.ServiceBus/namespaces",
            "Microsoft.SignalRService/SignalR",
            "Microsoft.Sql/servers/databases",
            "Microsoft.Sql/servers/elasticPools",
            "Microsoft.StreamAnalytics/streamingjobs",
            "Microsoft.TimeSeriesInsights/environments",
            "Microsoft.Network/trafficManagerProfiles",
            "Microsoft.Compute/virtualMachines",
            "Microsoft.Compute/virtualMachineScaleSets",
            "Microsoft.Network/virtualNetworks",
            "Microsoft.Network/virtualNetworkGateways",
          ]
        }
        logAnalyticsWorkspaceIdforVMReporting = {
          value = dependency.compliance_storage.outputs.vm_management.log_analytics_workspace.workspace_id
        }
        listOfMembersToExcludeFromWindowsVMAdministratorsGroup = {
          value = "user"
        }
        listOfMembersToIncludeInWindowsVMAdministratorsGroup = {
          value = "adminuser"
        }
      })
    },
    {
      name = "ISO 27001:2013"
      id   = "/providers/Microsoft.Authorization/policySetDefinitions/89c6cddc-1c73-4ac1-b19c-54d1a15a42f2"
      json_parameters = jsonencode({
        listOfResourceTypesWithDiagnosticLogsEnabled = {
          value = [
            "Microsoft.AnalysisServices/servers",
            "Microsoft.ApiManagement/service",
            "Microsoft.Network/applicationGateways",
            "Microsoft.Automation/automationAccounts",
            "Microsoft.ContainerInstance/containerGroups",
            "Microsoft.ContainerRegistry/registries",
            "Microsoft.ContainerService/managedClusters",
            "Microsoft.Batch/batchAccounts",
            "Microsoft.Cdn/profiles/endpoints",
            "Microsoft.CognitiveServices/accounts",
            "Microsoft.DocumentDB/databaseAccounts",
            "Microsoft.DataFactory/factories",
            "Microsoft.DataLakeAnalytics/accounts",
            "Microsoft.DataLakeStore/accounts",
            "Microsoft.EventGrid/eventSubscriptions",
            "Microsoft.EventGrid/topics",
            "Microsoft.EventHub/namespaces",
            "Microsoft.Network/expressRouteCircuits",
            "Microsoft.Network/azureFirewalls",
            "Microsoft.HDInsight/clusters",
            "Microsoft.Devices/IotHubs",
            "Microsoft.KeyVault/vaults",
            "Microsoft.Network/loadBalancers",
            "Microsoft.Logic/integrationAccounts",
            "Microsoft.Logic/workflows",
            "Microsoft.DBforMySQL/servers",
            "Microsoft.Network/networkInterfaces",
            "Microsoft.Network/networkSecurityGroups",
            "Microsoft.DBforPostgreSQL/servers",
            "Microsoft.PowerBIDedicated/capacities",
            "Microsoft.Network/publicIPAddresses",
            "Microsoft.RecoveryServices/vaults",
            "Microsoft.Cache/redis",
            "Microsoft.Relay/namespaces",
            "Microsoft.Search/searchServices",
            "Microsoft.ServiceBus/namespaces",
            "Microsoft.SignalRService/SignalR",
            "Microsoft.Sql/servers/databases",
            "Microsoft.Sql/servers/elasticPools",
            "Microsoft.StreamAnalytics/streamingjobs",
            "Microsoft.TimeSeriesInsights/environments",
            "Microsoft.Network/trafficManagerProfiles",
            "Microsoft.Compute/virtualMachines",
            "Microsoft.Compute/virtualMachineScaleSets",
            "Microsoft.Network/virtualNetworks",
            "Microsoft.Network/virtualNetworkGateways",
          ]
        }
      })
    },
    {
      name = "CIS Microsoft Azure Foundations Benchmark 1.1.0"
      id   = "/providers/Microsoft.Authorization/policySetDefinitions/1a5bb27d-173f-493e-9568-eb56638dde4d"
      json_parameters = jsonencode({
        listOfRegionsWhereNetworkWatcherShouldBeEnabled = {
          value = [
            "australiaeast",
            "australiasoutheast",
          ]
        }
        listOfApprovedVMExtensions = {
          value = [
            "AzureDiskEncryption",
            "AzureDiskEncryptionForLinux",
            "DependencyAgentWindows",
            "DependencyAgentLinux",
            "IaaSAntimalware",
            "IaaSDiagnostics",
            "LinuxDiagnostic",
            "MicrosoftMonitoringAgent",
            "NetworkWatcherAgentLinux",
            "NetworkWatcherAgentWindows",
            "OmsAgentForLinux",
            "VMSnapshot",
            "VMSnapshotLinux",
          ]
        }
      })
    },
  ]
}
