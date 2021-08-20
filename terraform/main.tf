terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*20*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


data "aws_ami" "redhat" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-8*-*-x86_64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["309956199498"] # RedHat
}


data "aws_ami" "redhat_arm64" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-8*-*-arm64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["309956199498"] # RedHat
}


data "aws_vpc" "default" {
    default = true
} 

data "aws_security_group" "allow_ssh_anywhere" {
  name = "ssh_only"
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.yml")
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [data.aws_security_group.allow_ssh_anywhere.id]
  associate_public_ip_address = true
  user_data                   = data.template_file.user_data.rendered

  tags = {
    Name = var.vm_name,
    Owner = var.owner_name,
    Environment = "Test",
    Purpose = "Runner",
    Expiration = "",
    Dependancy = "No"
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}