
# production manual deployment
helm --kubeconfig=kubeconfig upgrade alterconso ./../_helm/alterconso -f ./../_helm/alterconso/values.yaml \
  --set app.containers.webapp.image.repository=rg.fr-par.scw.cloud/le-portail/alterconso/webapp \
  --set app.containers.webapp.image.tag=0.3.0 \
  --set app.configuration.webapp.vhost=alterconso.leportail.org \
  --set app.containers.mailer.image.repository=rg.fr-par.scw.cloud/le-portail/alterconso/mailer \
  --set app.containers.mailer.image.tag=0.2.2 \
  --set app.cronjobs.opening-order.image_repository=rg.fr-par.scw.cloud/le-portail/alterconso/mailer \
  --set app.cronjobs.opening-order.image_tag=0.2.2 \
  --set app.cronjobs.closing-order.image_repository=rg.fr-par.scw.cloud/le-portail/alterconso/mailer \
  --set app.cronjobs.closing-order.image_tag=0.2.2 \
  --set app.ingress.hosts[0].host=alterconso.leportail.org \
  --set app.ingress.hosts[0].paths[0].path=/ \
  --set app.ingress.hosts[0].paths[0].pathType=Prefix \
  --set app.ingress.tls[0].hosts[0]=alterconso.leportail.org \
  --set app.ingress.tls[0].secretName=alterconso.leportail.org-tls \
  --set app.ingress.annotations.cert-manager\\.io/cluster-issuer=letsencrypt-production-clusterissuer \
  --set app.ingress.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname=alterconso.leportail.org \
  --set sops_smtp_user=alterconso@leportail.org \
  --set sops_smtp_password=elisabeth