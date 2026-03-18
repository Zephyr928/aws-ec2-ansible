terraform {
  require_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws.region
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "learning-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "learning-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "Public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
  Name = "learning-public-subnet"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "learning-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group
resource "aws_security_group" "web" {
  name         = "learning-web-sg"
  description  = "Security group for web servers"
  vpc_id       = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #NEED TO RESTRICT THIS TO PRODUCTION IP ADDRESSES.  ADDRESS THIS LATER
  }

ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "learning-web-sg"
  }
}

# Key Pair (you'll need to create this first)
resource "aws_key_pair" "deployer" {
  key_name   = "learning-key"
  public_key = file("~/.ssh/id_rsa.pub")  # Make sure this exists
}

# EC2 Instances
resource "aws_instance" "web_servers" {
  count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_id              = aws_subnet.public.id

  tags = {
    Name        = "web-server-${count.index + 1}"
    Environment = "learning"
    ManagedBy   = "terraform"
    AnsibleGroup = "webservers"
  }
}
