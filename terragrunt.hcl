# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Automatically load account-level variables
  common_vars      = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  project_name = local.environment_vars.locals.project_name
  profile      = local.environment_vars.locals.profile
  zone         = local.environment_vars.locals.zone
  region       = local.environment_vars.locals.region
  environment  = local.environment_vars.locals.environment
  root_path    = local.common_vars.locals.root_path
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
}

provider "scaleway" {
  zone       = "${local.zone}"
  region     = "${local.region}"
  profile    = "${local.profile}"
}
EOF
}



remote_state {
  backend = "local"
  config = {
    path = "${path_relative_to_include()}/terraform.tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.

inputs = merge(
  local.common_vars.locals,
  local.environment_vars.locals
)
