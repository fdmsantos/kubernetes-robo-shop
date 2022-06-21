# Robo Shop
Repo for Kubernetes/AWS Training

## Deploy

```bash
cd clusters
# Deploy EKS cluster
terraform init
AWS_PROFILE=outscope-tests terraform apply --auto-approve
# Configure Kubectl
aws eks update-kubeconfig --region eu-west-1 --name robo-shop-cluster --profile outscope-tests
kubectl apply -f https://s3.us-west-2.amazonaws.com/amazon-eks/docs/eks-console-full-access.yaml
# Deploy Flux Components (GitOps)
kubectl apply -f flux-system/gotk-components.yaml
kubectl apply -f flux-system/gotk-sync.yaml
```

## Troubleshooting

```bash
kubectl run troubleshooting --image=praqma/network-multitool -i --tty -- sh
```

## WIP

* Look for Kubernetes Patterns and implement
* Observability
* WAF, Cloudfront
* Data Analytics
* Create Robot Automobile -> With Camera to read Traffic Velocity Signals, and change the velocity
* Robo Sensors => Temperature => Usar Data Analytics Techniques (Kinesis Data Streams, Kinesis Analytics with Randow Cut Fores Algo to find broken Sensors)
* Enable PSP => Pod Security Policy
* Alexa to Control Robos => Turn On/off Robo and sensors
* Use IOT => Robos are IOT Things
* Sentiment Analysis in Robo Comments
* Robo Recommend system based in Country?
* Pen testing
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
* Apply HPA to deployments
* Move Cluster Nodes to private subnets
* 
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