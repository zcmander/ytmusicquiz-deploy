# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
}

module "vpc" {
  source = "./vpc"
}

module "lb" {
  source = "./lb"

  access_sg_id = module.ecs.ecs_acces_sg_id

  vpc_id = module.vpc.vpc_id

  subnets = [
    module.vpc.subnet1_id,
    module.vpc.subnet2_id,
  ]
}

module "rds" {
  source = "./rds"

  vpc_id = module.vpc.vpc_id
}

module "ecr" {
  source = "./ecr"
}

module "ecs" {
  source = "./ecs"

  vpc_id = module.vpc.vpc_id

  subnet_id = module.vpc.subnet1_id

  db_access_sg_id = module.rds.db_access_sg_id

  rds_address = module.rds.rds_address
  rds_port = module.rds.rds_port
  rds_username = module.rds.rds_username
  rds_password = module.rds.rds_password

  lb_target_group_id = module.lb.lb_target_group_id
}