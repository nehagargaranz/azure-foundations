using namespace System.Net

# Input bindings are passed in via param block.
param($eventGridEvent, $TriggerMetadata)

Function Split-Fqdn ($Fqdn) {
    Write-Debug "Split-Fqdn - (Fqdn: $($Fqdn))" -Debug
    # Private DNS Zone reference data
    $PrivateDnsZones = @{
        'database.windows.net'        = 'privatelink.database.windows.net'
        'blob.core.windows.net'       = 'privatelink.blob.core.windows.net'
        'table.core.windows.net'      = 'privatelink.table.core.windows.net'
        'queue.core.windows.net'      = 'privatelink.queue.core.windows.net'
        'file.core.windows.net'       = 'privatelink.file.core.windows.net'
        'web.core.windows.net'        = 'privatelink.web.core.windows.net'
        'dfs.core.windows.net'        = 'privatelink.dfs.core.windows.net'
        'documents.azure.com'         = 'privatelink.documents.azure.com'
        'mongo.cosmos.azure.com'      = 'privatelink.mongo.cosmos.azure.com'
        'cassandra.cosmos.azure.com'  = 'privatelink.cassandra.cosmos.azure.com'
        'gremlin.cosmos.azure.com'    = 'privatelink.gremlin.cosmos.azure.com'
        'table.cosmos.azure.com'      = 'privatelink.table.cosmos.azure.com'
        'postgres.database.azure.com' = 'privatelink.postgres.database.azure.com'
        'mysql.database.azure.com'    = 'privatelink.mysql.database.azure.com'
        'mariadb.database.azure.com'  = 'privatelink.mariadb.database.azure.com'
        'vault.azure.net'             = 'privatelink.vaultcore.azure.net'
        'vaultcore.azure.net'         = 'privatelink.vaultcore.azure.net'
        "$($env:LOCATION).azmk8s.io"  = "privatelink.$($env:LOCATION).azmk8s.io"
        'azurecr.io'                  = 'privatelink.azurecr.io'
        'azconfig.io'                 = 'privatelink.azconfig.io'
        'servicebus.windows.net'      = 'privatelink.servicebus.windows.net'
        'eventgrid.azure.net'         = 'privatelink.eventgrid.azure.net'
        'azurewebsites.net'           = 'privatelink.azurewebsites.net'
        'api.azureml.ms'              = 'privatelink.api.azureml.ms'
        'service.signalr.net'         = 'privatelink.service.signalr.net'
        'azure-devices.net'           = 'privatelink.azure-devices.net'
    }

    $FqdnArray = $Fqdn.Split('.')

    $HostNameSegment = 1
    # Allow for two level hostname for web.core.windows.net and azmk8s.io
    If ($Fqdn -Like '*.web.core.windows.net' -Or $Fqdn -Like '*.azmk8s.io' -Or $Fqdn -Like '*.eventgrid.azure.net') {
        $HostNameSegment = 2
    }
    ElseIf ($Fqdn -Like '*.studio.workspace.*.api.azureml.ms') {
        $HostNameSegment = 4
    }
    ElseIf ($Fqdn -Like '*.data.azurecr.io' -Or $Fqdn -Like '*.api.azureml.ms') {
        $HostNameSegment = 3
    }

    $Domain = ($FqdnArray | Select-Object -Skip $HostNameSegment) -Join '.'
    Write-Debug "Split-Fqdn - Domain: $($Domain) (Id=$($TriggerMetadata.InvocationId))" -Debug
    $HostName = ($FqdnArray | Select-Object -First $HostNameSegment) -Join '.'
    Write-Debug "Split-Fqdn - HostName: $($HostName) (Id=$($TriggerMetadata.InvocationId))" -Debug

    # Get the private zone name from reference data
    If ($PrivateDnsZones.ContainsKey($Domain)) {
        $PrivateDnsZoneName = $PrivateDnsZones[$Domain]
    }
    Else {
        Throw "Private DNS Zone for $($Domain) Not Found"
    }

    Return @{ "HostName" = $HostName; "PrivateDnsZoneName" = $PrivateDnsZoneName }
}

Function Add-ResourceRecord ($PrivateEndpointId, $HostName, $PrivateDnsZoneName, $Ipv4Address, $Context) {
    Write-Debug "Add-ResourceRecord - (PrivateEndpointId: $($PrivateEndpointId)) (HostName: $($HostName)) (PrivateDnsZoneName: $($PrivateDnsZoneName)) (Ipv4Address: $($Ipv4Address)) (Id=$($TriggerMetadata.InvocationId))" -Debug

    $PrivateDnsZone = Get-AzPrivateDnsZone -AzContext $Context -ResourceGroupName $env:RESOURCE_GROUP_NAME -Name $PrivateDnsZoneName
    Write-Debug "Add-ResourceRecord - PrivateDnsZone: $($PrivateDnsZone | Format-List | Out-String) (Id=$($TriggerMetadata.InvocationId))" -Debug

    # Create or Update the record set
    Try {
        # Existing record set
        $PrivateDnsRecordSet = Get-AzPrivateDnsRecordSet -AzContext $Context -Name $HostName -RecordType A -Zone $PrivateDnsZone
    }
    Catch {
        # New record set
        Write-Debug "Add-ResourceRecord - Creating new PrivateDnsRecordSet (Id=$($TriggerMetadata.InvocationId))" -Debug
        $PrivateDnsRecordSet = New-AzPrivateDnsRecordSet -AzContext $Context -Name $HostName -RecordType A -Zone $PrivateDnsZone -Ttl 3600
    }
    Write-Debug "PrivateDnsRecordSet: $($PrivateDnsRecordSet | Format-List | Out-String) (Id=$($TriggerMetadata.InvocationId))" -Debug

    # Check if duplicate request / ip address
    If ($PrivateDnsRecordSet.Records.Ipv4Address -and $PrivateDnsRecordSet.Records.Ipv4Address.Contains($Ipv4Address)) {
        Write-Debug "Add-ResourceRecord - PrivateDnsRecordSet already contains $($Ipv4Address) (Id=$($TriggerMetadata.InvocationId))" -Debug
    }
    Else {
        # Add the ip address and save the record set
        Write-Debug "Add-ResourceRecord - Adding $($Ipv4Address) to PrivateDnsRecordSet (Id=$($TriggerMetadata.InvocationId))" -Debug
        Add-AzPrivateDnsRecordConfig -RecordSet $PrivateDnsRecordSet -Ipv4Address $Ipv4Address | Out-String | Write-Debug -Debug
        Write-Debug "Add-ResourceRecord - Saving PrivateDnsRecordSet (Id=$($TriggerMetadata.InvocationId))" -Debug
        Set-AzPrivateDnsRecordSet -AzContext $Context -RecordSet $PrivateDnsRecordSet | Out-String | Write-Debug -Debug

        # Store the resource id (and other information) in privateendpoint state table
        Add-StateTableEntry $PrivateEndpointId $HostName $PrivateDnsZoneName $Ipv4Address $Context
    }

    Write-Information "Add-ResourceRecord - Added DNS entry ($($PrivateDnsRecordSet.Name).$($PrivateDnsRecordSet.ZoneName)) for private endpoint ($($eventGridEvent.subject)) (Id=$($TriggerMetadata.InvocationId))"

    Return
}

Function Remove-ResourceRecord ($PrivateEndpointId, $HostName, $PrivateDnsZoneName, $Ipv4Address, $Context) {
    Write-Debug "Remove-ResourceRecord - (PrivateEndpointId: $($PrivateEndpointId)) (HostName: $($HostName)) (PrivateDnsZoneName: $($PrivateDnsZoneName)) (Ipv4Address: $($Ipv4Address)) (Id=$($TriggerMetadata.InvocationId))" -Debug

    # Get the dns zone and record set using data from the state table
    $PrivateDnsZone = Get-AzPrivateDnsZone -AzContext $Context -ResourceGroupName $env:RESOURCE_GROUP_NAME -Name $PrivateDnsZoneName
    Write-Debug "Remove-ResourceRecord - PrivateDnsZone: $($PrivateDnsZone | Format-List | Out-String) (Id=$($TriggerMetadata.InvocationId))" -Debug
    $PrivateDnsRecordSet = Get-AzPrivateDnsRecordSet -AzContext $Context -Name $HostName -RecordType A -Zone $PrivateDnsZone
    Write-Debug "Remove-ResourceRecord - PrivateDnsRecordSet: $($PrivateDnsRecordSet | Format-List | Out-String) (Id=$($TriggerMetadata.InvocationId))" -Debug

    # Remove the IP address and save the record set
    Write-Debug "Remove-ResourceRecord - Removing $($Ipv4Address) from PrivateDnsRecordSet (Id=$($TriggerMetadata.InvocationId))" -Debug
    Remove-AzPrivateDnsRecordConfig -RecordSet $PrivateDnsRecordSet -Ipv4Address $Ipv4Address | Out-String | Write-Debug -Debug

    # If this is the last Record in the record set, then remove the record set
    If ($PrivateDnsRecordSet.Records.Ipv4Address) {
        Write-Debug "Remove-ResourceRecord - Saving PrivateDnsRecordSet (Id=$($TriggerMetadata.InvocationId))" -Debug
        Set-AzPrivateDnsRecordSet -AzContext $Context -RecordSet $PrivateDnsRecordSet | Out-String | Write-Debug -Debug
    }
    Else {
        Write-Debug "Remove-ResourceRecord - Removing PrivateRecordSet (Id=$($TriggerMetadata.InvocationId))" -Debug
        Remove-AzPrivateDnsRecordSet -AzContext $Context -RecordSet $PrivateDnsRecordSet | Out-String | Write-Debug -Debug
    }

    Remove-StateTableEntry $PrivateEndpointId $HostName $PrivateDnsZoneName $Ipv4Address $Context

    Write-Information "Remove-ResourceRecord - Removed DNS entry ($($PrivateDnsRecordSet.Name).$($PrivateDnsRecordSet.ZoneName)) for private endpoint ($($eventGridEvent.subject)) (Id=$($TriggerMetadata.InvocationId))"

    Return
}

Function Add-StateTableEntry ($PrivateEndpointId, $HostName, $PrivateDnsZoneName, $Ipv4Address, $Context) {
    Write-Debug "Add-StateTableEntry - (PrivateEndpointId: $($PrivateEndpointId)) (HostName: $($HostName)) (PrivateDnsZoneName: $($PrivateDnsZoneName)) (Ipv4Address: $($Ipv4Address)) (Id=$($TriggerMetadata.InvocationId))" -Debug

    $StorageAccount = Get-AzStorageAccount -AzContext $Context -ResourceGroupName $env:RESOURCE_GROUP_NAME -Name $env:STORAGE_ACCOUNT_NAME
    Write-Debug "Add-StateTableEntry - StorageAccount: $($StorageAccount | Format-List | Out-String) (Id=$($TriggerMetadata.InvocationId))" -Debug

    $CloudTable = (Get-AzStorageTable –Name $env:STORAGE_TABLE_NAME –Context $StorageAccount.Context).CloudTable
    Write-Debug "Add-StateTableEntry - CloudTable: $($CloudTable | Format-List | Out-String) (Id=$($TriggerMetadata.InvocationId))" -Debug

    $TableRow = Add-AzTableRow -Table $CloudTable -PartitionKey ($PrivateEndpointId).Replace('/', '_').ToUpper() -RowKey $Ipv4Address -Property @{ "PrivateDnsZoneName" = $PrivateDnsZoneName; "HostName" = $HostName; "Ipv4Address" = $Ipv4Address; "PrivateEndpointId" = $PrivateEndpointId; "InvocationId" = $TriggerMetadata.InvocationId }
    Write-Debug "Add-StateTableEntry - TableRow: $($TableRow | Format-List | Out-String) (Id=$($TriggerMetadata.InvocationId))" -Debug
    Return
}

Function Get-StateTableEntries ($PrivateEndpointId, $Context) {
    Write-Debug "Get-StateTableEntries - (PrivateEndpointId: $($PrivateEndpointId)) (Id=$($TriggerMetadata.InvocationId))" -Debug

    $StorageAccount = Get-AzStorageAccount -AzContext $LocalContext -ResourceGroupName $env:RESOURCE_GROUP_NAME -Name $env:STORAGE_ACCOUNT_NAME
    Write-Debug "Get-StateTableEntries - StorageAccount: $($StorageAccount | Format-List | Out-String) (Id=$($TriggerMetadata.InvocationId))" -Debug

    $CloudTable = (Get-AzStorageTable –Name $env:STORAGE_TABLE_NAME –Context $StorageAccount.Context).CloudTable
    Write-Debug "Get-StateTableEntries - CloudTable: $($CloudTable | Format-List | Out-String) (Id=$($TriggerMetadata.InvocationId))" -Debug

    $TableEntries = Get-AzTableRow -Table $CloudTable -PartitionKey ($PrivateEndpointId).Replace('/', '_').ToUpper()
    Write-Debug "Get-StateTableEntries - TableEntries: $($TableEntries | Format-List | Out-String) (Id=$($TriggerMetadata.InvocationId))" -Debug

    Return $TableEntries
}

Function Remove-StateTableEntry ($PrivateEndpointId, $HostName, $PrivateDnsZoneName, $Ipv4Address, $Context) {
    Write-Debug "Remove-StateTableEntry - (PrivateEndpointId: $($PrivateEndpointId)) (HostName: $($HostName)) (PrivateDnsZoneName: $($PrivateDnsZoneName)) (Ipv4Address: $($Ipv4Address)) (Id=$($TriggerMetadata.InvocationId))" -Debug

    $StorageAccount = Get-AzStorageAccount -AzContext $Context -ResourceGroupName $env:RESOURCE_GROUP_NAME -Name $env:STORAGE_ACCOUNT_NAME
    Write-Debug "Remove-StateTableEntry - StorageAccount: $($StorageAccount | Format-List | Out-String) (Id=$($TriggerMetadata.InvocationId))" -Debug

    $CloudTable = (Get-AzStorageTable –Name $env:STORAGE_TABLE_NAME –Context $StorageAccount.Context).CloudTable
    Write-Debug "Remove-StateTableEntry - CloudTable: $($CloudTable | Format-List | Out-String) (Id=$($TriggerMetadata.InvocationId))" -Debug

    Return Remove-AzTableRow -Table $CloudTable -PartitionKey ($PrivateEndpointId).Replace('/', '_').ToUpper() -RowKey $Ipv4Address
}

# Allowed Operations
$Operations = @(
    'Microsoft.Network/privateEndpoints/write',
    'Microsoft.Network/privateEndpoints/delete'
)

Try {
    # Default response code
    $Status = 0

    Write-Debug "eventGridEvent: $($eventGridEvent | ConvertTo-Json -Compress)" -Debug

    # Check if operation is in list of allowed operations
    If ($Operations.Contains($eventGridEvent.data.operationName)) {
        Write-Information "Event matches whitelisted operations $($eventGridEvent.data.operationName) (Id=$($TriggerMetadata.InvocationId))"

        # Store the Local and Remote Subscription contexts for later
        $LocalContext = Set-AzContext -SubscriptionId $env:SUBSCRIPTION_ID
        Write-Debug "LocalContext: $($LocalContext | Format-List | Out-String) (Id=$($TriggerMetadata.InvocationId))" -Debug
        $RemoteContext = Set-AzContext -SubscriptionId $eventGridEvent.data.subscriptionId
        Write-Debug "RemoteContext: $($RemoteContext | Format-List | Out-String) (Id=$($TriggerMetadata.InvocationId))" -Debug

        Switch ($eventGridEvent.eventType) {
            'Microsoft.Resources.ResourceWriteSuccess' {

                Write-Information "$($eventGridEvent.eventType) event received (Id=$($TriggerMetadata.InvocationId))"

                Try {
                    # Get the private endpoint resource
                    $PrivateEndpoint = (Get-AzResource -AzContext $RemoteContext -ResourceId $eventGridEvent.data.resourceUri | Get-AzPrivateEndpoint)
                    Write-Debug "PrivateEndpoint: $($PrivateEndpoint | Format-List | Out-String) (Id=$($TriggerMetadata.InvocationId))" -Debug
                }
                Catch {
                    # If the resource can't be resolved
                    $Status = 0
                }

                # Confirm event location
                If ($PrivateEndpoint -And $PrivateEndpoint.Location -eq $env:LOCATION) {
                    Write-Debug "PrivateEndpoint Location matches $($env:LOCATION) (Id=$($TriggerMetadata.InvocationId))" -Debug

                    ForEach ($PrivateLinkServiceConnection in $PrivateEndpoint.PrivateLinkServiceConnections) {
                        # Get the resource type of the linked service
                        $PrivateLinkServiceId = $PrivateLinkServiceConnection.PrivateLinkServiceId
                        Write-Debug "PrivateLinkServiceId: $($PrivateLinkServiceId) (Id=$($TriggerMetadata.InvocationId))" -Debug

                        If ($PrivateLinkServiceId -Like '*Microsoft.ContainerService/managedClusters*') {
                            Write-Debug "Resource Type is Microsoft.ContainerService/managedClusters"

                            $PrivateLinkService = Get-AzResource -AzContext $RemoteContext -ResourceId $PrivateLinkServiceId
                            Write-Debug "PrivateLinkService: $($PrivateLinkService | Format-List | Out-String)" -Debug

                            $ManagedCluster = $PrivateLinkService | Get-AzAks
                            Write-Debug "ManagedCluster: $($ManagedCluster | Format-List | Out-String)" -Debug

                            $SplitFqdn = Split-Fqdn($ManagedCluster.PrivateFQDN)
                            Add-ResourceRecord $PrivateEndpoint.Id $SplitFqdn.HostName $SplitFqdn.PrivateDnsZoneName $PrivateEndpoint.CustomDnsConfigs[0].Ipv4Addresses[0] $LocalContext
                        }

                        Else {
                            Write-Debug "Resource Type is other"

                            $CustomDnsConfigs = $PrivateEndpoint.CustomDnsConfigs
                            Write-Debug "CustomDnsConfigs: $($CustomDnsConfigs | Format-List | Out-String) (Id=$($TriggerMetadata.InvocationId))" -Debug

                            ForEach ($Config in $CustomDnsConfigs) {
                                $SplitFqdn = Split-Fqdn $Config.Fqdn
                                # TODO: Validate this works
                                Write-Debug "SplitFqdn Result: $($SplitFqdn | Format-List | Out-String)" -Debug
                                Write-Debug "SplitFqdn Result PrivateDnsZoneName: $($SplitFqdn.PrivateDnsZoneName)" -Debug
                                Write-Debug "SplitFqdn Result HostName: $($SplitFqdn.HostName)" -Debug
                                Add-ResourceRecord $PrivateEndpoint.Id $SplitFqdn.HostName $SplitFqdn.PrivateDnsZoneName $Config.IpAddresses[0] $LocalContext
                            }
                        }
                    }

                    $Status = 0
                }

                Else {
                    Write-Debug "PrivateEndpoint Location does not match $($env:LOCATION) (Id=$($TriggerMetadata.InvocationId))" -Debug
                }

                Write-Information "$($eventGridEvent.eventType) response sent (Id=$($TriggerMetadata.InvocationId))"
            }

            'Microsoft.Resources.ResourceDeleteSuccess' {

                Write-Information "$($eventGridEvent.eventType) event received (Id=$($TriggerMetadata.InvocationId))"

                # Read record from privateendpoint state table
                $TableRows = Get-StateTableEntries $eventGridEvent.data.resourceUri $Context
                Write-Debug "Get-StateTableEntries Result: $($TableRows | Format-Table | Out-String)" -Debug

                ForEach ($TableRow in $TableRows) {
                    Write-Debug "Removing Resource Record for: $($TableRow.PrivateEndpointId) $($TableRow.HostName) $($TableRow.PrivateDnsZoneName) $($TableRow.Ipv4Address) (Id=$($TriggerMetadata.InvocationId))"
                    Remove-ResourceRecord $TableRow.PrivateEndpointId $TableRow.HostName $TableRow.PrivateDnsZoneName $TableRow.Ipv4Address $LocalContext
                }

                $Status = 0
                Write-Information "$($eventGridEvent.eventType) response sent (Id=$($TriggerMetadata.InvocationId))"
            }
        }
    }
}
Catch {
    Write-Debug $_ -Debug
    $Status = 1
}
Finally {
    Write-Information "Status: $($Status) (Id=$($TriggerMetadata.InvocationId))"
    Write-Debug "eventGridEvent: $($eventGridEvent | Format-List | Out-String) (Id=$($TriggerMetadata.InvocationId))" -Debug

    exit $Status
}
