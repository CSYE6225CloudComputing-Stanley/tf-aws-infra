// step1
module "iam" {
  source         = "../../modules/iam"
  iam_group_name = var.iam_group_name
}

# // step2
module "role" {
  source = "../../modules/role"
}

// step3
module "kms" {
  source        = "../../modules/kms"
  ec2_role_name = module.role.ec2_iam["role_name"]
  depends_on    = [module.iam]
}

// step4
module "network" {
  source               = "../../modules/network"
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  vpc_name             = var.vpc_name
}

module "routing" {
  source               = "../../modules/routing"
  vpc_id               = module.network.vpc_id
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnets_id    = module.network.public_subnets_id
  private_subnets_id   = module.network.private_subnets_ids
  internet_gateway_id  = module.network.internet_gateway_id
}

module "security" {
  source = "../../modules/security"
  vpc_id = module.network.vpc_id
  my_ip  = var.my_ip
}
module "storage" {
  source        = "../../modules/storage"
  depends_on    = [module.iam]
  kms_s3_key_id = module.kms.kms_arns["s3"]
}

module "rds" {
  source                    = "../../modules/rds"
  db_name                   = var.DB_NAME
  db_username               = var.DB_USERNAME
  private_subnet_ids        = module.network.private_subnets_ids
  db_security_group_id      = module.security.db_security_group_id
  db_availability_zone      = var.db_availability_zone
  depends_on                = [module.iam]
  kms_rds_key_id            = module.kms.kms_arns["rds"]
  kms_secret_manager_key_id = module.kms.kms_arns["secrets_manager"]
}



// step5
module "ec2" {
  source                           = "../../modules/ec2"
  key_name                         = var.key_name
  ami_id                           = var.ami_id
  instance_type                    = var.instance_type
  webapp_instance_public_subnet_id = module.network.public_subnets_id[0]
  security_group_id                = module.security.security_group_id
  DB_HOST                          = var.DB_HOST
  DB_NAME                          = var.DB_NAME
  DB_USERNAME                      = var.DB_USERNAME
  BUCKET_NAME                      = var.BUCKET_NAME
  aws_lb_target_group_arn          = module.loadbalancer.aws_lb_target_group_arn
  ec2_profile_name                 = module.role.ec2_iam["instance_profile_name"]
  kms_ec2_id                       = module.kms.kms_arns["ec2"]
  region                           = var.aws_region
  secret_manager_name              = module.rds.rds_password_secret_name
}

module "loadbalancer" {
  source               = "../../modules/loadbalancer"
  vpc_id               = module.network.vpc_id
  public_subnets_id    = module.network.public_subnets_id
  lb_security_group_id = module.security.lb_security_group_id
  ssl_cert_arn         = var.ssl_cert_arn
}