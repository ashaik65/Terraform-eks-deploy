data "aws_availability_zones" "available" {
  state = "available"
}
#vpc resource
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpccidr
  instance_tenancy = "default"
  tags = merge(
    { "Name" = format("${var.Project}-${var.env}-vpc")
    },
    { "environment" = "${var.env}"
    },
    var.additional_tags
  )
}
# Internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    { "Name" = format("${var.Project}-${var.env}-igw")
    },
    { "environment" = "${var.env}"
    },
    var.additional_tags
  )
}
#Elastic IP for NAT Gateway resource
resource "aws_eip" "nat" {
  vpc = true
  tags = merge(
    { "Name" = format("${var.Project}-${var.env}-ngwIp")
    },
    { "environment" = "${var.env}"
    },
    var.additional_tags
  )
}
#NAT Gateway object and attachment of the Elastic IP Address
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.pubsub1.id
  depends_on    = [aws_internet_gateway.internet_gateway]
  tags = merge(
    { "Name" = format("${var.Project}-${var.env}-ngw") },
    { "environment" = "${var.env}" },
  var.additional_tags)
}
#Configuration of Subnets

#Public Subnets
resource "aws_subnet" "pubsub1" {
  cidr_block              = var.pubsub1cidr
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0] #0 indicates the first AZ
  tags = merge(
    { "Name" = format("${var.Project}-${var.env}-Public-Subnet-a") },
    { "environment" = "${var.env}" },
  var.additional_tags)
}
resource "aws_subnet" "pubsub2" {
  cidr_block              = var.pubsub2cidr
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = merge(
    { "Name" = format("${var.Project}-${var.env}-Public-Subnet-b") },
    { "environment" = "${var.env}" },
  var.additional_tags)
}
resource "aws_subnet" "pubsub3" {
  cidr_block              = var.pubsub3cidr
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[2]
  tags = merge(
    { "Name" = format("${var.Project}-${var.env}-Public-Subnet-c") },
    { "environment" = "${var.env}" },
  var.additional_tags)
}

#Private Subnets
resource "aws_subnet" "prisub1" {
  cidr_block              = var.prisub1cidr
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = merge(
    { "Name" = format("${var.Project}-${var.env}-Private-Subnet-a") },
    { "environment" = "${var.env}" },
  var.additional_tags)
}
resource "aws_subnet" "prisub2" {
  cidr_block              = var.prisub2cidr
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = merge(
    { "Name" = format("${var.Project}-${var.env}-Private-Subnet-b") },
    { "environment" = "${var.env}" },
  var.additional_tags)
}
resource "aws_subnet" "prisub3" {
  cidr_block              = var.prisub3cidr
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[2]
  tags = merge(
    { "Name" = format("${var.Project}-${var.env}-Private-Subnet-c") },
    { "environment" = "${var.env}" },
  var.additional_tags)
}

#Configuration of Route Table

#Public RouteTable
resource "aws_route_table" "routetablepublic" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = merge(
    { "Name" = format("${var.Project}-${var.env}-Public-rtb") },
    { "environment" = "${var.env}" },
  var.additional_tags)
}
#Private RouteTable
resource "aws_route_table" "routetableprivate" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }
  tags = merge(
    { "Name" = format("${var.Project}-${var.env}-Privare-rtb") },
    { "environment" = "${var.env}" },
  var.additional_tags)
}

#Association of Public Route Table to Public Subnets
resource "aws_route_table_association" "pubrtAs1" {
  subnet_id      = aws_subnet.pubsub1.id
  route_table_id = aws_route_table.routetablepublic.id
}
resource "aws_route_table_association" "pubrtAs2" {
  subnet_id      = aws_subnet.pubsub2.id
  route_table_id = aws_route_table.routetablepublic.id
}
resource "aws_route_table_association" "pubrtAs3" {
  subnet_id      = aws_subnet.pubsub3.id
  route_table_id = aws_route_table.routetablepublic.id
}
#Association of Private Route Table to Private Subnets
resource "aws_route_table_association" "prirtAs1" {
  subnet_id      = aws_subnet.prisub1.id
  route_table_id = aws_route_table.routetableprivate.id
}
resource "aws_route_table_association" "prirtAs2" {
  subnet_id      = aws_subnet.prisub2.id
  route_table_id = aws_route_table.routetableprivate.id
}
resource "aws_route_table_association" "prirtAs3" {
  subnet_id      = aws_subnet.prisub3.id
  route_table_id = aws_route_table.routetableprivate.id
}
