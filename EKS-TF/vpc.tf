# Create the VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.vpc-name
  }
}

# Create the Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.igw-name
  }
}

# Create Subnet 1 (Previously looked up via data)
resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet-name
  }
}

# Create Subnet 2 (Must reference the new VPC ID)
resource "aws_subnet" "public-subnet2" {
  vpc_id                  = aws_vpc.vpc.id # Updated reference
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet-name2
  }
}

# Create Security Group
resource "aws_security_group" "sg-default" {
  name        = var.security-group-name
  description = "Default security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = var.security-group-name
  }
}

# Create Route Table
resource "aws_route_table" "rt2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.rt-name2
  }
}

# Associate Route Table with Subnet 1
resource "aws_route_table_association" "rt-association1" {
  route_table_id = aws_route_table.rt2.id
  subnet_id      = aws_subnet.subnet.id
}

# Associate Route Table with Subnet 2
resource "aws_route_table_association" "rt-association2" {
  route_table_id = aws_route_table.rt2.id
  subnet_id      = aws_subnet.public-subnet2.id
}