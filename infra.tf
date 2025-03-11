resource "aws_vpc" "main" {

  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = format("%s-vpc", var.project_name)
  }
}


### Estrutura de subnets públicas

resource "aws_subnet" "public_aws_subnet_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = format("%s-public-1a", var.project_name)
    "kubernetes.io/role/elb" = var.tag_public_subnets
  }
}

resource "aws_subnet" "public_aws_subnet_1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.40.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name                     = format("%s-public-1b", var.project_name)
    "kubernetes.io/role/elb" = var.tag_public_subnets
  }
}

resource "aws_subnet" "public_aws_subnet_1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.60.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name                     = format("%s-public-1c", var.project_name)
    "kubernetes.io/role/elb" = var.tag_public_subnets
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name                     = format("%s-igw", var.project_name)
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "main_public_1a" {
  subnet_id      = aws_subnet.public_aws_subnet_1a.id
  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "main_public_1b" {
  subnet_id      = aws_subnet.public_aws_subnet_1b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "main_public_1c" {
  subnet_id      = aws_subnet.public_aws_subnet_1c.id
  route_table_id = aws_route_table.public.id
}



### Estrutura de subnets privadas

resource "aws_subnet" "private_aws_subnet_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.75.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name                              = format("%s-private-1a", var.project_name)
    "kubernetes.io/role/internal-elb" = var.tag_private_subnets
  }
}

resource "aws_subnet" "private_aws_subnet_1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.85.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name                              = format("%s-private-1b", var.project_name)
    "kubernetes.io/role/internal-elb" = var.tag_private_subnets
  }
}

resource "aws_subnet" "private_aws_subnet_1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.95.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name                              = format("%s-private-1c", var.project_name)
    "kubernetes.io/role/internal-elb" = var.tag_private_subnets
  }
}

resource "aws_eip" "main" {
  domain = "vpc"

}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public_aws_subnet_1a.id
  depends_on    = [aws_internet_gateway.main]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
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