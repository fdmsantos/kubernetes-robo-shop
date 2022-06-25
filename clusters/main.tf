module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "3.14.0"
  name            = "${var.name_prefix}-vpc"
  cidr            = "10.0.0.0/16"
  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = []
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
}

module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "18.21.0"
  cluster_name                    = "${var.name_prefix}-cluster"
  cluster_version                 = "1.21"
  cluster_endpoint_private_access = false
  cluster_endpoint_public_access  = true
  cluster_addons = {
    //    coredns = {
    //      resolve_conflicts = "OVERWRITE"
    //    }
    kube-proxy = {}
    //    vpc-cni = {
    //      resolve_conflicts = "OVERWRITE"
    //    }
  }

  //  cluster_encryption_config = [{
  //    provider_key_arn = "ac01234b-00d9-40f6-ac95-e42345f78b00"
  //    resources        = ["secrets"]
  //  }]
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  //  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    disk_size      = 50
    instance_types = ["t3.medium"]
    #    key_name        = aws_key_pair.this.key_name
  }
  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }
  node_security_group_additional_rules = {
    ingress_all = {
      description      = "All Node Ports Open"
      protocol         = "tcp"
      from_port        = 30000
      to_port          = 40000
      type             = "ingress"
      cidr_blocks      = ["0.0.0.0/0"] # NOTE: Open to World!!! don't use in production
#      ipv6_cidr_blocks = ["::/0"]      # NOTE: Open to World!!! don't use in production
    }

    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }

    ingress_istio = {
      description      = "Kube APi Server to Istio deamon"
      protocol         = "tcp"
      from_port        = 15017
      to_port          = 15017
      type             = "ingress"
      cidr_blocks      = ["0.0.0.0/0"] # NOTE: Needs to be open only to EKS Master Security Group => Fix
    }

    ingress_elb_controller_webhook = {
      description      = "AWS ELB Controller Webhook"
      protocol         = "tcp"
      from_port        = 9443
      to_port          = 9443
      type             = "ingress"
      cidr_blocks      = ["0.0.0.0/0"] # NOTE: Needs to be open only to EKS Master Security Group => Fix
    }

    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
#      ipv6_cidr_blocks = ["::/0"]
    }
  }

  # aws-auth configmap
#  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/outscope-devops-role"
      username = "outscope-devops-role"
      groups   = ["eks-console-dashboard-full-access-group"]
    },
  ]
}

module "loadbalancer_role" {
  source                                 = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name                              = "AmazonEKSLoadBalancerControllerRole"
  attach_load_balancer_controller_policy = true
  oidc_providers = {
    one = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

module "external_dns_route53_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name                     = "AmazonEKSAllowExternalDNSUpdates"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = [data.aws_route53_zone.this.arn]
  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:external-dns"]
    }
  }
}