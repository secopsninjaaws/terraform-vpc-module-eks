############################################################ VPC ##########################################################


resource "aws_vpc" "main" {

  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

data "aws_availability_zones" "available" {}

############################################################ SUBNETS PUBLICAS ##########################################################

resource "aws_subnet" "public_subnets" {
  count                   = var.number_of_subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name                     = "public-${element(data.aws_availability_zones.available.names, count.index)}"
    "kubernetes.io/role/elb" = var.tag_public_subnets
  }
}


#ROUTES

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = format("%s-igw", var.project_name)
  }
}

resource "aws_route_table" "public" {
  vpc_id     = aws_vpc.main.id
  depends_on = [aws_internet_gateway.main]
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id

  }
  tags = {
    Name = format("%s-public-rt", var.project_name)
  }
}

resource "aws_route_table_association" "main" {
  count          = var.number_of_subnets
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id

  depends_on = [aws_route_table.public]

}


############################################################ SUBNETS PRIVADAS ##########################################################

resource "aws_subnet" "private_subnets" {
  count             = var.number_of_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index + 3)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name                              = "private-${element(data.aws_availability_zones.available.names, count.index)}"
    "kubernetes.io/role/internal-elb" = var.tag_private_subnets
    "karperter.sh/discovery"          = var.cluster_name
  }
}

#NAT GATEWAY

resource "aws_eip" "main" {
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-nat-eip"
  }

}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public_subnets[0].id
  tags = {
    Name = format("%s-nat", var.project_name)
  }

  depends_on = [aws_internet_gateway.main, aws_eip.main]
}

#ROUTES

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


resource "aws_route_table_association" "private" {
  count          = var.number_of_subnets
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private.id

  depends_on = [aws_route_table.private]

}