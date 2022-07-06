export AWS_REGION=eu-west-1
cd clusters/es-proxy
# Run Packer
packer init es-proxy.pkr.hcl
AWS_PROFILE=outscope-tests packer build es-proxy.pkr.hcl
# Deploy EKS cluster
cd ..
terraform init
AWS_PROFILE=outscope-tests terraform apply --auto-approve
# Configure Kubectl
aws eks update-kubeconfig --region eu-west-1 --name robotshop-cluster --profile outscope-tests
kubectl apply -f https://s3.us-west-2.amazonaws.com/amazon-eks/docs/eks-console-full-access.yaml # Migrate to gitops process