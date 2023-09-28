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
  key_name = "default-key"
  tags = {
    Name = "Instance-Terraform"
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name = DEV
  public_key = file("${var.chave}.pub")
}

