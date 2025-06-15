# module "vpc" {
#   source                       = "./modules/vpc"
#   for_each                     = var.vpc
#   vpc_cidr                     = lookup(each.value,"vpc_cidr", null  )
#   public_subnets_cidr          = lookup(each.value,"public_subnets_cidr", null )
#   web_subnets_cidr             = lookup(each.value,"web_subnets_cidr", null )
#   app_subnets_cidr             = lookup(each.value,"app_subnets_cidr", null )
#   db_subnets_cidr              = lookup(each.value,"db_subnets_cidr", null )
#   az                           = lookup(each.value,"az", null )
#
#   env                          = var.env
#   project_name                 = var.project_name
# }
#
# module "rds" {
#   source       =   "./modules/rds"
#   for_each     = var.rds
#   allocated_storage = lookup(each.value,"allocated_storage", null  )
#   db_name           = lookup(each.value,"db_name", null  )
#   engine            = lookup(each.value,"engine", null  )
#   engine_version    = lookup(each.value,"engine_version", null  )
#   family            = lookup(each.value,"family", null  )
#   instance_class    = lookup(each.value,"instance_class", null  )
#
#   env               = var.env
#   project_name      = var.project_name
#   kms_key_id        = var.kms_key_id
#   # the subnets_ids are we are looking for db_subnets_cidr in vpc main module so that that rds sits only in db2 instances
#   subnets_ids       = lookup(lookup(module.vpc, "main", null ),"db_subnets_ids",null)
#   vpc_id            = lookup(lookup(module.vpc, "main", null ),"vpc_id",null)
#   sg_cidr_blocks    = lookup(lookup(var.vpc,"main",null),"app_subnets_ids",null)
# }
# module "backend" {
#   source    = "./modules/app"
#   for_each  = var.app
#   env              = var.env
#   project_name      = var.project_name
#   app_port          = lookup(each.value,"app_port", null  )
#   bastion_cidrs     = lookup(each.value,"bastion_cidrs", null  )
#   component         = lookup(each.value,"component", null  )
#   instance_capacity = lookup(each.value,"instance_capacity", null  )
#   instance_type     = lookup(each.value,"instance_type", null  )
#   vpc_zone_identifier = lookup(lookup(module.vpc, "main", null ),"app_subnets_ids",null) # were to sit
#   sg_cidr_blocks    = lookup(lookup(var.vpc,"main",null),"app_subnets_ids",null) # who should acess
#   vpc_id            = lookup(lookup(module.vpc, "main", null ),"vpc_id",null) # which vpc
# }
# module "frontend" {
#   source    = "./modules/app"
#   for_each  = var.app
#   env              = var.env
#   project_name      = var.project_name
#   app_port          = lookup(each.value,"app_port", null  )
#   bastion_cidrs     = lookup(each.value,"bastion_cidrs", null  )
#   component         = lookup(each.value,"component", null  )
#   instance_capacity = lookup(each.value,"instance_capacity", null  )
#   instance_type     = lookup(each.value,"instance_type", null  )
#   vpc_zone_identifier = lookup(lookup(module.vpc, "main", null ),"web_subnets_ids",null)
#   sg_cidr_blocks    = lookup(lookup(var.vpc,"main",null),"web_subnets_ids",null)
#   vpc_id            = lookup(lookup(module.vpc, "main", null ),"vpc_id",null)
# }
# module "app" {
#   source              = "./modules/app"
#   for_each            = var.app
#
#   env                 = var.env
#   project_name        = var.project_name
#   component           = lookup(each.value, "component", null)
#   app_port            = lookup(each.value, "app_port", null)
#   instance_capacity   = lookup(each.value, "instance_capacity", null)
#   instance_type       = lookup(each.value, "instance_type", null)
#   bastion_cidrs       = lookup(each.value, "bastion_cidrs", null)
#
#   vpc_id              = module.vpc["main"].vpc_id
#
#   # Conditional subnet and CIDR assignment
#   vpc_zone_identifier = each.key == "frontend" ? module.vpc["main"].public_subnets_ids : module.vpc["main"].app_subnets_ids
#   sg_cidr_blocks      = each.key == "frontend" ? var.vpc["main"].public_subnets_cidr : var.vpc["main"].app_subnets_cidr
# }
#
#
#
# module "public-alb" {
#
#   source = "./modules/alb"
#   alb_name    = "public"
#   internal    = false
#   sg_cidr_blocks = ["0.0.0.0/0"]
#
#   env         = var.env
#   project_name = var.project_name
#   acm_arn      = var.acm_arn
#   dns_name     = "frontend"
#   zone_id      = var.zone_id
#
#   subnets = module.vpc["main"].public_subnets_ids
#   vpc_id  = module.vpc["main"].vpc_id
#   target_group_arn =  module.app["frontend"].target_group_arn
#
# }
# module "private-alb" {
#
#   source = "./modules/alb"
#   alb_name    = "private"
#   internal    = false
#   sg_cidr_blocks = lookup(lookup(var.vpc, "main", null), "web_subnets_ids", null)  # it is which we are allowing to access
#
#   env         = var.env
#   project_name = var.project_name
#   acm_arn      = var.acm_arn
#   dns_name     = "backend"
#   zone_id      = var.zone_id
#
#   subnets = module.vpc["main"].app_subnets_ids #where it should be created.
#   vpc_id  = module.vpc["main"].vpc_id
#   target_group_arn =  module.app["backend"].target_group_arn
#
# }

module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnets_cidr = var.public_subnets_cidr
  web_subnets_cidr    = var.web_subnets_cidr
  app_subnets_cidr    = var.app_subnets_cidr
  db_subnets_cidr     = var.db_subnets_cidr
  az                  = var.az

  env          = var.env
  project_name = var.project_name
}

module "rds" {
  source = "./modules/rds"

  allocated_storage = var.rds_allocated_storage
  dbname            = var.rds_dbname
  engine            = var.rds_engine
  engine_version    = var.rds_engine_version
  family            = var.rds_family
  instance_class    = var.rds_instance_class

  env          = var.env
  project_name = var.project_name
  kms_key_id   = var.kms_key_id

  subnet_ids     = module.vpc.app_subnets_ids
  vpc_id         = module.vpc.vpc_id
  sg_cidr_blocks = var.app_subnets_cidr
}

module "backend" {
  depends_on         = [module.rds] #after rds it runs so we use depends on keyword
  source              = "./modules/app"
  env                 = var.env
  project_name        = var.project_name
  component           = "backend"
  app_port            = var.backend_app_port
  instance_capacity   = var.backend_instance_capacity
  instance_type       = var.backend_instance_type
  bastion_cidrs       = var.bastion_cidrs
  sg_cidr_blocks      = var.app_subnets_cidr           # who can access backend
  vpc_zone_identifier = module.vpc.app_subnets_ids     # where backend instances will run
  vpc_id              = module.vpc.vpc_id
  parameters          =["arn:aws:ssm:us-east-1:522814736516:parameter/${var.env}.${var.project_name}.rds.*", "arn:aws:ssm:us-east-1:522814736516:parameter/newrelic.*"]
  kms                 = var.kms_key_id
  prometheus_cidrs    = var.prometheus_cidrs
}

module "frontend" {
  source              = "./modules/app"
  env                 = var.env
  project_name        = var.project_name
  component           = "frontend"
  app_port            = var.frontend_app_port
  instance_capacity   = var.frontend_instance_capacity
  instance_type       = var.frontend_instance_type
  bastion_cidrs       = var.bastion_cidrs
  sg_cidr_blocks      = var.public_subnets_cidr        # who can access frontend (usually 0.0.0.0/0)
  vpc_zone_identifier = module.vpc.web_subnets_ids     # where frontend instances will run
  vpc_id              = module.vpc.vpc_id
  parameters          = ["arn:aws:ssm:us-east-1:522814736516:parameter/newrelic.*"]
  kms                 = var.kms_key_id
  prometheus_cidrs    = var.prometheus_cidrs
}


module "public-alb" {
  source = "./modules/alb"

  alb_name       = "public"
  internal       = false
  sg_cidr_blocks = ["0.0.0.0/0"]
  dns_name       = "frontend"

  project_name = var.project_name
  env          = var.env
  acm_arn      = var.acm_arn
  zone_id      = var.zone_id

  subnets          = module.vpc.public_subnets_ids
  vpc_id           = module.vpc.vpc_id
  target_group_arn = module.frontend.target_group_arn

}

module "private-alb" {
  source = "./modules/alb"

  alb_name = "private"
  internal = true
  dns_name = "backend"

  sg_cidr_blocks = var.web_subnets_cidr
  project_name   = var.project_name
  env            = var.env
  acm_arn        = var.acm_arn
  zone_id        = var.zone_id

  subnets          = module.vpc.app_subnets_ids
  vpc_id           = module.vpc.vpc_id
  target_group_arn = module.backend.target_group_arn

}