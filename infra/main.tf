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

resource "aws_launch_template" "terraform-template-ec2" {
  image_id = "ami-024e6efaf93d85776"
  instance_type = var.instance_type
  key_name = var.ssh_key
  tags = {
    Name = "TF Ansible Python"
  }
  security_group_names = [ var.sg_name ]
}

output "public-ipv4" {
  value = aws_instance.terraform-teste.public_ip
}
