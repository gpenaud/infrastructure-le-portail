#
# development values
#

# infrastructure variable
project_id                               = "86278d55-bb4e-4c8d-9362-db91bb2e4fa3"
force_helm_upgrade                       = "true"
domain                                   = "leportail.org"
deploy_monitoring_stack                  = "false"
certificate_issuer                       = "letsencrypt-staging-clusterissuer"
grafana_ingress_hostname                 = "test.monitoring"
prometheus_server_ingress_hostname       = "test.monitoring.prometheus"
prometheus_alertmanager_ingress_hostname = "test.monitoring.alertmanager"

# application variables
webapp_vhost                             = "test.alterconso.leportail.org"
webapp_image_repository                  = "rg.fr-par.scw.cloud/le-portail/alterconso/webapp"
webapp_image_tag                         = "0.2.8"
webapp_ingress_host                      = "test.alterconso.leportail.org"
webapp_ingress_tls_host                  = "test.alterconso.leportail.org"
webapp_ingress_tls_secret_name           = "test.alterconso.leportail.org-tls"
mailer_image_repository                  = "rg.fr-par.scw.cloud/le-portail/alterconso/mailer"
mailer_image_tag                         = "0.1.2"
