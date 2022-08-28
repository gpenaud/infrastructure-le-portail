#
# production values
#
project_id                               = "341d39c7-1613-45d9-8b9f-e3c001c46cb0"
force_helm_upgrade                       = "true"
domain                                   = "leportail.org"
deploy_monitoring_stack                  = "false"
certificate_issuer                       = "letsencrypt-production-clusterissuer"
grafana_ingress_hostname                 = "monitoring"
prometheus_server_ingress_hostname       = "monitoring.prometheus"
prometheus_alertmanager_ingress_hostname = "monitoring.alertmanager"
