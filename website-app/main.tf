
# configure aws provider
provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# create vpc
module "vpc" {
  source                       = "../modules/vpc"
  region                       = var.region
  project_name                 = var.project_name
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_subnet_az1_cidr      = var.private_subnet_az1_cidr
  private_subnet_az2_cidr      = var.private_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr
}

module "security_group" {
  source = "../modules/security-groups"
  vpc_id = module.vpc.vpc_id
}

module "az1_ec2" {
  source             = "../modules/ecs"
  instance_type      = var.instance_type
  subnet_id          = module.vpc.private_app_subnet_az1_id
  security_group_ids = [module.security_group.ssh_security_group_id]
  tag_name           = "AZ1 EC2"
}

module "az2_ec2" {
  source             = "../modules/ecs"
  instance_type      = var.instance_type
  subnet_id          = module.vpc.private_app_subnet_az2_id
  security_group_ids = [module.security_group.ecs_security_group_id]
  tag_name           = "AZ2 EC2"
}

module "public_ec2" {
  source             = "../modules/ecs"
  instance_type      = var.instance_type
  subnet_id          = module.vpc.public_subnet_az1_id
  security_group_ids = [module.security_group.alb_security_group_id]
  tag_name           = "Public EC2"
}