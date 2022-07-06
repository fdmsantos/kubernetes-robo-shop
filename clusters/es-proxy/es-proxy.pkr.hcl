packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.9"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

data "amazon-ami" "this" {
  filters = {
    name                               = "*amzn2-ami-hvm-*"
    architecture                       = "x86_64"
    virtualization-type                = "hvm",
    "block-device-mapping.volume-type" = "gp2",
    root-device-type                   = "ebs"
  }
  owners      = ["amazon"]
  most_recent = true
}

source "amazon-ebs" "es-proxy" {
  ami_name              = "es-proxy-ami"
  source_ami            = data.amazon-ami.this.id
  instance_type         = "t2.micro"
  region                = "eu-west-1"
  ssh_username          = "ec2-user"
  force_deregister      = true
  force_delete_snapshot = true
  launch_block_device_mappings {
    device_name = "/dev/xvda"
    volume_size = 50
  }
}

build {
  sources = [
    "source.amazon-ebs.es-proxy"
  ]

  provisioner "shell" {
    // Updating Instance
    inline = [
      "sudo yum update -y"
    ]
  }

  provisioner "shell" {
    // Install nginx
    inline = [
      "sudo amazon-linux-extras install nginx1",
      #     "sudo rm /etc/nginx/nginx.conf"
    ]
  }

  provisioner "file" {
    // Upload Nginx Config File
    source      = "nginx-es-dashboards.conf"
    destination = "/tmp/nginx.conf"
  }

  provisioner "shell"{
    // Move Nginx Config
    inline = [
      "sudo mv /tmp/nginx.conf /etc/nginx/conf.d",
    ]
  }

}