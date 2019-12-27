resource "aws_vpc" "vpc_network" {
    cidr_block           = var.aws_cidrs[0]
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
      Name    = "${var.owner_name}-${var.name_prefix}-vpc"
      owner   = var.owner_name
      project = var.tag_project
      enddate = var.tag_enddate
    }
}

################ Public Subnet #################
resource "aws_subnet" "public-subnet" {
    vpc_id	= aws_vpc.vpc_network.id
    cidr_block  = var.aws_cidrs[1]
    
    tags = {
      Name    = "${var.owner_name}-${var.name_prefix}-public-subnet"
      owner   = var.owner_name
      project = var.tag_project
      enddate = var.tag_enddate
    }
}

################ Private Subnet #################
resource "aws_subnet" "private-subnet" {
    vpc_id      = aws_vpc.vpc_network.id
    cidr_block  = var.aws_cidrs[2]
   
    tags = {
      Name    = "${var.owner_name}-${var.name_prefix}-private-subnet"
      owner   = var.owner_name
      project = var.tag_project
      enddate = var.tag_enddate
    }
}

################ Internet Gatway #################
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc_network.id

    tags = {
      Name    = "${var.owner_name}-${var.name_prefix}-igw"
      owner   = var.owner_name
      project = var.tag_project
      enddate = var.tag_enddate
    }
}

################ Route Tables #################
resource "aws_route_table" "public-rt" {
    vpc_id		= aws_vpc.vpc_network.id
    route {
        cidr_block 	= "0.0.0.0/0"
        gateway_id 	= aws_internet_gateway.igw.id
    }

    tags = {
      Name    = "${var.owner_name}-${var.name_prefix}-public-rt"
      owner   = var.owner_name
      project = var.tag_project
      enddate = var.tag_enddate
    }
}

resource "aws_route_table_association" "rtb_assoc"{
    subnet_id		= aws_subnet.public-subnet.id
    route_table_id	= aws_route_table.public-rt.id
}

################ Security Group ################
resource "aws_security_group" "public-sg" {
    name = "aws-public-sg"
    description = "Allow incoming SSH access"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["24.32.208.61/32"]
    }
    
    vpc_id = aws_vpc.vpc_network.id

    tags = {
      Name    = "${var.owner_name}-${var.name_prefix}-public-sg"
      owner   = var.owner_name
      project = var.tag_project
      enddate = var.tag_enddate
    }
}

################# Output Variables #################
output "aws_vpc_id" {
    value = aws_vpc.vpc_network.id
}


output "aws_owner_id" {
    value = "${aws_vpc.vpc_network.owner_id}"
}

