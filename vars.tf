# #common for each module
# variable "env" {}
# variable "project_name" {}
# variable "kms_key_id" {}
# variable "bastion_cidrs" {}
# variable "acm_arn" {}
#
# #different type of modules
# variable "vpc" {}
# variable "rds" {}
# variable "app" {}
# variable "zone_id" {}

variable "env" {}
variable "project_name" {}
variable "kms_key_id" {}
variable "bastion_cidrs" {}
variable "prometheus_cidrs" {}

variable "vpc_cidr" {}
variable "public_subnets_cidr" {}
variable "web_subnets_cidr" {}
variable "app_subnets_cidr" {}
variable "db_subnets_cidr" {}
variable "az" {}
variable "rds_allocated_storage" {}
variable "rds_dbname" {}
variable "rds_engine" {}
variable "rds_engine_version" {}
variable "rds_instance_class" {}
variable "rds_family" {}

variable "backend_app_port" {}
variable "backend_instance_capacity" {}
variable "backend_instance_type" {}

variable "frontend_app_port" {}
variable "frontend_instance_capacity" {}
variable "frontend_instance_type" {}

variable "acm_arn" {}
variable "zone_id" {}
