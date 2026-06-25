output "vpc_id" {
  value = aws_vpc.VPC_OBG.id
}

output "subnet_publica_id" {
  value = aws_subnet.VPC_subnet_publica.id
}

output "subnet_privada1_id" {
  value = aws_subnet.VPC_subnet_privada1.id
}

output "subnet_privada2_id" {
  value = aws_subnet.VPC_subnet_privada2.id
}

output "vpc_cidr_block" {
  value = aws_vpc.VPC_OBG.cidr_block
}