module "aws-prod" {
  source = "../../infra"
  instance_type = "t2.micro"
  region_aws = "us-east-2"
  ssh_key = "prod"
  sg_name = "sg-prod"
}

output "ipv4" {
  value = module.aws-prod.public-ipv4
}
