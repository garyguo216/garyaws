#terraform code to deploy server on EC2 in AWS

data "aws_ami" "aws_jumpserver_ami" {
    owners           = ["679593333241"]
    most_recent      = true
    filter {
        name = "name"
        values = ["CentOS-7*x86_64*"]
    }
}

#Create EC2
resource "aws_instance" "ec2_jumpserver" {
    ami                     = data.aws_ami.aws_jumpserver_ami.id
    instance_type           = "${var.ec2_type_jumpserver}"
    iam_instance_profile    = "${var.iam_instance_profile_jumpserver}"
    key_name                = "${var.ec2_key_name_jumpserver}"
    monitoring              = false
    network_interface {
        network_interface_id = aws_network_interface.ec2_interface_jumpserver.id
        device_index         = 0
    }
    root_block_device {
        delete_on_termination   = "${var.delete_volumes_on_termination_jumpserver}"
        encrypted               = false
        volume_size             = "${var.root_block_device_volume_size_jumpserver}"
        volume_type             = "${var.root_block_device_volume_type_jumpserver}"
    }
    tags        = { Name = var.ec2_name_jumpserver }
    volume_tags = { Name = "${var.ec2_name_jumpserver}_Disk"}
}

resource "aws_network_interface" "ec2_interface_jumpserver" {
    subnet_id         = aws_subnet.IacVPC_PublicSubnet1.id
    source_dest_check = false
    security_groups   = [aws_security_group.ec2_sg_jumpserver.id]
}

resource "aws_security_group" "ec2_sg_jumpserver" {
    name        = "${var.ec2_name_jumpserver}-sg"
    description = "A security group that allows inbound SSH and XRDP ports"
    vpc_id      = aws_vpc.IacVPC.id
    
    ingress {
        from_port   = "22"
        to_port     = "22"
        protocol    = "tcp"
        cidr_blocks = "${var.sg_ip_address_range_jumpserver}"
        description = "Allow SSH traffic"
    }

    ingress {
        from_port   = "1194"
        to_port     = "1194"
        protocol    = "udp"
        cidr_blocks = "${var.sg_ip_address_range_jumpserver}"
        description = "Allow XRDP traffic"
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags  = { Name = "${var.ec2_name_jumpserver}-sg" }
}
