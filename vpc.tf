#terraform code to deploy VPC in AWS

data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_vpc" "IacVPC" {
    cidr_block = "${var.vpc_cidr_block}"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "${var.vpc_name}"
    }
}

resource "aws_subnet" "IacVPC_PublicSubnet1" {
    cidr_block = "${var.PublicSubnet1_cidr_block}"
    map_public_ip_on_launch = true
    vpc_id = aws_vpc.IacVPC.id
    availability_zone = data.aws_availability_zones.available.names[0]

    tags = {
        Name = "${var.vpc_name}-PublicSubnet1"
    }
}

resource "aws_subnet" "IacVPC_PublicSubnet2" {
    cidr_block = "${var.PublicSubnet2_cidr_block}"
    map_public_ip_on_launch = true
    vpc_id = aws_vpc.IacVPC.id
    availability_zone = data.aws_availability_zones.available.names[1]

    tags = {
        Name = "${var.vpc_name}-PublicSubnet2"
    }
}

resource "aws_subnet" "IacVPC_AppSubnet1" {
    cidr_block = "${var.AppSubnet1_cidr_block}"
    map_public_ip_on_launch = true
    vpc_id = aws_vpc.IacVPC.id
    availability_zone = data.aws_availability_zones.available.names[0]

    tags = {
        Name = "${var.vpc_name}-AppSubnet1"
    }
}

resource "aws_subnet" "IacVPC_AppSubnet2" {
    cidr_block = "${var.AppSubnet2_cidr_block}"
    map_public_ip_on_launch = true
    vpc_id = aws_vpc.IacVPC.id
    availability_zone = data.aws_availability_zones.available.names[1]

    tags = {
        Name = "${var.vpc_name}-AppSubnet2"
    }
}

resource "aws_subnet" "IacVPC_DBSubnet1" {
    cidr_block = "${var.DBSubnet1_cidr_block}"
    map_public_ip_on_launch = true
    vpc_id = aws_vpc.IacVPC.id
    availability_zone = data.aws_availability_zones.available.names[0]

    tags = {
        Name = "${var.vpc_name}-DBSubnet1"
    }
}

resource "aws_subnet" "IacVPC_DBSubnet2" {
    cidr_block = "${var.DBSubnet2_cidr_block}"
    map_public_ip_on_launch = true
    vpc_id = aws_vpc.IacVPC.id
    availability_zone = data.aws_availability_zones.available.names[1]

    tags = {
        Name = "${var.vpc_name}-DBSubnet2"
    }
}

resource "aws_internet_gateway" "IacIGW" {
    vpc_id = aws_vpc.IacVPC.id
}

resource "aws_route_table" "RouteTablePublic" {
    vpc_id = aws_vpc.IacVPC.id
    depends_on = [ aws_internet_gateway.IacIGW ]
    tags = {
        Name = "${var.vpc_name}-public-route-table"
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IacIGW.id
    }
}

resource "aws_route_table_association" "AssociationForRouteTablePublic0" {
    subnet_id = aws_subnet.IacVPC_PublicSubnet1.id
    route_table_id = aws_route_table.RouteTablePublic.id
}

resource "aws_route_table_association" "AssociationForRouteTablePublic1" {
    subnet_id = aws_subnet.IacVPC_PublicSubnet2.id
    route_table_id = aws_route_table.RouteTablePublic.id
}

resource "aws_eip" "EIPNAT1" {
    tags = {
        Name = "${var.vpc_name}-EIP-NAT1"
    }
}

resource "aws_eip" "EIPNAT2" {
    tags = {
        Name = "${var.vpc_name}-EIP-NAT2"
    }
}

resource "aws_nat_gateway" "NATGW1" {
    subnet_id = aws_subnet.IacVPC_PublicSubnet1.id
    connectivity_type = "public"
    allocation_id = aws_eip.EIPNAT1.id
    tags = {
        Name = "NATGW1"
    }
}

resource "aws_nat_gateway" "NATGW2" {
    subnet_id = aws_subnet.IacVPC_PublicSubnet2.id
    connectivity_type = "public"
    allocation_id = aws_eip.EIPNAT2.id
    tags = {
        Name = "NATGW2"
    }
}

resource "aws_route_table" "RouteTablePrivate1" {
    vpc_id = aws_vpc.IacVPC.id
    depends_on = [ aws_nat_gateway.NATGW1 ]
    tags = {
        Name = "${var.vpc_name}-private-route-table-1"
    }
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.NATGW1.id
    }
}

resource "aws_route_table_association" "AssociationForRouteTablePrivate1a" {
    subnet_id = aws_subnet.IacVPC_AppSubnet1.id
    route_table_id = aws_route_table.RouteTablePrivate1.id
}

resource "aws_route_table_association" "AssociationForRouteTablePrivate1b" {
    subnet_id = aws_subnet.IacVPC_DBSubnet1.id
    route_table_id = aws_route_table.RouteTablePrivate1.id
}

resource "aws_route_table" "RouteTablePrivate2" {
    vpc_id = aws_vpc.IacVPC.id
    depends_on = [ aws_nat_gateway.NATGW2 ]
    tags = {
        Name = "${var.vpc_name}-private-route-table-2"
    }
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.NATGW2.id
    }
}

resource "aws_route_table_association" "AssociationForRouteTablePrivate2a" {
    subnet_id = aws_subnet.IacVPC_AppSubnet2.id
    route_table_id = aws_route_table.RouteTablePrivate2.id
}

resource "aws_route_table_association" "AssociationForRouteTablePrivate2b" {
    subnet_id = aws_subnet.IacVPC_DBSubnet2.id
    route_table_id = aws_route_table.RouteTablePrivate2.id
}