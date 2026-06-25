output "vpc_id" {
  value = aws_vpc.VPC_OBG.id
}

output "subnet_publica1_id" {
  value = aws_subnet.VPC_subnet_publica1.id
}

output "subnet_publica2_id" {
  value = aws_subnet.VPC_subnet_publica2.id
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

output "target_group_arn" {
  value = aws_lb_target_group.target_group.arn
}

output "lb_dns_name" {
  value = aws_lb.lb.dns_name
}