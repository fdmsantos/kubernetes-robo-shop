# Robo Shop
Repo for Kubernetes/AWS Training

## Main components

* Deployment: [Terraform](https://www.terraform.io/)
* GitOps: [Flux](https://fluxcd.io/docs/get-started/)
* [Robot Shop App](https://github.com/instana/robot-shop)
* Service Mesh: [Istio](https://istio.io/)
* AWS AddOns
  * [AWS Route53 External DNS](https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/aws.md) 
  * [AWS Load Balancer Controller](https://github.com/kubernetes-sigs/aws-load-balancer-controller)

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
* Harbor
* Open Policy Agent
* Rook
* Tuf