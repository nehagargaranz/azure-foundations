include {
  path = find_in_parent_folders()
}

dependency "hub" {
  config_path  = "../vnet"
  mock_outputs = try(yamldecode(file("${get_parent_terragrunt_dir()}/../modules/vnet-hub/mock_outputs.yaml")), {})
}

inputs = {
  resource_group_name = dependency.hub.outputs.resource_group_name
  subnets             = [for subnet in dependency.hub.outputs.subnets : subnet.id if !contains(["AzureBastionSubnet", "AzureFirewallSubnet"], subnet.name)]
}
