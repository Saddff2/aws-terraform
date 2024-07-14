provider "aws" {
  region = "il-central-1"
}


resource "aws_instance" "web_app_1" {
  ami           = "ami-04a4b28d712600827"
  instance_type = "t3.micro"
  tags = {
    owner  = "Daniel Tsoref"
    region = "tel-aviv"
    hello  = "world"
  }
}

output "public_dns" {
  value = aws_instance.web_app_1.public_dns
}

locals {
  init_sh = "echo hello world"
}

