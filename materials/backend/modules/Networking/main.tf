################################################################################
# VPC
################################################################################
provider "aws" {
  region = var.region-oregon
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
# Subnets
################################################################################

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "subnet_public" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = var.subnet-public_subnet_count
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 1)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    "Name"                         = "${var.name}-public_subnet-${count.index + 1}"
    "kubernetes.io/role/elb"       = 1
    "kubernetes.io/cluster/aaa-cl" = "owned"
  }
}

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
    "Name"                            = "${var.name}-private_subnet-${count.index + 1}"
    "kubernetes.io/role/internal-elb" = 1
    "kubernetes.io/cluster/aaa-cl"    = "owned"
  }
}