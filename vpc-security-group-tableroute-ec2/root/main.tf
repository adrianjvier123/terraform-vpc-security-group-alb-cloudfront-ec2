#configure aws provider
provider "aws" {
  region = var.region
#  profile = "cloud_user"
}

# create module vpc

module "vpc" {
  source = "../modules/vpc"
  region = var.region
  project_name = var.project_name
  vpc_cidr = var.vpc_cidr
  public_subnet_az1_cidr = var.public_subnet_az1_cidr
  public_subnet_az2_cidr = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr = var.private_app_subnet_az2_cidr
}

module "security_groups" {
  source = "../modules/security_groups"
  vpc_id = module.vpc.vpc_id #hace referencia la modulo vpc, que tiene como OUTPUT el id de la vpc en la variable vpc_id
  my_public_ip_1 = var.my_public_ip_1
}


module "ec2" {
  source = "../modules/ec2"
  ami = var.ami
  instance_type = var.instance_type
  public_subnet_az1_id = module.vpc.public_subnet_az1_id
  public_subnet_az2_id = module.vpc.public_subnet_az2_id
  sg_allow_tls_id = module.security_groups.sg_allow_tls_id
  private_app_subnet_az1_id = module.vpc.private_app_subnet_az1_id
  vpc_id = module.vpc.vpc_id
}

module "elastic_ip" {
  source = "../modules/elastic_ip"
  ec2_web_page_totem_id = module.ec2.ec2_web_page_totem_id
}