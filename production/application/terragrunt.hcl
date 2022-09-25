
inputs = {
  force_helm_upgrade             = true
  certificate_issuer             = "letsencrypt-production-clusterissuer"
  webapp_image_repository        = "rg.fr-par.scw.cloud/le-portail/alterconso/webapp"
  webapp_image_tag               = "0.3.0"
  mailer_image_repository        = "rg.fr-par.scw.cloud/le-portail/alterconso/mailer"
  mailer_image_tag               = "0.1.7"
  webapp_vhost                   = "alterconso.leportail.org"
  webapp_ingress_host            = "alterconso.leportail.org"
  webapp_ingress_tls_host        = "alterconso.leportail.org"
  webapp_ingress_tls_secret_name = "alterconso.leportail.org-tls"
}

dependency "subsystems" {
  config_path = "../subsystems"
  skip_outputs = true
}

locals {
  # Automatically load account-level variables
  common_vars      = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  root_path    = local.common_vars.locals.root_path
  environment  = local.environment_vars.locals.environment
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
	source  = "${get_parent_terragrunt_dir()}/_modules/application///"

  extra_arguments "include_tfvars" {
    commands = get_terraform_commands_that_need_vars()
    required_var_files = [
      // "${get_parent_terragrunt_dir()}/development/application.tfvars"
    ]
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

provider "helm" {
  kubernetes {
    config_path = "${local.root_path}/${local.environment}/kubeconfig"
  }
}

terraform {
  required_providers {
    sops = {
      source = "carlpett/sops"
      version = "~> 0.5"
    }
  }
}

provider "sops" {}
EOF
}
