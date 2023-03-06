#terraform code to deploy server on RDS in AWS

#create RDS instance
resource "aws_db_instance" "rds_instance" {
    identifier           = var.mysql_identifier
    storage_type         = "gp2"
    allocated_storage    = var.allocated_storage
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t3.medium"
    username             = var.mysql_username
    password             = var.mysql_password
    parameter_group_name = "default.mysql5.7"
    db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
    vpc_security_group_ids = [aws_security_group.rds_sg.id]
    publicly_accessible    = false
    skip_final_snapshot    = true
    multi_az               = true
}

resource "aws_db_subnet_group" "db_subnet_group" {
    name       = "${var.mysql_identifier}-db-subnet-group"
    subnet_ids = [aws_subnet.IacVPC_DBSubnet1.id,aws_subnet.IacVPC_DBSubnet2.id]
}

resource "aws_security_group" "rds_sg" {
    name        = "${var.mysql_identifier}-SG"
    description = "A security group that allows inbound SSH and XRDP ports"
    vpc_id      = aws_vpc.IacVPC.id
    
    ingress {
        from_port   = "3306"
        to_port     = "3306"
        protocol    = "tcp"
        security_groups = [aws_security_group.ec2_sg_jumpserver.id]
        description = "Allow Mysql traffic from Jumpserver"
    }
    
     ingress {
        from_port   = "3306"
        to_port     = "3306"
        protocol    = "tcp"
        security_groups = [aws_security_group.ec2_sg_appserver.id]
        description = "Allow Mysql traffic from Jumpserver"
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {Name = "${var.mysql_identifier}-SG" }
}