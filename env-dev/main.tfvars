# env               = "dev"
# project_name      = "expense"
# kms_key_id        = "arn:aws:kms:us-east-1:522814736516:key/94568fc4-e087-46db-8d88-a6e69ed61d8e"
# bastion_cidrs     = ["172.31.84.34/32"]
# acm_arn           = "arn:aws:acm:us-east-1:522814736516:certificate/41696961-81dc-404c-a055-49b3e536cdba"
# zone_id           = "Z07191123NJU9NTTKKZJ1"
# vpc = {
#   main = {
#     vpc_cidr     = "10.10.0.0/21"
#     public_subnets_cidr = ["10.10.0.0/25", "10.10.0.128/25"]
#     web_subnets_cidr = ["10.10.1.0/25", "10.10.1.128/25"]
#     app_subnets_cidr = ["10.10.2.0/25", "10.10.2.128/25"]
#     db_subnets_cidr = ["10.10.3.0/25", "10.10.3.128/25"]
#     az           = ["us-east-1a", "us-east-1b"]
#   }
# }
# rds = {
#   main = {
#     allocated_storage    = 20
#     db_name              = "expense"
#     engine               = "mysql"
#     engine_version       = "5.7"
#     instance_class       = "db.t3.micro"
#     family               = "mysql5.7"
#
#   }
# }
# # app = {
# #   main = {
# #     app_port          = 8080
# #     component         = "backend"
# #     instance_capacity =  1
# #     instance_type     = "t3.small"
# #   }
# # }
# app = {
#   backend = {
#     component         = "backend"
#     app_port          = 8080
#     instance_capacity = 1
#     instance_type     = "t3.small"
#   }
#
#   frontend = {
#     component         = "frontend"
#     app_port          = 80
#     instance_capacity = 1
#     instance_type     = "t3.small"
#   }
# }
env              = "dev"
project_name     = "expense"
kms_key_id       = "arn:aws:kms:us-east-1:522814736516:key/94568fc4-e087-46db-8d88-a6e69ed61d8e"
bastion_cidrs     = ["172.31.84.34/32"]
# prometheus_cidrs = ["172.31.84.209/32"]
acm_arn          = "arn:aws:acm:us-east-1:522814736516:certificate/41696961-81dc-404c-a055-49b3e536cdba"
zone_id          = "Z07191123NJU9NTTKKZJ1"

vpc_cidr            = "10.10.0.0/21"
public_subnets_cidr = ["10.10.0.0/25", "10.10.0.128/25"]
web_subnets_cidr    = ["10.10.1.0/25", "10.10.1.128/25"]
app_subnets_cidr    = ["10.10.2.0/25", "10.10.2.128/25"]
db_subnets_cidr     = ["10.10.3.0/25", "10.10.3.128/25"]
az                  = ["us-east-1a", "us-east-1b"]

rds_allocated_storage = 10
rds_dbname            = "expense"
rds_engine            = "mysql"
rds_engine_version    = "5.7"
rds_instance_class    = "db.t3.micro"
rds_family            = "mysql5.7"

backend_app_port          = 8080
backend_instance_capacity = 1
backend_instance_type     = "t3.small"

frontend_app_port          = 80
frontend_instance_capacity = 1
frontend_instance_type     = "t3.small"