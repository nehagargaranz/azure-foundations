include {
  path = find_in_parent_folders()
}

locals {
  region = element(split("/", path_relative_to_include()), 1)
}

dependency "compliance_storage" {
  config_path  = "${get_parent_terragrunt_dir()}/compliance/global/compliance-storage"
  mock_outputs = try(yamldecode(file("${get_parent_terragrunt_dir()}/../modules/compliance-storage/mock_outputs.yaml")), {})
}

dependency "private_link_dns_zone" {
  config_path  = "${get_parent_terragrunt_dir()}/hub/${local.region}/private-link-dns-zone"
  mock_outputs = try(yamldecode(file("${get_parent_terragrunt_dir()}/../modules/private-link-dns-zone/mock_outputs.yaml")), {})
}

inputs = {
  compliance_storage    = dependency.compliance_storage.outputs.compliance_storage
  function_app_identity = dependency.private_link_dns_zone.outputs.function_app_identity
  function_id           = dependency.private_link_dns_zone.outputs.function_id
}
