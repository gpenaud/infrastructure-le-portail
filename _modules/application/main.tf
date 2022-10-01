locals {
  default_values_path = "${var.root_path}/_helm/alterconso/values.yaml"
}

data "sops_file" "alterconso-webapp-secrets" {
  source_file = "${var.root_path}/_helm/alterconso/sops-secrets.yaml"
}

resource "helm_release" "alterconso" {
  name         = "alterconso"
  chart        = "${var.root_path}/_helm/alterconso"
  force_update = var.force_helm_upgrade
  timeout      = 120

  values = [
    "${file(local.default_values_path)}",
    "${file(var.environment_values_file)}"
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
