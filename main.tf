provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/24"
}

module "subnets" {
  source         = "./modules/subnet"
  vpc_id         = module.vpc.vpc_id
  public_cidr    = "10.0.0.0/25"
  private_cidr   = "10.0.0.128/25"
  az             = "ap-south-1a"
}

module "networking" {
  source            = "./modules/networking"
  vpc_id            = module.vpc.vpc_id
  public_subnet_id  = module.subnets.public_subnet_id
  private_subnet_id = module.subnets.private_subnet_id
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}

module "ec2_public" {
  source            = "./modules/ec2"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.subnets.public_subnet_id
  sg_id             = module.security.public_sg_id
  key_name          = var.key_name
  associate_public  = true
  server_type       = "nginx"
}

module "ec2_private" {
  source            = "./modules/ec2"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.subnets.private_subnet_id
  sg_id             = module.security.private_sg_id
  key_name          = var.key_name
  associate_public  = false
  server_type       = "tomcat"
}
