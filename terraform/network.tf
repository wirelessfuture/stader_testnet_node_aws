####################################
######        Network         ######
####################################

# VPC Resource
resource "aws_vpc" "stader_testnet_vpc" {
  count                = var.resource_count
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "stader_testnet_vpc_${count.index}"
  }
}

# Subnet Resource
resource "aws_subnet" "stader_testnet_subnet" {
  count             = var.resource_count
  vpc_id            = aws_vpc.stader_testnet_vpc[count.index].id
  cidr_block        = "172.16.10.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name = "stader_testnet_subnet_${count.index}"
  }
}

# Internet Gateway Resource
resource "aws_internet_gateway" "stader_testnet_igw" {
  count  = var.resource_count
  vpc_id = aws_vpc.stader_testnet_vpc[count.index].id
}

# Route Table Resource
resource "aws_route_table" "stader_testnet_rt" {
  count  = var.resource_count
  vpc_id = aws_vpc.stader_testnet_vpc[count.index].id

  tags = {
    Name = "stader_testnet_rt_${count.index}"
  }
}

# Route Resource
resource "aws_route" "stader_testnet_default_route" {
  count                  = var.resource_count
  route_table_id         = aws_route_table.stader_testnet_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.stader_testnet_igw[count.index].id
}

# Route Table Association Resource
resource "aws_route_table_association" "stader_testnet_rt_assoc" {
  count          = var.resource_count
  subnet_id      = aws_subnet.stader_testnet_subnet[count.index].id
  route_table_id = aws_route_table.stader_testnet_rt[count.index].id
}

# Security Group Resource
resource "aws_security_group" "stader_testnet_sg" {
  count       = var.resource_count
  name        = "stader-testnet-sg-${count.index}"
  description = "stader-testnet-sg-${count.index}"
  vpc_id      = aws_vpc.stader_testnet_vpc[count.index].id

  # To Allow SSH Transport
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # To Allow Port 3100 Transport for dashboard
  ingress {
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow egress on all ports and protocols
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

