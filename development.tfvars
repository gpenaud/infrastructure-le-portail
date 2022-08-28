#
# development values
#
project_id                               = "b2c4f829-56fe-4c2f-95be-1b7d089cc399"
force_helm_upgrade                       = "true"
domain                                   = "leportail.org"
deploy_monitoring_stack                  = "true"
certificate_issuer                       = "letsencrypt-staging-clusterissuer"
grafana_ingress_hostname                 = "test.monitoring"
prometheus_server_ingress_hostname       = "test.monitoring.prometheus"
prometheus_alertmanager_ingress_hostname = "test.monitoring.alertmanager"
