flux delete -s kustomization apps
flux delete -s kustomization ingress-infrastructure
flux delete -s kustomization istio-infrastructure
flux delete -s kustomization aws-elb-controller
flux delete -s kustomization external-dns-route53
flux delete -s kustomization cluster-autoscaler-controller
flux delete -s kustomization istio-system
cd clusters
AWS_PROFILE=outscope-tests terraform destroy --auto-approve