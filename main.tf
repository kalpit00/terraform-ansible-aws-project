provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "ubuntu-server" {
  ami = "ami-0dee22c13ea7a9a67"
  instance_type = "t2.micro"
  tags = {
    Name = "Ubuntu Server"
  }
}
resource "aws_vpc" "prod-vpc" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    Name = "Production"
  }
}