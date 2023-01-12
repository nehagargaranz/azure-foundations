locals {
  modules_folder = "${get_parent_terragrunt_dir()}/../modules//"
  module_name    = "vnet-hub"
  region         = element(split("/", path_relative_to_include()), 1)
}

terraform {
  source = "${local.modules_folder}${local.module_name}"
}

include {
  path = find_in_parent_folders()
}

dependency "compliance_settings" {
  config_path  = "../../global/compliance-settings"
  mock_outputs = try(yamldecode(file("${get_parent_terragrunt_dir()}/../modules/compliance-settings/mock_outputs.yaml")), {})
}

dependency "compliance_storage" {
  config_path  = "${get_parent_terragrunt_dir()}/compliance/global/compliance-storage"
  mock_outputs = try(yamldecode(file("${get_parent_terragrunt_dir()}/../modules/compliance-storage/mock_outputs.yaml")), {})
}

inputs = {
  compliance_storage                  = dependency.compliance_storage.outputs.compliance_storage
  network_watcher_name                = dependency.compliance_settings.outputs.network_watchers[local.region].name
  network_watcher_resource_group_name = dependency.compliance_settings.outputs.network_watcher_resource_group_name
}
