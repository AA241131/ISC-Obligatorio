output "instance_id" {
    value = aws_instance.module-instance-deploy.id
}

output "dns" {
  value = aws_instance.module-instance-deploy.public_dns
}