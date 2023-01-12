include {
  path   = find_in_parent_folders()
  expose = true
}

dependency "management_group" {
  config_path  = "${get_parent_terragrunt_dir()}/tenancy/global/management-group"
  mock_outputs = try(yamldecode(file("${get_parent_terragrunt_dir()}/../modules/management-group/mock_outputs.yaml")), {})
}

inputs = {
  management_group_parent_id = dependency.management_group.outputs.management_group_id
  subscription_ids           = [include.inputs.subscription_id]
}
