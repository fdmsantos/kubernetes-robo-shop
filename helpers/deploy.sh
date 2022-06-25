cd clusters
# Deploy EKS cluster
terraform init
AWS_PROFILE=outscope-tests terraform apply --auto-approve
# Configure Kubectl
aws eks update-kubeconfig --region eu-west-1 --name robotshop-cluster --profile outscope-tests
kubectl apply -f https://s3.us-west-2.amazonaws.com/amazon-eks/docs/eks-console-full-access.yaml # Migrate to gitops process
# Deploy Flux Components (GitOps)
kubectl apply -f flux-system/gotk-components.yaml
kubectl apply -f flux-system/gotk-sync.yaml