variable "env" {}
variable "project_name" {}
variable "app_port" {}
variable "bastion_cidrs" {
  default = []
}
variable "instance_capacity" {}
variable "instance_type" {}
variable "component" {}
variable "vpc_zone_identifier" {}
variable "sg_cidr_blocks" {}
variable "vpc_id" {}
variable "parameters" {}
variable "kms" {}
variable "prometheus_cidrs" {}
