locals {
  modules_folder = "${get_parent_terragrunt_dir()}/../modules//"
  module_name    = "vnet-spoke"
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

dependency "hub" {
  config_path  = "${get_parent_terragrunt_dir()}/hub/${local.region}/vnet"
  mock_outputs = try(yamldecode(file("${get_parent_terragrunt_dir()}/../modules/vnet-hub/mock_outputs.yaml")), {})
}

inputs = {
  compliance_storage                      = dependency.compliance_storage.outputs.compliance_storage
  hub_virtual_network_id                  = dependency.hub.outputs.virtual_network_id
  hub_virtual_network_name                = dependency.hub.outputs.virtual_network_name
  hub_virtual_network_resource_group_name = dependency.hub.outputs.resource_group_name
  hub_subscription_id                     = dependency.hub.outputs.subscription_id
  dns_forwarder_ip_address                = dependency.hub.outputs.dns_forwarder_ip_address
  network_watcher_name                    = dependency.compliance_settings.outputs.network_watchers[local.region].name
  network_watcher_resource_group_name     = dependency.compliance_settings.outputs.network_watcher_resource_group_name
}
