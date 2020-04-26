#-- networking/main.tf ---

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

#--- VPC 1 - Service Provider

resource "aws_vpc" "vpc1" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { 
    Name = format("%s_vpc1_provider", var.project_name)
    project_name = var.project_name
  }
}

resource "aws_subnet" "subprv1" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]
  
  tags = { 
    Name = format("%s_subprv1", var.project_name)
    project_name = var.project_name
  }
}

resource "aws_security_group" "sgprv1" {
  name        = "sgprv1"
  description = "Used for access to the public instances"
  vpc_id      = aws_vpc.vpc1.id
  ingress { # allow ping
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0 # the ICMP type number for 'Echo Reply'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
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
    Name = format("%s_sgprv1", var.project_name)
    project_name = var.project_name
  }
}
