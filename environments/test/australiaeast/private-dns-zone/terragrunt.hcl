include {
  path = find_in_parent_folders()
}

locals {
  environment = element(split("/", path_relative_to_include()), 0)
  region      = element(split("/", path_relative_to_include()), 1)
}

dependency "compliance_storage" {
  config_path  = "${get_parent_terragrunt_dir()}/compliance/global/compliance-storage"
  mock_outputs = try(yamldecode(file("${get_parent_terragrunt_dir()}/../modules/compliance-storage/mock_outputs.yaml")), {})
}

dependency "hub" {
  config_path  = "${get_parent_terragrunt_dir()}/hub/${local.region}/vnet"
  mock_outputs = try(yamldecode(file("${get_parent_terragrunt_dir()}/../modules/vnet-hub/mock_outputs.yaml")), {})
}

dependency "spoke" {
  config_path  = "../vnet"
  mock_outputs = try(yamldecode(file("${get_parent_terragrunt_dir()}/../modules/vnet-spoke/mock_outputs.yaml")), {})
}

inputs = {
  compliance_storage      = dependency.compliance_storage.outputs.compliance_storage
  private_dns_zone_prefix = "${local.region}.${local.environment}"
  virtual_network_links = {
    hub = {
      virtual_network_name = dependency.hub.outputs.virtual_network_name
      virtual_network_id   = dependency.hub.outputs.virtual_network_id
      registration_enabled = false
    },
    spoke = {
      virtual_network_name = dependency.spoke.outputs.virtual_network_name
      virtual_network_id   = dependency.spoke.outputs.virtual_network_id
      registration_enabled = true
    }
  }
}
