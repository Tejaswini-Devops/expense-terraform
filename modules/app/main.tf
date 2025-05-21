resource "aws_security_group" "main" {
  name        = "${local.name}-sg"
  description = "${local.name}-sg"
  vpc_id      = var.vpc_id # we need this because which vpc we wanna create it

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.bastion_cidrs
    description = "SSH Access from Bastion"
  }

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = var.sg_cidr_blocks
    description = "App Port Access"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "${local.name}-sg"
  }
}
resource "aws_launch_template" "main" {
  name_prefix            = "${local.name}-lt"
  image_id               = data.aws_ami.centos8.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]

  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    service_name = var.component
    env          = var.env
  }))


  iam_instance_profile {
    name = aws_iam_instance_profile.main.name
  }
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs{
      volume_size = 10
      encrypted = true
      kms_key_id = var.kms
      delete_on_termination = true
    }
  }
}
# create instances
resource "aws_autoscaling_group" "main" {
  name                = "${local.name}-asg"
  desired_capacity    = var.instance_capacity
  max_size            = var.instance_capacity # TBD, THis we will fine tune after autoscaling
  min_size            = var.instance_capacity
  vpc_zone_identifier = var.vpc_zone_identifier# it is a place we are saying to create instamce in app subnet
  target_group_arns = [aws_lb_target_group.main.arn] # assigning instances to the target groups
  # In Terraform, a target group typically refers to an AWS resource that defines how a load balancer (like an Application Load Balancer - ALB) routes traffic to registered targets (e.g., EC2 instances, IPs, or Lambda functions).

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = local.name
    propagate_at_launch = true
  }
}
resource "aws_lb_target_group" "main" {
  name     = "${local.name}-tg"
  port     = var.app_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/health"
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 5
    timeout = 2
  }
}
resource "aws_iam_role" "main" {  # creating role for ec2 instance.
  name = "${local.name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "parameter-store"

    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "GetParameter",
          "Effect" : "Allow",
          "Action" : [
            "kms:Decrypt",
            "ssm:GetParameterHistory",
            "ssm:DescribeDocumentParameters",
            "ssm:GetParametersByPath",
            "ssm:GetParameters",
            "ssm:GetParameter"
          ],
          "Resource" :concat([ "arn:aws:ssm:us-east-1:522814736516:parameter/${var.env}.${var.project_name}.${var.component}.*",
            "arn:aws:kms:us-east-1:522814736516:key/94568fc4-e087-46db-8d88-a6e69ed61d8e"],var.parameters)

        },
        {
          "Sid" : "DescribeAllParameters",
          "Effect" : "Allow",
          "Action" : "ssm:DescribeParameters",
          "Resource" : "*"
        }
      ]
    })
  }
}
resource "aws_iam_instance_profile" "main" {# used to create instance profile ARN Which is automatically created manually but not
  name = "${local.name}-role"
  role = aws_iam_role.main.name
}