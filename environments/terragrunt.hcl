terraform_version_constraint  = "= ${chomp(file("../.terraform-version"))}"
terragrunt_version_constraint = "= ${chomp(file("../.terragrunt-version"))}"

locals {
  modules_folder = "${get_parent_terragrunt_dir()}/../modules//"
  module_name    = basename(get_terragrunt_dir()) # Use the module with the same name as the terragrunt folder name

  paths_to_include = [
    # Get a list of indexes between zero and the max number of folders; i.e. [0,1,2]
    for index in range(0, length(split("/", path_relative_to_include()))) :
    # Create a string for each folder by joining the folder elements together
    # between zero and the end index
    join("/", slice(split("/", path_relative_to_include()), 0, index + 1))
  ]
  yaml_files = flatten([
    # List the yaml files in the top level folder, these will always apply
    fileset(".", "*.{yaml,yml}"),
    # List all the yaml files, include them if they're in the paths_to_include
    [for file in fileset(".", "**/*.{yaml,yml}") : file if contains(local.paths_to_include, dirname(file))]
  ])
  inputs = merge(
    # Decode and merge all the yaml files
    merge([for file in local.yaml_files : try(yamldecode(file(file)), {})]...),
    # environment is the first folder under `environments/`
    { environment = element(split("/", path_relative_to_include()), 0) },
    # resource_prefix is the hyphenated terragrunt path
    { resource_prefix = replace(path_relative_to_include(), "/", "-") },
  )
}

terraform {
  source = "${local.modules_folder}${local.module_name}"

  # Force Terraform to not ask for input value if some variables are undefined.
  extra_arguments "disable_input" {
    commands  = get_terraform_commands_that_need_input()
    arguments = ["-input=false"]
  }

  # Force Terraform to keep trying to acquire a lock for up to 20 minutes if someone else already has the lock
  extra_arguments "retry_lock" {
    commands  = get_terraform_commands_that_need_locking()
    arguments = ["-lock-timeout=20m"]
  }

  extra_arguments "upgrade" {
    commands  = ["init"]
    arguments = ["-upgrade"]
  }
}

inputs = local.inputs

remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    resource_group_name  = local.inputs.terraform_state_resource_group_name
    storage_account_name = local.inputs.terraform_state_storage_account_name
    container_name       = local.inputs.terraform_state_container_name
    subscription_id      = local.inputs.terraform_state_subscription_id
    key                  = "${path_relative_to_include()}/terraform.tfstate"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
variable "subscription_id" {}
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  partner_id      = "59e2c354-c7ea-52ea-9d8a-675c75658243"
}
EOF
}

# Don't use the root terragrunt.hcl file directly
skip = true
