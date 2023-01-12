include {
  path = find_in_parent_folders()
}

dependency "compliance_storage" {
  config_path  = "${get_parent_terragrunt_dir()}/compliance/global/compliance-storage"
  mock_outputs = try(yamldecode(file("${get_parent_terragrunt_dir()}/../modules/compliance-storage/mock_outputs.yaml")), {})
}

dependency "hub" {
  config_path  = "../vnet"
  mock_outputs = try(yamldecode(file("${get_parent_terragrunt_dir()}/../modules/vnet-hub/mock_outputs.yaml")), {})
}

inputs = {
  compliance_storage  = dependency.compliance_storage.outputs.compliance_storage
  resource_group_name = dependency.hub.outputs.resource_group_name
  subnet_id           = dependency.hub.outputs.subnets.GatewaySubnet.id
}
