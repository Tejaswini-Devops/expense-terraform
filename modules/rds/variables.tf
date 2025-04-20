variable "env" {}
variable "project_name" {}
variable "allocated_storage" {}
variable "db_name" {}
variable "engine" {}
variable "engine_version" {}
variable "instance_class" {}
variable "family" {}
variable "kms_key_id" {}

# these both variables are we took because we are accessing vpc module data into our rds
variable "subnets_ids" {}
variable "vpc_id" {}
variable "sg_cidr_blocks" {}