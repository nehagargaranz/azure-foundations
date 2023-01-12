include {
  path = find_in_parent_folders()
}

dependency "management_group" {
  config_path  = "../management-group"
  mock_outputs = try(yamldecode(file("${get_parent_terragrunt_dir()}/../modules/management-group/mock_outputs.yaml")), {})
}

dependencies {
  paths = ["../service-principal"]
}

inputs = {
  scope = dependency.management_group.outputs.management_group_id
}

skip = true
