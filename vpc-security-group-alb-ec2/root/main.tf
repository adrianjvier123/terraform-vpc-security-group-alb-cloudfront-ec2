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
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr
}

module "security_groups" {
  source = "../modules/security_groups"
  vpc_id = module.vpc.vpc_id #hace referencia la modulo vpc, que tiene como OUTPUT el id de la vpc en la variable vpc_id
}

module "ec2" {
  source = "../modules/ec2"
  ami = var.ami
  instance_type = var.instance_type
  public_subnet_az1_id = module.vpc.public_subnet_az1_id
  public_subnet_az2_id = module.vpc.public_subnet_az2_id
  sg_allow_tls_id = module.security_groups.sg_allow_tls_id
  private_app_subnet_az1_id = module.vpc.private_app_subnet_az1_id
  sg_allow_http_id = module.security_groups.sg_allow_http_id
  vpc_id = module.vpc.vpc_id
  efs_dns_name = module.efs.efs_dns_name
  efs_mount_target = module.efs.efs_mount_target
  efs_mount_2_target = module.efs.efs_mount_2_target
}


module "alb"{
    source = "../modules/alb"
    ec2_id = module.ec2.ec2_id
    ec2_2_id = module.ec2.ec2_2_id
    sg_alb_tls_id = module.security_groups.sg_alb_tls_id
    private_app_subnet_az1_id = module.vpc.private_app_subnet_az1_id
    private_app_subnet_az2_id = module.vpc.private_app_subnet_az2_id
    vpc_id = module.vpc.vpc_id
    public_subnet_az1_id = module.vpc.public_subnet_az1_id
}

# module "db" {
#   source = "../modules/rds"
#   db_security_group_id  = module.security_groups.sg_db_to_ec2_id
#   private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
#   private_data_subnet_az2_id = module.vpc.private_data_subnet_az2_id
# }

module "cloudwatch" {
  source = "../modules/cloudwatch"
  aws_lb_target_group_app_arn_suffix = module.alb.aws_lb_target_group_app_arn_suffix
  alb_app_web1_arn_suffix = module.alb.alb_app_web1_arn_suffix
  SNS_CPU_Utilization_arn = module.sns.SNS_CPU_Utilization_arn
}

module "sns" {
  source = "../modules/sns"
}

module "efs" {
  source = "../modules/efs"
  public_subnet_az1_id = module.vpc.public_subnet_az1_id
  sg_allow_tls_id = module.security_groups.sg_allow_tls_id
  public_subnet_az2_id = module.vpc.public_subnet_az2_id
}

module "s3" {
  source = "../modules/s3"
  bucket_wp_name = var.bucket_wp_name
}