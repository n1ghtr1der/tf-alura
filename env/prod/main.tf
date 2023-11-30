module "aws-prod" {
  source = "../../infra"
  instance_type = "t2.micro"
  region_aws = "us-east-2"
  ssh_key = "default-key"
  sg_name = "sg-prod"
  min_size = 1
  max_size = 3
  group_name = prod-autoscaling
  production = true
}
