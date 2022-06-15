provider "aws" {
  region = "ap-south-1"
}
resource "aws_instance" "web" {
    ami = "ami-00aa9fef649878d44"
    instance_type = "t2.micro"
    key_name = "Gen"
    tags = {
        Name = "web1"
    }
}
resource "aws_vpc" "vpc1" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    tags = {
        Name = "vpc-1"
    }
}
resource "aws_internet_gateway" "gw1" {
    vpc_id = "vpc-0a9c514102dc284be"
    tags = {
        Name = "Ig-1"
    }
}
resource "aws_route_table" "route1" {
    vpc_id = "vpc-0a9c514102dc284be"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw1.id
    }
    route {
        ipv6_cidr_block = "::/0"
        gateway_id = aws_internet_gateway.gw1.id
    }
    tags = {
        Name = "rt-1"
    }
}
resource "aws_subnet" "sub1" {
    vpc_id = "vpc-0a9c514102dc284be"
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-south-1a"
    tags = {
        Name = "sub-1"
    }
}
resource "aws_route_table_association" "rt-sub" {
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.route1.id
}
resource "aws_security_group" "sg1" {
    name = "allow-sg1"
    description = "allow-sg1-traffic"
    vpc_id = "vpc-0a9c514102dc284be"

    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["152.57.199.149/32"]
    }
    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol ="tcp"
        cidr_blocks = ["152.57.199.149/32"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "sg-1"
    }
}
resource "aws_network_interface" "ni1" {
    subnet_id       = aws_subnet.sub1.id
    private_ips     = ["10.0.0.50"]
    security_groups = [aws_security_group.sg1.id]
}
resource "aws_instance" "prac" {
    ami = "ami-00aa9fef649878d44"
    instance_type = "t2.micro"
    availability_zone = "ap-south-1a"
    key_name = "Gen" 
    tags = {
        Name = "prac1"
    }
}
