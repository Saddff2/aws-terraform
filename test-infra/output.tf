
output "vpc_id" {
  value = aws_vpc.example_vpc.id
}

output "subnet_id" {
  value = aws_subnet.public_subnet_example.id
}

output "security_group_id" {
  value = aws_security_group.sg_example_001.id
}

output "instance_ids" {
  value = aws_instance.example_vm[*].id
}

output "instance_public_ips" {
  value = aws_instance.example_vm[*].public_ip
}

output "instance_private_ips" {
  value = aws_instance.example_vm[*].private_ip
}
