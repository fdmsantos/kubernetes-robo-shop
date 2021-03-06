# Robo Shop
Repo for Kubernetes/AWS Training

## Main components

* Kubernetes Cluster: [EKS](https://aws.amazon.com/eks/)
* Deployment: 
  * [Terraform](https://www.terraform.io/)
  * [Packer](https://www.packer.io/)
* GitOps: [Flux](https://fluxcd.io/docs/get-started/)
* [Robot Shop App](https://github.com/instana/robot-shop)
* Service Mesh: [Istio](https://istio.io/)
  * [Kiali](https://kiali.io/)
  * [Jaeger](https://www.jaegertracing.io/)
  * [Grafana](https://grafana.com/)
  * [Prometheus](https://prometheus.io/)
* AWS AddOns
  * [AWS Route53 External DNS](https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/aws.md) 
  * [AWS Load Balancer Controller](https://github.com/kubernetes-sigs/aws-load-balancer-controller)
  * [AWS Cluster Autoscaler](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md)
* Amazon OpenSearch
  * With Nginx Proxy to access OpenSearch Dashboards

## Usage

* Pre-Requisites
  * Created Public Route53 Hosted Zone

* Deploy

```bash
./helpers/deploy.sh
```

* Destroy

```bash
./helpers/destroy.sh
```

* Troubleshooting

```bash
kubectl run troubleshooting --image=praqma/network-multitool -i --tty -- sh
```

## WIP

* Service Mesh
  * istio Flagger => Deloyment
    * https://ruzickap.github.io/k8s-flagger-istio-flux/
    * https://github.com/stefanprodan/gitops-istio/blob/main/istio/system/flagger.yaml
  * Traffic Mirroring
  * Canary Deployments vs blue green in istio
    * https://fluxcd.io/flagger/tutorials/istio-progressive-delivery/
* Monitoring
  * FluentD 
  * Logs
  * ElasticSearch
  * Alerting (Nagios)
* Observability
  * SLOS, SLAS, SLI
  * Tracing (XRAY?)
  * Prometheus???
  * Grafana
* Scaling
  * HPA to deployments
  * Metrics Server
  * Auto Scaling based in custom Metrics (Dispatch service based in rabbitmq messages)
  * Knative
* Chaos Engineering
* Move Cluster Nodes to private subnets
  * Create Fargate Profile (It's necessary private subnets)
  * Istio ALB should be internal
  * Move Elasticsearch too
* Fix Application
  * Implement Circuit breaking??
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
* Web Deployment
  * WAF (via ACK)
  * Cloudfront (Via ACK)
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
* DevOps Pipelines
  * [Skaffold](https://skaffold.dev/)
* Authentication
  * Integrate SAML (OpenSearch)

## Study

* cert manager controller, secrets
* AWS DevOps Guru
* Calico
* Admission controllers
* Admission webhooks
* Initializers
* PodPresets
* Harbor
* Open Policy Agent
* Rook
* Tuf