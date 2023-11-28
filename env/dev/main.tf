module "aws-dev" {
  source = "../../infra"
  instance_type = "t2.micro"
  region_aws = "us-east-2"
  ssh_key = "default-key"
  sg_name = "sg-dev"
}

output "ipv4" {
  value = module.aws-dev.public-ipv4
}
