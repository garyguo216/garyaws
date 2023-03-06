#provider info
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "3.63.0"
        }
    }
    backend "s3" {
        bucket = "garyterraform"
        region = "ap-northeast-1"
        key = "aws/demo/webdemo.tfstate"
    }
}

provider "aws" {
    region = "${var.aws_region}"
}