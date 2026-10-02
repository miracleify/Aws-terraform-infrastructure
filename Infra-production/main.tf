module "network" {
  source = "./modules/network"

  project_name          = var.project_name
  environment           = var.environment
  nat_eip_allocation_id = var.nat_eip_allocation_id
  vpc_cidr              = var.vpc_cidr
  availability_zones    = var.availability_zones
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  db_subnet_cidrs       = var.db_subnet_cidrs

}

module "security" {
  source = "./modules/security"

  vpc_id       = module.network.vpc_id
  project_name = var.project_name
  environment  = var.environment

  app_port = var.app_port
}

module "alb" {
  source = "./modules/alb"

  project_name = var.project_name
  environment  = var.environment
  app_port     = var.app_port

  vpc_id         = module.network.vpc_id
  public_subnets = module.network.public_subnets
  alb_sg_id      = module.security.alb_sg_id

  acm_certificate_arn = var.acm_certificate_arn
}

module "registry" {
  source = "./modules/registry"

  project_name = var.project_name
  environment  = var.environment

  repo_name = var.ecr_repo_name
}


module "compute" {
  source = "./modules/compute"

  project_name = var.project_name
  environment  = var.environment
  node_env     = var.node_env

  private_subnets = module.network.private_subnets
  ecs_sg_id       = module.security.ecs_sg_id

  target_group_arn = module.alb.target_group_arn

  ecr_image   = var.ecr_image
  secrets_arn = var.secrets_arn

  ecs_desired_count = var.ecs_desired_count
  app_port          = var.app_port

  autoscaling_min_capacity = var.autoscaling_min_capacity
  autoscaling_max_capacity = var.autoscaling_max_capacity
}

module "database" {
  count  = var.enable_rds ? 1 : 0
  source = "./modules/database"

  project_name = var.project_name
  environment  = var.environment

  db_subnets = module.network.db_subnets
  rds_sg_id  = module.security.rds_sg_id

  db_username = var.db_username
  db_password = var.db_password
}


module "security_services" {
  source = "./modules/security_services"

  project_name = var.project_name
  environment  = var.environment

  alb_arn = module.alb.alb_arn
}


module "monitoring" {
  source = "./modules/monitoring"

  project_name = var.project_name
  environment  = var.environment

  alb_arn_suffix = module.alb.alb_arn_suffix
  waf_name       = "${var.project_name}-waf-${var.environment}"

  ecs_cluster_arn = module.compute.ecs_cluster_arn

  alert_email = var.alert_email
  alert_phone = var.alert_phone

  enable_slack      = var.enable_slack
  slack_webhook_url = var.slack_webhook_url

  enable_discord      = var.enable_discord
  discord_webhook_url = var.discord_webhook_url
}



module "cache" {
  source = "./modules/cache"

  project_name = var.project_name
  environment  = var.environment

  vpc_id          = module.network.vpc_id
  private_subnets = module.network.private_subnets

  ecs_sg_id = module.security.ecs_sg_id
}