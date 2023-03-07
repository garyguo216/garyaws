#terraform code to deploy server on EC2 in AWS

data "aws_ami" "aws_app_ami" {
    owners           = ["679593333241"]
    most_recent      = true
    filter {
        name = "name"
        values = ["CentOS-7*x86_64*"]
    }
}

#Create EC2
resource "aws_instance" "ec2_appserver_1" {
    ami                         = data.aws_ami.aws_app_ami.id
    instance_type               = "${var.ec2_type_appserver}"
    iam_instance_profile        = "${var.iam_instance_profile_appserver}"
    key_name                    = "${var.ec2_key_name_appserver}"
    monitoring                  = false
    security_groups             = [aws_security_group.ec2_sg_appserver.id]
    associate_public_ip_address = false
    source_dest_check           = true
    subnet_id                   = aws_subnet.IacVPC_AppSubnet1.id
    
    root_block_device {
        delete_on_termination   = "${var.delete_volumes_on_termination_appserver}"
        encrypted               = false
        volume_size             = "${var.root_block_device_volume_size_appserver}"
        volume_type             = "${var.root_block_device_volume_type_appserver}"
    }
    tags        = { Name = "${var.ec2_name_appserver}_1" }
    volume_tags = { Name = "${var.ec2_name_appserver}_1_Disk"}
}

resource "aws_instance" "ec2_appserver_2" {
    ami                     = data.aws_ami.aws_app_ami.id
    instance_type           = "${var.ec2_type_appserver}"
    iam_instance_profile    = "${var.iam_instance_profile_appserver}"
    key_name                = "${var.ec2_key_name_appserver}"
    monitoring              = false
    security_groups             = [aws_security_group.ec2_sg_appserver.id]
    associate_public_ip_address = false
    source_dest_check           = true
    subnet_id                   = aws_subnet.IacVPC_AppSubnet2.id
    root_block_device {
        delete_on_termination   = "${var.delete_volumes_on_termination_appserver}"
        encrypted               = false
        volume_size             = "${var.root_block_device_volume_size_appserver}"
        volume_type             = "${var.root_block_device_volume_type_appserver}"
    }
    tags        = { Name = "${var.ec2_name_appserver}_2" }
    volume_tags = { Name = "${var.ec2_name_appserver}_2_Disk"}
}

resource "aws_security_group" "ec2_sg_appserver" {
    name        = "${var.ec2_name_appserver}-SG"
    description = "A security group that allows inbound SSH and web ports"
    vpc_id      = aws_vpc.IacVPC.id
    
    ingress {
        from_port   = "80"
        to_port     = "80"
        protocol    = "tcp"
        security_groups = [aws_security_group.ec2_sg_jumpserver.id]
        description = "Allow web traffic from Jumpserver"
    }
    ingress {
        from_port   = "22"
        to_port     = "22"
        protocol    = "tcp"
        security_groups = [aws_security_group.ec2_sg_jumpserver.id]
        description = "Allow SSH traffic from Jumpserver"
    }
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags        = { Name = "${var.ec2_name_appserver}-SG" }
}
