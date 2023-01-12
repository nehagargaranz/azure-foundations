include {
  path = find_in_parent_folders()
}

dependency "spoke" {
  config_path  = "../vnet"
  mock_outputs = try(yamldecode(file("${get_parent_terragrunt_dir()}/../modules/vnet-spoke/mock_outputs.yaml")), {})
}

inputs = {
  resource_group_name = dependency.spoke.outputs.resource_group_name
  subnets             = [for subnet in dependency.spoke.outputs.subnets : subnet.id]
}
