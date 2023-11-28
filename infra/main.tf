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
  user_data = filebase64("ansible.sh")
}

resource "aws_autoscaling_group" "autoscaling-group" {
  availability_zones = [ "${var.region_aws}a", "${var.region_aws}b" ]
  name = var.group_name
  max_size = var.max_size
  min_size = var.min_size
  launch_template {
    id = aws_launch_template.terraform-template-ec2.id
    version = "$Latest"
  }
  target_group_arns = aws_lb_target_group.lb_target_group.arn
}

resource "aws_default_subnet" "subnet_1" {
  availability_zone = "${var.region_aws}a"
}

resource "aws_default_subnet" "subnet_2" {
  availability_zone = "${var.region_aws}b"
}

resource "aws_lb" "load_balancer" {
  internal = false
  subnets = [ aws_default_subnet.subnet_1, aws_default_subnet.subnet_2 ]
}

resource "aws_lb_target_group" "lb_target_group" {
  name = "target_instances"
  port = "8000"
  protocol = "HTTP"
  vpc_id = aws_vpc.vpc_default.id
}

resource "aws_vpc" "vpc_default" {
  
}

resource "aws_lb_listener" "listener_lb" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port = "8000"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn 
  }
}