# Infrastructure

A tiny repository to manage alterconso webapp infrastrucure, hosted by scaleway
in France.

### Deploys the whole infrastructure

This command deploys "test" version of infrastructure (cert-manager as staging)
and enforce helm to redeploy
```
terraform apply -auto-approve -var='force_helm_upgrade=true'
```

### Deploys the system components

- cert-manager and its resources
- harpin-protocol
- prometheus & prometheus-operator (optional)
- grafana & grafana-operator (optional)

This command deploys "test" version of infrastructure (cert-manager as staging)
and enforce helm to redeploy

```
terraform apply -auto-approve -target='module.layer_system' -var='force_helm_upgrade=true'
```
