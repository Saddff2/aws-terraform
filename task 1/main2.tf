/*
provider "aws" {
  region = "europe-west-3"
}

resource "aws_vpc" "example_vpc" {
  cidr_block = "10.10.0.0/16"
}

resource "aws_subnet" "example_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.10.1.0/24"

}



resource "aws_eip" "example_ip" {
  instance = aws_lb.example_lb.id
}

resource "aws_lb" "example_lb" {
  subnets = [aws_subnet.example_subnet.id]
  load_balancer_type = "application"
  enable_deletion_protection = true

  
}
*/
