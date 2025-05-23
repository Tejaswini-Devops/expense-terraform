# resource "aws_vpc" "main" {
#   cidr_block = var.vpc_cidr
#   tags = {
#     Name = "${var.env}-${var.project_name}-vpc"
#   }
# }
# resource "aws_internet_gateway" "main" {
#   vpc_id = aws_vpc.main.id
#
#   tags = {
#     Name = "${var.env}-${var.project_name}-igw"
#   }
# }
# resource "aws_vpc_peering_connection" "main" {
#   vpc_id        = aws_vpc.main.id
#   peer_vpc_id   = data.aws_vpc.default.id
#   auto_accept   = true
#
#   tags = {
#     Name = "${var.env}-default-vpc-new-vpc"
#   }
# }
#
# resource "aws_subnet" "public" {
#   count             = length(var.public_subnets_cidr)
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = var.public_subnets_cidr[count.index]
#   availability_zone = var.az[count.index]
#
#   tags = {
#     Name = "public_subnet-${count.index+1}"
#   }
# }
# resource "aws_route_table" "public" {
#   count             = length(var.public_subnets_cidr)
#   vpc_id             = aws_vpc.main.id
#
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.main.id
#   }
#   route {
#     cidr_block = data.aws_vpc.default.cidr_block
#     vpc_peering_connection_id = aws_vpc_peering_connection.main.id
#   }
#
#   tags = {
#     Name = "public_rt-${count.index+1}"
#   }
# }
#
# resource "aws_route_table_association" "public" {
#   count          = length(var.public_subnets_cidr)
#   route_table_id = aws_route_table.public[count.index].id
#   subnet_id      = aws_subnet.public[count.index].id
# }
# # its a ip we need for internet connection
# resource "aws_eip" "main" {
#   count = length(var.public_subnets_cidr)
#   domain   = "vpc"
# }
#
# resource "aws_nat_gateway" "main" {
#   count = length(var.public_subnets_cidr)
#   allocation_id = aws_eip.main[count.index].id
#   subnet_id     = aws_subnet.public[count.index].id
#
#   tags = {
#     Name = "ngw-${count.index+1}"
#   }
#
# }
#
# resource "aws_subnet" "web" {
#   count             = length(var.web_subnets_cidr)
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = var.web_subnets_cidr[count.index]
#   availability_zone = var.az[count.index]
#
#   tags = {
#     Name = "web_subnet-${count.index+1}"
#   }
# }
# resource "aws_route_table" "web" {
#   count             = length(var.web_subnets_cidr)
#   vpc_id             = aws_vpc.main.id
#
#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.main[count.index].id
#   }
#   route {
#     cidr_block = data.aws_vpc.default.cidr_block
#     vpc_peering_connection_id = aws_vpc_peering_connection.main.id
#   }
#
#   tags = {
#     Name = "web_rt-${count.index+1}"
#   }
# }
#
# resource "aws_route_table_association" "web" {
#   count          = length(var.web_subnets_cidr)
#   route_table_id = aws_route_table.web[count.index].id
#   subnet_id      = aws_subnet.web[count.index].id
# }
# resource "aws_subnet" "app" {
#   count             = length(var.app_subnets_cidr)
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = var.app_subnets_cidr[count.index]
#   availability_zone = var.az[count.index]
#
#   tags = {
#     Name = "app_subnet-${count.index+1}"
#   }
# }
# resource "aws_route_table" "app" {
#   count             = length(var.app_subnets_cidr)
#   vpc_id             = aws_vpc.main.id
#
#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.main[count.index].id
#   }
#   route {
#     cidr_block = data.aws_vpc.default.cidr_block
#     vpc_peering_connection_id = aws_vpc_peering_connection.main.id
#   }
#
#   tags = {
#     Name = "app_rt-${count.index+1}"
#   }
# }
#
# resource "aws_route_table_association" "app" {
#   count          = length(var.app_subnets_cidr)
#   route_table_id = aws_route_table.app[count.index].id
#   subnet_id      = aws_subnet.app[count.index].id
# }
# resource "aws_subnet" "db" {
#   count             = length(var.db_subnets_cidr)
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = var.db_subnets_cidr[count.index]
#   availability_zone = var.az[count.index]
#
#   tags = {
#     Name = "db_subnet-${count.index+1}"
#   }
# }
# resource "aws_route_table" "db" {
#   count             = length(var.db_subnets_cidr)
#   vpc_id             = aws_vpc.main.id
#
#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.main[count.index].id
#   }
#   route {
#     cidr_block = data.aws_vpc.default.cidr_block
#     vpc_peering_connection_id = aws_vpc_peering_connection.main.id
#   }
#
#   tags = {
#     Name = "db_rt-${count.index+1}"
#   }
# }
#
# resource "aws_route_table_association" "private" {
#   count          = length(var.db_subnets_cidr)
#   route_table_id = aws_route_table.db[count.index].id
#   subnet_id      = aws_subnet.db[count.index].id
# }
#
#
# resource "aws_route" "main" {
#   route_table_id            = aws_vpc.main.main_route_table_id
#   destination_cidr_block    = data.aws_vpc.default.cidr_block
#   vpc_peering_connection_id = aws_vpc_peering_connection.main.id
# }
#
# resource "aws_route" "default" {
#   route_table_id            = data.aws_vpc.default.main_route_table_id
#   destination_cidr_block    = aws_vpc.main.cidr_block
#   vpc_peering_connection_id = aws_vpc_peering_connection.main.id
# }
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.env}-${var.project_name}-vpc"
  }
}

resource "aws_vpc_peering_connection" "main" {
  vpc_id      = aws_vpc.main.id
  peer_vpc_id = data.aws_vpc.default.id
  auto_accept = true

  tags = {
    Name = "${var.env}-vpc-with-default-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-${var.project_name}-igw"
  }
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnets_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets_cidr[count.index]
  availability_zone = var.az[count.index]

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  count  = length(var.public_subnets_cidr)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  route {
    cidr_block                = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }

  tags = {
    Name = "public-rt-${count.index + 1}"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  route_table_id = lookup(aws_route_table.public[count.index], "id", null) # aws_route_table.public[count.index].id
  subnet_id      = lookup(aws_subnet.public[count.index], "id", null)
}

resource "aws_eip" "main" {
  count  = length(var.public_subnets_cidr)
  domain = "vpc"
}


resource "aws_nat_gateway" "main" {
  count         = length(var.public_subnets_cidr)
  allocation_id = lookup(aws_eip.main[count.index], "id", null)
  subnet_id     = lookup(aws_subnet.public[count.index], "id", null)

  tags = {
    Name = "ngw-${count.index + 1}"
  }
}


resource "aws_subnet" "web" {
  count             = length(var.web_subnets_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.web_subnets_cidr[count.index]
  availability_zone = var.az[count.index]

  tags = {
    Name = "web-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "web" {
  count  = length(var.web_subnets_cidr)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = lookup(aws_nat_gateway.main[count.index], "id", null)
  }

  route {
    cidr_block                = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }

  tags = {
    Name = "web-rt-${count.index + 1}"
  }
}

resource "aws_route_table_association" "web" {
  count          = length(var.web_subnets_cidr)
  route_table_id = lookup(aws_route_table.web[count.index], "id", null) # aws_route_table.private[count.index].id
  subnet_id      = lookup(aws_subnet.web[count.index], "id", null)
}

resource "aws_subnet" "app" {
  count             = length(var.app_subnets_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.app_subnets_cidr[count.index]
  availability_zone = var.az[count.index]

  tags = {
    Name = "app-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "app" {
  count  = length(var.app_subnets_cidr)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = lookup(aws_nat_gateway.main[count.index], "id", null)
  }

  route {
    cidr_block                = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }

  tags = {
    Name = "app-rt-${count.index + 1}"
  }
}

resource "aws_route_table_association" "app" {
  count          = length(var.app_subnets_cidr)
  route_table_id = lookup(aws_route_table.app[count.index], "id", null) # aws_route_table.private[count.index].id
  subnet_id      = lookup(aws_subnet.app[count.index], "id", null)
}

resource "aws_subnet" "db" {
  count             = length(var.db_subnets_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnets_cidr[count.index]
  availability_zone = var.az[count.index]

  tags = {
    Name = "db-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "db" {
  count  = length(var.db_subnets_cidr)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = lookup(aws_nat_gateway.main[count.index], "id", null)
  }

  route {
    cidr_block                = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }

  tags = {
    Name = "db-rt-${count.index + 1}"
  }
}

resource "aws_route_table_association" "db" {
  count          = length(var.db_subnets_cidr)
  route_table_id = lookup(aws_route_table.db[count.index], "id", null) # aws_route_table.private[count.index].id
  subnet_id      = lookup(aws_subnet.db[count.index], "id", null)
}


resource "aws_route" "main" {
  route_table_id            = aws_vpc.main.main_route_table_id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

resource "aws_route" "default-vpc" {
  route_table_id            = data.aws_vpc.default.main_route_table_id
  destination_cidr_block    = aws_vpc.main.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}