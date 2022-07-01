terraform {
  required_version = ">= 0.12"
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
    }
    flux = {
      source  = "fluxcd/flux"
    }
  }
}

provider "github" {
  owner = var.github_user
  token = var.github_token
}

provider "aws" {
  region                      = "eu-west-1"
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
  }
}

#provider "helm" {
#  kubernetes {
#    config_path = "~/.kube/config"
#  }
#}