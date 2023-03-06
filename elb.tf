#terraform code to deploy ELB in AWS

#create RDS instance
resource "aws_lb" "aws_alb" {
    name               = var.load_balancer_name
    internal           = var.internal_load_balancer
    load_balancer_type = var.load_balancer_type
    security_groups    = [aws_security_group.elb_sg.id]
    subnets            = [aws_subnet.IacVPC_PublicSubnet1.id,aws_subnet.IacVPC_PublicSubnet2.id]
    enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
    tags = {
        Name =  var.load_balancer_name
    }
}

resource "aws_lb_listener" "aws_alb_listener" {
    load_balancer_arn = aws_lb.aws_alb.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.elb_target_group.arn
    }
}

resource "aws_lb_target_group" "elb_target_group" {
    name             = "${var.load_balancer_name}-target-group"
    vpc_id           = aws_vpc.IacVPC.id
    port             = "80"
    protocol         = "HTTP"
    target_type      = "instance"
   
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_lb_target_group_attachment" "ec2_appserver_1" {
    target_group_arn = aws_lb_target_group.elb_target_group.arn
    target_id        = aws_instance.ec2_appserver_1.id
    port             = 80
}

resource "aws_lb_target_group_attachment" "ec2_appserver_2" {
    target_group_arn = aws_lb_target_group.elb_target_group.arn
    target_id        = aws_instance.ec2_appserver_2.id
    port             = 80
}

resource "aws_security_group" "elb_sg" {
    name        = "${var.load_balancer_name}-sg"
    description = "A security group that allows inbound web ports"
    vpc_id      = aws_vpc.IacVPC.id
    ingress {
        from_port   = "80"
        to_port     = "80"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow web traffic"
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {Name = "${var.load_balancer_name}-SG" }
}

resource "aws_security_group_rule" "application" {
    type              = "ingress"
    from_port         = "80"
    to_port           = "80"
    protocol          = "tcp"
    security_group_id = aws_security_group.ec2_sg_appserver.id
	source_security_group_id = aws_security_group.elb_sg.id
}