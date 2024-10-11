provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "ubuntu-server" {
  ami = "ami-0dee22c13ea7a9a67"
  instance_type = "t2.micro"
  tags = {
    Name = "Ubuntu Server"
  }
  availability_zone = "ap-south-1b"
  key_name = "main-key"
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }
  user_data = <<-EOF
            #!/bin/bash
            sudo apt update -y
            sudo apt install apache2 -y
            sudo systemctl start apache2
            sudo bash -c 'echo HelloWorld > /var/www/html/index.html'
            EOF      
}
resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "Production"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id
}
resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id
  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.gw.id
  }
  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "Prod"
  }
}
resource "aws_subnet" "subnet-1" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1b"
    tags = {
        Name = "prod-subnet"
    }
}
resource "aws_route_table_association" "a" {
  subnet_id = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id
}
resource "aws_security_group" "allow_web" {
  name = "allow_web_traffic"
  description = "allow web traffic"
  vpc_id = aws_vpc.prod-vpc.id
  ingress = {
    description = "SSH traffic"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress = {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow web"
  }
}
resource "aws_security_group" "allow_web2" {
  name = "allow_web_traffic"
  description = "allow web traffic"
  vpc_id = aws_vpc.prod-vpc.id
  ingress = {
    description = "HTTP traffic"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress = {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow web"
  }
}
resource "aws_network_interface" "web-server-nic" {
  subnet_id = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id, aws_security_group.allow_web2]
}
resource "aws_eip" "one" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [ aws_internet_gateway.gw ]
}