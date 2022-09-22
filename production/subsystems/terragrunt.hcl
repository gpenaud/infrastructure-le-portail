
inputs = {
  force_helm_upgrade                       = true
  domain                                   = "leportail.org"
  lb_nginx_ip                              = dependency.cluster.outputs.lb_nginx_ip
  deploy_monitoring_stack                  = false
  deploy_application                       = false
  certificate_issuer                       = "letsencrypt-production-clusterissuer"
  grafana_ingress_hostname                 = "monitoring"
  prometheus_server_ingress_hostname       = "monitoring.prometheus"
  prometheus_alertmanager_ingress_hostname = "monitoring.alertmanager"
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
	source  = "${get_parent_terragrunt_dir()}/_modules/subsystems///"

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

dependency "cluster" {
  config_path = "../cluster"

  mock_outputs_allowed_terraform_commands = ["destroy"]
  mock_outputs = {
    lb_nginx_ip = {
      zone = ""
      ip_address = ""
    }
  }
  // skip_outputs = true
}
