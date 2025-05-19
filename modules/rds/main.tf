# resource "aws_db_parameter_group" "main" {
#   name   = "${var.env}-${var.project_name}-pg"
#   family = var.family
# }
#
# # the subnet group is nothing but we are creating a group so that the rds will go and sit in DB instances only not in other instances
# resource "aws_db_subnet_group" "main" {
#   name       = "${var.env}-${var.project_name}-sg"
#   subnet_ids = var.subnets_ids
#
#   tags = {
#     Name = "${var.env}-${var.project_name}-sg"
#   }
# }
# # we create this to say only app subnets should access db instances here we provide what all subnets should access db_instances
# resource "aws_security_group" "main" {
#   name        = "${var.env}-${var.project_name}-rds-sg"
#   description = "${var.env}-${var.project_name}-rds-sg"
#   vpc_id      = var.vpc_id # we need this because which vpc we wanna create it
#
#   ingress {
#     from_port        = 3306
#     to_port          = 3306
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = var.sg_cidr_blocks
#   }
#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
#   tags = {
#     Name = "${var.env}-${var.project_name}-rds-sg"
#   }
# }
#
# resource "aws_db_instance" "main" {
#   identifier           = "${var.env}-${var.project_name}-rds"
#   allocated_storage    = var.allocated_storage
#   db_name              = var.db_name
#   engine               = var.engine
#   engine_version       = var.engine_version
#   instance_class       = var.instance_class
#   username             = data.aws_ssm_parameter.username.value
#   password             = data.aws_ssm_parameter.password.value
#   parameter_group_name = aws_db_parameter_group.main.name
#   skip_final_snapshot  = true
#   storage_encrypted    = true
#   kms_key_id           = var.kms_key_id
#   db_subnet_group_name = aws_db_subnet_group.main.name
#   vpc_security_group_ids = [aws_security_group.main.id]
#
# }


resource "aws_db_parameter_group" "main" {
  name   = "${var.env}-${var.project_name}-pg"
  family = var.family
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.env}-${var.project_name}-sg"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.env}-${var.project_name}-sg"
  }
}

resource "aws_security_group" "main" {
  name        = "${var.env}-${var.project_name}-rds-sg"
  description = "${var.env}-${var.project_name}-rds-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.sg_cidr_blocks
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.env}-${var.project_name}-rds-sg"
  }
}

resource "aws_db_instance" "main" {
  identifier             = "${var.env}-${var.project_name}-rds"
  allocated_storage      = var.allocated_storage
  db_name                = var.dbname
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = data.aws_ssm_parameter.username.value
  password               = data.aws_ssm_parameter.password.value
  parameter_group_name   = aws_db_parameter_group.main.name
  skip_final_snapshot    = true
  storage_encrypted      = true
  kms_key_id             = var.kms_key_id
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.main.id]
}






