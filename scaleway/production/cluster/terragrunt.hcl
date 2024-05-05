
inputs = {
  registry_create    = true
  registry_name      = "le-portail"
  registry_is_public = true
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
	source  = "${get_parent_terragrunt_dir()}/_modules/cluster///"

  extra_arguments "include_tfvars" {
    commands = get_terraform_commands_that_need_vars()
    required_var_files = [
      // "${get_parent_terragrunt_dir()}/development/terraform.tfvars"
    ]
  }
}
