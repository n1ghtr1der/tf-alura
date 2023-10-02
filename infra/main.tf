terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  profile = "emirtonf"
  region = var.region_aws
}

resource "aws_instance" "terraform-teste" {
  ami = "ami-024e6efaf93d85776"
  instance_type = var.instance_type
  key_name = var.ssh_key
  tags = {
    Name = "Instance-Terraform"
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name = var.ssh_key
  public_key = file("${var.ssh_key}.pub")
}

output "public-ipv4" {
  value = aws_instance.terraform-teste.public_ip
}
