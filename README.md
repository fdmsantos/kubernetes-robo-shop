# Robo Shop
Repo for Kubernetes/AWS Training

## Deploy

```bash
cd clusters
# Deploy EKS cluster
terraform init
AWS_PROFILE=outscope-tests terraform apply --auto-approve
# Configure Kubectl
aws eks update-kubeconfig --region eu-west-1 --name robotshop-cluster --profile outscope-tests
kubectl apply -f https://s3.us-west-2.amazonaws.com/amazon-eks/docs/eks-console-full-access.yaml
# Deploy Flux Components (GitOps)
kubectl apply -f flux-system/gotk-components.yaml
kubectl apply -f flux-system/gotk-sync.yaml
```

## Destroy

```bash
cd clusters
flux delete -s kustomization apps
flux delete -s kustomization infrastructure
flux delete -s kustomization istio-jaeger
flux delete -s kustomization istio-grafana
flux delete -s kustomization istio-kiali
flux delete -s kustomization istio-system
flux delete -s kustomization flux-system
flux delete -s kustomization aws-elb-controller
AWS_PROFILE=outscope-tests terraform destroy --auto-approve
```

## Troubleshooting

```bash
kubectl run troubleshooting --image=praqma/network-multitool -i --tty -- sh
```

## WIP

* Look for Kubernetes Patterns and implement
* Observability
* Data Analytics
  * Redshift
    * Several Users different access
  * Glue
  * EMR
    * Several users different access, kerberos....
    * Create image with packer
  * Kinesis
* Create Robot Automobile -> With Camera to read Traffic Velocity Signals, and change the velocity
* Robo Sensors => Temperature => Usar Data Analytics Techniques (Kinesis Data Streams, Kinesis Analytics with Randow Cut Fores Algo to find broken Sensors)
* Enable PSP => Pod Security Policy
* Alexa to Control Robos => Turn On/off Robo and sensors
* Use IOT => Robos are IOT Things
* Sentiment Analysis in Robo Comments
* Robo Recommend system based in Country?
* Pen testing
* Monitoring
  * Logs
  * ElasticSearch
* Web Deployment
  * WAF (via ACK)
  * Cloudfront (Via ACK)
  * Change service to Loadbalancer type
* Redis 
  * is SatefulSet
  * Create Several Replicas and Replicate?
  * Convert to Elasticache
* Rabbit MQ
  * Apply HTTPs to Rabbit MQ Management Portal
  * Create Secret (Secrets Manager) to Management Portal (same to Mongo DB and Mysql and others)
  * Tem Persistent Storage?
  * Convert to SQS?
* Mysql
  * Convert to RDS
  * Use DMS with CDC to simulate real migration
* Mongo DB
  * Convert to Manage AWS MongoDB
* Create VPNS
  * Site to Site
  * Client to Site
  * Transit Gateway
  * Give Access to Rabbit MQ Management Portal
* Scaling
  * HPA to deployments
  * Auto Scaling based in custom Metrics (Dispatch service based in rabbitmq messages)
  * Knative
* Move Cluster Nodes to private subnets
* Observability
  * SLOS, SLAS, SLI
  * Tracing (XRAY?)
  * Prometheus???
  * Grafana
* Monitoring
* DevOps Pipelines
* Service Mesh
  * Istio, Envoy
    * Encryption
    * Grafana
    * Flagger
      * https://ruzickap.github.io/k8s-flagger-istio-flux/
      * https://github.com/stefanprodan/gitops-istio/blob/main/istio/system/flagger.yaml
    * Put Add-ons via Istio Gateway
  * AWs App Mesh
  * Traffic Mirroring
  * Canary Deployments vs blue green in istio
    * https://fluxcd.io/flagger/tutorials/istio-progressive-delivery/
* Chaos Engineering

## Study

* cert manager controller, secrets
* AWS DevOps Guru
* Calico
* Admission controllers
* Admission webhooks
* Initializers
* PodPresets