################################################################################
# VPC
################################################################################
provider "aws" {
  region = var.region-oregon
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block                       = var.vpc-cidr
  instance_tenancy                 = var.vpc-instance_tenancy
  assign_generated_ipv6_cidr_block = var.vpc-enable_ipv6
  tags = {
    "Name" = var.vpc-name
  }
}

################################################################################
# Public subnets
################################################################################

resource "aws_subnet" "subnet_public" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = var.subnet-public_subnet_count
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 1)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    "Name"                             = "${var.name}-public_subnet-${count.index + 1}"
    "kubernetes.io/role/elb"           = 1
    "kubernetes.io/cluster/tu-cluster" = "owned"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.name}-rtb-public"
  }
}

resource "aws_route_table_association" "public_assoc" {
  count          = var.subnet-public_subnet_count
  subnet_id      = aws_subnet.subnet_public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

################################################################################
# Private subnets
################################################################################

resource "aws_subnet" "subnet_private" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = var.subnet-private_subnet_count
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 101)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  depends_on = [
    aws_subnet.subnet_public
  ]

  tags = {
    "Name"                             = "${var.name}-private_subnet-${count.index + 1}"
    "kubernetes.io/role/internal-elb"  = 1
    "kubernetes.io/cluster/tu-cluster" = "owned"
  }
}

resource "aws_eip" "eip" {
  # domain = "vpc"
  depends_on = [aws_vpc.vpc]
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.subnet_public[0].id

  tags = {
    Name = "${var.name}-ngw"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-rtb-private"
  }
}

resource "aws_route_table_association" "private_assoc" {
  count          = var.subnet-private_subnet_count
  subnet_id      = aws_subnet.subnet_private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.ngw.id
}