# Robo Shop
Repo for Kubernetes/AWS Training

## Kubectl Configuration

```bash
aws eks update-kubeconfig --region eu-west-1 --name robo-shop-cluster --profile outscope-tests

kubectl apply -f https://s3.us-west-2.amazonaws.com/amazon-eks/docs/eks-console-full-access.yaml
```

## Troubleshooting

```bash
kubectl run troubleshooting --image=praqma/network-multitool -i --tty -- sh
```

## WIP

* Implement RoboShop (With Gitops)
* Look for Kubernetes Patterns and implement
* Observability
* WAF, Cloudfront
* Data Analytics

## Study

* cert manager controller, secrets
* istio, Linkerd, consul, AWS App Mesh
* Envoy
* AWS DevOps Guru
* Knative, Calico
* Admission controllers
* Admission webhooks
* Initializers
* PodPresets