module "iam" {
  source         = "../../modules/iam"
  iam_group_name = var.iam_group_name
}

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
  DB_PASSWORD                      = var.DB_PASSWORD
  BUCKET_NAME                      = var.BUCKET_NAME
  aws_lb_target_group_arn          = module.loadbalancer.aws_lb_target_group_arn
}

module "loadbalancer" {
  source               = "../../modules/loadbalancer"
  vpc_id               = module.network.vpc_id
  public_subnets_id    = module.network.public_subnets_id
  lb_security_group_id = module.security.lb_security_group_id
}

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
  source     = "../../modules/storage"
  depends_on = [module.iam]
}

module "rds" {
  source               = "../../modules/rds"
  mysql_db_name        = var.mysql_db_name
  mysql_username       = var.mysql_username
  mysql_password       = var.mysql_password
  private_subnet_ids   = module.network.private_subnets_ids
  db_security_group_id = module.security.db_security_group_id
  db_availability_zone = var.db_availability_zone
  depends_on           = [module.iam]
}