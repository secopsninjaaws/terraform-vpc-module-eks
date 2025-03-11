resource "aws_subnet" "public_aws_subnet_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 4)
  availability_zone = "${data.aws_region.main.name}a"
  tags = {
    Name = format("%s-public-1a", var.project_name)
    "kubernetes.io/role/elb" = var.tag_public_subnets
  }
}

resource "aws_subnet" "public_aws_subnet_1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 5)
  availability_zone = "${data.aws_region.main.name}b"
  tags = {
    Name                     = format("%s-public-1b", var.project_name)
    "kubernetes.io/role/elb" = var.tag_public_subnets
  }
}

resource "aws_subnet" "public_aws_subnet_1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 6)
  availability_zone = "${data.aws_region.main.name}c"
  tags = {
    Name                     = format("%s-public-1c", var.project_name)
    "kubernetes.io/role/elb" = var.tag_public_subnets
  }
}


###ROUTES

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name                     = format("%s-igw", var.project_name)
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  depends_on = [ aws_internet_gateway.main ]
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  
} 
  tags = {
    Name = format("%s-public", var.project_name)
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
