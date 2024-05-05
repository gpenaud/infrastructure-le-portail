locals {
  default_values_path               = "${var.root_path}/_helm/alterconso/values.yaml"
  environment_values_path           = "${var.root_path}/${var.environment}/application/alterconso/values.yaml"
  environment_encrypted_values_path = "${var.root_path}/${var.environment}/application/alterconso/encrypted.yaml"
}

data "sops_file" "alterconso-webapp-secrets" {
  source_file = "${local.environment_encrypted_values_path}"
}

resource "helm_release" "alterconso" {
  name         = "alterconso"
  chart        = "${var.root_path}/_helm/alterconso"
  force_update = var.force_helm_upgrade
  timeout      = 120

  values = [
    "${file(local.default_values_path)}",
    "${file(local.environment_values_path)}"
  ]

  set {
    name  = "sops_smtp_user"
    value = data.sops_file.alterconso-webapp-secrets.data["smtp_user"]
  }

  set {
    name  = "sops_smtp_password"
    value = data.sops_file.alterconso-webapp-secrets.data["smtp_password"]
  }
}
