include {
  path = find_in_parent_folders()
}

dependency "compliance_storage" {
  config_path  = "${get_parent_terragrunt_dir()}/compliance/global/compliance-storage"
  mock_outputs = try(yamldecode(file("${get_parent_terragrunt_dir()}/../modules/compliance-storage/mock_outputs.yaml")), {})
}

inputs = {
  compliance_storage = dependency.compliance_storage.outputs.compliance_storage
  vm_management      = dependency.compliance_storage.outputs.vm_management
}
