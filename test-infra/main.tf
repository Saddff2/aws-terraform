provider "aws" {
  region = "eu-west-3"
}

resource "aws_vpc" "example_vpc" {
  cidr_block = "10.10.0.0/16"
}

resource "aws_subnet" "public_subnet_example" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.10.2.0/24"
  availability_zone = "eu-west-3a"
}


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}


resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet_example.id
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id
}


resource "aws_security_group" "sg_example_001" {
  name   = "sg_example_001"
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
}

resource "aws_instance" "example_vm" {
  count                       = 2
  ami                         = "ami-00ac45f3035ff009e"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_example.id
  security_groups             = [aws_security_group.sg_example_001.id]
  key_name                    = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true

  tags = {
    Owner  = "Daniel Tsoref"
    OS     = "Ubuntu 24.04"
    Region = "Paris"
  }
}

resource "aws_key_pair" "generated_key" {
  key_name   = "deployer-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGW2HlgAv0fndNVlR3vMju3aOBYDEBocD1cDVzHFmmQ1 saddff@MacBook-Air-Daniel.local"
}

