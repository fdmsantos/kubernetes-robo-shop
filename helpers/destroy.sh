flux delete -s kustomization apps
flux delete -s kustomization infrastructure
flux delete -s kustomization istio-jaeger
flux delete -s kustomization istio-grafana
flux delete -s kustomization istio-kiali
flux delete -s kustomization istio-system
flux delete -s kustomization flux-system
flux delete -s kustomization aws-elb-controller
flux delete -s kustomization external-dns-route53
cd clusters
AWS_PROFILE=outscope-tests terraform destroy --auto-approve