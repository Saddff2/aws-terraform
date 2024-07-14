
provider "aws" {
  region = "eu-west-3"
}

resource "aws_vpc" "example_vpc" {
  cidr_block = "10.10.0.0/16"

}

resource "aws_subnet" "example_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.10.0.0/24"
}

resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id
}

resource "aws_route_table" "example_rt" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }
}

resource "aws_network_interface" "example_nic" {
  count     = 2
  subnet_id = aws_subnet.example_subnet.id
}

resource "aws_route_table_association" "example_rta" {
  route_table_id = aws_route_table.example_rt.id
  subnet_id      = aws_subnet.example_subnet.id
}

resource "aws_security_group" "example_sg" {
  name   = "example-security-group"
  vpc_id = aws_vpc.example_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example_vm" {
  count                       = 2
  ami                         = "ami-00ac45f3035ff009e"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.example_subnet.id
  security_groups             = [aws_security_group.example_sg.id]
  associate_public_ip_address = true
  tags = {
    name = "example_vm${count.index + 1}"
  }
}
