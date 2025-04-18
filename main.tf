module "vpc" {
  source       = "./modules/vpc"
  for_each = var.vpc
  vpc_cidr = lookup(each.value,"vpc_cidr", null  )
  env           = var.env
  project_name = var.project_name
}