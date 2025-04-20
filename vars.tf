#common for each module
variable "env" {}
variable "project_name" {}
variable "kms_key_id" {}
variable "bastion_cidrs" {}

#different type of modules
variable "vpc" {}
variable "rds" {}
variable "app" {}
