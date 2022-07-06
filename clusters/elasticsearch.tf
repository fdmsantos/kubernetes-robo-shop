data "aws_ami" "es-proxy" {
  count       = var.enable_elasticsearch ? 1 : 0
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["es-proxy-ami"]
  }
}

data "template_file" "user_data" {
  count    = var.enable_elasticsearch ? 1 : 0
  template = file("${path.module}/es-proxy/user-data.sh")
  vars = {
    DOMAIN_ENDPOINT = "robot-es.${var.domain}"
  }
}

resource "aws_security_group" "es_proxy" {
  count       = var.enable_elasticsearch ? 1 : 0
  name        = "es-proxy"
  description = "Security group to ES Proxy EC2"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Access From My PC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "es_proxy" {
  count              = var.enable_elasticsearch ? 1 : 0
  name               = "es-proxy-role"
  path               = "/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "es-proxy-profile" {
  count = var.enable_elasticsearch ? 1 : 0
  name  = "es-proxy-instance-profile"
  role  = aws_iam_role.es_proxy[0].name
}

resource "aws_iam_role_policy_attachment" "es_proxy_ssm" {
  count      = var.enable_elasticsearch ? 1 : 0
  role       = aws_iam_role.es_proxy[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

module "es-proxy" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  count                       = var.enable_elasticsearch ? 1 : 0
  name                        = "es-proxy"
  ami                         = data.aws_ami.es-proxy[0].id
  instance_type               = "t2.micro"
  iam_instance_profile        = aws_iam_instance_profile.es-proxy-profile[0].id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.es_proxy[0].id]
  subnet_id                   = module.vpc.public_subnets[0]
  user_data                   = data.template_file.user_data[0].rendered

}

module "elasticsearch" {
  source                          = "cloudposse/elasticsearch/aws"
  version                         = "0.35.1"
  count                           = var.enable_elasticsearch ? 1 : 0
  name                            = "robot-es"
  dns_zone_id                     = data.aws_route53_zone.this.id
  security_groups                 = [module.eks.node_security_group_id, aws_security_group.es_proxy[0].id]
  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = [module.vpc.public_subnets[0]]
  zone_awareness_enabled          = "false"
  availability_zone_count         = 2
  elasticsearch_version           = "OpenSearch_1.2"
  instance_type                   = "t3.medium.elasticsearch"
  instance_count                  = 1
  ebs_volume_size                 = 10
  encrypt_at_rest_enabled         = true
  kibana_hostname_enabled         = true
  kibana_subdomain_name           = "kibana"
  domain_hostname_enabled         = true
  custom_endpoint_enabled         = true
  custom_endpoint                 = "robot-es.${var.domain}"
  custom_endpoint_certificate_arn = module.acm.acm_certificate_arn
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }
}

resource "aws_elasticsearch_domain_policy" "all" {
  count           = var.enable_elasticsearch ? 1 : 0
  domain_name     = module.elasticsearch[0].domain_name
  access_policies = <<POLICIES
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "${module.elasticsearch[0].domain_arn}/*"
        }
    ]
}
POLICIES
}