variable "owner_name" {
  description = "Owner name of resources"
}

variable "owner_initials" {
  description = "Owner initials"
}

variable "name_prefix" {
  description = "Prefix Name for items"
}

#variable "aws_access_key_id" {
#  description = "Abort this with CTRL-C, set the TF_VAR_aws_access_key_id environment variable in your shell and try again."
#}

#variable "aws_secret_access_key" {
#  description = "Abort this with CTRL-C, set the TF_VAR_aws_secret_access_key environment variable in your shell and try again."
#}

variable "aws_region" {
  description = "AWS Region"
}

#variable "aws_vpc_name" {
#  description = "AWS VPC Name"
#}

variable "aws_vpc_id" {
  description = "AWS VPC ID"
  default = ""
}

#variable "aws_subnet_name" {
#  description = "AWS  Subnet Name"
#}

variable "aws_cidrs" {
  description = "AWS CIDR IP Range"
  type = list
}

variable "aws_s3_bucketname" {
  description = "AWS S3 Bucketname"
  default = ""
}

variable "tag_project" {
  description = "Project Name"
  default = ""
}

variable "tag_enddate" {
  description = "Resource expiration date (MMDDYYYY)"
  default = ""
}
