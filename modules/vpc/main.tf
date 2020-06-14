### Data

data "aws_availability_zones" "azs" {
  state = "available"
}

### Local variables

locals {
  outside_cidr = "0.0.0.0/0"

  public_subnets  = [var.subnet_a, var.subnet_b]
  private_subnets = [var.subnet_c]
}


### VPC

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    var.general_tags,
    { Name = format("%s-vpc", var.name) }
  )
}

### Private Subnet

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.vpc.id

  count             = length(var.private_subnets)
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = tolist(data.aws_availability_zones.azs.names)[count.index]

  tags = merge(
    var.general_tags,
    {
      Tier = "private"
      Name = format("%s-private-subnet", var.name),
    }
  )
}

resource "aws_eip" "eip" { vpc = true }

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public.0.id

  depends_on = [
    aws_eip.eip,
    aws_internet_gateway.igw
  ]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = local.outside_cidr
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

### Public Subnet

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.vpc.id

  count             = length(var.public_subnets)
  cidr_block        = element(var.public_subnets, count.index)
  availability_zone = tolist(data.aws_availability_zones.azs.names)[count.index]

  map_public_ip_on_launch = true

  tags = merge(
    var.general_tags,
    {
      Tier = "public"
      Name = format("%s-public-subnet", var.name)
    }
  )
}

resource "aws_route" "public" {
  destination_cidr_block = local.outside_cidr

  gateway_id     = aws_internet_gateway.igw.id
  route_table_id = aws_vpc.vpc.main_route_table_id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_vpc.vpc.main_route_table_id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.general_tags,
    { Name = format("%s-igw", var.name) }
  )
}
