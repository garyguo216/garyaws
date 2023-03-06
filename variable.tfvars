#Provide parameter
#parameter for VPC
aws_region                     =   "ap-northeast-1"
vpc_name                       =   "Demo-VPC"
vpc_cidr_block                 =   "10.0.0.0/16"
PublicSubnet1_cidr_block       =   "10.0.0.0/24"
PublicSubnet2_cidr_block       =   "10.0.1.0/24"
AppSubnet1_cidr_block          =   "10.0.2.0/24"
AppSubnet2_cidr_block          =   "10.0.3.0/24"
DBSubnet1_cidr_block           =   "10.0.4.0/24"
DBSubnet2_cidr_block           =   "10.0.5.0/24"

#parameter for jumpserver
ec2_name_jumpserver 		   = "Demo-JumpServer"
ec2_type_jumpserver	  	       = "t3.micro"
ec2_key_name_jumpserver 	   = "Gary-Demo"
sg_ip_address_range_jumpserver = ["52.198.107.166/32"]

#parameter for rds
mysql_identifier               = "demo-mysql"
allocated_storage              = "500"
mysql_username                 = "testuser"
mysql_password                 = "12345678"

#parameter for app
ec2_name_appserver 		       = "Demo-appServer"
ec2_type_appserver	           = "t3.medium"
ec2_key_name_appserver 	       = "Gary-Demo"


#parameter for elb
load_balancer_name 		       = "demoelb"
internal_load_balancer         = "true"