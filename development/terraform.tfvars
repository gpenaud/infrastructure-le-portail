# development values #
# ------------------ #

# cluster variable

registry_create    = true
registry_name      = "le-portail-development"
registry_is_public = true

# subsystems variables

force_helm_upgrade                       = true
domain                                   = "leportail.org"
deploy_monitoring_stack                  = false
deploy_application                       = false
certificate_issuer                       = "letsencrypt-staging-clusterissuer"
grafana_ingress_hostname                 = "development-monitoring"
prometheus_server_ingress_hostname       = "development-monitoring.prometheus"
prometheus_alertmanager_ingress_hostname = "development-monitoring.alertmanager"

# application variables

webapp_image_repository        = "rg.fr-par.scw.cloud/le-portail-development/alterconso/webapp"
webapp_image_tag               = "0.3.0"
mailer_image_repository        = "rg.fr-par.scw.cloud/le-portail-development/alterconso/mailer"
mailer_image_tag               = "0.1.4"
webapp_vhost                   = "development-alterconso.leportail.org"
webapp_ingress_host            = "development-alterconso.leportail.org"
webapp_ingress_tls_host        = "development-alterconso.leportail.org"
webapp_ingress_tls_secret_name = "development-alterconso.leportail.org-tls"
