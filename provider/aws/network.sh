resource "aws_vpc" "vpc_network" {
#    count                = (var.aws_vpc_id != "" ? 0 : 1)
    cidr_block           = var.aws_cidrs[0]
#    cidr_block           = "10.8.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
      Name    = "${var.owner_name}-${var.name_prefix}-vpc"
      owner   = var.owner_name
      project = var.project
      enddate = var.enddate
    }
}
/*
resource "aws_internet_gateway" "igw" {
#    vpc_id = aws_vpc.vpc_network.self_link
    vpc_id = aws_vpc.vpc_network.id

    tags = {
      Name    = "${var.owner_name}-${var.name_prefix}-igw"
      owner   = var.owner_name
      project = var.project
      enddate = var.enddate
    }
}

output "aws_vpc_id" {
    value = "${aws_vpc.vpc_network.id}"
}
*/

output "aws_owner_id" {
    value = "${aws_vpc.vpc_network.owner_id}"
}

