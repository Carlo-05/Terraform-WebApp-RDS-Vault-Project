# VPC
resource "aws_vpc" "MyVPC" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  

  tags = merge(var.default_tags, { Name = var.vpc_tag })
}

# Internet Gateway
resource "aws_internet_gateway" "MyGW" {
  vpc_id = aws_vpc.MyVPC.id

  tags = merge(var.default_tags, { Name = var.igw_tag })
}

# Create Public Subnets
resource "aws_subnet" "Public-1" {
  vpc_id                  = aws_vpc.MyVPC.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.subnet-public-1-az

  tags = merge(var.default_tags, { Name = var.public1_subnet_tag })
}

resource "aws_subnet" "Public-2" {
  vpc_id                  = aws_vpc.MyVPC.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.subnet-public-2-az

  tags = merge(var.default_tags, { Name = var.public2_subnet_tag })
}

# Create Private Subnets
resource "aws_subnet" "Private-1" {
  vpc_id            = aws_vpc.MyVPC.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.subnet-private-1-az

  tags = merge(var.default_tags, { Name = var.private1_subnet_tag})
}

resource "aws_subnet" "Private-2" {
  vpc_id            = aws_vpc.MyVPC.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = var.subnet-private-2-az

  tags = merge(var.default_tags, { Name = var.private2_subnet_tag })
}

# Route Table for public subnets
resource "aws_route_table" "Public-Route-Table" {
  vpc_id = aws_vpc.MyVPC.id
  tags = merge(var.default_tags, { Name = var.public_RT_tag })

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.MyGW.id
  }
}

# Associate Public Subnets with Route Table
resource "aws_route_table_association" "Public-RTA-1" {
  subnet_id      = aws_subnet.Public-1.id
  route_table_id = aws_route_table.Public-Route-Table.id
}

resource "aws_route_table_association" "Public-RTA-2" {
  subnet_id      = aws_subnet.Public-2.id
  route_table_id = aws_route_table.Public-Route-Table.id
}

# PRivate Route TAble
resource "aws_route_table" "Private-Route-Table" {
  vpc_id = aws_vpc.MyVPC.id
  tags = merge(var.default_tags, { Name = var.private_RT_tag })
}
# Associate Private Subnets with Route Table
resource "aws_route_table_association" "Private-RTA-1" {
  subnet_id      = aws_subnet.Private-1.id
  route_table_id = aws_route_table.Private-Route-Table.id
}

resource "aws_route_table_association" "Private-RTA-2" {
  subnet_id      = aws_subnet.Private-2.id
  route_table_id = aws_route_table.Private-Route-Table.id
}
