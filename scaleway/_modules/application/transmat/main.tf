locals {
  environment_values_path           = "${var.root_path}/${var.environment}/application/transmat/values.yaml"
  environment_encrypted_values_path = "${var.root_path}/${var.environment}/application/transmat/encrypted.yaml"
}

# data "sops_file" "transmat-webapp-secrets" {
#   source_file = "${local.environment_encrypted_values_path}"
# }

resource "helm_release" "transmat" {
  name         = "transmat"
  repository   = "https://charts.bitnami.com/bitnami"
  chart        = "wordpress"
  force_update = var.force_helm_upgrade
  timeout      = 120

  values = [
    "${file(local.environment_values_path)}"
  ]

  # set {
  #   name  = "smtpUser"
  #   value = "alterconso@leportail.org"
  #   # value = data.sops_file.transmat-webapp-secrets.data["smtp_user"]
  # }

  # set {
  #   name  = "smtpPassword"
  #   value = "elisabeth"
  #   # value = data.sops_file.transmat-webapp-secrets.data["smtp_password"]
  # }
}
