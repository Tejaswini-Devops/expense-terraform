resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env}-${var.project_name}-vpc"
  }
}
resource "aws_subnet" "main" {
  count             = length(var.subnets_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnets_cidr[count.index]
  availability_zone = var.az[count.index]

  tags = {
    Name = "${var.env}-${var.project_name}-subnet-${count.index}"
  }
}

resource "aws_vpc_peering_connection" "main" {
  vpc_id        = aws_vpc.main.id
  peer_vpc_id   = data.aws_vpc.default.id
  auto_accept   = true

  tags = {
    Name = "${var.env}-default-vpc-new-vpc"
  }
}
resource "aws_route" "main" {
  route_table_id            = aws_vpc.main.main_route_table_id
  destination_cidr_block    = data.aws_vpc.default.id
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

resource "aws_route" "default" {
  route_table_id            = data.aws_vpc.default.main_route_table_id
  destination_cidr_block    = aws_vpc.main.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}