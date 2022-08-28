terraform {
  required_providers {
    sops = {
      source = "carlpett/sops"
      version = "~> 0.5"
    }
  }
}


data "sops_file" "alterconso-webapp-secrets" {
  source_file = "${path.root}/helm/alterconso/sops-secrets.yaml"
}

resource "helm_release" "alterconso" {
  name         = "cert-manager-issuer"
  chart        = "${path.root}/helm/cert-manager-issuer"
  force_update = var.force_helm_upgrade

  set {
    name  = "app.configuration.webapp.vhost"
    value = "alterconso.leportail.org"
  }

  set {
    name  = "app.containers.webapp.image.repository"
    value = "rg.fr-par.scw.cloud/le-portail/alterconso/webapp"
  }

  set {
    name  = "app.configuration.webapp.image.tag"
    value = "0.2.8"
  }

  set {
    name  = "app.containers.webapp.image.repository"
    value = "rg.fr-par.scw.cloud/le-portail/alterconso/mailer"
  }

  set {
    name  = "app.containers.mailer.image.tag"
    value = "0.1.2"
  }

  set {
    name  = "app.ingress.hosts[1].host"
    value = "alterconso.leportail.org"
  }

  set {
    name  = "app.ingress.hosts[1].paths[0].path"
    value = "/"
  }

  set {
    name  = "app.ingress.hosts[1].paths[0].pathType"
    value = "Prefix"
  }

  set {
    name  = "app.ingress.tls[1].hosts[0]"
    value = "alterconso.leportail.org"
  }

  set {
    name  = "app.ingress.tls[1].secretName"
    value = "alterconso.leportail.org-tls"
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
