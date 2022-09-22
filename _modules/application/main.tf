data "sops_file" "alterconso-webapp-secrets" {
  source_file = "${var.root_path}/_helm/alterconso/sops-secrets.yaml"
}

resource "helm_release" "alterconso" {
  name         = "alterconso"
  chart        = "${var.root_path}/_helm/alterconso"
  force_update = var.force_helm_upgrade
  timeout      = 120

  set {
    name  = "app.configuration.webapp.vhost"
    value = var.webapp_vhost
  }

  set {
    name  = "app.containers.webapp.image.repository"
    value = var.webapp_image_repository
  }

  set {
    name  = "app.containers.webapp.image.tag"
    value = var.webapp_image_tag
  }

  set {
    name  = "app.containers.mailer.image.repository"
    value = var.mailer_image_repository
  }

  set {
    name  = "app.containers.mailer.image.tag"
    value = var.mailer_image_tag
  }

  set {
    name  = "app.ingress.hosts[0].host"
    value = var.webapp_ingress_host
  }

  set {
    name  = "app.ingress.hosts[0].paths[0].path"
    value = "/"
  }

  set {
    name  = "app.ingress.hosts[0].paths[0].pathType"
    value = "Prefix"
  }

  set {
    name  = "app.ingress.tls[0].hosts[0]"
    value = var.webapp_ingress_tls_host
  }

  set {
    name  = "app.ingress.tls[0].secretName"
    value = var.webapp_ingress_tls_secret_name
  }

  set {
    name  = "app.ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = var.certificate_issuer
  }

  set {
    name  = "app.ingress.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname"
    value = "development-alterconso.leportail.org"
  }

  set {
    name  = "sops_smtp_user"
    value = data.sops_file.alterconso-webapp-secrets.data["smtp_user"]
  }

  set {
    name  = "sops_smtp_password"
    value = data.sops_file.alterconso-webapp-secrets.data["smtp_password"]
  }
}
