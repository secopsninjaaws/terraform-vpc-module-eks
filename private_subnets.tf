resource "aws_subnet" "private_aws_subnet_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 1)
  availability_zone = "${data.aws_region.main.name}a"
  tags = {
    Name                              = format("%s-private-1a", var.project_name)
    "kubernetes.io/role/internal-elb" = var.tag_private_subnets
  }
}

resource "aws_subnet" "private_aws_subnet_1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 2)
  availability_zone = "${data.aws_region.main.name}b"
  tags = {
    Name                              = format("%s-private-1b", var.project_name)
    "kubernetes.io/role/internal-elb" = var.tag_private_subnets
  }
}

resource "aws_subnet" "private_aws_subnet_1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 3)
  availability_zone = "${data.aws_region.main.name}c"
  tags = {
    Name                              = format("%s-private-1c", var.project_name)
    "kubernetes.io/role/internal-elb" = var.tag_private_subnets
  }
}

resource "aws_eip" "main" {
  domain = "vpc"
  tags = {
    Name = format("%s-nat-eip", var.project_name)
  }

}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public_aws_subnet_1a.id
  depends_on    = [aws_internet_gateway.main, aws_eip.main]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  tags = {
    Name = format("%s-private", var.project_name)
  }
}


resource "aws_route_table_association" "main_private_1a" {
  subnet_id      = aws_subnet.private_aws_subnet_1a.id
  route_table_id = aws_route_table.private.id

}

resource "aws_route_table_association" "main_private_1b" {
  subnet_id      = aws_subnet.private_aws_subnet_1b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "main_private_1c" {
  subnet_id      = aws_subnet.private_aws_subnet_1c.id
  route_table_id = aws_route_table.private.id
}
