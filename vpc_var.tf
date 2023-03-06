#define variable for VPC deploy
variable "aws_region" {
	type      = string
}
variable "vpc_name" {
	type      = string
}

variable "vpc_cidr_block" {
	type      = string
}

variable "PublicSubnet1_cidr_block" {
	type      = string
}

variable "PublicSubnet2_cidr_block" {
	type      = string
}

variable "AppSubnet1_cidr_block" {
	type      = string
}

variable "AppSubnet2_cidr_block" {
	type      = string
}

variable "DBSubnet1_cidr_block" {
	type      = string
}

variable "DBSubnet2_cidr_block" {
	type      = string
}